Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2CCLkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:40:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2CCLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:40:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        Estevam Fabio-R49496 <r49496@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/4] ARM i.MX pcm037: register a dummy regulator for the smsc911x device
Date: Sat,  3 Mar 2012 12:40:03 +0100
Message-Id: <1330774804-7310-4-git-send-email-s.hauer@pengutronix.de>
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
 arch/arm/mach-imx/mach-pcm037.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index e48854b..5fddf94 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -32,6 +32,8 @@
 #include <linux/usb/ulpi.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 
 #include <media/soc_camera.h>
 
@@ -570,6 +572,11 @@ static int __init pcm037_otg_mode(char *options)
 }
 __setup("otg_mode=", pcm037_otg_mode);
 
+static struct regulator_consumer_supply dummy_supplies[] = {
+	REGULATOR_SUPPLY("vdd33a", "smsc911x"),
+	REGULATOR_SUPPLY("vddvario", "smsc911x"),
+};
+
 /*
  * Board specific initialization.
  */
@@ -579,6 +586,8 @@ static void __init pcm037_init(void)
 
 	imx31_soc_init();
 
+	regulator_register_fixed(0, dummy_supplies, ARRAY_SIZE(dummy_supplies));
+
 	mxc_iomux_set_gpr(MUX_PGP_UH2, 1);
 
 	mxc_iomux_setup_multiple_pins(pcm037_pins, ARRAY_SIZE(pcm037_pins),
-- 
1.7.9.1

