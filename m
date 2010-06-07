Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0FGMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:39:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56223 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0FGMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 07 Jun 2010 14:39:57 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 10/13] USB: gadget: g_multi: more configurable
In-reply-to: <9fe3db6d72e8376ece39bbe4f5ac9c8cd863af4c.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <b2b534da1e741bd0438e5e13df65aa7e2be72a7c.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
 <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
 <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
 <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
 <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
 <9fe3db6d72e8376ece39bbe4f5ac9c8cd863af4c.1275906835.git.m.nazarewicz@samsung.com>
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
index 0bd9139..ac3c547 100644
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
 
@@ -81,11 +82,11 @@ Similarly, [[file:linux-cdc-acm.inf]] is provided for CDC ACM.
 
 **** Customising the gadget
 
-If you intend to hack the g_multi gadget be advised that rearranging
-functions will obviously change interface numbers for each of the
-functionality.  As an effect provided INFs won't work since they have
-interface numbers hard-coded in them (it's not hard to change those
-though[7]).
+If you intend to customise (via Kconfig) or hack the g_multi gadget be
+advised that rearranging functions will obviously change interface
+numbers for each of the functionality.  As an effect provided INFs
+won't work since they have interface numbers hard-coded in them (it's
+not hard to change those though[7]).
 
 This also means, that after experimenting with g_multi and changing
 provided functions one should change gadget's vendor and/or product ID
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 027f61b..6bf6c5c 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -862,43 +862,62 @@ config USB_G_NOKIA
 
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

