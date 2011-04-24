Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1DXJwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:52:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60538 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab1DXJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Eo3LaiQTbu5NCMax5vW0fKEaAe4YKnTCFNyBgGNDP7FR6SVABq+7X8iHgjDNUpX1pZ
         DtcT/lys74opWN4oX9s/ypsp90e+9GaYvXfE/rjuUCTXJniq2DXSVbRxyyNcPdPwMa3m
         AsIa9eJj0wncUVgiLWidQ9mmF/fBQwaeRpoPQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 2/6] bitops: add #ifndef for each of find bitops
Date: Sun, 24 Apr 2011 18:51:13 +0900
Message-Id: <1303638677-11211-3-git-send-email-akinobu.mita@gmail.com>
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

This adds the #ifndef for each of the find bitops in the generic header
and source files.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>
---
 include/asm-generic/bitops/find.h |    4 ++++
 include/asm-generic/bitops/le.h   |    7 +++++++
 include/linux/bitops.h            |    2 ++
 lib/find_last_bit.c               |    4 ++++
 lib/find_next_bit.c               |   12 ++++++++++++
 5 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 110fa70..71c7780 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
+#ifndef find_next_bit
 /**
  * find_next_bit - find the next set bit in a memory region
  * @addr: The address to base the search on
@@ -9,7 +10,9 @@
  */
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
+#endif
 
+#ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
  * @addr: The address to base the search on
@@ -18,6 +21,7 @@ extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
  */
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
+#endif
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 946a21b..f95c663 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -30,13 +30,20 @@ static inline unsigned long find_first_zero_bit_le(const void *addr,
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
+#ifndef find_next_zero_bit_le
 extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
+#endif
+
+#ifndef find_next_bit_le
 extern unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
+#endif
 
+#ifndef find_first_zero_bit_le
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
+#endif
 
 #else
 #error "Please fix <asm/byteorder.h>"
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2184c6b..4829252 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -149,6 +149,7 @@ static inline unsigned long __ffs64(u64 word)
 #ifdef __KERNEL__
 
 #ifdef CONFIG_GENERIC_FIND_LAST_BIT
+#ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
  * @addr: The address to start the search at
@@ -158,6 +159,7 @@ static inline unsigned long __ffs64(u64 word)
  */
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
+#endif
 #endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
 #endif /* __KERNEL__ */
diff --git a/lib/find_last_bit.c b/lib/find_last_bit.c
index 5d202e3..d903959 100644
--- a/lib/find_last_bit.c
+++ b/lib/find_last_bit.c
@@ -15,6 +15,8 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
+#ifndef find_last_bit
+
 unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long words;
@@ -43,3 +45,5 @@ found:
 	return size;
 }
 EXPORT_SYMBOL(find_last_bit);
+
+#endif
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index b0a8767..c02d09f 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -17,6 +17,7 @@
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+#ifndef find_next_bit
 /*
  * Find the next set bit in a memory region.
  */
@@ -59,7 +60,9 @@ found_middle:
 	return result + __ffs(tmp);
 }
 EXPORT_SYMBOL(find_next_bit);
+#endif
 
+#ifndef find_next_zero_bit
 /*
  * This implementation of find_{first,next}_zero_bit was stolen from
  * Linus' asm-alpha/bitops.h.
@@ -103,9 +106,11 @@ found_middle:
 	return result + ffz(tmp);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
+#endif
 #endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+#ifndef find_first_bit
 /*
  * Find the first set bit in a memory region.
  */
@@ -131,7 +136,9 @@ found:
 	return result + __ffs(tmp);
 }
 EXPORT_SYMBOL(find_first_bit);
+#endif
 
+#ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
  */
@@ -157,6 +164,7 @@ found:
 	return result + ffz(tmp);
 }
 EXPORT_SYMBOL(find_first_zero_bit);
+#endif
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
@@ -186,6 +194,7 @@ static inline unsigned long ext2_swab(const unsigned long y)
 #endif
 }
 
+#ifndef find_next_zero_bit_le
 unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
@@ -229,7 +238,9 @@ found_middle_swap:
 	return result + ffz(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
+#endif
 
+#ifndef find_next_bit_le
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
@@ -274,6 +285,7 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_bit_le);
+#endif
 
 #endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
-- 
1.7.4.4

