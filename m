Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1A3Jrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1A3Jrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:47:42 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: [PATCH 4/4] kmap_atomic: remove KM_* types except KM_TYPE_NR
Date: Sun, 30 Jan 2011 17:47:00 +0800
Message-Id: <1296380820-8801-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1296380820-8801-1-git-send-email-amwang@redhat.com>
References: <1296380820-8801-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, it is the right time to remove all KM_* types,
except KM_TYPE_NR, it is still used, convert it to a macro.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 arch/arm/include/asm/kmap_types.h     |   20 +------------------
 arch/avr32/include/asm/kmap_types.h   |   24 +---------------------
 arch/frv/include/asm/kmap_types.h     |   24 +----------------------
 arch/powerpc/include/asm/kmap_types.h |   20 +------------------
 arch/tile/include/asm/kmap_types.h    |   26 -------------------------
 arch/um/include/asm/kmap_types.h      |   18 +----------------
 include/asm-generic/kmap_types.h      |   34 +-------------------------------
 7 files changed, 8 insertions(+), 158 deletions(-)

diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
index e51b1e8..0069242 100644
--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -4,25 +4,7 @@
 /*
  * This is the "bare minimum".  AIO seems to require this.
  */
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_L1_CACHE,
-	KM_L2_CACHE,
-	KM_KDB,
-	KM_TYPE_NR
-};
+#define KM_TYPE_NR 16
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 #define KM_NMI		(-1)
diff --git a/arch/avr32/include/asm/kmap_types.h b/arch/avr32/include/asm/kmap_types.h
index b7f5c68..479330b 100644
--- a/arch/avr32/include/asm/kmap_types.h
+++ b/arch/avr32/include/asm/kmap_types.h
@@ -2,29 +2,9 @@
 #define __ASM_AVR32_KMAP_TYPES_H
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
+# define KM_TYPE_NR 29
 #else
-# define D(n)
+# define KM_TYPE_NR 14
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_PTE2,
-D(10)	KM_IRQ0,
-D(11)	KM_IRQ1,
-D(12)	KM_SOFTIRQ0,
-D(13)	KM_SOFTIRQ1,
-D(14)	KM_TYPE_NR
-};
-
-#undef D
-
 #endif /* __ASM_AVR32_KMAP_TYPES_H */
diff --git a/arch/frv/include/asm/kmap_types.h b/arch/frv/include/asm/kmap_types.h
index f8e16b2..43901f2 100644
--- a/arch/frv/include/asm/kmap_types.h
+++ b/arch/frv/include/asm/kmap_types.h
@@ -2,28 +2,6 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	/* arch specific kmaps - change the numbers attached to these at your peril */
-	__KM_CACHE,		/* cache flush page attachment point */
-	__KM_PGD,		/* current page directory */
-	__KM_ITLB_PTD,		/* current instruction TLB miss page table lookup */
-	__KM_DTLB_PTD,		/* current data TLB miss page table lookup */
-
-	/* general kmaps */
-        KM_BOUNCE_READ,
-        KM_SKB_SUNRPC_DATA,
-        KM_SKB_DATA_SOFTIRQ,
-        KM_USER0,
-        KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#define KM_TYPE_NR 17
 
 #endif
diff --git a/arch/powerpc/include/asm/kmap_types.h b/arch/powerpc/include/asm/kmap_types.h
index bca8fdc..751fd53 100644
--- a/arch/powerpc/include/asm/kmap_types.h
+++ b/arch/powerpc/include/asm/kmap_types.h
@@ -10,25 +10,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_PPC_SYNC_PAGE,
-	KM_PPC_SYNC_ICACHE,
-	KM_KDB,
-	KM_TYPE_NR
-};
+#define KM_TYPE_NR 16
 
 /*
  * This is a temporary build fix that (so they say on lkml....) should no longer
diff --git a/arch/tile/include/asm/kmap_types.h b/arch/tile/include/asm/kmap_types.h
index 3d0f202..054374c 100644
--- a/arch/tile/include/asm/kmap_types.h
+++ b/arch/tile/include/asm/kmap_types.h
@@ -27,31 +27,5 @@ enum km_type {
 	KM_TYPE_NR = 8
 };
 
-/*
- * We provide dummy definitions of all the stray values that used to be
- * required for kmap_atomic() and no longer are.
- */
-enum {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_SYNC_ICACHE,
-	KM_SYNC_DCACHE,
-	KM_UML_USERCOPY,
-	KM_IRQ_PTE,
-	KM_NMI,
-	KM_NMI_PTE,
-	KM_KDB
-};
 
 #endif /* _ASM_TILE_KMAP_TYPES_H */
diff --git a/arch/um/include/asm/kmap_types.h b/arch/um/include/asm/kmap_types.h
index 6c03acd..2e0a6b1 100644
--- a/arch/um/include/asm/kmap_types.h
+++ b/arch/um/include/asm/kmap_types.h
@@ -8,22 +8,6 @@
 
 /* No more #include "asm/arch/kmap_types.h" ! */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_UML_USERCOPY,	/* UML specific, for copy_*_user - used in do_op_one_page */
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#define KM_TYPE_NR 14
 
 #endif
diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
index 0232ccb..90f99c7 100644
--- a/include/asm-generic/kmap_types.h
+++ b/include/asm-generic/kmap_types.h
@@ -2,39 +2,9 @@
 #define _ASM_GENERIC_KMAP_TYPES_H
 
 #ifdef __WITH_KM_FENCE
-# define KMAP_D(n) __KM_FENCE_##n ,
+# define KM_TYPE_NR 41
 #else
-# define KMAP_D(n)
+# define KM_TYPE_NR 20
 #endif
 
-enum km_type {
-KMAP_D(0)	KM_BOUNCE_READ,
-KMAP_D(1)	KM_SKB_SUNRPC_DATA,
-KMAP_D(2)	KM_SKB_DATA_SOFTIRQ,
-KMAP_D(3)	KM_USER0,
-KMAP_D(4)	KM_USER1,
-KMAP_D(5)	KM_BIO_SRC_IRQ,
-KMAP_D(6)	KM_BIO_DST_IRQ,
-KMAP_D(7)	KM_PTE0,
-KMAP_D(8)	KM_PTE1,
-KMAP_D(9)	KM_IRQ0,
-KMAP_D(10)	KM_IRQ1,
-KMAP_D(11)	KM_SOFTIRQ0,
-KMAP_D(12)	KM_SOFTIRQ1,
-KMAP_D(13)	KM_SYNC_ICACHE,
-KMAP_D(14)	KM_SYNC_DCACHE,
-/* UML specific, for copy_*_user - used in do_op_one_page */
-KMAP_D(15)	KM_UML_USERCOPY,
-KMAP_D(16)	KM_IRQ_PTE,
-KMAP_D(17)	KM_NMI,
-KMAP_D(18)	KM_NMI_PTE,
-KMAP_D(19)	KM_KDB,
-/*
- * Remember to update debug_kmap_atomic() when adding new kmap types!
- */
-KMAP_D(20)	KM_TYPE_NR
-};
-
-#undef KMAP_D
-
 #endif
-- 
1.7.3.5

