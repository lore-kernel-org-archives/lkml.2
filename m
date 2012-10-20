Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056Ab2JTMh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:37:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2JTMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:37:55 -0400
Message-ID: <50829995.4080006@gmail.com>
Date: Sat, 20 Oct 2012 14:31:17 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/21] Documentation: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco <marco.stornelli@gmail.com>
---
 Documentation/filesystems/Locking |    6 ------
 Documentation/filesystems/porting |    2 +-
 Documentation/filesystems/vfs.txt |   11 -----------
 3 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index e540a24..f48e0c6 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -80,7 +80,6 @@ rename:		yes (all)	(see below)
 readlink:	no
 follow_link:	no
 put_link:	no
-truncate:	yes		(see below)
 setattr:	yes
 permission:	no (may not block if called in rcu-walk mode)
 get_acl:	no
@@ -96,11 +95,6 @@ atomic_open:	yes
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
-	->truncate() is never called directly - it's a callback, not a
-method. It's called by vmtruncate() - deprecated library function used by
-->setattr(). Locking information above applies to that call (i.e. is
-inherited from ->setattr() - vmtruncate() is used when ATTR_SIZE had been
-passed).
 
 See Documentation/filesystems/directory-locking for more detailed discussion
 of the locking scheme for directory operations.
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 0742fee..0472c31 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -281,7 +281,7 @@ ext2_write_failed and callers for an example.
 
 [mandatory]
 
-	->truncate is going away.  The whole truncate sequence needs to be
+	->truncate is gone.  The whole truncate sequence needs to be
 implemented in ->setattr, which is now mandatory for filesystems
 implementing on-disk size changes.  Start with a copy of the old inode_setattr
 and vmtruncate, and the reorder the vmtruncate + foofs_vmtruncate sequence to
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 2ee133e..e386909 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -350,7 +350,6 @@ struct inode_operations {
 	int (*readlink) (struct dentry *, char __user *,int);
         void * (*follow_link) (struct dentry *, struct nameidata *);
         void (*put_link) (struct dentry *, struct nameidata *, void *);
-	void (*truncate) (struct inode *);
 	int (*permission) (struct inode *, int);
 	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
@@ -431,16 +430,6 @@ otherwise noted.
   	started might not be in the page cache at the end of the
   	walk).
 
-  truncate: Deprecated. This will not be called if ->setsize is defined.
-	Called by the VFS to change the size of a file.  The
- 	i_size field of the inode is set to the desired size by the
- 	VFS before this method is called.  This method is called by
- 	the truncate(2) system call and related functionality.
-
-	Note: ->truncate and vmtruncate are deprecated. Do not add new
-	instances/calls of these. Filesystems should be converted to do their
-	truncate sequence via ->setattr().
-
   permission: called by the VFS to check for access rights on a POSIX-like
   	filesystem.
 
-- 
1.7.3.4
