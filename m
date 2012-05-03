Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2ECMnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:43:17 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:39189 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754277Ab2ECMnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:43:16 -0400
Date: Thu, 3 May 2012 18:13:08 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201205031243.q43Ch8cU029192@amcc.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v16 10/10]USB/ppc4xx:Synopsys DWC OTG driver enable gadget support
Cc: rsarmah@apm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable gadget support

Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
Signed-off-by: Tirumala R Marri <tmarri@apm.com>
Signed-off-by: Fushen Chen <fchen@apm.com>
Signed-off-by: Mark Miesfeld <mmiesfeld@apm.com>
---
 drivers/usb/gadget/Kconfig        |   11 +++++++++++
 drivers/usb/gadget/gadget_chips.h |    9 ++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 2633f75..4bca4dc 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -329,6 +329,17 @@ config USB_GADGET_MUSB_HDRC
 	  This OTG-capable silicon IP is used in dual designs including
 	  the TI DaVinci, OMAP 243x, OMAP 343x, TUSB 6010, and ADI Blackfin
 
+# dwc_otg builds in ../dwc along with host support
+config USB_GADGET_DWC_HDRC
+	boolean "DesignWare USB Peripheral"
+	depends on DWC_OTG_MODE || DWC_DEVICE_ONLY
+	select USB_GADGET_DUALSPEED
+	select USB_GADGET_SELECTED
+	select USB_GADGET_DWC_OTG
+	help
+	  This OTG-capable Designware USB IP which has host and device
+	  modes.
+
 config USB_M66592
 	tristate "Renesas M66592 USB Peripheral Controller"
 	select USB_GADGET_DUALSPEED
diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadget_chips.h
index a8855d0..ab1ea6e 100644
--- a/drivers/usb/gadget/gadget_chips.h
+++ b/drivers/usb/gadget/gadget_chips.h
@@ -51,6 +51,12 @@
 #define gadget_is_s3c_hsotg(g)		(!strcmp("s3c-hsotg", (g)->name))
 #define gadget_is_s3c_hsudc(g)		(!strcmp("s3c-hsudc", (g)->name))
 
+#if defined(CONFIG_DWC_OTG_MODE) || defined(CONFIG_DWC_DEVICE_ONLY)
+#define gadget_is_dwc_otg_pcd(g)	(!strcmp("dwc_otg_pcd", (g)->name))
+#else
+#define gadget_is_dwc_otg_pcd(g)	0
+#endif
+
 /**
  * usb_gadget_controller_number - support bcdDevice id convention
  * @gadget: the controller being driven
@@ -118,11 +124,12 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
 		return 0x31;
 	else if (gadget_is_dwc3(gadget))
 		return 0x32;
+	else if (gadget_is_dwc_otg_pcd(gadget))
+		return 0x33;
 
 	return -ENOENT;
 }
 
-
 /**
  * gadget_supports_altsettings - return true if altsettings work
  * @gadget: the gadget in question
-- 
1.7.0.4

