Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0G2MXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:23:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:4143 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab0G2MX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,280,1278313200"; 
   d="scan'208";a="305844426"
Message-Id: <20100729115142.102255590@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 29 Jul 2010 19:51:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
cc: Dave Chinner <david@fromorbit.com>
cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
cc: Rik van Riel <riel@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
cc: Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 0/5]  [RFC] transfer ASYNC vmscan writeback IO to the flusher threads
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

It's possible to transfer ASYNC vmscan writeback IOs to the flusher threads.
This simple patchset shows the basic idea. Since it's a big behavior change,
there are inevitably lots of details to sort out. I don't know where it will
go after tests and discussions, so the patches are intentionally kept simple.

sync livelock avoidance (need more to be complete, but this is minimal required for the last two patches)
	[PATCH 1/5] writeback: introduce wbc.for_sync to cover the two sync stages
	[PATCH 2/5] writeback: stop periodic/background work on seeing sync works
	[PATCH 3/5] writeback: prevent sync livelock with the sync_after timestamp

let the flusher threads do ASYNC writeback for pageout()
	[PATCH 4/5] writeback: introduce bdi_start_inode_writeback()
	[PATCH 5/5] vmscan: transfer async file writeback to the flusher

The last two patches are the meats, they depend on the first three patches to
kick the background writeback work, so that the for_reclaim writeback can be
serviced timely.

Comments are welcome!

Thanks,
Fengguang

