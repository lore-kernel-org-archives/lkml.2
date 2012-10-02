Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2JBSBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:01:53 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57718 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755350Ab2JBSBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:01:52 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.7-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20121002180147.DE9534266DC@whiskey.americas.sgi.com>
Date: Tue,  2 Oct 2012 13:01:47 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these XFS updates for 3.7-rc1.  inode32/64 mount options have been
remountable, and there are SEEK_HOLE/SEEK_DATA enhancements.  I believe you
have already merged all of the bug fixes.

Thanks,
	Ben

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc1

for you to fetch changes up to 2ea0392983a82f7dc3055568ae0f2558724d119b:

  xfs: Make inode32 a remountable option (2012-09-26 16:01:28 -0500)

----------------------------------------------------------------
xfs: update for 3.7-rc1

Several enhancements and cleanups:

- make inode32 and inode64 remountable options
- SEEK_HOLE/SEEK_DATA enhancements
- cleanup struct declarations in xfs_mount.h

----------------------------------------------------------------
Alex Elder (1):
      xfs: kill struct declarations in xfs_mount.h

Ben Myers (1):
      xfs: stop the sync worker before xfs_unmountfs

Carlos Maiolino (8):
      xfs: fix race while discarding buffers [V4]
      Make inode64 a remountable option
      xfs: Fix m_agirotor reset during AG selection
      xfs: make inode64 as the default allocation mode
      xfs: reduce code duplication handling inode32/64 options
      xfs: Fix mp->m_maxagi update during inode64 remount
      xfs: add inode64->inode32 transition into xfs_set_inode32()
      xfs: Make inode32 a remountable option

Christoph Hellwig (1):
      xfs: unlock the AGI buffer when looping in xfs_dialloc

Dave Chinner (1):
      xfs: fix uninitialised variable in xfs_rtbuf_get()

Jeff Liu (4):
      xfs: Remove type argument from xfs_seek_data()/xfs_seek_hole()
      xfs: Introduce a helper routine to probe data or hole offset from page cache
      xfs: xfs_seek_data() refinement with unwritten extents check up from page cache
      xfs: xfs_seek_hole() refinement with hole searching from page cache for unwritten extents

Tomas Racek (1):
      xfs: check for possible overflow in xfs_ioc_trim

 fs/xfs/xfs_buf.c     |   5 +-
 fs/xfs/xfs_buf.h     |  41 +++---
 fs/xfs/xfs_discard.c |   6 +-
 fs/xfs/xfs_file.c    | 379 ++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ialloc.c  |  19 +--
 fs/xfs/xfs_mount.c   |  43 +-----
 fs/xfs/xfs_mount.h   |   5 -
 fs/xfs/xfs_rtalloc.c |   2 +-
 fs/xfs/xfs_super.c   |  96 ++++++++++++-
 fs/xfs/xfs_super.h   |   2 +
 fs/xfs/xfs_trace.h   |   1 +
 11 files changed, 490 insertions(+), 109 deletions(-)
