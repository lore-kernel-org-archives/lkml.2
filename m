Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2KCJib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:38:31 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36345 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2KCJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:38:29 -0400
Message-ID: <5094E489.2090207@gmail.com>
Date: Sat, 03 Nov 2012 10:31:53 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/21] vfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/libfs.c         |    2 --
 include/linux/fs.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 7cc37ca..c8fe267 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -369,8 +369,6 @@ int simple_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	WARN_ON_ONCE(inode->i_op->truncate);
-
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..131a101 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1565,7 +1565,6 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
-	void (*truncate) (struct inode *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-- 
1.7.3.4
