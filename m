Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab0HEK0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:26:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29408 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100Ab0HEK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:26:24 -0400
Date: Thu, 05 Aug 2010 12:27:40 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 6/7] USB: gadget: functionfs: code cleanup
In-reply-to: <a90a95cba800f0a9d62fbb805a975548746a4009.1281002833.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <fb7320a530ea60ee086a95bbf5fd25bff01c51ee.1281002833.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281002833.git.m.nazarewicz@samsung.com>
 <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
 <c66a92a8efa1ec83017633035352ba4a936d0f94.1281002833.git.m.nazarewicz@samsung.com>
 <c59df14c2fff1e327bb37f382769dad9b41da01c.1281002833.git.m.nazarewicz@samsung.com>
 <f663aae67270ec7bf8732b1ba48b6030ded70355.1281002833.git.m.nazarewicz@samsung.com>
 <a90a95cba800f0a9d62fbb805a975548746a4009.1281002833.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some of the string registration from the
FunctionFS Gadget as composite layer can handle the
iManufacturer and iProduct for us.

It also removes some of the module parameters which were
redundant as well as changes the name of others to better much
the module parameter of the composite layer.

Other then that, it also fixes formatting of multiline comments
to match the coding style.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/g_ffs.c |   85 ++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 57 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 3c2f0a4..7533328 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -52,9 +52,8 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Michal Nazarewicz");
 MODULE_LICENSE("GPL");
 
-
-static unsigned short gfs_vendor_id    = 0x1d6b;	/* Linux Foundation */
-static unsigned short gfs_product_id   = 0x0105;	/* FunctionFS Gadget */
+#define GFS_VENDOR_ID	0x1d6b	/* Linux Foundation */
+#define GFS_PRODUCT_ID	0x0105	/* FunctionFS Gadget */
 
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,
@@ -63,29 +62,16 @@ static struct usb_device_descriptor gfs_dev_desc = {
 	.bcdUSB			= cpu_to_le16(0x0200),
 	.bDeviceClass		= USB_CLASS_PER_INTERFACE,
 
-	/* Vendor and product id can be overridden by module parameters.  */
-	/* .idVendor		= cpu_to_le16(gfs_vendor_id), */
-	/* .idProduct		= cpu_to_le16(gfs_product_id), */
-	/* .bcdDevice		= f(hardware) */
-	/* .iManufacturer	= DYNAMIC */
-	/* .iProduct		= DYNAMIC */
-	/* NO SERIAL NUMBER */
-	.bNumConfigurations	= 1,
+	.idVendor		= cpu_to_le16(GFS_VENDOR_ID),
+	.idProduct		= cpu_to_le16(GFS_PRODUCT_ID),
 };
 
-#define GFS_MODULE_PARAM_DESC(name, field) \
-	MODULE_PARM_DESC(name, "Value of the " #field " field of the device descriptor sent to the host.  Takes effect only prior to the user-space driver registering to the FunctionFS.")
-
-module_param_named(usb_class,    gfs_dev_desc.bDeviceClass,    byte,   0644);
-GFS_MODULE_PARAM_DESC(usb_class, bDeviceClass);
-module_param_named(usb_subclass, gfs_dev_desc.bDeviceSubClass, byte,   0644);
-GFS_MODULE_PARAM_DESC(usb_subclass, bDeviceSubClass);
-module_param_named(usb_protocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
-GFS_MODULE_PARAM_DESC(usb_protocol, bDeviceProtocol);
-module_param_named(usb_vendor,   gfs_vendor_id,                ushort, 0644);
-GFS_MODULE_PARAM_DESC(usb_vendor, idVendor);
-module_param_named(usb_product,  gfs_product_id,               ushort, 0644);
-GFS_MODULE_PARAM_DESC(usb_product, idProduct);
+module_param_named(bDeviceClass,    gfs_dev_desc.bDeviceClass,    byte,   0644);
+MODULE_PARAM_DESC(bDeviceClass, "USB Device class");
+module_param_named(bDeviceSubClass, gfs_dev_desc.bDeviceSubClass, byte,   0644);
+MODULE_PARAM_DESC(bDeviceSubClass, "USB Device subclass");
+module_param_named(bDeviceProtocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
+MODULE_PARAM_DESC(bDeviceProtocol, "USB Device protocol");
 
 
 
@@ -95,8 +81,10 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 		.bLength		= sizeof(struct usb_otg_descriptor),
 		.bDescriptorType	= USB_DT_OTG,
 
-		/* REVISIT SRP-only hardware is possible, although
-		 * it would not be called "OTG" ... */
+		/*
+		 * REVISIT SRP-only hardware is possible, although
+		 * it would not be called "OTG" ...
+		 */
 		.bmAttributes		= USB_OTG_SRP | USB_OTG_HNP,
 	},
 
@@ -105,19 +93,7 @@ static const struct usb_descriptor_header *gfs_otg_desc[] = {
 
 /* string IDs are assigned dynamically */
 
-enum {
-	GFS_STRING_MANUFACTURER_IDX,
-	GFS_STRING_PRODUCT_IDX,
-	GFS_STRING_FIRST_CONFIG_IDX,
-};
-
-static       char gfs_manufacturer[50];
-static const char gfs_driver_desc[] = DRIVER_DESC;
-static const char gfs_short_name[]  = DRIVER_NAME;
-
 static struct usb_string gfs_strings[] = {
-	[GFS_STRING_MANUFACTURER_IDX].s = gfs_manufacturer,
-	[GFS_STRING_PRODUCT_IDX].s = gfs_driver_desc,
 #ifdef CONFIG_USB_FUNCTIONFS_RNDIS
 	{ .s = "FunctionFS + RNDIS" },
 #endif
@@ -168,11 +144,12 @@ static int gfs_unbind(struct usb_composite_dev *cdev);
 static int gfs_do_config(struct usb_configuration *c);
 
 static struct usb_composite_driver gfs_driver = {
-	.name		= gfs_short_name,
+	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
 	.bind		= gfs_bind,
 	.unbind		= gfs_unbind,
+	.iProduct	= DRIVER_DESC,
 };
 
 
@@ -245,20 +222,10 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	if (unlikely(ret < 0))
 		goto error_quick;
 
-	gfs_dev_desc.idVendor  = cpu_to_le16(gfs_vendor_id);
-	gfs_dev_desc.idProduct = cpu_to_le16(gfs_product_id);
-
-	snprintf(gfs_manufacturer, sizeof gfs_manufacturer, "%s %s with %s",
-		 init_utsname()->sysname, init_utsname()->release,
-		 cdev->gadget->name);
-
 	ret = usb_string_ids_tab(cdev, gfs_strings);
 	if (unlikely(ret < 0))
 		goto error;
 
-	gfs_dev_desc.iManufacturer = gfs_strings[GFS_STRING_MANUFACTURER_IDX].id;
-	gfs_dev_desc.iProduct      = gfs_strings[GFS_STRING_PRODUCT_IDX].id;
-
 	ret = functionfs_bind(gfs_ffs_data, cdev);
 	if (unlikely(ret < 0))
 		goto error;
@@ -266,9 +233,8 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	for (i = 0; i < ARRAY_SIZE(gfs_configurations); ++i) {
 		struct gfs_configuration *c = gfs_configurations + i;
 
-		ret = GFS_STRING_FIRST_CONFIG_IDX + i;
-		c->c.label			= gfs_strings[ret].s;
-		c->c.iConfiguration		= gfs_strings[ret].id;
+		c->c.label			= gfs_strings[i].s;
+		c->c.iConfiguration		= gfs_strings[i].id;
 		c->c.bind			= gfs_do_config;
 		c->c.bConfigurationValue	= 1 + i;
 		c->c.bmAttributes		= USB_CONFIG_ATT_SELFPOWER;
@@ -293,13 +259,14 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
 {
 	ENTER();
 
-	/* We may have been called in an error recovery frem
+	/*
+	 * We may have been called in an error recovery from
 	 * composite_bind() after gfs_unbind() failure so we need to
 	 * check if gfs_ffs_data is not NULL since gfs_bind() handles
 	 * all error recovery itself.  I'd rather we werent called
 	 * from composite on orror recovery, but what you're gonna
-	 * do...? */
-
+	 * do...?
+	 */
 	if (gfs_ffs_data) {
 		gether_cleanup();
 		functionfs_unbind(gfs_ffs_data);
@@ -334,14 +301,16 @@ static int gfs_do_config(struct usb_configuration *c)
 	if (unlikely(ret < 0))
 		return ret;
 
-	/* After previous do_configs there may be some invalid
+	/*
+	 * After previous do_configs there may be some invalid
 	 * pointers in c->interface array.  This happens every time
 	 * a user space function with fewer interfaces than a user
 	 * space function that was run before the new one is run.  The
 	 * compasit's set_config() assumes that if there is no more
 	 * then MAX_CONFIG_INTERFACES interfaces in a configuration
 	 * then there is a NULL pointer after the last interface in
-	 * c->interface array.  We need to make sure this is true. */
+	 * c->interface array.  We need to make sure this is true.
+	 */
 	if (c->next_interface_id < ARRAY_SIZE(c->interface))
 		c->interface[c->next_interface_id] = NULL;
 
@@ -350,10 +319,12 @@ static int gfs_do_config(struct usb_configuration *c)
 
 
 #ifdef CONFIG_USB_FUNCTIONFS_ETH
+
 static int eth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	return can_support_ecm(c->cdev->gadget)
 		? ecm_bind_config(c, ethaddr)
 		: geth_bind_config(c, ethaddr);
 }
+
 #endif
-- 
1.7.1

