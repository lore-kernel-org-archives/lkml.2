Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1AVNNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:13:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1AVNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pPN8ro8iIloJ+hioocx312vRc//MzdZIWu2Wdfg0pl4557vvihbL6Y5kiJbybtt4gL
         Wquell+9kiMG5ieVBFZDKW578mx3MngBIuO3IeJNCSbToeDLgLF+CEUw6wCcocEm/fIi
         hXbf0glkUYZ4wUKg9Tzqv0T9Cs2/5FZhUKvFM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 06/27] powerpc: introduce little-endian bitops
Date: Sat, 22 Jan 2011 22:13:38 +0900
Message-Id: <1295702039-23186-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming existing powerpc
native little-endian bit operations and changing them to take any
pointer types.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---

Change from v4:
 - change the prototypes and add casts in the macro to take any pointer types

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 arch/powerpc/include/asm/bitops.h |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index db567ed..a77f6be 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -281,27 +281,27 @@ unsigned long __arch_hweight64(__u64 w);
 
 /* Little-endian versions */
 
-static __inline__ int test_le_bit(unsigned long nr,
-				  __const__ unsigned long *addr)
+static __inline__ int test_bit_le(unsigned long nr,
+				  __const__ void *addr)
 {
 	__const__ unsigned char	*tmp = (__const__ unsigned char *) addr;
 	return (tmp[nr >> 3] >> (nr & 7)) & 1;
 }
 
-#define __set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+#define __set_bit_le(nr, addr) \
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
+#define __clear_bit_le(nr, addr) \
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
-#define test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+#define test_and_set_bit_le(nr, addr) \
+	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
+#define test_and_clear_bit_le(nr, addr) \
+	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
-#define __test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+#define __test_and_set_bit_le(nr, addr) \
+	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
+#define __test_and_clear_bit_le(nr, addr) \
+	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
@@ -313,16 +313,16 @@ unsigned long find_next_bit_le(const void *addr,
 /* Bitmap functions for the ext2 filesystem */
 
 #define ext2_set_bit(nr,addr) \
-	__test_and_set_le_bit((nr), (unsigned long*)addr)
+	__test_and_set_bit_le((nr), (unsigned long*)addr)
 #define ext2_clear_bit(nr, addr) \
-	__test_and_clear_le_bit((nr), (unsigned long*)addr)
+	__test_and_clear_bit_le((nr), (unsigned long*)addr)
 
 #define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_le_bit((nr), (unsigned long*)addr)
+	test_and_set_bit_le((nr), (unsigned long*)addr)
 #define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_le_bit((nr), (unsigned long*)addr)
+	test_and_clear_bit_le((nr), (unsigned long*)addr)
 
-#define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
+#define ext2_test_bit(nr, addr)      test_bit_le((nr),(unsigned long*)addr)
 
 #define ext2_find_first_zero_bit(addr, size) \
 	find_first_zero_bit_le((unsigned long*)addr, size)
@@ -334,13 +334,13 @@ unsigned long find_next_bit_le(const void *addr,
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
-	__test_and_set_le_bit(nr, (unsigned long *)addr)
+	__test_and_set_bit_le(nr, (unsigned long *)addr)
 #define minix_set_bit(nr,addr) \
-	__set_le_bit(nr, (unsigned long *)addr)
+	__set_bit_le(nr, (unsigned long *)addr)
 #define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit(nr, (unsigned long *)addr)
+	__test_and_clear_bit_le(nr, (unsigned long *)addr)
 #define minix_test_bit(nr,addr) \
-	test_le_bit(nr, (unsigned long *)addr)
+	test_bit_le(nr, (unsigned long *)addr)
 
 #define minix_find_first_zero_bit(addr,size) \
 	find_first_zero_bit_le((unsigned long *)addr, size)
-- 
1.7.3.4

