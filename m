Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2EYWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:04:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab2EYWEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:46 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/20] arm: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:17 +0200
Message-Id: <1337983476-22081-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 4e5fdd9..434a1f3 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -722,6 +723,8 @@ static void do_signal(struct pt_regs *regs, int syscall)
 asmlinkage void
 do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 {
+	local_irq_enable();
+
 	if (thread_flags & _TIF_SIGPENDING)
 		do_signal(regs, syscall);
 
-- 
1.7.7.3

