Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab0EURrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:47:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0EURrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:47:07 -0400
Date: Fri, 21 May 2010 19:46:58 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] Ext2, ext3, and quota updates for 2.6.35-rc1
Message-ID: <20100521174658.GA10149@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get the changes below? The big chunks are BKL removal from ext2, OCFS2
quota locking fixes, and some quota cleanups from Christoph (I have some
more of them pending but I got to testing them properly only today and thus
I want to leave the final version in linux-next at least over the weekend
before pushing them...).

Christoph Hellwig (3):
      quota: unify ->get_dqblk
      quota: unify ->set_dqblk
      quota: remove sb_has_quota_active in get/set_info

Dmitry Monakhov (5):
      quota: optimize mark_dirty logic
      ext3: init statistics after journal recovery v2
      ufs: add ufs speciffic ->setattr call
      quota: Make quota stat accounting lockless.
      quota: unify quota init condition in setattr

Eric Sandeen (1):
      ext3: make barrier options consistent with ext4

Francis Moreau (1):
      ext2: remove useless call to brelse() in ext2_free_inode()

Frans van de Wiel (1):
      ext3: Avoid loading bitmaps for full groups during block allocation

Jan Blunck (7):
      ext2: Use ext2_clear_super_error() in ext2_sync_fs()
      ext2: Set the write time in ext2_sync_fs()
      ext2: Remove duplicate code from ext2_sync_fs()
      ext2: Fold ext2_commit_super() into ext2_sync_super()
      ext2: Move ext2_write_super() out of ext2_setup_super()
      ext2: Add ext2_sb_info s_lock spinlock
      BKL: Remove BKL from ext2 filesystem

Jan Kara (11):
      ext2: Avoid loading bitmaps for full groups during block allocation
      jbd: Provide function to check whether transaction will issue data barrier
      ext3: Fix waiting on transaction during fsync
      quota: Refactor dquot_transfer code so that OCFS2 can pass in its references
      ocfs2: Do not map blocks from local quota file on each write
      ocfs2: Avoid unnecessary block mapping when refreshing quota info
      ocfs2: Fix quota locking
      ocfs2: Fix estimate of credits needed for quota allocation
      ocfs2: Fix NULL pointer deref when writing local dquot
      ocfs2: Use __dquot_transfer to avoid lock inversion
      ocfs2: Fix lock inversion in quotas during umount

Jiaying Zhang (1):
      dquot: Detect partial write error to quota file in write_blk() and add printk_ratelimit for quota error messages

Sergey Senozhatsky (1):
      suppress warning: "quotatypes" defined but not used

The diffstat is

 Documentation/filesystems/ext3.txt |   15 ++-
 fs/ext2/balloc.c                   |    6 +
 fs/ext2/ialloc.c                   |    9 +-
 fs/ext2/inode.c                    |    7 +-
 fs/ext2/super.c                    |   99 +++++------
 fs/ext2/xattr.c                    |    2 +
 fs/ext3/balloc.c                   |    6 +
 fs/ext3/fsync.c                    |   20 +--
 fs/ext3/inode.c                    |    2 +-
 fs/ext3/super.c                    |   77 +++++---
 fs/ext4/inode.c                    |    2 +-
 fs/gfs2/quota.c                    |   12 +-
 fs/jbd/commit.c                    |    8 +-
 fs/jbd/journal.c                   |   33 ++++
 fs/jfs/file.c                      |    2 +-
 fs/ocfs2/dlmglue.c                 |    3 +-
 fs/ocfs2/file.c                    |   21 +--
 fs/ocfs2/quota.h                   |   12 +-
 fs/ocfs2/quota_global.c            |  347 +++++++++++++++++++++---------------
 fs/ocfs2/quota_local.c             |  133 +++++++-------
 fs/ocfs2/super.c                   |    4 +
 fs/quota/dquot.c                   |  275 +++++++++++++++++-----------
 fs/quota/quota.c                   |   63 +++++--
 fs/quota/quota_tree.c              |   50 +++---
 fs/quota/quota_tree.h              |    6 +
 fs/quota/quota_v1.c                |    4 +-
 fs/quota/quota_v2.c                |    6 +-
 fs/reiserfs/inode.c                |    3 +-
 fs/udf/file.c                      |    2 +-
 fs/ufs/inode.c                     |    2 +-
 fs/ufs/namei.c                     |    2 +-
 fs/ufs/symlink.c                   |    8 +
 fs/ufs/truncate.c                  |   10 +-
 fs/ufs/ufs.h                       |    2 +
 fs/xfs/linux-2.6/xfs_quotaops.c    |    8 +-
 fs/xfs/quota/xfs_qm_syscalls.c     |   10 +-
 include/linux/dqblk_xfs.h          |    9 +
 include/linux/ext2_fs_sb.h         |    9 +
 include/linux/jbd.h                |    3 +-
 include/linux/quota.h              |   48 ++++--
 include/linux/quotaops.h           |   15 ++-
 41 files changed, 829 insertions(+), 526 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
