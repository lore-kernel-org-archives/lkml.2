Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0JYI74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:59:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46321 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab0JYI7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:59:55 -0400
Subject: [RFC PATCH 03/18] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 09:59:50 +0100
Message-ID: <20101025085950.25275.77229.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 08:59:50.0989 (UTC) FILETIME=[FBA66FD0:01CB7422]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

When using 2-level paging, pte_t and pmd_t are typedefs for
unsigned long but phys_addr_t is a typedef for u32.

This patch uses u32 for the page table entry types when
phys_addr_t is not 64-bit, allowing the same conversion
specifier to be used for physical addresses and page table
entries regardless of LPAE.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/page-nommu.h           |    8 ++++----
 arch/arm/include/asm/pgtable-2level-types.h |   18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index d1b162a..a20641a 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -29,10 +29,10 @@
 /*
  * These are used to make use of C type-checking..
  */
-typedef unsigned long pte_t;
-typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
-typedef unsigned long pgprot_t;
+typedef u32 pte_t;
+typedef u32 pmd_t;
+typedef u32 pgd_t[2];
+typedef u32 pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 30f6741..adc4928 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -21,16 +21,16 @@
 
 #undef STRICT_MM_TYPECHECKS
 
-typedef unsigned long pteval_t;
+typedef u32 pteval_t;
 
 #ifdef STRICT_MM_TYPECHECKS
 /*
  * These are used to make use of C type-checking..
  */
-typedef struct { unsigned long pte; } pte_t;
-typedef struct { unsigned long pmd; } pmd_t;
-typedef struct { unsigned long pgd[2]; } pgd_t;
-typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct { u32 pte; } pte_t;
+typedef struct { u32 pmd; } pmd_t;
+typedef struct { u32 pgd[2]; } pgd_t;
+typedef struct { u32 pgprot; } pgprot_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)
@@ -45,10 +45,10 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 /*
  * .. while these make it easier on the compiler
  */
-typedef unsigned long pte_t;
-typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
-typedef unsigned long pgprot_t;
+typedef u32 pte_t;
+typedef u32 pmd_t;
+typedef u32 pgd_t[2];
+typedef u32 pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)

