Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1AELXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:23:20 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17898 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab1AELXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:23:17 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next-2.6] pch_udc: support new device ML7213 IOH
Date: Wed,  5 Jan 2011 20:22:30 +0900
Message-Id: <1294226550-4788-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support new device OKI SEMICONDUCTOR's ML7213 IOH(Input/Output Hub) which is for
IVI(In-Vehicle Infotainment) use.
The ML7213 is companion chip for Intel Atom E6xx series.
The ML7213 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/usb/gadget/Kconfig   |    7 ++++++-
 drivers/usb/gadget/pch_udc.c |    7 +++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 02f9049..533dbc8 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -496,7 +496,7 @@ config USB_LANGWELL
 	select USB_GADGET_SELECTED
 
 config USB_GADGET_EG20T
-	boolean "Intel EG20T(Topcliff) USB Device controller"
+	boolean "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
 	depends on PCI
 	select USB_GADGET_DUALSPEED
 	help
@@ -512,6 +512,11 @@ config USB_GADGET_EG20T
 	  This driver dose not support interrupt transfer or isochronous
 	  transfer modes.
 
+	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 which is
+	  for IVI(In-Vehicle Infotainment) use.
+	  ML7213 is companion chip for Intel Atom E6xx series.
+	  ML7213 is completely compatible for Intel EG20T PCH.
+
 config USB_EG20T
 	tristate
 	depends on USB_GADGET_EG20T
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 0c8dd81..cab47d6 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -361,6 +361,8 @@ struct pch_udc_dev {
 
 #define PCH_UDC_PCI_BAR			1
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
+#define PCI_VENDOR_ID_ROHM 0x10DB
+#define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
 
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
@@ -2914,6 +2916,11 @@ static DEFINE_PCI_DEVICE_TABLE(pch_udc_pcidev_id) = {
 		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
 		.class_mask = 0xffffffff,
 	},
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_ROHM, PCI_DEVICE_ID_ML7213_IOH_UDC),
+		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
+		.class_mask = 0xffffffff,
+	},
 	{ 0 },
 };
 
-- 
1.6.2.5

