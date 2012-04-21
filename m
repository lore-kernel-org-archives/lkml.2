Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2DUIMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 04:12:24 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36299 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898Ab2DUIMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 04:12:21 -0400
From: Roland Stigge <stigge@antcom.de>
To: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v5] rtc: Add device tree support for LPC32xx
Date: Sat, 21 Apr 2012 10:11:32 +0200
Message-Id: <1334995893-14402-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for rtc-lpc32xx.c

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

Changes since v4:
* Reduced "compatible" strings to just the first one

 Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt |   15 +++++++++++++++
 drivers/rtc/rtc-lpc32xx.c                             |   12 +++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt
@@ -0,0 +1,15 @@
+* NXP LPC32xx SoC Real Time Clock controller
+
+Required properties:
+- compatible: must be "nxp,lpc3220-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The RTC interrupt
+
+Example:
+
+	rtc@40024000 {
+		compatible = "nxp,lpc3220-rtc";
+		reg = <0x40024000 0x1000>;
+		interrupts = <52 0>;
+	};
--- linux-2.6.orig/drivers/rtc/rtc-lpc32xx.c
+++ linux-2.6/drivers/rtc/rtc-lpc32xx.c
@@ -19,6 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 /*
  * Clock and Power control register offsets
@@ -386,13 +387,22 @@ static const struct dev_pm_ops lpc32xx_r
 #define LPC32XX_RTC_PM_OPS NULL
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id lpc32xx_rtc_match[] = {
+	{ .compatible = "nxp,lpc3220-rtc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_rtc_match);
+#endif
+
 static struct platform_driver lpc32xx_rtc_driver = {
 	.probe		= lpc32xx_rtc_probe,
 	.remove		= __devexit_p(lpc32xx_rtc_remove),
 	.driver = {
 		.name	= RTC_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= LPC32XX_RTC_PM_OPS
+		.pm	= LPC32XX_RTC_PM_OPS,
+		.of_match_table = of_match_ptr(lpc32xx_rtc_match),
 	},
 };
 
