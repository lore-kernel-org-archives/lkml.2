Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2DMWhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:37:41 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:54893 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753284Ab2DMWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:37:38 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3 4/8] wdt: Device tree support for pnx4008-wdt
Date: Sat, 14 Apr 2012 00:36:35 +0200
Message-Id: <1334356600-20950-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334356600-20950-1-git-send-email-stigge@antcom.de>
References: <1334356600-20950-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds watchdog support to pnx4008-wdt.c

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

 Applies to v3.4-rc2

 Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt |   13 +++++++++++++
 drivers/watchdog/pnx4008_wdt.c                             |   10 ++++++++++
 2 files changed, 23 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
@@ -0,0 +1,13 @@
+* NXP PNX watchdog timer
+
+Required properties:
+- compatible: must be "nxp,pnx4008-wdt"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+Example:
+
+	watchdog@4003C000 {
+		compatible = "nxp,pnx4008-wdt";
+		reg = <0x4003C000 0x1000>;
+	};
--- linux-2.6.orig/drivers/watchdog/pnx4008_wdt.c
+++ linux-2.6/drivers/watchdog/pnx4008_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <mach/hardware.h>
 
 /* WatchDog Timer - Chapter 23 Page 207 */
@@ -201,10 +202,19 @@ static int __devexit pnx4008_wdt_remove(
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id pnx4008_wdt_match[] = {
+	{ .compatible = "nxp,pnx4008-wdt" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pnx4008_wdt_match);
+#endif
+
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "pnx4008-watchdog",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pnx4008_wdt_match),
 	},
 	.probe = pnx4008_wdt_probe,
 	.remove = __devexit_p(pnx4008_wdt_remove),
