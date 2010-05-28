Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0E1Lmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:42:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56425 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0E1Lmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:42:44 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: sha@pengutronix.de
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, Baruch Siach <baruch@tkos.co.il>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <jbe@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mx25: Add flexcan devices
Date: Fri, 28 May 2010 13:42:16 +0200
Message-Id: <1275046938-8465-3-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
References: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/mach-mx25/devices.c |   38 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mx25/devices.h |    2 ++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx25/devices.c b/arch/arm/mach-mx25/devices.c
index 3a405fa..e8b320b 100644
--- a/arch/arm/mach-mx25/devices.c
+++ b/arch/arm/mach-mx25/devices.c
@@ -390,6 +390,44 @@ struct platform_device mxc_i2c_device2 = {
 	.resource = mxc_i2c_3_resources,
 };
 
+static struct resource mxc_can_1_resources[] = {
+	{
+		.start	= 0x43f88000,
+		.end	= 0x43f8bfff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= 43,
+		.end	= 43,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device mxc_can_device0 = {
+	.name = "flexcan",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(mxc_can_1_resources),
+	.resource = mxc_can_1_resources,
+};
+
+static struct resource mxc_can_2_resources[] = {
+	{
+		.start	= 0x43f8c000,
+		.end	= 0x43f8ffff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= 44,
+		.end	= 44,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device mxc_can_device1 = {
+	.name = "flexcan",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(mxc_can_2_resources),
+	.resource = mxc_can_2_resources,
+};
+
 static struct mxc_gpio_port imx_gpio_ports[] = {
 	{
 		.chip.label = "gpio-0",
diff --git a/arch/arm/mach-mx25/devices.h b/arch/arm/mach-mx25/devices.h
index cee12c0..e3267d6 100644
--- a/arch/arm/mach-mx25/devices.h
+++ b/arch/arm/mach-mx25/devices.h
@@ -22,3 +22,5 @@ extern struct platform_device mxc_nand_device;
 extern struct platform_device mx25_rtc_device;
 extern struct platform_device mx25_fb_device;
 extern struct platform_device mxc_wdt;
+extern struct platform_device mxc_can_device0;
+extern struct platform_device mxc_can_device1;
-- 
1.7.1

