Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2HaOKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:10:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49486 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2HaOKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:10:06 -0400
Message-ID: <5040C431.4020509@gmail.com>
Date: Fri, 31 Aug 2012 16:03:29 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/21] vfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/libfs.c         |    2 --
 include/linux/fs.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index a74cb17..69cf30d 100644
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
index aa11047..419b25b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1822,7 +1822,6 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
-	void (*truncate) (struct inode *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-- 
1.7.3.4
