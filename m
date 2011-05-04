Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1EDIPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:15:21 -0400
Received: from mx9.orcon.net.nz ([219.88.242.59]:42420 "EHLO mx9.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab1EDIPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:15:19 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH] alpha: Wire up syscalls new to 2.6.39
Date: Wed,  4 May 2011 20:14:50 +1200
Message-Id: <1304496890-7725-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
X-DSPAM-Check: by mx9.orcon.net.nz on Wed, 04 May 2011 20:15:17 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed May  4 20:15:17 2011
X-DSPAM-Confidence: 0.7010
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up the syscalls:
   name_to_handle_at
   open_by_handle_at
   clock_adjtime
   syncfs
and adjust some whitespace in the neighbourhood to align commments.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/unistd.h |    6 +++++-
 arch/alpha/kernel/systbls.S     |   14 +++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 058937b..b183416 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -452,10 +452,14 @@
 #define __NR_fanotify_init		494
 #define __NR_fanotify_mark		495
 #define __NR_prlimit64			496
+#define __NR_name_to_handle_at		497
+#define __NR_open_by_handle_at		498
+#define __NR_clock_adjtime		499
+#define __NR_syncfs			500
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			497
+#define NR_SYSCALLS			501
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index a6a1de9..c77a8fc 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -498,24 +498,28 @@ sys_call_table:
 	.quad sys_ni_syscall			/* sys_timerfd */
 	.quad sys_eventfd
 	.quad sys_recvmmsg
-	.quad sys_fallocate				/* 480 */
+	.quad sys_fallocate			/* 480 */
 	.quad sys_timerfd_create
 	.quad sys_timerfd_settime
 	.quad sys_timerfd_gettime
 	.quad sys_signalfd4
-	.quad sys_eventfd2				/* 485 */
+	.quad sys_eventfd2			/* 485 */
 	.quad sys_epoll_create1
 	.quad sys_dup3
 	.quad sys_pipe2
 	.quad sys_inotify_init1
-	.quad sys_preadv				/* 490 */
+	.quad sys_preadv			/* 490 */
 	.quad sys_pwritev
 	.quad sys_rt_tgsigqueueinfo
 	.quad sys_perf_event_open
 	.quad sys_fanotify_init
-	.quad sys_fanotify_mark				/* 495 */
+	.quad sys_fanotify_mark			/* 495 */
 	.quad sys_prlimit64
-
+	.quad sys_name_to_handle_at
+	.quad sys_open_by_handle_at
+	.quad sys_clock_adjtime
+	.quad sys_syncfs			/* 500 */
+	
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
 
-- 
1.7.4.3

