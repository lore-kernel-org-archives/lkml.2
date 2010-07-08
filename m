Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0GHHAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:00:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:43056 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab0GHHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:00:04 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-arch@vger.kernel.org
Subject: [PATCH -mm 1/3] rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN
Date: Thu,  8 Jul 2010 15:57:46 +0900
Message-Id: <1278572268-26146-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Jul 2010 15:59:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_get_cache_alignment() needs to know if an architecture defines
ARCH_KMALLOC_MINALIGN or not (needs to know if architecture has DMA
alignment restriction). However, slab.h define ARCH_KMALLOC_MINALIGN
if architectures doesn't define it.

Let's rename ARCH_KMALLOC_MINALIGN to
ARCH_DMA_MINALIGN. ARCH_KMALLOC_MINALIGN is used only in the internals
of slab/slob/slub (except for crypto).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/arm/include/asm/cache.h                 |    2 +-
 arch/avr32/include/asm/cache.h               |    2 +-
 arch/blackfin/include/asm/cache.h            |    2 +-
 arch/frv/include/asm/mem-layout.h            |    2 +-
 arch/m68k/include/asm/cache.h                |    2 +-
 arch/microblaze/include/asm/page.h           |    2 +-
 arch/mips/include/asm/mach-generic/kmalloc.h |    2 +-
 arch/mips/include/asm/mach-ip27/kmalloc.h    |    2 +-
 arch/mips/include/asm/mach-ip32/kmalloc.h    |    4 ++--
 arch/mips/include/asm/mach-tx49xx/kmalloc.h  |    2 +-
 arch/mn10300/include/asm/cache.h             |    2 +-
 arch/powerpc/include/asm/page_32.h           |    2 +-
 arch/sh/include/asm/page.h                   |    2 +-
 arch/xtensa/include/asm/cache.h              |    2 +-
 include/linux/slab_def.h                     |    4 +++-
 include/linux/slob_def.h                     |    4 +++-
 include/linux/slub_def.h                     |    8 +++++---
 17 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/cache.h b/arch/arm/include/asm/cache.h
index 66c160b..9d61220 100644
--- a/arch/arm/include/asm/cache.h
+++ b/arch/arm/include/asm/cache.h
@@ -14,7 +14,7 @@
  * cache before the transfer is done, causing old data to be seen by
  * the CPU.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 /*
  * With EABI on ARMv5 and above we must have 64-bit aligned slab pointers.
diff --git a/arch/avr32/include/asm/cache.h b/arch/avr32/include/asm/cache.h
index d3cf35a..c3a58a1 100644
--- a/arch/avr32/include/asm/cache.h
+++ b/arch/avr32/include/asm/cache.h
@@ -11,7 +11,7 @@
  * cache before the transfer is done, causing old data to be seen by
  * the CPU.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifndef __ASSEMBLER__
 struct cache_info {
diff --git a/arch/blackfin/include/asm/cache.h b/arch/blackfin/include/asm/cache.h
index 93f6c63..bd0641a 100644
--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -15,7 +15,7 @@
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 #define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifdef CONFIG_SMP
 #define __cacheline_aligned
diff --git a/arch/frv/include/asm/mem-layout.h b/arch/frv/include/asm/mem-layout.h
index ccae981..e9a0ec8 100644
--- a/arch/frv/include/asm/mem-layout.h
+++ b/arch/frv/include/asm/mem-layout.h
@@ -35,7 +35,7 @@
  * the slab must be aligned such that load- and store-double instructions don't
  * fault if used
  */
-#define	ARCH_KMALLOC_MINALIGN		L1_CACHE_BYTES
+#define	ARCH_DMA_MINALIGN		L1_CACHE_BYTES
 #define	ARCH_SLAB_MINALIGN		L1_CACHE_BYTES
 
 /*****************************************************************************/
diff --git a/arch/m68k/include/asm/cache.h b/arch/m68k/include/asm/cache.h
index ecafbe1..0395c51 100644
--- a/arch/m68k/include/asm/cache.h
+++ b/arch/m68k/include/asm/cache.h
@@ -8,6 +8,6 @@
 #define        L1_CACHE_SHIFT  4
 #define        L1_CACHE_BYTES  (1<< L1_CACHE_SHIFT)
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #endif
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index c12c6df..2b108db 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -40,7 +40,7 @@
 #ifndef __ASSEMBLY__
 
 /* MS be sure that SLAB allocates aligned objects */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #define ARCH_SLAB_MINALIGN	L1_CACHE_BYTES
 
diff --git a/arch/mips/include/asm/mach-generic/kmalloc.h b/arch/mips/include/asm/mach-generic/kmalloc.h
index b8e6deb..a5d6690 100644
--- a/arch/mips/include/asm/mach-generic/kmalloc.h
+++ b/arch/mips/include/asm/mach-generic/kmalloc.h
@@ -7,7 +7,7 @@
  * Total overkill for most systems but need as a safe default.
  * Set this one if any device in the system might do non-coherent DMA.
  */
-#define ARCH_KMALLOC_MINALIGN	128
+#define ARCH_DMA_MINALIGN	128
 #endif
 
 #endif /* __ASM_MACH_GENERIC_KMALLOC_H */
diff --git a/arch/mips/include/asm/mach-ip27/kmalloc.h b/arch/mips/include/asm/mach-ip27/kmalloc.h
index 426bd04..82c23ce 100644
--- a/arch/mips/include/asm/mach-ip27/kmalloc.h
+++ b/arch/mips/include/asm/mach-ip27/kmalloc.h
@@ -2,7 +2,7 @@
 #define __ASM_MACH_IP27_KMALLOC_H
 
 /*
- * All happy, no need to define ARCH_KMALLOC_MINALIGN
+ * All happy, no need to define ARCH_DMA_MINALIGN
  */
 
 #endif /* __ASM_MACH_IP27_KMALLOC_H */
diff --git a/arch/mips/include/asm/mach-ip32/kmalloc.h b/arch/mips/include/asm/mach-ip32/kmalloc.h
index b1e0be6..042ca92 100644
--- a/arch/mips/include/asm/mach-ip32/kmalloc.h
+++ b/arch/mips/include/asm/mach-ip32/kmalloc.h
@@ -3,9 +3,9 @@
 
 
 #if defined(CONFIG_CPU_R5000) || defined(CONFIG_CPU_RM7000)
-#define ARCH_KMALLOC_MINALIGN	32
+#define ARCH_DMA_MINALIGN	32
 #else
-#define ARCH_KMALLOC_MINALIGN	128
+#define ARCH_DMA_MINALIGN	128
 #endif
 
 #endif /* __ASM_MACH_IP32_KMALLOC_H */
diff --git a/arch/mips/include/asm/mach-tx49xx/kmalloc.h b/arch/mips/include/asm/mach-tx49xx/kmalloc.h
index 913ff19..6ac7f1f 100644
--- a/arch/mips/include/asm/mach-tx49xx/kmalloc.h
+++ b/arch/mips/include/asm/mach-tx49xx/kmalloc.h
@@ -2,7 +2,7 @@
 #define __ASM_MACH_TX49XX_KMALLOC_H
 
 /*
- * All happy, no need to define ARCH_KMALLOC_MINALIGN
+ * All happy, no need to define ARCH_DMA_MINALIGN
  */
 
 #endif /* __ASM_MACH_TX49XX_KMALLOC_H */
diff --git a/arch/mn10300/include/asm/cache.h b/arch/mn10300/include/asm/cache.h
index 6e2fe28..781bf61 100644
--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -21,7 +21,7 @@
 #define L1_CACHE_DISPARITY	L1_CACHE_NENTRIES * L1_CACHE_BYTES
 #endif
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 /* data cache purge registers
  * - read from the register to unconditionally purge that cache line
diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
index bd0849d..68d73b2 100644
--- a/arch/powerpc/include/asm/page_32.h
+++ b/arch/powerpc/include/asm/page_32.h
@@ -10,7 +10,7 @@
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
 #ifdef CONFIG_NOT_COHERENT_CACHE
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 #endif
 
 #ifdef CONFIG_PTE_64BIT
diff --git a/arch/sh/include/asm/page.h b/arch/sh/include/asm/page.h
index fb703d1..c4e0b3d 100644
--- a/arch/sh/include/asm/page.h
+++ b/arch/sh/include/asm/page.h
@@ -180,7 +180,7 @@ typedef struct page *pgtable_t;
  * Some drivers need to perform DMA into kmalloc'ed buffers
  * and so we have to increase the kmalloc minalign for this.
  */
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #ifdef CONFIG_SUPERH64
 /*
diff --git a/arch/xtensa/include/asm/cache.h b/arch/xtensa/include/asm/cache.h
index ed8cd3c..d2fd932 100644
--- a/arch/xtensa/include/asm/cache.h
+++ b/arch/xtensa/include/asm/cache.h
@@ -29,6 +29,6 @@
 # define CACHE_WAY_SIZE ICACHE_WAY_SIZE
 #endif
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #endif	/* _XTENSA_CACHE_H */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 1acfa73..791a502 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -17,7 +17,6 @@
 
 #include <trace/events/kmem.h>
 
-#ifndef ARCH_KMALLOC_MINALIGN
 /*
  * Enforce a minimum alignment for the kmalloc caches.
  * Usually, the kmalloc caches are cache_line_size() aligned, except when
@@ -27,6 +26,9 @@
  * ARCH_KMALLOC_MINALIGN allows that.
  * Note that increasing this value may disable some debug features.
  */
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 62667f7..4382db0 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -1,7 +1,9 @@
 #ifndef __LINUX_SLOB_DEF_H
 #define __LINUX_SLOB_DEF_H
 
-#ifndef ARCH_KMALLOC_MINALIGN
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
 #endif
 
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 6447a72..6d14409 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -106,15 +106,17 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#if defined(ARCH_KMALLOC_MINALIGN) && ARCH_KMALLOC_MINALIGN > 8
-#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
+#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
+#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
 #else
 #define KMALLOC_MIN_SIZE 8
 #endif
 
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 
-#ifndef ARCH_KMALLOC_MINALIGN
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
+#else
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
-- 
1.6.5

