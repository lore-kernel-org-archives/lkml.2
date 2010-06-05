Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab0FELRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:17:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40388 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab0FELRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:17:15 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006051117.o55BH8KB006254@stout.americas.sgi.com>
Date: Sat, 05 Jun 2010 06:17:07 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.35-rc2
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7f0d384cafabfbb56663ee6944c18fc0450fc5d6:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2010-06-04 21:12:39 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' into for-linus

Christoph Hellwig (6):
      xfs: cleanup log reservation calculactions
      xfs: clean up xlog_align
      xfs: fix access to upper inodes without inode64
      xfs: remove done roadmap item from xfs-delayed-logging-design.txt
      xfs: skip writeback from reclaim context
      xfs: improve xfs_isilocked

Dave Chinner (3):
      xfs: Check new inode size is OK before preallocating
      xfs: fix might_sleep() warning when initialising per-ag tree
      xfs: fix race in inode cluster freeing failing to stale inodes

Eric Sandeen (2):
      xfs: replace E2BIG with EFBIG where appropriate
      xfs: be more explicit if RT mount fails due to config

Huang Weiyi (2):
      xfs: xfs_trace.c: remove duplicated #include
      xfs: remove duplicated #include

Julia Lawall (1):
      fs/xfs/quota: Add missing mutex_unlock

Li Zefan (1):
      xfs: convert more trace events to DEFINE_EVENT

 .../filesystems/xfs-delayed-logging-design.txt     |    5 -
 fs/xfs/linux-2.6/xfs_aops.c                        |   15 +
 fs/xfs/linux-2.6/xfs_iops.c                        |   16 +-
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 -
 fs/xfs/linux-2.6/xfs_sync.c                        |    9 -
 fs/xfs/linux-2.6/xfs_trace.c                       |    1 -
 fs/xfs/linux-2.6/xfs_trace.h                       |  356 ++++++++--------
 fs/xfs/quota/xfs_qm.c                              |    4 +-
 fs/xfs/xfs_ag.h                                    |    1 -
 fs/xfs/xfs_iget.c                                  |   29 +-
 fs/xfs/xfs_inode.c                                 |  144 +++----
 fs/xfs/xfs_log_recover.c                           |   11 +-
 fs/xfs/xfs_mount.c                                 |   68 ++--
 fs/xfs/xfs_rtalloc.c                               |    4 +-
 fs/xfs/xfs_rtalloc.h                               |   11 +-
 fs/xfs/xfs_trans.c                                 |  446 ++++++++++++++++++--
 fs/xfs/xfs_trans.h                                 |  411 ------------------
 fs/xfs/xfs_vnodeops.c                              |    2 +-
 18 files changed, 736 insertions(+), 798 deletions(-)
