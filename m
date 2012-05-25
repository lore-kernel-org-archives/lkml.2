Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab2EYWGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:06:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47862 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab2EYWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:05:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 20/20] xtensa: Do not call try_to_freeze() in do_signal()
Date: Sat, 26 May 2012 00:04:36 +0200
Message-Id: <1337983476-22081-20-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() already calls try_to_freeze(), there is no
need to call it directly.

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/xtensa/kernel/signal.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index c5e4ec0..f14ef4e 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/personality.h>
-#include <linux/freezer.h>
 #include <linux/tracehook.h>
 
 #include <asm/ucontext.h>
@@ -454,9 +453,6 @@ static void do_signal(struct pt_regs *regs)
 	struct k_sigaction ka;
 	sigset_t oldset;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
 	else
@@ -513,7 +509,6 @@ static void do_signal(struct pt_regs *regs)
 		return;
 	}
 
-no_signal:
 	/* Did we come from a system call? */
 	if ((signed) regs->syscall >= 0) {
 		/* Restart the system call - no handlers present */
-- 
1.7.7.3

