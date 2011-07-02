Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1GBJ7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:59:23 -0400
Received: from mail.southpole.se ([193.12.106.18]:53330 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1GBJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:59:20 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, lethal@linux-sh.org,
        Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 2/2] asm-generic: move archictures to common delay.h
Date: Sat,  2 Jul 2011 11:59:14 +0200
Message-Id: <1309600754-21217-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309600754-21217-1-git-send-email-jonas@southpole.se>
References: <1309600754-21217-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch moves the in-tree architectures that were using the 'generic'
delay.h over to using the header file in asm-generic.

This is not done using the generic-y mechanism as none of these arch's
have started using that mechanism yet.  This is a trivial change to make
later when the arch begins using generic-y.

Note the subtle change to the avr32 and SH architectures where the argument
to __const_udelay was previously using the rounded down constant value
instead of the rounded up value.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/avr32/include/asm/delay.h |   27 +--------------------------
 arch/m32r/include/asm/delay.h  |   27 +--------------------------
 arch/sh/include/asm/delay.h    |   27 +--------------------------
 arch/x86/include/asm/delay.h   |   25 +------------------------
 4 files changed, 4 insertions(+), 102 deletions(-)

diff --git a/arch/avr32/include/asm/delay.h b/arch/avr32/include/asm/delay.h
index a0ed9a9..9670e12 100644
--- a/arch/avr32/include/asm/delay.h
+++ b/arch/avr32/include/asm/delay.h
@@ -1,26 +1 @@
-#ifndef __ASM_AVR32_DELAY_H
-#define __ASM_AVR32_DELAY_H
-
-/*
- * Copyright (C) 1993 Linus Torvalds
- *
- * Delay routines calling functions in arch/avr32/lib/delay.c
- */
-
-extern void __bad_udelay(void);
-extern void __bad_ndelay(void);
-
-extern void __udelay(unsigned long usecs);
-extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long xloops);
-extern void __delay(unsigned long loops);
-
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c6ul)) : \
-	__udelay(n))
-
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
-
-#endif /* __ASM_AVR32_DELAY_H */
+#include <asm-generic/delay.h>
diff --git a/arch/m32r/include/asm/delay.h b/arch/m32r/include/asm/delay.h
index 9dd9e99..9670e12 100644
--- a/arch/m32r/include/asm/delay.h
+++ b/arch/m32r/include/asm/delay.h
@@ -1,26 +1 @@
-#ifndef _ASM_M32R_DELAY_H
-#define _ASM_M32R_DELAY_H
-
-/*
- * Copyright (C) 1993 Linus Torvalds
- *
- * Delay routines calling functions in arch/m32r/lib/delay.c
- */
-
-extern void __bad_udelay(void);
-extern void __bad_ndelay(void);
-
-extern void __udelay(unsigned long usecs);
-extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long xloops);
-extern void __delay(unsigned long loops);
-
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
-	__udelay(n))
-
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
-
-#endif /* _ASM_M32R_DELAY_H */
+#include <asm-generic/delay.h>
diff --git a/arch/sh/include/asm/delay.h b/arch/sh/include/asm/delay.h
index 4b16bf9..9670e12 100644
--- a/arch/sh/include/asm/delay.h
+++ b/arch/sh/include/asm/delay.h
@@ -1,26 +1 @@
-#ifndef __ASM_SH_DELAY_H
-#define __ASM_SH_DELAY_H
-
-/*
- * Copyright (C) 1993 Linus Torvalds
- *
- * Delay routines calling functions in arch/sh/lib/delay.c
- */
-
-extern void __bad_udelay(void);
-extern void __bad_ndelay(void);
-
-extern void __udelay(unsigned long usecs);
-extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long xloops);
-extern void __delay(unsigned long loops);
-
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c6ul)) : \
-	__udelay(n))
-
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
-
-#endif /* __ASM_SH_DELAY_H */
+#include <asm-generic/delay.h>
diff --git a/arch/x86/include/asm/delay.h b/arch/x86/include/asm/delay.h
index 409a649..9b3b4f2 100644
--- a/arch/x86/include/asm/delay.h
+++ b/arch/x86/include/asm/delay.h
@@ -1,30 +1,7 @@
 #ifndef _ASM_X86_DELAY_H
 #define _ASM_X86_DELAY_H
 
-/*
- * Copyright (C) 1993 Linus Torvalds
- *
- * Delay routines calling functions in arch/x86/lib/delay.c
- */
-
-/* Undefined functions to get compile-time errors */
-extern void __bad_udelay(void);
-extern void __bad_ndelay(void);
-
-extern void __udelay(unsigned long usecs);
-extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long xloops);
-extern void __delay(unsigned long loops);
-
-/* 0x10c7 is 2**32 / 1000000 (rounded up) */
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
-	__udelay(n))
-
-/* 0x5 is 2**32 / 1000000000 (rounded up) */
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
+#include <asm-generic/delay.h>
 
 void use_tsc_delay(void);
 
-- 
1.7.4.1

