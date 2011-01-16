Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1APNIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:08:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1APNIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o4YJp1O9FksjDplBHzhJs5bzdcrlxW96SLmjeAoqlf+CTJgQFPI5EaAA8e/qHjnLoP
         eDeN6nf081YFkCgq3tIgCXTONxBsh1F9kgIeW3+ir5FijlMp7LswosKe837+i9IyLoKK
         Qc0DECqZK611HHSp++zaigQ2eNnqI/3Nab0jc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 03/24] powerpc: introduce little-endian bitops
Date: Sun, 16 Jan 2011 22:08:32 +0900
Message-Id: <1295183333-13802-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming existing powerpc
native little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/powerpc/include/asm/bitops.h |   38 ++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index e903264..7b1c5a9 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -281,29 +281,29 @@ unsigned long __arch_hweight64(__u64 w);
 
 /* Little-endian versions */
 
-static __inline__ int test_le_bit(unsigned long nr,
+static __inline__ int test_bit_le(unsigned long nr,
 				  __const__ unsigned long *addr)
 {
 	__const__ unsigned char	*tmp = (__const__ unsigned char *) addr;
 	return (tmp[nr >> 3] >> (nr & 7)) & 1;
 }
 
-#define __set_le_bit(nr, addr) \
+#define __set_bit_le(nr, addr) \
 	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_le_bit(nr, addr) \
+#define __clear_bit_le(nr, addr) \
 	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define test_and_set_le_bit(nr, addr) \
+#define test_and_set_bit_le(nr, addr) \
 	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_le_bit(nr, addr) \
+#define test_and_clear_bit_le(nr, addr) \
 	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define __test_and_set_le_bit(nr, addr) \
+#define __test_and_set_bit_le(nr, addr) \
 	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_le_bit(nr, addr) \
+#define __test_and_clear_bit_le(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) \
+#define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
 unsigned long find_next_zero_bit_le(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
@@ -313,19 +313,19 @@ unsigned long find_next_bit_le(const unsigned long *addr,
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
-	find_first_zero_le_bit((unsigned long*)addr, size)
+	find_first_zero_bit_le((unsigned long*)addr, size)
 #define ext2_find_next_zero_bit(addr, size, off) \
 	find_next_zero_bit_le((unsigned long *)addr, size, off)
 
@@ -334,16 +334,16 @@ unsigned long find_next_bit_le(const unsigned long *addr,
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
-	find_first_zero_le_bit((unsigned long *)addr, size)
+	find_first_zero_bit_le((unsigned long *)addr, size)
 
 #include <asm-generic/bitops/sched.h>
 
-- 
1.7.3.4

