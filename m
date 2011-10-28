Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1J1Ahv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:37:51 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40018 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605Ab1J1Ahs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:37:48 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] pch_udc: Support new device LAPIS Semiconductor ML7831 IOH
Date: Fri, 28 Oct 2011 09:37:34 +0900
Message-Id: <1319762255-7092-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/usb/gadget/Kconfig   |    9 +++++----
 drivers/usb/gadget/pch_udc.c |    6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index b21cd37..23a4473 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -469,7 +469,7 @@ config USB_LANGWELL
 	   gadget drivers to also be dynamically linked.
 
 config USB_EG20T
-	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
+	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
 	depends on PCI
 	select USB_GADGET_DUALSPEED
 	help
@@ -485,10 +485,11 @@ config USB_EG20T
 	  This driver dose not support interrupt transfer or isochronous
 	  transfer modes.
 
-	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 which is
+	  This driver also can be used for LAPIS Semiconductor's ML7213 which is
 	  for IVI(In-Vehicle Infotainment) use.
-	  ML7213 is companion chip for Intel Atom E6xx series.
-	  ML7213 is completely compatible for Intel EG20T PCH.
+	  ML7831 is for general purpose use.
+	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
 
 config USB_CI13XXX_MSM
 	tristate "MIPS USB CI13xxx for MSM"
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 550d6dc..729e974 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -354,6 +354,7 @@ struct pch_udc_dev {
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
+#define PCI_DEVICE_ID_ML7831_IOH_UDC	0x8808
 
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
@@ -2970,6 +2971,11 @@ static DEFINE_PCI_DEVICE_TABLE(pch_udc_pcidev_id) = {
 		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
 		.class_mask = 0xffffffff,
 	},
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_ROHM, PCI_DEVICE_ID_ML7831_IOH_UDC),
+		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
+		.class_mask = 0xffffffff,
+	},
 	{ 0 },
 };
 
-- 
1.7.4.4

