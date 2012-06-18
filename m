Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2FRO1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:27:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38284 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2FRO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:27:52 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dhowells@redhat.com
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
	<20120610034921.GB30000@ZenIV.linux.org.uk>
	<20120610111056.GD30000@ZenIV.linux.org.uk>
	<20120610175605.GE30000@ZenIV.linux.org.uk>
	<20120610222745.GG30000@ZenIV.linux.org.uk>
	<20120617203755.GA31478@infradead.org>
	<20120618115804.GA4048@infradead.org>
	<20120618131252.GA21931@infradead.org>
Date: Mon, 18 Jun 2012 16:27:41 +0200
In-Reply-To: <20120618131252.GA21931@infradead.org> (Christoph Hellwig's
	message of "Mon, 18 Jun 2012 09:12:52 -0400")
Message-ID: <87aa00g0f6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's fix against e8c30bb7 "->atomic_open() prototype change - pass int
* instead of bool *"

Rename FILE_CREATE to FILE_CREATED because it conflicts with a define in
fs/cifs/cifspdu.h

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/9p/vfs_inode.c      |    2 +-
 fs/9p/vfs_inode_dotl.c |    2 +-
 fs/ceph/dir.c          |    2 +-
 fs/cifs/dir.c          |    4 ++--
 fs/fuse/dir.c          |    2 +-
 fs/namei.c             |   14 +++++++-------
 include/linux/fs.h     |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/fs/9p/vfs_inode.c	2012-06-18 15:52:59.000000000 +0200
@@ -925,7 +925,7 @@ v9fs_vfs_atomic_open(struct inode *dir,
 		v9fs_cache_inode_set_cookie(dentry->d_inode, file);
 #endif
 
-	*opened |= FILE_CREATE;
+	*opened |= FILE_CREATED;
 out:
 	dput(res);
 	return err;
Index: linux-2.6/fs/9p/vfs_inode_dotl.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode_dotl.c	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/fs/9p/vfs_inode_dotl.c	2012-06-18 15:57:11.000000000 +0200
@@ -362,7 +362,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (v9ses->cache)
 		v9fs_cache_inode_set_cookie(inode, file);
 #endif
-	*opened |= FILE_CREATE;
+	*opened |= FILE_CREATED;
 out:
 	dput(res);
 	return err;
Index: linux-2.6/fs/ceph/dir.c
===================================================================
--- linux-2.6.orig/fs/ceph/dir.c	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/fs/ceph/dir.c	2012-06-18 16:01:31.000000000 +0200
@@ -665,7 +665,7 @@ int ceph_atomic_open(struct inode *dir,
 	if (dentry->d_inode)
 		return finish_no_open(file, res);
 
-	*opened |= FILE_CREATE;
+	*opened |= FILE_CREATED;
 	err = ceph_lookup_open(dir, dentry, file, flags, mode, opened);
 	dput(res);
 
Index: linux-2.6/fs/cifs/dir.c
===================================================================
--- linux-2.6.orig/fs/cifs/dir.c	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/fs/cifs/dir.c	2012-06-18 16:03:39.000000000 +0200
@@ -311,7 +311,7 @@ static int cifs_do_create(struct inode *
 				.device	= 0,
 		};
 
-		*created |= FILE_CREATE;
+		*created |= FILE_CREATED;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			args.uid = (__u64) current_fsuid();
 			if (inode->i_mode & S_ISGID)
@@ -466,7 +466,7 @@ int cifs_create(struct inode *inode, str
 	struct tcon_link *tlink;
 	__u16 fileHandle;
 	__u32 oplock;
-	int created = FILE_CREATE;
+	int created = FILE_CREATED;
 
 	cFYI(1, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p",
 	     inode, direntry->d_name.name, direntry);
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2012-06-18 16:04:46.000000000 +0200
@@ -490,7 +490,7 @@ static int fuse_atomic_open(struct inode
 		goto no_open;
 
 	/* Only creates */
-	*opened |= FILE_CREATE;
+	*opened |= FILE_CREATED;
 
 	if (fc->no_create)
 		goto mknod;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2012-06-18 15:43:07.000000000 +0200
+++ linux-2.6/fs/namei.c	2012-06-18 16:05:27.000000000 +0200
@@ -2244,7 +2244,7 @@ static int atomic_open(struct nameidata
 
 	if (open_flag & O_EXCL) {
 		open_flag &= ~O_TRUNC;
-		*opened |= FILE_CREATE;
+		*opened |= FILE_CREATED;
 	}
 
 	/*
@@ -2302,7 +2302,7 @@ static int atomic_open(struct nameidata
 	}
 
 	acc_mode = op->acc_mode;
-	if (*opened & FILE_CREATE) {
+	if (*opened & FILE_CREATED) {
 		fsnotify_create(dir, dentry);
 		acc_mode = MAY_OPEN;
 	}
@@ -2374,7 +2374,7 @@ static int atomic_open(struct nameidata
  *
  * An error code is returned otherwise.
  *
- * FILE_CREATE will be set in @*opened if the dentry was created and will be
+ * FILE_CREATED will be set in @*opened if the dentry was created and will be
  * cleared otherwise prior to returning.
  */
 static int lookup_open(struct nameidata *nd, struct path *path,
@@ -2388,7 +2388,7 @@ static int lookup_open(struct nameidata
 	int error;
 	bool need_lookup;
 
-	*opened &= ~FILE_CREATE;
+	*opened &= ~FILE_CREATED;
 	dentry = lookup_dcache(&nd->last, dir, nd->flags, &need_lookup);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
@@ -2426,7 +2426,7 @@ static int lookup_open(struct nameidata
 		if (error)
 			goto out_dput;
 		*want_write = true;
-		*opened |= FILE_CREATE;
+		*opened |= FILE_CREATED;
 		error = security_path_mknod(&nd->path, dentry, mode, 0);
 		if (error)
 			goto out_dput;
@@ -2532,7 +2532,7 @@ static int do_last(struct nameidata *nd,
 		if (error)
 			goto out;
 
-		if ((*opened & FILE_CREATE) ||
+		if ((*opened & FILE_CREATED) ||
 		    !S_ISREG(file->f_path.dentry->d_inode->i_mode))
 			will_truncate = false;
 
@@ -2540,7 +2540,7 @@ static int do_last(struct nameidata *nd,
 		goto opened;
 	}
 
-	if (*opened & FILE_CREATE) {
+	if (*opened & FILE_CREATED) {
 		/* Don't check for write permission, don't truncate */
 		open_flag &= ~O_TRUNC;
 		will_truncate = false;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2012-06-18 13:50:17.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2012-06-18 16:05:37.000000000 +0200
@@ -2065,7 +2065,7 @@ extern struct file * dentry_open(struct
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
 enum {
-	FILE_CREATE = 1,
+	FILE_CREATED = 1,
 	FILE_OPENED = 2
 };
 extern int finish_open(struct file *file, struct dentry *dentry,
