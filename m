Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1KOJnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 04:43:32 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:55939 "EHLO
	AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754093Ab1KOJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:43:31 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Dong Aisheng <dong.aisheng@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <arnd@arndb.de>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>
Subject: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro define
Date: Tue, 15 Nov 2011 17:55:10 +0800
Message-ID: <1321350910-8685-1-git-send-email-dong.aisheng@linaro.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
---
 drivers/gpio/gpio-mxs.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 385c58e..b9f7567 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -31,9 +31,6 @@
 #include <linux/module.h>
 #include <mach/mxs.h>
 
-#define MXS_SET		0x4
-#define MXS_CLR		0x8
-
 #define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
 #define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
 #define PINCTRL_DOE(n)		((cpu_is_mx23() ? 0x0700 : 0x0b00) + (n) * 0x10)
@@ -91,19 +88,19 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 	/* set level or edge */
 	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
 	if (edge & GPIO_INT_LEV_MASK)
-		writel(pin_mask, pin_addr + MXS_SET);
+		writel(pin_mask, pin_addr + MXS_SET_ADDR);
 	else
-		writel(pin_mask, pin_addr + MXS_CLR);
+		writel(pin_mask, pin_addr + MXS_CLR_ADDR);
 
 	/* set polarity */
 	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
 	if (edge & GPIO_INT_POL_MASK)
-		writel(pin_mask, pin_addr + MXS_SET);
+		writel(pin_mask, pin_addr + MXS_SET_ADDR);
 	else
-		writel(pin_mask, pin_addr + MXS_CLR);
+		writel(pin_mask, pin_addr + MXS_CLR_ADDR);
 
 	writel(1 << (gpio & 0x1f),
-	       port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
+	       port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR_ADDR);
 
 	return 0;
 }
@@ -164,7 +161,7 @@ static void __init mxs_gpio_init_gc(struct mxs_gpio_port *port)
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = mxs_gpio_set_irq_type;
 	ct->chip.irq_set_wake = mxs_gpio_set_wake_irq;
-	ct->regs.ack = PINCTRL_IRQSTAT(port->id) + MXS_CLR;
+	ct->regs.ack = PINCTRL_IRQSTAT(port->id) + MXS_CLR_ADDR;
 	ct->regs.mask = PINCTRL_IRQEN(port->id);
 
 	irq_setup_generic_chip(gc, IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
@@ -232,7 +229,7 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 	writel(0, port->base + PINCTRL_IRQEN(port->id));
 
 	/* clear address has to be used to clear IRQSTAT bits */
-	writel(~0U, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
+	writel(~0U, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR_ADDR);
 
 	/* gpio-mxs can be a generic irq chip */
 	mxs_gpio_init_gc(port);
-- 
1.7.0.4


