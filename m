Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0EJSDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:03:01 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37098 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab0EJSB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 11/11] unistd: add __NR_prlimit64 syscall numbers
Date: Mon, 10 May 2010 20:00:51 +0200
Message-Id: <1273514451-28894-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __NR_prlimit64 syscall numbers to asm-generic. Add them also to
asm-x86, both 32 and 64-bit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/asm-generic/unistd.h       |    4 +++-
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 17cf65c..b9472ec 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -844,4 +844,5 @@ ia32_sys_call_table:
 	.quad compat_sys_recvmmsg
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
+	.quad sys_prlimit64			/* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 80b799c..b766a5e 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,10 +345,11 @@
 #define __NR_recvmmsg		337
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
+#define __NR_prlimit64		340
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 340
+#define NR_syscalls 341
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 5b7b1d5..363e9b8 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -667,6 +667,8 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark			301
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_prlimit64				302
+__SYSCALL(__NR_prlimit64, sys_prlimit64)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 07ad5eb..b35786d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -339,3 +339,4 @@ ENTRY(sys_call_table)
 	.long sys_recvmmsg
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
+	.long sys_prlimit64		/* 340 */
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 6a0b30f..0dfd517 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -626,9 +626,11 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 __SYSCALL(__NR_accept4, sys_accept4)
 #define __NR_recvmmsg 243
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_prlimit64 244
+__SYSCALL(__NR_prlimit64, sys_prlimit64)
 
 #undef __NR_syscalls
-#define __NR_syscalls 244
+#define __NR_syscalls 245
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.1


