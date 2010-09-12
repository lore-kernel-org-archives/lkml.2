Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0ILPz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:18093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="323693162"
Message-Id: <20100912155203.355459925@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 05/17] writeback: quit throttling when signal pending
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-break-on-signal-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows quick response to Ctrl-C etc. for impatient users.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2010-09-09 16:01:14.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-09-09 16:02:27.000000000 +0800
@@ -553,6 +553,9 @@ static void balance_dirty_pages(struct a
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
+		if (signal_pending(current))
+			break;
+
 check_exceeded:
 		/*
 		 * The bdi thresh is somehow "soft" limit derived from the


