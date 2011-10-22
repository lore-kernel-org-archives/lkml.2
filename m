Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1JVKHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:07:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1JVKHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:07:46 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 22/49] score: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:34 +0800
Message-Id: <1319277421-9203-23-git-send-email-yong.zhang0@gmail.com>
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
 arch/score/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
index f0a43af..24770cd 100644
--- a/arch/score/kernel/time.c
+++ b/arch/score/kernel/time.c
@@ -41,7 +41,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction timer_irq = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "timer",
 };
 
-- 
1.7.1

