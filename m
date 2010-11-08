Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0KHLB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:01:58 -0500
Received: from smtp.nokia.com ([147.243.128.24]:52291 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754326Ab0KHLB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:01:57 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: benh@kernel.crashing.org, yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH] memblock: fix memblock_is_region_memory()
Date: Mon,  8 Nov 2010 13:00:13 +0200
Message-Id: <1289214013-13449-1-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.7.1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_is_region_memory() uses reserved memblocks to search for the
given region, while it should use the memory memblocks.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
---
 mm/memblock.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 400dc62..bdba245 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -683,13 +683,13 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
-	int idx = memblock_search(&memblock.reserved, base);
+	int idx = memblock_search(&memblock.memory, base);
 
 	if (idx == -1)
 		return 0;
-	return memblock.reserved.regions[idx].base <= base &&
-		(memblock.reserved.regions[idx].base +
-		 memblock.reserved.regions[idx].size) >= (base + size);
+	return memblock.memory.regions[idx].base <= base &&
+		(memblock.memory.regions[idx].base +
+		 memblock.memory.regions[idx].size) >= (base + size);
 }
 
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
-- 
1.7.1

