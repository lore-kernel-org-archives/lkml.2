Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3ACKLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:11:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18090 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3ACKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:49 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-bf-50e559263b9f
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:19 +0100
Message-id: <1357207825-10485-3-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJMWRmVeSWpSXmKPExsVy+t/xy7pqkU8DDN5Pl7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZPZ+vMRec0az4f/IjYwPjJaUuRk4OCQETiXPrNjJC2GISF+6t
	Z+ti5OIQEljKKLH2YReUs4FJ4snumcwgVWwCxhJ7D3aAdYgIKEhs7n3GClLELLCeUWLi/Qaw
	hDDQ2OktL1m6GDk4WARUJa6cVgEJ8wq4Smy5940VYpu8xNP7fWwgNqeAm8SXO43sILYQUM38
	LY9ZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kR4vOvOxiXHrM6xCjAwajEw8tY
	/yRAiDWxrLgy9xCjBAezkgjv9RygEG9KYmVValF+fFFpTmrxIUYmDk6pBsapmtwCU+IfPQgM
	Zix+pzpr7v5e771TldTDXn7+8MVwQ37MXF6O8v6NMn/mLMv1zj1bvbH137kQhln/9n+POPdQ
	2ZLrQla7r5ZQ1omnN3bXb1xy7yaXgWvwuiddlcVT7ib1bjsaUrhsq4Ham4IVRdfWb2W07w49
	ckr/y7Eb+gZ+F1cvvTrHWyVCiaU4I9FQi7moOBEAWjFVQ9cBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/configfs/configfs_internal.h |   54 +++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index b5f0a3b..4ef5d4d 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -34,11 +34,11 @@ struct configfs_dirent {
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	struct list_head	s_links;
-	void			* s_element;
+	void			*s_element;
 	int			s_type;
 	umode_t			s_mode;
-	struct dentry		* s_dentry;
-	struct iattr		* s_iattr;
+	struct dentry		*s_dentry;
+	struct iattr		*s_iattr;
 #ifdef CONFIG_LOCKDEP
 	int			s_depth;
 #endif
@@ -62,21 +62,26 @@ extern struct kmem_cache *configfs_dir_cachep;
 
 extern int configfs_is_root(struct config_item *item);
 
-extern struct inode * configfs_new_inode(umode_t mode, struct configfs_dirent *, struct super_block *);
-extern int configfs_create(struct dentry *, umode_t mode, int (*init)(struct inode *));
+extern struct inode *configfs_new_inode(umode_t mode, struct configfs_dirent *,
+					struct super_block *);
+extern int configfs_create(struct dentry *, umode_t mode,
+			   int (*init)(struct inode *));
 extern int configfs_inode_init(void);
 extern void configfs_inode_exit(void);
 
-extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
+extern int configfs_create_file(struct config_item *,
+				const struct configfs_attribute *);
 extern int configfs_make_dirent(struct configfs_dirent *,
 				struct dentry *, void *, umode_t, int);
 extern int configfs_dirent_is_ready(struct configfs_dirent *);
 
-extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
-extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
+extern int configfs_add_file(struct dentry *,
+			     const struct configfs_attribute *, int);
+extern void configfs_hash_and_remove(struct dentry *dir, const char *name);
 
-extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
-extern void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent);
+extern const unsigned char *configfs_get_name(struct configfs_dirent *sd);
+extern void configfs_drop_dentry(struct configfs_dirent *sd,
+				 struct dentry *parent);
 extern int configfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern struct dentry *configfs_pin_fs(void);
@@ -104,27 +109,28 @@ extern int configfs_create_link(struct configfs_symlink *sl,
 				struct dentry *parent,
 				struct dentry *dentry);
 
-static inline struct config_item * to_item(struct dentry * dentry)
+static inline struct config_item *to_item(struct dentry *dentry)
 {
-	struct configfs_dirent * sd = dentry->d_fsdata;
-	return ((struct config_item *) sd->s_element);
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	return (struct config_item *) sd->s_element;
 }
 
-static inline struct configfs_attribute * to_attr(struct dentry * dentry)
+static inline struct configfs_attribute *to_attr(struct dentry *dentry)
 {
-	struct configfs_dirent * sd = dentry->d_fsdata;
-	return ((struct configfs_attribute *) sd->s_element);
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	return (struct configfs_attribute *) sd->s_element;
 }
 
-static inline struct config_item *configfs_get_config_item(struct dentry *dentry)
+static inline struct config_item
+*configfs_get_config_item(struct dentry *dentry)
 {
-	struct config_item * item = NULL;
+	struct config_item *item = NULL;
 
 	spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
-		struct configfs_dirent * sd = dentry->d_fsdata;
+		struct configfs_dirent *sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
-			struct configfs_symlink * sl = sd->s_element;
+			struct configfs_symlink *sl = sd->s_element;
 			item = config_item_get(sl->sl_target);
 		} else
 			item = config_item_get(sd->s_element);
@@ -134,7 +140,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 	return item;
 }
 
-static inline void release_configfs_dirent(struct configfs_dirent * sd)
+static inline void release_configfs_dirent(struct configfs_dirent *sd)
 {
 	if (!(sd->s_type & CONFIGFS_ROOT)) {
 		kfree(sd->s_iattr);
@@ -142,7 +148,7 @@ static inline void release_configfs_dirent(struct configfs_dirent * sd)
 	}
 }
 
-static inline struct configfs_dirent * configfs_get(struct configfs_dirent * sd)
+static inline struct configfs_dirent *configfs_get(struct configfs_dirent *sd)
 {
 	if (sd) {
 		WARN_ON(!atomic_read(&sd->s_count));
@@ -151,7 +157,7 @@ static inline struct configfs_dirent * configfs_get(struct configfs_dirent * sd)
 	return sd;
 }
 
-static inline void configfs_put(struct configfs_dirent * sd)
+static inline void configfs_put(struct configfs_dirent *sd)
 {
 	WARN_ON(!atomic_read(&sd->s_count));
 	if (atomic_dec_and_test(&sd->s_count))
-- 
1.7.0.4

