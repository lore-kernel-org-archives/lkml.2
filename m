Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2BJHIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 02:08:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51274 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758319Ab2BJHH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:07:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bcYATUBSbxdN1AedKdbYEx6fpCIgW6B46hvIef6
	b0AfTPE1Qx2dWq
Message-ID: <1328857675.7327.8.camel@marge.simpson.net>
Subject: [patch] usb: add missing Kconfig UWB select to USB_WHCI_HCD and
 USB_HWA_HCD
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 10 Feb 2012 08:07:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: add missing Kconfig UWB select to USB_WHCI_HCD and USB_HWA_HCD

cripts/kconfig/conf --oldconfig Kconfig
warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 91413ca..b224959 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -547,6 +547,7 @@ config USB_WHCI_HCD
 	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on PCI && USB
+	select UWB
 	select USB_WUSB
 	select UWB_WHCI
 	help
@@ -560,6 +561,7 @@ config USB_HWA_HCD
 	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on USB
+	select UWB
 	select USB_WUSB
 	select UWB_HWA
 	help


