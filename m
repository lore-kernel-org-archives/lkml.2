Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2EYWEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:04:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab2EYWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:50 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 04/20] h8300: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:20 +0200
Message-Id: <1337983476-22081-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/h8300/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index d4b0555..b3e03a7 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -40,6 +40,7 @@
 #include <linux/binfmts.h>
 #include <linux/freezer.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
@@ -507,6 +508,8 @@ statis void do_signal(struct pt_regs *regs)
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 {
+	local_irq_enable();
+
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-- 
1.7.7.3

