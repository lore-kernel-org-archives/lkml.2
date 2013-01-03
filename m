Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3ACKLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:11:03 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18090 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3ACKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:52 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-c6-50e55926e5a2
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:20 +0100
Message-id: <1357207825-10485-4-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xy7pqkU8DDBbcNLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZLVf7WAtWT2esOPdiBksDY0NlFyMnh4SAicTLvd1sELaYxIV7
	64FsLg4hgaWMEh/fnGCHcDYwSTzZPZMZpIpNwFhi78EORhBbREBBYnPvM1aQImaB9YwSE+83
	gCWEgca+nr0WbCyLgKrEyb537CA2r4CrxM6Vj1kh1slLPL3fB1bDKeAm8eVOI1iNEFDN/C2P
	WSYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJEeL3rzsYlx6zOsQowMGoxMPLWP8k
	QIg1say4MvcQowQHs5II7/UcoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGOr1g//Mpk9bO6Sq9
	wRAZqmwlvsftz+H5xzjUJnyousakINRr0nrjReV/k7D3wasFAjmcAz5Otlv8IySgV/yt66wm
	50a9DRsi+E+FvPo7X0/y98ptmb2tpRqi3q/3ZYVfs3hpEMHMszasqX9LUtEkhXkmy3cv0udL
	+73Ll7uVRXz/Ul0xsW4lluKMREMt5qLiRAADywdh2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conflicts:

	fs/configfs/dir.c
---
 fs/configfs/dir.c |  282 +++++++++++++++++++++++++++-------------------------
 1 files changed, 146 insertions(+), 136 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 712b10f..afa37d2 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -50,8 +50,8 @@ DECLARE_RWSEM(configfs_rename_sem);
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
 
-static void configfs_d_iput(struct dentry * dentry,
-			    struct inode * inode)
+static void configfs_d_iput(struct dentry *dentry,
+			    struct inode *inode)
 {
 	struct configfs_dirent *sd = dentry->d_fsdata;
 
@@ -170,10 +170,10 @@ configfs_adjust_dir_dirent_depth_after_populate(struct configfs_dirent *sd)
 /*
  * Allocates a new configfs_dirent and links it to the parent configfs_dirent
  */
-static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent *parent_sd,
-						   void *element, int type)
+static struct configfs_dirent
+*configfs_new_dirent(struct configfs_dirent *parent_sd, void *element, int type)
 {
-	struct configfs_dirent * sd;
+	struct configfs_dirent *sd;
 
 	sd = kmem_cache_zalloc(configfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
@@ -207,7 +207,7 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent *paren
 static int configfs_dirent_exists(struct configfs_dirent *parent_sd,
 				  const unsigned char *new)
 {
-	struct configfs_dirent * sd;
+	struct configfs_dirent *sd;
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_element) {
@@ -223,11 +223,11 @@ static int configfs_dirent_exists(struct configfs_dirent *parent_sd,
 }
 
 
-int configfs_make_dirent(struct configfs_dirent * parent_sd,
-			 struct dentry * dentry, void * element,
+int configfs_make_dirent(struct configfs_dirent *parent_sd,
+			 struct dentry *dentry, void *element,
 			 umode_t mode, int type)
 {
-	struct configfs_dirent * sd;
+	struct configfs_dirent *sd;
 
 	sd = configfs_new_dirent(parent_sd, element, type);
 	if (IS_ERR(sd))
@@ -241,7 +241,7 @@ int configfs_make_dirent(struct configfs_dirent * parent_sd,
 	return 0;
 }
 
-static int init_dir(struct inode * inode)
+static int init_dir(struct inode *inode)
 {
 	inode->i_op = &configfs_dir_inode_operations;
 	inode->i_fop = &configfs_dir_operations;
@@ -251,14 +251,14 @@ static int init_dir(struct inode * inode)
 	return 0;
 }
 
-static int configfs_init_file(struct inode * inode)
+static int configfs_init_file(struct inode *inode)
 {
 	inode->i_size = PAGE_SIZE;
 	inode->i_fop = &configfs_file_operations;
 	return 0;
 }
 
-static int init_symlink(struct inode * inode)
+static int init_symlink(struct inode *inode)
 {
 	inode->i_op = &configfs_symlink_inode_operations;
 	return 0;
@@ -267,7 +267,7 @@ static int init_symlink(struct inode * inode)
 static int create_dir(struct config_item *k, struct dentry *d)
 {
 	int error;
-	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
+	umode_t mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	struct dentry *p = d->d_parent;
 
 	BUG_ON(!k);
@@ -275,7 +275,8 @@ static int create_dir(struct config_item *k, struct dentry *d)
 	error = configfs_dirent_exists(p->d_fsdata, d->d_name.name);
 	if (!error)
 		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
-					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
+					     CONFIGFS_DIR |
+					     CONFIGFS_USET_CREATING);
 	if (!error) {
 		configfs_set_dir_dirent_depth(p->d_fsdata, d->d_fsdata);
 		error = configfs_create(d, mode, init_dir);
@@ -304,7 +305,7 @@ static int create_dir(struct config_item *k, struct dentry *d)
  *	until it is validated by configfs_dir_set_ready()
  */
 
-static int configfs_create_dir(struct config_item * item, struct dentry *dentry)
+static int configfs_create_dir(struct config_item *item, struct dentry *dentry)
 {
 	int error = create_dir(item, dentry);
 	if (!error)
@@ -374,10 +375,10 @@ int configfs_create_link(struct configfs_symlink *sl,
 	return err;
 }
 
-static void remove_dir(struct dentry * d)
+static void remove_dir(struct dentry *d)
 {
-	struct dentry * parent = dget(d->d_parent);
-	struct configfs_dirent * sd;
+	struct dentry *parent = dget(d->d_parent);
+	struct configfs_dirent *sd;
 
 	sd = d->d_fsdata;
 	spin_lock(&configfs_dirent_lock);
@@ -385,9 +386,9 @@ static void remove_dir(struct dentry * d)
 	spin_unlock(&configfs_dirent_lock);
 	configfs_put(sd);
 	if (d->d_inode)
-		simple_rmdir(parent->d_inode,d);
+		simple_rmdir(parent->d_inode, d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
+	pr_debug(" o %s removing done (%d)\n", d->d_name.name, d->d_count);
 
 	dput(parent);
 }
@@ -403,9 +404,9 @@ static void remove_dir(struct dentry * d)
  * Caller holds the mutex of the item's inode
  */
 
-static void configfs_remove_dir(struct config_item * item)
+static void configfs_remove_dir(struct config_item *item)
 {
-	struct dentry * dentry = dget(item->ci_dentry);
+	struct dentry *dentry = dget(item->ci_dentry);
 
 	if (!dentry)
 		return;
@@ -421,9 +422,10 @@ static void configfs_remove_dir(struct config_item * item)
 /* attaches attribute's configfs_dirent to the dentry corresponding to the
  * attribute file
  */
-static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * dentry)
+static int configfs_attach_attr(struct configfs_dirent *sd,
+				struct dentry *dentry)
 {
-	struct configfs_attribute * attr = sd->s_element;
+	struct configfs_attribute *attr = sd->s_element;
 	int error;
 
 	dentry->d_fsdata = configfs_get(sd);
@@ -440,12 +442,12 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 	return 0;
 }
 
-static struct dentry * configfs_lookup(struct inode *dir,
-				       struct dentry *dentry,
-				       unsigned int flags)
+static struct dentry *configfs_lookup(struct inode *dir,
+				      struct dentry *dentry,
+				      unsigned int flags)
 {
-	struct configfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
-	struct configfs_dirent * sd;
+	struct configfs_dirent *parent_sd = dentry->d_parent->d_fsdata;
+	struct configfs_dirent *sd;
 	int found = 0;
 	int err;
 
@@ -463,7 +465,7 @@ static struct dentry * configfs_lookup(struct inode *dir,
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & CONFIGFS_NOT_PINNED) {
-			const unsigned char * name = configfs_get_name(sd);
+			const unsigned char *name = configfs_get_name(sd);
 
 			if (strcmp(name, dentry->d_name.name))
 				continue;
@@ -497,7 +499,8 @@ out:
  * If there is an error, the caller will reset the flags via
  * configfs_detach_rollback().
  */
-static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex)
+static int configfs_detach_prep(struct dentry *dentry,
+				struct mutex **wait_mutex)
 {
 	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *sd;
@@ -519,7 +522,8 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 			/* Abort if racing with mkdir() */
 			if (sd->s_type & CONFIGFS_USET_IN_MKDIR) {
 				if (wait_mutex)
-					*wait_mutex = &sd->s_dentry->d_inode->i_mutex;
+					*wait_mutex =
+						&sd->s_dentry->d_inode->i_mutex;
 				return -EAGAIN;
 			}
 
@@ -556,11 +560,11 @@ static void configfs_detach_rollback(struct dentry *dentry)
 			configfs_detach_rollback(sd->s_dentry);
 }
 
-static void detach_attrs(struct config_item * item)
+static void detach_attrs(struct config_item *item)
 {
-	struct dentry * dentry = dget(item->ci_dentry);
-	struct configfs_dirent * parent_sd;
-	struct configfs_dirent * sd, * tmp;
+	struct dentry *dentry = dget(item->ci_dentry);
+	struct configfs_dirent *parent_sd;
+	struct configfs_dirent *sd, *tmp;
 
 	if (!dentry)
 		return;
@@ -596,7 +600,8 @@ static int populate_attrs(struct config_item *item)
 		return -EINVAL;
 	if (t->ct_attrs) {
 		for (i = 0; (attr = t->ct_attrs[i]) != NULL; i++) {
-			if ((error = configfs_create_file(item, attr)))
+			error = configfs_create_file(item, attr);
+			if (error)
 				break;
 		}
 	}
@@ -614,7 +619,7 @@ static void configfs_detach_group(struct config_item *item);
 
 static void detach_groups(struct config_group *group)
 {
-	struct dentry * dentry = dget(group->cg_item.ci_dentry);
+	struct dentry *dentry = dget(group->cg_item.ci_dentry);
 	struct dentry *child;
 	struct configfs_dirent *parent_sd;
 	struct configfs_dirent *sd, *tmp;
@@ -774,7 +779,8 @@ static void unlink_group(struct config_group *group)
 	unlink_obj(&group->cg_item);
 }
 
-static void link_group(struct config_group *parent_group, struct config_group *group)
+static void link_group(struct config_group *parent_group,
+		       struct config_group *group)
 {
 	int i;
 	struct config_group *new_group;
@@ -910,8 +916,8 @@ static void client_disconnect_notify(struct config_item *parent_item,
 	BUG_ON(!type);
 
 	if (type->ct_group_ops && type->ct_group_ops->disconnect_notify)
-		type->ct_group_ops->disconnect_notify(to_config_group(parent_item),
-						      item);
+		type->ct_group_ops->
+			disconnect_notify(to_config_group(parent_item), item);
 }
 
 /*
@@ -942,9 +948,13 @@ static void client_drop_item(struct config_item *parent_item,
 #ifdef DEBUG
 static void configfs_dump_one(struct configfs_dirent *sd, int level)
 {
-	printk(KERN_INFO "%*s\"%s\":\n", level, " ", configfs_get_name(sd));
+	pr_info("%*s\"%s\":\n", level, " ", configfs_get_name(sd));
 
-#define type_print(_type) if (sd->s_type & _type) printk(KERN_INFO "%*s %s\n", level, " ", #_type);
+#define type_print(_type)						\
+	do {								\
+		if (sd->s_type & _type)					\
+			pr_info("%*s %s\n", level, " ", #_type);	\
+	} while (0)
 	type_print(CONFIGFS_ROOT);
 	type_print(CONFIGFS_DIR);
 	type_print(CONFIGFS_ITEM_ATTR);
@@ -1161,7 +1171,7 @@ void configfs_undepend_item(struct configfs_subsystem *subsys,
 }
 EXPORT_SYMBOL(configfs_undepend_item);
 
-static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mod)
 {
 	int ret = 0;
 	int module_got = 0;
@@ -1228,7 +1238,8 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 
 	mutex_lock(&subsys->su_mutex);
 	if (type->ct_group_ops->make_group) {
-		group = type->ct_group_ops->make_group(to_config_group(parent_item), name);
+		group = type->ct_group_ops->
+			make_group(to_config_group(parent_item), name);
 		if (!group)
 			group = ERR_PTR(-ENOMEM);
 		if (!IS_ERR(group)) {
@@ -1237,7 +1248,8 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 		} else
 			ret = PTR_ERR(group);
 	} else {
-		item = type->ct_group_ops->make_item(to_config_group(parent_item), name);
+		item = type->ct_group_ops->
+			make_item(to_config_group(parent_item), name);
 		if (!item)
 			item = ERR_PTR(-ENOMEM);
 		if (!IS_ERR(item))
@@ -1448,10 +1460,10 @@ const struct inode_operations configfs_root_inode_operations = {
 };
 
 #if 0
-int configfs_rename_dir(struct config_item * item, const char *new_name)
+int configfs_rename_dir(struct config_item *item, const char *new_name)
 {
 	int error = 0;
-	struct dentry * new_dentry, * parent;
+	struct dentry *new_dentry, *parent;
 
 	if (!strcmp(config_item_name(item), new_name))
 		return -EINVAL;
@@ -1471,8 +1483,7 @@ int configfs_rename_dir(struct config_item * item, const char *new_name)
 			if (!error) {
 				d_add(new_dentry, NULL);
 				d_move(item->dentry, new_dentry);
-			}
-			else
+			} else
 				d_delete(new_dentry);
 		} else
 			error = -EEXIST;
@@ -1487,8 +1498,8 @@ int configfs_rename_dir(struct config_item * item, const char *new_name)
 
 static int configfs_dir_open(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
-	struct configfs_dirent * parent_sd = dentry->d_fsdata;
+	struct dentry *dentry = file->f_path.dentry;
+	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	int err;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -1511,8 +1522,8 @@ static int configfs_dir_open(struct inode *inode, struct file *file)
 
 static int configfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
-	struct configfs_dirent * cursor = file->private_data;
+	struct dentry *dentry = file->f_path.dentry;
+	struct configfs_dirent *cursor = file->private_data;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	spin_lock(&configfs_dirent_lock);
@@ -1531,102 +1542,102 @@ static inline unsigned char dt_type(struct configfs_dirent *sd)
 	return (sd->s_mode >> 12) & 15;
 }
 
-static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
+static int configfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct super_block *sb = dentry->d_sb;
-	struct configfs_dirent * parent_sd = dentry->d_fsdata;
+	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->s_sibling;
 	ino_t ino = 0;
 	int i = filp->f_pos;
 
 	switch (i) {
-		case 0:
-			ino = dentry->d_inode->i_ino;
-			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		case 1:
-			ino = parent_ino(dentry);
-			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		default:
-			if (filp->f_pos == 2) {
-				spin_lock(&configfs_dirent_lock);
-				list_move(q, &parent_sd->s_children);
-				spin_unlock(&configfs_dirent_lock);
-			}
-			for (p=q->next; p!= &parent_sd->s_children; p=p->next) {
-				struct configfs_dirent *next;
-				const char * name;
-				int len;
-				struct inode *inode = NULL;
+	case 0:
+		ino = dentry->d_inode->i_ino;
+		if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	case 1:
+		ino = parent_ino(dentry);
+		if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	default:
+		if (filp->f_pos == 2) {
+			spin_lock(&configfs_dirent_lock);
+			list_move(q, &parent_sd->s_children);
+			spin_unlock(&configfs_dirent_lock);
+		}
+		for (p = q->next; p != &parent_sd->s_children; p = p->next) {
+			struct configfs_dirent *next;
+			const char *name;
+			int len;
+			struct inode *inode = NULL;
+
+			next = list_entry(p, struct configfs_dirent,
+					   s_sibling);
+			if (!next->s_element)
+				continue;
 
-				next = list_entry(p, struct configfs_dirent,
-						   s_sibling);
-				if (!next->s_element)
-					continue;
-
-				name = configfs_get_name(next);
-				len = strlen(name);
-
-				/*
-				 * We'll have a dentry and an inode for
-				 * PINNED items and for open attribute
-				 * files.  We lock here to prevent a race
-				 * with configfs_d_iput() clearing
-				 * s_dentry before calling iput().
-				 *
-				 * Why do we go to the trouble?  If
-				 * someone has an attribute file open,
-				 * the inode number should match until
-				 * they close it.  Beyond that, we don't
-				 * care.
-				 */
-				spin_lock(&configfs_dirent_lock);
-				dentry = next->s_dentry;
-				if (dentry)
-					inode = dentry->d_inode;
-				if (inode)
-					ino = inode->i_ino;
-				spin_unlock(&configfs_dirent_lock);
-				if (!inode)
-					ino = iunique(sb, 2);
+			name = configfs_get_name(next);
+			len = strlen(name);
 
-				if (filldir(dirent, name, len, filp->f_pos, ino,
-						 dt_type(next)) < 0)
-					return 0;
+			/*
+			 * We'll have a dentry and an inode for
+			 * PINNED items and for open attribute
+			 * files.  We lock here to prevent a race
+			 * with configfs_d_iput() clearing
+			 * s_dentry before calling iput().
+			 *
+			 * Why do we go to the trouble?  If
+			 * someone has an attribute file open,
+			 * the inode number should match until
+			 * they close it.  Beyond that, we don't
+			 * care.
+			 */
+			spin_lock(&configfs_dirent_lock);
+			dentry = next->s_dentry;
+			if (dentry)
+				inode = dentry->d_inode;
+			if (inode)
+				ino = inode->i_ino;
+			spin_unlock(&configfs_dirent_lock);
+			if (!inode)
+				ino = iunique(sb, 2);
 
-				spin_lock(&configfs_dirent_lock);
-				list_move(q, p);
-				spin_unlock(&configfs_dirent_lock);
-				p = q;
-				filp->f_pos++;
-			}
+			if (filldir(dirent, name, len, filp->f_pos, ino,
+					 dt_type(next)) < 0)
+				return 0;
+
+			spin_lock(&configfs_dirent_lock);
+			list_move(q, p);
+			spin_unlock(&configfs_dirent_lock);
+			p = q;
+			filp->f_pos++;
+		}
 	}
 	return 0;
 }
 
 static loff_t configfs_dir_lseek(struct file *file, loff_t offset, int whence)
 {
-	struct dentry * dentry = file->f_path.dentry;
+	struct dentry *dentry = file->f_path.dentry;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (whence) {
-		case 1:
-			offset += file->f_pos;
-		case 0:
-			if (offset >= 0)
-				break;
-		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
-			return -EINVAL;
+	case 1:
+		offset += file->f_pos;
+	case 0:
+		if (offset >= 0)
+			break;
+	default:
+		mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+		return -EINVAL;
 	}
 	if (offset != file->f_pos) {
 		file->f_pos = offset;
@@ -1715,6 +1726,7 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 
 	return err;
 }
+EXPORT_SYMBOL(configfs_register_subsystem);
 
 void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 {
@@ -1723,7 +1735,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	struct dentry *root = dentry->d_sb->s_root;
 
 	if (dentry->d_parent != root) {
-		printk(KERN_ERR "configfs: Tried to unregister non-subsystem!\n");
+		pr_err("configfs: Tried to unregister non-subsystem!\n");
 		return;
 	}
 
@@ -1732,9 +1744,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
-	if (configfs_detach_prep(dentry, NULL)) {
-		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
-	}
+	if (configfs_detach_prep(dentry, NULL))
+		pr_err("configfs: Tried to unregister non-empty subsystem!\n");
+
 	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&configfs_symlink_mutex);
 	configfs_detach_group(&group->cg_item);
@@ -1751,6 +1763,4 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	unlink_group(group);
 	configfs_release_fs();
 }
-
-EXPORT_SYMBOL(configfs_register_subsystem);
 EXPORT_SYMBOL(configfs_unregister_subsystem);
-- 
1.7.0.4

