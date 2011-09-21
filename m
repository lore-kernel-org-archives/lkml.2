Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1IUJg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:36:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44302 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1IUJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:36:54 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Richard Kuo <rkuo@codeaurora.org>,
        Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-hexagon@vger.kernel.org
Subject: [PATCH 55/57] hexagon: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:56 +0800
Message-Id: <1316597339-29861-56-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/hexagon/kernel/smp.c  |    2 +-
 arch/hexagon/kernel/time.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 96bf6c2..ad43649 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -136,7 +136,7 @@ void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
 
 static struct irqaction ipi_intdesc = {
 	.handler = handle_ipi,
-	.flags = IRQF_DISABLED | IRQF_TRIGGER_RISING,
+	.flags = IRQF_TRIGGER_RISING,
 	.name = "ipi_handler"
 };
 
diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index fc8e95c..a4d7b58 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -181,7 +181,7 @@ static irqreturn_t timer_interrupt(int irq, void *devid)
 /*  This should also be pulled from devtree  */
 static struct irqaction rtos_timer_intdesc = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
+	.flags = IRQF_TIMER | IRQF_TRIGGER_RISING,
 	.name = "rtos_timer"
 };
 
-- 
1.7.4.1

