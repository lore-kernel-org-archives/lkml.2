Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1DZNYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:24:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53121 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab1DZNYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Uohdgw3Xlwi7jjDi2jDNOkT9UuuxgnEXzGsLImpD8MyYT1MVjqus0Fk/5HjiUpdXjF
         6M1aKc3n0+fHxoOrCht6g94+6bh2YL0Wnlqlh+exFdcW7+9xb0qL/TNMKFBiYuVwpPgB
         tBnS13DtBkWm5ECzvWCR7ae3Ixca2kqf/PzqM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 5/6] s390: use asm-generic/bitops/le.h
Date: Tue, 26 Apr 2011 22:23:42 +0900
Message-Id: <1303824223-3566-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303824223-3566-1-git-send-email-akinobu.mita@gmail.com>
References: <1303824223-3566-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous style change enables to use asm-generic/bitops/le.h
on s390.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---

Changes from previous submission:
- Rebase to mainline

 arch/s390/include/asm/bitops.h |   37 ++-----------------------------------
 1 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 426c974..667c6e9 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -746,41 +746,6 @@ static inline int sched_find_first_bit(unsigned long *b)
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
-static inline void __set_bit_le(unsigned long nr, void *addr)
-{
-	__set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline void __clear_bit_le(unsigned long nr, void *addr)
-{
-	__clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
-{
-	return __test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_and_set_bit_le(unsigned long nr, void *addr)
-{
-	return test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
-{
-	return __test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
-{
-	return test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_bit_le(unsigned long nr, const void *addr)
-{
-	return test_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
 static inline int find_first_zero_bit_le(void *vaddr, unsigned int size)
 {
 	unsigned long bytes, bits;
@@ -865,6 +830,8 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
 }
 #define find_next_bit_le find_next_bit_le
 
+#include <asm-generic/bitops/le.h>
+
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_bit_le(nr, addr)
 #define ext2_clear_bit_atomic(lock, nr, addr)	\
-- 
1.7.4.4

