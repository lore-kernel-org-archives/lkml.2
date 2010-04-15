Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0DORVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:21:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49778 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab0DORVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:21:42 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 04/10] vmscan: Remove useless loop at end of do_try_to_free_pages
Date: Thu, 15 Apr 2010 18:21:37 +0100
Message-Id: <1271352103-2280-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the patch "vmscan: kill prev_priority completely", the loop at the
end of do_try_to_free_pages() is now doing nothing. Delete it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 76c2b03..838ac8b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1806,11 +1806,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		ret = sc->nr_reclaimed;
 
 out:
-	if (scanning_global_lru(sc))
-		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-				continue;
-
 	delayacct_freepages_end();
 
 	return ret;
-- 
1.6.5

