Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2DNKyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:54:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:38818 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754577Ab2DNKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:54:16 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        thierry.reding@avionic-design.de, devel@driverdev.osuosl.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/4] input: Device tree support for LPC32xx touchscreen
Date: Sat, 14 Apr 2012 12:53:08 +0200
Message-Id: <1334400790-10892-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334400790-10892-1-git-send-email-stigge@antcom.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for the LPC32xx SoC's touchscreen
controller.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

 Applies to v3.4-rc2

 Documentation/devicetree/bindings/input/touchscreen/lpc32xx-tsc.txt |   16 ++++++++++
 drivers/input/touchscreen/lpc32xx_ts.c                              |   10 ++++++
 2 files changed, 26 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/input/touchscreen/lpc32xx-tsc.txt
@@ -0,0 +1,16 @@
+* NXP LPC32xx SoC Touchscreen Controller (TSC)
+
+Required properties:
+- compatible: must be "nxp,lpc32xx-tsc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The TSC/ADC interrupt
+
+Example:
+
+	tsc@40048000 {
+		compatible = "nxp,lpc32xx-tsc";
+		reg = <0x40048000 0x1000>;
+		interrupt-parent = <&mic>;
+		interrupts = <39 0>;
+	};
--- linux-2.6.orig/drivers/input/touchscreen/lpc32xx_ts.c
+++ linux-2.6/drivers/input/touchscreen/lpc32xx_ts.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 /*
  * Touchscreen controller register offsets
@@ -383,6 +384,14 @@ static const struct dev_pm_ops lpc32xx_t
 #define LPC32XX_TS_PM_OPS NULL
 #endif
 
+#ifdef CONFIG_OF
+static struct of_device_id lpc32xx_tsc_of_match[] = {
+	{ .compatible = "nxp,lpc32xx-tsc", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_tsc_of_match);
+#endif
+
 static struct platform_driver lpc32xx_ts_driver = {
 	.probe		= lpc32xx_ts_probe,
 	.remove		= __devexit_p(lpc32xx_ts_remove),
@@ -390,6 +399,7 @@ static struct platform_driver lpc32xx_ts
 		.name	= MOD_NAME,
 		.owner	= THIS_MODULE,
 		.pm	= LPC32XX_TS_PM_OPS,
+		.of_match_table = of_match_ptr(lpc32xx_tsc_of_match),
 	},
 };
 module_platform_driver(lpc32xx_ts_driver);
