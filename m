Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440Ab0HEQ3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:11532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304Ab0HEQ3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="825048607"
Message-Id: <20100805161051.501816677@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:10:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 00/13] writeback patches for 2.6.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

These are writeback patches intended for 2.6.36.

It's combined from 2 previous patchsets:

	writeback cleanups and trivial fixes <http://lkml.org/lkml/2010/7/10/153>
	writeback: try to write older pages first <http://lkml.org/lkml/2010/7/22/47>

changelog:
- removed patch "writeback: take account of NR_WRITEBACK_TEMP in balance_dirty_pages()"
- added patch "writeback: explicit low bound for vm.dirty_ratio"
- use "if (list_empty(&wb->b_io))" directly in "writeback: sync expired inodes first in background writeback"
- fix misplaced chunk for removing more_io in include/trace/events/ext4.h
- update comments in "writeback: fix queue_io() ordering"
- update comments in "writeback: add comment to the dirty limits functions"
- patch "writeback: try more writeback as long as something was written" will
  no longer livelock sync() with Jan's sync() livelock avoidance patches

	[PATCH 01/13] writeback: reduce calls to global_page_state in balance_dirty_pages()
	[PATCH 02/13] writeback: avoid unnecessary calculation of bdi dirty thresholds
	[PATCH 03/13] writeback: add comment to the dirty limits functions
	[PATCH 04/13] writeback: dont redirty tail an inode with dirty pages
	[PATCH 05/13] writeback: fix queue_io() ordering
	[PATCH 06/13] writeback: merge for_kupdate and !for_kupdate cases
	[PATCH 07/13] writeback: explicit low bound for vm.dirty_ratio
	[PATCH 08/13] writeback: pass writeback_control down to move_expired_inodes()
	[PATCH 09/13] writeback: the kupdate expire timestamp should be a moving target
	[PATCH 10/13] writeback: kill writeback_control.more_io
	[PATCH 11/13] writeback: sync expired inodes first in background writeback
	[PATCH 12/13] writeback: try more writeback as long as something was written
	[PATCH 13/13] writeback: introduce writeback_control.inodes_written

Thanks,
Fengguang

