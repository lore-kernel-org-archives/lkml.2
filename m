Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2GXBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:09:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45806 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab2GXBJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:09:54 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Vitaly Andrianov <vitalya@ti.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [RFC 05/23] ARM: LPAE: use phys_addr_t in free_memmap()
Date: Mon, 23 Jul 2012 21:09:07 -0400
Message-ID: <1343092165-9470-6-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
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
---
 arch/arm/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f54d592..8252c31 100644
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

