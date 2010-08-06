Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab0HFFQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:16:00 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49969 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab0HFFPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:38 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 27/43] memblock: Move memblock_init() to the bottom of the file
Date: Fri,  6 Aug 2010 15:15:08 +1000
Message-Id: <1281071724-28740-28-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a real PITA to have to search for it in the middle

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   54 +++++++++++++++++++++++++++---------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index fc7f97b..ae856d4 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -107,33 +107,6 @@ static void memblock_coalesce_regions(struct memblock_type *type,
 	memblock_remove_region(type, r2);
 }
 
-void __init memblock_init(void)
-{
-	/* Hookup the initial arrays */
-	memblock.memory.regions	= memblock_memory_init_regions;
-	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
-	memblock.reserved.regions	= memblock_reserved_init_regions;
-	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
-
-	/* Write a marker in the unused last array entry */
-	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
-	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
-
-	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
-	 * This simplifies the memblock_add() code below...
-	 */
-	memblock.memory.regions[0].base = 0;
-	memblock.memory.regions[0].size = 0;
-	memblock.memory.cnt = 1;
-
-	/* Ditto. */
-	memblock.reserved.regions[0].base = 0;
-	memblock.reserved.regions[0].size = 0;
-	memblock.reserved.cnt = 1;
-
-	memblock.current_limit = MEMBLOCK_ALLOC_ANYWHERE;
-}
-
 void __init memblock_analyze(void)
 {
 	int i;
@@ -543,3 +516,30 @@ void __init memblock_set_current_limit(phys_addr_t limit)
 	memblock.current_limit = limit;
 }
 
+void __init memblock_init(void)
+{
+	/* Hookup the initial arrays */
+	memblock.memory.regions	= memblock_memory_init_regions;
+	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
+	memblock.reserved.regions	= memblock_reserved_init_regions;
+	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
+
+	/* Write a marker in the unused last array entry */
+	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
+	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = (phys_addr_t)RED_INACTIVE;
+
+	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
+	 * This simplifies the memblock_add() code below...
+	 */
+	memblock.memory.regions[0].base = 0;
+	memblock.memory.regions[0].size = 0;
+	memblock.memory.cnt = 1;
+
+	/* Ditto. */
+	memblock.reserved.regions[0].base = 0;
+	memblock.reserved.regions[0].size = 0;
+	memblock.reserved.cnt = 1;
+
+	memblock.current_limit = MEMBLOCK_ALLOC_ANYWHERE;
+}
+
-- 
1.7.0.4

