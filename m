Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1DXJvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:51:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56442 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab1DXJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JUoOsX5kk+ri3QBnJP43U7nx/OW6yvaVB/Tg3foQpjvqCwOgdhaTwmupDARjDxkNva
         1zBtBJVaJ6iOA575wAWGvc0h/ucNJ88ZFn7DXQQt26ZRTJwuUVrvCU/8o+Am/Wk890vy
         Oezll3axevhM+PWngPUNom6ssM3IDPIEqcUbc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 1/6] arch: add #define for each of optimized find bitops
Date: Sun, 24 Apr 2011 18:51:12 +0900
Message-Id: <1303638677-11211-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/arm/include/asm/bitops.h     |    3 +++
 arch/avr32/include/asm/bitops.h   |   15 +++++++++++++++
 arch/m68k/include/asm/bitops_mm.h |    8 ++++++++
 arch/m68k/include/asm/bitops_no.h |    1 +
 arch/s390/include/asm/bitops.h    |    8 ++++++++
 5 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index ec2e0d4..73ee73e 100644
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
index 27d5d67..4909a90 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -200,6 +200,7 @@ out:
 	res += ((long)p - (long)vaddr - 4) * 8;
 	return res < size ? res : size;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 				     int offset)
@@ -229,6 +230,7 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit(p, size - offset);
 }
+#define find_next_zero_bit find_next_zero_bit
 
 static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 {
@@ -253,6 +255,7 @@ out:
 	res += ((long)p - (long)vaddr - 4) * 8;
 	return res < size ? res : size;
 }
+#define find_first_bit find_first_bit
 
 static inline int find_next_bit(const unsigned long *vaddr, int size,
 				int offset)
@@ -282,6 +285,7 @@ static inline int find_next_bit(const unsigned long *vaddr, int size,
 	/* No one yet, search remaining full bytes for a one */
 	return offset + find_first_bit(p, size - offset);
 }
+#define find_next_bit find_next_bit
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
@@ -398,6 +402,7 @@ out:
 	res += (p - addr) * 32;
 	return res < size ? res : size;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -427,6 +432,7 @@ static inline unsigned long find_next_zero_bit_le(const void *addr,
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit_le(p, size - offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
@@ -451,6 +457,7 @@ out:
 	res += (p - addr) * 32;
 	return res < size ? res : size;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -480,6 +487,7 @@ static inline unsigned long find_next_bit_le(const void *addr,
 	/* No set bit yet, search remaining full bytes for a set bit */
 	return offset + find_first_bit_le(p, size - offset);
 }
+#define find_next_bit_le find_next_bit_le
 
 /* Bitmap functions for the ext2 filesystem. */
 
diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 1ab40f2..e98d42c 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -324,6 +324,7 @@ found_first:
 found_middle:
 	return result + ffz(__swab32(tmp));
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 38fab08..fc298b2 100644
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
 
 #include <asm-generic/bitops/ext2-atomic-test.h>
 
-- 
1.7.4.4

