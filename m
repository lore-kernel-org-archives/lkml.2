Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329Ab0HFFU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:20:56 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33772 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab0HFFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:36 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 26/43] memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
Date: Fri,  6 Aug 2010 15:15:07 +1000
Message-Id: <1281071724-28740-27-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c1d2060..fc7f97b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -22,6 +22,8 @@ static int memblock_debug;
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 
+#define MEMBLOCK_ERROR	(~(phys_addr_t)0)
+
 static int __init early_memblock(char *p)
 {
 	if (p && strstr(p, "debug"))
@@ -326,7 +328,7 @@ static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t en
 		base = memblock_align_down(res_base - size, align);
 	}
 
-	return ~(phys_addr_t)0;
+	return MEMBLOCK_ERROR;
 }
 
 phys_addr_t __weak __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
@@ -353,14 +355,14 @@ static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
 		this_end = memblock_nid_range(start, end, &this_nid);
 		if (this_nid == nid) {
 			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
-			if (ret != ~(phys_addr_t)0 &&
+			if (ret != MEMBLOCK_ERROR &&
 			    memblock_add_region(&memblock.reserved, ret, size) >= 0)
 				return ret;
 		}
 		start = this_end;
 	}
 
-	return ~(phys_addr_t)0;
+	return MEMBLOCK_ERROR;
 }
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
@@ -379,7 +381,7 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 	for (i = 0; i < mem->cnt; i++) {
 		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
 					       size, align, nid);
-		if (ret != ~(phys_addr_t)0)
+		if (ret != MEMBLOCK_ERROR)
 			return ret;
 	}
 
@@ -430,7 +432,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 			continue;
 		base = min(memblockbase + memblocksize, max_addr);
 		res_base = memblock_find_region(memblockbase, base, size, align);
-		if (res_base != ~(phys_addr_t)0 &&
+		if (res_base != MEMBLOCK_ERROR &&
 		    memblock_add_region(&memblock.reserved, res_base, size) >= 0)
 			return res_base;
 	}
-- 
1.7.0.4

