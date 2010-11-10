Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0KJW6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:58:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:40734 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab0KJW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:58:09 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201011102258.oAAMw2fT017804@stout.americas.sgi.com>
Date: Wed, 10 Nov 2010 16:58:02 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.37-rc2
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please include the following patches in 2.6.37-rc2 (or if
it's too late for that, 2.6.37-rc3).

The first one simply drops a "this is an experimental feature"
warning message; this has been planned for 2.6.37 since earlier this
year.  The next two are simple cleanups, and the fourth makes use of
the newly available hlist_add_fake().

The last four fix real bugs and are the most imporant.

Thanks.

					-Alex

The following changes since commit f6614b7bb405a9b35dd28baea989a749492c46b2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-11-09 10:34:48 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (5):
      xfs: remove experimental tag from the delaylog option
      xfs: tell lockdep about parent iolock usage in filestreams
      xfs: fix a few compiler warnings with CONFIG_XFS_QUOTA=n
      xfs: use hlist_add_fake
      xfs: remove incorrect assert in xfs_vm_writepage

Dave Chinner (2):
      xfs: fix per-ag reference counting in inode reclaim tree walking
      xfs: move delayed write buffer trace

Kulikov Vasiliy (1):
      xfs: xfs_ioctl: fix information leak to userland

 .../filesystems/xfs-delayed-logging-design.txt     |   11 -----------
 fs/xfs/linux-2.6/xfs_aops.c                        |    7 ++++---
 fs/xfs/linux-2.6/xfs_buf.c                         |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                       |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c                        |    3 ++-
 fs/xfs/linux-2.6/xfs_super.c                       |    3 ---
 fs/xfs/linux-2.6/xfs_sync.c                        |    1 +
 fs/xfs/xfs_filestream.c                            |    8 +++++++-
 fs/xfs/xfs_mount.c                                 |    1 +
 fs/xfs/xfs_quota.h                                 |   20 ++++++++++++++++----
 10 files changed, 33 insertions(+), 25 deletions(-)
