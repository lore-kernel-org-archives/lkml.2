Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0I2KGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 06:06:34 -0400
Received: from [150.82.175.143] ([150.82.175.143]:39718 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750951Ab0I2KGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 06:06:33 -0400
X-Greylist: delayed 3574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 06:06:32 EDT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] bitops: remove duplicated extern declarations
Date: Wed, 29 Sep 2010 18:08:51 +0900
Message-Id: <1285751331-29148-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1285751331-29148-1-git-send-email-akinobu.mita@gmail.com>
References: <1285751331-29148-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_GENERIC_FIND_NEXT_BIT is enabled, find_next_bit() and
find_next_zero_bit() are doubly declared in asm-generic/bitops/find.h
and linux/bitops.h.

asm/bitops.h includes asm-generic/bitops/find.h if and only if the
architecture enables CONFIG_GENERIC_FIND_NEXT_BIT. And asm/bitops.h
is included by linux/bitops.h

So we can just remove the extern declarations of find_next_bit() and
find_next_zero_bit() in linux/bitops.h.

Also we can remove unneeded #ifndef CONFIG_GENERIC_FIND_NEXT_BIT in
asm-generic/bitops/find.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/bitops/find.h |   14 ++++++++++++--
 include/linux/bitops.h            |   23 -----------------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 30afec0..110fa70 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -1,13 +1,23 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
-#ifndef CONFIG_GENERIC_FIND_NEXT_BIT
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
 
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
-#endif
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index adb0f11..827cc95 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -149,28 +149,5 @@ extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
 #endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
-#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
-
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- */
-extern unsigned long find_next_bit(const unsigned long *addr,
-				   unsigned long size, unsigned long offset);
-
-/**
- * find_next_zero_bit - find the next cleared bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- */
-
-extern unsigned long find_next_zero_bit(const unsigned long *addr,
-					unsigned long size,
-					unsigned long offset);
-
-#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 #endif /* __KERNEL__ */
 #endif
-- 
1.7.1.231.gd0b16

