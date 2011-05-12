Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab1ELOHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:07:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:65228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab1ELOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,358,1301900400"; 
   d="scan'208";a="434940471"
Message-Id: <20110512135706.937596128@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 May 2011 21:57:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/17] writeback fixes and cleanups for 2.6.40 (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is the combination of all the recent writeback patches that get
reasonably reviewed and tested.

The first 10 patches are already in -mm tree, with updates:

- remove "writeback: pass writeback_control down to move_expired_inodes()", and
  resolve the resulting merge conflicts in other patches.
- move ahead the sync livelock prevention patches (01, 02) so that (04) won't livelock sync
- merge the three -mm fixes to (08)
- fixed changelog of (01)

	[PATCH 01/17] writeback: introduce .tagged_sync for the WB_SYNC_NONE sync stage
	[PATCH 02/17] writeback: update dirtied_when for synced inode to prevent livelock
	[PATCH 03/17] writeback: introduce writeback_control.inodes_cleaned
	[PATCH 04/17] writeback: try more writeback as long as something was written
	[PATCH 05/17] writeback: the kupdate expire timestamp should be a moving target
	[PATCH 06/17] writeback: sync expired inodes first in background writeback
	[PATCH 07/17] writeback: refill b_io iff empty
	[PATCH 08/17] writeback: split inode_wb_list_lock into bdi_writeback.list_lock
	[PATCH 09/17] writeback: elevate queue_io() into wb_writeback()
	[PATCH 10/17] writeback: avoid extra sync work at enqueue time

The following 7 patches were posted and reviewed these days:

	[PATCH 11/17] writeback: add bdi_dirty_limit() kernel-doc
	[PATCH 12/17] writeback: skip balance_dirty_pages() for in-memory fs
	[PATCH 13/17] writeback: remove writeback_control.more_io
	[PATCH 14/17] writeback: make writeback_control.nr_to_write straight
	[PATCH 15/17] writeback: remove .nonblocking and .encountered_congestion
	[PATCH 16/17] writeback: trace event writeback_single_inode
	[PATCH 17/17] writeback: trace event writeback_queue_io

Thanks to Jan and Dave for the careful reviews!

The patches are git pullable from

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback

Thanks,
Fengguang

