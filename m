Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2EYWE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:04:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47845 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab2EYWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:55 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
Subject: [PATCH 06/20] m32r: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:22 +0200
Message-Id: <1337983476-22081-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m32r/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index f54d969..0521e19 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/personality.h>
 #include <linux/freezer.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -372,6 +373,8 @@ static void do_signal(struct pt_regs *regs)
  */
 void do_notify_resume(struct pt_regs *regs, __u32 thread_info_flags)
 {
+	local_irq_enable();
+
 	/* Pending single-step? */
 	if (thread_info_flags & _TIF_SINGLESTEP)
 		clear_thread_flag(TIF_SINGLESTEP);
-- 
1.7.7.3

