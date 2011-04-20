Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1DTOVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:21:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56059 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1DTOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ohZpDyorsVs+kDH5thz61bTs95Kafa3pKBKtWnRRNoncyioPSb9wA8jDI+0Fn0KSQT
         hkPCoMAvD/k5bw5kCL2ZW2K+4T2rxp/aXh8RlBmC05cbY4eVl2ZNeFPK3O2LWnL2wIKy
         OKvrB3NThO5JDs/9d9XtA4U1C+OT2bEDOBobg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] arm: use asm-generic/bitops/le.h
Date: Wed, 20 Apr 2011 23:20:51 +0900
Message-Id: <1303309252-9946-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303309252-9946-1-git-send-email-akinobu.mita@gmail.com>
References: <1303309252-9946-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous change enables to use asm-generic/bitops/le.h on arm.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/bitops.h |   41 ++++-------------------------------------
 1 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index ec2e0d4..4615e1b 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -203,8 +203,6 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
 #define find_first_bit(p,sz)		_find_first_bit_le(p,sz)
 #define find_next_bit(p,sz,off)		_find_next_bit_le(p,sz,off)
 
-#define WORD_BITOFF_TO_LE(x)		((x))
-
 #else
 /*
  * These are the big endian, atomic definitions.
@@ -214,8 +212,6 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
 #define find_first_bit(p,sz)		_find_first_bit_be(p,sz)
 #define find_next_bit(p,sz,off)		_find_next_bit_be(p,sz,off)
 
-#define WORD_BITOFF_TO_LE(x)		((x) ^ 0x18)
-
 #endif
 
 #if __LINUX_ARM_ARCH__ < 5
@@ -287,40 +283,9 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static inline void __set_bit_le(int nr, void *addr)
-{
-	__set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline void __clear_bit_le(int nr, void *addr)
-{
-	__clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int __test_and_set_bit_le(int nr, void *addr)
-{
-	return __test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
+#include <asm-generic/bitops/le.h>
 
-static inline int test_and_set_bit_le(int nr, void *addr)
-{
-	return test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int __test_and_clear_bit_le(int nr, void *addr)
-{
-	return __test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int test_and_clear_bit_le(int nr, void *addr)
-{
-	return test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int test_bit_le(int nr, const void *addr)
-{
-	return test_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
+#ifdef __ARMEB__
 
 static inline int find_first_zero_bit_le(const void *p, unsigned size)
 {
@@ -337,6 +302,8 @@ static inline int find_next_bit_le(const void *p, int size, int offset)
 	return _find_next_bit_le(p, size, offset);
 }
 
+#endif
+
 /*
  * Ext2 is defined to use little-endian byte ordering.
  */
-- 
1.7.4.4

