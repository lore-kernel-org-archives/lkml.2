Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1GDKEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:04:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35307 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1GDKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:04:23 -0400
Subject: [PATCH] power: gpio-charger: Fix checking return value of
 request_any_context_irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 18:04:15 +0800
Message-ID: <1309773855.2267.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_any_context_irq() returns a negative value on failure.
On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/gpio-charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 718f2c5..a64b885 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -127,7 +127,7 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 		ret = request_any_context_irq(irq, gpio_charger_irq,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				dev_name(&pdev->dev), charger);
-		if (ret)
+		if (ret < 0)
 			dev_warn(&pdev->dev, "Failed to request irq: %d\n", ret);
 		else
 			gpio_charger->irq = irq;
-- 
1.7.4.1



