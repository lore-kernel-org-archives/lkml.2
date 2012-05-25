Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab2EYWG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:06:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47855 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab2EYWFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:05:06 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 16/20] h8300: Do not call try_to_freeze() in do_signal()
Date: Sat, 26 May 2012 00:04:32 +0200
Message-Id: <1337983476-22081-16-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() already calls try_to_freeze(), there is no
need to call it directly.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/h8300/kernel/signal.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index b3e03a7..35036e5 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -38,7 +38,6 @@
 #include <linux/personality.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
-#include <linux/freezer.h>
 #include <linux/tracehook.h>
 #include <linux/irqflags.h>
 
@@ -469,9 +468,6 @@ statis void do_signal(struct pt_regs *regs)
 	if ((regs->ccr & 0x10))
 		return;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	current->thread.esp0 = (unsigned long) regs;
 
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
@@ -485,7 +481,7 @@ statis void do_signal(struct pt_regs *regs)
 		handle_signal(signr, &info, &ka, oldset, regs);
 		return;
 	}
- no_signal:
+
 	/* Did we come from a system call? */
 	if (regs->orig_er0 >= 0) {
 		/* Restart the system call - no handlers present */
-- 
1.7.7.3

