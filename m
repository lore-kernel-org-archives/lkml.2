Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0JHKAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:00:34 -0400
Received: from [150.82.175.143] ([150.82.175.143]:53851 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753665Ab0JHKAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:00:32 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/5] bitops: add generic implementation of ext2 atomic bitops by test_and_{set,clear}_bit
Date: Fri,  8 Oct 2010 19:03:09 +0900
Message-Id: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces asm-generic header file for generic implementation of
ext2 atomic bit operations by test_and_set_bit() and test_and_clear_bit().

alpha, arm, cris, frv, ia64, m68k, mn10300, parisc, powerpc, s390,
sparc64, x86, xtensa can use this header file in its asm/bitops.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/alpha/include/asm/bitops.h               |    4 +--
 arch/arm/include/asm/bitops.h                 |    6 +---
 arch/cris/include/asm/bitops.h                |    4 +--
 arch/frv/include/asm/bitops.h                 |    4 +--
 arch/ia64/include/asm/bitops.h                |    4 +--
 arch/m68k/include/asm/bitops_mm.h             |    4 +-
 arch/mn10300/include/asm/bitops.h             |    6 +----
 arch/parisc/include/asm/bitops.h              |    9 +-------
 arch/powerpc/include/asm/bitops.h             |    8 ++----
 arch/s390/include/asm/bitops.h                |    6 +---
 arch/sparc/include/asm/bitops_64.h            |    6 +----
 arch/x86/include/asm/bitops.h                 |    6 +----
 arch/xtensa/include/asm/bitops.h              |   15 +-------------
 include/asm-generic/bitops/ext2-atomic-test.h |   26 +++++++++++++++++++++++++
 include/asm-generic/bitops/ext2-atomic.h      |    4 +++
 15 files changed, 48 insertions(+), 64 deletions(-)
 create mode 100644 include/asm-generic/bitops/ext2-atomic-test.h

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index adfab8a..778468b 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -455,9 +455,7 @@ sched_find_first_bit(const unsigned long b[2])
 }
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 338ff19..f98b8c8 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -309,12 +309,8 @@ static inline int fls(int x)
  */
 #define ext2_set_bit(nr,p)			\
 		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_set_bit_atomic(lock,nr,p)          \
-                test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
 #define ext2_clear_bit(nr,p)			\
 		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_clear_bit_atomic(lock,nr,p)        \
-                test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
 #define ext2_test_bit(nr,p)			\
 		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
 #define ext2_find_first_zero_bit(p,sz)		\
@@ -324,6 +320,8 @@ static inline int fls(int x)
 #define ext2_find_next_bit(p, sz, off) \
 		_find_next_bit_le(p, sz, off)
 
+#include <asm-generic/bitops/ext2-atomic-test.h>
+
 /*
  * Minix is defined to use little-endian byte ordering.
  * These do not need to be atomic.
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 9e69cfb..e1f77fc 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -155,9 +155,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index 50ae91b..0d718ce 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -402,9 +402,7 @@ int __ilog2_u64(u64 n)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
-#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix-le.h>
 
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 9da3df6..22ba18b 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -457,9 +457,7 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index b4ecdaa..776d7b3 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -362,9 +362,7 @@ static inline int minix_test_bit(int nr, const void *vaddr)
 /* Bitmap functions for the ext2 filesystem. */
 
 #define ext2_set_bit(nr, addr)			__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_find_next_zero_bit(addr, size, offset) \
 	generic_find_next_zero_le_bit((unsigned long *)addr, size, offset)
 #define ext2_find_next_bit(addr, size, offset) \
@@ -461,6 +459,8 @@ static inline unsigned long generic_find_next_le_bit(const unsigned long *addr,
 	return (p - addr) * 32 + res;
 }
 
+#include <asm-generic/bitops/ext2-atomic-test.h>
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 3f50e96..23e3a5a 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -228,11 +228,7 @@ int ffs(int x)
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit((nr), (addr))
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit((nr), (addr))
-
+#include <asm-generic/bitops/ext2-atomic-test.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 7a6ea10..2bd003d 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -223,14 +223,7 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-/* '3' is bits per byte */
-#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
-
-#define ext2_set_bit_atomic(l,nr,addr) \
-		test_and_set_bit((nr)   ^ LE_BYTE_ADDR, (unsigned long *)addr)
-#define ext2_clear_bit_atomic(l,nr,addr) \
-		test_and_clear_bit( (nr) ^ LE_BYTE_ADDR, (unsigned long *)addr)
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index 30964ae..d8dba27 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -307,11 +307,6 @@ unsigned long generic_find_next_le_bit(const unsigned long *addr,
 #define ext2_clear_bit(nr, addr) \
 	__test_and_clear_le_bit((nr), (unsigned long*)addr)
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_le_bit((nr), (unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_le_bit((nr), (unsigned long*)addr)
-
 #define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
 
 #define ext2_find_first_zero_bit(addr, size) \
@@ -321,6 +316,9 @@ unsigned long generic_find_next_le_bit(const unsigned long *addr,
 
 #define ext2_find_next_bit(addr, size, off) \
 	generic_find_next_le_bit((unsigned long *)addr, size, off)
+
+#include <asm-generic/bitops/ext2-atomic-test.h>
+
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 2e05972..052b4fb 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -744,12 +744,8 @@ static inline int sched_find_first_bit(unsigned long *b)
 
 #define ext2_set_bit(nr, addr)       \
 	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_set_bit_atomic(lock, nr, addr)       \
-	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_clear_bit(nr, addr)     \
 	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)     \
-	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_test_bit(nr, addr)      \
 	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 
@@ -834,6 +830,8 @@ static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
 	return offset + ext2_find_first_bit(p, size);
 }
 
+#include <asm-generic/bitops/ext2-atomic-test.h>
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 766121a..fd12692 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -90,11 +90,7 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock,nr,addr) \
-	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock,nr,addr) \
-	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 903683b..601f4c4 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -457,11 +457,7 @@ static inline int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 6c39303..1aa0a5c 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -107,20 +107,7 @@ static inline unsigned long __fls(unsigned long word)
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#ifdef __XTENSA_EL__
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr), (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr), (unsigned long*)(addr))
-#elif defined(__XTENSA_EB__)
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr) ^ 0x18, (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr) ^ 0x18, (unsigned long*)(addr))
-#else
-# error processor byte order undefined!
-#endif
+#include <asm-generic/bitops/ext2-atomic-test.h>
 
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff --git a/include/asm-generic/bitops/ext2-atomic-test.h b/include/asm-generic/bitops/ext2-atomic-test.h
new file mode 100644
index 0000000..ece193a
--- /dev/null
+++ b/include/asm-generic/bitops/ext2-atomic-test.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_TEST_H_
+#define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_TEST_H_
+
+/*
+ * Generic implementation of ext2 atomic bit operations
+ * by test_and_set_bit() and test_and_clear_bit()
+ */
+
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN)
+#define LE_BYTE_ADDR 0
+#elif defined(__BIG_ENDIAN)
+/* '3' is bits per byte */
+#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
+#else
+#error processor byte order undefined!
+#endif
+
+#define ext2_set_bit_atomic(l, nr, addr) \
+	test_and_set_bit((nr) ^ LE_BYTE_ADDR, (unsigned long *)(addr))
+
+#define ext2_clear_bit_atomic(l, nr, addr) \
+	test_and_clear_bit((nr) ^ LE_BYTE_ADDR, (unsigned long *)(addr))
+
+#endif /* _ASM_GENERIC_BITOPS_EXT2_ATOMIC_TEST_H_ */
diff --git a/include/asm-generic/bitops/ext2-atomic.h b/include/asm-generic/bitops/ext2-atomic.h
index ab1c875..151219f 100644
--- a/include/asm-generic/bitops/ext2-atomic.h
+++ b/include/asm-generic/bitops/ext2-atomic.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 
+/*
+ * Generic implementation of ext2 atomic bit operations by spinlock
+ */
+
 #define ext2_set_bit_atomic(lock, nr, addr)		\
 	({						\
 		int ret;				\
-- 
1.7.1.231.gd0b16

