//
//  CHPulseButton.swift
//  Pods
//
//  Created by Charles HARROCH on 25/05/2016.
//
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable open class CHPulseButton: UIButton {
    
    var pulseView = UIView()
    var button = UIButton()
    var pulseImageView = UIImageView()
    
    open var isAnimating = false
    
    lazy private var pulseAnimation : CABasicAnimation = self.initAnimation()
    
    // MARK: Inspectable properties
    
    @IBInspectable open var contentImageScale : Int = 0 {
        didSet {
            guard let contentMode = UIView.ContentMode(rawValue: contentImageScale) else { return }
            pulseImageView.contentMode = contentMode
        }
    }
    
    @IBInspectable open var image: UIImage? {
        get {
            return pulseImageView.image
        }
        set(image) {
            pulseImageView.image = image
        }
    }
    
    @IBInspectable open var pulseMargin: CGFloat = 5.0
    
    @IBInspectable open var pulseBackgroundColor: UIColor = .lightGray {
        didSet {
            pulseView.backgroundColor = pulseBackgroundColor
        }
    }
    
    @IBInspectable open var buttonBackgroundColor: UIColor = .blue {
        didSet {
            button.backgroundColor = buttonBackgroundColor
        }
    }
    
    @IBInspectable open var titleColor: UIColor = .blue {
        didSet {
            button.setTitleColor(titleColor, for: [])
        }
    }
    
    @IBInspectable open var title: String? {
        didSet {
            button.setTitle(title, for: [])
        }
    }
    
    @IBInspectable open var pulsePercent: Float = 120
    @IBInspectable open var pulseAlpha: Float = 1.0 {
        didSet {
            pulseView.alpha = CGFloat(pulseAlpha)
        }
    }
    
    @IBInspectable open var isCircle: Bool = false
    
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            if isCircle == true {
                cornerRadius = 0
            } else {
                button.layer.cornerRadius = cornerRadius - pulseMargin
                pulseImageView.layer.cornerRadius = cornerRadius - pulseMargin
                pulseView.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    // MARK: Initialization
    
    func initAnimation() -> CABasicAnimation {
        let anim  = CABasicAnimation(keyPath: "transform.scale")
        anim.duration = 1
        anim.fromValue = 1
        anim.toValue = 1 * (pulsePercent / 100)
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.autoreverses = true
        anim.repeatCount = FLT_MAX
        return anim
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setup()
        
        if isCircle {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            pulseView.layer.cornerRadius = 0.5 * pulseView.bounds.size.width
            pulseImageView.layer.cornerRadius = 0.5 * pulseImageView.bounds.size.width
            
            button.clipsToBounds = true
            pulseView.clipsToBounds = true
            pulseImageView.clipsToBounds = true
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        
        pulseView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        addSubview(pulseView)
        
        button.frame = CGRect(x: pulseMargin/2, y: pulseMargin/2, width: bounds.size.width - pulseMargin, height: bounds.size.height - pulseMargin)
        addSubview(button)
        
        pulseImageView.frame = CGRect(x: pulseMargin/2, y: pulseMargin/2, width: bounds.size.width - pulseMargin, height: bounds.size.height - pulseMargin)
        addSubview(pulseImageView)
        
        for target in allTargets {
            let targetActions = actions(forTarget: target, forControlEvent: UIControl.Event.touchUpInside)
            for action in targetActions ?? [] {
                button.addTarget(target, action:Selector(stringLiteral: action), for: UIControl.Event.touchUpInside)
            }
        }
    }
    
    open func animate(animate : Bool) {
        if animate {
            self.pulseView.layer.add(pulseAnimation, forKey: nil)
        } else {
            self.pulseView.layer.removeAllAnimations()
        }
        isAnimating = animate
    }
}
