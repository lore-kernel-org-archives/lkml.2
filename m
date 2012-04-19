Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab2DSVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:40:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44862 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811Ab2DSVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:47 -0400
Message-Id: <20120419210614.792930198@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 43/59] USB: pch_udc: Support new device LAPIS Semiconductor ML7831 IOH
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 731ad81e2dd97e3f222361f7b3ff4b35639e46af upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/gadget/Kconfig   |    7 ++++---
 drivers/usb/gadget/pch_udc.c |    6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -544,7 +544,7 @@ config USB_LANGWELL
 	select USB_GADGET_SELECTED
 
 config USB_GADGET_EG20T
-	boolean "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
+	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR IOH(ML7213/ML7831) UDC"
 	depends on PCI
 	select USB_GADGET_DUALSPEED
 	help
@@ -562,8 +562,9 @@ config USB_GADGET_EG20T
 
 	  This driver also can be used for OKI SEMICONDUCTOR's ML7213 which is
 	  for IVI(In-Vehicle Infotainment) use.
-	  ML7213 is companion chip for Intel Atom E6xx series.
-	  ML7213 is completely compatible for Intel EG20T PCH.
+	  ML7831 is for general purpose use.
+	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
 
 config USB_EG20T
 	tristate
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -365,6 +365,7 @@ struct pch_udc_dev {
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
+#define PCI_DEVICE_ID_ML7831_IOH_UDC	0x8808
 
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
@@ -3048,6 +3049,11 @@ static DEFINE_PCI_DEVICE_TABLE(pch_udc_p
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
 


