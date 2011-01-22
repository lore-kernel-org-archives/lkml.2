Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1AVNNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:13:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1AVNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KrewS1niP/jadnWgp741lXn++IZ51OpRowHiHIq2Ey6SXResi5/P3I6XmLK8D9D/py
         z3S3ayXJ17mCGujvdmEX0eomDA7SB3003CqnafkqfJC89lG5NjhNJPAwCGgSj+SJwzPK
         RcOaRkBdDqDEf2Gm6AGE+JrGoN3uekQ2QxXjk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Mikael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Luck, Tony" <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <willy@debian.org>,
        Grant Grundler <grundler@parisc-linux.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Kazumoto Kojima <kkojima@rr.iij4u.or.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH v5 05/27] asm-generic: change little-endian bitops to take any pointer types
Date: Sat, 22 Jan 2011 22:13:37 +0900
Message-Id: <1295702039-23186-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the little-endian bitops take any pointer types by
changing the prototypes and adding casts in the preprocessor macros.

That would seem to at least make all the filesystem code happier, and
they can continue to do just something like

  #define ext2_set_bit __test_and_set_bit_le

(or whatever the exact sequence ends up being).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---

Change from v4:
 - new patch 

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 arch/powerpc/include/asm/bitops.h |    4 ++--
 include/asm-generic/bitops/le.h   |   24 ++++++++++++------------
 lib/find_next_bit.c               |   10 ++++++----
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index 97aacbd..db567ed 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -305,10 +305,10 @@ static __inline__ int test_le_bit(unsigned long nr,
 
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
-unsigned long find_next_zero_bit_le(const unsigned long *addr,
+unsigned long find_next_zero_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 
-unsigned long find_next_bit_le(const unsigned long *addr,
+unsigned long find_next_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 394ac3e..7644a15 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -9,19 +9,19 @@
 #define BITOP_LE_SWIZZLE	0
 
 #define find_next_zero_bit_le(addr, size, offset) \
-	find_next_zero_bit(addr, size, offset)
+	find_next_zero_bit((unsigned long *)(addr), size, offset)
 #define find_next_bit_le(addr, size, offset) \
-	find_next_bit(addr, size, offset)
+	find_next_bit((unsigned long *)(addr), size, offset)
 #define find_first_zero_bit_le(addr, size) \
-	find_first_zero_bit(addr, size)
+	find_first_zero_bit((unsigned long *)(addr), size)
 
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-extern unsigned long find_next_zero_bit_le(const unsigned long *addr,
+extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
-extern unsigned long find_next_bit_le(const unsigned long *addr,
+extern unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
 
 #define find_first_zero_bit_le(addr, size) \
@@ -32,20 +32,20 @@ extern unsigned long find_next_bit_le(const unsigned long *addr,
 #endif
 
 #define test_bit_le(nr, addr) \
-	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __set_bit_le(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __clear_bit_le(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #define test_and_set_bit_le(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define test_and_clear_bit_le(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #define __test_and_set_bit_le(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __test_and_clear_bit_le(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index c093ba9..7667c3d 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -185,15 +185,16 @@ static inline unsigned long ext2_swab(const unsigned long y)
 #endif
 }
 
-unsigned long find_next_zero_bit_le(const unsigned long *addr, unsigned
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
+	const unsigned long *p = addr;
 	unsigned long result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
 	if (offset >= size)
 		return size;
+	p += BITOP_WORD(offset);
 	size -= result;
 	offset &= (BITS_PER_LONG - 1UL);
 	if (offset) {
@@ -228,15 +229,16 @@ found_middle_swap:
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 
-unsigned long find_next_bit_le(const unsigned long *addr, unsigned
+unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
+	const unsigned long *p = addr;
 	unsigned long result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
 	if (offset >= size)
 		return size;
+	p += BITOP_WORD(offset);
 	size -= result;
 	offset &= (BITS_PER_LONG - 1UL);
 	if (offset) {
-- 
1.7.3.4

