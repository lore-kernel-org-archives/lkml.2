Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2JEQX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:23:29 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56414 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab2JEQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:22:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/32 v3] MIPS: Netlogic: convert to use OHCI platform driver
Date: Fri,  5 Oct 2012 18:20:52 +0200
Message-Id: <1349454064-11606-21-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OHCI platform driver is suitable for use by the Netlogic XLR platform
so use this driver instead of the OHCI XLS platform driver.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
No changes in v3

Changes in v2:
- really make the code register the "ohci-platform" driver instead of "ohci-xls"

 arch/mips/netlogic/xlr/platform.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
index 144c5c6..507230e 100644
--- a/arch/mips/netlogic/xlr/platform.c
+++ b/arch/mips/netlogic/xlr/platform.c
@@ -16,6 +16,7 @@
 #include <linux/serial_reg.h>
 #include <linux/i2c.h>
 #include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <asm/netlogic/haldefs.h>
 #include <asm/netlogic/xlr/iomap.h>
@@ -128,12 +129,14 @@ static struct usb_ehci_pdata xls_usb_ehci_pdata = {
 	.caps_offset	= 0,
 };
 
+static struct usb_ohci_pdata xls_usb_ohci_pdata;
+
 static struct platform_device xls_usb_ehci_device =
 			 USB_PLATFORM_DEV("ehci-platform", 0, PIC_USB_IRQ);
 static struct platform_device xls_usb_ohci_device_0 =
-			 USB_PLATFORM_DEV("ohci-xls-0", 1, PIC_USB_IRQ);
+			 USB_PLATFORM_DEV("ohci-platform", 1, PIC_USB_IRQ);
 static struct platform_device xls_usb_ohci_device_1 =
-			 USB_PLATFORM_DEV("ohci-xls-1", 2, PIC_USB_IRQ);
+			 USB_PLATFORM_DEV("ohci-platform", 2, PIC_USB_IRQ);
 
 static struct platform_device *xls_platform_devices[] = {
 	&xls_usb_ehci_device,
@@ -182,10 +185,12 @@ int xls_platform_usb_init(void)
 	memres += 0x400;
 	xls_usb_ohci_device_0.resource[0].start = memres;
 	xls_usb_ohci_device_0.resource[0].end = memres + 0x400 - 1;
+	xls_usb_ohci_device_0.dev.platform_data = &xls_usb_ohci_pdata;
 
 	memres += 0x400;
 	xls_usb_ohci_device_1.resource[0].start = memres;
 	xls_usb_ohci_device_1.resource[0].end = memres + 0x400 - 1;
+	xls_usb_ohci_device_1.dev.platform_data = &xls_usb_ohci_pdata;
 
 	return platform_add_devices(xls_platform_devices,
 				ARRAY_SIZE(xls_platform_devices));
-- 
1.7.9.5

