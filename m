Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0FBMpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:45:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0FBMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:45:02 -0400
Date: Wed, 02 Jun 2010 14:45:29 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 08/11] USB: gadget: g_multi: more configurable
In-reply-to: <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <762e84e05c338446cb4c51797b4773d3db321179.1275481997.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275481997.git.mina86@mina86.com>
 <5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
 <e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
 <785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
 <5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
 <17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
 <381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
 <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Kconfig options for each function used by g_multi so that
one can customize the gadget to a greater extend.

Note that it will be wise to change vendor and product ID when
customising the gadget.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_multi.txt |   27 +++---
 drivers/usb/gadget/Kconfig         |   67 +++++++++-----
 drivers/usb/gadget/multi.c         |  166 ++++++++++++++++--------------------
 3 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/usb/gadget_multi.txt
index bd53a9f..65bccd8 100644
--- a/Documentation/usb/gadget_multi.txt
+++ b/Documentation/usb/gadget_multi.txt
@@ -2,20 +2,21 @@
 
 * Overview
 
-The Multifunction Composite Gadget (or g_multi) is a composite gadget
-that makes extensive use of the composite framework to provide
-a... multifunction gadget.
+The Multifunction Composite Gadget (or g_multi) is a customisable
+composite gadget that makes extensive use of the composite framework
+to provide a... multifunction gadget.
 
 In it's standard configuration it provides a single USB configuration
 with RNDIS[1] (that is Ethernet), USB CDC[2] ACM (that is serial) and
 USB Mass Storage functions.
 
-A CDC ECM (Ethernet) function may be turned on via a Kconfig option
-and RNDIS can be turned off.  If they are both enabled the gadget will
-have two configurations -- one with RNDIS and another with CDC ECM[3].
+Each function can be disabled via a Kconfig option.  There's also
+a CDC ECM (Ethernet) function which can be turned on.  If CDC ECM and
+RNDIS are enabled the gadget will have two configurations -- one with
+RNDIS and another with CDC ECM[3].
 
-Please not that if you use non-standard configuration (that is enable
-CDC ECM) you may need to change vendor and/or product ID.
+Please not that if you use non-standard configuration you may need to
+change vendor and/or product ID.
 
 * Host drivers
 
@@ -92,11 +93,11 @@ hesitate submitting it!
 
 **** Customising the gadget
 
-If you intend to hack the g_multi gadget be advised that rearranging
-functions will obviously change interface numbers for each of the
-functionality.  As an effect provided INFs won't work since they have
-interface numbers hard-coded in them (it's not hard to change those
-though).
+If you intend to customise (via Kconfig) or hack the g_multi gadget be
+advised that rearranging functions will obviously change interface
+numbers for each of the functionality.  As an effect provided INFs
+won't work since they have interface numbers hard-coded in them (it's
+not hard to change those though).
 
 This also means, that after experimenting with g_multi and changing
 provided functions one should change gadget's vendor and/or product ID
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index c97f021..8052643 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -861,43 +861,62 @@ config USB_G_NOKIA
 
 config USB_G_MULTI
 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
-	depends on BLOCK && NET
-	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
+	select USB_G_MULTI_ACM if !USB_G_MULTI_ANYTHING
 	help
-	  The Multifunction Composite Gadget provides Ethernet (RNDIS
-	  and/or CDC Ethernet), mass storage and ACM serial link
-	  interfaces.
-
-	  You will be asked to choose which of the two configurations is
-	  to be available in the gadget.  At least one configuration must
-	  be chosen to make the gadget usable.  Selecting more than one
-	  configuration will prevent Windows from automatically detecting
-	  the gadget as a composite gadget, so an INF file will be needed to
-	  use the gadget.
+	  The Multifunction Composite Gadget provides several different
+	  configurations and functions.  Which interfaces are provided can
+	  be configured at build time.  If you choose this gadget additional
+	  options will appear.
 
 	  Say "y" to link the driver statically, or "m" to build a
 	  dynamically linked module called "g_multi".
 
-config USB_G_MULTI_RNDIS
-	bool "RNDIS + CDC Serial + Storage configuration"
+config USB_G_MULTI_ANYTHING
+	bool
 	depends on USB_G_MULTI
+
+config USB_G_MULTI_RNDIS
+	bool "Include RNDIS function"
+	depends on USB_G_MULTI && NET
+	select USB_G_MULTI_ANYTHING
 	default y
 	help
-	  This option enables a configuration with RNDIS, CDC Serial and
-	  Mass Storage functions available in the Multifunction Composite
-	  Gadget.  This is the configuration dedicated for Windows since RNDIS
-	  is Microsoft's protocol.
+	  This option enables the RNDIS (Ethernet) function.  It is
+	  protocol dedicated for Windows since it's Microsoft's invention.
+
+	  If you select also CDC ECM function gadget will have two
+	  configurations one with RNDIS and another with CDC ECM.
+
+	  If unsure, say "y".
+
+config USB_G_MULTI_ECM
+	bool "Include CDC ECM function"
+	depends on USB_G_MULTI && NET
+	select USB_G_MULTI_ANYTHING
+	help
+	  This option enables the CDC ECM (Ethernet) function.
+
+	  If you select also RNDIS function gadget will have two
+	  configurations one with RNDIS and another with CDC ECM.
 
 	  If unsure, say "y".
 
-config USB_G_MULTI_CDC
-	bool "CDC Ethernet + CDC Serial + Storage configuration"
+config USB_G_MULTI_ACM
+	bool "Include CDC ACM function"
 	depends on USB_G_MULTI
-	default n
+	default y
+	help
+	  This option enables the CDC ACM (serial) function.
+
+	  If unsure, say "y".
+
+config USB_G_MULTI_MSF
+	bool "Include mass storage function"
+	depends on USB_G_MULTI && BLOCK
+	select USB_G_MULTI_ANYTHING
+	default y
 	help
-	  This option enables a configuration with CDC Ethernet (ECM), CDC
-	  Serial and Mass Storage functions available in the Multifunction
-	  Composite Gadget.
+	  This option enables the mass storage (or UMS) function.
 
 	  If unsure, say "y".
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index c7a5b58..6f6fd3e 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -57,19 +57,57 @@ MODULE_LICENSE("GPL");
 #include "config.c"
 #include "epautoconf.c"
 
-#include "f_mass_storage.c"
+/* Mass storage */
+#ifdef CONFIG_USB_G_MULTI_MSF
+#  include "f_mass_storage.c"
 
-#include "u_serial.c"
-#include "f_acm.c"
+static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
+FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
+
+static struct fsg_common fsg_common;
+#else
+#  define fsg_common_from_params(common, cdev, data) NULL
+#  define fsg_bind_config(cdev, conf, common)        ((int)0)
+#  define fsg_common_put(common)            do { } while (0)
+#endif
 
-#include "f_ecm.c"
-#include "f_subset.c"
-#ifdef USB_ETH_RNDIS
+/* CDC ACM */
+#ifdef CONFIG_USB_G_MULTI_ACM
+#  include "u_serial.c"
+#  include "f_acm.c"
+#else
+#  define gserial_setup(conf, ports)        ((int)0)
+#  define gserial_cleanup()                 do { } while (0)
+#  define acm_bind_config(conf, ports)      ((int)0)
+#endif
+
+/* Ethernet */
+#ifdef CONFIG_USB_G_MULTI_ECM
+#  include "f_ecm.c"
+#  include "f_subset.c"
+#endif
+
+#ifdef CONFIG_USB_G_MULTI_RNDIS
 #  include "f_rndis.c"
 #  include "rndis.c"
 #endif
-#include "u_ether.c"
 
+#if defined CONFIG_USB_G_MULTI_ECM || defined CONFIG_USB_G_MULTI_RNDIS
+#  include "u_ether.c"
+static u8 hostaddr[ETH_ALEN];
+#else
+#  define gether_setup(cdev, hostaddr) ((int)0)
+#  define gether_cleanup()             do { } while (0)
+#endif
+
+#ifndef CONFIG_USB_G_MULTI_ECM
+#  define can_support_ecm(gadget)           true
+#  define ecm_bind_config(conf, ethaddr)    ((int)0)
+#endif
+
+#ifndef CONFIG_USB_G_MULTI_RNDIS
+#  define rndis_bind_config(conf, ethaddr)  ((int)0)
+#endif
 
 
 /***************************** Device Descriptor ****************************/
@@ -78,19 +116,6 @@ MODULE_LICENSE("GPL");
 #define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
 
 
-enum {
-	__MULTI_NO_CONFIG,
-#ifdef CONFIG_USB_G_MULTI_RNDIS
-	MULTI_RNDIS_CONFIG_NUM,
-#endif
-#ifdef CONFIG_USB_G_MULTI_CDC
-	MULTI_CDC_CONFIG_NUM,
-#endif
-	__MULTI_NUM_CONFIGS_HELPER,
-	MULTI_NUM_CONFIGS = __MULTI_NUM_CONFIGS_HELPER - 1
-};
-
-
 static struct usb_device_descriptor device_desc = {
 	.bLength =		sizeof device_desc,
 	.bDescriptorType =	USB_DT_DEVICE,
@@ -104,7 +129,11 @@ static struct usb_device_descriptor device_desc = {
 	/* Vendor and product id can be overridden by module parameters.  */
 	.idVendor =		cpu_to_le16(MULTI_VENDOR_NUM),
 	.idProduct =		cpu_to_le16(MULTI_PRODUCT_NUM),
-	.bNumConfigurations =	MULTI_NUM_CONFIGS,
+#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
+	.bNumConfigurations =	2,
+#else
+	.bNumConfigurations =	1,
+#endif
 };
 
 
@@ -124,12 +153,6 @@ static const struct usb_descriptor_header *otg_desc[] = {
 enum {
 	MULTI_STRING_MANUFACTURER_IDX,
 	MULTI_STRING_PRODUCT_IDX,
-#ifdef CONFIG_USB_G_MULTI_RNDIS
-	MULTI_STRING_RNDIS_CONFIG_IDX,
-#endif
-#ifdef CONFIG_USB_G_MULTI_CDC
-	MULTI_STRING_CDC_CONFIG_IDX,
-#endif
 };
 
 static char manufacturer[50];
@@ -137,12 +160,6 @@ static char manufacturer[50];
 static struct usb_string strings_dev[] = {
 	[MULTI_STRING_MANUFACTURER_IDX].s = manufacturer,
 	[MULTI_STRING_PRODUCT_IDX].s      = DRIVER_DESC,
-#ifdef CONFIG_USB_G_MULTI_RNDIS
-	[MULTI_STRING_RNDIS_CONFIG_IDX].s = "Multifunction with RNDIS",
-#endif
-#ifdef CONFIG_USB_G_MULTI_CDC
-	[MULTI_STRING_CDC_CONFIG_IDX].s   = "Multifunction with CDC ECM",
-#endif
 	{  } /* end of list */
 };
 
@@ -159,19 +176,8 @@ static struct usb_gadget_strings *dev_strings[] = {
 
 /****************************** Configurations ******************************/
 
-static struct fsg_module_parameters fsg_mod_data = { .stall = 1 };
-FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
 
-static struct fsg_common fsg_common;
-
-static u8 hostaddr[ETH_ALEN];
-
-
-/********** RNDIS **********/
-
-#ifdef USB_ETH_RNDIS
-
-static __ref int rndis_do_config(struct usb_configuration *c)
+static __ref int first_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -180,7 +186,11 @@ static __ref int rndis_do_config(struct usb_configuration *c)
 		c->bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 	}
 
+#ifdef CONFIG_USB_G_MULTI_RNDIS
 	ret = rndis_bind_config(c, hostaddr);
+#else
+	ret = ecm_bind_config(c, hostaddr);
+#endif
 	if (ret < 0)
 		return ret;
 
@@ -195,35 +205,17 @@ static __ref int rndis_do_config(struct usb_configuration *c)
 	return 0;
 }
 
-static int rndis_config_register(struct usb_composite_dev *cdev)
-{
-	static struct usb_configuration config = {
-		.bind			= rndis_do_config,
-		.bConfigurationValue	= MULTI_RNDIS_CONFIG_NUM,
-		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-	};
-
-	config.label          = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].s;
-	config.iConfiguration = strings_dev[MULTI_STRING_RNDIS_CONFIG_IDX].id;
-
-	return usb_add_config(cdev, &config);
-}
-
-#else
-
-static int rndis_config_register(struct usb_composite_dev *cdev)
-{
-	return 0;
-}
-
-#endif
-
+static struct usb_configuration first_config_driver = {
+	.label			= "First Configuration",
+	.bind			= first_do_config,
+	.bConfigurationValue	= 1,
+	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+};
 
-/********** CDC ECM **********/
 
-#ifdef CONFIG_USB_G_MULTI_CDC
+#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
 
-static __ref int cdc_do_config(struct usb_configuration *c)
+static __ref int second_do_config(struct usb_configuration *c)
 {
 	int ret;
 
@@ -247,26 +239,12 @@ static __ref int cdc_do_config(struct usb_configuration *c)
 	return 0;
 }
 
-static int cdc_config_register(struct usb_composite_dev *cdev)
-{
-	static struct usb_configuration config = {
-		.bind			= cdc_do_config,
-		.bConfigurationValue	= MULTI_CDC_CONFIG_NUM,
-		.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
-	};
-
-	config.label          = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].s;
-	config.iConfiguration = strings_dev[MULTI_STRING_CDC_CONFIG_IDX].id;
-
-	return usb_add_config(cdev, &config);
-}
-
-#else
-
-static int cdc_config_register(struct usb_composite_dev *cdev)
-{
-	return 0;
-}
+static struct usb_configuration second_config_driver = {
+	.label			= "Second Configuration",
+	.bind			= second_do_config,
+	.bConfigurationValue	= 2,
+	.bmAttributes		= USB_CONFIG_ATT_SELFPOWER,
+};
 
 #endif
 
@@ -331,13 +309,15 @@ static int __ref multi_bind(struct usb_composite_dev *cdev)
 		strings_dev[MULTI_STRING_PRODUCT_IDX].id;
 
 	/* register configurations */
-	status = rndis_config_register(cdev);
+	status = usb_add_config(cdev, &first_config_driver);
 	if (unlikely(status < 0))
 		goto fail2;
 
-	status = cdc_config_register(cdev);
+#if defined CONFIG_USB_G_MULTI_RNDIS && defined CONFIG_USB_G_MULTI_ECM
+	status = usb_add_config(cdev, &second_config_driver);
 	if (unlikely(status < 0))
 		goto fail2;
+#endif
 
 	/* we're done */
 	dev_info(&gadget->dev, DRIVER_DESC "\n");
-- 
1.7.1

