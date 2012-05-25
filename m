Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2EYWHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:07:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47851 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934087Ab2EYWFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:05:05 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 14/20] blackfin: Do not call try_to_freeze() in do_signal()
Date: Sat, 26 May 2012 00:04:30 +0200
Message-Id: <1337983476-22081-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() already calls try_to_freeze(), there is no
need to call it directly.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/blackfin/kernel/signal.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index e5bbc1a..cea3873 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -10,7 +10,6 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
-#include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 
@@ -285,9 +284,6 @@ asmlinkage void do_signal(struct pt_regs *regs)
 
 	current->thread.esp0 = (unsigned long)regs;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
 	else
@@ -311,7 +307,6 @@ asmlinkage void do_signal(struct pt_regs *regs)
 		return;
 	}
 
- no_signal:
 	/* Did we come from a system call? */
 	if (regs->orig_p0 >= 0)
 		/* Restart the system call - no handlers present */
-- 
1.7.7.3

