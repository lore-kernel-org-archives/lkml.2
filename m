Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2CGVXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030260Ab2CGVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:40 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 25/25] vfs: remove nameidata from lookup
Date: Wed,  7 Mar 2012 22:22:42 +0100
Message-Id: <1331155362-11132-26-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Remove nameidata argument of i_op->lookup.  It is no longer used by any
filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking |    3 +--
 Documentation/filesystems/vfs.txt |    2 +-
 fs/9p/v9fs.h                      |    3 +--
 fs/9p/vfs_inode.c                 |    8 +++-----
 fs/adfs/dir.c                     |    2 +-
 fs/affs/affs.h                    |    2 +-
 fs/affs/namei.c                   |    2 +-
 fs/afs/dir.c                      |    6 ++----
 fs/afs/mntpt.c                    |    7 ++-----
 fs/autofs4/root.c                 |    4 ++--
 fs/bad_inode.c                    |    3 +--
 fs/befs/linuxvfs.c                |    4 ++--
 fs/bfs/dir.c                      |    3 +--
 fs/btrfs/inode.c                  |    3 +--
 fs/ceph/dir.c                     |    5 ++---
 fs/cifs/cifsfs.h                  |    3 +--
 fs/cifs/dir.c                     |    3 +--
 fs/coda/dir.c                     |    4 ++--
 fs/configfs/dir.c                 |    4 +---
 fs/cramfs/inode.c                 |    2 +-
 fs/ecryptfs/inode.c               |    4 +---
 fs/efs/efs.h                      |    2 +-
 fs/efs/namei.c                    |    3 ++-
 fs/exofs/namei.c                  |    3 +--
 fs/ext2/namei.c                   |    2 +-
 fs/ext3/namei.c                   |    2 +-
 fs/ext4/namei.c                   |    2 +-
 fs/fat/namei_msdos.c              |    3 +--
 fs/fat/namei_vfat.c               |    3 +--
 fs/freevxfs/vxfs_lookup.c         |    5 ++---
 fs/fuse/dir.c                     |    3 +--
 fs/gfs2/inode.c                   |    4 +---
 fs/hfs/dir.c                      |    3 +--
 fs/hfs/inode.c                    |    3 +--
 fs/hfsplus/dir.c                  |    3 +--
 fs/hfsplus/inode.c                |    2 +-
 fs/hostfs/hostfs_kern.c           |    3 +--
 fs/hpfs/dir.c                     |    2 +-
 fs/hpfs/hpfs_fn.h                 |    2 +-
 fs/hppfs/hppfs.c                  |    3 +--
 fs/isofs/isofs.h                  |    2 +-
 fs/isofs/namei.c                  |    2 +-
 fs/jffs2/dir.c                    |    6 ++----
 fs/jfs/namei.c                    |    2 +-
 fs/libfs.c                        |    2 +-
 fs/logfs/dir.c                    |    3 +--
 fs/minix/namei.c                  |    2 +-
 fs/namei.c                        |   11 +++++------
 fs/ncpfs/dir.c                    |    4 ++--
 fs/nfs/dir.c                      |    4 ++--
 fs/nilfs2/namei.c                 |    3 +--
 fs/ntfs/namei.c                   |    4 +---
 fs/ocfs2/namei.c                  |    3 +--
 fs/omfs/dir.c                     |    3 +--
 fs/openpromfs/inode.c             |    5 +++--
 fs/proc/base.c                    |   22 ++++++++++++----------
 fs/proc/generic.c                 |    3 +--
 fs/proc/internal.h                |    4 ++--
 fs/proc/namespaces.c              |    2 +-
 fs/proc/proc_net.c                |    2 +-
 fs/proc/proc_sysctl.c             |    3 +--
 fs/proc/root.c                    |    9 ++++-----
 fs/qnx4/namei.c                   |    2 +-
 fs/qnx4/qnx4.h                    |    2 +-
 fs/reiserfs/namei.c               |    3 +--
 fs/romfs/super.c                  |    3 +--
 fs/squashfs/namei.c               |    3 +--
 fs/sysfs/dir.c                    |    3 +--
 fs/sysv/namei.c                   |    2 +-
 fs/ubifs/dir.c                    |    3 +--
 fs/udf/namei.c                    |    3 +--
 fs/ufs/namei.c                    |    2 +-
 fs/xfs/xfs_iops.c                 |    6 ++----
 include/linux/fs.h                |    4 ++--
 kernel/cgroup.c                   |    4 ++--
 75 files changed, 112 insertions(+), 159 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4fca82e..636eb0b 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -38,8 +38,7 @@ d_manage:	no		no		yes (ref-walk)	maybe
 --------------------------- inode_operations --------------------------- 
 prototypes:
 	int (*create) (struct inode *,struct dentry *,umode_t, struct nameidata *);
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameid
-ata *);
+	struct dentry * (*lookup) (struct inode *,struct dentry *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..647307f 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -342,7 +342,7 @@ filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *, umode_t, struct nameidata *);
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	struct dentry * (*lookup) (struct inode *,struct dentry *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index e78956c..cb28298 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -143,8 +143,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
 extern void v9fs_session_close(struct v9fs_session_info *v9ses);
 extern void v9fs_session_cancel(struct v9fs_session_info *v9ses);
 extern void v9fs_session_begin_cancel(struct v9fs_session_info *v9ses);
-extern struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
-			struct nameidata *nameidata);
+extern struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry);
 extern int v9fs_vfs_unlink(struct inode *i, struct dentry *d);
 extern int v9fs_vfs_rmdir(struct inode *i, struct dentry *d);
 extern int v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3d526a7..6883765 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -830,12 +830,10 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
  * v9fs_vfs_lookup - VFS lookup hook to "walk" to a new inode
  * @dir:  inode that is being walked from
  * @dentry: dentry that is being walked to?
- * @nameidata: path data
  *
  */
 
-struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nameidata)
+struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *res;
 	struct super_block *sb;
@@ -845,8 +843,8 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	char *name;
 	int result = 0;
 
-	p9_debug(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
-		 dir, dentry->d_name.name, dentry, nameidata);
+	p9_debug(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p\n",
+		 dir, dentry->d_name.name, dentry);
 
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 3d83075a..9314d8d 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -266,7 +266,7 @@ const struct dentry_operations adfs_dentry_operations = {
 };
 
 static struct dentry *
-adfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+adfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	struct object_info obj;
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index e0fca52..9b698c8 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -154,7 +154,7 @@ extern void	affs_free_bitmap(struct super_block *sb);
 /* namei.c */
 
 extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
-extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *);
+extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry);
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
 extern int	affs_create(struct inode *dir, struct dentry *dentry,
 			    umode_t mode);
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 3ad7695..886f4d2 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -211,7 +211,7 @@ affs_find_entry(struct inode *dir, struct dentry *dentry)
 }
 
 struct dentry *
-affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+affs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct super_block *sb = dir->i_sb;
 	struct buffer_head *bh;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index ea254ab..853e9ca 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -19,8 +19,7 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd);
+static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry);
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
@@ -514,8 +513,7 @@ out:
 /*
  * look up an entry in a directory
  */
-static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct afs_vnode *vnode;
 	struct afs_fid fid;
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 8f4ce26..fa15077 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -21,8 +21,7 @@
 
 
 static struct dentry *afs_mntpt_lookup(struct inode *dir,
-				       struct dentry *dentry,
-				       struct nameidata *nd);
+				       struct dentry *dentry);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
@@ -102,9 +101,7 @@ out:
 /*
  * no valid lookup procedure on this sort of dir
  */
-static struct dentry *afs_mntpt_lookup(struct inode *dir,
-				       struct dentry *dentry,
-				       struct nameidata *nd)
+static struct dentry *afs_mntpt_lookup(struct inode *dir, struct dentry *dentry)
 {
 	_enter("%p,%p{%p{%s},%s}",
 	       dir,
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 75e5f1c..43ccbc5 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -32,7 +32,7 @@ static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
 static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 #endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
+static struct dentry *autofs4_lookup(struct inode *, struct dentry *);
 static struct vfsmount *autofs4_d_automount(struct path *);
 static int autofs4_d_manage(struct dentry *, bool);
 static void autofs4_dentry_release(struct dentry *);
@@ -458,7 +458,7 @@ int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 9fc0eab..8f76ebf 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -178,8 +178,7 @@ static int bad_inode_create(struct inode *dir, struct dentry *dentry,
 	return -EIO;
 }
 
-static struct dentry *bad_inode_lookup(struct inode *dir,
-			struct dentry *dentry, struct nameidata *nd)
+static struct dentry *bad_inode_lookup(struct inode *dir, struct dentry *dentry)
 {
 	return ERR_PTR(-EIO);
 }
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 6e6d536..1c2e50f 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -34,7 +34,7 @@ static int befs_readdir(struct file *, void *, filldir_t);
 static int befs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 static int befs_readpage(struct file *file, struct page *page);
 static sector_t befs_bmap(struct address_space *mapping, sector_t block);
-static struct dentry *befs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *befs_lookup(struct inode *, struct dentry *);
 static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
@@ -159,7 +159,7 @@ befs_get_block(struct inode *inode, sector_t block,
 }
 
 static struct dentry *
-befs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+befs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index e9a3937..4322fc7 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -131,8 +131,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return 0;
 }
 
-static struct dentry *bfs_lookup(struct inode *dir, struct dentry *dentry,
-						struct nameidata *nd)
+static struct dentry *bfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	struct buffer_head *bh;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a5b0fb5..2514364 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4007,8 +4007,7 @@ static void btrfs_dentry_release(struct dentry *dentry)
 		kfree(dentry->d_fsdata);
 }
 
-static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *ret;
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 62b10e7..17f984f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -575,8 +575,7 @@ static int is_root_ceph_dentry(struct inode *inode, struct dentry *dentry)
  * Look up a single dir entry.  If there is a lookup intent, inform
  * the MDS so that it gets our 'caps wanted' value in a single op.
  */
-static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
@@ -640,7 +639,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
  */
 int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry)
 {
-	struct dentry *result = ceph_lookup(dir, dentry, NULL);
+	struct dentry *result = ceph_lookup(dir, dentry);
 
 	if (result && !IS_ERR(result)) {
 		/*
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 16aa162..2cfd0f4 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -47,8 +47,7 @@ extern struct inode *cifs_root_iget(struct super_block *);
 extern struct file *cifs_atomic_open(struct inode *, struct dentry *,
 				     struct opendata *, unsigned, umode_t,
 				     bool *);
-extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
-				  struct nameidata *);
+extern struct dentry *cifs_lookup(struct inode *, struct dentry *);
 extern int cifs_unlink(struct inode *dir, struct dentry *dentry);
 extern int cifs_hardlink(struct dentry *, struct inode *, struct dentry *);
 extern int cifs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 507cc67..57212c9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -534,8 +534,7 @@ mknod_out:
 }
 
 struct dentry *
-cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
-	    struct nameidata *nd)
+cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry)
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index e8d02b9..025c174 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -31,7 +31,7 @@
 
 /* dir inode-ops */
 static int coda_create(struct inode *dir, struct dentry *new, umode_t mode);
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, struct nameidata *nd);
+static struct dentry *coda_lookup(struct inode *dir, struct dentry *target);
 static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
 		     struct dentry *entry);
 static int coda_unlink(struct inode *dir_inode, struct dentry *entry);
@@ -94,7 +94,7 @@ const struct file_operations coda_dir_operations = {
 
 /* inode operations for directories */
 /* access routines: lookup, readlink, permission */
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struct nameidata *nd)
+static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry)
 {
 	struct super_block *sb = dir->i_sb;
 	const char *name = entry->d_name.name;
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5ddd7eb..2c09ae6 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -450,9 +450,7 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 	return 0;
 }
 
-static struct dentry * configfs_lookup(struct inode *dir,
-				       struct dentry *dentry,
-				       struct nameidata *nd)
+static struct dentry *configfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct configfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct configfs_dirent * sd;
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a2ee8f9..53a5135 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -419,7 +419,7 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 /*
  * Lookup and fill in the inode data..
  */
-static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *cramfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	unsigned int offset = 0;
 	struct inode *inode = NULL;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 8371f06..0e3fa4c 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -366,14 +366,12 @@ static int ecryptfs_lookup_interpose(struct dentry *dentry,
  * ecryptfs_lookup
  * @ecryptfs_dir_inode: The eCryptfs directory inode
  * @ecryptfs_dentry: The eCryptfs dentry that we are looking up
- * @ecryptfs_nd: nameidata; may be NULL
  *
  * Find a file on disk. If the file does not exist, then we'll add it to the
  * dentry cache and continue on to read it from the disk.
  */
 static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
-				      struct dentry *ecryptfs_dentry,
-				      struct nameidata *ecryptfs_nd)
+				      struct dentry *ecryptfs_dentry)
 {
 	char *encrypted_and_encoded_name = NULL;
 	size_t encrypted_and_encoded_name_size;
diff --git a/fs/efs/efs.h b/fs/efs/efs.h
index d8305b5..2729b33 100644
--- a/fs/efs/efs.h
+++ b/fs/efs/efs.h
@@ -129,7 +129,7 @@ extern struct inode *efs_iget(struct super_block *, unsigned long);
 extern efs_block_t efs_map_block(struct inode *, efs_block_t);
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
-extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *efs_lookup(struct inode *, struct dentry *);
 extern struct dentry *efs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 		int fh_len, int fh_type);
 extern struct dentry *efs_fh_to_parent(struct super_block *sb, struct fid *fid,
diff --git a/fs/efs/namei.c b/fs/efs/namei.c
index 832b10d..ee1f261 100644
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -58,7 +58,8 @@ static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
 	return(0);
 }
 
-struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd) {
+struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry)
+{
 	efs_ino_t inodenum;
 	struct inode *inode = NULL;
 
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 570845b..4c77014 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -45,8 +45,7 @@ static inline int exofs_add_nondir(struct dentry *dentry, struct inode *inode)
 	return err;
 }
 
-static struct dentry *exofs_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *exofs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
 	ino_t ino;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index a39f4c4..0fc69a6 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -55,7 +55,7 @@ static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
  * Methods themselves.
  */
 
-static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext2_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode * inode;
 	ino_t ino;
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index af7adfc..d7803b0 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1023,7 +1023,7 @@ errout:
 	return NULL;
 }
 
-static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext3_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode * inode;
 	struct ext3_dir_entry_2 * de;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 20f9a13..380b7b2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1019,7 +1019,7 @@ errout:
 	return NULL;
 }
 
-static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
 	struct ext4_dir_entry_2 *de;
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c854101..c6fa9c9 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -200,8 +200,7 @@ static const struct dentry_operations msdos_dentry_operations = {
  */
 
 /***** Get inode using directory and name */
-static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 39e810f..fe45623 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -724,8 +724,7 @@ static int vfat_d_anon_disconn(struct dentry *dentry)
 	return IS_ROOT(dentry) && (dentry->d_flags & DCACHE_DISCONNECTED);
 }
 
-static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index 3360f1e..9eec2b4 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -48,7 +48,7 @@
 #define VXFS_BLOCK_PER_PAGE(sbp)  ((PAGE_CACHE_SIZE / (sbp)->s_blocksize))
 
 
-static struct dentry *	vxfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry	*vxfs_lookup(struct inode *, struct dentry *);
 static int		vxfs_readdir(struct file *, void *, filldir_t);
 
 const struct inode_operations vxfs_dir_inode_ops = {
@@ -192,7 +192,6 @@ vxfs_inode_by_name(struct inode *dip, struct dentry *dp)
  * vxfs_lookup - lookup pathname component
  * @dip:	dir in which we lookup
  * @dp:		dentry we lookup
- * @nd:		lookup nameidata
  *
  * Description:
  *   vxfs_lookup tries to lookup the pathname component described
@@ -203,7 +202,7 @@ vxfs_inode_by_name(struct inode *dip, struct dentry *dp)
  *   in the return pointer.
  */
 static struct dentry *
-vxfs_lookup(struct inode *dip, struct dentry *dp, struct nameidata *nd)
+vxfs_lookup(struct inode *dip, struct dentry *dp)
 {
 	struct inode		*ip = NULL;
 	ino_t			ino;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 584385e..cf0e470 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -315,8 +315,7 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 	return err;
 }
 
-static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
-				  struct nameidata *nd)
+static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry)
 {
 	int err;
 	struct fuse_entry_out outarg;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 203ec3c..d1820e5 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -775,15 +775,13 @@ static struct file *gfs2_create(struct inode *dir, struct dentry *dentry,
  * gfs2_lookup - Look up a filename in a directory and return its inode
  * @dir: The directory inode
  * @dentry: The dentry of the new inode
- * @nd: passed from Linux VFS, ignored by us
  *
  * Called by the VFS layer. Lock dir and call gfs2_lookupi()
  *
  * Returns: errno
  */
 
-static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = gfs2_lookupi(dir, &dentry->d_name, 0);
 	if (inode && !IS_ERR(inode)) {
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index ba125c1..ee6b6f2 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -17,8 +17,7 @@
 /*
  * hfs_lookup()
  */
-static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	hfs_cat_rec rec;
 	struct hfs_find_data fd;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 737dbeb..c649d1a 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -488,8 +488,7 @@ out:
 	return 0;
 }
 
-static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	hfs_cat_rec rec;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index bfb2ad8..03bd823 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -24,8 +24,7 @@ static inline void hfsplus_instantiate(struct dentry *dentry,
 }
 
 /* Find the entry inside dir named dentry->d_name */
-static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry,
-				     struct nameidata *nd)
+static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	struct hfs_find_data fd;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6643b24..8edd486 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -168,7 +168,7 @@ const struct dentry_operations hfsplus_dentry_operations = {
 };
 
 static struct dentry *hfsplus_file_lookup(struct inode *dir,
-		struct dentry *dentry, struct nameidata *nd)
+					  struct dentry *dentry)
 {
 	struct hfs_find_data fd;
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index a3d2242..6f6985b 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -592,8 +592,7 @@ static int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return error;
 }
 
-struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
-			     struct nameidata *nd)
+static struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry)
 {
 	struct inode *inode;
 	char *name;
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 2fa0089..087afbf 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -189,7 +189,7 @@ out:
  *	      to tell read_inode to read fnode or not.
  */
 
-struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	const unsigned char *name = dentry->d_name.name;
 	unsigned len = dentry->d_name.len;
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index de94617..eb08076 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -227,7 +227,7 @@ extern const struct dentry_operations hpfs_dentry_operations;
 
 /* dir.c */
 
-struct dentry *hpfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+struct dentry *hpfs_lookup(struct inode *, struct dentry *);
 extern const struct file_operations hpfs_dir_ops;
 
 /* dnode.c */
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index d92f4ce..90b94e6 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -137,8 +137,7 @@ static int file_removed(struct dentry *dentry, const char *file)
 	return 0;
 }
 
-static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry)
 {
 	struct dentry *proc_dentry, *parent;
 	struct qstr *name = &dentry->d_name;
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 0e73f63..c0589a4 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -114,7 +114,7 @@ extern int isofs_name_translate(struct iso_directory_record *, char *, struct in
 int get_joliet_filename(struct iso_directory_record *, unsigned char *, struct inode *);
 int get_acorn_filename(struct iso_directory_record *, char *, struct inode *);
 
-extern struct dentry *isofs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *isofs_lookup(struct inode *, struct dentry *);
 extern struct buffer_head *isofs_bread(struct inode *, sector_t);
 extern int isofs_get_blocks(struct inode *, sector_t, struct buffer_head **, unsigned long);
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 1e2946f..3d6e214 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -163,7 +163,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 	return 0;
 }
 
-struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	int found;
 	unsigned long uninitialized_var(block);
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 099dd6a..0c3a2b8 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -23,8 +23,7 @@
 static int jffs2_readdir (struct file *, void *, filldir_t);
 
 static int jffs2_create(struct inode *, struct dentry *, umode_t);
-static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
-				    struct nameidata *);
+static struct dentry *jffs2_lookup(struct inode *, struct dentry *);
 static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
 static int jffs2_unlink (struct inode *,struct dentry *);
 static int jffs2_symlink (struct inode *,struct dentry *,const char *);
@@ -70,8 +69,7 @@ const struct inode_operations jffs2_dir_inode_operations =
    and we use the same hash function as the dentries. Makes this
    nice and simple
 */
-static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
-				   struct nameidata *nd)
+static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target)
 {
 	struct jffs2_inode_info *dir_f;
 	struct jffs2_full_dirent *fd = NULL, *fd_list;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 423c520..2c1ce6b 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1447,7 +1447,7 @@ static int jfs_mknod(struct inode *dir, struct dentry *dentry,
 	return rc;
 }
 
-static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry)
 {
 	struct btstack btstack;
 	ino_t inum;
diff --git a/fs/libfs.c b/fs/libfs.c
index 5b2dbb3..2654564 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -53,7 +53,7 @@ static int simple_delete_dentry(const struct dentry *dentry)
  * Lookup the data. This is trivial - if the dentry didn't already
  * exist, we know it is negative.  Set d_op to delete negative dentries.
  */
-struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry)
 {
 	static const struct dentry_operations simple_dentry_operations = {
 		.d_delete = simple_delete_dentry,
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 33556ae..a748d02 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -348,8 +348,7 @@ static void logfs_set_name(struct logfs_disk_dentry *dd, struct qstr *name)
 	memcpy(dd->name, name->name, name->len);
 }
 
-static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry,
-		struct nameidata *nd)
+static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct page *page;
 	struct logfs_disk_dentry *dd;
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 2ec09bb..ea5585a 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -18,7 +18,7 @@ static int add_nondir(struct dentry *dentry, struct inode *inode)
 	return err;
 }
 
-static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *minix_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
diff --git a/fs/namei.c b/fs/namei.c
index 3e3652c..5d821ff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1094,8 +1094,7 @@ static struct dentry *lookup_dcache(struct qstr *name, struct dentry *dir,
  *
  * dir->d_inode->i_mutex must be held
  */
-static struct dentry *lookup_real(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+static struct dentry *lookup_real(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *old;
 
@@ -1105,7 +1104,7 @@ static struct dentry *lookup_real(struct inode *dir, struct dentry *dentry,
 		return ERR_PTR(-ENOENT);
 	}
 
-	old = dir->i_op->lookup(dir, dentry, nd);
+	old = dir->i_op->lookup(dir, dentry);
 	if (unlikely(old)) {
 		dput(dentry);
 		dentry = old;
@@ -1123,7 +1122,7 @@ static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
 	if (IS_ERR(dentry) || !need_lookup)
 		return dentry;
 
-	return lookup_real(base->d_inode, dentry, nd);
+	return lookup_real(base->d_inode, dentry);
 }
 
 /*
@@ -2313,7 +2312,7 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 	if (need_lookup) {
 		BUG_ON(dentry->d_inode);
 
-		dentry = lookup_real(dir_inode, dentry, nd);
+		dentry = lookup_real(dir_inode, dentry);
 		if (IS_ERR(dentry))
 			return ERR_CAST(dentry);
 
@@ -2736,7 +2735,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	if (need_lookup) {
 		struct inode *dir = nd.path.dentry->d_inode;
 		if (!(dir->i_sb->s_type->fs_flags & FS_SKIP_LOOKUP_EXCL)) {
-			dentry = lookup_real(dir, dentry, &nd);
+			dentry = lookup_real(dir, dentry);
 			if (IS_ERR(dentry))
 				goto fail;
 		}
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 34eeb46..119c0b0 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -31,7 +31,7 @@ static void ncp_do_readdir(struct file *, void *, filldir_t,
 static int ncp_readdir(struct file *, void *, filldir_t);
 
 static int ncp_create(struct inode *, struct dentry *, umode_t);
-static struct dentry *ncp_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *ncp_lookup(struct inode *, struct dentry *);
 static int ncp_unlink(struct inode *, struct dentry *);
 static int ncp_mkdir(struct inode *, struct dentry *, umode_t);
 static int ncp_rmdir(struct inode *, struct dentry *);
@@ -836,7 +836,7 @@ out:
 	return result;
 }
 
-static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct ncp_server *server = NCP_SERVER(dir);
 	struct inode *inode = NULL;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2b91cf3..9125230 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -46,7 +46,7 @@
 static int nfs_opendir(struct inode *, struct file *);
 static int nfs_closedir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
-static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *nfs_lookup(struct inode *, struct dentry *);
 static struct file *nfs_create(struct inode *, struct dentry *,
 			       struct opendata *, unsigned, umode_t);
 static int nfs_mkdir(struct inode *, struct dentry *, umode_t);
@@ -1269,7 +1269,7 @@ const struct dentry_operations nfs_dentry_operations = {
 	.d_release	= nfs_d_release,
 };
 
-static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *nfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *res;
 	struct dentry *parent;
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ebde465..26f703a 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -62,8 +62,7 @@ static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
  * Methods themselves.
  */
 
-static struct dentry *
-nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *nilfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode;
 	ino_t ino;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 358273e..8f788ec 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -35,7 +35,6 @@
  * ntfs_lookup - find the inode represented by a dentry in a directory inode
  * @dir_ino:	directory inode in which to look for the inode
  * @dent:	dentry representing the inode to look for
- * @nd:		lookup nameidata
  *
  * In short, ntfs_lookup() looks for the inode represented by the dentry @dent
  * in the directory inode @dir_ino and if found attaches the inode to the
@@ -100,8 +99,7 @@
  *
  * Locking: Caller must hold i_mutex on the directory.
  */
-static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
-		struct nameidata *nd)
+static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent)
 {
 	ntfs_volume *vol = NTFS_SB(dir_ino->i_sb);
 	struct inode *dent_inode;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0ef9de8..634be51 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -97,8 +97,7 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
 
-static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry)
 {
 	int status;
 	u64 blkno;
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index d1aa51d..c4b5a5e 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -289,8 +289,7 @@ static int omfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return omfs_add_node(dir, dentry, mode | S_IFREG);
 }
 
-static struct dentry *omfs_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+static struct dentry *omfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct buffer_head *bh;
 	struct inode *inode = NULL;
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index a88c03b..5ea1c81 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -170,13 +170,14 @@ static const struct file_operations openprom_operations = {
 	.llseek		= generic_file_llseek,
 };
 
-static struct dentry *openpromfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *openpromfs_lookup(struct inode *, struct dentry *);
 
 static const struct inode_operations openprom_inode_operations = {
 	.lookup		= openpromfs_lookup,
 };
 
-static struct dentry *openpromfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *openpromfs_lookup(struct inode *dir,
+					struct dentry *dentry)
 {
 	struct op_inode_info *ent_oi, *oi = OP_I(dir);
 	struct device_node *dp, *child;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..05d768d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1967,8 +1967,7 @@ out_no_task:
 	return retval;
 }
 
-static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
-				    struct nameidata *nd)
+static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate);
 }
@@ -2160,7 +2159,7 @@ proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 }
 
 static struct dentry *proc_map_files_lookup(struct inode *dir,
-		struct dentry *dentry, struct nameidata *nd)
+					    struct dentry *dentry)
 {
 	unsigned long vm_start, vm_end;
 	struct vm_area_struct *vma;
@@ -2398,8 +2397,7 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 }
 
 static struct dentry *proc_lookupfdinfo(struct inode *dir,
-					struct dentry *dentry,
-					struct nameidata *nd)
+					struct dentry *dentry)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate);
 }
@@ -2649,7 +2647,7 @@ static const struct file_operations proc_attr_dir_operations = {
 };
 
 static struct dentry *proc_attr_dir_lookup(struct inode *dir,
-				struct dentry *dentry, struct nameidata *nd)
+					   struct dentry *dentry)
 {
 	return proc_pident_lookup(dir, dentry,
 				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
@@ -3061,7 +3059,9 @@ static const struct file_operations proc_tgid_base_operations = {
 	.llseek		= default_llseek,
 };
 
-static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tgid_base_lookup(struct inode *dir,
+					    struct dentry *dentry)
+{
 	return proc_pident_lookup(dir, dentry,
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
@@ -3190,7 +3190,7 @@ out:
 	return error;
 }
 
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+struct dentry *proc_pid_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *result;
 	struct task_struct *task;
@@ -3410,7 +3410,9 @@ static int proc_tid_base_readdir(struct file * filp,
 				   tid_base_stuff,ARRAY_SIZE(tid_base_stuff));
 }
 
-static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tid_base_lookup(struct inode *dir,
+					   struct dentry *dentry)
+{
 	return proc_pident_lookup(dir, dentry,
 				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
 }
@@ -3454,7 +3456,7 @@ out:
 	return error;
 }
 
-static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_task_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 2edf34f..7db4387 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -445,8 +445,7 @@ out_unlock:
 	return ERR_PTR(error);
 }
 
-struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
-		struct nameidata *nd)
+struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry)
 {
 	return proc_lookup_de(PDE(dir), dir, dentry);
 }
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2925775..03ca6b7 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -101,7 +101,7 @@ void pde_users_dec(struct proc_dir_entry *pde);
 
 extern spinlock_t proc_subdir_lock;
 
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
+struct dentry *proc_pid_lookup(struct inode *dir, struct dentry *dentry);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 unsigned long task_statm(struct mm_struct *,
@@ -127,7 +127,7 @@ int proc_remount(struct super_block *sb, int *flags, char *data);
  * of the /proc/<pid> subdirectories.
  */
 int proc_readdir(struct file *, void *, filldir_t);
-struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+struct dentry *proc_lookup(struct inode *, struct dentry *);
 
 
 
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 27da860..7962651 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -140,7 +140,7 @@ const struct file_operations proc_ns_dir_operations = {
 };
 
 static struct dentry *proc_ns_dir_lookup(struct inode *dir,
-				struct dentry *dentry, struct nameidata *nd)
+					 struct dentry *dentry)
 {
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 06e1cc1..aa3c10d 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -119,7 +119,7 @@ static struct net *get_proc_task_net(struct inode *dir)
 }
 
 static struct dentry *proc_tgid_net_lookup(struct inode *dir,
-		struct dentry *dentry, struct nameidata *nd)
+					   struct dentry *dentry)
 {
 	struct dentry *de;
 	struct net *net;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index a6b6217..e0c4d31 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -86,8 +86,7 @@ static struct ctl_table_header *grab_header(struct inode *inode)
 		return sysctl_head_next(NULL);
 }
 
-static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
-					struct nameidata *nd)
+static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct ctl_table_header *head = grab_header(dir);
 	struct ctl_table *table = PROC_I(dir)->sysctl_entry;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 46a15d8..2ad8a08 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -199,13 +199,12 @@ static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 	return 0;
 }
 
-static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_root_lookup(struct inode *dir, struct dentry *dentry)
 {
-	if (!proc_lookup(dir, dentry, nd)) {
+	if (!proc_lookup(dir, dentry))
 		return NULL;
-	}
-	
-	return proc_pid_lookup(dir, dentry, nd);
+
+	return proc_pid_lookup(dir, dentry);
 }
 
 static int proc_root_readdir(struct file * filp,
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index 275327b..42bd979 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -98,7 +98,7 @@ static struct buffer_head *qnx4_find_entry(int len, struct inode *dir,
 	return NULL;
 }
 
-struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry)
 {
 	int ino;
 	struct qnx4_inode_entry *de;
diff --git a/fs/qnx4/qnx4.h b/fs/qnx4/qnx4.h
index 33a6085..12003ec 100644
--- a/fs/qnx4/qnx4.h
+++ b/fs/qnx4/qnx4.h
@@ -23,7 +23,7 @@ struct qnx4_inode_info {
 };
 
 extern struct inode *qnx4_iget(struct super_block *, unsigned long);
-extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd);
+extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry);
 extern unsigned long qnx4_count_free_blocks(struct super_block *sb);
 extern unsigned long qnx4_block_map(struct inode *inode, long iblock);
 
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 044120c..d377f38 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -321,8 +321,7 @@ static int reiserfs_find_entry(struct inode *dir, const char *name, int namelen,
 	}			/* while (1) */
 }
 
-static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
 	int lock_depth;
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index bb36ab7..baeeb46 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -209,8 +209,7 @@ out:
 /*
  * look up an entry in a directory
  */
-static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	unsigned long offset, maxoff;
 	struct inode *inode;
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 0682b38..efd8612 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -133,8 +133,7 @@ out:
 }
 
 
-static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	const unsigned char *name = dentry->d_name.name;
 	int len = dentry->d_name.len;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7fdf6a7..a079d23 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -724,8 +724,7 @@ int sysfs_create_dir(struct kobject * kobj)
 	return error;
 }
 
-static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
-				struct nameidata *nd)
+static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *ret = NULL;
 	struct dentry *parent = dentry->d_parent;
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 9fd62a4..13fd282 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -43,7 +43,7 @@ const struct dentry_operations sysv_dentry_operations = {
 	.d_hash		= sysv_hash,
 };
 
-static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *sysv_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 90adfaf..c50109d 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -191,8 +191,7 @@ static int dbg_check_name(const struct ubifs_info *c,
 
 #endif
 
-static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	int err;
 	union ubifs_key key;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index c96f1a7..8c3baf4 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -252,8 +252,7 @@ out_ok:
 	return fi;
 }
 
-static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = NULL;
 	struct fileIdentDesc cfi;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index ca6c710..b747bb6 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -46,7 +46,7 @@ static inline int ufs_add_nondir(struct dentry *dentry, struct inode *inode)
 	return err;
 }
 
-static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ufs_lookup(struct inode *dir, struct dentry *dentry)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 66810ac..8c1bf879 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -248,8 +248,7 @@ xfs_vn_mkdir(
 STATIC struct dentry *
 xfs_vn_lookup(
 	struct inode	*dir,
-	struct dentry	*dentry,
-	struct nameidata *nd)
+	struct dentry	*dentry)
 {
 	struct xfs_inode *cip;
 	struct xfs_name	name;
@@ -273,8 +272,7 @@ xfs_vn_lookup(
 STATIC struct dentry *
 xfs_vn_ci_lookup(
 	struct inode	*dir,
-	struct dentry	*dentry,
-	struct nameidata *nd)
+	struct dentry	*dentry)
 {
 	struct xfs_inode *ip;
 	struct xfs_name	xname;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a5e0d3..8cfe7bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1630,7 +1630,7 @@ struct file_operations {
 };
 
 struct inode_operations {
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	struct dentry * (*lookup) (struct inode *, struct dentry *);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	int (*permission) (struct inode *, int);
 	struct posix_acl * (*get_acl)(struct inode *, int);
@@ -2537,7 +2537,7 @@ extern int simple_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata);
 
-extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *simple_lookup(struct inode *, struct dentry *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..a284d08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -778,7 +778,7 @@ EXPORT_SYMBOL_GPL(cgroup_unlock);
  */
 
 static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
-static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *cgroup_lookup(struct inode *, struct dentry *);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
 static const struct inode_operations cgroup_dir_inode_operations;
@@ -2606,7 +2606,7 @@ static const struct inode_operations cgroup_dir_inode_operations = {
 	.rename = cgroup_rename,
 };
 
-static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry)
 {
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
-- 
1.7.7

