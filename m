Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2DYTVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:21:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2DYTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:21:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="184910317"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: mm: Fix section mismatches
Date: Wed, 25 Apr 2012 12:21:45 -0700
Message-Id: <1335381705-24608-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.227.gd1ca7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x111b8): Section mismatch in reference
from the function arm_memory_present() to the function
.init.text:memory_present()
The function arm_memory_present() references
the function __init memory_present().
This is often because arm_memory_present lacks a __init
annotation or the annotation of memory_present is wrong.

WARNING: arch/arm/mm/built-in.o(.text+0x1edc): Section mismatch
in reference from the function alloc_init_pud() to the function
.init.text:alloc_init_section()
The function alloc_init_pud() references
the function __init alloc_init_section().
This is often because alloc_init_pud lacks a __init
annotation or the annotation of alloc_init_section is wrong.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mm/init.c |    4 ++--
 arch/arm/mm/mmu.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 6e9fde6..c21d06c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -302,11 +302,11 @@ EXPORT_SYMBOL(pfn_valid);
 #endif
 
 #ifndef CONFIG_SPARSEMEM
-static void arm_memory_present(void)
+static void __init arm_memory_present(void)
 {
 }
 #else
-static void arm_memory_present(void)
+static void __init arm_memory_present(void)
 {
 	struct memblock_region *reg;
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 4c1c6f2..81af404 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -626,8 +626,8 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
 	}
 }
 
-static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
-	unsigned long phys, const struct mem_type *type)
+static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
+	unsigned long end, unsigned long phys, const struct mem_type *type)
 {
 	pud_t *pud = pud_offset(pgd, addr);
 	unsigned long next;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

