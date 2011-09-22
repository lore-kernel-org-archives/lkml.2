Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1IVJDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:03:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43591 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1IVJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:02:59 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com, Chris Zankel <chris@zankel.net>,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 22/55] xtensa: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:49 +0800
Message-Id: <1316681962-8217-23-git-send-email-yong.zhang0@gmail.com>
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
 arch/xtensa/kernel/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index f3e5eb4..2370229 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -54,7 +54,6 @@ static struct clocksource ccount_clocksource = {
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
 	.name =		"timer",
 };
 
-- 
1.7.4.1

