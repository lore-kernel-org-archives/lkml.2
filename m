Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1AVNPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:15:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1AVNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QaCyalH80MbwRqmyhyvnkz2Ft3woJREymPQFlF4usfsTNRN6OJvahYDLorb/gONEZk
         jR6vwSk6QSAGCmXEGVua2tHvUClGgLuggGa8Ao+YmpugFmELwQHKBs/7QyA3C5JCq6Eg
         93Lni5ErCmkAyxVypg45R4ijxQRgMeEM7RTkk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH v5 25/27] bitops: remove ext2 non-atomic bitops from asm/bitops.h
Date: Sat, 22 Jan 2011 22:13:57 +0900
Message-Id: <1295702039-23186-26-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the result of conversions, there are no users of ext2 non-atomic bit
operations except for ext2 filesystem itself.  Now we can put them into
architecture independent code in ext2 filesystem, and remove from
asm/bitops.h for all architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - remove casts to "unsigned long *" due to le-bitops prototype change

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 arch/alpha/include/asm/bitops.h              |    1 -
 arch/arm/include/asm/bitops.h                |    7 -------
 arch/avr32/include/asm/bitops.h              |    1 -
 arch/blackfin/include/asm/bitops.h           |    1 -
 arch/cris/include/asm/bitops.h               |    1 -
 arch/frv/include/asm/bitops.h                |    1 -
 arch/h8300/include/asm/bitops.h              |    1 -
 arch/ia64/include/asm/bitops.h               |    1 -
 arch/m32r/include/asm/bitops.h               |    1 -
 arch/m68k/include/asm/bitops_mm.h            |    7 -------
 arch/m68k/include/asm/bitops_no.h            |    7 -------
 arch/mips/include/asm/bitops.h               |    1 -
 arch/mn10300/include/asm/bitops.h            |    1 -
 arch/parisc/include/asm/bitops.h             |    1 -
 arch/powerpc/include/asm/bitops.h            |   14 --------------
 arch/s390/include/asm/bitops.h               |    7 -------
 arch/sh/include/asm/bitops.h                 |    1 -
 arch/sparc/include/asm/bitops_32.h           |    1 -
 arch/sparc/include/asm/bitops_64.h           |    1 -
 arch/tile/include/asm/bitops.h               |    1 -
 arch/x86/include/asm/bitops.h                |    1 -
 arch/xtensa/include/asm/bitops.h             |    1 -
 fs/ext2/ext2.h                               |    6 ++++++
 include/asm-generic/bitops.h                 |    1 -
 include/asm-generic/bitops/ext2-non-atomic.h |   18 ------------------
 25 files changed, 6 insertions(+), 78 deletions(-)
 delete mode 100644 include/asm-generic/bitops/ext2-non-atomic.h

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 955fec7..822433a 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -455,7 +455,6 @@ sched_find_first_bit(const unsigned long b[2])
 }
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 872d502..a7b037e 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -325,18 +325,11 @@ static inline int fls(int x)
 		_find_next_bit_le((unsigned long *)(p), sz, off)
 /*
  * Ext2 is defined to use little-endian byte ordering.
- * These do not need to be atomic.
  */
-#define ext2_set_bit __test_and_set_bit_le
 #define ext2_set_bit_atomic(lock, nr, p)	\
 		test_and_set_bit_le(nr, p)
-#define ext2_clear_bit __test_and_clear_bit_le
 #define ext2_clear_bit_atomic(lock, nr, p)	\
 		test_and_clear_bit_le(nr, p)
-#define ext2_test_bit test_bit_le
-#define ext2_find_first_zero_bit find_first_zero_bit_le
-#define ext2_find_next_zero_bit find_next_zero_bit_le
-#define ext2_find_next_bit find_next_bit_le
 
 /*
  * Minix is defined to use little-endian byte ordering.
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index 1c482fc..73a163a 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -300,7 +300,6 @@ static inline int ffs(unsigned long word)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index fe257cf..6a69690 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -26,7 +26,6 @@
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 599ae67..71bea40 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -155,7 +155,6 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index 2631917..e3ea644 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -402,7 +402,6 @@ int __ilog2_u64(u64 n)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
 #define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index 763094f..23cea66 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -201,7 +201,6 @@ static __inline__ unsigned long __ffs(unsigned long word)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 2cde4f0..336984a 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -457,7 +457,6 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index 681f7e8..cdfb4c8 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -267,7 +267,6 @@ static __inline__ int test_and_change_bit(int nr, volatile void * addr)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index ba1ce43..645a4d5 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -473,17 +473,10 @@ static inline unsigned long find_next_bit_le(const void *addr,
 
 /* Bitmap functions for the ext2 filesystem. */
 
-#define ext2_set_bit __test_and_set_bit_le
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_bit_le(nr, addr)
-#define ext2_clear_bit __test_and_clear_bit_le
 #define ext2_clear_bit_atomic(lock, nr, addr)	\
 	test_and_clear_bit_le(nr, addr)
-#define ext2_find_next_zero_bit find_next_zero_bit_le
-#define ext2_find_next_bit find_next_bit_le
-#define ext2_test_bit test_bit_le
-#define ext2_find_first_zero_bit find_first_zero_bit_le
-#define ext2_find_first_bit find_first_bit_le
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index e2209ac..de59543 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -332,13 +332,6 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
-#define ext2_set_bit __test_and_set_bit_le
-#define ext2_clear_bit __test_and_clear_bit_le
-#define ext2_test_bit test_bit_le
-#define ext2_find_first_zero_bit find_first_zero_bit_le
-#define ext2_find_next_zero_bit find_next_zero_bit_le
-#define ext2_find_next_bit find_next_bit_le
-
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/mips/include/asm/bitops.h b/arch/mips/include/asm/bitops.h
index ef420eb..e062718 100644
--- a/arch/mips/include/asm/bitops.h
+++ b/arch/mips/include/asm/bitops.h
@@ -677,7 +677,6 @@ static inline int ffs(int word)
 #include <asm-generic/bitops/const_hweight.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 42b5453..a5f460c 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -234,7 +234,6 @@ int ffs(int x)
 	test_and_clear_bit((nr), (addr))
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 4b9e58d..919d7ed 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -223,7 +223,6 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 /* '3' is bits per byte */
 #define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index a77f6be..cec17b5 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -312,25 +312,11 @@ unsigned long find_next_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
-#define ext2_set_bit(nr,addr) \
-	__test_and_set_bit_le((nr), (unsigned long*)addr)
-#define ext2_clear_bit(nr, addr) \
-	__test_and_clear_bit_le((nr), (unsigned long*)addr)
-
 #define ext2_set_bit_atomic(lock, nr, addr) \
 	test_and_set_bit_le((nr), (unsigned long*)addr)
 #define ext2_clear_bit_atomic(lock, nr, addr) \
 	test_and_clear_bit_le((nr), (unsigned long*)addr)
 
-#define ext2_test_bit(nr, addr)      test_bit_le((nr),(unsigned long*)addr)
-
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_bit_le((unsigned long*)addr, size)
-#define ext2_find_next_zero_bit(addr, size, off) \
-	find_next_zero_bit_le((unsigned long *)addr, size, off)
-
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_bit_le((unsigned long *)addr, size, off)
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index f47c8cf..c7c1d80 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -837,17 +837,10 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
 	return offset + find_first_bit_le(p, size);
 }
 
-#define ext2_set_bit __test_and_set_bit_le
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_bit_le(nr, addr)
-#define ext2_clear_bit __test_and_clear_bit_le
 #define ext2_clear_bit_atomic(lock, nr, addr)	\
 	test_and_clear_bit_le(nr, addr)
-#define ext2_test_bit test_bit_le
-#define ext2_find_first_zero_bit find_first_zero_bit_le
-#define ext2_find_next_zero_bit find_next_zero_bit_le
-#define ext2_find_first_bit find_first_bit_le
-#define ext2_find_next_bit find_next_bit_le
 
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/sh/include/asm/bitops.h b/arch/sh/include/asm/bitops.h
index 9167810..fc5cd5b 100644
--- a/arch/sh/include/asm/bitops.h
+++ b/arch/sh/include/asm/bitops.h
@@ -95,7 +95,6 @@ static inline unsigned long ffz(unsigned long word)
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
diff --git a/arch/sparc/include/asm/bitops_32.h b/arch/sparc/include/asm/bitops_32.h
index 5b3ab06..75da6f8 100644
--- a/arch/sparc/include/asm/bitops_32.h
+++ b/arch/sparc/include/asm/bitops_32.h
@@ -104,7 +104,6 @@ static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 9097862..66db28e 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -90,7 +90,6 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr) \
 	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index 56b0355..5447add 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -123,7 +123,6 @@ static inline unsigned long __arch_hweight64(__u64 w)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
 #endif /* _ASM_TILE_BITOPS_H */
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index c68bc10..3c95e07 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -457,7 +457,6 @@ static inline int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\
 	test_and_set_bit((nr), (unsigned long *)(addr))
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 0475c11..a56b7b5 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -107,7 +107,6 @@ static inline unsigned long __fls(unsigned long word)
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #ifdef __XTENSA_EL__
 # define ext2_set_bit_atomic(lock,nr,addr)				\
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 6346a2a..fa21a53 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -174,3 +174,9 @@ ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
 	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
 		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
 }
+
+#define ext2_set_bit	__test_and_set_bit_le
+#define ext2_clear_bit	__test_and_clear_bit_le
+#define ext2_test_bit	test_bit_le
+#define ext2_find_first_zero_bit	find_first_zero_bit_le
+#define ext2_find_next_zero_bit		find_next_zero_bit_le
diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index 933710b..dd7c014 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -39,7 +39,6 @@
 #include <asm-generic/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff --git a/include/asm-generic/bitops/ext2-non-atomic.h b/include/asm-generic/bitops/ext2-non-atomic.h
deleted file mode 100644
index ad0a244..0000000
--- a/include/asm-generic/bitops/ext2-non-atomic.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
-#define _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
-
-#define ext2_set_bit(nr,addr)	\
-	__test_and_set_bit_le((nr), (unsigned long *)(addr))
-#define ext2_clear_bit(nr,addr)	\
-	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
-
-#define ext2_test_bit(nr,addr)	\
-	test_bit_le((nr), (unsigned long *)(addr))
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_bit_le((unsigned long *)(addr), (size))
-#define ext2_find_next_zero_bit(addr, size, off) \
-	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_bit_le((unsigned long *)(addr), (size), (off))
-
-#endif /* _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_ */
-- 
1.7.3.4

