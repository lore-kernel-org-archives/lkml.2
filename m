Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1D0NV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:21:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38046 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab1D0NUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hMY8zyKe3sJ2htxxxrhR2G4ylOKnTtIw+h1SwPQwrUpIKADYzbu87WEGNhS0zEIBoF
         Anpo6qJqtrZxZ5KM8coPRRctHqFafXIEn4ruCcAwXSWsARrEgkT7A2Sqb4n7aZkKXvA6
         D58QQx9GyEljd7Nvo7tf+76G+5QCM8BlEQWsI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 2/7] arch: add #define for each of optimized find bitops
Date: Wed, 27 Apr 2011 22:20:06 +0900
Message-Id: <1303910411-15793-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The style that we normally use in asm-generic is to test the macro itself
for existence, so in asm-generic, do:

	#ifndef find_next_zero_bit_le
	extern unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset);
	#endif

and in the architectures, write

	static inline unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset)
	#define find_next_zero_bit_le find_next_zero_bit_le

This adds the #define for each of the optimized find bitops in the
architectures.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---

Changes from previous submission:
- Add Acked-by: lines
- Add #define for find_next_bit_le on m68knommu

 arch/arm/include/asm/bitops.h     |    3 +++
 arch/avr32/include/asm/bitops.h   |   15 +++++++++++++++
 arch/m68k/include/asm/bitops_mm.h |    8 ++++++++
 arch/m68k/include/asm/bitops_no.h |    2 ++
 arch/s390/include/asm/bitops.h    |    8 ++++++++
 5 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 6b7403f..18a024b 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -326,16 +326,19 @@ static inline int find_first_zero_bit_le(const void *p, unsigned size)
 {
 	return _find_first_zero_bit_le(p, size);
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline int find_next_zero_bit_le(const void *p, int size, int offset)
 {
 	return _find_next_zero_bit_le(p, size, offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_next_bit_le(const void *p, int size, int offset)
 {
 	return _find_next_bit_le(p, size, offset);
 }
+#define find_next_bit_le find_next_bit_le
 
 /*
  * Ext2 is defined to use little-endian byte ordering.
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index 72444d9..b70c19b 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -270,14 +270,21 @@ static inline int __fls(unsigned long word)
 
 unsigned long find_first_zero_bit(const unsigned long *addr,
 				  unsigned long size);
+#define find_first_zero_bit find_first_zero_bit
+
 unsigned long find_next_zero_bit(const unsigned long *addr,
 				 unsigned long size,
 				 unsigned long offset);
+#define find_next_zero_bit find_next_zero_bit
+
 unsigned long find_first_bit(const unsigned long *addr,
 			     unsigned long size);
+#define find_first_bit find_first_bit
+
 unsigned long find_next_bit(const unsigned long *addr,
 				 unsigned long size,
 				 unsigned long offset);
+#define find_next_bit find_next_bit
 
 /*
  * ffs: find first bit set. This is defined the same way as
@@ -299,6 +306,14 @@ static inline int ffs(unsigned long word)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+extern unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
+#define find_next_zero_bit_le find_next_zero_bit_le
+
+extern unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
+#define find_next_bit_le find_next_bit_le
+
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 9d69f6e..a938ebe 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -198,6 +198,7 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
 out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 				     int offset)
@@ -223,6 +224,7 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 	res = find_first_zero_bit(p, size - ((long)p - (long)vaddr) * 8);
 	return offset + res;
 }
+#define find_next_zero_bit find_next_zero_bit
 
 static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 {
@@ -245,6 +247,7 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
+#define find_first_bit find_first_bit
 
 static inline int find_next_bit(const unsigned long *vaddr, int size,
 				int offset)
@@ -270,6 +273,7 @@ static inline int find_next_bit(const unsigned long *vaddr, int size,
 	res = find_first_bit(p, size - ((long)p - (long)vaddr) * 8);
 	return offset + res;
 }
+#define find_next_bit find_next_bit
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
@@ -384,6 +388,7 @@ static inline int find_first_zero_bit_le(const void *vaddr, unsigned size)
 			break;
 	return (p - addr) * 32 + res;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -408,6 +413,7 @@ static inline unsigned long find_next_zero_bit_le(const void *addr,
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit_le(p, size - offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
@@ -429,6 +435,7 @@ static inline int find_first_bit_le(const void *vaddr, unsigned size)
 			break;
 	return (p - addr) * 32 + res;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -453,6 +460,7 @@ static inline unsigned long find_next_bit_le(const void *addr,
 	/* No set bit yet, search remaining full bytes for a set bit */
 	return offset + find_first_bit_le(p, size - offset);
 }
+#define find_next_bit_le find_next_bit_le
 
 /* Bitmap functions for the ext2 filesystem. */
 
diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 97d1d0c..cd229fb 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -335,6 +335,7 @@ found_first:
 found_middle:
 	return result + ffz(__swab32(tmp));
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
@@ -379,6 +380,7 @@ found_middle:
 found_middle_swap:
 	return result + __ffs(__swab32(tmp));
 }
+#define find_next_bit_le find_next_bit_le
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index e1c8f3a..426c974 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -621,6 +621,7 @@ static inline unsigned long find_first_zero_bit(const unsigned long *addr,
 	bits = __ffz_word(bytes*8, __load_ulong_be(addr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 /**
  * find_first_bit - find the first set bit in a memory region
@@ -641,6 +642,7 @@ static inline unsigned long find_first_bit(const unsigned long * addr,
 	bits = __ffs_word(bytes*8, __load_ulong_be(addr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_bit find_first_bit
 
 /**
  * find_next_zero_bit - find the first zero bit in a memory region
@@ -677,6 +679,7 @@ static inline int find_next_zero_bit (const unsigned long * addr,
 	}
 	return offset + find_first_zero_bit(p, size);
 }
+#define find_next_zero_bit find_next_zero_bit
 
 /**
  * find_next_bit - find the first set bit in a memory region
@@ -713,6 +716,7 @@ static inline int find_next_bit (const unsigned long * addr,
 	}
 	return offset + find_first_bit(p, size);
 }
+#define find_next_bit find_next_bit
 
 /*
  * Every architecture must define this function. It's the fastest
@@ -787,6 +791,7 @@ static inline int find_first_zero_bit_le(void *vaddr, unsigned int size)
 	bits = __ffz_word(bytes*8, __load_ulong_le(vaddr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline int find_next_zero_bit_le(void *vaddr, unsigned long size,
 					  unsigned long offset)
@@ -816,6 +821,7 @@ static inline int find_next_zero_bit_le(void *vaddr, unsigned long size,
         }
 	return offset + find_first_zero_bit_le(p, size);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline unsigned long find_first_bit_le(void *vaddr, unsigned long size)
 {
@@ -827,6 +833,7 @@ static inline unsigned long find_first_bit_le(void *vaddr, unsigned long size)
 	bits = __ffs_word(bytes*8, __load_ulong_le(vaddr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline int find_next_bit_le(void *vaddr, unsigned long size,
 				     unsigned long offset)
@@ -856,6 +863,7 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
 	}
 	return offset + find_first_bit_le(p, size);
 }
+#define find_next_bit_le find_next_bit_le
 
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_bit_le(nr, addr)
-- 
1.7.4.4

