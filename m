Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0DORXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:23:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49803 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0DORVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:21:43 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 07/10] vmscan: Remove unnecessary temporary variables in shrink_zone()
Date: Thu, 15 Apr 2010 18:21:40 +0100
Message-Id: <1271352103-2280-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two variables are declared that are unnecessary in shrink_zone() as they
already exist int the scan_control. Remove them

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a374879..a232ad6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1633,8 +1633,6 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
-	unsigned long nr_reclaimed = sc->nr_reclaimed;
-	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	enum lru_list l;
 
 	calc_scan_trybatch(zone, sc, nr);
@@ -1647,7 +1645,7 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 						   nr[l], SWAP_CLUSTER_MAX);
 				nr[l] -= nr_to_scan;
 
-				nr_reclaimed += shrink_list(l, nr_to_scan,
+				sc->nr_reclaimed += shrink_list(l, nr_to_scan,
 							    zone, sc);
 			}
 		}
@@ -1659,13 +1657,11 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim &&
+		if (sc->nr_reclaimed >= sc->nr_to_reclaim &&
 		    sc->priority < DEF_PRIORITY)
 			break;
 	}
 
-	sc->nr_reclaimed = nr_reclaimed;
-
 	/*
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
-- 
1.6.5

