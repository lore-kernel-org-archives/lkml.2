Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab0HEGOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:14:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37405 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:14:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 5/7] vmscan: kill dead code in shrink_inactive_list()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
Message-Id: <20100805151415.31C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:14:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When synchrounous lumy reclaim occur, page_list have gurantee to
don't have active page because now page activation in shrink_page_list()
always disable lumpy reclaim.

Then, This patch remove virtual dead code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f7aabd2..f21dbeb 100644
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
1.6.5.2



