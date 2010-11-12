Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0KLSD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:03:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50896 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456Ab0KLSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:02 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/20] ARM: LPAE: Remove the FIRST_USER_PGD_NR and USER_PTRS_PER_PGD definitions
Date: Fri, 12 Nov 2010 18:00:30 +0000
Message-Id: <1289584840-18097-11-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:51.0500 (UTC) FILETIME=[8B0ED6C0:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were only used in setup_mm_for_reboot and get_pgd_slow.
Both have been modified to no longer use these definitions. One of the
reasons is the different meaning that PGD has with the 2-level and
3-level page tables.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/pgtable-2level.h |    3 ---
 arch/arm/include/asm/pgtable-3level.h |    3 ---
 arch/arm/mm/pgd.c                     |    2 +-
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 4e21166..a0548b6 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -92,9 +92,6 @@
  */
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
-#define FIRST_USER_PGD_NR	1
-#define USER_PTRS_PER_PGD	((TASK_SIZE/PGDIR_SIZE) - FIRST_USER_PGD_NR)
-
 /*
  * section address mask and size definitions.
  */
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 5b1482d..381b04b 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -58,9 +58,6 @@
  */
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
-#define FIRST_USER_PGD_NR	1
-#define USER_PTRS_PER_PGD	((TASK_SIZE/PGDIR_SIZE) - FIRST_USER_PGD_NR)
-
 /*
  * section address mask and size definitions.
  */
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index e7c149b..09238fa 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -25,7 +25,7 @@
 #else
 #define alloc_pgd()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
 #define free_pgd(pgd)	free_pages((unsigned long)pgd, 2)
-#define FIRST_KERNEL_PGD_NR	(FIRST_USER_PGD_NR + USER_PTRS_PER_PGD)
+#define FIRST_KERNEL_PGD_NR	(TASK_SIZE >> PGDIR_SHIFT)
 #endif
 
 /*
