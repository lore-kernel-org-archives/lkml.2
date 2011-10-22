Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1JVJ7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:59:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43353 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1JVJ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:59:29 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 04/49] avr32: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:16 +0800
Message-Id: <1319277421-9203-5-git-send-email-yong.zhang0@gmail.com>
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
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 05ad291..cfc9778 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -58,7 +58,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
 	/* Oprofile uses the same irq as the timer, so allow it to be shared */
-	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
+	.flags		= IRQF_TIMER | IRQF_SHARED,
 	.name		= "avr32_comparator",
 };
 
-- 
1.7.1

