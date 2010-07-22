Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab0GVS2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:28:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38195 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0GVS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:28:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
Date: Thu, 22 Jul 2010 11:21:01 -0700
Message-Id: <1279822864-17154-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C488C51.00ED,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will used by x86 memblock_x86_find_in_range_node and nobootmem replacement

-v2: use 0 instead -1ULL, Suggested by Linus, so we don't need cast them later to unsigned long

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 70bc467..89749c4 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -19,6 +19,7 @@
 #include <asm/memblock.h>
 
 #define INIT_MEMBLOCK_REGIONS 128
+#define MEMBLOCK_ERROR		0
 
 struct memblock_region {
 	phys_addr_t base;
diff --git a/mm/memblock.c b/mm/memblock.c
index 796ef8c..3d0a754 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -27,8 +27,6 @@ int memblock_can_resize;
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
 
-#define MEMBLOCK_ERROR	(~(phys_addr_t)0)
-
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
 {
-- 
1.6.4.2

