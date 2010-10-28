Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab0J1Vd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934358Ab0J1VdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 15/20] fsnotify: rename FS_IN_ISDIR to FS_ISDIR
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:01 -0400
Message-ID: <20101028213301.24810.93295.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _IN_ in the naming is reserved for flags only used by inotify.  Since I
am about to use this flag for fanotify rename it to be generic like the
rest.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 include/linux/fsnotify.h         |   20 ++++++++++----------
 include/linux/fsnotify_backend.h |    4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 24edc11..444c305 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -862,7 +862,7 @@ static int __init inotify_user_setup(void)
 	BUILD_BUG_ON(IN_Q_OVERFLOW != FS_Q_OVERFLOW);
 	BUILD_BUG_ON(IN_IGNORED != FS_IN_IGNORED);
 	BUILD_BUG_ON(IN_EXCL_UNLINK != FS_EXCL_UNLINK);
-	BUILD_BUG_ON(IN_ISDIR != FS_IN_ISDIR);
+	BUILD_BUG_ON(IN_ISDIR != FS_ISDIR);
 	BUILD_BUG_ON(IN_ONESHOT != FS_IN_ONESHOT);
 
 	BUG_ON(hweight32(ALL_INOTIFY_BITS) != 21);
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 5059faa..ecb43b3 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -98,8 +98,8 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 		old_dir_mask |= FS_DN_RENAME;
 
 	if (isdir) {
-		old_dir_mask |= FS_IN_ISDIR;
-		new_dir_mask |= FS_IN_ISDIR;
+		old_dir_mask |= FS_ISDIR;
+		new_dir_mask |= FS_ISDIR;
 	}
 
 	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
@@ -137,7 +137,7 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 	__u32 mask = FS_DELETE;
 
 	if (isdir)
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	fsnotify_parent(NULL, dentry, mask);
 }
@@ -179,7 +179,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
-	__u32 mask = (FS_CREATE | FS_IN_ISDIR);
+	__u32 mask = (FS_CREATE | FS_ISDIR);
 	struct inode *d_inode = dentry->d_inode;
 
 	audit_inode_child(dentry, inode);
@@ -197,7 +197,7 @@ static inline void fsnotify_access(struct file *file)
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
 		fsnotify_parent(path, NULL, mask);
@@ -215,7 +215,7 @@ static inline void fsnotify_modify(struct file *file)
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
 		fsnotify_parent(path, NULL, mask);
@@ -233,7 +233,7 @@ static inline void fsnotify_open(struct file *file)
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
 		fsnotify_parent(path, NULL, mask);
@@ -252,7 +252,7 @@ static inline void fsnotify_close(struct file *file)
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
 		fsnotify_parent(path, NULL, mask);
@@ -269,7 +269,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	__u32 mask = FS_ATTRIB;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= FS_IN_ISDIR;
+		mask |= FS_ISDIR;
 
 	fsnotify_parent(NULL, dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
@@ -304,7 +304,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 
 	if (mask) {
 		if (S_ISDIR(inode->i_mode))
-			mask |= FS_IN_ISDIR;
+			mask |= FS_ISDIR;
 
 		fsnotify_parent(NULL, dentry, mask);
 		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 4366f45..b36041e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -45,7 +45,7 @@
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 
 #define FS_EXCL_UNLINK		0x04000000	/* do not send events if object is unlinked */
-#define FS_IN_ISDIR		0x40000000	/* event occurred against dir */
+#define FS_ISDIR		0x40000000	/* event occurred against dir */
 #define FS_IN_ONESHOT		0x80000000	/* only send event once */
 
 #define FS_DN_RENAME		0x10000000	/* file renamed */
@@ -72,7 +72,7 @@
 			     FS_DELETE | FS_DELETE_SELF | FS_MOVE_SELF | \
 			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED | \
 			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_EXCL_UNLINK | \
-			     FS_IN_ISDIR | FS_IN_ONESHOT | FS_DN_RENAME | \
+			     FS_ISDIR | FS_IN_ONESHOT | FS_DN_RENAME | \
 			     FS_DN_MULTISHOT | FS_EVENT_ON_CHILD)
 
 struct fsnotify_group;

