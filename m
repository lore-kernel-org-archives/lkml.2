Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0GBXzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:55:06 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33183 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0GBXzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:55:04 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007022354.o62NsucI020931@stout.americas.sgi.com>
Date: Fri, 02 Jul 2010 18:54:55 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.35-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These five commits implement a few security-related changes to XFS.
One enforces more strict permission checks for swapping file
extents.  Others do a better job of validating information from
untrustworthy sources before using it.

					-Alex

The following changes since commit 123f94f22e3d283dfe68742b269c245b0501ad82:

  Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-07-02 09:52:58 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: always use iget in bulkstat

Dan Rosenberg (1):
      xfs: prevent swapext from operating on write-only files

Dave Chinner (3):
      xfs: validate untrusted inode numbers during lookup
      xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
      xfs: remove block number from inode lookup code

 fs/xfs/linux-2.6/xfs_export.c  |   11 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    7 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |   15 +--
 fs/xfs/quota/xfs_qm.c          |   18 +--
 fs/xfs/quota/xfs_qm_syscalls.c |   27 ++--
 fs/xfs/xfs_dfrag.c             |    5 +-
 fs/xfs/xfs_ialloc.c            |  142 ++++++++++++---------
 fs/xfs/xfs_iget.c              |   10 +-
 fs/xfs/xfs_inode.c             |    5 +-
 fs/xfs/xfs_inode.h             |    6 +-
 fs/xfs/xfs_itable.c            |  285 ++++++----------------------------------
 fs/xfs/xfs_itable.h            |   17 ---
 fs/xfs/xfs_log_recover.c       |    2 +-
 fs/xfs/xfs_mount.c             |    2 +-
 fs/xfs/xfs_rtalloc.c           |    4 +-
 fs/xfs/xfs_trans_inode.c       |    2 +-
 fs/xfs/xfs_vnodeops.c          |    2 +-
 17 files changed, 172 insertions(+), 388 deletions(-)
