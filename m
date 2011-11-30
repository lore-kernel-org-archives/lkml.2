Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab1K3CRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:17:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55817 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:17:39 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/28] namespace: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:14 -0800
Message-Id: <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few style things.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/namespace.c | \
  cut -f3- -d":" | sort | uniq -c
      1  ERROR: do not initialise statics to 0 or NULL
      2  ERROR: do not use assignment in if condition
      1  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: need consistent spacing around '|' (ctx:VxW)
      1  WARNING: braces {} are not necessary for single statement blocks
      3  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      4  WARNING: line over 80 characters
      9  WARNING: please, no space before tabs
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      1  WARNING: Use #include <linux/unistd.h> instead of <asm/unistd.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/namespace.c |   52 +++++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f9a164d..30bc685 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -33,8 +33,8 @@
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
 #include <linux/fsnotify.h>
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
 #include "pnode.h"
 #include "internal.h"
 
@@ -45,7 +45,7 @@ static int event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
 static DEFINE_SPINLOCK(mnt_id_lock);
-static int mnt_id_start = 0;
+static int mnt_id_start;
 static int mnt_group_start = 1;
 
 static struct list_head *mount_hashtable __read_mostly;
@@ -511,7 +511,8 @@ struct vfsmount *lookup_mnt(struct path *path)
 	struct vfsmount *child_mnt;
 
 	br_read_lock(&vfsmount_lock);
-	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
+	child_mnt = __lookup_mnt(path->mnt, path->dentry, 1);
+	if (child_mnt)
 		mntget(child_mnt);
 	br_read_unlock(&vfsmount_lock);
 	return child_mnt;
@@ -671,7 +672,8 @@ static struct vfsmount *skip_mnt_tree(struct vfsmount *p)
 }
 
 struct vfsmount *
-vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void *data)
+vfs_kern_mount(struct file_system_type *type, int flags, const char *name,
+	       void *data)
 {
 	struct vfsmount *mnt;
 	struct dentry *root;
@@ -1174,7 +1176,6 @@ int may_umount_tree(struct vfsmount *mnt)
 
 	return 1;
 }
-
 EXPORT_SYMBOL(may_umount_tree);
 
 /**
@@ -1201,7 +1202,6 @@ int may_umount(struct vfsmount *mnt)
 	up_read(&namespace_sem);
 	return ret;
 }
-
 EXPORT_SYMBOL(may_umount);
 
 void release_mounts(struct list_head *head)
@@ -1307,9 +1307,8 @@ static int do_umount(struct vfsmount *mnt, int flags)
 	 * about for the moment.
 	 */
 
-	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
+	if (flags & MNT_FORCE && sb->s_op->umount_begin)
 		sb->s_op->umount_begin(sb);
-	}
 
 	/*
 	 * No sense to grab the lock for this test, but test itself looks
@@ -1541,8 +1540,8 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
  *  @parent_nd  : if non-null, detach the source_mnt from its parent and
- *  		   store the parent mount and mountpoint dentry.
- *  		   (done when source_mnt is moved)
+ *		   store the parent mount and mountpoint dentry.
+ *		   (done when source_mnt is moved)
  *
  *  NOTE: in the table below explains the semantics when a source mount
  *  of a given type is attached to a destination mount of a given type.
@@ -1562,8 +1561,8 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
  * destination mount.
  *
  * (++)  the cloned mount is propagated to all the mounts in the propagation
- * 	 tree of the destination mount and the cloned mount is added to
- * 	 the peer group of the source mount.
+ *	 tree of the destination mount and the cloned mount is added to
+ *	 the peer group of the source mount.
  * (+)   the cloned mount is created under the destination mount and is marked
  *       as shared. The cloned mount is added to the peer group of the source
  *       mount.
@@ -1572,10 +1571,10 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
  *       of the same master as that of the source mount. The cloned mount
  *       is marked as 'shared and slave'.
  * (*)   the cloned mount is made a slave of the same master as that of the
- * 	 source mount.
+ *	 source mount.
  *
  * ---------------------------------------------------------------------------
- * |         		MOVE MOUNT OPERATION                                 |
+ * |			MOVE MOUNT OPERATION                                 |
  * |**************************************************************************
  * | source-->| shared        |       private  |       slave    | unbindable |
  * | dest     |               |                |                |            |
@@ -1588,11 +1587,11 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
  * ***************************************************************************
  *
  * (+)  the mount is moved to the destination. And is then propagated to
- * 	all the mounts in the propagation tree of the destination mount.
+ *	all the mounts in the propagation tree of the destination mount.
  * (+*)  the mount is moved to the destination.
  * (+++)  the mount is moved to the destination and is then propagated to
- * 	all the mounts belonging to the destination mount's propagation tree.
- * 	the mount is marked as 'shared and slave'.
+ *	all the mounts belonging to the destination mount's propagation tree.
+ *	the mount is marked as 'shared and slave'.
  * (*)	the mount continues to be a slave at the new location.
  *
  * if the source mount is a tree, the operations explained above is
@@ -1977,7 +1976,8 @@ EXPORT_SYMBOL_GPL(do_kern_mount);
 /*
  * add a mount into a namespace's mount tree
  */
-static int do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flags)
+static int
+do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flags)
 {
 	int err;
 
@@ -2123,7 +2123,6 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 
 	release_mounts(&umounts);
 }
-
 EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
 
 /*
@@ -2132,7 +2131,8 @@ EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
  * search the list of submounts for a given mountpoint, and move any
  * shrinkable submounts to the 'graveyard' list.
  */
-static int select_submounts(struct vfsmount *parent, struct list_head *graveyard)
+static int
+select_submounts(struct vfsmount *parent, struct list_head *graveyard)
 {
 	struct vfsmount *this_parent = parent;
 	struct list_head *next;
@@ -2143,7 +2143,8 @@ repeat:
 resume:
 	while (next != &this_parent->mnt_mounts) {
 		struct list_head *tmp = next;
-		struct vfsmount *mnt = list_entry(tmp, struct vfsmount, mnt_child);
+		struct vfsmount *mnt = list_entry(tmp, struct vfsmount,
+						  mnt_child);
 
 		next = tmp->next;
 		if (!(mnt->mnt_flags & MNT_SHRINKABLE))
@@ -2222,7 +2223,7 @@ static long exact_copy_from_user(void *to, const void __user * from,
 	return n;
 }
 
-int copy_mount_options(const void __user * data, unsigned long *where)
+int copy_mount_options(const void __user *data, unsigned long *where)
 {
 	int i;
 	unsigned long page;
@@ -2232,7 +2233,8 @@ int copy_mount_options(const void __user * data, unsigned long *where)
 	if (!data)
 		return 0;
 
-	if (!(page = __get_free_page(GFP_KERNEL)))
+	page = __get_free_page(GFP_KERNEL);
+	if (!page)
 		return -ENOMEM;
 
 	/* We only care that *some* data at the address the user
@@ -2336,7 +2338,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_KERNMOUNT |
 		   MS_STRICTATIME);
 
 	if (flags & MS_REMOUNT)
-- 
1.7.6.405.gc1be0

