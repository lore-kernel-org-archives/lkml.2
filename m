Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1CYN0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:26:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:34627 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257Ab1CYNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:00 -0400
Message-Id: <20110325132048.130150757@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 08/23] arm: stmp3xxx: Use generic_handle_irq()
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-stmp3.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-stmp3xxx/pinmux.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-stmp3xxx/pinmux.c
+++ linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
@@ -495,8 +495,7 @@ static void stmp3xxx_gpio_irq(u32 irq, s
 
 	while (stat) {
 		if (stat & 1)
-			irq_desc[gpio_irq].handle_irq(gpio_irq,
-				&irq_desc[gpio_irq]);
+			generic_handle_irq(gpio_irq);
 		gpio_irq++;
 		stat >>= 1;
 	}


