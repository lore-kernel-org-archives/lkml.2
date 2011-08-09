Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1HIQhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:37:21 -0400
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:43241 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab1HIQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8lAHpfQU5UXebj/2dsb2JhbABCgh2CbJJmNY8ad4FuUnE1GBOHb61zAodTiS0OhjgEmA6DLoE4hnw
Subject: [PATCH] mfd: asic3: Make asic3_clk_enable() a void function
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <philipp.zabel@gmail.com>, <sameo@linux.intel.com>, <mad_soft@inbox.ru>,
        <koen@dominion.thruhere.net>
Date: Tue, 09 Aug 2011 16:27:43 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.39 x86_64 [http://email.cleancode.org])
Message-Id: <E1Qqp9d-00012N-Dm@outmx01.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of asic3_clk_enable() was neither used nor useful. So let's
make it a void function, and thereby match asic3_clk_disable().

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---

diff -uprN clean-3.0.1/drivers/mfd/asic3.c linux-3.0.1/drivers/mfd/asic3.c
--- clean-3.0.1/drivers/mfd/asic3.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1/drivers/mfd/asic3.c	2011-08-08 11:18:38.853875362 +0100
@@ -584,7 +584,7 @@ static int asic3_gpio_remove(struct plat
 	return gpiochip_remove(&asic->gpio);
 }
 
-static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
+static void asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
 {
 	unsigned long flags;
 	u32 cdex;
@@ -596,8 +596,6 @@ static int asic3_clk_enable(struct asic3
 		asic3_write_register(asic, ASIC3_OFFSET(CLOCK, CDEX), cdex);
 	}
 	spin_unlock_irqrestore(&asic->lock, flags);
-
-	return 0;
 }
 
 static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)

