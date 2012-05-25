Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab2EYWFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:05:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47847 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751Ab2EYWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:58 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 07/20] mn10300: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:23 +0200
Message-Id: <1337983476-22081-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mn10300/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 890cf91..4a6c212 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/personality.h>
 #include <linux/suspend.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -537,6 +538,8 @@ static void do_signal(struct pt_regs *regs)
  */
 asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 {
+	local_irq_enable();
+
 	/* Pending single-step? */
 	if (thread_info_flags & _TIF_SINGLESTEP) {
 #ifndef CONFIG_MN10300_USING_JTAG
-- 
1.7.7.3

