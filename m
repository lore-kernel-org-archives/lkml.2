Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab2CaFTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 01:19:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46964 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2CaFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 01:19:10 -0400
Date: Sat, 31 Mar 2012 06:19:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs part 2
Message-ID: <20120331051906.GU6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Miklos' first series (with do_lookup() rewrite split into edible
chunks) + assorted bits and pieces.
Please, pull from
git:git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (18):
      selinuxfs: merge dentry allocation into sel_make_dir()
      aio: merge aio_cancel_all() with wait_for_all_aios()
      aio: take final put_ioctx() into callers of io_destroy()
      pstore: trim pstore_get_inode()
      mtdchar: kill persistently held vfsmount
      get rid of pointless includes of ext2_fs.h
      new helper: ext2_image_size()
      migrate ext2_fs.h guts to fs/ext2/ext2.h
      ext3: move headers to fs/ext3/
      untangling do_lookup(), part 1
      untangling do_lookup(), part 2
      untangling do_lookup(), part 3
      untangling do_lookup(), part 4
      untangling do_lookup(), part 5
      untangling do_lookup(), part 6
      untangling do_lookup(), part 7
      untangling do_lookup(), part 8
      untangling do_lookup(), part 9

J. Bruce Fields (1):
      vfs: fix out-of-date dentry_unhash() comment

Miklos Szeredi (4):
      vfs: fix d_need_lookup/d_revalidate order in do_lookup
      vfs: don't revalidate just looked up dentry
      vfs: move MAY_EXEC check from __lookup_hash()
      vfs: split __lookup_hash

Thierry Reding (1):
      ext2: No longer export ext2_fs.h to user space

Diffstat:
 arch/blackfin/kernel/setup.c              |    7 +-
 drivers/mtd/mtdchar.c                     |   53 +--
 fs/aio.c                                  |   32 +-
 fs/ext2/ext2.h                            |  631 +++++++++++++++++++++++++++++
 fs/ext2/xattr_security.c                  |    5 +-
 fs/ext2/xattr_trusted.c                   |    5 +-
 fs/ext2/xip.c                             |    2 -
 fs/ext3/acl.c                             |    8 +-
 fs/ext3/balloc.c                          |   10 +-
 fs/ext3/bitmap.c                          |    4 +-
 fs/ext3/dir.c                             |    7 +-
 include/linux/ext3_fs.h => fs/ext3/ext3.h |  488 +++++++++++++++++++----
 fs/ext3/ext3_jbd.c                        |    2 +-
 fs/ext3/file.c                            |    6 +-
 fs/ext3/fsync.c                           |    8 +-
 fs/ext3/hash.c                            |    4 +-
 fs/ext3/ialloc.c                          |   13 +-
 fs/ext3/inode.c                           |   12 +-
 fs/ext3/ioctl.c                           |    7 +-
 fs/ext3/namei.c                           |   14 +-
 fs/ext3/resize.c                          |    5 +-
 fs/ext3/super.c                           |   18 +-
 fs/ext3/symlink.c                         |    4 +-
 fs/ext3/xattr.c                           |    7 +-
 fs/ext3/xattr_security.c                  |    6 +-
 fs/ext3/xattr_trusted.c                   |    6 +-
 fs/ext3/xattr_user.c                      |    5 +-
 fs/gfs2/file.c                            |    1 -
 fs/namei.c                                |  195 ++++------
 fs/ocfs2/ioctl.c                          |    2 -
 fs/pstore/inode.c                         |   26 +-
 include/linux/Kbuild                      |    1 -
 include/linux/ext2_fs.h                   |  569 +-------------------------
 include/linux/ext2_fs_sb.h                |  126 ------
 include/linux/ext3_fs_i.h                 |  151 -------
 include/linux/ext3_fs_sb.h                |   91 -----
 include/linux/ext3_jbd.h                  |  229 -----------
 init/do_mounts_initrd.c                   |    1 -
 init/do_mounts_rd.c                       |    9 +-
 security/selinux/hooks.c                  |    9 +-
 security/selinux/selinuxfs.c              |  108 ++---
 41 files changed, 1248 insertions(+), 1639 deletions(-)
 rename include/linux/ext3_fs.h => fs/ext3/ext3.h (67%)
 delete mode 100644 include/linux/ext2_fs_sb.h
 delete mode 100644 include/linux/ext3_fs_i.h
 delete mode 100644 include/linux/ext3_fs_sb.h
 delete mode 100644 include/linux/ext3_jbd.h
