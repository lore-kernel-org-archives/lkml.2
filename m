Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901Ab0HFFY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:24:57 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49946 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733Ab0HFFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:34 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 13/43] memblock: Remove obsolete accessors
Date: Fri,  6 Aug 2010 15:14:54 +1000
Message-Id: <1281071724-28740-14-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index c914112..7d70fdd 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -64,29 +64,6 @@ extern int memblock_find(struct memblock_region *res);
 
 extern void memblock_dump_all(void);
 
-/* Obsolete accessors */
-static inline u64
-memblock_size_bytes(struct memblock_type *type, unsigned long region_nr)
-{
-	return type->regions[region_nr].size;
-}
-static inline u64
-memblock_size_pages(struct memblock_type *type, unsigned long region_nr)
-{
-	return memblock_size_bytes(type, region_nr) >> PAGE_SHIFT;
-}
-static inline u64
-memblock_start_pfn(struct memblock_type *type, unsigned long region_nr)
-{
-	return type->regions[region_nr].base >> PAGE_SHIFT;
-}
-static inline u64
-memblock_end_pfn(struct memblock_type *type, unsigned long region_nr)
-{
-	return memblock_start_pfn(type, region_nr) +
-	       memblock_size_pages(type, region_nr);
-}
-
 /*
  * pfn conversion functions
  *
-- 
1.7.0.4

