Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1IUJf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:35:26 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1IUJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:35:20 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Anton Vorontsov <cbouatmailru@gmail.com>, Tejun Heo <tj@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>, Axel Lin <axel.lin@gmail.com>
Subject: [PATCH 44/57] power_supply:irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:45 +0800
Message-Id: <1316597339-29861-45-git-send-email-yong.zhang0@gmail.com>
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
 drivers/power/wm97xx_battery.c |    2 +-
 drivers/power/z2_battery.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 156559e..cf8681c 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -196,7 +196,7 @@ static int __devinit wm97xx_bat_probe(struct platform_device *dev)
 		if (ret)
 			goto err2;
 		ret = request_irq(gpio_to_irq(pdata->charge_gpio),
-				wm97xx_chrg_irq, IRQF_DISABLED,
+				wm97xx_chrg_irq, 0,
 				"AC Detect", dev);
 		if (ret)
 			goto err2;
diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index ae38c44..636ebb2 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -218,7 +218,7 @@ static int __devinit z2_batt_probe(struct i2c_client *client,
 		irq_set_irq_type(gpio_to_irq(info->charge_gpio),
 				 IRQ_TYPE_EDGE_BOTH);
 		ret = request_irq(gpio_to_irq(info->charge_gpio),
-				z2_charge_switch_irq, IRQF_DISABLED,
+				z2_charge_switch_irq, 0,
 				"AC Detect", charger);
 		if (ret)
 			goto err3;
-- 
1.7.4.1

