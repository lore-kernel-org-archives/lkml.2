Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1E1RZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:25:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48551 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1E1RZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:25:15 -0400
Date: Sat, 28 May 2011 18:25:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile, part 2
Message-ID: <20110528172513.GH11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Stuff missed in the previous one (Darrick's after rediff,
continuation of dentry_unhash() series, Andi's "let's not call
->getxattr() on each and every write(2)", etc.)  DCACHE_NEED_LOOKUP
series is *NOT* there yet; I've tossed pending do_lookup() cleanups
into the pile and I'd like to see Josef's set rediffed on top of that,
with obvious cleanup I suggested to him in do_lookup() part.

	Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (3):
      split __follow_mount_rcu() into normal and .. cases
      Trim excessive arguments of follow_mount_rcu()
      Lift the check for automount points into do_lookup()

Andi Kleen (1):
      Cache xattr security drop check for write v2

Andreas Gruenbacher (2):
      xattr: Fix error results for non-existent / invisible attributes
      vfs: Improve the bio_add_page() and bio_add_pc_page() descriptions

Christoph Hellwig (2):
      fs: pass exact type of data dirties to ->dirty_inode
      fs: cosmetic inode.c cleanups

Darrick J. Wong (2):
      mm: Wait for writeback when grabbing pages to begin a write
      fs: block_page_mkwrite should wait for writeback to finish

Sage Weil (26):
      bfs: remove unnecessary dentry_unhash on dir rename
      sysv: remove unnecessary dentry_unhash from rmdir, dir rename
      jffs2: remove unnecessary dentry_unhash from rmdir, dir rename
      jfs: remove unnecessary dentry_unhash from rmdir, dir rename
      logfs: remove unnecessary dentry_unhash from rmdir, dir rename
      nilfs2: remove unnecessary dentry_unhash from rmdir, dir rename
      ubifs: remove unnecessary dentry_unhash from rmdir, dir rename
      ufs: remove unnecessary dentry_unhash from rmdir, dir rename
      reiserfs: remove unnecessary dentry_unhash from rmdir, dir rename
      udf: remove unnecessary dentry_unhash from rmdir, dir rename
      omfs: remove unnecessary dentry_unhash on rmdir, dir rneame
      hfs: remove unnecessary dentry_unhash on rmdir, dir rename
      hfsplus: remove unnecessary dentry_unhash on rmdir, dir rename
      hostfs: remove unnecessary dentry_unhash on rmdir, dir rename
      ecryptfs: remove unnecessary dentry_unhash on rmdir, dir rename
      ncpfs: document dentry_unhash usage
      ncpfs: fix rename over directory with dangling references
      9p: remove unnecessary dentry_unhash on rmdir, dir rename
      affs: remove unnecessary dentry_unhash on rmdir, dir rename
      afs: remove unnecessary dentry_unhash on rmdir, dir rename
      coda: remove unnecessary dentry_unhash on rmdir, dir rename
      fuse: remove unnecessary dentry_unhash on rmdir, dir rename
      minix: remove unnecessary dentry_unhash on rmdir, dir rename
      hpfs: remove unnecessary dentry_unhash on rmdir, dir rename
      fat: remove unnecessary dentry_unhash on rmdir, dir rename
      configfs: remove unnecessary dentry_unhash on rmdir, dir rename

Diffstat:
 Documentation/filesystems/Locking |    4 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/9p/vfs_inode.c                 |    4 ---
 fs/affs/namei.c                   |    5 ---
 fs/afs/dir.c                      |    5 ---
 fs/attr.c                         |    7 +++++
 fs/bfs/dir.c                      |    3 --
 fs/bio.c                          |   16 +++++-----
 fs/btrfs/ctree.h                  |    2 +-
 fs/btrfs/inode.c                  |    2 +-
 fs/buffer.c                       |    1 +
 fs/coda/dir.c                     |    5 ---
 fs/configfs/dir.c                 |    2 -
 fs/ecryptfs/inode.c               |    5 ---
 fs/ext3/inode.c                   |    2 +-
 fs/ext4/ext4.h                    |    2 +-
 fs/ext4/inode.c                   |    2 +-
 fs/fat/namei_msdos.c              |    5 ---
 fs/fat/namei_vfat.c               |    5 ---
 fs/fs-writeback.c                 |    5 +---
 fs/fuse/dir.c                     |    5 ---
 fs/hfs/dir.c                      |    6 ----
 fs/hfsplus/dir.c                  |    8 +----
 fs/hostfs/hostfs_kern.c           |    5 ---
 fs/hpfs/namei.c                   |    5 ---
 fs/inode.c                        |   54 +++---------------------------------
 fs/jffs2/dir.c                    |    5 ---
 fs/jffs2/fs.c                     |    2 +-
 fs/jffs2/os-linux.h               |    2 +-
 fs/jfs/inode.c                    |    2 +-
 fs/jfs/jfs_inode.h                |    2 +-
 fs/jfs/namei.c                    |    5 ---
 fs/logfs/dir.c                    |    5 ---
 fs/minix/namei.c                  |    5 ---
 fs/namei.c                        |   41 ++++++++++++++++-----------
 fs/ncpfs/dir.c                    |   15 +++++++++-
 fs/nilfs2/inode.c                 |    2 +-
 fs/nilfs2/namei.c                 |    5 ---
 fs/nilfs2/nilfs.h                 |    2 +-
 fs/omfs/dir.c                     |   11 ++-----
 fs/reiserfs/namei.c               |    5 ---
 fs/reiserfs/super.c               |    2 +-
 fs/reiserfs/xattr.c               |    1 -
 fs/sysv/namei.c                   |    5 ---
 fs/ubifs/dir.c                    |    5 ---
 fs/ubifs/super.c                  |    2 +-
 fs/udf/namei.c                    |    5 ---
 fs/ufs/namei.c                    |    5 ---
 fs/xattr.c                        |   23 ++++++++++-----
 fs/xfs/linux-2.6/xfs_super.c      |    3 +-
 include/linux/ext3_fs.h           |    2 +-
 include/linux/fs.h                |   15 +++++++++-
 mm/filemap.c                      |   18 ++++++++++--
 53 files changed, 127 insertions(+), 235 deletions(-)
