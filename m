Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab2HKB3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:29:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60274 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549Ab2HKBZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:25:48 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v2 08/22] ARM: LPAE: use phys_addr_t in free_memmap()
Date: Fri, 10 Aug 2012 21:24:51 -0400
Message-ID: <1344648306-15619-9-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Andrianov <vitalya@ti.com>

The free_memmap() was mistakenly using unsigned long type to represent
physical addresses.  This breaks on PAE systems where memory could be placed
above the 32-bit addressible limit.

This patch fixes this function to properly use phys_addr_t instead.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9aec41f..19ba70b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -457,7 +457,7 @@ static inline void
 free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct page *start_pg, *end_pg;
-	unsigned long pg, pgend;
+	phys_addr_t pg, pgend;
 
 	/*
 	 * Convert start_pfn/end_pfn to a struct page pointer.
@@ -469,8 +469,8 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 	 * Convert to physical addresses, and
 	 * round start upwards and end downwards.
 	 */
-	pg = (unsigned long)PAGE_ALIGN(__pa(start_pg));
-	pgend = (unsigned long)__pa(end_pg) & PAGE_MASK;
+	pg = PAGE_ALIGN(__pa(start_pg));
+	pgend = __pa(end_pg) & PAGE_MASK;
 
 	/*
 	 * If there are free pages between these,
-- 
1.7.9.5

