Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1ISJYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:24:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59689 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1ISJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:24:04 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] gpio/mxc: make it work with imx6q
Date: Mon, 19 Sep 2011 17:10:32 +0800
Message-Id: <1316423432-18333-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imx6q is a Cortex-A9 Quad Core SoC, which has GIC as the primary
interrupt controller.  GIC requires gpio irq handler to signal EOI,
otherwise system will hang whenever there is a gpio irq triggered.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-mxc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 4340aca..00b4c9c 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -233,6 +233,9 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 	u32 irq_stat;
 	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
+	if (desc->irq_data.chip->irq_eoi)
+		desc->irq_data.chip->irq_eoi(&desc->irq_data);
+
 	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
 
 	mxc_gpio_irq_handler(port, irq_stat);
-- 
1.7.4.1

