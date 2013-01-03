Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3ACKLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:11:11 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65502 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3ACKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:49 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-80-50e55927d33a
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:22 +0100
Message-id: <1357207825-10485-6-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xy7rqkU8DDBZPUbW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZe5a1MRU81Kq4sXoWYwPjO6UuRk4OCQETiQObLjJD2GISF+6t
	Z+ti5OIQEljKKHHl6kZmCGcDk8SpSS9YQarYBIwl9h7sYASxRQQUJDb3PmMFKWIWWM8oMfF+
	A1hCGGjssY42sLEsAqoSW2++ZwGxeQVcJb5v7GOCWCcv8fR+HxuIzSngJvHlTiM7iC0EVDN/
	y2OWCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEeP3LDsbFx6wOMQpwMCrx8K6o
	eRIgxJpYVlyZe4hRgoNZSYT3eg5QiDclsbIqtSg/vqg0J7X4ECMTB6dUAyO3afdUY0fffYWs
	Qmu09nZGrZm4dduqNNfw/cVforfuzZI/vcj3snXAG9Zf8x+vX3ferzetxyxLRCjK68+BqRVr
	1/RXqKenOU9+x92wX7bzSG3gtsfl8yZPnrds/f8fnM2nbra91YmruPxx6tyDsq//db8RYtkl
	+tlAMV5s35ndqetudqzgn+2uxFKckWioxVxUnAgA0epLVtgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/configfs/inode.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index a9d35b0..087fc73 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
@@ -56,15 +56,15 @@ static struct backing_dev_info configfs_backing_dev_info = {
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
-static const struct inode_operations configfs_inode_operations ={
+static const struct inode_operations configfs_inode_operations = {
 	.setattr	= configfs_setattr,
 };
 
-int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
+int configfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
-	struct inode * inode = dentry->d_inode;
-	struct configfs_dirent * sd = dentry->d_fsdata;
-	struct iattr * sd_iattr;
+	struct inode *inode = dentry->d_inode;
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	struct iattr *sd_iattr;
 	unsigned int ia_valid = iattr->ia_valid;
 	int error;
 
@@ -81,7 +81,8 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		sd_iattr->ia_mode = sd->s_mode;
 		sd_iattr->ia_uid = GLOBAL_ROOT_UID;
 		sd_iattr->ia_gid = GLOBAL_ROOT_GID;
-		sd_iattr->ia_atime = sd_iattr->ia_mtime = sd_iattr->ia_ctime = CURRENT_TIME;
+		sd_iattr->ia_atime = sd_iattr->ia_mtime = sd_iattr->ia_ctime =
+			CURRENT_TIME;
 		sd->s_iattr = sd_iattr;
 	}
 	/* attributes were changed atleast once in past */
@@ -114,13 +115,13 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	return error;
 }
 
-static inline void set_default_inode_attr(struct inode * inode, umode_t mode)
+static inline void set_default_inode_attr(struct inode *inode, umode_t mode)
 {
 	inode->i_mode = mode;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 }
 
-static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
+static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 {
 	inode->i_mode = iattr->ia_mode;
 	inode->i_uid = iattr->ia_uid;
@@ -133,7 +134,7 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
 struct inode *configfs_new_inode(umode_t mode, struct configfs_dirent *sd,
 				 struct super_block *s)
 {
-	struct inode * inode = new_inode(s);
+	struct inode *inode = new_inode(s);
 	if (inode) {
 		inode->i_ino = get_next_ino();
 		inode->i_mapping->a_ops = &configfs_aops;
@@ -154,6 +155,8 @@ struct inode *configfs_new_inode(umode_t mode, struct configfs_dirent *sd,
 
 #ifdef CONFIG_LOCKDEP
 
+static char *lockdep_msg =
+"configfs: Too many levels of inodes for the locking correctness validator.\n";
 static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
 					  struct inode *inode)
 {
@@ -168,9 +171,8 @@ static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
 			 * In practice the maximum level of locking depth is
 			 * already reached. Just inform about possible reasons.
 			 */
-			printk(KERN_INFO "configfs: Too many levels of inodes"
-			       " for the locking correctness validator.\n");
-			printk(KERN_INFO "Spurious warnings may appear.\n");
+			pr_info(lockdep_msg);
+			pr_info("Spurious warnings may appear.\n");
 		}
 	}
 }
@@ -184,7 +186,8 @@ static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
 
 #endif /* CONFIG_LOCKDEP */
 
-int configfs_create(struct dentry * dentry, umode_t mode, int (*init)(struct inode *))
+int configfs_create(struct dentry *dentry, umode_t mode,
+		    int (*init)(struct inode *))
 {
 	int error = 0;
 	struct inode *inode = NULL;
@@ -220,9 +223,10 @@ int configfs_create(struct dentry * dentry, umode_t mode, int (*init)(struct ino
 }
 
 /*
- * Get the name for corresponding element represented by the given configfs_dirent
+ * Get the name for corresponding element represented by the given
+ * configfs_dirent
  */
-const unsigned char * configfs_get_name(struct configfs_dirent *sd)
+const unsigned char *configfs_get_name(struct configfs_dirent *sd)
 {
 	struct configfs_attribute *attr;
 
@@ -244,9 +248,9 @@ const unsigned char * configfs_get_name(struct configfs_dirent *sd)
  * Unhashes the dentry corresponding to given configfs_dirent
  * Called with parent inode's i_mutex held.
  */
-void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
+void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent)
 {
-	struct dentry * dentry = sd->s_dentry;
+	struct dentry *dentry = sd->s_dentry;
 
 	if (dentry) {
 		spin_lock(&dentry->d_lock);
@@ -260,10 +264,10 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 	}
 }
 
-void configfs_hash_and_remove(struct dentry * dir, const char * name)
+void configfs_hash_and_remove(struct dentry *dir, const char *name)
 {
-	struct configfs_dirent * sd;
-	struct configfs_dirent * parent_sd = dir->d_fsdata;
+	struct configfs_dirent *sd;
+	struct configfs_dirent *parent_sd = dir->d_fsdata;
 
 	if (dir->d_inode == NULL)
 		/* no inode means this hasn't been made visible yet */
-- 
1.7.0.4

