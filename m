Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2IUP52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:57:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab2IUP5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:09 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 08/17] ARM: LPAE: use phys_addr_t in free_memmap()
Date: Fri, 21 Sep 2012 11:56:06 -0400
Message-ID: <1348242975-19184-9-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
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

