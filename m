Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1C1Vtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:49:47 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58467 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753956Ab1C1Vtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:49:46 -0400
Date: Mon, 28 Mar 2011 16:49:40 -0500
From: Alex Elder <aelder@americas.sgi.com>
Message-Id: <201103282149.p2SLneQ1020631@alcatraz.americas.sgi.com>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS 2nd update for 2.6.39-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS updates for 2.6.39.  I have two
branches for you to choose from:

    git://oss.sgi.com/xfs/xfs for-linus-merged  (recommended)
	This version includes one additional commit--a manual merge
	I completed to fix a merge conflict.  The conflict was
	between Jens Axboe's queue plugging work that you pulled in
	over the weekend, and a change by Dave Chinner to manage XFS
	internal buffers without involvement of the page cache.

    git://oss.sgi.com/xfs/xfs for-linus
	This version contains the XFS changes only, in case you want
	to do the merge yourself.

Thank you.

					-Alex

The following changes since commit 1788c208aab15f9d9d1d24cff0d0c64b5c73bbee:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-28 07:52:58 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus-merged

Alex Elder (1):
      Merge branch 'master' of git://oss.sgi.com/xfs/xfs into for-linus-merged

Dave Chinner (6):
      xfs: preallocation transactions do not need to be synchronous
      vmap: flush vmap aliases when mapping fails
      xfs: introduce inode cluster buffer trylocks for xfs_iflush
      xfs: xfs_trans_read_buf() should return an error on failure
      xfs: register the inode cache shrinker before quotachecks
      xfs: stop using the page cache to back the buffer cache

 fs/xfs/linux-2.6/xfs_buf.c   |  344 +++++++++++-------------------------------
 fs/xfs/linux-2.6/xfs_buf.h   |   40 +-----
 fs/xfs/linux-2.6/xfs_file.c  |    6 +-
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 +
 fs/xfs/linux-2.6/xfs_super.c |   36 +++--
 fs/xfs/linux-2.6/xfs_sync.c  |   30 ++++-
 fs/xfs/xfs_inode.c           |    2 +-
 fs/xfs/xfs_inode_item.c      |    6 +-
 fs/xfs/xfs_trans_buf.c       |    3 +-
 fs/xfs/xfs_vnodeops.c        |    3 +-
 fs/xfs/xfs_vnodeops.h        |    1 +
 11 files changed, 160 insertions(+), 315 deletions(-)
