Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1EZLxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:53:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32940 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab1EZLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:53:14 -0400
Date: Thu, 26 May 2011 12:53:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20110526115312.GE11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted stuff from the last cycle.  That's not all, there will be
another pile tomorrow or on Saturday...  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (2):
      consolidate nameidata_..._drop_rcu()
      merge handle_reval_dot and nameidata_drop_rcu_last

Jan Kara (2):
      vfs: Create __block_page_mkwrite() helper passing error values back
      vfs: Block mmapped writes while the fs is frozen

Jonas Gorski (1):
      exportfs: reallow building as a module

Miklos Szeredi (1):
      vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems

Roman Borisov (1):
      fs/namespace.c: bound mount propagation fix

Sage Weil (18):
      vfs: dentry_unhash immediately prior to rmdir
      vfs: remove dget() from dentry_unhash()
      vfs: push dentry_unhash on rmdir into file systems
      vfs: push dentry_unhash on rename_dir into file systems
      vfs: update dentry_unhash() comment
      libfs: drop unneeded dentry_unhash
      vfs: clean up vfs_rmdir
      vfs: clean up vfs_rename_dir
      vfs: clean up vfs_rename_other
      ceph: remove unnecessary dentry_unhash calls
      btrfs: remove unnecessary dentry_unhash in rmdir/rename_dir
      ext4: remove unnecessary dentry_unhash on rmdir/rename_dir
      ext3: remove unnecessary dentry_unhash on rmdir/rename_dir
      ext2: remove unnecessary dentry_unhash on rmdir/rename_dir
      nfs: remove unnecessary dentry_unhash on rmdir/rename_dir
      exofs: remove unnecessary dentry_unhash on rmdir/rename_dir
      ocfs2: remove unnecessary dentry_unhash on rmdir/rename_dir
      cifs: remove unnecessary dentry_unhash on rmdir/rename_dir

Diffstat:
 fs/9p/vfs_inode.c           |    4 +
 fs/Kconfig                  |    2 +-
 fs/affs/namei.c             |    5 +
 fs/afs/dir.c                |    5 +
 fs/autofs4/root.c           |    2 +
 fs/bfs/dir.c                |    3 +
 fs/buffer.c                 |   59 +++++--
 fs/coda/dir.c               |    5 +
 fs/configfs/dir.c           |    2 +
 fs/ecryptfs/inode.c         |    5 +
 fs/fat/namei_msdos.c        |    5 +
 fs/fat/namei_vfat.c         |    5 +
 fs/fuse/dir.c               |    6 +
 fs/hfs/dir.c                |    6 +
 fs/hfsplus/dir.c            |    8 +-
 fs/hostfs/hostfs_kern.c     |    5 +
 fs/hpfs/namei.c             |    9 +-
 fs/jffs2/dir.c              |    5 +
 fs/jfs/namei.c              |    5 +
 fs/logfs/dir.c              |    5 +
 fs/minix/namei.c            |    5 +
 fs/namei.c                  |  380 ++++++++++++++++---------------------------
 fs/namespace.c              |    2 +-
 fs/ncpfs/dir.c              |    5 +
 fs/nilfs2/namei.c           |    5 +
 fs/omfs/dir.c               |   11 +-
 fs/reiserfs/namei.c         |    5 +
 fs/reiserfs/xattr.c         |    1 -
 fs/sysv/namei.c             |    5 +
 fs/ubifs/dir.c              |    5 +
 fs/udf/namei.c              |    5 +
 fs/ufs/namei.c              |    5 +
 include/linux/buffer_head.h |   16 ++
 33 files changed, 332 insertions(+), 269 deletions(-)
