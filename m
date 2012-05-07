Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2EGLiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:38:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50894 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab2EGLiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 03/10] mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata
Date: Mon,  7 May 2012 13:37:45 +0200
Message-Id: <1336390672-14421-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callsites need to provide a bootmem_data_t *, make the naming more
descriptive.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 053ac3f..ceed0df 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -468,7 +468,7 @@ static unsigned long __init align_off(struct bootmem_data *bdata,
 	return ALIGN(base + off, align) - base;
 }
 
-static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
+static void * __init alloc_bootmem_bdata(struct bootmem_data *bdata,
 					unsigned long size, unsigned long align,
 					unsigned long goal, unsigned long limit)
 {
@@ -589,7 +589,7 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
 							goal, limit);
 		if (p_bdata)
-			return alloc_bootmem_core(p_bdata, size, align,
+			return alloc_bootmem_bdata(p_bdata, size, align,
 							goal, limit);
 	}
 #endif
@@ -615,7 +615,7 @@ restart:
 		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
 			break;
 
-		region = alloc_bootmem_core(bdata, size, align, goal, limit);
+		region = alloc_bootmem_bdata(bdata, size, align, goal, limit);
 		if (region)
 			return region;
 	}
@@ -695,7 +695,7 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
+	ptr = alloc_bootmem_bdata(bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
 
@@ -744,7 +744,7 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 		unsigned long new_goal;
 
 		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-		ptr = alloc_bootmem_core(pgdat->bdata, size, align,
+		ptr = alloc_bootmem_bdata(pgdat->bdata, size, align,
 						 new_goal, 0);
 		if (ptr)
 			return ptr;
@@ -773,7 +773,7 @@ void * __init alloc_bootmem_section(unsigned long size,
 	goal = pfn << PAGE_SHIFT;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, 0);
+	return alloc_bootmem_bdata(bdata, size, SMP_CACHE_BYTES, goal, 0);
 }
 #endif
 
@@ -789,7 +789,7 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
-- 
1.7.10

