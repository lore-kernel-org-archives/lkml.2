Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1IUJaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:30:39 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:49741 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1IUJaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:30:35 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Hirokazu Takata <takata@linux-m32r.org>, Torben Hohn <torbenh@gmx.de>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org
Subject: [PATCH 09/57] m32r: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:10 +0800
Message-Id: <1316597339-29861-10-git-send-email-yong.zhang0@gmail.com>
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
 arch/m32r/kernel/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 84dd040..b3b5b32 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -134,7 +134,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "MFT2",
 };
 
-- 
1.7.4.1

