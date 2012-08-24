Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab2HXOgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:36:01 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52200 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2HXOf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:35:59 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 5/5] mm/memblock: cleanup early_node_map[] related comments  
Date: Fri, 24 Aug 2012 22:33:40 +0800
Message-Id: <1345818820-12102-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082414-2000-0000-0000-000008D5D201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Commit 0ee332c14518699 ("memblock: Kill early_node_map[]") removed
early_node_map[], the patch does cleanup on comments to comply with
that change.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/memblock.h |    3 +--
 mm/nobootmem.c           |    2 --
 mm/page_alloc.c          |    2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d3d53aa..ab7b887 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -70,8 +70,7 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
  * @p_end: ptr to ulong for end pfn of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  *
- * Walks over configured memory ranges.  Available after early_node_map is
- * populated.
+ * Walks over configured memory ranges.
  */
 #define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
 	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 8ec48484..7e95953 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -162,8 +162,6 @@ unsigned long __init free_all_bootmem(void)
 	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
-	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
-	 *  will be used instead of only Node0 related
 	 */
 	return free_low_memory_core_early(MAX_NUMNODES);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 009ac28..c1e2949 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4873,7 +4873,7 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/* Print out the early_node_map[] */
+	/* Print out the early node map */
 	printk("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
-- 
1.7.7.6

