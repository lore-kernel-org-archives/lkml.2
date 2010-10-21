Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0JUOmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:42:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65446 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0JUOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oa2UmAuimrYpB7AXojigfG2KzZl+zY4pVqVq2CzEwrl2WDWfgYtbDVwsksGx4VGs5R
         fIPJY5+8eVXyiH/Fyx3hNT+QZsCx3X8BsP14SuSRzFbEhg7qLU6ptoaWycInzY6bgurM
         AjqSuxnml6zKMx9FBUQ97yqBhKFgWgYSyBGCw=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 01/22] bitops: merge little and big endian definisions in asm-generic/bitops/le.h
Date: Thu, 21 Oct 2010 23:40:56 +0900
Message-Id: <1287672077-5797-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the forthcoming changes smaller, this merges
macro definisions in asm-generic/bitops/le.h for big-endian and
little-endian as much as possible.

This also removes unused BITOP_WORD macro.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
No change from previous submission

 include/asm-generic/bitops/le.h |   38 +++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 80e3bf1..db2be81 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -4,27 +4,28 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
-
 #if defined(__LITTLE_ENDIAN)
 
-#define generic_test_le_bit(nr, addr) test_bit(nr, addr)
-#define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
-#define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
-
-#define generic_test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
-#define generic_test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
+#define BITOP_LE_SWIZZLE	0
 
-#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
-#define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
-
-#define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
+#define generic_find_next_zero_le_bit(addr, size, offset) \
+	find_next_zero_bit(addr, size, offset)
 #define generic_find_next_le_bit(addr, size, offset) \
-			find_next_bit(addr, size, offset)
+	find_next_bit(addr, size, offset)
 
 #elif defined(__BIG_ENDIAN)
 
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
 #define generic_test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 #define generic___set_le_bit(nr, addr) \
@@ -42,15 +43,6 @@
 #define generic___test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
 #define generic_find_first_zero_le_bit(addr, size) \
         generic_find_next_zero_le_bit((addr), (size), 0)
 
-- 
1.7.1.231.gd0b16

