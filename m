Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2GYPKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:10:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:30025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452Ab2GYPKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267510"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 02/16] Documentation: get rid of write_super
Date: Wed, 25 Jul 2012 18:12:00 +0300
Message-Id: <1343229134-29487-3-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from various pieces of the kernel documentation.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 Documentation/DocBook/filesystems.tmpl |    4 ++--
 Documentation/filesystems/Locking      |    2 --
 Documentation/filesystems/porting      |    5 ++---
 Documentation/filesystems/vfs.txt      |    4 ----
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/filesystems.tmpl b/Documentation/DocBook/filesystems.tmpl
index 3fca32c..25b58ef 100644
--- a/Documentation/DocBook/filesystems.tmpl
+++ b/Documentation/DocBook/filesystems.tmpl
@@ -224,8 +224,8 @@ all your transactions.
 </para>
 
 <para>
-Then at umount time , in your put_super() (2.4) or write_super() (2.5)
-you can then call journal_destroy() to clean up your in-core journal object.
+Then at umount time , in your put_super() you can then call journal_destroy()
+to clean up your in-core journal object.
 </para>
 
 <para>
diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 8e2da1e..7feac7f 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -111,7 +111,6 @@ prototypes:
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
-	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
 	int (*freeze_fs) (struct super_block *);
 	int (*unfreeze_fs) (struct super_block *);
@@ -133,7 +132,6 @@ write_inode:
 drop_inode:				!!!inode->i_lock!!!
 evict_inode:
 put_super:		write
-write_super:		read
 sync_fs:		read
 freeze_fs:		read
 unfreeze_fs:		read
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 8c91d10..df6cfc0 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -94,9 +94,8 @@ protected.
 ---
 [mandatory]
 
-BKL is also moved from around sb operations.  ->write_super() Is now called 
-without BKL held.  BKL should have been shifted into individual fs sb_op
-functions.  If you don't need it, remove it.  
+BKL is also moved from around sb operations. BKL should have been shifted into
+individual fs sb_op functions.  If you don't need it, remove it.
 
 ---
 [informational]
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index efd23f4..f3e9242 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -216,7 +216,6 @@ struct super_operations {
         void (*drop_inode) (struct inode *);
         void (*delete_inode) (struct inode *);
         void (*put_super) (struct super_block *);
-        void (*write_super) (struct super_block *);
         int (*sync_fs)(struct super_block *sb, int wait);
         int (*freeze_fs) (struct super_block *);
         int (*unfreeze_fs) (struct super_block *);
@@ -273,9 +272,6 @@ or bottom half).
   put_super: called when the VFS wishes to free the superblock
 	(i.e. unmount). This is called with the superblock lock held
 
-  write_super: called when the VFS superblock needs to be written to
-	disc. This method is optional
-
   sync_fs: called when VFS is writing out all dirty data associated with
   	a superblock. The second parameter indicates whether the method
 	should wait until the write out has been completed. Optional.
-- 
1.7.10

