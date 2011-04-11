Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1DKOj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:39:26 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751395Ab1DKOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:39:25 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201104111439.p3BEdGTc005062@stout.americas.sgi.com>
Date: Mon, 11 Apr 2011 09:39:16 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS 2nd update for 2.6.39-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS changes for 2.6.39-rc3.

They fall into these categories:
- switching XFS daemons over to use workqueues, taking advantage of
  the recent global workqueue improvements
- improving how the new per-process device plugging is used in XFS
- alleviating some OOM issues reported by Chris Mason
- reducing memory use in some log code (where it could needlessly
  allocate much more than required)
- checking for and reporting bad extents when they are found during
  free (instead of using ASSERT())
- eliminating warnings (some of which have begun to show up with
  newer gcc)

Thank you.

					-Alex

The following changes since commit 4263a2f1dad8c8e7ce2352a0cbc882c2b0c044a9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-04-10 09:56:10 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: fix variable set but not used warnings
      xfs: fix xfs_debug warnings
      xfs: use proper interfaces for on-stack plugging

Dave Chinner (10):
      xfs: fix unreferenced var error in xfs_buf.c
      xfs: fix extent format buffer allocation size
      xfs: introduce a xfssyncd workqueue
      xfs: convert ENOSPC inode flushing to use new syncd workqueue
      xfs: introduce background inode reclaim work
      xfs: convert the xfsaild threads to a workqueue
      xfs: clean up code layout in xfs_trans_ail.c
      xfs: push the AIL from memory reclaim and periodic sync
      xfs: catch bad block numbers freeing extents.
      xfs: convert log tail checking to a warning

 fs/xfs/linux-2.6/xfs_buf.c     |   24 +--
 fs/xfs/linux-2.6/xfs_message.c |   27 +--
 fs/xfs/linux-2.6/xfs_message.h |   24 ++-
 fs/xfs/linux-2.6/xfs_super.c   |  129 +++++--------
 fs/xfs/linux-2.6/xfs_sync.c    |  228 +++++++++++-----------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +
 fs/xfs/quota/xfs_qm.c          |    7 -
 fs/xfs/quota/xfs_qm.h          |    5 -
 fs/xfs/quota/xfs_qm_syscalls.c |    2 -
 fs/xfs/xfs_alloc.c             |   30 +++-
 fs/xfs/xfs_inode_item.c        |   67 ++++---
 fs/xfs/xfs_itable.c            |    2 -
 fs/xfs/xfs_log.c               |   38 +++-
 fs/xfs/xfs_log_priv.h          |    1 +
 fs/xfs/xfs_mount.h             |    9 +-
 fs/xfs/xfs_trans_ail.c         |  421 ++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h        |   22 ++-
 17 files changed, 531 insertions(+), 507 deletions(-)
