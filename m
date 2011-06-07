Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab1FGVoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:44:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:11556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab1FGVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="15195922"
Message-Id: <20110607213236.634026193@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Jun 2011 05:32:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/15] writeback fixes and cleanups for 3.0 (v5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

Here are the intented patches for upstream submission, rebased to v3.0-rc2:

	[PATCH 01/15] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
	[PATCH 02/15] writeback: update dirtied_when for synced inode to prevent livelock
	[PATCH 03/15] writeback: introduce writeback_control.inodes_cleaned
	[PATCH 04/15] writeback: try more writeback as long as something was written
	[PATCH 05/15] writeback: the kupdate expire timestamp should be a moving target
	[PATCH 06/15] writeback: refill b_io iff empty
	[PATCH 07/15] writeback: split inode_wb_list_lock into bdi_writeback.list_lock
	[PATCH 08/15] writeback: elevate queue_io() into wb_writeback()
	[PATCH 09/15] writeback: avoid extra sync work at enqueue time
	[PATCH 10/15] writeback: add bdi_dirty_limit() kernel-doc
	[PATCH 11/15] writeback: skip balance_dirty_pages() for in-memory fs
	[PATCH 12/15] writeback: remove writeback_control.more_io
	[PATCH 13/15] writeback: remove .nonblocking and .encountered_congestion
	[PATCH 14/15] writeback: trace event writeback_single_inode
	[PATCH 15/15] writeback: trace event writeback_queue_io

 fs/block_dev.c                   |   16 ++-
 fs/ext4/inode.c                  |    4 +-
 fs/fs-writeback.c                |  219 ++++++++++++++++++++------------------
 fs/inode.c                       |    5 +-
 fs/nfs/write.c                   |    3 +-
 fs/xfs/linux-2.6/xfs_aops.c      |    2 +-
 include/linux/backing-dev.h      |    2 +
 include/linux/writeback.h        |   10 +--
 include/trace/events/btrfs.h     |    6 +-
 include/trace/events/ext4.h      |    6 +-
 include/trace/events/writeback.h |  100 +++++++++++++++++-
 mm/backing-dev.c                 |   21 +++-
 mm/filemap.c                     |    6 +-
 mm/page-writeback.c              |   25 +++--
 mm/rmap.c                        |    4 +-
 15 files changed, 270 insertions(+), 159 deletions(-)

They are git pullable from

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback

Thanks to Jan and Dave for the careful reviews!

Thanks,
Fengguang


