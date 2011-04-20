Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1DTOVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:21:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63231 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1DTOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BhH9ZlawM1gBns1Wlbk9pH2xn869RKMuqxTAxAD+KxZK1yKxItrKKzOTMk5baaFTrq
         dCs69My3ZY/8X2cQciwGfmEhZaSRS4JaPMMQua4ApDi/GkP0bOFxnxrDM9id7JJYE3iB
         9prWAxluBFrlTMFKULj3zg74wR6o80erz+n6U=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] bitops: add ifdef CONFIG_GENERIC_FIND_BIT_LE guard
Date: Wed, 20 Apr 2011 23:20:50 +0900
Message-Id: <1303309252-9946-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures have optimized find_*_bit_le() as static inline
functions but other little-endian bitops are identical to the generic
version.

This adds #ifdef CONFIG_GENERIC_FIND_BIT_LE guard for find_*_bit_le()
in asm-generic/bitops/le.h so that those architectures can use this
header file.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 include/asm-generic/bitops/le.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 946a21b..bd2253e 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -30,6 +30,8 @@ static inline unsigned long find_first_zero_bit_le(const void *addr,
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
+#ifdef CONFIG_GENERIC_FIND_BIT_LE
+
 extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
 extern unsigned long find_next_bit_le(const void *addr,
@@ -38,6 +40,8 @@ extern unsigned long find_next_bit_le(const void *addr,
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
 
+#endif /* CONFIG_GENERIC_FIND_BIT_LE */
+
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
-- 
1.7.4.4

