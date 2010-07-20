Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967382Ab0GTAqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:46:35 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:47315 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966750Ab0GTAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:46:34 -0400
Date: Tue, 20 Jul 2010 10:46:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Shrinker fixes for XFS for 2.6.36-rc6
Message-ID: <20100720004630.GH23223@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following patches address shrinker lockdep and performance
regressions introduced into XFS in 2.6.34 when a shrinker was
added at the last moment to address OOM issues with lazy XFS inode
reclaim.

The first two patches are the saem as I originally posted to solve
the problem for 2.6.34. They did not pass review in time for 2.6.34,
and attempts to address said review comments resulted in a bigger,
more contentious patchset that has much bigger issues than this
patchset. Time has run out and I really don't want to have another
kernel released with XFS causing lockdep to trigger the moment
memory reclaim starts, so I'm asking if you will accept the original
fixes I posted for the problem.

The third patch addresses shrinker inode scanning performance
problems raised in recently here:

https://bugzilla.kernel.org/show_bug.cgi?id=16348

Please consider these commits for 2.6.26-rc6.

Cheers,

Dave.

The following changes since commit d0c6f6258478e1dba532bf7c28e2cd6e1047d3a4:

  Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-07-19 13:19:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev shrinker

Dave Chinner (3):
      mm: add context argument to shrinker callback
      xfs: convert inode shrinker to per-filesystem contexts
      xfs: track AGs with reclaimable inodes in per-ag radix tree

 arch/x86/kvm/mmu.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 fs/dcache.c                     |    2 +-
 fs/gfs2/glock.c                 |    2 +-
 fs/gfs2/quota.c                 |    2 +-
 fs/gfs2/quota.h                 |    2 +-
 fs/inode.c                      |    2 +-
 fs/mbcache.c                    |    5 +-
 fs/nfs/dir.c                    |    2 +-
 fs/nfs/internal.h               |    3 +-
 fs/quota/dquot.c                |    2 +-
 fs/ubifs/shrinker.c             |    2 +-
 fs/ubifs/ubifs.h                |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c      |    5 +-
 fs/xfs/linux-2.6/xfs_super.c    |    2 -
 fs/xfs/linux-2.6/xfs_sync.c     |  130 +++++++++++++++++++++++----------------
 fs/xfs/linux-2.6/xfs_sync.h     |    2 -
 fs/xfs/linux-2.6/xfs_trace.h    |    3 +
 fs/xfs/quota/xfs_qm.c           |    7 ++-
 fs/xfs/xfs_mount.h              |    2 +-
 include/linux/mm.h              |    2 +-
 mm/vmscan.c                     |    8 ++-
 22 files changed, 111 insertions(+), 80 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
