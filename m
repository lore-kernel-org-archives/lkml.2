Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab1HLUwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:52:30 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1HLUw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:52:29 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201108122052.p7CKqPMl022987@stout.americas.sgi.com>
Date: Fri, 12 Aug 2011 15:52:24 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.1-rc2
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following updates for XFS for 3.1-rc2.

FYI  We are eliminating the subdirectory structure under fs/xfs/.
The changes are simple but I'm holding off sending them until next
week sometime (unless you have another preference).

Thanks.

					-Alex

The following changes since commit 72fa59970f8698023045ab0713d66f3f4f96945c:

  move RLIMIT_NPROC check from set_user() to do_execve_common() (2011-08-11 11:24:42 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Ajeet Yadav (1):
      "xfs: fix error handling for synchronous writes" revisited

Alex Elder (2):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux
      xfs: set cursor in xfs_ail_splice() even when AIL was empty

Chandra Seetharaman (13):
      xfs: Remove the macro XFS_BUF_BFLAGS
      xfs: Remove the macro XFS_BUF_ERROR and family
      xfs: Remove macro XFS_BUF_BUSY and family
      xfs: Remove macro XFS_BUF_HOLD
      xfs: Remove macro XFS_BUF_SET_START
      xfs: Remove the macro XFS_BUF_PTR
      xfs: Remove the macro XFS_BUF_SET_PTR
      Replace the macro XFS_BUF_ISPINNED with helper xfs_buf_ispinned
      xfs: Remove the macro XFS_BUF_SET_TARGET
      xfs: Remove the macro XFS_BUF_TARGET
      xfs: Remove the macro XFS_BUFTARG_NAME
      xfs: Check the return value of xfs_buf_read() for NULL
      xfs: replace xfs_buf_geterror() with bp->b_error

 fs/xfs/linux-2.6/xfs_buf.c  |   15 ++++-----
 fs/xfs/linux-2.6/xfs_buf.h  |   32 +++++++-------------
 fs/xfs/linux-2.6/xfs_sync.c |    2 +-
 fs/xfs/quota/xfs_dquot.c    |   16 ++++------
 fs/xfs/quota/xfs_qm.c       |    2 +-
 fs/xfs/xfs_ag.h             |    6 ++--
 fs/xfs/xfs_alloc.c          |    7 ++--
 fs/xfs/xfs_attr.c           |    3 +-
 fs/xfs/xfs_bmap.c           |    3 +-
 fs/xfs/xfs_btree.c          |   17 ++++-------
 fs/xfs/xfs_btree.h          |    2 +-
 fs/xfs/xfs_buf_item.c       |   24 ++++++---------
 fs/xfs/xfs_da_btree.c       |   12 ++++----
 fs/xfs/xfs_dinode.h         |    2 +-
 fs/xfs/xfs_ialloc.c         |    5 +--
 fs/xfs/xfs_inode.c          |    4 +-
 fs/xfs/xfs_log.c            |   14 +++------
 fs/xfs/xfs_log_recover.c    |   38 ++++++++++++------------
 fs/xfs/xfs_mount.c          |    4 +-
 fs/xfs/xfs_rtalloc.c        |   32 ++++++++++----------
 fs/xfs/xfs_rtalloc.h        |    2 +-
 fs/xfs/xfs_rw.c             |    8 ++--
 fs/xfs/xfs_sb.h             |    2 +-
 fs/xfs/xfs_trans_ail.c      |   67 ++++++++++++++++++------------------------
 fs/xfs/xfs_trans_buf.c      |   28 ++++++------------
 fs/xfs/xfs_vnodeops.c       |   12 ++++---
 26 files changed, 155 insertions(+), 204 deletions(-)
