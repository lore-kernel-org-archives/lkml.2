Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab1FDP0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:26:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36110 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1FDP0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rd3OYh6q1ICUt63czfyo2hnRGBSIVx2ReOxb92v+xDa7XzzEn6F3X1YTn1OuHniTVS
         P4hcaJqiTizIpaSOm/u85qxdTIu27cB+8T/XJ0vRpK6OLSrn7402ymQ5irS1tUhhUWCB
         Gtx9XJSKRjs801Fmna8ED61QO8uiuijrJw1yc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andreas Dilger <adilger@dilger.ca>, Arnd Bergmann <arnd@arndb.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-arch@vger.kernel.org
Subject: [PATCH v2] asm-generic: add another generic ext2 atomic bitops
Date: Sun,  5 Jun 2011 00:27:31 +0900
Message-Id: <1307201251-16805-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of architectures implement ext2 atomic bitops as
test_and_{set,clear}_bit() without spinlock.

This adds this type of generic implementation in ext2-atomic-setbit.h
and use it wherever possible.

Suggested-by: Andreas Dilger <adilger@dilger.ca>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-arch@vger.kernel.org
---
v2: provide a new asm-generic/bitops/ext2-atomic-setbit.h

 arch/alpha/include/asm/bitops.h                 |    3 +--
 arch/arm/include/asm/bitops.h                   |    5 +----
 arch/cris/include/asm/bitops.h                  |    3 +--
 arch/frv/include/asm/bitops.h                   |    3 +--
 arch/ia64/include/asm/bitops.h                  |    3 +--
 arch/m68k/include/asm/bitops_mm.h               |    5 +----
 arch/mn10300/include/asm/bitops.h               |    7 +------
 arch/parisc/include/asm/bitops.h                |    9 +--------
 arch/powerpc/include/asm/bitops.h               |    5 +----
 arch/s390/include/asm/bitops.h                  |    5 +----
 arch/sparc/include/asm/bitops_64.h              |    5 +----
 arch/tile/include/asm/bitops_64.h               |    5 +----
 arch/x86/include/asm/bitops.h                   |    5 +----
 arch/xtensa/include/asm/bitops.h                |   14 +-------------
 include/asm-generic/bitops/ext2-atomic-setbit.h |   11 +++++++++++
 include/asm-generic/bitops/ext2-atomic.h        |    4 ++++
 16 files changed, 29 insertions(+), 63 deletions(-)
 create mode 100644 include/asm-generic/bitops/ext2-atomic-setbit.h

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 85b8152..a19ba5e 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -456,8 +456,7 @@ sched_find_first_bit(const unsigned long b[2])
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index b4892a0..86fb8e3 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -310,10 +310,7 @@ static inline int find_next_bit_le(const void *p, int size, int offset)
 /*
  * Ext2 is defined to use little-endian byte ordering.
  */
-#define ext2_set_bit_atomic(lock, nr, p)	\
-		test_and_set_bit_le(nr, p)
-#define ext2_clear_bit_atomic(lock, nr, p)	\
-		test_and_clear_bit_le(nr, p)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 310e0de..c0092fc 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -156,8 +156,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index a1d00b0..57bf85d 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -403,8 +403,7 @@ int __ilog2_u64(u64 n)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
-#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index b76f7e0..8e20bff 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -458,8 +458,7 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 89cf5b8..4ec7272 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -491,10 +491,7 @@ static inline unsigned long find_next_bit_le(const void *addr,
 
 /* Bitmap functions for the ext2 filesystem. */
 
-#define ext2_set_bit_atomic(lock, nr, addr)	\
-	test_and_set_bit_le(nr, addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)	\
-	test_and_clear_bit_le(nr, addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 0939462..596bb27 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -227,12 +227,7 @@ int ffs(int x)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit((nr), (addr))
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit((nr), (addr))
-
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 #include <asm-generic/bitops/le.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 43c516f..4e833aa 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -223,14 +223,7 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-
-/* '3' is bits per byte */
-#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
-
-#define ext2_set_bit_atomic(l,nr,addr) \
-		test_and_set_bit((nr)   ^ LE_BYTE_ADDR, (unsigned long *)addr)
-#define ext2_clear_bit_atomic(l,nr,addr) \
-		test_and_clear_bit( (nr) ^ LE_BYTE_ADDR, (unsigned long *)addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index f18c6d9..e137afc 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -327,10 +327,7 @@ unsigned long find_next_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit_le((nr), (unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit_le((nr), (unsigned long*)addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 667c6e9..e5beb49 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -832,10 +832,7 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr)	\
-	test_and_set_bit_le(nr, addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)	\
-	test_and_clear_bit_le(nr, addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 38e9aa1..325e295 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -91,10 +91,7 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr) \
-	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock,nr,addr) \
-	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index 99615e8..68f8c5b 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -97,9 +97,6 @@ static inline int test_and_change_bit(unsigned nr,
 	return (oldval & mask) != 0;
 }
 
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* _ASM_TILE_BITOPS_64_H */
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 69d5813..1775d6e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -458,10 +458,7 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_BITOPS_H */
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index c8fac8d..40aa7fe 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -108,19 +108,7 @@ static inline unsigned long __fls(unsigned long word)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 
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
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff --git a/include/asm-generic/bitops/ext2-atomic-setbit.h b/include/asm-generic/bitops/ext2-atomic-setbit.h
new file mode 100644
index 0000000..5a09978
--- /dev/null
+++ b/include/asm-generic/bitops/ext2-atomic-setbit.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_
+#define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_
+
+/*
+ * Atomic bitops based version of ext2 atomic bitops
+ */
+
+#define ext2_set_bit_atomic(l, nr, addr)	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit_atomic(l, nr, addr)	test_and_clear_bit_le(nr, addr)
+
+#endif /* _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_ */
diff --git a/include/asm-generic/bitops/ext2-atomic.h b/include/asm-generic/bitops/ext2-atomic.h
index ecf1c9d..87f0f10 100644
--- a/include/asm-generic/bitops/ext2-atomic.h
+++ b/include/asm-generic/bitops/ext2-atomic.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 
+/*
+ * Spinlock based version of ext2 atomic bitops
+ */
+
 #define ext2_set_bit_atomic(lock, nr, addr)		\
 	({						\
 		int ret;				\
-- 
1.7.4.4

