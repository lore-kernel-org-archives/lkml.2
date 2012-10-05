Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab2JEQbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:31:55 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56263 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab2JEQW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:22:26 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/32 v3] MIPS: Netlogic: use ehci-platform driver
Date: Fri,  5 Oct 2012 18:20:37 +0200
Message-Id: <1349454064-11606-6-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI platform driver is suitable for use by the Netlogic XLR platform
since there is nothing specific that the EHCI XLR platform driver does.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
No changes in v3

Changes in v2:
- really change driver name to "ehci-platform"
- slightly reworded commit message

 arch/mips/netlogic/xlr/platform.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
index 71b44d8..144c5c6 100644
--- a/arch/mips/netlogic/xlr/platform.c
+++ b/arch/mips/netlogic/xlr/platform.c
@@ -15,6 +15,7 @@
 #include <linux/serial_8250.h>
 #include <linux/serial_reg.h>
 #include <linux/i2c.h>
+#include <linux/usb/ehci_pdriver.h>
 
 #include <asm/netlogic/haldefs.h>
 #include <asm/netlogic/xlr/iomap.h>
@@ -123,8 +124,12 @@ static u64 xls_usb_dmamask = ~(u32)0;
 		},							\
 	}
 
+static struct usb_ehci_pdata xls_usb_ehci_pdata = {
+	.caps_offset	= 0,
+};
+
 static struct platform_device xls_usb_ehci_device =
-			 USB_PLATFORM_DEV("ehci-xls", 0, PIC_USB_IRQ);
+			 USB_PLATFORM_DEV("ehci-platform", 0, PIC_USB_IRQ);
 static struct platform_device xls_usb_ohci_device_0 =
 			 USB_PLATFORM_DEV("ohci-xls-0", 1, PIC_USB_IRQ);
 static struct platform_device xls_usb_ohci_device_1 =
@@ -172,6 +177,7 @@ int xls_platform_usb_init(void)
 	memres = CPHYSADDR((unsigned long)usb_mmio);
 	xls_usb_ehci_device.resource[0].start = memres;
 	xls_usb_ehci_device.resource[0].end = memres + 0x400 - 1;
+	xls_usb_ehci_device.dev.platform_data = &xls_usb_ehci_pdata;
 
 	memres += 0x400;
 	xls_usb_ohci_device_0.resource[0].start = memres;
-- 
1.7.9.5

