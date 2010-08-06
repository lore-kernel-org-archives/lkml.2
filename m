Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab0HFFYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:24:04 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57841 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 14/43] memblock: Remove memblock_find()
Date: Fri,  6 Aug 2010 15:14:55 +1000
Message-Id: <1281071724-28740-15-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody uses it anymore. It's semantics were ... weird

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    1 -
 mm/memblock.c            |   32 --------------------------------
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7d70fdd..776c7d9 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -60,7 +60,6 @@ extern int memblock_is_memory(u64 addr);
 extern int memblock_is_region_memory(u64 base, u64 size);
 extern int __init memblock_is_reserved(u64 addr);
 extern int memblock_is_region_reserved(u64 base, u64 size);
-extern int memblock_find(struct memblock_region *res);
 
 extern void memblock_dump_all(void);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index aa88c62..8a118b7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -531,35 +531,3 @@ int memblock_is_region_reserved(u64 base, u64 size)
 	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
-/*
- * Given a <base, len>, find which memory regions belong to this range.
- * Adjust the request and return a contiguous chunk.
- */
-int memblock_find(struct memblock_region *res)
-{
-	int i;
-	u64 rstart, rend;
-
-	rstart = res->base;
-	rend = rstart + res->size - 1;
-
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		u64 start = memblock.memory.regions[i].base;
-		u64 end = start + memblock.memory.regions[i].size - 1;
-
-		if (start > rend)
-			return -1;
-
-		if ((end >= rstart) && (start < rend)) {
-			/* adjust the request */
-			if (rstart < start)
-				rstart = start;
-			if (rend > end)
-				rend = end;
-			res->base = rstart;
-			res->size = rend - rstart + 1;
-			return 0;
-		}
-	}
-	return -1;
-}
-- 
1.7.0.4

