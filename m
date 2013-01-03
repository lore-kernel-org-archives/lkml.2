Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3ACLoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:44:02 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3ACLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:56 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-a8-50e56ebb8fd9
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/8] fs/configfs: file.c checkpatch cleanup
Date: Thu, 03 Jan 2013 12:42:37 +0100
Message-id: <1357213361-23620-5-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
References: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
 <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJMWRmVeSWpSXmKPExsVy+t/xq7q7854GGKy8o2JxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyJr1uZClY51sxadtP9gbGD3ZdjBwcEgImEvsbcroYOYFMMYkL
	99azdTFycQgJLGWUONrzgx0kISSwgUliw5ZCEJtNwFhi78EORhBbREBBYnPvM1aQBmaB9YwS
	E+83gCWEBawlrs57wQKygEVAVWLbGW6QMK+Aq0TX704WiGXyEk/v97GB2JwCbhIr+5ewQiye
	yyjxbel61gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihHj8yw7GxcesDjEKcDAq
	8fCuqHkSIMSaWFZcmXuIUYKDWUmE93oOUIg3JbGyKrUoP76oNCe1+BAjEwenVANjrZLzjotX
	q/8FVuZr90tkrYuQuqHaNOVB16M1Uac5Dl668eHCbSWVY10HzX93tdR821z6UnviYYtnZjeu
	LDp6TFlFTMdV425c2ckrRlkvwreqv89scG5U+OrMtmZi7f99jCEzmxUymwPv7pv+c3bL5DM8
	m+Q3FN6+9EP7200D3vagz7dK4h97K7EUZyQaajEXFScCAPstao7WAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate checkpatch errors and warnings

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/configfs/file.c |  112 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 2b6cb23..18e2823 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
@@ -44,8 +44,8 @@
 struct configfs_buffer {
 	size_t			count;
 	loff_t			pos;
-	char			* page;
-	struct configfs_item_operations	* ops;
+	char			*page;
+	struct configfs_item_operations	*ops;
 	struct mutex		mutex;
 	int			needs_read_fill;
 };
@@ -61,11 +61,12 @@ struct configfs_buffer {
  *	data.
  *	This is called only once, on the file's first read.
  */
-static int fill_read_buffer(struct dentry * dentry, struct configfs_buffer * buffer)
+static int fill_read_buffer(struct dentry *dentry,
+			    struct configfs_buffer *buffer)
 {
-	struct configfs_attribute * attr = to_attr(dentry);
-	struct config_item * item = to_item(dentry->d_parent);
-	struct configfs_item_operations * ops = buffer->ops;
+	struct configfs_attribute *attr = to_attr(dentry);
+	struct config_item *item = to_item(dentry->d_parent);
+	struct configfs_item_operations *ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -74,7 +75,7 @@ static int fill_read_buffer(struct dentry * dentry, struct configfs_buffer * buf
 	if (!buffer->page)
 		return -ENOMEM;
 
-	count = ops->show_attribute(item,attr,buffer->page);
+	count = ops->show_attribute(item, attr, buffer->page);
 	buffer->needs_read_fill = 0;
 	BUG_ON(count > (ssize_t)SIMPLE_ATTR_SIZE);
 	if (count >= 0)
@@ -104,14 +105,16 @@ static int fill_read_buffer(struct dentry * dentry, struct configfs_buffer * buf
  */
 
 static ssize_t
-configfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+configfs_read_file(struct file *file, char __user *buf, size_t count,
+		   loff_t *ppos)
 {
-	struct configfs_buffer * buffer = file->private_data;
+	struct configfs_buffer *buffer = file->private_data;
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
+		retval = fill_read_buffer(file->f_path.dentry, buffer);
+		if (retval)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
@@ -135,7 +138,8 @@ out:
  */
 
 static int
-fill_write_buffer(struct configfs_buffer * buffer, const char __user * buf, size_t count)
+fill_write_buffer(struct configfs_buffer *buffer, const char __user *buf,
+		  size_t count)
 {
 	int error;
 
@@ -146,7 +150,7 @@ fill_write_buffer(struct configfs_buffer * buffer, const char __user * buf, size
 
 	if (count >= SIMPLE_ATTR_SIZE)
 		count = SIMPLE_ATTR_SIZE - 1;
-	error = copy_from_user(buffer->page,buf,count);
+	error = copy_from_user(buffer->page, buf, count);
 	buffer->needs_read_fill = 1;
 	/* if buf is assumed to contain a string, terminate it by \0,
 	 * so e.g. sscanf() can scan the string easily */
@@ -167,13 +171,14 @@ fill_write_buffer(struct configfs_buffer * buffer, const char __user * buf, size
  */
 
 static int
-flush_write_buffer(struct dentry * dentry, struct configfs_buffer * buffer, size_t count)
+flush_write_buffer(struct dentry *dentry, struct configfs_buffer *buffer,
+		   size_t count)
 {
-	struct configfs_attribute * attr = to_attr(dentry);
-	struct config_item * item = to_item(dentry->d_parent);
-	struct configfs_item_operations * ops = buffer->ops;
+	struct configfs_attribute *attr = to_attr(dentry);
+	struct config_item *item = to_item(dentry->d_parent);
+	struct configfs_item_operations *ops = buffer->ops;
 
-	return ops->store_attribute(item,attr,buffer->page,count);
+	return ops->store_attribute(item, attr, buffer->page, count);
 }
 
 
@@ -184,7 +189,8 @@ flush_write_buffer(struct dentry * dentry, struct configfs_buffer * buffer, size
  *	@count:	number of bytes
  *	@ppos:	starting offset
  *
- *	Similar to configfs_read_file(), though working in the opposite direction.
+ *	Similar to configfs_read_file(), though working in the opposite
+ *	direction.
  *	We allocate and fill the data from the user in fill_write_buffer(),
  *	then push it to the config_item in flush_write_buffer().
  *	There is no easy way for us to know if userspace is only doing a partial
@@ -195,9 +201,10 @@ flush_write_buffer(struct dentry * dentry, struct configfs_buffer * buffer, size
  */
 
 static ssize_t
-configfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+configfs_write_file(struct file *file, const char __user *buf, size_t count,
+		    loff_t *ppos)
 {
-	struct configfs_buffer * buffer = file->private_data;
+	struct configfs_buffer *buffer = file->private_data;
 	ssize_t len;
 
 	mutex_lock(&buffer->mutex);
@@ -210,27 +217,28 @@ configfs_write_file(struct file *file, const char __user *buf, size_t count, lof
 	return len;
 }
 
-static int check_perm(struct inode * inode, struct file * file)
+static int check_perm(struct inode *inode, struct file *file)
 {
-	struct config_item *item = configfs_get_config_item(file->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(file->f_path.dentry);
-	struct configfs_buffer * buffer;
-	struct configfs_item_operations * ops = NULL;
+	struct config_item *item =
+		configfs_get_config_item(file->f_path.dentry->d_parent);
+	struct configfs_attribute *attr = to_attr(file->f_path.dentry);
+	struct configfs_buffer *buffer;
+	struct configfs_item_operations *ops = NULL;
 	int error = 0;
 
 	if (!item || !attr)
-		goto Einval;
+		goto einval;
 
 	/* Grab the module reference for this attribute if we have one */
 	if (!try_module_get(attr->ca_owner)) {
 		error = -ENODEV;
-		goto Done;
+		goto done;
 	}
 
 	if (item->ci_type)
 		ops = item->ci_type->ct_item_ops;
 	else
-		goto Eaccess;
+		goto eaccess;
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok,
@@ -239,7 +247,7 @@ static int check_perm(struct inode * inode, struct file * file)
 	if (file->f_mode & FMODE_WRITE) {
 
 		if (!(inode->i_mode & S_IWUGO) || !ops->store_attribute)
-			goto Eaccess;
+			goto eaccess;
 
 	}
 
@@ -249,47 +257,47 @@ static int check_perm(struct inode * inode, struct file * file)
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO) || !ops->show_attribute)
-			goto Eaccess;
+			goto eaccess;
 	}
 
 	/* No error? Great, allocate a buffer for the file, and store it
 	 * it in file->private_data for easy access.
 	 */
-	buffer = kzalloc(sizeof(struct configfs_buffer),GFP_KERNEL);
+	buffer = kzalloc(sizeof(struct configfs_buffer), GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
-		goto Enomem;
+		goto enomem;
 	}
 	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
-	goto Done;
+	goto done;
 
- Einval:
+ einval:
 	error = -EINVAL;
-	goto Done;
- Eaccess:
+	goto done;
+ eaccess:
 	error = -EACCES;
- Enomem:
+ enomem:
 	module_put(attr->ca_owner);
- Done:
+ done:
 	if (error && item)
 		config_item_put(item);
 	return error;
 }
 
-static int configfs_open_file(struct inode * inode, struct file * filp)
+static int configfs_open_file(struct inode *inode, struct file *filp)
 {
-	return check_perm(inode,filp);
+	return check_perm(inode, filp);
 }
 
-static int configfs_release(struct inode * inode, struct file * filp)
+static int configfs_release(struct inode *inode, struct file *filp)
 {
-	struct config_item * item = to_item(filp->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(filp->f_path.dentry);
-	struct module * owner = attr->ca_owner;
-	struct configfs_buffer * buffer = filp->private_data;
+	struct config_item *item = to_item(filp->f_path.dentry->d_parent);
+	struct configfs_attribute *attr = to_attr(filp->f_path.dentry);
+	struct module *owner = attr->ca_owner;
+	struct configfs_buffer *buffer = filp->private_data;
 
 	if (item)
 		config_item_put(item);
@@ -314,14 +322,15 @@ const struct file_operations configfs_file_operations = {
 };
 
 
-int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type)
+int configfs_add_file(struct dentry *dir, const struct configfs_attribute *attr,
+		      int type)
 {
-	struct configfs_dirent * parent_sd = dir->d_fsdata;
+	struct configfs_dirent *parent_sd = dir->d_fsdata;
 	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
 	int error = 0;
 
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_NORMAL);
-	error = configfs_make_dirent(parent_sd, NULL, (void *) attr, mode, type);
+	error = configfs_make_dirent(parent_sd, NULL, (void *)attr, mode, type);
 	mutex_unlock(&dir->d_inode->i_mutex);
 
 	return error;
@@ -334,7 +343,8 @@ int configfs_add_file(struct dentry * dir, const struct configfs_attribute * att
  *	@attr:	atrribute descriptor.
  */
 
-int configfs_create_file(struct config_item * item, const struct configfs_attribute * attr)
+int configfs_create_file(struct config_item *item,
+			 const struct configfs_attribute *attr)
 {
 	BUG_ON(!item || !item->ci_dentry || !attr);
 
-- 
1.7.0.4

