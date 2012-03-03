Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2CCLkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:40:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2CCLkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:40:18 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        Estevam Fabio-R49496 <r49496@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator for the smsc911x device
Date: Sat,  3 Mar 2012 12:40:04 +0100
Message-Id: <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/plat-mxc/3ds_debugboard.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/3ds_debugboard.c b/arch/arm/plat-mxc/3ds_debugboard.c
index f0ba072..d1e31fa 100644
--- a/arch/arm/plat-mxc/3ds_debugboard.c
+++ b/arch/arm/plat-mxc/3ds_debugboard.c
@@ -16,6 +16,8 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/smsc911x.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 
 #include <mach/hardware.h>
 
@@ -148,6 +150,11 @@ static struct irq_chip expio_irq_chip = {
 	.irq_unmask = expio_unmask_irq,
 };
 
+static struct regulator_consumer_supply dummy_supplies[] = {
+	REGULATOR_SUPPLY("vdd33a", "smsc911x"),
+	REGULATOR_SUPPLY("vddvario", "smsc911x"),
+};
+
 int __init mxc_expio_init(u32 base, u32 p_irq)
 {
 	int i;
@@ -188,6 +195,8 @@ int __init mxc_expio_init(u32 base, u32 p_irq)
 	irq_set_chained_handler(p_irq, mxc_expio_irq_handler);
 
 	/* Register Lan device on the debugboard */
+	regulator_register_fixed(0, dummy_supplies, ARRAY_SIZE(dummy_supplies));
+
 	smsc911x_resources[0].start = LAN9217_BASE_ADDR(base);
 	smsc911x_resources[0].end = LAN9217_BASE_ADDR(base) + 0x100 - 1;
 	platform_device_register(&smsc_lan9217_device);
-- 
1.7.9.1

