//
//  InsertProcess.swift
//  Caffeine
//
//  Created by hyogang on 2021/08/22.
//

import Foundation
import SQLite3

class InsertModel{
    
    var db: OpaquePointer?

    func loadData(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Caffeine.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS caffeine(no INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, mg INTEGER, name TEXT, memo TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func insertValues(name: String, mg: Int, memo: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: Date())
        let date = currentDate
        
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        // Query
        let queryString = "INSERT INTO caffeine(date, mg, name, memo) VALUES (?,?,?,?)"
            
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            return
        }
        
        if sqlite3_bind_text(stmt, 1, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            return
        }
        if sqlite3_bind_int(stmt!, 2, Int32(mg)) != SQLITE_OK{
            return
        }
        if sqlite3_bind_text(stmt, 3, name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            return
        }
        if sqlite3_bind_text(stmt, 4, memo, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            return
        }
        
        // stmp 실행
        if sqlite3_step(stmt) != SQLITE_DONE{
            return
        }

    }
}
