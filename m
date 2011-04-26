Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1DZNYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:24:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42055 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1DZNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LQuDBfCDwh9XzVgybVbxzlqGeZ9FjMI8W7NkJuRSSJP9gEh223g1IMKry/WKVzcwY1
         l0D0zP8VLNzVBw6gW2bl9glyXn4gKBvx1B7e6dWhv9Ve4OWln0YFGd2NQC26DTybEt7a
         MnX4exsxhVppKkAHcioFwaWcfV2qRP2d3b8TA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 4/6] arm: use asm-generic/bitops/le.h
Date: Tue, 26 Apr 2011 22:23:41 +0900
Message-Id: <1303824223-3566-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303824223-3566-1-git-send-email-akinobu.mita@gmail.com>
References: <1303824223-3566-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous style change enables to use asm-generic/bitops/le.h
on arm.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---

No change from previous submission

 arch/arm/include/asm/bitops.h |   43 ++++------------------------------------
 1 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 18a024b..b4892a0 100644
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

