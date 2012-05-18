Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2ERRNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:47 -0400
Received: from www.tglx.de ([62.245.132.106]:60010 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965839Ab2ERRNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:37 -0400
Message-Id: <20120518163104.630579708@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:44 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [patch 02/24] x86: Use generic time config
References: <20120518163020.548627576@glx-um.de>
Content-Disposition: inline; filename=x86-use-generic-time-config.patch
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: x86@kernel.org
---
 arch/x86/Kconfig |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -82,6 +82,13 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS
+	select GENERIC_CMOS_UPDATE
+	select CLOCKSOURCE_WATCHDOG
+	select GENERIC_CLOCKEVENTS
+	select ARCH_CLOCKSOURCE_DATA if X86_64
+	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
+	select GENERIC_TIME_VSYSCALL if X86_64
+	select KTIME_SCALAR if X86_32
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -96,23 +103,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config ARCH_CLOCKSOURCE_DATA
-	def_bool y
-	depends on X86_64
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	def_bool y
-	depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
-
 config LOCKDEP_SUPPORT
 	def_bool y
 
@@ -166,10 +156,6 @@ config ARCH_HAS_CPU_IDLE_WAIT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	bool
-	default X86_64
-
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
@@ -236,9 +222,6 @@ config ARCH_HWEIGHT_CFLAGS
 	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
 	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
 
-config KTIME_SCALAR
-	def_bool X86_32
-
 config ARCH_CPU_PROBE_RELEASE
 	def_bool y
 	depends on HOTPLUG_CPU


