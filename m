Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1E0FbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:31:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2103 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1E0FbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:31:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] staging: Make usb_device_id declarations const where possible
Date: Thu, 26 May 2011 22:30:58 -0700
Message-Id: <8ceb1d588a822c1ff215ad61de652f27b7005588.1306473714.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.2.365.g5cfe4
In-Reply-To: <cover.1306473713.git.joe@perches.com>
References: <cover.1306473713.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Const is good.  Reduce data, increase text.

Standardize the declarations that have a space after
the variable name and array brackets too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/bcm/InterfaceInit.c            |    2 +-
 drivers/staging/easycap/easycap_main.c         |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 drivers/staging/keucr/usb.c                    |    2 +-
 drivers/staging/lirc/lirc_igorplugusb.c        |    2 +-
 drivers/staging/lirc/lirc_imon.c               |    6 +++---
 drivers/staging/lirc/lirc_sasem.c              |    2 +-
 drivers/staging/lirc/lirc_ttusbir.c            |    2 +-
 drivers/staging/rtl8712/usb_intf.c             |    2 +-
 drivers/staging/tm6000/tm6000-cards.c          |    2 +-
 drivers/staging/usbip/stub_dev.c               |    2 +-
 drivers/staging/wlan-ng/prism2usb.c            |    2 +-
 12 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index d78d5ef..c3d3a63 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -1,6 +1,6 @@
 #include "headers.h"
 
-static struct usb_device_id InterfaceUsbtable[] = {
+static const struct usb_device_id InterfaceUsbtable[] = {
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
diff --git a/drivers/staging/easycap/easycap_main.c b/drivers/staging/easycap/easycap_main.c
index 62e07f6..46c77e4 100644
--- a/drivers/staging/easycap/easycap_main.c
+++ b/drivers/staging/easycap/easycap_main.c
@@ -4394,7 +4394,7 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
  *  PARAMETERS APPLICABLE TO ENTIRE DRIVER, I.E. BOTH VIDEO AND AUDIO
  */
 /*---------------------------------------------------------------------------*/
-static struct usb_device_id easycap_usb_device_id_table[] = {
+static const struct usb_device_id easycap_usb_device_id_table[] = {
 	{USB_DEVICE(USB_EASYCAP_VENDOR_ID, USB_EASYCAP_PRODUCT_ID)},
 	{ }
 };
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 79482ac..af03fb5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -29,7 +29,7 @@ size_t FileLength;
 #define PRODUCT_ID 0x11		/* fake product id */
 
 /* table of devices that work with this driver */
-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
 	{},
 };
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index d8c5c62..23a00f6 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -24,7 +24,7 @@ MODULE_LICENSE("GPL");
 
 static unsigned int delay_use = 1;
 
-static struct usb_device_id eucr_usb_ids [] = {
+static const struct usb_device_id eucr_usb_ids[] = {
 	{ USB_DEVICE(0x058f, 0x6366) },
 	{ USB_DEVICE(0x0cf2, 0x6230) },
 	{ USB_DEVICE(0x0cf2, 0x6250) },
diff --git a/drivers/staging/lirc/lirc_igorplugusb.c b/drivers/staging/lirc/lirc_igorplugusb.c
index 0dc2c2b..a14f342 100644
--- a/drivers/staging/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/lirc/lirc_igorplugusb.c
@@ -524,7 +524,7 @@ static void igorplugusb_remote_disconnect(struct usb_interface *intf)
 	dev_info(dev, DRIVER_NAME "[%d]: %s done\n", devnum, __func__);
 }
 
-static struct usb_device_id igorplugusb_remote_id_table[] = {
+static const struct usb_device_id igorplugusb_remote_id_table[] = {
 	/* Igor Plug USB (Atmel's Manufact. ID) */
 	{ USB_DEVICE(0x03eb, 0x0002) },
 	/* Fit PC2 Infrared Adapter */
diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/lirc/lirc_imon.c
index 4039eda..00cb9ff 100644
--- a/drivers/staging/lirc/lirc_imon.c
+++ b/drivers/staging/lirc/lirc_imon.c
@@ -129,7 +129,7 @@ static const struct file_operations display_fops = {
  * Samsung vendor ID (0x0aa8 and 0x04e8 respectively), while all later
  * devices use the SoundGraph vendor ID (0x15c2).
  */
-static struct usb_device_id imon_usb_id_table[] = {
+static const struct usb_device_id imon_usb_id_table[] = {
 	/* TriGem iMON (IR only) -- TG_iMON.inf */
 	{ USB_DEVICE(0x0aa8, 0x8001) },
 
@@ -146,13 +146,13 @@ static struct usb_device_id imon_usb_id_table[] = {
 };
 
 /* Some iMON VFD models requires a 6th packet for VFD writes */
-static struct usb_device_id vfd_proto_6p_list[] = {
+static const struct usb_device_id vfd_proto_6p_list[] = {
 	{ USB_DEVICE(0x15c2, 0xffda) },
 	{}
 };
 
 /* Some iMON devices have no lcd/vfd, don't set one up */
-static struct usb_device_id ir_only_list[] = {
+static const struct usb_device_id ir_only_list[] = {
 	{ USB_DEVICE(0x0aa8, 0x8001) },
 	{ USB_DEVICE(0x04e8, 0xff30) },
 	{}
diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 7080cde..773dc0c 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -129,7 +129,7 @@ static const struct file_operations vfd_fops = {
 };
 
 /* USB Device ID for Sasem USB Control Board */
-static struct usb_device_id sasem_usb_id_table[] = {
+static const struct usb_device_id sasem_usb_id_table[] = {
 	/* Sasem USB Control Board */
 	{ USB_DEVICE(0x11ba, 0x0101) },
 	/* Terminating entry */
diff --git a/drivers/staging/lirc/lirc_ttusbir.c b/drivers/staging/lirc/lirc_ttusbir.c
index e345ab9..cd79373 100644
--- a/drivers/staging/lirc/lirc_ttusbir.c
+++ b/drivers/staging/lirc/lirc_ttusbir.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(num_urbs,
 		 "of problems (default: 2; minimum: 2)");
 
 /* table of devices that work with this driver */
-static struct usb_device_id device_id_table[] = {
+static const struct usb_device_id device_id_table[] = {
 	/* TechnoTrend USB IR Receiver */
 	{ USB_DEVICE(0x0B48, 0x2003) },
 	/* Terminating entry */
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 21ce2af..72a8dbb 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -46,7 +46,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 
 static void r871xu_dev_remove(struct usb_interface *pusb_intf);
 
-static struct usb_device_id rtl871x_usb_id_tbl[] = {
+static const struct usb_device_id rtl871x_usb_id_tbl[] = {
 
 /* RTL8188SU */
 	/* Realtek */
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a69c82e..5e01cf4 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -612,7 +612,7 @@ struct tm6000_board tm6000_boards[] = {
 };
 
 /* table of devices that work with this driver */
-struct usb_device_id tm6000_id_table[] = {
+static const struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_GENERIC },
 	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
 	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 6e99ec8..8d68358 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -32,7 +32,7 @@ static void stub_disconnect(struct usb_interface *interface);
  * In the most cases, wild card matching will be ok because driver binding can
  * be changed dynamically by a userland program.
  */
-static struct usb_device_id stub_table[] = {
+static const struct usb_device_id stub_table[] = {
 #if 0
 	/* just an example */
 	{ USB_DEVICE(0x05ac, 0x0301) },   /* Mac 1 button mouse */
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 4efa027..6ef5c9b 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -8,7 +8,7 @@
 	USB_DEVICE(vid, pid),			\
 	.driver_info = (unsigned long) name
 
-static struct usb_device_id usb_prism_tbl[] = {
+static const struct usb_device_id usb_prism_tbl[] = {
 	{PRISM_USB_DEVICE(0x04bb, 0x0922, "IOData AirPort WN-B11/USBS")},
 	{PRISM_USB_DEVICE(0x07aa, 0x0012, "Corega Wireless LAN USB Stick-11")},
 	{PRISM_USB_DEVICE(0x09aa, 0x3642, "Prism2.x 11Mbps WLAN USB Adapter")},
-- 
1.7.5.2.365.g5cfe4

