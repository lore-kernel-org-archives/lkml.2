Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1AaQmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:42:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751404Ab1AaQmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:42:38 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
Date: Mon, 31 Jan 2011 10:42:33 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.38-rc3
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please accept the following updates for XFS, for 2.6.38-rc3
(if it's not too late) or 2.6.38-rc4.

They are all fixes for bugs that have some pretty undesirable
consequences.  They address:
- One spot in which a hang can occur due to neglecting to drop a
  lock
- A bug which in some cases a bogus block number can be recorded in
  a block map btree, resulting in a subsequent BUG_ON().
- Two memory leaks
- Three places in which extent sizes are allowed to exceed various
  size limits
- One place where code depends on behavior that is not well-defined
  by the C standard
- One problem in handling transaction commit errors

Thank you.

					-Alex

The following changes since commit 70d1f365568e0cdbc9f4ab92428e1830fdb09ab0:

  Merge branch 'for-linus' of git://git.infradead.org/ubi-2.6 (2011-01-31 13:04:51 +1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (8):
      xfs: fix log ticket leak on forced shutdown.
      xfs: fix efi item leak on forced shutdown
      xfs: speculative delayed allocation uses rounddown_power_of_2 badly
      xfs: limit extent length for allocation to AG size
      xfs: prevent extsize alignment from exceeding maximum extent size
      xfs: limit extsize to size of AGs and/or MAXEXTLEN
      xfs: handle CIl transaction commit failures correctly
      xfs: fix dquot shaker deadlock

bpm@sgi.com (1):
      xfs: xfs_bmap_add_extent_delay_real should init br_startblock

 fs/xfs/linux-2.6/xfs_ioctl.c |   20 ++++++++++++-
 fs/xfs/quota/xfs_qm.c        |   46 ++++++++++++++-----------------
 fs/xfs/xfs_alloc.h           |   16 +++++++++++
 fs/xfs/xfs_bmap.c            |   61 +++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_buf_item.c        |   12 +++++---
 fs/xfs/xfs_extfree_item.c    |    3 +-
 fs/xfs/xfs_iomap.c           |    7 ++++-
 fs/xfs/xfs_log.h             |    2 +-
 fs/xfs/xfs_log_cil.c         |   15 ++++------
 fs/xfs/xfs_trans.c           |   41 ++++++++++++++++++++-------
 10 files changed, 152 insertions(+), 71 deletions(-)
