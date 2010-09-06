Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0IFKrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:47:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60495 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab0IFKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:47:39 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 07/10] vmscan: Remove dead code in shrink_inactive_list()
Date: Mon,  6 Sep 2010 11:47:30 +0100
Message-Id: <1283770053-18833-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

After synchrounous lumpy reclaim, the page_list is guaranteed to not
have active pages as page activation in shrink_page_list() disables lumpy
reclaim. Remove the dead code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 21d1153..64f9ca5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1334,7 +1334,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
-	unsigned long nr_active;
 	unsigned long nr_anon;
 	unsigned long nr_file;
 
@@ -1389,13 +1388,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
-		/*
-		 * The attempt at page out may have made some
-		 * of the pages active, mark them inactive again.
-		 */
-		nr_active = clear_active_flags(&page_list, NULL);
-		count_vm_events(PGDEACTIVATE, nr_active);
-
 		set_lumpy_reclaim_mode(priority, sc, true);
 		nr_reclaimed += shrink_page_list(&page_list, sc);
 	}
-- 
1.7.1

