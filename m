Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1GBDqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:46:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1GBDpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:15 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dbfm8pASyCkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=WPyIoOwQAAAA:8 a=meVymXHHAAAA:8 a=xyLcrhHpmspGRm4AOFsA:9 a=ymcg898n2rhFRdeYOikA:7 a=jEp0ucaQiEUA:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033853.795022400@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 06/11] mips/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0006-mips-irqs-Do-not-trace-arch_local_-irq_-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
Although they are marked inline, gcc may still make a function out of
them and add it to the pool of functions that are traced by the function
tracer. This can cause undesirable results (kernel panic, triple faults,
etc).

Add the notrace notation to prevent them from ever being traced.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/include/asm/irqflags.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/irqflags.h b/arch/mips/include/asm/irqflags.h
index 309cbcd..299d75d 100644
--- a/arch/mips/include/asm/irqflags.h
+++ b/arch/mips/include/asm/irqflags.h
@@ -40,7 +40,7 @@ __asm__(
 
 extern void smtc_ipi_replay(void);
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 #ifdef CONFIG_MIPS_MT_SMTC
 	/*
@@ -97,7 +97,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	__asm__ __volatile__(
 		"arch_local_irq_disable"
@@ -118,7 +118,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 	asm volatile("arch_local_save_flags %0" : "=r" (flags));
@@ -150,7 +150,7 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 	asm volatile("arch_local_irq_save\t%0"
@@ -201,7 +201,7 @@ __asm__(
 	"	.endm							\n");
 
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
@@ -222,7 +222,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
 		: "memory");
 }
 
-static inline void __arch_local_irq_restore(unsigned long flags)
+static inline notrace void __arch_local_irq_restore(unsigned long flags)
 {
 	unsigned long __tmp1;
 
@@ -233,7 +233,7 @@ static inline void __arch_local_irq_restore(unsigned long flags)
 		: "memory");
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
+static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
 {
 #ifdef CONFIG_MIPS_MT_SMTC
 	/*
-- 
1.7.5.4



