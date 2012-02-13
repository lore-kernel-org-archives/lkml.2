Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2BMOoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:15 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:47810 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2BMOoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:12 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 3/9] ARM/USB: at91/ohci-at91: remove the use of irq_to_gpio
Date: Mon, 13 Feb 2012 15:43:03 +0100
Message-Id: <fab15f7eaf6622e68e62bc3afa533b12f48ca27e.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_to_gpio() macro will be removed from AT91 GPIO interrupt
controller. So we replace it with the use of gpio_to_irq()
and a reworked test.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ohci-at91.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 77afabc..8e855eb 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -448,10 +448,11 @@ static irqreturn_t ohci_hcd_at91_overcurrent_irq(int irq, void *data)
 
 	/* From the GPIO notifying the over-current situation, find
 	 * out the corresponding port */
-	gpio = irq_to_gpio(irq);
 	for (port = 0; port < ARRAY_SIZE(pdata->overcurrent_pin); port++) {
-		if (pdata->overcurrent_pin[port] == gpio)
+		if (gpio_to_irq(pdata->overcurrent_pin[port]) == irq) {
+			gpio = pdata->overcurrent_pin[port];
 			break;
+		}
 	}
 
 	if (port == ARRAY_SIZE(pdata->overcurrent_pin)) {
-- 
1.7.9

