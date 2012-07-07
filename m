Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2GGHzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 03:55:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55206 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GGHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 03:55:38 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: mchehab@infradead.org
Cc: anssi.hannula@iki.fi, gregkh@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v2] [media] rc: ati_remote.c: code style fixing
Date: Sat,  7 Jul 2012 15:53:28 +0800
Message-Id: <1341647608-29407-1-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <4FF75962.5000102@redhat.com>
References: <4FF75962.5000102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

changes:
	1. wrap some lines that are longer than 80 characters.
	2. remove local function prototype declarations which do not
	   need.
	3. replace TAB character with a space character in function
	   comments.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
changes for v2:
	remove compile warning fixing
---
 drivers/media/rc/ati_remote.c |  133 +++++++++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 53 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 7be377f..8fa72e2 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -147,7 +147,8 @@ static bool mouse = true;
 module_param(mouse, bool, 0444);
 MODULE_PARM_DESC(mouse, "Enable mouse device, default = yes");
 
-#define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev , format , ## arg); } while (0)
+#define dbginfo(dev, format, arg...) \
+	do { if (debug) dev_info(dev , format , ## arg); } while (0)
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
 
@@ -191,17 +192,41 @@ static const char *get_medion_keymap(struct usb_interface *interface)
 	return RC_MAP_MEDION_X10;
 }
 
-static const struct ati_receiver_type type_ati		= { .default_keymap = RC_MAP_ATI_X10 };
-static const struct ati_receiver_type type_medion	= { .get_default_keymap = get_medion_keymap };
-static const struct ati_receiver_type type_firefly	= { .default_keymap = RC_MAP_SNAPSTREAM_FIREFLY };
+static const struct ati_receiver_type type_ati		= {
+	.default_keymap = RC_MAP_ATI_X10
+};
+static const struct ati_receiver_type type_medion	= {
+	.get_default_keymap = get_medion_keymap
+};
+static const struct ati_receiver_type type_firefly	= {
+	.default_keymap = RC_MAP_SNAPSTREAM_FIREFLY
+};
 
 static struct usb_device_id ati_remote_table[] = {
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_ati },
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_ati },
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_ati },
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_ati },
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_medion },
-	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, FIREFLY_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)&type_firefly },
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_ati
+	},
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_ati
+	},
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_ati
+	},
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_ati
+	},
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_medion
+	},
+	{
+		USB_DEVICE(ATI_REMOTE_VENDOR_ID, FIREFLY_REMOTE_PRODUCT_ID),
+		.driver_info = (unsigned long)&type_firefly
+	},
 	{}	/* Terminating entry */
 };
 
@@ -296,25 +321,8 @@ static const struct {
 	{KIND_END, 0x00, EV_MAX + 1, 0, 0}
 };
 
-/* Local function prototypes */
-static int ati_remote_sendpacket	(struct ati_remote *ati_remote, u16 cmd, unsigned char *data);
-static void ati_remote_irq_out		(struct urb *urb);
-static void ati_remote_irq_in		(struct urb *urb);
-static void ati_remote_input_report	(struct urb *urb);
-static int ati_remote_initialize	(struct ati_remote *ati_remote);
-static int ati_remote_probe		(struct usb_interface *interface, const struct usb_device_id *id);
-static void ati_remote_disconnect	(struct usb_interface *interface);
-
-/* usb specific object to register with the usb subsystem */
-static struct usb_driver ati_remote_driver = {
-	.name         = "ati_remote",
-	.probe        = ati_remote_probe,
-	.disconnect   = ati_remote_disconnect,
-	.id_table     = ati_remote_table,
-};
-
 /*
- *	ati_remote_dump_input
+ * ati_remote_dump_input
  */
 static void ati_remote_dump(struct device *dev, unsigned char *data,
 			    unsigned int len)
@@ -326,12 +334,14 @@ static void ati_remote_dump(struct device *dev, unsigned char *data,
 		dev_warn(dev, "Weird key %02x %02x %02x %02x\n",
 		     data[0], data[1], data[2], data[3]);
 	else
-		dev_warn(dev, "Weird data, len=%d %02x %02x %02x %02x %02x %02x ...\n",
-		     len, data[0], data[1], data[2], data[3], data[4], data[5]);
+		dev_warn(dev,
+			"Weird data, len=%d %02x %02x %02x %02x %02x %02x ...\n",
+			len, data[0], data[1], data[2], data[3], data[4],
+			data[5]);
 }
 
 /*
- *	ati_remote_open
+ * ati_remote_open
  */
 static int ati_remote_open(struct ati_remote *ati_remote)
 {
@@ -355,7 +365,7 @@ out:	mutex_unlock(&ati_remote->open_mutex);
 }
 
 /*
- *	ati_remote_close
+ * ati_remote_close
  */
 static void ati_remote_close(struct ati_remote *ati_remote)
 {
@@ -390,7 +400,7 @@ static void ati_remote_rc_close(struct rc_dev *rdev)
 }
 
 /*
- *		ati_remote_irq_out
+ * ati_remote_irq_out
  */
 static void ati_remote_irq_out(struct urb *urb)
 {
@@ -408,11 +418,12 @@ static void ati_remote_irq_out(struct urb *urb)
 }
 
 /*
- *	ati_remote_sendpacket
+ * ati_remote_sendpacket
  *
- *	Used to send device initialization strings
+ * Used to send device initialization strings
  */
-static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd, unsigned char *data)
+static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd,
+	unsigned char *data)
 {
 	int retval = 0;
 
@@ -441,7 +452,7 @@ static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd, unsigne
 }
 
 /*
- *	ati_remote_compute_accel
+ * ati_remote_compute_accel
  *
  * Implements acceleration curve for directional control pad
  * If elapsed time since last event is > 1/4 second, user "stopped",
@@ -478,7 +489,7 @@ static int ati_remote_compute_accel(struct ati_remote *ati_remote)
 }
 
 /*
- *	ati_remote_report_input
+ * ati_remote_report_input
  */
 static void ati_remote_input_report(struct urb *urb)
 {
@@ -518,7 +529,8 @@ static void ati_remote_input_report(struct urb *urb)
 	remote_num = (data[3] >> 4) & 0x0f;
 	if (channel_mask & (1 << (remote_num + 1))) {
 		dbginfo(&ati_remote->interface->dev,
-			"Masked input from channel 0x%02x: data %02x,%02x, mask= 0x%02lx\n",
+			"Masked input from channel 0x%02x: data %02x,%02x, "
+			"mask= 0x%02lx\n",
 			remote_num, data[1], data[2], channel_mask);
 		return;
 	}
@@ -546,7 +558,9 @@ static void ati_remote_input_report(struct urb *urb)
 		if (wheel_keycode == KEY_RESERVED) {
 			/* scrollwheel was not mapped, assume mouse */
 
-			/* Look up event code index in the mouse translation table. */
+			/* Look up event code index in the mouse translation
+			 * table.
+			 */
 			for (i = 0; ati_remote_tbl[i].kind != KIND_END; i++) {
 				if (scancode == ati_remote_tbl[i].data) {
 					index = i;
@@ -630,9 +644,9 @@ static void ati_remote_input_report(struct urb *urb)
 	} else {
 
 		/*
-		 * Other event kinds are from the directional control pad, and have an
-		 * acceleration factor applied to them.  Without this acceleration, the
-		 * control pad is mostly unusable.
+		 * Other event kinds are from the directional control pad, and
+		 * have an acceleration factor applied to them.  Without this
+		 * acceleration, the control pad is mostly unusable.
 		 */
 		acc = ati_remote_compute_accel(ati_remote);
 
@@ -659,7 +673,8 @@ static void ati_remote_input_report(struct urb *urb)
 			input_report_rel(dev, REL_Y, acc);
 			break;
 		default:
-			dev_dbg(&ati_remote->interface->dev, "ati_remote kind=%d\n",
+			dev_dbg(&ati_remote->interface->dev,
+				"ati_remote kind=%d\n",
 				ati_remote_tbl[index].kind);
 		}
 		input_sync(dev);
@@ -670,7 +685,7 @@ static void ati_remote_input_report(struct urb *urb)
 }
 
 /*
- *	ati_remote_irq_in
+ * ati_remote_irq_in
  */
 static void ati_remote_irq_in(struct urb *urb)
 {
@@ -684,22 +699,25 @@ static void ati_remote_irq_in(struct urb *urb)
 	case -ECONNRESET:	/* unlink */
 	case -ENOENT:
 	case -ESHUTDOWN:
-		dev_dbg(&ati_remote->interface->dev, "%s: urb error status, unlink? \n",
+		dev_dbg(&ati_remote->interface->dev,
+			"%s: urb error status, unlink?\n",
 			__func__);
 		return;
 	default:		/* error */
-		dev_dbg(&ati_remote->interface->dev, "%s: Nonzero urb status %d\n",
+		dev_dbg(&ati_remote->interface->dev,
+			"%s: Nonzero urb status %d\n",
 			__func__, urb->status);
 	}
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		dev_err(&ati_remote->interface->dev, "%s: usb_submit_urb()=%d\n",
+		dev_err(&ati_remote->interface->dev,
+			"%s: usb_submit_urb()=%d\n",
 			__func__, retval);
 }
 
 /*
- *	ati_remote_alloc_buffers
+ * ati_remote_alloc_buffers
  */
 static int ati_remote_alloc_buffers(struct usb_device *udev,
 				    struct ati_remote *ati_remote)
@@ -726,7 +744,7 @@ static int ati_remote_alloc_buffers(struct usb_device *udev,
 }
 
 /*
- *	ati_remote_free_buffers
+ * ati_remote_free_buffers
  */
 static void ati_remote_free_buffers(struct ati_remote *ati_remote)
 {
@@ -825,9 +843,10 @@ static int ati_remote_initialize(struct ati_remote *ati_remote)
 }
 
 /*
- *	ati_remote_probe
+ * ati_remote_probe
  */
-static int ati_remote_probe(struct usb_interface *interface, const struct usb_device_id *id)
+static int ati_remote_probe(struct usb_interface *interface,
+	const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct usb_host_interface *iface_host = interface->cur_altsetting;
@@ -949,7 +968,7 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 }
 
 /*
- *	ati_remote_disconnect
+ * ati_remote_disconnect
  */
 static void ati_remote_disconnect(struct usb_interface *interface)
 {
@@ -971,6 +990,14 @@ static void ati_remote_disconnect(struct usb_interface *interface)
 	kfree(ati_remote);
 }
 
+/* usb specific object to register with the usb subsystem */
+static struct usb_driver ati_remote_driver = {
+	.name         = "ati_remote",
+	.probe        = ati_remote_probe,
+	.disconnect   = ati_remote_disconnect,
+	.id_table     = ati_remote_table,
+};
+
 module_usb_driver(ati_remote_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.7.9.5

