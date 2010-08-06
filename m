Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab0HFFR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:17:28 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43322 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795Ab0HFFPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:37 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 39/43] memblock: Export MEMBLOCK_ERROR
Date: Fri,  6 Aug 2010 15:15:20 +1000
Message-Id: <1281071724-28740-40-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

will used by x86 memblock_x86_find_in_range_node and nobootmem replacement

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    3 ++-
 mm/memblock.c            |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index eed0f9b..1a9c29c 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -18,7 +18,8 @@
 
 #include <asm/memblock.h>
 
-#define INIT_MEMBLOCK_REGIONS 128
+#define INIT_MEMBLOCK_REGIONS	128
+#define MEMBLOCK_ERROR		(~(phys_addr_t)0)
 
 struct memblock_region {
 	phys_addr_t base;
diff --git a/mm/memblock.c b/mm/memblock.c
index c3703ab..85cfa1d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -27,8 +27,6 @@ int memblock_can_resize;
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 
-#define MEMBLOCK_ERROR	(~(phys_addr_t)0)
-
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
 {
-- 
1.7.0.4

