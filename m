Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2AESkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:40:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33860 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751494Ab2AESkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:40:21 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.3-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120105184017.089CB426DA7@whiskey.americas.sgi.com>
Date: Thu,  5 Jan 2012 12:40:17 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull the following changes for 3.3-rc1.  There is
   a merge conflict between

   be4f1ac - xfs: log all dirty inodes in xfs_fs_sync_fs
   and
   34625c6 - xfs: remove xfs_qm_sync

   which I have resolved in the for-linus-merged branch for
   your convenience.

Thanks,
	Ben

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
  Linus Torvalds (1):
        Linux 3.2

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (20):
      xfs: remove the deprecated nodelaylog option
      xfs: cleanup the transaction commit path a bit
      xfs: remove the lid_size field in struct log_item_desc
      xfs: untangle SYNC_WAIT and SYNC_TRYLOCK meanings for xfs_qm_dqflush
      xfs: make sure to really flush all dquots in xfs_qm_quotacheck
      xfs: remove xfs_qm_sync
      xfs: remove the sync_mode argument to xfs_qm_dqflush_all
      xfs: cleanup dquot locking helpers
      xfs: cleanup xfs_qm_dqlookup
      xfs: remove XFS_DQ_INACTIVE
      xfs: implement lazy removal for the dquot freelist
      xfs: flatten the dquot lock ordering
      xfs: nest qm_dqfrlist_lock inside the dquot qlock
      xfs: simplify xfs_qm_dqattach_grouphint
      xfs: add a xfs_dqhold helper
      xfs: merge xfs_qm_dqinit_core into the only caller
      xfs: kill xfs_qm_idtodq
      xfs: remove XFS_QMOPT_DQSUSER
      xfs: simplify xfs_qm_detach_gdquots
      xfs: mark the xfssyncd workqueue as non-reentrant

Eric Sandeen (1):
      xfs: remove unused XBT_FORCE_SLEEP bit

Xi Wang (1):
      xfs: fix acl count validation in xfs_acl_from_disk()

 fs/xfs/xfs_acl.c        |    2 +-
 fs/xfs/xfs_buf.c        |    6 +-
 fs/xfs/xfs_buf.h        |    3 +-
 fs/xfs/xfs_dquot.c      |  500 ++++++++++++++++-------------------------------
 fs/xfs/xfs_dquot.h      |   39 +++-
 fs/xfs/xfs_dquot_item.c |    5 +-
 fs/xfs/xfs_inode_item.c |    2 -
 fs/xfs/xfs_log.c        |   79 ++------
 fs/xfs/xfs_log.h        |    8 +-
 fs/xfs/xfs_log_cil.c    |   96 ++++++----
 fs/xfs/xfs_mount.h      |    1 -
 fs/xfs/xfs_qm.c         |  464 ++++++++++---------------------------------
 fs/xfs/xfs_qm.h         |    6 -
 fs/xfs/xfs_quota.h      |   12 +-
 fs/xfs/xfs_super.c      |   36 +---
 fs/xfs/xfs_sync.c       |    6 +-
 fs/xfs/xfs_trace.h      |    2 -
 fs/xfs/xfs_trans.c      |  475 +--------------------------------------------
 fs/xfs/xfs_trans.h      |    3 +-
 19 files changed, 412 insertions(+), 1333 deletions(-)
