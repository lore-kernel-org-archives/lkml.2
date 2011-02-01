Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1BANyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:54:06 -0500
Received: from www.tglx.de ([62.245.132.106]:47399 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab1BANwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:43 -0500
Message-Id: <20110201134419.968905083@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 26/28] posix_clocks: Add clock_adjtime for x86
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix_clocks-add-clock_adjtime-for-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the clock_adjtime system call to the x86 architecture.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <john.stultz@linaro.org>
LKML-Reference: <4501cddb99d555624baade4609030ca458dfa3a0.1296124770.git.richard.cochran@omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/ia32/ia32entry.S
+++ linux-2.6-tip/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,5 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad compat_sys_clock_adjtime
 ia32_syscall_end:
Index: linux-2.6-tip/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/unistd_32.h
+++ linux-2.6-tip/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_clock_adjtime	341
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 342
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6-tip/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/unistd_64.h
+++ linux-2.6-tip/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_fanotify_init, sys_fanoti
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_clock_adjtime			303
+__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/syscall_table_32.S
+++ linux-2.6-tip/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_clock_adjtime


