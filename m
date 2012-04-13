Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2DMWiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:38:07 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:40550 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757105Ab2DMWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:38:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3 2/8] rtc: Add device tree support for LPC32xx
Date: Sat, 14 Apr 2012 00:36:33 +0200
Message-Id: <1334356600-20950-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334356600-20950-1-git-send-email-stigge@antcom.de>
References: <1334356600-20950-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for rtc-lpc32xx.c

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

 Applies to v3.4-rc2

 Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt |   15 +++++++++++++++
 drivers/rtc/rtc-lpc32xx.c                             |   12 +++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt
@@ -0,0 +1,15 @@
+* NXP LPC32xx SoC Real Time Clock controller
+
+Required properties:
+- compatible: must be "nxp,lpc32xx-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The RTC interrupt
+
+Example:
+
+	rtc@40024000 {
+		compatible = "nxp,lpc32xx-rtc";
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
+	{ .compatible = "nxp,lpc32xx-rtc" },
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
 
