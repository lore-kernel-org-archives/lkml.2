Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0HYH2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:28:19 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:59424 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124Ab0HYH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:28:17 -0400
Date: Wed, 25 Aug 2010 17:28:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [GIT PULL] xfs: Fixes for 2.6.36-rc3
Message-ID: <20100825072809.GO31488@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the XFS and writeback related fixes from the
tree below? There are writeback efficieny fixes, data integrity
fixes, race and sanity fixes for the delayed logging mode, making
the filesystem idle correctly (no more disk writes every 30s),
ensuring df doesn't return negative free inode counts and fixing
a thinko in the untrusted inode validation code.

Thanks,,

Dave.

The following changes since commit 9ee47476d6734c9deb9ae9ab05d963302f6b6150:

  Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev (2010-08-22 19:55:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git 2.6.36-fixes

Christoph Hellwig (1):
      xfs: do not discard page cache data on EAGAIN

Dave Chinner (8):
      xfs: unlock items before allowing the CIL to commit
      xfs: ensure we mark all inodes in a freed cluster XFS_ISTALE
      xfs: fix untrusted inode number lookup
      writeback: write_cache_pages doesn't terminate at nr_to_write <= 0
      xfs: handle negative wbc->nr_to_write during sync writeback
      xfs: dummy transactions should not dirty VFS state
      xfs: Reduce log force overhead for delayed logging
      xfs: don't do memory allocation under the CIL context lock

Stuart Brodsky (1):
      xfs: ensure f_ffree returned by statfs() is non-negative

 fs/xfs/linux-2.6/xfs_aops.c  |   13 ++-
 fs/xfs/linux-2.6/xfs_super.c |    9 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   42 +------
 fs/xfs/xfs_fsops.c           |   31 +++--
 fs/xfs/xfs_fsops.h           |    2 +-
 fs/xfs/xfs_ialloc.c          |   16 ++-
 fs/xfs/xfs_inode.c           |   49 ++++----
 fs/xfs/xfs_log.c             |    7 +-
 fs/xfs/xfs_log_cil.c         |  263 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h        |   13 ++-
 fs/xfs/xfs_trans.c           |    5 +-
 fs/xfs/xfs_trans_priv.h      |    3 +-
 mm/page-writeback.c          |   26 ++---
 13 files changed, 261 insertions(+), 218 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
