Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2D2Oso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:48:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49765 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502Ab2D2Ork (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:47:40 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v8 2/5] ohci-nxp: Device tree support
Date: Sun, 29 Apr 2012 16:47:03 +0200
Message-Id: <1335710826-6684-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1335710826-6684-1-git-send-email-stigge@antcom.de>
References: <1335710826-6684-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to ohci-nxp.c

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/devicetree/bindings/usb/ohci-nxp.txt |   16 ++++++++++++++++
 drivers/usb/host/ohci-nxp.c                        |   10 ++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-nxp.txt

diff --git a/Documentation/devicetree/bindings/usb/ohci-nxp.txt b/Documentation/devicetree/bindings/usb/ohci-nxp.txt
new file mode 100644
index 0000000..b5c3631
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ohci-nxp.txt
@@ -0,0 +1,16 @@
+* OHCI controller, NXP ohci-nxp variant
+
+Required properties:
+- compatible: must be "nxp,ohci-nxp"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The OHCI interrupt
+
+Example (LPC32xx):
+
+	ohci@31020000 {
+		compatible = "nxp,ohci-nxp";
+		reg = <0x31020000 0x300>;
+		interrupt-parent = <&mic>;
+		interrupts = <0x3b 0>;
+	};
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 63261f7..bf542e7 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
+#include <linux/of.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -525,10 +526,19 @@ static int usb_hcd_nxp_remove(struct platform_device *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:usb-ohci");
 
+#ifdef CONFIG_OF
+static const struct of_device_id usb_hcd_nxp_match[] = {
+	{ .compatible = "nxp,ohci-nxp" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, usb_hcd_nxp_match);
+#endif
+
 static struct platform_driver usb_hcd_nxp_driver = {
 	.driver = {
 		.name = "usb-ohci",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(usb_hcd_nxp_match),
 	},
 	.probe = usb_hcd_nxp_probe,
 	.remove = usb_hcd_nxp_remove,
-- 
1.7.9

