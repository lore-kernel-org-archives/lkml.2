Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1DXJvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:51:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50127 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab1DXJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=svlDvfT7uon1o4YzBUcjn4QLjVx0LUpzO0xMQZfCasjz5xNSluRNPLOaDRUkG9HbeY
         mFjfcsiyNF/dpxDjZkoVtfGFAkryynszprkVXlso8a7253pHGuNW0adiEK6wNRa6F1Wf
         yzju70K/xXHhLWOo0pidR7cbasUl++O5Gq8FY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/6] arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
Date: Sun, 24 Apr 2011 18:51:14 +0900
Message-Id: <1303638677-11211-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous style change, CONFIG_GENERIC_FIND_NEXT_BIT,
CONFIG_GENERIC_FIND_BIT_LE, and CONFIG_GENERIC_FIND_LAST_BIT are
not used to test for existence of find bitops anymore.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/alpha/Kconfig      |    4 ----
 arch/blackfin/Kconfig   |    3 ---
 arch/cris/Kconfig       |    4 ----
 arch/frv/Kconfig        |    8 --------
 arch/h8300/Kconfig      |    8 --------
 arch/ia64/Kconfig       |    4 ----
 arch/m32r/Kconfig       |    8 --------
 arch/m68k/Kconfig.nommu |    4 ----
 arch/microblaze/Kconfig |    6 ------
 arch/mips/Kconfig       |    8 --------
 arch/mn10300/Kconfig    |    3 ---
 arch/parisc/Kconfig     |    8 --------
 arch/powerpc/Kconfig    |    8 --------
 arch/score/Kconfig      |    3 ---
 arch/sh/Kconfig         |    6 ------
 arch/sparc/Kconfig      |    8 --------
 arch/tile/Kconfig       |    1 -
 arch/um/Kconfig.x86     |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    6 ------
 include/linux/bitops.h  |    2 --
 lib/Kconfig             |   10 ----------
 lib/Makefile            |    9 +++------
 lib/find_next_bit.c     |    6 ------
 24 files changed, 3 insertions(+), 126 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9808998..1e3fd03 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -40,10 +40,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8addb12..f465e10 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -45,9 +45,6 @@ config GENERIC_BUG
 config ZONE_DMA
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index a6d0306..b6b94a2 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -31,10 +31,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 064f621..cb884e4 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -19,14 +19,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index e20322f..091ed61 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -41,14 +41,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index e5cc56a..38280ef 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -78,10 +78,6 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 	depends on HUGETLB_PAGE
 	default y
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 736b808..85b44e8 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -256,14 +256,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/m68k/Kconfig.nommu b/arch/m68k/Kconfig.nommu
index 273bcca..fc98f9b 100644
--- a/arch/m68k/Kconfig.nommu
+++ b/arch/m68k/Kconfig.nommu
@@ -2,10 +2,6 @@ config FPU
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	default n
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index eccdefe..e446bab 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -33,12 +33,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8e256cc..319c0a1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -774,14 +774,6 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y if !MIPS_MT_SMTC
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index feaf09c..1f87034 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -44,9 +44,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CMOS_UPDATE
         def_bool n
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 69ff049..65adc86 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -47,14 +47,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_BUG
 	bool
 	default y
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8f4d50b..17d0ddc 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -91,14 +91,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	help
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index e73bc78..288add8 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -43,9 +43,6 @@ config NO_DMA
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 4b89da2..b20a2da 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -71,12 +71,6 @@ config GENERIC_CSUM
 	def_bool y
 	depends on SUPERH64
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e560d10..9d7c2ff 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -189,14 +189,6 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y if SPARC64
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e32b0c2..a1f4642 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -5,7 +5,6 @@ config TILE
 	def_bool y
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index a9da516..c349960 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -15,7 +15,6 @@ endmenu
 config UML_X86
 	def_bool y
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 
 config 64BIT
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..2617e00 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -65,7 +65,6 @@ config X86
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 7c275f5..5d43c1f 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -20,12 +20,6 @@ config XTENSA
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 4829252..a3ef66a 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -148,7 +148,6 @@ static inline unsigned long __ffs64(u64 word)
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_GENERIC_FIND_LAST_BIT
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
@@ -160,7 +159,6 @@ static inline unsigned long __ffs64(u64 word)
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
 #endif
-#endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
 #endif /* __KERNEL__ */
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 9c10e38..830181c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -19,16 +19,6 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-
-config GENERIC_FIND_BIT_LE
-	bool
-
-config GENERIC_FIND_LAST_BIT
-	bool
-	default y
-
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index ef0f285..e2b8116 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o find_next_bit.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -21,7 +21,8 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 find_last_bit.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
@@ -38,10 +39,6 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
-lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_BIT_LE) += find_next_bit.o
-obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index c02d09f..4bd75a7 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -16,7 +16,6 @@
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
-#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 #ifndef find_next_bit
 /*
  * Find the next set bit in a memory region.
@@ -107,9 +106,7 @@ found_middle:
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
-#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 #ifndef find_first_bit
 /*
  * Find the first set bit in a memory region.
@@ -165,10 +162,8 @@ found:
 }
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
-#ifdef CONFIG_GENERIC_FIND_BIT_LE
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -287,5 +282,4 @@ found_middle_swap:
 EXPORT_SYMBOL(find_next_bit_le);
 #endif
 
-#endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
-- 
1.7.4.4

