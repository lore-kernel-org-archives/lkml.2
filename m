Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2KMQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:16:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64420 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2KMQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:16:24 -0500
Message-ID: <1352823374.10676.1.camel@phoenix>
Subject: [PATCH] pinctrl: coh901: Return proper error if
 irq_domain_add_linear() fails
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 14 Nov 2012 00:16:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM instead of 0 if irq_domain_add_linear fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-coh901.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 5c7daf9..1144dcd 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -752,8 +752,10 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 						     U300_GPIO_PINS_PER_PORT,
 						     &irq_domain_simple_ops,
 						     port);
-		if (!port->domain)
+		if (!port->domain) {
+			err = -ENOMEM;
 			goto err_no_domain;
+		}
 
 		irq_set_chained_handler(port->irq, u300_gpio_irq_handler);
 		irq_set_handler_data(port->irq, port);
@@ -801,7 +803,7 @@ err_no_domain:
 err_no_port:
 	u300_gpio_free_ports(gpio);
 	clk_disable_unprepare(gpio->clk);
-	dev_info(&pdev->dev, "module ERROR:%d\n", err);
+	dev_err(&pdev->dev, "module ERROR:%d\n", err);
 	return err;
 }
 
-- 
1.7.9.5



