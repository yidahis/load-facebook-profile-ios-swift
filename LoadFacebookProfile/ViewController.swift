import UIKit
import LoadFacebookProfileKit

class ViewController: UIViewController {
  @IBOutlet weak var loginLogoutButton: UIButton!
  @IBOutlet weak var userInfoLabel: UILabel!
  
  private let loader: TegFacebookUserLoader
  
  required init(coder aDecoder: NSCoder) {
    loader = TegFacebookUserLoader()
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfoLabel.text = ""
  }
  
  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {
    userInfoLabel.text = ""
    
    loader.load(askEmail: true).onComplete { [weak self] result in
      switch result {
      case .Success(let boxedUser):
        self?.onUserLoaded(boxedUser.value)
      case .Failure(let boxedError):
        self?.userInfoLabel.text = boxedError.value.nsError.localizedDescription
      }
    }
  }
  
  private func onUserLoaded(user: TegFacebookUser) {
    var fields = ["User id: \(user.id)"]
    
    if let name = user.name {
      fields.append("Name: \(name)")
    }
    
    if let email = user.email {
      fields.append("Email: \(email)")
    }
    
    fields.append("Access token: \(user.accessToken)")
    
    let outputText = join("\n\n", fields)
    
    userInfoLabel.text = outputText
    println(outputText)
  }
}

