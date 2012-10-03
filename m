Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2JCPN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:13:56 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36900 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511Ab2JCPNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:50 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/25] MIPS: Netlogic: convert to use OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:16 +0200
Message-Id: <1349276601-8371-22-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/netlogic/xlr/platform.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
index 320b7ef..755ddcc 100644
--- a/arch/mips/netlogic/xlr/platform.c
+++ b/arch/mips/netlogic/xlr/platform.c
@@ -16,6 +16,7 @@
 #include <linux/serial_reg.h>
 #include <linux/i2c.h>
 #include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <asm/netlogic/haldefs.h>
 #include <asm/netlogic/xlr/iomap.h>
@@ -129,6 +130,8 @@ static struct usb_ehci_pdata xls_usb_ehci_pdata = {
 	.need_io_watchdog = 1,
 };
 
+static struct usb_ohci_pdata xls_usb_ohci_pdata;
+
 static struct platform_device xls_usb_ehci_device =
 			 USB_PLATFORM_DEV("ehci-xls", 0, PIC_USB_IRQ);
 static struct platform_device xls_usb_ohci_device_0 =
@@ -183,10 +186,12 @@ int xls_platform_usb_init(void)
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

