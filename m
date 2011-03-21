Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1CUVOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:14:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754546Ab1CUVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:14:29 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103212114.p2LLELei031028@stout.americas.sgi.com>
Date: Mon, 21 Mar 2011 16:14:21 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.39-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 10effcb548c170d59ea1d2152f2ee0ad45ce4c9d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-21 10:06:51 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      xfs: zero proper structure size for geometry calls
      xfs: don't name variables "panic"

Christoph Hellwig (8):
      xfs: only lock the rt bitmap inode once per allocation
      xfs: fix xfs_get_extsz_hint for a zero extent size hint
      xfs: add lockdep annotations for the rt inodes
      xfs: stop using xfs_trans_iget in the RT allocator
      xfs: more sensible inode refcounting for ialloc
      xfs: enable delaylog by default
      xfs: clean up the xfs_alloc_compute_aligned calling convention
      xfs: factor agf counter updates into a helper

Dan Rosenberg (1):
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Dave Chinner (11):
      xfs: introduce new logging API.
      xfs: Convert linux-2.6/ files to new logging interface
      xfs: Convert xlog_warn to new logging interface
      xfs: convert xfs_cmn_err to xfs_alert_tag
      xfs: kill xfs_fs_repair_cmn_err() macro
      xfs: kill xfs_fs_mount_cmn_err() macro
      xfs: convert xfs_fs_cmn_err to new error logging API
      xfs: rename xfs_cmn_err_fsblock_zero()
      xfs: convert the quota debug prints to new API
      xfs: Convert remaining cmn_err() callers to new API
      xfs: kill support/debug.[ch]

Lukas Czerner (1):
      xfs: check if device support discard in xfs_ioc_trim()

 .../filesystems/xfs-delayed-logging-design.txt     |    7 -
 fs/xfs/Makefile                                    |    5 +-
 fs/xfs/linux-2.6/kmem.c                            |    9 +-
 fs/xfs/linux-2.6/xfs_aops.c                        |    6 +-
 fs/xfs/linux-2.6/xfs_buf.c                         |   17 +-
 fs/xfs/linux-2.6/xfs_discard.c                     |    2 +
 fs/xfs/linux-2.6/xfs_ioctl.c                       |   11 +-
 fs/xfs/linux-2.6/xfs_linux.h                       |   23 ++-
 fs/xfs/linux-2.6/xfs_message.c                     |  133 ++++++++++++
 fs/xfs/linux-2.6/xfs_message.h                     |   38 ++++
 fs/xfs/linux-2.6/xfs_super.c                       |  128 +++++------
 fs/xfs/linux-2.6/xfs_sync.c                        |    5 +-
 fs/xfs/linux-2.6/xfs_sysctl.c                      |    2 +-
 fs/xfs/quota/xfs_dquot.c                           |   48 +++--
 fs/xfs/quota/xfs_dquot_item.c                      |    5 +-
 fs/xfs/quota/xfs_qm.c                              |   49 ++---
 fs/xfs/quota/xfs_qm_bhv.c                          |    3 +-
 fs/xfs/quota/xfs_qm_syscalls.c                     |   85 ++++----
 fs/xfs/quota/xfs_trans_dquot.c                     |    5 +-
 fs/xfs/support/debug.c                             |  107 ----------
 fs/xfs/support/debug.h                             |   61 ------
 fs/xfs/xfs_alloc.c                                 |  160 +++++++-------
 fs/xfs/xfs_bmap.c                                  |   24 ++-
 fs/xfs/xfs_buf_item.c                              |   15 +-
 fs/xfs/xfs_da_btree.c                              |    9 +-
 fs/xfs/xfs_dfrag.c                                 |    4 +-
 fs/xfs/xfs_dir2.c                                  |    2 +-
 fs/xfs/xfs_dir2_node.c                             |   25 +--
 fs/xfs/xfs_error.c                                 |   22 +-
 fs/xfs/xfs_error.h                                 |   19 +--
 fs/xfs/xfs_fsops.c                                 |    9 +-
 fs/xfs/xfs_ialloc.c                                |   82 +++-----
 fs/xfs/xfs_inode.c                                 |  129 +++++------
 fs/xfs/xfs_inode.h                                 |   23 ++-
 fs/xfs/xfs_iomap.c                                 |   12 +-
 fs/xfs/xfs_log.c                                   |  124 +++++------
 fs/xfs/xfs_log_priv.h                              |    4 -
 fs/xfs/xfs_log_recover.c                           |  223 ++++++++++----------
 fs/xfs/xfs_mount.c                                 |  148 +++++++-------
 fs/xfs/xfs_quota.h                                 |    3 +-
 fs/xfs/xfs_rtalloc.c                               |   92 ++++-----
 fs/xfs/xfs_rtalloc.h                               |    2 +-
 fs/xfs/xfs_rw.c                                    |   58 ++---
 fs/xfs/xfs_trans.h                                 |    2 -
 fs/xfs/xfs_trans_ail.c                             |    2 +-
 fs/xfs/xfs_trans_buf.c                             |    6 +-
 fs/xfs/xfs_trans_inode.c                           |   22 --
 fs/xfs/xfs_vnodeops.c                              |   74 ++-----
 48 files changed, 961 insertions(+), 1083 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_message.c
 create mode 100644 fs/xfs/linux-2.6/xfs_message.h
 delete mode 100644 fs/xfs/support/debug.c
 delete mode 100644 fs/xfs/support/debug.h
