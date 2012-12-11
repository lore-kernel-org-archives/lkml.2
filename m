Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2LKTKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:10:25 -0500
Received: from relay3.sgi.com ([192.48.152.1]:54477 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753917Ab2LKTKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:10:24 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.8-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20121211191019.82A444266DC@whiskey.americas.sgi.com>
Date: Tue, 11 Dec 2012 13:10:19 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these XFS updates for 3.8-rc1.  There is plenty going on, including
the cleanup of xfssyncd, metadata verifiers, CRC infrastructure for the log,
tracking of inodes with speculative allocation, a cleanup of xfs_fs_subr.c,
fixes for XFS_IOC_ZERO_RANGE, and important fix related to log replay (only
update the last_sync_lsn when a transaction completes), a fix for deadlock on
AGF buffers, documentation and comment updates, and a few more cleanups and
fixes.

Thanks,
Ben

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.8-rc1

for you to fetch changes up to f9668a09e32ac6d2aa22f44cc310e430a8f4a40f:

  xfs: fix sparse reported log CRC endian issue (2012-12-03 12:10:59 -0600)

----------------------------------------------------------------
xfs: update for 3.8-rc1

- remove the xfssyncd mess
- only update the last_sync_lsn when a transaction completes
- zero allocation_args on the kernel stack
- fix AGF/alloc workqueue deadlock
- silence uninitialised f.file warning
- Update inode alloc comments
- Update mount options documentation
- report projid32bit feature in geometry call
- speculative preallocation inode tracking
- fix attr tree double split corruption
- fix broken error handling in xfs_vm_writepage
- drop buffer io reference when a bad bio is built
- add more attribute tree trace points
- growfs infrastructure changes for 3.8
- fs/xfs/xfs_fs_subr.c die die die
- add CRC infrastructure
- add CRC checks to the log
- Remove description of nodelaylog mount option from xfs.txt
- inode allocation should use unmapped buffers
- byte range granularity for XFS_IOC_ZERO_RANGE
- fix direct IO nested transaction deadlock
- fix stray dquot unlock when reclaiming dquots
- fix sparse reported log CRC endian issue

----------------------------------------------------------------
Andrew Dahl (1):
      xfs: reverse the check on XFS_IOC_ZERO_RANGE

Brian Foster (10):
      xfs: add EOFBLOCKS inode tagging/untagging
      xfs: support a tag-based inode_ag_iterator
      xfs: create helper to check whether to free eofblocks on inode
      xfs: make xfs_free_eofblocks() non-static, return EAGAIN on trylock failure
      xfs: create function to scan and clear EOFBLOCKS inodes
      xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
      xfs: add inode id filtering to eofblocks scan
      xfs: support multiple inode id filtering in eofblocks scan
      xfs: add minimum file size filtering to eofblocks scan
      xfs: add background scanning to clear eofblocks inodes

Carlos Maiolino (2):
      xfs: Update inode alloc comments
      xfs: Update mount options documentation

Christoph Hellwig (2):
      xfs: add CRC infrastructure
      xfs: add CRC checks to the log

Dave Chinner (60):
      xfs: xfs_syncd_stop must die
      xfs: rationalise xfs_mount_wq users
      xfs: don't run the sync work if the filesystem is read-only
      xfs: sync work is now only periodic log work
      xfs: Bring some sanity to log unmounting
      xfs: xfs_sync_data is redundant.
      xfs: syncd workqueue is no more
      xfs: xfs_sync_fsdata is redundant
      xfs: move xfs_quiesce_attr() into xfs_super.c
      xfs: xfs_quiesce_attr() should quiesce the log like unmount
      xfs: rename xfs_sync.[ch] to xfs_icache.[ch]
      xfs: move inode locking functions to xfs_inode.c
      xfs: remove xfs_iget.c
      xfs: only update the last_sync_lsn when a transaction completes
      xfs: introduce XFS_BMAPI_STACK_SWITCH
      xfs: move allocation stack switch up to xfs_bmapi_allocate
      xfs: growfs: don't read garbage for new secondary superblocks
      xfs: silence uninitialised f.file warning.
      xfs: invalidate allocbt blocks moved to the free list
      xfs: don't vmap inode cluster buffers during free
      xfs: fix buffer shudown reference count mismatch
      xfs: fix reading of wrapped log data
      xfs: fix attr tree double split corruption
      xfs: fix broken error handling in xfs_vm_writepage
      xfs: drop buffer io reference when a bad bio is built
      xfs: add more attribute tree trace points.
      xfs: use btree block initialisation functions in growfs
      xfs: growfs: use uncached buffers for new headers
      xfs: make growfs initialise the AGFL header
      xfs: remove xfs_tosspages
      xfs: remove xfs_wait_on_pages()
      xfs: remove xfs_flush_pages
      xfs: remove xfs_flushinval_pages
      xfs: make buffer read verication an IO completion function
      xfs: uncached buffer reads need to return an error
      xfs: verify superblocks as they are read from disk
      xfs: verify AGF blocks as they are read from disk
      xfs: verify AGI blocks as they are read from disk
      xfs: verify AGFL blocks as they are read from disk
      xfs: verify inode buffers as they are read from disk
      xfs: verify btree blocks as they are read from disk
      xfs: verify dquot blocks as they are read from disk
      xfs: add verifier callback to directory read code
      xfs: factor dir2 block read operations
      xfs: verify dir2 block format buffers
      xfs: factor dir2 free block reading
      xfs: factor out dir2 data block reading
      xfs: factor dir2 leaf read
      xfs: factor and verify attr leaf reads
      xfs: add xfs_da_node verification
      xfs: Add verifiers to dir2 data readahead.
      xfs: add buffer pre-write callback
      xfs: add pre-write metadata buffer verifier callbacks
      xfs: connect up write verifiers to new buffers
      xfs: convert buffer verifiers to an ops structure.
      xfs: inode allocation should use unmapped buffers.
      xfs: byte range granularity for XFS_IOC_ZERO_RANGE
      xfs: fix direct IO nested transaction deadlock.
      xfs: fix stray dquot unlock when reclaiming dquots
      xfs: fix sparse reported log CRC endian issue

Eric Sandeen (1):
      xfs: report projid32bit feature in geometry call

Mark Tinguely (1):
      xfs: zero allocation_args on the kernel stack

Satoru Takeuchi (1):
      xfs: Remove the description of nodelaylog mount option from xfs.txt

 Documentation/filesystems/xfs.txt   |  13 +-
 fs/xfs/Kconfig                      |   1 +
 fs/xfs/Makefile                     |   4 +-
 fs/xfs/uuid.h                       |   6 +
 fs/xfs/xfs_ag.h                     |   5 +
 fs/xfs/xfs_alloc.c                  | 183 +++++---
 fs/xfs/xfs_alloc.h                  |   6 +-
 fs/xfs/xfs_alloc_btree.c            |  79 ++++
 fs/xfs/xfs_alloc_btree.h            |   2 +
 fs/xfs/xfs_aops.c                   | 137 +++---
 fs/xfs/xfs_attr.c                   | 103 ++--
 fs/xfs/xfs_attr_leaf.c              | 163 ++++---
 fs/xfs/xfs_attr_leaf.h              |   6 +
 fs/xfs/xfs_bmap.c                   | 127 +++--
 fs/xfs/xfs_bmap.h                   |   9 +-
 fs/xfs/xfs_bmap_btree.c             |  63 +++
 fs/xfs/xfs_bmap_btree.h             |   1 +
 fs/xfs/xfs_btree.c                  | 111 +++--
 fs/xfs/xfs_btree.h                  |  22 +-
 fs/xfs/xfs_buf.c                    |  73 ++-
 fs/xfs/xfs_buf.h                    |  27 +-
 fs/xfs/xfs_buf_item.c               |  18 +
 fs/xfs/xfs_cksum.h                  |  63 +++
 fs/xfs/xfs_da_btree.c               | 141 +++++-
 fs/xfs/xfs_da_btree.h               |  10 +-
 fs/xfs/xfs_dfrag.c                  |  13 +-
 fs/xfs/xfs_dir2_block.c             | 436 +++++++++--------
 fs/xfs/xfs_dir2_data.c              | 170 +++++--
 fs/xfs/xfs_dir2_leaf.c              | 172 +++++--
 fs/xfs/xfs_dir2_node.c              | 288 ++++++++----
 fs/xfs/xfs_dir2_priv.h              |  19 +-
 fs/xfs/xfs_dquot.c                  | 134 +++++-
 fs/xfs/xfs_dquot.h                  |   2 +
 fs/xfs/xfs_export.c                 |   1 +
 fs/xfs/xfs_file.c                   |  42 +-
 fs/xfs/xfs_fs.h                     |  33 +-
 fs/xfs/xfs_fs_subr.c                |  96 ----
 fs/xfs/xfs_fsops.c                  | 158 +++++--
 fs/xfs/xfs_globals.c                |   4 +-
 fs/xfs/xfs_ialloc.c                 |  84 +++-
 fs/xfs/xfs_ialloc.h                 |   4 +-
 fs/xfs/xfs_ialloc_btree.c           |  55 +++
 fs/xfs/xfs_ialloc_btree.h           |   2 +
 fs/xfs/{xfs_sync.c => xfs_icache.c} | 914 +++++++++++++++++++++++++-----------
 fs/xfs/{xfs_sync.h => xfs_icache.h} |  28 +-
 fs/xfs/xfs_iget.c                   | 705 ---------------------------
 fs/xfs/xfs_inode.c                  | 440 ++++++++++++++---
 fs/xfs/xfs_inode.h                  |  12 +-
 fs/xfs/xfs_ioctl.c                  |  23 +-
 fs/xfs/xfs_iomap.c                  |  35 +-
 fs/xfs/xfs_iops.c                   |   8 +-
 fs/xfs/xfs_itable.c                 |   4 +-
 fs/xfs/xfs_linux.h                  |   2 +
 fs/xfs/xfs_log.c                    | 260 ++++++++--
 fs/xfs/xfs_log.h                    |   4 +
 fs/xfs/xfs_log_priv.h               |  12 +-
 fs/xfs/xfs_log_recover.c            | 148 +++---
 fs/xfs/xfs_mount.c                  | 163 ++++---
 fs/xfs/xfs_mount.h                  |  13 +-
 fs/xfs/xfs_qm.c                     |  22 +-
 fs/xfs/xfs_qm_syscalls.c            |   6 +-
 fs/xfs/xfs_rtalloc.c                |  16 +-
 fs/xfs/xfs_sb.h                     |   7 +
 fs/xfs/xfs_super.c                  | 148 ++++--
 fs/xfs/xfs_super.h                  |   1 +
 fs/xfs/xfs_sysctl.c                 |   9 +
 fs/xfs/xfs_sysctl.h                 |   1 +
 fs/xfs/xfs_trace.h                  |  60 ++-
 fs/xfs/xfs_trans.h                  |  19 +-
 fs/xfs/xfs_trans_buf.c              |   9 +-
 fs/xfs/xfs_vnodeops.c               | 168 +++++--
 fs/xfs/xfs_vnodeops.h               |   9 +-
 72 files changed, 3941 insertions(+), 2391 deletions(-)
 create mode 100644 fs/xfs/xfs_cksum.h
 delete mode 100644 fs/xfs/xfs_fs_subr.c
 rename fs/xfs/{xfs_sync.c => xfs_icache.c} (55%)
 rename fs/xfs/{xfs_sync.h => xfs_icache.h} (64%)
 delete mode 100644 fs/xfs/xfs_iget.c
