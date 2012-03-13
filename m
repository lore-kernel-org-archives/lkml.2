Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2CMPc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:32:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38182 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2CMPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:32:26 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/2] page_alloc.c: kill add_from_early_node_map
Date: Tue, 13 Mar 2012 11:32:00 -0400
Message-Id: <1331652720-3054-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one seems to be calling add_from_early_node_map anywhere from the
kernel.

Also, deleting this function decreases page_alloc.o file size.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 include/linux/mm.h |    2 --
 mm/page_alloc.c    |   12 ------------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..d8c4339 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1291,8 +1291,6 @@ extern void get_pfn_range_for_nid(unsigned int nid,
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
-int add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid);
 extern void sparse_memory_present_with_active_regions(int nid);
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a13ded1..3171f4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3925,18 +3925,6 @@ void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 	}
 }
 
-int __init add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid)
-{
-	unsigned long start_pfn, end_pfn;
-	int i;
-
-	/* need to go over early_node_map to find out good range for node */
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL)
-		nr_range = add_range(range, az, nr_range, start_pfn, end_pfn);
-	return nr_range;
-}
-
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
-- 
1.7.5.4

