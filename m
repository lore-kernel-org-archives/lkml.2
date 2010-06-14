Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0FNLSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:18:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47668 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0FNLR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:17:59 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 07/12] vmscan: Remove unnecessary temporary vars in do_try_to_free_pages
Date: Mon, 14 Jun 2010 12:17:48 +0100
Message-Id: <1276514273-27693-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove temporary variable that is only used once and does not help
clarify code.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a42ebc..246e084 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1721,13 +1721,12 @@ static void shrink_zone(int priority, struct zone *zone,
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
-	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	struct zoneref *z;
 	struct zone *zone;
 	bool all_unreclaimable = true;
 
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
-					sc->nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
 			continue;
 		/*
@@ -1773,7 +1772,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	unsigned long lru_pages = 0;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	unsigned long writeback_threshold;
 
 	get_mems_allowed();
@@ -1785,7 +1783,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	 * mem_cgroup will not do shrink_slab.
 	 */
 	if (scanning_global_lru(sc)) {
-		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+		for_each_zone_zonelist(zone, z, zonelist, gfp_zone(sc->gfp_mask)) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
-- 
1.7.1

