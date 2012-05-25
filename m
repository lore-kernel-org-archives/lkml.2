Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab2EYWFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:05:02 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551Ab2EYWE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:59 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net
Subject: [PATCH 08/20] openrisc: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:24 +0200
Message-Id: <1337983476-22081-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index e970743..f2ae7ac 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -26,6 +26,7 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -370,6 +371,8 @@ void do_signal(struct pt_regs *regs)
 
 asmlinkage void do_notify_resume(struct pt_regs *regs)
 {
+	local_irq_enable();
+
 	if (current_thread_info()->flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-- 
1.7.7.3

