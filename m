Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab1J1MOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:14:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1J1MOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:14:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 10/13] filesystems: add set_nlink()
Date: Fri, 28 Oct 2011 14:13:29 +0200
Message-Id: <1319804012-16346-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace remaining direct i_nlink updates with a new set_nlink()
updater function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 arch/s390/hypfs/inode.c          |    2 +-
 drivers/staging/pohmelfs/inode.c |    2 +-
 fs/9p/vfs_inode.c                |    4 ++--
 fs/9p/vfs_inode_dotl.c           |    4 ++--
 fs/adfs/inode.c                  |    2 +-
 fs/affs/amigaffs.c               |    2 +-
 fs/affs/inode.c                  |    8 ++++----
 fs/afs/fsclient.c                |    2 +-
 fs/afs/inode.c                   |    4 ++--
 fs/autofs4/inode.c               |    2 +-
 fs/befs/linuxvfs.c               |    2 +-
 fs/bfs/dir.c                     |    2 +-
 fs/bfs/inode.c                   |    2 +-
 fs/btrfs/delayed-inode.c         |    2 +-
 fs/btrfs/disk-io.c               |    2 +-
 fs/btrfs/inode.c                 |    4 ++--
 fs/btrfs/tree-log.c              |    2 +-
 fs/ceph/caps.c                   |    2 +-
 fs/ceph/inode.c                  |    2 +-
 fs/cifs/inode.c                  |    6 +++---
 fs/coda/coda_linux.c             |    2 +-
 fs/devpts/inode.c                |    2 +-
 fs/ecryptfs/inode.c              |   12 ++++++------
 fs/efs/inode.c                   |    2 +-
 fs/exofs/inode.c                 |    2 +-
 fs/ext2/inode.c                  |    2 +-
 fs/ext3/inode.c                  |    2 +-
 fs/ext3/namei.c                  |    4 ++--
 fs/ext4/inode.c                  |    2 +-
 fs/ext4/namei.c                  |    6 +++---
 fs/fat/inode.c                   |    4 ++--
 fs/fat/namei_msdos.c             |    2 +-
 fs/fat/namei_vfat.c              |    2 +-
 fs/freevxfs/vxfs_inode.c         |    2 +-
 fs/fuse/control.c                |    2 +-
 fs/fuse/inode.c                  |    2 +-
 fs/gfs2/glops.c                  |    2 +-
 fs/hfs/inode.c                   |    4 ++--
 fs/hfsplus/inode.c               |   10 +++++-----
 fs/hostfs/hostfs_kern.c          |    2 +-
 fs/hpfs/dir.c                    |    2 +-
 fs/hpfs/inode.c                  |    8 ++++----
 fs/hpfs/namei.c                  |    8 ++++----
 fs/hppfs/hppfs.c                 |    2 +-
 fs/isofs/inode.c                 |    4 ++--
 fs/isofs/rock.c                  |    4 ++--
 fs/jffs2/dir.c                   |    6 +++---
 fs/jffs2/fs.c                    |    6 +++---
 fs/jfs/jfs_imap.c                |    6 +++---
 fs/jfs/namei.c                   |    2 +-
 fs/libfs.c                       |    2 +-
 fs/logfs/readwrite.c             |    2 +-
 fs/minix/inode.c                 |    4 ++--
 fs/ncpfs/inode.c                 |    2 +-
 fs/nfs/inode.c                   |    4 ++--
 fs/nilfs2/inode.c                |    2 +-
 fs/nilfs2/namei.c                |    2 +-
 fs/ntfs/inode.c                  |    8 ++++----
 fs/ocfs2/dir.c                   |    4 ++--
 fs/ocfs2/dlmglue.c               |    2 +-
 fs/ocfs2/inode.c                 |    4 ++--
 fs/ocfs2/namei.c                 |    8 ++++----
 fs/openpromfs/inode.c            |    4 ++--
 fs/proc/base.c                   |   12 ++++++------
 fs/proc/generic.c                |    2 +-
 fs/proc/inode.c                  |    2 +-
 fs/qnx4/inode.c                  |    2 +-
 fs/reiserfs/inode.c              |    6 +++---
 fs/reiserfs/namei.c              |    4 ++--
 fs/romfs/super.c                 |    2 +-
 fs/squashfs/inode.c              |   18 +++++++++---------
 fs/stack.c                       |    2 +-
 fs/sysfs/inode.c                 |    2 +-
 fs/sysv/inode.c                  |    2 +-
 fs/ubifs/super.c                 |    2 +-
 fs/ubifs/xattr.c                 |    2 +-
 fs/udf/inode.c                   |    8 +++++---
 fs/udf/namei.c                   |    4 ++--
 fs/ufs/inode.c                   |    4 ++--
 fs/xfs/xfs_iops.c                |    2 +-
 include/linux/fs.h               |   13 +++++++++++++
 81 files changed, 163 insertions(+), 148 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index baa82f8..481f4f7 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -108,7 +108,7 @@ static struct inode *hypfs_make_inode(struct super_block *sb, int mode)
 		ret->i_gid = hypfs_info->gid;
 		ret->i_atime = ret->i_mtime = ret->i_ctime = CURRENT_TIME;
 		if (mode & S_IFDIR)
-			ret->i_nlink = 2;
+			set_nlink(ret, 2);
 	}
 	return ret;
 }
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index f3c6060..7a19555 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1197,7 +1197,7 @@ const struct inode_operations pohmelfs_file_inode_operations = {
 void pohmelfs_fill_inode(struct inode *inode, struct netfs_inode_info *info)
 {
 	inode->i_mode = info->mode;
-	inode->i_nlink = info->nlink;
+	set_nlink(inode, info->nlink);
 	inode->i_uid = info->uid;
 	inode->i_gid = info->gid;
 	inode->i_blocks = info->blocks;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b5a1076..879ed88 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1138,7 +1138,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 
 	inode->i_atime.tv_sec = stat->atime;
 	inode->i_mtime.tv_sec = stat->mtime;
@@ -1164,7 +1164,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 			/* HARDLINKCOUNT %u */
 			sscanf(ext, "%13s %u", tag_name, &i_nlink);
 			if (!strncmp(tag_name, "HARDLINKCOUNT", 13))
-				inode->i_nlink = i_nlink;
+				set_nlink(inode, i_nlink);
 		}
 	}
 	mode = stat->mode & S_IALLUGO;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index aded79f..0b5745e 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -606,7 +606,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 		inode->i_ctime.tv_nsec = stat->st_ctime_nsec;
 		inode->i_uid = stat->st_uid;
 		inode->i_gid = stat->st_gid;
-		inode->i_nlink = stat->st_nlink;
+		set_nlink(inode, stat->st_nlink);
 
 		mode = stat->st_mode & S_IALLUGO;
 		mode |= inode->i_mode & ~S_IALLUGO;
@@ -632,7 +632,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 		if (stat->st_result_mask & P9_STATS_GID)
 			inode->i_gid = stat->st_gid;
 		if (stat->st_result_mask & P9_STATS_NLINK)
-			inode->i_nlink = stat->st_nlink;
+			set_nlink(inode, stat->st_nlink);
 		if (stat->st_result_mask & P9_STATS_MODE) {
 			inode->i_mode = stat->st_mode;
 			if ((S_ISBLK(inode->i_mode)) ||
diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index d5250c5..1dab6a1 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -247,7 +247,7 @@ adfs_iget(struct super_block *sb, struct object_info *obj)
 	inode->i_gid	 = ADFS_SB(sb)->s_gid;
 	inode->i_ino	 = obj->file_id;
 	inode->i_size	 = obj->size;
-	inode->i_nlink	 = 2;
+	set_nlink(inode, 2);
 	inode->i_blocks	 = (inode->i_size + sb->s_blocksize - 1) >>
 			    sb->s_blocksize_bits;
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 8f12723..de37ec8 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -215,7 +215,7 @@ affs_remove_link(struct dentry *dentry)
 				break;
 			default:
 				if (!AFFS_TAIL(sb, bh)->link_chain)
-					inode->i_nlink = 1;
+					set_nlink(inode, 1);
 			}
 			affs_free_block(sb, link_ino);
 			goto done;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 5d82890..88a4b0b 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -54,7 +54,7 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	prot = be32_to_cpu(tail->protect);
 
 	inode->i_size = 0;
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	inode->i_mode = 0;
 	AFFS_I(inode)->i_extcnt = 1;
 	AFFS_I(inode)->i_ext_last = ~1;
@@ -137,7 +137,7 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 					       sbi->s_hashsize + 1;
 		}
 		if (tail->link_chain)
-			inode->i_nlink = 2;
+			set_nlink(inode, 2);
 		inode->i_mapping->a_ops = (sbi->s_flags & SF_OFS) ? &affs_aops_ofs : &affs_aops;
 		inode->i_op = &affs_file_inode_operations;
 		inode->i_fop = &affs_file_operations;
@@ -304,7 +304,7 @@ affs_new_inode(struct inode *dir)
 	inode->i_uid     = current_fsuid();
 	inode->i_gid     = current_fsgid();
 	inode->i_ino     = block;
-	inode->i_nlink   = 1;
+	set_nlink(inode, 1);
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
@@ -387,7 +387,7 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		AFFS_TAIL(sb, inode_bh)->link_chain = cpu_to_be32(block);
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 		ihold(inode);
 	}
 	affs_fix_checksum(sb, bh);
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 346e328..2f213d1 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -90,7 +90,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 			vnode->vfs_inode.i_uid = status->owner;
 			vnode->vfs_inode.i_gid = status->group;
 			vnode->vfs_inode.i_generation = vnode->fid.unique;
-			vnode->vfs_inode.i_nlink = status->nlink;
+			set_nlink(&vnode->vfs_inode, status->nlink);
 
 			mode = vnode->vfs_inode.i_mode;
 			mode &= ~S_IALLUGO;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 0fdab6e..d890ae3 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -67,7 +67,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 		fscache_attr_changed(vnode->cache);
 #endif
 
-	inode->i_nlink		= vnode->status.nlink;
+	set_nlink(inode, vnode->status.nlink);
 	inode->i_uid		= vnode->status.owner;
 	inode->i_gid		= 0;
 	inode->i_size		= vnode->status.size;
@@ -174,7 +174,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_size		= 0;
 	inode->i_mode		= S_IFDIR | S_IRUGO | S_IXUGO;
 	inode->i_op		= &afs_autocell_inode_operations;
-	inode->i_nlink		= 2;
+	set_nlink(inode, 2);
 	inode->i_uid		= 0;
 	inode->i_gid		= 0;
 	inode->i_ctime.tv_sec	= get_seconds();
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 180fa24..8179f1a 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -342,7 +342,7 @@ struct inode *autofs4_get_inode(struct super_block *sb, mode_t mode)
 	inode->i_ino = get_next_ino();
 
 	if (S_ISDIR(mode)) {
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 		inode->i_op = &autofs4_dir_inode_operations;
 		inode->i_fop = &autofs4_dir_operations;
 	} else if (S_ISLNK(mode)) {
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 720d885..8342ca6 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -357,7 +357,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	inode->i_gid = befs_sb->mount_opts.use_gid ?
 	    befs_sb->mount_opts.gid : (gid_t) fs32_to_cpu(sb, raw_inode->gid);
 
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 
 	/*
 	 * BEFS's time is 64 bits, but current VFS is 32 bits...
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index b14cebf..9cc0740 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -199,7 +199,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		printf("unlinking non-existent file %s:%lu (nlink=%d)\n",
 					inode->i_sb->s_id, inode->i_ino,
 					inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	de->ino = 0;
 	mark_buffer_dirty_inode(bh, dir);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index a8e37f8..697af5b 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -78,7 +78,7 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino);
 	inode->i_uid =  le32_to_cpu(di->i_uid);
 	inode->i_gid =  le32_to_cpu(di->i_gid);
-	inode->i_nlink =  le32_to_cpu(di->i_nlink);
+	set_nlink(inode, le32_to_cpu(di->i_nlink));
 	inode->i_size = BFS_FILESIZE(di);
 	inode->i_blocks = BFS_FILEBLOCKS(di);
 	inode->i_atime.tv_sec =  le32_to_cpu(di->i_atime);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..ae4d9cd 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1641,7 +1641,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	inode->i_gid = btrfs_stack_inode_gid(inode_item);
 	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
 	inode->i_mode = btrfs_stack_inode_mode(inode_item);
-	inode->i_nlink = btrfs_stack_inode_nlink(inode_item);
+	set_nlink(inode, btrfs_stack_inode_nlink(inode_item));
 	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
 	BTRFS_I(inode)->sequence = btrfs_stack_inode_sequence(inode_item);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..07ea918 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1705,7 +1705,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	sb->s_bdi = &fs_info->bdi;
 
 	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
-	fs_info->btree_inode->i_nlink = 1;
+	set_nlink(fs_info->btree_inode, 1);
 	/*
 	 * we set the i_size on the btree inode to the max possible int.
 	 * the real end of the address space is determined by all of
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2d004a..75686a6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2534,7 +2534,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
 	inode->i_mode = btrfs_inode_mode(leaf, inode_item);
-	inode->i_nlink = btrfs_inode_nlink(leaf, inode_item);
+	set_nlink(inode, btrfs_inode_nlink(leaf, inode_item));
 	inode->i_uid = btrfs_inode_uid(leaf, inode_item);
 	inode->i_gid = btrfs_inode_gid(leaf, inode_item);
 	btrfs_i_size_write(inode, btrfs_inode_size(leaf, inode_item));
@@ -6728,7 +6728,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
 
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	btrfs_i_size_write(inode, 0);
 
 	err = btrfs_update_inode(trans, new_root, inode);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 786639f..0618aa3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1030,7 +1030,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 	if (nlink != inode->i_nlink) {
-		inode->i_nlink = nlink;
+		set_nlink(inode, nlink);
 		btrfs_update_inode(trans, root, inode);
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 8d74ad7..8c00ada 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2363,7 +2363,7 @@ static void handle_cap_grant(struct inode *inode, struct ceph_mds_caps *grant,
 	}
 
 	if ((issued & CEPH_CAP_LINK_EXCL) == 0)
-		inode->i_nlink = le32_to_cpu(grant->nlink);
+		set_nlink(inode, le32_to_cpu(grant->nlink));
 
 	if ((issued & CEPH_CAP_XATTR_EXCL) == 0 && grant->xattr_len) {
 		int len = le32_to_cpu(grant->xattr_len);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 095799b..2dfbcee 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -619,7 +619,7 @@ static int fill_inode(struct inode *inode,
 	}
 
 	if ((issued & CEPH_CAP_LINK_EXCL) == 0)
-		inode->i_nlink = le32_to_cpu(info->nlink);
+		set_nlink(inode, le32_to_cpu(info->nlink));
 
 	/* be careful with mtime, atime, size */
 	ceph_decode_timespec(&atime, &info->atime);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a7b2dcd..7989118 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -132,7 +132,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	inode->i_mtime = fattr->cf_mtime;
 	inode->i_ctime = fattr->cf_ctime;
 	inode->i_rdev = fattr->cf_rdev;
-	inode->i_nlink = fattr->cf_nlink;
+	set_nlink(inode, fattr->cf_nlink);
 	inode->i_uid = fattr->cf_uid;
 	inode->i_gid = fattr->cf_gid;
 
@@ -900,7 +900,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	if (rc && tcon->ipc) {
 		cFYI(1, "ipc connection - fake read inode");
 		inode->i_mode |= S_IFDIR;
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 		inode->i_op = &cifs_ipc_inode_ops;
 		inode->i_fop = &simple_dir_operations;
 		inode->i_uid = cifs_sb->mnt_uid;
@@ -1362,7 +1362,7 @@ mkdir_get_info:
 		 /* setting nlink not necessary except in cases where we
 		  * failed to get it from the server or was set bogus */
 		if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
-				direntry->d_inode->i_nlink = 2;
+			set_nlink(direntry->d_inode, 2);
 
 		mode &= ~current_umask();
 		/* must turn on setgid bit if parent dir has it */
diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index 2bdbcc1..854ace7 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -104,7 +104,7 @@ void coda_vattr_to_iattr(struct inode *inode, struct coda_vattr *attr)
         if (attr->va_gid != -1)
 	        inode->i_gid = (gid_t) attr->va_gid;
 	if (attr->va_nlink != -1)
-	        inode->i_nlink = attr->va_nlink;
+		set_nlink(inode, attr->va_nlink);
 	if (attr->va_size != -1)
 	        inode->i_size = attr->va_size;
 	if (attr->va_size != -1)
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index c196e54..d5d5297 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -307,7 +307,7 @@ devpts_fill_super(struct super_block *s, void *data, int silent)
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO | S_IWUSR;
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 
 	s->s_root = d_alloc_root(inode);
 	if (s->s_root)
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 11f8582..a36d327 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -474,8 +474,8 @@ static int ecryptfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto out_lock;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
-	old_dentry->d_inode->i_nlink =
-		ecryptfs_inode_to_lower(old_dentry->d_inode)->i_nlink;
+	set_nlink(old_dentry->d_inode,
+		  ecryptfs_inode_to_lower(old_dentry->d_inode)->i_nlink);
 	i_size_write(new_dentry->d_inode, file_size_save);
 out_lock:
 	unlock_dir(lower_dir_dentry);
@@ -499,8 +499,8 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out_unlock;
 	}
 	fsstack_copy_attr_times(dir, lower_dir_inode);
-	dentry->d_inode->i_nlink =
-		ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink;
+	set_nlink(dentry->d_inode,
+		  ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink);
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
@@ -565,7 +565,7 @@ static int ecryptfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
-	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
+	set_nlink(dir, lower_dir_dentry->d_inode->i_nlink);
 out:
 	unlock_dir(lower_dir_dentry);
 	if (!dentry->d_inode)
@@ -588,7 +588,7 @@ static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!rc && dentry->d_inode)
 		clear_nlink(dentry->d_inode);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
+	set_nlink(dir, lower_dir_dentry->d_inode->i_nlink);
 	unlock_dir(lower_dir_dentry);
 	if (!rc)
 		d_drop(dentry);
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 9c13412..bc84f36 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -96,7 +96,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	efs_inode = (struct efs_dinode *) (bh->b_data + offset);
     
 	inode->i_mode  = be16_to_cpu(efs_inode->di_mode);
-	inode->i_nlink = be16_to_cpu(efs_inode->di_nlink);
+	set_nlink(inode, be16_to_cpu(efs_inode->di_nlink));
 	inode->i_uid   = (uid_t)be16_to_cpu(efs_inode->di_uid);
 	inode->i_gid   = (gid_t)be16_to_cpu(efs_inode->di_gid);
 	inode->i_size  = be32_to_cpu(efs_inode->di_size);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 3e5f3a6..f6dbf77 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1165,7 +1165,7 @@ struct inode *exofs_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mode = le16_to_cpu(fcb.i_mode);
 	inode->i_uid = le32_to_cpu(fcb.i_uid);
 	inode->i_gid = le32_to_cpu(fcb.i_gid);
-	inode->i_nlink = le16_to_cpu(fcb.i_links_count);
+	set_nlink(inode, le16_to_cpu(fcb.i_links_count));
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(fcb.i_ctime);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(fcb.i_atime);
 	inode->i_mtime.tv_sec = (signed)le32_to_cpu(fcb.i_mtime);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index a8a58f6..91a6945 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1321,7 +1321,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
-	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
+	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 12661e1..85fe655 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2899,7 +2899,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
-	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
+	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8a60e33..642dc6d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1821,7 +1821,7 @@ retry:
 	de->name_len = 2;
 	strcpy (de->name, "..");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	BUFFER_TRACE(dir_block, "call ext3_journal_dirty_metadata");
 	err = ext3_journal_dirty_metadata(handle, dir_block);
 	if (err)
@@ -2170,7 +2170,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 		ext3_warning (inode->i_sb, "ext3_unlink",
 			      "Deleting nonexistent file (%lu), %d",
 			      inode->i_ino, inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	retval = ext3_delete_entry(handle, dir, de, bh);
 	if (retval)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 986e238..989440e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3414,7 +3414,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
-	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
+	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	ei->i_dir_start_lookup = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4623c08..5f7fb46 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1694,7 +1694,7 @@ static void ext4_inc_count(handle_t *handle, struct inode *inode)
 	if (is_dx(inode) && inode->i_nlink > 1) {
 		/* limit is 16-bit i_links_count */
 		if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
-			inode->i_nlink = 1;
+			set_nlink(inode, 1);
 			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb,
 					      EXT4_FEATURE_RO_COMPAT_DIR_NLINK);
 		}
@@ -1861,7 +1861,7 @@ retry:
 	de->name_len = 2;
 	strcpy(de->name, "..");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
 	if (err)
@@ -2214,7 +2214,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		ext4_warning(inode->i_sb,
 			     "Deleting nonexistent file (%lu), %d",
 			     inode->i_ino, inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 1726d73..808cac7 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -379,7 +379,7 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 			return error;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
 
-		inode->i_nlink = fat_subdirs(inode);
+		set_nlink(inode, fat_subdirs(inode));
 	} else { /* not a directory */
 		inode->i_generation |= 1;
 		inode->i_mode = fat_make_mode(sbi, de->attr,
@@ -1233,7 +1233,7 @@ static int fat_read_root(struct inode *inode)
 	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
 	inode->i_mtime.tv_nsec = inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 0;
-	inode->i_nlink = fat_subdirs(inode)+2;
+	set_nlink(inode, fat_subdirs(inode)+2);
 
 	return 0;
 }
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 66e83b8..216b419 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -387,7 +387,7 @@ static int msdos_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		/* the directory was completed, just return a error */
 		goto out;
 	}
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bb3f29c..a87a656 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -900,7 +900,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out;
 	}
 	inode->i_version++;
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 1a43114..7b2af5a 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -227,7 +227,7 @@ vxfs_iinit(struct inode *ip, struct vxfs_inode_info *vip)
 	ip->i_uid = (uid_t)vip->vii_uid;
 	ip->i_gid = (gid_t)vip->vii_gid;
 
-	ip->i_nlink = vip->vii_nlink;
+	set_nlink(ip, vip->vii_nlink);
 	ip->i_size = vip->vii_size;
 
 	ip->i_atime.tv_sec = vip->vii_atime;
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 85542a7..42593c5 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -231,7 +231,7 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	if (iop)
 		inode->i_op = iop;
 	inode->i_fop = fop;
-	inode->i_nlink = nlink;
+	set_nlink(inode, nlink);
 	inode->i_private = fc;
 	d_add(dentry, inode);
 	return dentry;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index add96f6..3e6d727 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -151,7 +151,7 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 
 	inode->i_ino     = attr->ino;
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
-	inode->i_nlink   = attr->nlink;
+	set_nlink(inode, attr->nlink);
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
 	inode->i_blocks  = attr->blocks;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index da21eca..102cf5e 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -277,7 +277,7 @@ static void gfs2_set_nlink(struct inode *inode, u32 nlink)
 		if (nlink == 0)
 			clear_nlink(inode);
 		else
-			inode->i_nlink = nlink;
+			set_nlink(inode, nlink);
 	}
 }
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 96a1b62..a1a9fdc 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -183,7 +183,7 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
@@ -313,7 +313,7 @@ static int hfs_read_inode(struct inode *inode, void *data)
 	/* Initialize the inode */
 	inode->i_uid = hsb->s_uid;
 	inode->i_gid = hsb->s_gid;
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 
 	if (idata->key)
 		HFS_I(inode)->cat_key = *idata->key;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 4cc1e3a..40e1413 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -391,7 +391,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 
 	hip = HFSPLUS_I(inode);
@@ -512,7 +512,7 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		hfsplus_get_perms(inode, &folder->permissions, 1);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 		inode->i_size = 2 + be32_to_cpu(folder->valence);
 		inode->i_atime = hfsp_mt2ut(folder->access_date);
 		inode->i_mtime = hfsp_mt2ut(folder->content_mod_date);
@@ -532,11 +532,11 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 		hfsplus_inode_read_fork(inode, HFSPLUS_IS_RSRC(inode) ?
 					&file->rsrc_fork : &file->data_fork);
 		hfsplus_get_perms(inode, &file->permissions, 0);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 		if (S_ISREG(inode->i_mode)) {
 			if (file->permissions.dev)
-				inode->i_nlink =
-					be32_to_cpu(file->permissions.dev);
+				set_nlink(inode,
+					  be32_to_cpu(file->permissions.dev));
 			inode->i_op = &hfsplus_file_inode_operations;
 			inode->i_fop = &hfsplus_file_operations;
 			inode->i_mapping->a_ops = &hfsplus_aops;
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 0d22afd..2f72da5 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -541,7 +541,7 @@ static int read_name(struct inode *ino, char *name)
 
 	ino->i_ino = st.ino;
 	ino->i_mode = st.mode;
-	ino->i_nlink = st.nlink;
+	set_nlink(ino, st.nlink);
 	ino->i_uid = st.uid;
 	ino->i_gid = st.gid;
 	ino->i_atime = st.atime;
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 96a8ed9..2fa0089 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -247,7 +247,7 @@ struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, struct name
 			result->i_mode &= ~0111;
 			result->i_op = &hpfs_file_iops;
 			result->i_fop = &hpfs_file_ops;
-			result->i_nlink = 1;
+			set_nlink(result, 1);
 		}
 		unlock_new_inode(result);
 	}
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index dfe800c..3b2cec2 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -77,7 +77,7 @@ void hpfs_read_inode(struct inode *i)
 			i->i_mode = S_IFLNK | 0777;
 			i->i_op = &page_symlink_inode_operations;
 			i->i_data.a_ops = &hpfs_symlink_aops;
-			i->i_nlink = 1;
+			set_nlink(i, 1);
 			i->i_size = ea_size;
 			i->i_blocks = 1;
 			brelse(bh);
@@ -101,7 +101,7 @@ void hpfs_read_inode(struct inode *i)
 			}
 			if (S_ISBLK(mode) || S_ISCHR(mode) || S_ISFIFO(mode) || S_ISSOCK(mode)) {
 				brelse(bh);
-				i->i_nlink = 1;
+				set_nlink(i, 1);
 				i->i_size = 0;
 				i->i_blocks = 1;
 				init_special_inode(i, mode,
@@ -125,13 +125,13 @@ void hpfs_read_inode(struct inode *i)
 		hpfs_count_dnodes(i->i_sb, hpfs_inode->i_dno, &n_dnodes, &n_subdirs, NULL);
 		i->i_blocks = 4 * n_dnodes;
 		i->i_size = 2048 * n_dnodes;
-		i->i_nlink = 2 + n_subdirs;
+		set_nlink(i, 2 + n_subdirs);
 	} else {
 		i->i_mode |= S_IFREG;
 		if (!hpfs_inode->i_ea_mode) i->i_mode &= ~0111;
 		i->i_op = &hpfs_file_iops;
 		i->i_fop = &hpfs_file_ops;
-		i->i_nlink = 1;
+		set_nlink(i, 1);
 		i->i_size = le32_to_cpu(fnode->file_size);
 		i->i_blocks = ((i->i_size + 511) >> 9) + 1;
 		i->i_data.a_ops = &hpfs_aops;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 2df69e2..ea91fcb 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -56,7 +56,7 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	result->i_fop = &hpfs_dir_ops;
 	result->i_blocks = 4;
 	result->i_size = 2048;
-	result->i_nlink = 2;
+	set_nlink(result, 2);
 	if (dee.read_only)
 		result->i_mode &= ~0222;
 
@@ -150,7 +150,7 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struc
 	result->i_mode &= ~0111;
 	result->i_op = &hpfs_file_iops;
 	result->i_fop = &hpfs_file_ops;
-	result->i_nlink = 1;
+	set_nlink(result, 1);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
 	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
 	result->i_ctime.tv_nsec = 0;
@@ -242,7 +242,7 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t
 	hpfs_i(result)->i_ea_size = 0;
 	result->i_uid = current_fsuid();
 	result->i_gid = current_fsgid();
-	result->i_nlink = 1;
+	set_nlink(result, 1);
 	result->i_size = 0;
 	result->i_blocks = 1;
 	init_special_inode(result, mode, rdev);
@@ -318,7 +318,7 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	result->i_uid = current_fsuid();
 	result->i_gid = current_fsgid();
 	result->i_blocks = 1;
-	result->i_nlink = 1;
+	set_nlink(result, 1);
 	result->i_size = strlen(symlink);
 	result->i_op = &page_symlink_inode_operations;
 	result->i_data.a_ops = &hpfs_symlink_aops;
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 970ea98..f590b11 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -702,7 +702,7 @@ static struct inode *get_inode(struct super_block *sb, struct dentry *dentry)
 	inode->i_ctime = proc_ino->i_ctime;
 	inode->i_ino = proc_ino->i_ino;
 	inode->i_mode = proc_ino->i_mode;
-	inode->i_nlink = proc_ino->i_nlink;
+	set_nlink(inode, proc_ino->i_nlink);
 	inode->i_size = proc_ino->i_size;
 	inode->i_blocks = proc_ino->i_blocks;
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a5d0367..562adab 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1319,7 +1319,7 @@ static int isofs_read_inode(struct inode *inode)
 			inode->i_mode = S_IFDIR | sbi->s_dmode;
 		else
 			inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
-		inode->i_nlink = 1;	/*
+		set_nlink(inode, 1);	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
 					 * if it is 2, and it screws up.  It is
@@ -1337,7 +1337,7 @@ static int isofs_read_inode(struct inode *inode)
 			 */
 			inode->i_mode = S_IFREG | S_IRUGO | S_IXUGO;
 		}
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	inode->i_uid = sbi->s_uid;
 	inode->i_gid = sbi->s_gid;
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 1fbc7de..70e79d0 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -363,7 +363,7 @@ repeat:
 			break;
 		case SIG('P', 'X'):
 			inode->i_mode = isonum_733(rr->u.PX.mode);
-			inode->i_nlink = isonum_733(rr->u.PX.n_links);
+			set_nlink(inode, isonum_733(rr->u.PX.n_links));
 			inode->i_uid = isonum_733(rr->u.PX.uid);
 			inode->i_gid = isonum_733(rr->u.PX.gid);
 			break;
@@ -496,7 +496,7 @@ repeat:
 				goto out;
 			}
 			inode->i_mode = reloc->i_mode;
-			inode->i_nlink = reloc->i_nlink;
+			set_nlink(inode, reloc->i_nlink);
 			inode->i_uid = reloc->i_uid;
 			inode->i_gid = reloc->i_gid;
 			inode->i_rdev = reloc->i_rdev;
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 9659b7c..be6169b 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -245,7 +245,7 @@ static int jffs2_unlink(struct inode *dir_i, struct dentry *dentry)
 	ret = jffs2_do_unlink(c, dir_f, dentry->d_name.name,
 			      dentry->d_name.len, dead_f, now);
 	if (dead_f->inocache)
-		dentry->d_inode->i_nlink = dead_f->inocache->pino_nlink;
+		set_nlink(dentry->d_inode, dead_f->inocache->pino_nlink);
 	if (!ret)
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
 	return ret;
@@ -278,7 +278,7 @@ static int jffs2_link (struct dentry *old_dentry, struct inode *dir_i, struct de
 
 	if (!ret) {
 		mutex_lock(&f->sem);
-		old_dentry->d_inode->i_nlink = ++f->inocache->pino_nlink;
+		set_nlink(old_dentry->d_inode, ++f->inocache->pino_nlink);
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
@@ -497,7 +497,7 @@ static int jffs2_mkdir (struct inode *dir_i, struct dentry *dentry, int mode)
 	f = JFFS2_INODE_INFO(inode);
 
 	/* Directories get nlink 2 at start */
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	/* but ic->pino_nlink is the parent ino# */
 	f->inocache->pino_nlink = dir_i->i_ino;
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index bbcb975..7286e44 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -278,7 +278,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mtime = ITIME(je32_to_cpu(latest_node.mtime));
 	inode->i_ctime = ITIME(je32_to_cpu(latest_node.ctime));
 
-	inode->i_nlink = f->inocache->pino_nlink;
+	set_nlink(inode, f->inocache->pino_nlink);
 
 	inode->i_blocks = (inode->i_size + 511) >> 9;
 
@@ -291,7 +291,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 	case S_IFDIR:
 	{
 		struct jffs2_full_dirent *fd;
-		inode->i_nlink = 2; /* parent and '.' */
+		set_nlink(inode, 2); /* parent and '.' */
 
 		for (fd=f->dents; fd; fd = fd->next) {
 			if (fd->type == DT_DIR && fd->ino)
@@ -453,7 +453,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 		iput(inode);
 		return ERR_PTR(ret);
 	}
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	inode->i_ino = je32_to_cpu(ri->ino);
 	inode->i_mode = jemode_to_cpu(ri->mode);
 	inode->i_gid = je16_to_cpu(ri->gid);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index b78b2f9..1b6f15f 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -457,7 +457,7 @@ struct inode *diReadSpecial(struct super_block *sb, ino_t inum, int secondary)
 	/* read the page of fixed disk inode (AIT) in raw mode */
 	mp = read_metapage(ip, address << sbi->l2nbperpage, PSIZE, 1);
 	if (mp == NULL) {
-		ip->i_nlink = 1;	/* Don't want iput() deleting it */
+		set_nlink(ip, 1);	/* Don't want iput() deleting it */
 		iput(ip);
 		return (NULL);
 	}
@@ -469,7 +469,7 @@ struct inode *diReadSpecial(struct super_block *sb, ino_t inum, int secondary)
 	/* copy on-disk inode to in-memory inode */
 	if ((copy_from_dinode(dp, ip)) != 0) {
 		/* handle bad return by returning NULL for ip */
-		ip->i_nlink = 1;	/* Don't want iput() deleting it */
+		set_nlink(ip, 1);	/* Don't want iput() deleting it */
 		iput(ip);
 		/* release the page */
 		release_metapage(mp);
@@ -3076,7 +3076,7 @@ static int copy_from_dinode(struct dinode * dip, struct inode *ip)
 				ip->i_mode |= 0001;
 		}
 	}
-	ip->i_nlink = le32_to_cpu(dip->di_nlink);
+	set_nlink(ip, le32_to_cpu(dip->di_nlink));
 
 	jfs_ip->saved_uid = le32_to_cpu(dip->di_uid);
 	if (sbi->uid == -1)
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 94b0a62..a112ad9 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -292,7 +292,7 @@ static int jfs_mkdir(struct inode *dip, struct dentry *dentry, int mode)
 		goto out3;
 	}
 
-	ip->i_nlink = 2;	/* for '.' */
+	set_nlink(ip, 2);	/* for '.' */
 	ip->i_op = &jfs_dir_inode_operations;
 	ip->i_fop = &jfs_dir_operations;
 
diff --git a/fs/libfs.c b/fs/libfs.c
index c18e9a1..fe3ec42 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -490,7 +490,7 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index d8d0938..2ac4217 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -126,7 +126,7 @@ static void logfs_disk_to_inode(struct logfs_disk_inode *di, struct inode*inode)
 	inode->i_atime	= be64_to_timespec(di->di_atime);
 	inode->i_ctime	= be64_to_timespec(di->di_ctime);
 	inode->i_mtime	= be64_to_timespec(di->di_mtime);
-	inode->i_nlink	= be32_to_cpu(di->di_refcount);
+	set_nlink(inode, be32_to_cpu(di->di_refcount));
 	inode->i_generation = be32_to_cpu(di->di_generation);
 
 	switch (inode->i_mode & S_IFMT) {
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index e7d23e2..64cdcd6 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -446,7 +446,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
 	inode->i_gid = (gid_t)raw_inode->i_gid;
-	inode->i_nlink = raw_inode->i_nlinks;
+	set_nlink(inode, raw_inode->i_nlinks);
 	inode->i_size = raw_inode->i_size;
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = raw_inode->i_time;
 	inode->i_mtime.tv_nsec = 0;
@@ -479,7 +479,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
 	inode->i_gid = (gid_t)raw_inode->i_gid;
-	inode->i_nlink = raw_inode->i_nlinks;
+	set_nlink(inode, raw_inode->i_nlinks);
 	inode->i_size = raw_inode->i_size;
 	inode->i_mtime.tv_sec = raw_inode->i_mtime;
 	inode->i_atime.tv_sec = raw_inode->i_atime;
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 202f370..5b5fa33 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -228,7 +228,7 @@ static void ncp_set_attr(struct inode *inode, struct ncp_entry_info *nwinfo)
 
 	DDPRINTK("ncp_read_inode: inode->i_mode = %u\n", inode->i_mode);
 
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	inode->i_uid = server->m.uid;
 	inode->i_gid = server->m.gid;
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1fc715a..c07a55a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -355,7 +355,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 				| NFS_INO_INVALID_DATA
 				| NFS_INO_REVAL_PAGECACHE;
 		if (fattr->valid & NFS_ATTR_FATTR_NLINK)
-			inode->i_nlink = fattr->nlink;
+			set_nlink(inode, fattr->nlink);
 		else if (nfs_server_capable(inode, NFS_CAP_NLINK))
 			nfsi->cache_validity |= NFS_INO_INVALID_ATTR;
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
@@ -1361,7 +1361,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			invalid |= NFS_INO_INVALID_ATTR;
 			if (S_ISDIR(inode->i_mode))
 				invalid |= NFS_INO_INVALID_DATA;
-			inode->i_nlink = fattr->nlink;
+			set_nlink(inode, fattr->nlink);
 		}
 	} else if (server->caps & NFS_CAP_NLINK)
 		invalid |= save_cache_validity & (NFS_INO_INVALID_ATTR
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 08ac272..b50ffb7 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -396,7 +396,7 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le32_to_cpu(raw_inode->i_uid);
 	inode->i_gid = (gid_t)le32_to_cpu(raw_inode->i_gid);
-	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
+	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le64_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
 	inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index a314199..768982d 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -289,7 +289,7 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 		nilfs_warning(inode->i_sb, __func__,
 			      "deleting nonexistent file (%lu), %d\n",
 			      inode->i_ino, inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
 	if (err)
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1371487..97e2dac 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -612,7 +612,7 @@ static int ntfs_read_locked_inode(struct inode *vi)
 	 * might be tricky due to vfs interactions. Need to think about this
 	 * some more when implementing the unlink command.
 	 */
-	vi->i_nlink = le16_to_cpu(m->link_count);
+	set_nlink(vi, le16_to_cpu(m->link_count));
 	/*
 	 * FIXME: Reparse points can have the directory bit set even though
 	 * they would be S_IFLNK. Need to deal with this further below when we
@@ -634,7 +634,7 @@ static int ntfs_read_locked_inode(struct inode *vi)
 		vi->i_mode &= ~vol->dmask;
 		/* Things break without this kludge! */
 		if (vi->i_nlink > 1)
-			vi->i_nlink = 1;
+			set_nlink(vi, 1);
 	} else {
 		vi->i_mode |= S_IFREG;
 		/* Apply the file permissions mask set in the mount options. */
@@ -1242,7 +1242,7 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
-	vi->i_nlink	= base_vi->i_nlink;
+	set_nlink(vi, base_vi->i_nlink);
 	vi->i_mtime	= base_vi->i_mtime;
 	vi->i_ctime	= base_vi->i_ctime;
 	vi->i_atime	= base_vi->i_atime;
@@ -1508,7 +1508,7 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
-	vi->i_nlink	= base_vi->i_nlink;
+	set_nlink(vi, base_vi->i_nlink);
 	vi->i_mtime	= base_vi->i_mtime;
 	vi->i_ctime	= base_vi->i_ctime;
 	vi->i_atime	= base_vi->i_atime;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8582e3f..e2878b5 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2292,7 +2292,7 @@ static int ocfs2_fill_new_dir_id(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, di_bh);
 
 	i_size_write(inode, size);
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
 
 	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
@@ -2354,7 +2354,7 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, new_bh);
 
 	i_size_write(inode, inode->i_sb->s_blocksize);
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
 	status = ocfs2_mark_inode_dirty(handle, inode, fe_bh);
 	if (status < 0) {
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..e1ed5e5 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2092,7 +2092,7 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
 	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
-	inode->i_nlink   = be16_to_cpu(lvb->lvb_inlink);
+	set_nlink(inode, be16_to_cpu(lvb->lvb_inlink));
 	ocfs2_unpack_timespec(&inode->i_atime,
 			      be64_to_cpu(lvb->lvb_iatime_packed));
 	ocfs2_unpack_timespec(&inode->i_mtime,
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b4c8bb6..a22d2c0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -291,7 +291,7 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 		     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
-	inode->i_nlink = ocfs2_read_links_count(fe);
+	set_nlink(inode, ocfs2_read_links_count(fe));
 
 	trace_ocfs2_populate_inode(OCFS2_I(inode)->ip_blkno,
 				   le32_to_cpu(fe->i_flags));
@@ -1290,7 +1290,7 @@ void ocfs2_refresh_inode(struct inode *inode,
 	OCFS2_I(inode)->ip_dyn_features = le16_to_cpu(fe->i_dyn_features);
 	ocfs2_set_inode_flags(inode);
 	i_size_write(inode, le64_to_cpu(fe->i_size));
-	inode->i_nlink = ocfs2_read_links_count(fe);
+	set_nlink(inode, ocfs2_read_links_count(fe));
 	inode->i_uid = le32_to_cpu(fe->i_uid);
 	inode->i_gid = le32_to_cpu(fe->i_gid);
 	inode->i_mode = le16_to_cpu(fe->i_mode);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ea0ecbd..a8b2bfe 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -199,7 +199,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 	 * these are used by the support functions here and in
 	 * callers. */
 	if (S_ISDIR(mode))
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 	inode_init_owner(inode, dir, mode);
 	dquot_initialize(inode);
 	return inode;
@@ -2016,7 +2016,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
 	if (S_ISDIR(inode->i_mode))
 		ocfs2_add_links_count(orphan_fe, 1);
-	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
+	set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
 	ocfs2_journal_dirty(handle, orphan_dir_bh);
 
 	status = __ocfs2_add_entry(handle, orphan_dir_inode, name,
@@ -2114,7 +2114,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
 	if (S_ISDIR(inode->i_mode))
 		ocfs2_add_links_count(orphan_fe, -1);
-	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
+	set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
 	ocfs2_journal_dirty(handle, orphan_dir_bh);
 
 leave:
@@ -2435,7 +2435,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 	le32_add_cpu(&di->i_flags, -OCFS2_ORPHANED_FL);
 	di->i_orphaned_slot = 0;
-	inode->i_nlink = 1;
+	set_nlink(inode, 1);
 	ocfs2_set_links_count(di, inode->i_nlink);
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index a2a5bff..e4e0ff7 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -242,7 +242,7 @@ found:
 		inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
 		inode->i_op = &openprom_inode_operations;
 		inode->i_fop = &openprom_operations;
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 		break;
 	case op_inode_prop:
 		if (!strcmp(dp->name, "options") && (len == 17) &&
@@ -251,7 +251,7 @@ found:
 		else
 			inode->i_mode = S_IFREG | S_IRUGO;
 		inode->i_fop = &openpromfs_prop_ops;
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 		inode->i_size = ent_oi->u.prop->length;
 		break;
 	}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5eb0206..1f2ae7d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2261,7 +2261,7 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
 	ei = PROC_I(inode);
 	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
-		inode->i_nlink = 2;	/* Use getattr to fix if necessary */
+		set_nlink(inode, 2);	/* Use getattr to fix if necessary */
 	if (p->iop)
 		inode->i_op = p->iop;
 	if (p->fop)
@@ -2655,7 +2655,7 @@ static struct dentry *proc_base_instantiate(struct inode *dir,
 
 	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
-		inode->i_nlink = 2;
+		set_nlink(inode, 2);
 	if (S_ISLNK(inode->i_mode))
 		inode->i_size = 64;
 	if (p->iop)
@@ -2994,8 +2994,8 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
-	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
-		ARRAY_SIZE(tgid_base_stuff));
+	set_nlink(inode, 2 + pid_entry_count_dirs(tgid_base_stuff,
+						  ARRAY_SIZE(tgid_base_stuff)));
 
 	d_set_d_op(dentry, &pid_dentry_operations);
 
@@ -3246,8 +3246,8 @@ static struct dentry *proc_task_instantiate(struct inode *dir,
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 
-	inode->i_nlink = 2 + pid_entry_count_dirs(tid_base_stuff,
-		ARRAY_SIZE(tid_base_stuff));
+	set_nlink(inode, 2 + pid_entry_count_dirs(tid_base_stuff,
+						  ARRAY_SIZE(tid_base_stuff)));
 
 	d_set_d_op(dentry, &pid_dentry_operations);
 
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 9d99131..10090d9 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -283,7 +283,7 @@ static int proc_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct inode *inode = dentry->d_inode;
 	struct proc_dir_entry *de = PROC_I(inode)->pde;
 	if (de && de->nlink)
-		inode->i_nlink = de->nlink;
+		set_nlink(inode, de->nlink);
 
 	generic_fillattr(inode, stat);
 	return 0;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ed72d6..7737c54 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -445,7 +445,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 		if (de->size)
 			inode->i_size = de->size;
 		if (de->nlink)
-			inode->i_nlink = de->nlink;
+			set_nlink(inode, de->nlink);
 		if (de->proc_iops)
 			inode->i_op = de->proc_iops;
 		if (de->proc_fops) {
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 2b06466..3bdd214 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -379,7 +379,7 @@ struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mode    = le16_to_cpu(raw_inode->di_mode);
 	inode->i_uid     = (uid_t)le16_to_cpu(raw_inode->di_uid);
 	inode->i_gid     = (gid_t)le16_to_cpu(raw_inode->di_gid);
-	inode->i_nlink   = le16_to_cpu(raw_inode->di_nlink);
+	set_nlink(inode, le16_to_cpu(raw_inode->di_nlink));
 	inode->i_size    = le32_to_cpu(raw_inode->di_size);
 	inode->i_mtime.tv_sec   = le32_to_cpu(raw_inode->di_mtime);
 	inode->i_mtime.tv_nsec = 0;
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index c425441..950f13a 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1154,7 +1154,7 @@ static void init_inode(struct inode *inode, struct treepath *path)
 		set_inode_item_key_version(inode, KEY_FORMAT_3_5);
 		set_inode_sd_version(inode, STAT_DATA_V1);
 		inode->i_mode = sd_v1_mode(sd);
-		inode->i_nlink = sd_v1_nlink(sd);
+		set_nlink(inode, sd_v1_nlink(sd));
 		inode->i_uid = sd_v1_uid(sd);
 		inode->i_gid = sd_v1_gid(sd);
 		inode->i_size = sd_v1_size(sd);
@@ -1199,7 +1199,7 @@ static void init_inode(struct inode *inode, struct treepath *path)
 		struct stat_data *sd = (struct stat_data *)B_I_PITEM(bh, ih);
 
 		inode->i_mode = sd_v2_mode(sd);
-		inode->i_nlink = sd_v2_nlink(sd);
+		set_nlink(inode, sd_v2_nlink(sd));
 		inode->i_uid = sd_v2_uid(sd);
 		inode->i_size = sd_v2_size(sd);
 		inode->i_gid = sd_v2_gid(sd);
@@ -1832,7 +1832,7 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 #endif
 
 	/* fill stat data */
-	inode->i_nlink = (S_ISDIR(mode) ? 2 : 1);
+	set_nlink(inode, (S_ISDIR(mode) ? 2 : 1));
 
 	/* uid and gid must already be set by the caller for quota init */
 
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 6ce3328..80058e8 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -19,7 +19,7 @@
 #include <linux/reiserfs_xattr.h>
 #include <linux/quotaops.h>
 
-#define INC_DIR_INODE_NLINK(i) if (i->i_nlink != 1) { inc_nlink(i); if (i->i_nlink >= REISERFS_LINK_MAX) i->i_nlink=1; }
+#define INC_DIR_INODE_NLINK(i) if (i->i_nlink != 1) { inc_nlink(i); if (i->i_nlink >= REISERFS_LINK_MAX) set_nlink(i, 1); }
 #define DEC_DIR_INODE_NLINK(i) if (i->i_nlink != 1) drop_nlink(i);
 
 // directory item contains array of entry headers. This performs
@@ -964,7 +964,7 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 		reiserfs_warning(inode->i_sb, "reiserfs-7042",
 				 "deleting nonexistent file (%lu), %d",
 				 inode->i_ino, inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 
 	drop_nlink(inode);
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 2305e31..8b4089f 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -337,7 +337,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	inode->i_metasize = (ROMFH_SIZE + nlen + 1 + ROMFH_PAD) & ROMFH_MASK;
 	inode->i_dataoffset = pos + inode->i_metasize;
 
-	i->i_nlink = 1;		/* Hard to decide.. */
+	set_nlink(i, 1);		/* Hard to decide.. */
 	i->i_size = be32_to_cpu(ri.size);
 	i->i_mtime.tv_sec = i->i_atime.tv_sec = i->i_ctime.tv_sec = 0;
 	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 04bebca..fd7b3b3 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -159,7 +159,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			frag_offset = 0;
 		}
 
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;
@@ -203,7 +203,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 		}
 
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_inode_ops;
 		inode->i_fop = &generic_ro_fops;
@@ -232,7 +232,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
@@ -257,7 +257,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			goto failed_read;
 
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
@@ -284,7 +284,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
 		inode->i_op = &squashfs_symlink_inode_ops;
 		inode->i_data.a_ops = &squashfs_symlink_aops;
@@ -325,7 +325,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			inode->i_mode |= S_IFCHR;
 		else
 			inode->i_mode |= S_IFBLK;
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
 
@@ -349,7 +349,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			inode->i_mode |= S_IFBLK;
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		inode->i_op = &squashfs_inode_ops;
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
 
@@ -370,7 +370,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			inode->i_mode |= S_IFIFO;
 		else
 			inode->i_mode |= S_IFSOCK;
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
 		break;
 	}
@@ -389,7 +389,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 			inode->i_mode |= S_IFSOCK;
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		inode->i_op = &squashfs_inode_ops;
-		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
 		break;
 	}
diff --git a/fs/stack.c b/fs/stack.c
index b4f2ab4..9c11519 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -71,6 +71,6 @@ void fsstack_copy_attr_all(struct inode *dest, const struct inode *src)
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
-	dest->i_nlink = src->i_nlink;
+	set_nlink(dest, src->i_nlink);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e23f288..c81b22f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -218,7 +218,7 @@ static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 	}
 
 	if (sysfs_type(sd) == SYSFS_DIR)
-		inode->i_nlink = sd->s_dir.subdirs + 2;
+		set_nlink(inode, sd->s_dir.subdirs + 2);
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 0630eb9..25ffb3e 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -219,7 +219,7 @@ struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 	inode->i_mode = fs16_to_cpu(sbi, raw_inode->i_mode);
 	inode->i_uid = (uid_t)fs16_to_cpu(sbi, raw_inode->i_uid);
 	inode->i_gid = (gid_t)fs16_to_cpu(sbi, raw_inode->i_gid);
-	inode->i_nlink = fs16_to_cpu(sbi, raw_inode->i_nlink);
+	set_nlink(inode, fs16_to_cpu(sbi, raw_inode->i_nlink));
 	inode->i_size = fs32_to_cpu(sbi, raw_inode->i_size);
 	inode->i_atime.tv_sec = fs32_to_cpu(sbi, raw_inode->i_atime);
 	inode->i_mtime.tv_sec = fs32_to_cpu(sbi, raw_inode->i_mtime);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index b281212..20403dc 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -129,7 +129,7 @@ struct inode *ubifs_iget(struct super_block *sb, unsigned long inum)
 		goto out_ino;
 
 	inode->i_flags |= (S_NOCMTIME | S_NOATIME);
-	inode->i_nlink = le32_to_cpu(ino->nlink);
+	set_nlink(inode, le32_to_cpu(ino->nlink));
 	inode->i_uid   = le32_to_cpu(ino->uid);
 	inode->i_gid   = le32_to_cpu(ino->gid);
 	inode->i_atime.tv_sec  = (int64_t)le64_to_cpu(ino->atime_sec);
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 993adc8..bf18f7a 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -561,7 +561,7 @@ int ubifs_removexattr(struct dentry *dentry, const char *name)
 	clear_nlink(inode);
 	err = remove_xattr(c, host, inode, &nm);
 	if (err)
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 
 	/* If @i_nlink is 0, 'iput()' will delete the inode */
 	iput(inode);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1d1358e..6e73f1d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1236,6 +1236,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	int offset;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	unsigned int link_count;
 
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
@@ -1318,9 +1319,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	inode->i_mode &= ~sbi->s_umask;
 	read_unlock(&sbi->s_cred_lock);
 
-	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
-	if (!inode->i_nlink)
-		inode->i_nlink = 1;
+	link_count = le16_to_cpu(fe->fileLinkCount);
+	if (!link_count)
+		link_count = 1;
+	set_nlink(inode, link_count);
 
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	iinfo->i_lenExtents = inode->i_size;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index e8d61b1..f1c64c6 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -667,7 +667,7 @@ static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		iput(inode);
 		goto out;
 	}
-	inode->i_nlink = 2;
+	set_nlink(inode, 2);
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(dinfo->i_location);
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
@@ -837,7 +837,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	if (!inode->i_nlink) {
 		udf_debug("Deleting nonexistent file (%lu), %d\n",
 			  inode->i_ino, inode->i_nlink);
-		inode->i_nlink = 1;
+		set_nlink(inode, 1);
 	}
 	retval = udf_delete_entry(dir, fi, &fibh, &cfi);
 	if (retval)
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index b4d791a..879b134 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -589,7 +589,7 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	 * Copy data to the in-core inode.
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs_inode->ui_mode);
-	inode->i_nlink = fs16_to_cpu(sb, ufs_inode->ui_nlink);
+	set_nlink(inode, fs16_to_cpu(sb, ufs_inode->ui_nlink));
 	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
 		return -1;
@@ -637,7 +637,7 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	 * Copy data to the in-core inode.
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs2_inode->ui_mode);
-	inode->i_nlink = fs16_to_cpu(sb, ufs2_inode->ui_nlink);
+	set_nlink(inode, fs16_to_cpu(sb, ufs2_inode->ui_nlink));
 	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
 		return -1;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 28856ac..5f6b4ac 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1153,7 +1153,7 @@ xfs_setup_inode(
 	hlist_add_fake(&inode->i_hash);
 
 	inode->i_mode	= ip->i_d.di_mode;
-	inode->i_nlink	= ip->i_d.di_nlink;
+	set_nlink(inode, ip->i_d.di_nlink);
 	inode->i_uid	= ip->i_d.di_uid;
 	inode->i_gid	= ip->i_d.di_gid;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0eb2b39..a56dbef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1752,6 +1752,19 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
 }
 
 /**
+ * set_nlink - directly set an inode's link count
+ * @inode: inode
+ * @nlink: new nlink (should be non-zero)
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.
+ */
+static inline void set_nlink(struct inode *inode, unsigned int nlink)
+{
+	inode->i_nlink = nlink;
+}
+
+/**
  * inc_nlink - directly increment an inode's link count
  * @inode: inode
  *
-- 
1.7.3.4

