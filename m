Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab1FATrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:46 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59160 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759673Ab1FATrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:43 -0400
Message-Id: <20110601180610.913463093@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:08 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-mips@linux-mips.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [patch 12/14] i8253: Move remaining content and delete <asm/i8253.h>
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-sort-remaining-definitions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no really good other place but one line for two out of three
architectures that have a <asm/i8253.h> file doesn't justify this files
existence.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-mips@linux-mips.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

 arch/arm/include/asm/i8253.h  |    4 ----
 arch/mips/include/asm/i8253.h |   10 ----------
 arch/mips/include/asm/time.h  |    5 +++++
 arch/x86/include/asm/i8253.h  |    6 ------
 arch/x86/include/asm/time.h   |    1 +
 include/linux/i8253.h         |    1 -
 6 files changed, 6 insertions(+), 21 deletions(-)

Index: linux-i8253/arch/x86/include/asm/i8253.h
===================================================================
--- linux-i8253.orig/arch/x86/include/asm/i8253.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_X86_I8253_H
-#define _ASM_X86_I8253_H
-
-extern void setup_pit_timer(void);
-
-#endif /* _ASM_X86_I8253_H */
Index: linux-i8253/include/linux/i8253.h
===================================================================
--- linux-i8253.orig/include/linux/i8253.h
+++ linux-i8253/include/linux/i8253.h
@@ -12,7 +12,6 @@
 #include <linux/param.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
-#include <asm/i8253.h>
 
 /* i8253A PIT registers */
 #define PIT_MODE	0x43
Index: linux-i8253/arch/x86/include/asm/time.h
===================================================================
--- linux-i8253.orig/arch/x86/include/asm/time.h
+++ linux-i8253/arch/x86/include/asm/time.h
@@ -6,6 +6,7 @@
 
 extern void hpet_time_init(void);
 extern void time_init(void);
+extern void setup_pit_timer(void);
 
 extern struct clock_event_device *global_clock_event;
 
Index: linux-i8253/arch/mips/include/asm/i8253.h
===================================================================
--- linux-i8253.orig/arch/mips/include/asm/i8253.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/*
- *  Machine specific IO port address definition for generic.
- *  Written by Osamu Tomita <tomita@cinet.co.jp>
- */
-#ifndef __ASM_I8253_H
-#define __ASM_I8253_H
-
-extern void setup_pit_timer(void);
-
-#endif /* __ASM_I8253_H */
Index: linux-i8253/arch/arm/include/asm/i8253.h
===================================================================
--- linux-i8253.orig/arch/arm/include/asm/i8253.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASMARM_I8253_H
-#define __ASMARM_I8253_H
-
-#endif
Index: linux-i8253/arch/mips/include/asm/time.h
===================================================================
--- linux-i8253.orig/arch/mips/include/asm/time.h
+++ linux-i8253/arch/mips/include/asm/time.h
@@ -36,6 +36,11 @@ extern int rtc_mips_set_mmss(unsigned lo
 extern void plat_time_init(void);
 
 /*
+ * Initialize i8253 / i8254 PIT clockevent device.
+ */
+extern void setup_pit_timer(void);
+
+/*
  * mips_hpt_frequency - must be set if you intend to use an R4k-compatible
  * counter as a timer interrupt source.
  */


