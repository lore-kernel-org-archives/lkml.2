Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1IUI64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:58:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44295 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1IUI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:58:54 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-54-4e79a74c1ea9
Date: Wed, 21 Sep 2011 17:58:43 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] mm: compaction: staticize compact_zone_order
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-id: <20110921085843.GA16233@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 21 Sep 2011 08:59:46.0936 (UTC)
 FILETIME=[CFF73F80:01CC783C]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

There's no user to use compact_zone_order. So staticize this function.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index cc9f7a4..bb2bbdb 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -24,8 +24,6 @@ extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
-extern unsigned long compact_zone_order(struct zone *zone, int order,
-					gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -69,12 +67,6 @@ static inline unsigned long compaction_suitable(struct zone *zone, int order)
 	return COMPACT_SKIPPED;
 }
 
-static inline unsigned long compact_zone_order(struct zone *zone, int order,
-					       gfp_t gfp_mask, bool sync)
-{
-	return COMPACT_CONTINUE;
-}
-
 static inline void defer_compaction(struct zone *zone)
 {
 }
diff --git a/mm/compaction.c b/mm/compaction.c
index 6cc604b..c17079e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -586,7 +586,7 @@ out:
 	return ret;
 }
 
-unsigned long compact_zone_order(struct zone *zone,
+static unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
 				 bool sync)
 {
