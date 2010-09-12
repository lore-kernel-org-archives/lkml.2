Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0ILPzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:35314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0ILPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="656512021"
Message-Id: <20100912155204.774257544@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:59 +0800
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
Subject: [PATCH 14/17] vmscan: add scan_control.priority
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=mm-sc-priority.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems most vmscan functions need the priority parameter.
It will simplify code to put it into scan_control.

It will be referenced in the next patch. This patch could convert
the many exising functnions, but let's keep it simple at first.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next.orig/mm/vmscan.c	2010-09-10 13:13:41.000000000 +0800
+++ linux-next/mm/vmscan.c	2010-09-10 13:17:01.000000000 +0800
@@ -78,6 +78,8 @@ struct scan_control {
 
 	int order;
 
+	int priority;
+
 	/*
 	 * Intend to reclaim enough continuous memory rather than reclaim
 	 * enough amount of memory. i.e, mode for high order allocation.
@@ -1875,6 +1877,7 @@ static unsigned long do_try_to_free_page
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
+		sc->priority = priority;
 		if (!priority)
 			disable_swap_token();
 		all_unreclaimable = shrink_zones(priority, zonelist, sc);
@@ -2127,6 +2130,7 @@ loop_again:
 			disable_swap_token();
 
 		all_zones_ok = 1;
+		sc.priority = priority;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest


