Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2JCPSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:18:53 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36945 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab2JCPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:55 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/25] USB: ohci: allow platform driver to specify the number of ports
Date: Wed,  3 Oct 2012 17:03:08 +0200
Message-Id: <1349276601-8371-14-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-platform.c |    4 ++++
 include/linux/usb/ohci_pdriver.h |    2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index e24ec9f..1caaf65 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -31,6 +31,10 @@ static int ohci_platform_reset(struct usb_hcd *hcd)
 		ohci->flags |= OHCI_QUIRK_FRAME_NO;
 
 	ohci_hcd_init(ohci);
+
+	if (pdata->num_ports)
+		ohci->num_ports = pdata->num_ports;
+
 	err = ohci_init(ohci);
 
 	return err;
diff --git a/include/linux/usb/ohci_pdriver.h b/include/linux/usb/ohci_pdriver.h
index 74e7755..012f2b7 100644
--- a/include/linux/usb/ohci_pdriver.h
+++ b/include/linux/usb/ohci_pdriver.h
@@ -25,6 +25,7 @@
  * @big_endian_desc:	BE descriptors
  * @big_endian_mmio:	BE registers
  * @no_big_frame_no:	no big endian frame_no shift
+ * @num_ports:		number of ports
  *
  * These are general configuration options for the OHCI controller. All of
  * these options are activating more or less workarounds for some hardware.
@@ -33,6 +34,7 @@ struct usb_ohci_pdata {
 	unsigned	big_endian_desc:1;
 	unsigned	big_endian_mmio:1;
 	unsigned	no_big_frame_no:1;
+	unsigned int	num_ports;
 
 	/* Turn on all power and clocks */
 	int (*power_on)(struct platform_device *pdev);
-- 
1.7.9.5

