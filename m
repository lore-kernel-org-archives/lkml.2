Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2KHWTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:19:08 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33711 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756662Ab2KHWTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:19:03 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.7-rc5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20121108221859.3FF8D4266DC@whiskey.americas.sgi.com>
Date: Thu,  8 Nov 2012 16:18:59 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these 10 bug fixes for XFS.  They include a fix for deadlock on
   allocation group freelist buffers, a fix for corruption on log replay, a fix
   for growfs, and a few more to boot.

   Erm... this is for 3.7-rc5, please.  Sorry for the dup.

Thanks,
      Ben	

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc5

for you to fetch changes up to 6ce377afd1755eae5c93410ca9a1121dfead7b87:

  xfs: fix reading of wrapped log data (2012-11-08 11:10:51 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.7-rc5

- fix for large transactions spanning multiple iclog buffers
- zero the allocation_args structure on the stack before using it
  to determine whether to use a worker for allocation
- move allocation stack switch to xfs_bmapi_allocate in order
  to prevent deadlock on AGF buffers
- growfs no longer reads in garbage for new secondary superblocks
- silence a build warning
- ensure that invalid buffers never get written to disk while on
  free list
- don't vmap inode cluster buffers during free
- fix buffer shutdown reference count mismatch
- fix reading of wrapped log data

----------------------------------------------------------------
Dave Chinner (9):
      xfs: only update the last_sync_lsn when a transaction completes
      xfs: introduce XFS_BMAPI_STACK_SWITCH
      xfs: move allocation stack switch up to xfs_bmapi_allocate
      xfs: growfs: don't read garbage for new secondary superblocks
      xfs: silence uninitialised f.file warning.
      xfs: invalidate allocbt blocks moved to the free list
      xfs: don't vmap inode cluster buffers during free
      xfs: fix buffer shudown reference count mismatch
      xfs: fix reading of wrapped log data

Mark Tinguely (1):
      xfs: zero allocation_args on the kernel stack

 fs/xfs/xfs_alloc.c       | 43 ++-------------------------------
 fs/xfs/xfs_alloc.h       |  3 ---
 fs/xfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_bmap.c        | 63 +++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_bmap.h        |  9 ++++++-
 fs/xfs/xfs_buf_item.c    | 18 ++++++++++++++
 fs/xfs/xfs_fsops.c       | 21 ++++++++++++++--
 fs/xfs/xfs_ialloc.c      |  1 +
 fs/xfs/xfs_inode.c       |  3 ++-
 fs/xfs/xfs_ioctl.c       |  2 +-
 fs/xfs/xfs_iomap.c       |  4 ++-
 fs/xfs/xfs_log.c         | 19 ++++++++++++---
 fs/xfs/xfs_log_recover.c |  2 +-
 13 files changed, 127 insertions(+), 63 deletions(-)
