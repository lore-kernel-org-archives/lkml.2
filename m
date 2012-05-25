Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab2EYWLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:11:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47842 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2EYWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:51 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH 05/20] hexagon: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:21 +0200
Message-Id: <1337983476-22081-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/hexagon/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index 434866e..8403bfd 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 #include <asm/registers.h>
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
@@ -267,6 +268,8 @@ no_restart:
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
+	local_irq_enable();
+
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-- 
1.7.7.3

