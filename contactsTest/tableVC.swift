//
//  tableVC.swift
//  contactsTest
//
//  Created by 김민영 on 2020/06/15.
//  Copyright © 2020 KIMMINYOUNG. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class tableVC:UIViewController{
    
    @IBOutlet weak var sBar: UISearchBar!
    
    var list : [String] = ["abc", "bca","cab"]
    
//    var contacts = [tableCellVC]()
    var contacts: NSMutableArray = NSMutableArray()
    
    var contactsFamilyName : [String] = []
    var contactsGivenName : [String] = []
    var contactsPhoneNumber : [String] = []
    
    @IBOutlet weak var tv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sBar.delegate = self
        
        tv.delegate=self
        tv.dataSource=self
        
        self.fetchContacts()
        
    }
    
    private func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (acccess, errors) in
            
            guard acccess else{
                print("Access denied")
                return
            }
            print("Access ok")
            
            let req : CNContactFetchRequest = self.getCNContactFetchRequest()
            
            req.sortOrder = CNContactSortOrder.userDefault
            
            try! store.enumerateContacts(with: req, usingBlock: { (contact, stop) in
                if contact.phoneNumbers.isEmpty{
                    return
                }
                
//                contact.phoneNumbers
                
//                CNLabeledValue(label: CNLabelPhoneNumberMobile, value: contact.phoneNumbers)
                
//                print((contact.phoneNumbers[0].value).value(forKey: "stringValue") as! String)
////                print((contact.phoneNumbers[0].value).value(forKey: "identifier") as! String)
//
//                print(contact.phoneNumbers[0].value)
//                print(contact.phoneNumbers)
                print(contact)
                print("================")
                print(contact.phoneNumbers[0].value)
                print("==================")
                print(contact.value(forKey: "identifier")!)
                
////                print("phone : \(CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringV)))")
//                print(contact.givenName)
//                print(contact.familyName)
                
                self.contacts.add(contact)
//                print((contact.phoneNumbers[0].value).value(forKey: "stringValue") as! String)
                //임시방편
                self.contactsFamilyName.append(contact.familyName)
                self.contactsGivenName.append(contact.givenName)
                self.contactsPhoneNumber.append((contact.phoneNumbers[0].value).value(forKey: "stringValue") as! String)
                
                
            })
        }
        
    }
    
      // Request 생성
        private func getCNContactFetchRequest() -> CNContactFetchRequest {
            // 주소록에서 읽어올 key 설정
            let keys: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                           CNContactPhoneNumbersKey,
                                           CNContactEmailAddressesKey,
                                           CNContactJobTitleKey,
                                           CNContactPostalAddressesKey] as! [CNKeyDescriptor]
            
            return CNContactFetchRequest(keysToFetch: keys)
        }
    
}

extension tableVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("==> \(String(describing:searchBar.text))" )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension tableVC:UITableViewDelegate{
    
}

extension tableVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    // 몇 개의 행을 만들지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//        return 0
        print("contacts count : \(contacts.count)")
        return contacts.count
    }
    
    // cellForRowAt
    // 행의 내용 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellVC", for: indexPath) as! tableCellVC
        
//        cell.name = ~~~[indexPath.row]
//        cell.phone = ~~~[indexPath.row]
        
        cell.name.text = contactsFamilyName[indexPath.row]
        cell.givenName.text = contactsGivenName[indexPath.row]
        cell.phone.text = contactsPhoneNumber[indexPath.row]
        
//        print("indexPath.row : \(contacts[indexPath.row] )")
        
        return cell
    
    }
    // heightForRowAt
    // 행 높이 결정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // didSelectRowAt
    // 특정 행 선택시 로직 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // canEditRowAt
    // 편집기능 부여 여부
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
