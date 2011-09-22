Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1IVJJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:09:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1IVJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:06:29 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 23/55] clocksource: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:50 +0800
Message-Id: <1316681962-8217-24-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/clocksource/cs5535-clockevt.c |    2 +-
 drivers/clocksource/dw_apb_timer.c    |    3 +--
 drivers/clocksource/sh_cmt.c          |    2 +-
 drivers/clocksource/sh_mtu2.c         |    2 +-
 drivers/clocksource/sh_tmu.c          |    2 +-
 drivers/clocksource/tcb_clksrc.c      |    2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index b7dab32..2d3715f 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_TIMER,
 	.name = DRV_NAME,
 };
 
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 580f870..55eb8ad 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -243,8 +243,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->irqaction.dev_id	= &dw_ced->ced;
 	dw_ced->irqaction.irq		= irq;
 	dw_ced->irqaction.flags		= IRQF_TIMER | IRQF_IRQPOLL |
-					  IRQF_NOBALANCING |
-					  IRQF_DISABLED;
+					  IRQF_NOBALANCING;
 
 	dw_ced->eoi = apbt_eoi;
 	err = setup_irq(irq, &dw_ced->irqaction);
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index ca09bc4..3bc55c4 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -641,7 +641,7 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 	p->irqaction.name = dev_name(&p->pdev->dev);
 	p->irqaction.handler = sh_cmt_interrupt;
 	p->irqaction.dev_id = p;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
+	p->irqaction.flags = IRQF_TIMER | \
 			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
 
 	/* get hold of clock */
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index db8d595..0521f03 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -282,7 +282,7 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_mtu2_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
+	p->irqaction.flags = IRQF_TIMER | \
 			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
 
 	/* get hold of clock */
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 079e96a..306d212 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -385,7 +385,7 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_tmu_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
+	p->irqaction.flags = IRQF_TIMER | \
 			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
 
 	/* get hold of clock */
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 79c47e8..1963b93 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -175,7 +175,7 @@ static irqreturn_t ch2_irq(int irq, void *handle)
 
 static struct irqaction tc_irqaction = {
 	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.flags		= IRQF_TIMER,
 	.handler	= ch2_irq,
 };
 
-- 
1.7.4.1

