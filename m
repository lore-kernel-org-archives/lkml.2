Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab2JFIpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:45:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53965 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2JFIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:45:05 -0400
Message-ID: <506FEE02.3080706@gmail.com>
Date: Sat, 06 Oct 2012 10:38:26 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/22] vfs: drop vmtruncate
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
index ca6d8c8..b3d8fa3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1826,7 +1826,6 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
-	void (*truncate) (struct inode *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-- 
1.7.3.4
