Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2EUJ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:27:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2EUJ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:27:33 -0400
Date: Mon, 21 May 2012 02:27:04 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-bdebaf80a02b854381fe212e0dac13c8c8edac57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163104.630579708@glx-um.de>
References: <20120518163104.630579708@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: Use generic time config
Git-Commit-ID: bdebaf80a02b854381fe212e0dac13c8c8edac57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:27:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdebaf80a02b854381fe212e0dac13c8c8edac57
Gitweb:     http://git.kernel.org/tip/bdebaf80a02b854381fe212e0dac13c8c8edac57
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 18 May 2012 16:45:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

x86: Use generic time config

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Link: http://lkml.kernel.org/r/20120518163104.630579708@glx-um.de
Cc: x86@kernel.org
---
 arch/x86/Kconfig |   31 +++++++------------------------
 1 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9866b0..3b0a921 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
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
