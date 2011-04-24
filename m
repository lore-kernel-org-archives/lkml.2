Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1DXJvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:51:37 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56442 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1DXJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q4XNg5LrY1vX1w57Zt/MPOlKtS5LRZECjtakBX5ijCtQkU5htZ6OOR0o7zqkbUysCV
         h1ORMR9Vj2pHADXspFIGLII7NgeypNCC5rpHPvva8R9B3zm1FNzLEmNIqsnWn9CmpOQn
         uZAZvofZcqncUYWDeUvJsu3JU8oQ/+Ct3Awlw=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/6] arm: use asm-generic/bitops/le.h
Date: Sun, 24 Apr 2011 18:51:15 +0900
Message-Id: <1303638677-11211-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous style change enables to use asm-generic/bitops/le.h
on arm.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/bitops.h |   43 ++++------------------------------------
 1 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 73ee73e..585d408 100644
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
@@ -287,40 +283,7 @@ static inline int fls(int x)
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
-
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
@@ -340,6 +303,10 @@ static inline int find_next_bit_le(const void *p, int size, int offset)
 }
 #define find_next_bit_le find_next_bit_le
 
+#endif
+
+#include <asm-generic/bitops/le.h>
+
 /*
  * Ext2 is defined to use little-endian byte ordering.
  */
-- 
1.7.4.4

