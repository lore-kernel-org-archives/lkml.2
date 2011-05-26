Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab1EZQpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:45:51 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42780 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab1EZQpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:45:50 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201105261645.p4QGjjOv026256@stout.americas.sgi.com>
Date: Thu, 26 May 2011 11:45:45 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 2 for 2.6.40-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:

  tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
      xfs: add online discard support
      xfs: do not discard alloc btree blocks
      xfs: remove the unused XFS_BMAPI_RSVBLOCKS flag
      xfs: remove if_lastex
      xfs: do not use unchecked extent indices in xfs_bmap_add_extent_*
      xfs: do not use unchecked extent indices in xfs_bmapi
      xfs: do not use unchecked extent indices in xfs_bunmapi
      xfs: do not do pointer arithmetic on extent records
      xfs: fix up asserts in xfs_iflush_fork
      xfs: check for valid indices in xfs_iext_get_ext and xfs_iext_idx_to_irec
      xfs: correctly decrement the extent buffer index in xfs_bmap_del_extent

 Documentation/filesystems/xfs.txt |    6 +
 fs/xfs/linux-2.6/xfs_discard.c    |   29 ++
 fs/xfs/linux-2.6/xfs_discard.h    |    2 +
 fs/xfs/linux-2.6/xfs_super.c      |   18 +-
 fs/xfs/xfs_ag.h                   |    3 +
 fs/xfs/xfs_alloc.c                |   35 ++-
 fs/xfs/xfs_alloc.h                |    5 +-
 fs/xfs/xfs_alloc_btree.c          |    3 +-
 fs/xfs/xfs_bmap.c                 |  549 +++++++++++++++++--------------------
 fs/xfs/xfs_bmap.h                 |    2 -
 fs/xfs/xfs_inode.c                |   15 +-
 fs/xfs/xfs_inode.h                |    1 -
 fs/xfs/xfs_log_cil.c              |   13 +-
 fs/xfs/xfs_mount.h                |    1 +
 fs/xfs/xfs_trans.c                |    2 +-
 15 files changed, 366 insertions(+), 318 deletions(-)
