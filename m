Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1EHSjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:39:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38560 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1EHSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:39:20 -0400
Message-ID: <4DC6E342.3030906@kernel.org>
Date: Sun, 08 May 2011 11:38:58 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Olaf Hering <olaf@aepfle.de>, Tejun Heo <tj@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] memblock/nobootmem: remove code for alloc_bootmem_node_high()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DC6E34D.004E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bootmem wrapper with memblock support top-down now, So do not need this trick now.

Signed-off-by: Yinghai LU <yinghai@kernel.org>

---
 mm/nobootmem.c |   23 -----------------------
 1 file changed, 23 deletions(-)

Index: linux-2.6/mm/nobootmem.c
===================================================================
--- linux-2.6.orig/mm/nobootmem.c
+++ linux-2.6/mm/nobootmem.c
@@ -307,30 +307,7 @@ void * __init __alloc_bootmem_node(pg_da
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-#ifdef MAX_DMA32_PFN
-	unsigned long end_pfn;
-
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
-	/* update goal according ...MAX_DMA32_PFN */
-	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
-
-	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
-	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
-		void *ptr;
-		unsigned long new_goal;
-
-		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 new_goal, -1ULL);
-		if (ptr)
-			return ptr;
-	}
-#endif
-
 	return __alloc_bootmem_node(pgdat, size, align, goal);
-
 }
 
 #ifdef CONFIG_SPARSEMEM
