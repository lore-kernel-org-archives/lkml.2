Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BFQar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:30:47 -0500
Received: from www.tglx.de ([62.245.132.106]:41511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab1BFQaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:30:46 -0500
Message-Id: <20110206163009.289833604@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 16:30:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [patch 4/4] avr32: Use generic IRQ config,
	enable GENERIC_HARDIRQS_NO_DEPRECATED
References: <20110206162900.250401028@linutronix.de>
Content-Disposition: inline; filename=avr32-enable-no-depr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic Kconfig for interrupts and enable
GENERIC_HARDIRQS_NO_DEPRECATED. All conversions done.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/Kconfig |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-next/arch/avr32/Kconfig
===================================================================
--- linux-next.orig/arch/avr32/Kconfig
+++ linux-next/arch/avr32/Kconfig
@@ -6,6 +6,10 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_PROBE
+	select HARDIRQS_SW_RESEND
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -17,9 +21,6 @@ config AVR32
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -29,12 +30,6 @@ config LOCKDEP_SUPPORT
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
-config HARDIRQS_SW_RESEND
-	def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 


