Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab1KWAzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:55:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab1KWAgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:36:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:56 2011
Message-Id: <20111123002556.387425437@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [37/53] USB: pch_udc: Support new device LAPIS Semiconductor ML7831 IOH
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 731ad81e2dd97e3f222361f7b3ff4b35639e46af upstream.

ML7831 is companion chip for Intel Atom E6xx series.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/Kconfig   |    9 +++++----
 drivers/usb/gadget/pch_udc.c |    6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -442,7 +442,7 @@ config USB_LANGWELL
 	   gadget drivers to also be dynamically linked.
 
 config USB_EG20T
-	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH UDC"
+	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
 	depends on PCI
 	select USB_GADGET_DUALSPEED
 	help
@@ -458,10 +458,11 @@ config USB_EG20T
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
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -363,6 +363,7 @@ struct pch_udc_dev {
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
+#define PCI_DEVICE_ID_ML7831_IOH_UDC	0x8808
 
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
@@ -2979,6 +2980,11 @@ static DEFINE_PCI_DEVICE_TABLE(pch_udc_p
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
 


