Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1GVS1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:27:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38081 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754674Ab1GVS1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:27:14 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107221827.p6MIR9iU015044@stout.americas.sgi.com>
Date: Fri, 22 Jul 2011 13:27:09 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 1 for 3.1-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Revert "xfs: fix filesystsem freeze race in xfs_trans_alloc"

Chandra Seetharaman (2):
      xfs: remove variables that serve no purpose in xfs_alloc_ag_vextent_exact()
      xfs: Remove the second parameter to xfs_sb_count()

Christoph Hellwig (40):
      xfs: PF_FSTRANS should never be set in ->writepage
      xfs: re-enable non-blocking behaviour in xfs_map_blocks
      xfs: work around bogus gcc warning in xfs_allocbt_init_cursor
      xfs: split xfs_setattr
      xfs: always log timestamp updates in xfs_setattr_size
      xfs: kill xfs_itruncate_start
      xfs: split xfs_itruncate_finish
      xfs: improve sync behaviour in the face of aggressive dirtying
      xfs: fix filesystsem freeze race in xfs_trans_alloc
      xfs: remove i_transp
      xfs: kill the unused struct xfs_sync_work
      xfs: factor out xfs_dir2_leaf_find_entry
      xfs: cleanup shortform directory inode number handling
      xfs: kill struct xfs_dir2_sf
      xfs: cleanup the definition of struct xfs_dir2_sf_entry
      xfs: avoid usage of struct xfs_dir2_block
      xfs: kill struct xfs_dir2_block
      xfs: avoid usage of struct xfs_dir2_data
      xfs: kill struct xfs_dir2_data
      xfs: cleanup the definition of struct xfs_dir2_data_entry
      xfs: cleanup struct xfs_dir2_leaf
      xfs: use generic get_unaligned_beXX helpers
      xfs: byteswap constants instead of variables
      xfs: remove the unused xfs_bufhash structure
      xfs: clean up buffer locking helpers
      xfs: return the buffer locked from xfs_buf_get_uncached
      xfs: cleanup I/O-related buffer flags
      xfs: avoid a few disk cache flushes
      xfs: start periodic workers later
      xfs: reshuffle dir2 headers
      xfs: cleanup struct xfs_dir2_free
      xfs: factor out xfs_dir2_leaf_find_stale
      xfs: factor out xfs_da_grow_inode_int
      xfs: add a proper transaction pointer to struct xfs_buf
      xfs: remove wrappers around b_fspriv
      xfs: remove wrappers around b_iodone
      xfs: remove the unused xfs_buf_delwri_sort function
      xfs: remove the dead QUOTADEBUG code
      xfs: remove leftovers of the old btree tracing code
      xfs: remove the dead XFS_DABUF_DEBUG code

Dave Chinner (4):
      xfs: use a cursor for bulk AIL insertion
      xfs: remove confusing ail cursor wrapper
      xfs: convert AIL cursors to use struct list_head
      xfs: add size update tracepoint to IO completion

Eric Sandeen (1):
      xfs: consolidate & clarify mount sanity checks

J. Bruce Fields (1):
      xfs: failure mapping nfs fh to inode should return ESTALE

 fs/xfs/Makefile                |    2 -
 fs/xfs/linux-2.6/xfs_acl.c     |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c    |   20 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   79 ++----
 fs/xfs/linux-2.6/xfs_buf.h     |   64 ++---
 fs/xfs/linux-2.6/xfs_export.c  |    4 +-
 fs/xfs/linux-2.6/xfs_file.c    |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |  433 +++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_linux.h   |    7 +-
 fs/xfs/linux-2.6/xfs_super.c   |   36 +--
 fs/xfs/linux-2.6/xfs_sync.c    |   10 +-
 fs/xfs/linux-2.6/xfs_sync.h    |    8 -
 fs/xfs/linux-2.6/xfs_trace.h   |   60 +---
 fs/xfs/quota/xfs_dquot.c       |   48 +---
 fs/xfs/quota/xfs_dquot.h       |    6 -
 fs/xfs/quota/xfs_qm.c          |   49 +----
 fs/xfs/quota/xfs_qm.h          |    6 -
 fs/xfs/quota/xfs_qm_syscalls.c |  355 +------------------------
 fs/xfs/quota/xfs_trans_dquot.c |   15 +-
 fs/xfs/xfs.h                   |    1 -
 fs/xfs/xfs_alloc.c             |   14 +-
 fs/xfs/xfs_alloc_btree.c       |   84 +------
 fs/xfs/xfs_arch.h              |  136 ---------
 fs/xfs/xfs_attr.c              |   41 ++--
 fs/xfs/xfs_attr_leaf.c         |   60 ++--
 fs/xfs/xfs_bmap.c              |   41 ++--
 fs/xfs/xfs_bmap_btree.c        |  106 +-------
 fs/xfs/xfs_btree.c             |   29 +-
 fs/xfs/xfs_btree.h             |   38 ++--
 fs/xfs/xfs_btree_trace.c       |  249 -----------------
 fs/xfs/xfs_btree_trace.h       |   99 -------
 fs/xfs/xfs_buf_item.c          |   75 +++---
 fs/xfs/xfs_da_btree.c          |  272 ++++++++-----------
 fs/xfs/xfs_da_btree.h          |   13 +-
 fs/xfs/xfs_dir2.c              |  140 ++--------
 fs/xfs/xfs_dir2.h              |   54 +----
 fs/xfs/xfs_dir2_block.c        |  253 ++++++++---------
 fs/xfs/xfs_dir2_block.h        |   92 ------
 fs/xfs/xfs_dir2_data.c         |  327 +++++++++++-----------
 fs/xfs/xfs_dir2_data.h         |  184 ------------
 fs/xfs/xfs_dir2_format.h       |  597 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2_leaf.c         |  417 +++++++++++++++-------------
 fs/xfs/xfs_dir2_leaf.h         |  253 -----------------
 fs/xfs/xfs_dir2_node.c         |  201 ++++----------
 fs/xfs/xfs_dir2_node.h         |  100 -------
 fs/xfs/xfs_dir2_priv.h         |  135 +++++++++
 fs/xfs/xfs_dir2_sf.c           |  338 ++++++++++++++---------
 fs/xfs/xfs_dir2_sf.h           |  171 ------------
 fs/xfs/xfs_fs.h                |    5 +
 fs/xfs/xfs_ialloc.c            |   14 +-
 fs/xfs/xfs_ialloc_btree.c      |   75 -----
 fs/xfs/xfs_iget.c              |    1 -
 fs/xfs/xfs_inode.c             |  537 +++++++++---------------------------
 fs/xfs/xfs_inode.h             |   25 +--
 fs/xfs/xfs_inode_item.c        |   17 +-
 fs/xfs/xfs_inum.h              |   11 -
 fs/xfs/xfs_log.c               |   64 ++---
 fs/xfs/xfs_log_recover.c       |   38 ++--
 fs/xfs/xfs_mount.c             |   71 ++---
 fs/xfs/xfs_mount.h             |    2 +-
 fs/xfs/xfs_trans.c             |   27 ++-
 fs/xfs/xfs_trans_ail.c         |  214 ++++++++-------
 fs/xfs/xfs_trans_buf.c         |  118 ++++-----
 fs/xfs/xfs_trans_inode.c       |    9 -
 fs/xfs/xfs_trans_priv.h        |   14 +-
 fs/xfs/xfs_vnodeops.c          |  479 +-------------------------------
 fs/xfs/xfs_vnodeops.h          |    3 +-
 67 files changed, 2796 insertions(+), 4654 deletions(-)
 delete mode 100644 fs/xfs/xfs_arch.h
 delete mode 100644 fs/xfs/xfs_btree_trace.c
 delete mode 100644 fs/xfs/xfs_btree_trace.h
 delete mode 100644 fs/xfs/xfs_dir2_block.h
 delete mode 100644 fs/xfs/xfs_dir2_data.h
 create mode 100644 fs/xfs/xfs_dir2_format.h
 delete mode 100644 fs/xfs/xfs_dir2_leaf.h
 delete mode 100644 fs/xfs/xfs_dir2_node.h
 create mode 100644 fs/xfs/xfs_dir2_priv.h
 delete mode 100644 fs/xfs/xfs_dir2_sf.h
