Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0HKPLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:11:16 -0400
Received: from king.tilera.com ([72.1.168.226]:50770 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0HKPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:11:15 -0400
Message-Id: <201008111511.o7BFBA9k005534@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 11 Aug 2010 10:54:13 -0400
Subject: [PATCH] arch/tile: support new kunmap_atomic() naming convention.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 11 Aug 2010 15:11:10.0829 (UTC) FILETIME=[6E7CF9D0:01CB3967]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit 597781f3e51f48ef8e67be772196d9e9673752c4.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/highmem.h |    2 +-
 arch/tile/mm/highmem.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/asm/highmem.h b/arch/tile/include/asm/highmem.h
index efdd12e..d155db6 100644
--- a/arch/tile/include/asm/highmem.h
+++ b/arch/tile/include/asm/highmem.h
@@ -60,7 +60,7 @@ void *kmap_fix_kpte(struct page *page, int finished);
 /* This macro is used only in map_new_virtual() to map "page". */
 #define kmap_prot page_to_kpgprot(page)
 
-void kunmap_atomic(void *kvaddr, enum km_type type);
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index ff1cdff..12ab137 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -276,7 +276,7 @@ void *kmap_atomic(struct page *page, enum km_type type)
 }
 EXPORT_SYMBOL(kmap_atomic);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
@@ -300,7 +300,7 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_notypecheck);
 
 /*
  * This API is supposed to allow us to map memory without a "struct page".
-- 
1.6.5.2

