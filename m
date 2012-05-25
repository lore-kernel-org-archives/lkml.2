Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2EYWLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:11:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab2EYWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:04:48 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 03/20] cris: Do not call do_signal() with irqs disabled
Date: Sat, 26 May 2012 00:04:19 +0200
Message-Id: <1337983476-22081-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() calls try_to_freeze() which might sleep.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/cris/kernel/ptrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index d114ad3..da1b647 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -17,6 +17,7 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/tracehook.h>
+#include <linux/irqflags.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -33,6 +34,8 @@ extern int do_signal(int canrestart, struct pt_regs *regs);
 void do_notify_resume(int canrestart, struct pt_regs *regs,
 		      __u32 thread_info_flags)
 {
+	local_irq_enable();
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(canrestart,regs);
-- 
1.7.7.3

