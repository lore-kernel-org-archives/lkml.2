Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397Ab1CYBiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:38:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab1CYBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:38:14 -0400
Date: Fri, 25 Mar 2011 01:38:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] last major vfs bits for -rc1
Message-ID: <20110325013812.GG22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	autofs4 fixes, inode.c work (lock-splitting).  This is more or less
it for VFS stuff in this window; the rest is going to go into #for-40, and
#for-next once linux-next starts taking .40 material.  There is a couple of
patches in fs/namei.c basically reordering functions and fixing comments
that might be worth pushing before -rc1, but that should be it.

	FWIW, I really hope we'll have saner life this cycle; most of the
joy in the last one had come from massive fs/namei.c series conflicting
with Nick's changes *and* 4 queues hitting the same area (open-by-fhandle,
O_PATH, automounting, atomic open) that had been far beyond "let's have
topic branches and let git merge handle them"; out of those atomic open
has missed the boat, but the rest got serialized and merged.  This time
around we ought to avoid that kind of nightmares, so I'm hoping for
useful #for-next.  Famous last words...

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-linus

Shortlog:

Christoph Hellwig (1):
      fs: simplify iget & friends

Dave Chinner (8):
      fs: protect inode->i_state with inode->i_lock
      fs: factor inode disposal
      fs: Lock the inode LRU list separately
      fs: remove inode_lock from iput_final and prune_icache
      fs: move i_sb_list out from under inode_lock
      fs: move i_wb_list out from under inode_lock
      fs: rename inode_lock to inode_hash_lock
      fs: pull inode->i_lock up out of writeback_single_inode

Ian Kent (6):
      vfs - check non-mountpoint dentry might block in __follow_mount_rcu()
      autofs4 - reinstate last used update on access
      autofs4 - fix dentry leak in autofs4_expire_direct()
      autofs4 - fix autofs4_expire_indirect() traversal
      autofs4 - fix d_manage() return on rcu-walk
      autofs4 - remove autofs4_lock

Jesper Juhl (1):
      autofs4: Do not potentially dereference NULL pointer returned by fget() in autofs_dev_ioc

Diffstat:
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/porting |   16 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/autofs4/autofs_i.h             |    2 -
 fs/autofs4/dev-ioctl.c            |    4 +
 fs/autofs4/expire.c               |   84 ++++--
 fs/autofs4/root.c                 |   62 ++---
 fs/autofs4/waitq.c                |    6 +-
 fs/block_dev.c                    |    6 +-
 fs/buffer.c                       |    2 +-
 fs/drop_caches.c                  |   18 +-
 fs/fs-writeback.c                 |  141 +++++---
 fs/inode.c                        |  656 ++++++++++++++++++-------------------
 fs/internal.h                     |    7 +
 fs/logfs/inode.c                  |    2 +-
 fs/namei.c                        |   23 +-
 fs/notify/inode_mark.c            |   42 ++-
 fs/notify/mark.c                  |    1 -
 fs/notify/vfsmount_mark.c         |    1 -
 fs/ntfs/inode.c                   |    4 +-
 fs/quota/dquot.c                  |   41 ++-
 include/linux/fs.h                |    2 +-
 include/linux/quotaops.h          |    2 +-
 include/linux/writeback.h         |    2 +-
 mm/backing-dev.c                  |    8 +-
 mm/filemap.c                      |   10 +-
 mm/rmap.c                         |    5 +-
 27 files changed, 615 insertions(+), 536 deletions(-)

