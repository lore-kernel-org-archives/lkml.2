Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0E1Lmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:42:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56427 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0E1Lms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:42:48 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: sha@pengutronix.de
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       Vladimir Zapolskiy <vzapolskiy@gmail.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Fabio Estevam <fabio.estevam@freescale.com>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mx35: add flexcan devices
Date: Fri, 28 May 2010 13:42:18 +0200
Message-Id: <1275046938-8465-5-git-send-email-mkl@pengutronix.de>
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

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/mach-mx3/devices.c |   40 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mx3/devices.h |    2 ++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
index db7acd6..0e1e20b 100644
--- a/arch/arm/mach-mx3/devices.c
+++ b/arch/arm/mach-mx3/devices.c
@@ -127,6 +127,46 @@ struct platform_device mxc_uart_device4 = {
 };
 #endif /* CONFIG_ARCH_MX31 */
 
+#ifdef CONFIG_ARCH_MX35
+static struct resource mxc_can_1_resources[] = {
+	{
+		.start	= 0x53fe4000,
+		.end	= 0x53fe7fff,
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
+		.start	= 0x53fe8000,
+		.end	= 0x53feffff,
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
+#endif /* CONFIG_ARCH_MX35 */
+
 /* GPIO port description */
 static struct mxc_gpio_port imx_gpio_ports[] = {
 	{
diff --git a/arch/arm/mach-mx3/devices.h b/arch/arm/mach-mx3/devices.h
index 2c3c864..f600d09 100644
--- a/arch/arm/mach-mx3/devices.h
+++ b/arch/arm/mach-mx3/devices.h
@@ -29,3 +29,5 @@ extern struct platform_device imx_ssi_device1;
 extern struct platform_device imx_wdt_device0;
 extern struct platform_device imx_rtc_device0;
 extern struct platform_device imx_kpp_device;
+extern struct platform_device mxc_can_device0;
+extern struct platform_device mxc_can_device1;
-- 
1.7.1

