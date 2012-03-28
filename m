Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2C1WGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:06:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758531Ab2C1WGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:06:35 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.4 (part 2)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120328220642.920D444925E@whiskey.americas.sgi.com>
Date: Wed, 28 Mar 2012 17:06:42 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull from
   git://oss.sgi.com/xfs/xfs for-linus

   This includes:

   Fixes for tracing of xfs_name strings, flag handling in open_by_handle, a
   log space hang with freeze/unfreeze, fstrim offset calculations, a section
   mismatch with xfs_qm_exit, an oops in xlog_recover_process_iunlinks, and a
   deadlock in xfs_rtfree_extent.  There are also additional trace points for
   attributes, and the addition of a workqueue for allocation to work around
   kernel stack size limitations.

Thanks,
	Ben


The following changes since commit 735e941caa9a35f933297af0ab1e0ad6447411c4:

  Merge tag 'common-clk-api' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-03-28 12:38:06 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: trace xfs_name strings correctly

Dave Chinner (6):
      xfs: Fix open flag handling in open_by_handle code
      xfs: introduce an allocation workqueue
      xfs: don't cache inodes read through bulkstat
      xfs: Account log unmount transaction correctly
      xfs: fix fstrim offset calculations
      xfs: add lots of attribute trace points

Gerard Snitselaar (1):
      fs: xfs: fix section mismatch in linux-next

Jan Kara (1):
      xfs: Fix oops on IO error during xlog_recover_process_iunlinks()

Kamal Dasu (1):
      xfs: fix deadlock in xfs_rtfree_extent

 fs/xfs/xfs_alloc.c       |   36 ++++++++++++++++++++-
 fs/xfs/xfs_alloc.h       |   12 +++++++
 fs/xfs/xfs_attr.c        |   16 +++++++++
 fs/xfs/xfs_attr_leaf.c   |   40 +++++++++++++++++++++--
 fs/xfs/xfs_bmap.c        |    9 +++++
 fs/xfs/xfs_da_btree.c    |   32 +++++++++++++++++++
 fs/xfs/xfs_discard.c     |   61 ++++++++++++++++++++++-------------
 fs/xfs/xfs_dquot.c       |    2 +-
 fs/xfs/xfs_iget.c        |    8 +++-
 fs/xfs/xfs_inode.h       |    4 ++-
 fs/xfs/xfs_ioctl.c       |   14 +++-----
 fs/xfs/xfs_itable.c      |    3 +-
 fs/xfs/xfs_log.c         |    3 +-
 fs/xfs/xfs_log_recover.c |   33 ++++++-------------
 fs/xfs/xfs_rtalloc.c     |    9 ++---
 fs/xfs/xfs_super.c       |   33 +++++++++++++++++++
 fs/xfs/xfs_trace.h       |   78 +++++++++++++++++++++++++++++++++++++++++++---
 17 files changed, 317 insertions(+), 76 deletions(-)
