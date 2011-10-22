Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1JVKGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:06:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1JVKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:06:51 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 19/49] unicore32: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:31 +0800
Message-Id: <1319277421-9203-20-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
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
 arch/unicore32/kernel/puv3-nb0916.c |    4 ++--
 arch/unicore32/kernel/time.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/kernel/puv3-nb0916.c b/arch/unicore32/kernel/puv3-nb0916.c
index e731c56..951826a 100644
--- a/arch/unicore32/kernel/puv3-nb0916.c
+++ b/arch/unicore32/kernel/puv3-nb0916.c
@@ -124,7 +124,7 @@ int __init mach_nb0916_init(void)
 
 	if (request_irq(gpio_to_irq(GPI_LCD_CASE_OFF),
 		&nb0916_lcdcaseoff_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		"NB0916 lcd case off", NULL) < 0) {
 
 		printk(KERN_DEBUG "LCD-Case-OFF IRQ %d not available\n",
@@ -132,7 +132,7 @@ int __init mach_nb0916_init(void)
 	}
 
 	if (request_irq(gpio_to_irq(GPI_OTP_INT), &nb0916_overheat_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		"NB0916 overheating protection", NULL) < 0) {
 
 		printk(KERN_DEBUG "Overheating Protection IRQ %d not available\n",
diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
index 080710c..d3824b2 100644
--- a/arch/unicore32/kernel/time.c
+++ b/arch/unicore32/kernel/time.c
@@ -86,7 +86,7 @@ static struct clocksource cksrc_puv3_oscr = {
 
 static struct irqaction puv3_timer_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= puv3_ost0_interrupt,
 	.dev_id		= &ckevt_puv3_osmr0,
 };
-- 
1.7.1

