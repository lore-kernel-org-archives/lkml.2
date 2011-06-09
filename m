Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab1FILJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:09:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab1FILJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:09:44 -0400
From: GuanXuetao <gxt@mprc.pku.edu.cn>
To: arnd@arndb.de
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] unicore32: fix build error for find bitops
Date: Thu,  9 Jun 2011 11:09:12 +0000
Message-Id: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.5.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:09:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

Remove the __uc32_ prefix in find bitops functions.
see commit <19de85ef574c3a2182e3ccad9581805052f14946>
  bitops: add #ifndef for each of find bitops

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/unicore32/include/asm/bitops.h |    6 ------
 arch/unicore32/kernel/ksyms.c       |    4 ++--
 arch/unicore32/lib/findbit.S        |   14 ++++++++------
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/include/asm/bitops.h
index 1628a63..a9653f0 100644
--- a/arch/unicore32/include/asm/bitops.h
+++ b/arch/unicore32/include/asm/bitops.h
@@ -13,12 +13,6 @@
 #ifndef __UNICORE_BITOPS_H__
 #define __UNICORE_BITOPS_H__
 
-#define find_next_bit		__uc32_find_next_bit
-#define find_next_zero_bit	__uc32_find_next_zero_bit
-
-#define find_first_bit		__uc32_find_first_bit
-#define find_first_zero_bit	__uc32_find_first_zero_bit
-
 #define _ASM_GENERIC_BITOPS_FLS_H_
 #define _ASM_GENERIC_BITOPS___FLS_H_
 #define _ASM_GENERIC_BITOPS_FFS_H_
diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index a897080..d98bd81 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -24,8 +24,8 @@
 
 #include "ksyms.h"
 
-EXPORT_SYMBOL(__uc32_find_next_zero_bit);
-EXPORT_SYMBOL(__uc32_find_next_bit);
+EXPORT_SYMBOL(find_next_zero_bit);
+EXPORT_SYMBOL(find_next_bit);
 
 EXPORT_SYMBOL(__backtrace);
 
diff --git a/arch/unicore32/lib/findbit.S b/arch/unicore32/lib/findbit.S
index c360ce9..c777462 100644
--- a/arch/unicore32/lib/findbit.S
+++ b/arch/unicore32/lib/findbit.S
@@ -17,7 +17,7 @@
  * Purpose  : Find a 'zero' bit
  * Prototype: int find_first_zero_bit(void *addr, unsigned int maxbit);
  */
-__uc32_find_first_zero_bit:
+ENTRY(find_first_zero_bit)
 		cxor.a	r1, #0
 		beq	3f
 		mov	r2, #0
@@ -29,13 +29,14 @@ __uc32_find_first_zero_bit:
 		bub	1b
 3:		mov	r0, r1			@ no free bits
 		mov	pc, lr
+ENDPROC(find_first_zero_bit)
 
 /*
  * Purpose  : Find next 'zero' bit
  * Prototype: int find_next_zero_bit
  *		(void *addr, unsigned int maxbit, int offset)
  */
-ENTRY(__uc32_find_next_zero_bit)
+ENTRY(find_next_zero_bit)
 		cxor.a	r1, #0
 		beq	3b
 		and.a	ip, r2, #7
@@ -47,14 +48,14 @@ ENTRY(__uc32_find_next_zero_bit)
 		or	r2, r2, #7		@ if zero, then no bits here
 		add	r2, r2, #1		@ align bit pointer
 		b	2b			@ loop for next bit
-ENDPROC(__uc32_find_next_zero_bit)
+ENDPROC(find_next_zero_bit)
 
 /*
  * Purpose  : Find a 'one' bit
  * Prototype: int find_first_bit
  *		(const unsigned long *addr, unsigned int maxbit);
  */
-__uc32_find_first_bit:
+ENTRY(find_first_bit)
 		cxor.a	r1, #0
 		beq	3f
 		mov	r2, #0
@@ -66,13 +67,14 @@ __uc32_find_first_bit:
 		bub	1b
 3:		mov	r0, r1			@ no free bits
 		mov	pc, lr
+ENDPROC(find_first_bit)
 
 /*
  * Purpose  : Find next 'one' bit
  * Prototype: int find_next_zero_bit
  *		(void *addr, unsigned int maxbit, int offset)
  */
-ENTRY(__uc32_find_next_bit)
+ENTRY(find_next_bit)
 		cxor.a	r1, #0
 		beq	3b
 		and.a	ip, r2, #7
@@ -83,7 +85,7 @@ ENTRY(__uc32_find_next_bit)
 		or	r2, r2, #7		@ if zero, then no bits here
 		add	r2, r2, #1		@ align bit pointer
 		b	2b			@ loop for next bit
-ENDPROC(__uc32_find_next_bit)
+ENDPROC(find_next_bit)
 
 /*
  * One or more bits in the LSB of r3 are assumed to be set.
-- 
1.7.5.4

