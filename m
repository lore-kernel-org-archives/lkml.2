Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173Ab2EYWGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:06:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47857 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934105Ab2EYWFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:05:07 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH 17/20] hexagon: Do not call try_to_freeze() in do_signal()
Date: Sat, 26 May 2012 00:04:33 +0200
Message-Id: <1337983476-22081-17-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1337983476-22081-1-git-send-email-richard@nod.at>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_signal_to_deliver() already calls try_to_freeze(), there is no
need to call it directly.

Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/hexagon/kernel/signal.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index 8403bfd..9783cfa 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -20,7 +20,6 @@
 
 #include <linux/linkage.h>
 #include <linux/syscalls.h>
-#include <linux/freezer.h>
 #include <linux/tracehook.h>
 #include <linux/irqflags.h>
 #include <asm/registers.h>
@@ -210,9 +209,6 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	if (try_to_freeze())
-		goto no_signal;
-
 	signo = get_signal_to_deliver(&info, &sigact, regs, NULL);
 
 	if (signo > 0) {
@@ -237,7 +233,6 @@ static void do_signal(struct pt_regs *regs)
 		return;
 	}
 
-no_signal:
 	/*
 	 * If we came from a system call, handle the restart.
 	 */
-- 
1.7.7.3

