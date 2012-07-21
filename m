Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2GUK7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:59:09 -0400
Received: from mta05.xtra.co.nz ([210.54.141.250]:33069 "EHLO mta02.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507Ab2GUK7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:59:07 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tony Prisk <linux@prisktech.co.nz>, Alan Stern <stern@rowland.harvard.edu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        VT8500 mailing list 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: [PATCHv4 1/2] ARM: vt8500: Update vt8500-ehci driver to support device tree.
Date: Sat, 21 Jul 2012 22:58:52 +1200
Message-Id: <1342868333-10647-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
v4:
Minor changes to the documentation of required properties.

 .../devicetree/bindings/usb/vt8500-ehci.txt        |   12 ++++++++++++
 drivers/usb/host/ehci-vt8500.c                     |    9 +++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/vt8500-ehci.txt

diff --git a/Documentation/devicetree/bindings/usb/vt8500-ehci.txt b/Documentation/devicetree/bindings/usb/vt8500-ehci.txt
new file mode 100644
index 0000000..5fb8fd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/vt8500-ehci.txt
@@ -0,0 +1,12 @@
+VIA VT8500 and Wondermedia WM8xxx SoC USB controllers.
+
+Required properties:
+ - compatible: Should be "via,vt8500-ehci" or "wm,prizm-ehci".
+ - reg: Address range of the ehci registers. size should be 0x200
+ - interrupts: Should contain the ehci interrupt.
+
+usb: ehci@D8007100 {
+	compatible = "wm,prizm-ehci", "usb-ehci";
+	reg = <0xD8007100 0x200>;
+	interrupts = <1>;
+};
diff --git a/drivers/usb/host/ehci-vt8500.c b/drivers/usb/host/ehci-vt8500.c
index c1eda73..4ba8f0c 100644
--- a/drivers/usb/host/ehci-vt8500.c
+++ b/drivers/usb/host/ehci-vt8500.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 static int ehci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
@@ -162,6 +163,12 @@ static int vt8500_ehci_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id vt8500_ehci_ids[] = {
+	{ .compatible = "via,vt8500-ehci", },
+	{ .compatible = "wm,prizm-ehci", },
+	{}
+};
+
 static struct platform_driver vt8500_ehci_driver = {
 	.probe		= vt8500_ehci_drv_probe,
 	.remove		= vt8500_ehci_drv_remove,
@@ -169,7 +176,9 @@ static struct platform_driver vt8500_ehci_driver = {
 	.driver = {
 		.name	= "vt8500-ehci",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(vt8500_ehci_ids),
 	}
 };
 
 MODULE_ALIAS("platform:vt8500-ehci");
+MODULE_DEVICE_TABLE(of, vt8500_ehci_ids);
-- 
1.7.2.5

