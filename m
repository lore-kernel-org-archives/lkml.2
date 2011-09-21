Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1IUJaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:30:23 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1IUJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:30:18 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 07/57] h8300: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:08 +0800
Message-Id: <1316597339-29861-8-git-send-email-yong.zhang0@gmail.com>
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
 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index a2ae5e9..21afa64 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index ae0d381..3864531 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -54,7 +54,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initdata divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 7a1533f..13617fb 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -74,7 +74,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initdata divide_rate[] = {8, 64, 8192};
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index 2193a2e..aa5707e 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -63,7 +63,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initdata divide_rate[] = {
-- 
1.7.4.1

