Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0EYDTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 23:19:47 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57612 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755662Ab0EYDTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 23:19:46 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201005250319.o4P3JexR027722@stout.americas.sgi.com>
Date: Mon, 24 May 2010 22:19:40 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.35-rc1 (2 of 2)
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second set of changes for XFS for 2.6.35-rc1.	-Alex

The following changes since commit 7e125f7b9cbfce4101191b8076d606c517a73066:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6 (2010-05-24 08:05:29 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'delayed-logging-for-2.6.35' into for-linus

Dave Chinner (12):
      xfs: Don't reuse the same transaction ID for duplicated transactions.
      xfs: allow log ticket allocation to take allocation flags
      xfs: modify buffer item reference counting
      xfs: Clean up XFS_BLI_* flag namespace
      xfs: clean up log ticket overrun debug output
      xfs: make the log ticket ID available outside the log infrastructure
      xfs: Improve scalability of busy extent tracking
      xfs: Delayed logging design documentation
      xfs: Introduce delayed logging core code
      xfs: forced unmounts need to push the CIL
      xfs: enable background pushing of the CIL
      xfs: Ensure inode allocation buffers are fully replayed

 .../filesystems/xfs-delayed-logging-design.txt     |  816 ++++++++++++++++++++
 fs/xfs/Makefile                                    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c                         |    9 +
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 +
 fs/xfs/linux-2.6/xfs_super.c                       |   12 +-
 fs/xfs/linux-2.6/xfs_trace.h                       |   83 ++-
 fs/xfs/quota/xfs_dquot.c                           |    6 +-
 fs/xfs/xfs_ag.h                                    |   24 +-
 fs/xfs/xfs_alloc.c                                 |  357 ++++++---
 fs/xfs/xfs_alloc.h                                 |    7 +-
 fs/xfs/xfs_alloc_btree.c                           |    2 +-
 fs/xfs/xfs_buf_item.c                              |  166 ++--
 fs/xfs/xfs_buf_item.h                              |   18 +-
 fs/xfs/xfs_error.c                                 |    2 +-
 fs/xfs/xfs_log.c                                   |  120 +++-
 fs/xfs/xfs_log.h                                   |   14 +-
 fs/xfs/xfs_log_cil.c                               |  725 +++++++++++++++++
 fs/xfs/xfs_log_priv.h                              |  118 +++-
 fs/xfs/xfs_log_recover.c                           |   46 +-
 fs/xfs/xfs_log_recover.h                           |    2 +-
 fs/xfs/xfs_mount.h                                 |    1 +
 fs/xfs/xfs_trans.c                                 |  144 +++-
 fs/xfs/xfs_trans.h                                 |   44 +-
 fs/xfs/xfs_trans_buf.c                             |   46 +-
 fs/xfs/xfs_trans_item.c                            |  114 +---
 fs/xfs/xfs_trans_priv.h                            |   15 +-
 fs/xfs/xfs_types.h                                 |    2 +
 27 files changed, 2382 insertions(+), 513 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt
 create mode 100644 fs/xfs/xfs_log_cil.c
