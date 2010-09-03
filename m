Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab0ICAwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:59048 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0ICAvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:50 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de
Subject: [PATCH -mm 8/8] add the common dma_addr_t typedef to include/linux/types.h
Date: Fri,  3 Sep 2010 09:49:16 +0900
Message-Id: <1283474956-14710-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures can use the common dma_addr_t typedef now. We can
remove the arch specific dma_addr_t.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de
---
 arch/alpha/include/asm/types.h   |    1 -
 arch/arm/include/asm/types.h     |    3 ---
 arch/avr32/include/asm/types.h   |    8 --------
 arch/cris/include/asm/types.h    |    3 ---
 arch/frv/include/asm/types.h     |    8 --------
 arch/h8300/include/asm/types.h   |    4 ----
 arch/ia64/include/asm/types.h    |    3 ---
 arch/m32r/include/asm/types.h    |    3 ---
 arch/m68k/include/asm/types.h    |    3 ---
 arch/mips/include/asm/types.h    |    6 ------
 arch/mn10300/include/asm/types.h |    7 -------
 arch/parisc/include/asm/types.h  |    3 ---
 arch/powerpc/include/asm/types.h |    5 -----
 arch/s390/include/asm/types.h    |    6 ------
 arch/sparc/include/asm/types.h   |    4 ----
 arch/x86/include/asm/types.h     |    8 --------
 arch/xtensa/include/asm/types.h  |    4 ----
 include/asm-generic/types.h      |   27 ---------------------------
 include/linux/types.h            |    6 ++++++
 19 files changed, 6 insertions(+), 106 deletions(-)

diff --git a/arch/alpha/include/asm/types.h b/arch/alpha/include/asm/types.h
index bd621ec..e46e503 100644
--- a/arch/alpha/include/asm/types.h
+++ b/arch/alpha/include/asm/types.h
@@ -27,7 +27,6 @@ typedef unsigned int umode_t;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-typedef u64 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index 345df01..c684e37 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/avr32/include/asm/types.h b/arch/avr32/include/asm/types.h
index 9cefda6..72667a3 100644
--- a/arch/avr32/include/asm/types.h
+++ b/arch/avr32/include/asm/types.h
@@ -23,14 +23,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 
diff --git a/arch/cris/include/asm/types.h b/arch/cris/include/asm/types.h
index 5790262..4405508 100644
--- a/arch/cris/include/asm/types.h
+++ b/arch/cris/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide, just like our other addresses.  */
- 
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/frv/include/asm/types.h b/arch/frv/include/asm/types.h
index 613bf1e..aa3e7fd 100644
--- a/arch/frv/include/asm/types.h
+++ b/arch/frv/include/asm/types.h
@@ -27,14 +27,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TYPES_H */
diff --git a/arch/h8300/include/asm/types.h b/arch/h8300/include/asm/types.h
index 1287519..bb2c91a 100644
--- a/arch/h8300/include/asm/types.h
+++ b/arch/h8300/include/asm/types.h
@@ -22,10 +22,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/ia64/include/asm/types.h b/arch/ia64/include/asm/types.h
index 93773fd..82b3939 100644
--- a/arch/ia64/include/asm/types.h
+++ b/arch/ia64/include/asm/types.h
@@ -40,9 +40,6 @@ struct fnptr {
 	unsigned long gp;
 };
 
-/* DMA addresses are 64-bits wide, in general.  */
-typedef u64 dma_addr_t;
-
 # endif /* __KERNEL__ */
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/m32r/include/asm/types.h b/arch/m32r/include/asm/types.h
index bc9f7ff..fd84b48 100644
--- a/arch/m32r/include/asm/types.h
+++ b/arch/m32r/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* DMA addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/m68k/include/asm/types.h b/arch/m68k/include/asm/types.h
index 6441cb5..10ad92f 100644
--- a/arch/m68k/include/asm/types.h
+++ b/arch/m68k/include/asm/types.h
@@ -25,9 +25,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* DMA addresses are always 32-bits wide */
-
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/mips/include/asm/types.h b/arch/mips/include/asm/types.h
index 544a285..9520dc8 100644
--- a/arch/mips/include/asm/types.h
+++ b/arch/mips/include/asm/types.h
@@ -33,12 +33,6 @@ typedef unsigned short umode_t;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#if (defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR)) \
-    || defined(CONFIG_64BIT)
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 typedef u64 dma64_addr_t;
 
 /*
diff --git a/arch/mn10300/include/asm/types.h b/arch/mn10300/include/asm/types.h
index 7b9f010..c1833eb 100644
--- a/arch/mn10300/include/asm/types.h
+++ b/arch/mn10300/include/asm/types.h
@@ -26,13 +26,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TYPES_H */
diff --git a/arch/parisc/include/asm/types.h b/arch/parisc/include/asm/types.h
index 20135cc..bc164dd 100644
--- a/arch/parisc/include/asm/types.h
+++ b/arch/parisc/include/asm/types.h
@@ -16,9 +16,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
index a5aea0c..e16a6b2 100644
--- a/arch/powerpc/include/asm/types.h
+++ b/arch/powerpc/include/asm/types.h
@@ -44,11 +44,6 @@ typedef struct {
 
 typedef __vector128 vector128;
 
-#if defined(__powerpc64__) || defined(CONFIG_PHYS_64BIT)
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 typedef u64 dma64_addr_t;
 
 typedef struct {
diff --git a/arch/s390/include/asm/types.h b/arch/s390/include/asm/types.h
index 04d6b95..f7f6ae6 100644
--- a/arch/s390/include/asm/types.h
+++ b/arch/s390/include/asm/types.h
@@ -31,12 +31,6 @@ typedef __signed__ long saddr_t;
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
-#ifdef __s390x__
-/* DMA addresses come in 32-bit and 64-bit flavours. */
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 
 #ifndef __s390x__
 typedef union {
diff --git a/arch/sparc/include/asm/types.h b/arch/sparc/include/asm/types.h
index 09c79a9..f02d330 100644
--- a/arch/sparc/include/asm/types.h
+++ b/arch/sparc/include/asm/types.h
@@ -22,10 +22,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses come in generic and 64-bit flavours.  */
-
-typedef u32 dma_addr_t;
-
 #if defined(__arch64__)
 
 /*** SPARC 64 bit ***/
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index df1da20..8810205 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -1,20 +1,12 @@
 #ifndef _ASM_X86_TYPES_H
 #define _ASM_X86_TYPES_H
 
-#define dma_addr_t	dma_addr_t
-
 #include <asm-generic/types.h>
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
-#if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
-/* DMA addresses come in 32-bit and 64-bit flavours. */
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
diff --git a/arch/xtensa/include/asm/types.h b/arch/xtensa/include/asm/types.h
index c89569a..b1c981e 100644
--- a/arch/xtensa/include/asm/types.h
+++ b/arch/xtensa/include/asm/types.h
@@ -32,10 +32,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
 #endif	/* __KERNEL__ */
 #endif
 
diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
index fba7d33..7a0f69e 100644
--- a/include/asm-generic/types.h
+++ b/include/asm-generic/types.h
@@ -12,31 +12,4 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-/*
- * DMA addresses may be very different from physical addresses
- * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
- * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
- * physical addresses.
- * This default defines dma_addr_t to have the same size as
- * phys_addr_t, which is the most common way.
- * Do not define the dma64_addr_t type, which never really
- * worked.
- */
-#ifndef dma_addr_t
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif /* CONFIG_PHYS_ADDR_T_64BIT */
-#endif /* dma_addr_t */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_GENERIC_TYPES_H */
diff --git a/include/linux/types.h b/include/linux/types.h
index 01a082f..266f1d0 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -150,6 +150,12 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif /* dma_addr_t */
+
 #endif /* __KERNEL__ */
 
 /*
-- 
1.7.1

