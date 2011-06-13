Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1FMI50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:57:26 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:42033 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1FMI5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:57:20 -0400
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
In-Reply-To: <BANLkTi=aVFisCuS-W-4iNSmDVCtKOWD5_w@mail.gmail.com>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
	 <BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
	 <BANLkTimWYjzxhQBH2A76D590KBfjKbguTA@mail.gmail.com>
	 <1307675815.1537.9.camel@epip-laptop>
	 <BANLkTi=aVFisCuS-W-4iNSmDVCtKOWD5_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 13 Jun 2011 16:57:02 +0800
Message-ID: <1307955422.1878.3.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 13:22 +0900, Akinobu Mita wrote:
> 2011/6/10 Guan Xuetao <gxt@mprc.pku.edu.cn>:
> > On Thu, 2011-06-09 at 23:05 +0900, Akinobu Mita wrote:
> >> 2011/6/9 Akinobu Mita <akinobu.mita@gmail.com>:
> >> > 2011/6/9 GuanXuetao <gxt@mprc.pku.edu.cn>:
> >> >> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >> >>
> >> >> Remove the __uc32_ prefix in find bitops functions.
> >> >> see commit <19de85ef574c3a2182e3ccad9581805052f14946>
> >> >>  bitops: add #ifndef for each of find bitops
> >> >>
> >> >> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >> >> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> >> >> ---
> >> >>  arch/unicore32/include/asm/bitops.h |    6 ------
> >> >>  arch/unicore32/kernel/ksyms.c       |    4 ++--
> >> >>  arch/unicore32/lib/findbit.S        |   14 ++++++++------
> >> >>  3 files changed, 10 insertions(+), 14 deletions(-)
> >> >>
> >> >> diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/include/asm/bitops.h
> >> >> index 1628a63..a9653f0 100644
> >> >> --- a/arch/unicore32/include/asm/bitops.h
> >> >> +++ b/arch/unicore32/include/asm/bitops.h
> >> >> @@ -13,12 +13,6 @@
> >> >>  #ifndef __UNICORE_BITOPS_H__
> >> >>  #define __UNICORE_BITOPS_H__
> >> >>
> >> >> -#define find_next_bit          __uc32_find_next_bit
> >> >> -#define find_next_zero_bit     __uc32_find_next_zero_bit
> >> >> -
> >> >> -#define find_first_bit         __uc32_find_first_bit
> >> >> -#define find_first_zero_bit    __uc32_find_first_zero_bit
> >> >> -
> >> >
> >> > Is this patch really fix the build error?
> >> >
> >> > If these find_*_bit macros are removed, vmlinux will have multiple
> >> > definisions of find_*_bit. Because lib/find_next_bit.c is built
> >> > unconditionally after the commit 63e424c84429903c92a0f1e9654c31ccaf6694d0
> >> > ("arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}".
> >>
> >> The attached patch hopefully fix the build error but it is untested
> >> because I can't find crosstool for unicore32. So could you apply
> >> this patch on top of your patch and check whether it fixes?
> >
> > Thanks Akinobu.
> > I want to avoid the duplication of the 'extern' function definitions in
> > asm-generic header and arch-specific header.
> 
> OK then adding the following four lines after asm-generic/bitops.h
> inclusion should fix the problem.
> 
> #define find_next_bit find_next_bit
> #define find_next_zero_bit find_next_zero_bit
> #define find_first_bit find_first_bit
> #define find_first_zero_bit find_first_zero_bit

Thanks, please review following patch:
>From 660882536a3c7c77e0f8d817dabcbbecab20367d Mon Sep 17 00:00:00 2001
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Date: Mon, 13 Jun 2011 11:44:49 +0800
Subject: [PATCH] unicore32: fix build error for find bitops

Remove the __uc32_ prefix in find bitops functions.
Move find_* macros behind asm-generic/bitops.h inclusion.
see commit <19de85ef574c3a2182e3ccad9581805052f14946>
  bitops: add #ifndef for each of find bitops
also see commit <63e424c84429903c92a0f1e9654c31ccaf6694d0>
  arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/unicore32/include/asm/bitops.h |   12 ++++++------
 arch/unicore32/kernel/ksyms.c       |    4 ++--
 arch/unicore32/lib/findbit.S        |   14 ++++++++------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/unicore32/include/asm/bitops.h
b/arch/unicore32/include/asm/bitops.h
index 1628a63..401f597 100644
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
@@ -44,4 +38,10 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops.h>
 
+/* following definitions: to avoid using codes in lib/find_*.c */
+#define find_next_bit		find_next_bit
+#define find_next_zero_bit	find_next_zero_bit
+#define find_first_bit		find_first_bit
+#define find_first_zero_bit	find_first_zero_bit
+
 #endif /* __UNICORE_BITOPS_H__ */
diff --git a/arch/unicore32/kernel/ksyms.c
b/arch/unicore32/kernel/ksyms.c
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
1.6.2.2



