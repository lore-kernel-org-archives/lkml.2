Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0ESJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:04:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0ESJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:05 -0400
Date: Wed, 19 May 2010 11:04:21 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 7/8] USB: gadget: g_multi: more configurable
In-reply-to: <785cc2b8e47bacfa2ec25b9ed6cec4abc0326b64.1274187425.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <2460ac80ee51e759c7d4d552112c2e816db7c83b.1274187425.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
 <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
 <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
 <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
 <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
 <785cc2b8e47bacfa2ec25b9ed6cec4abc0326b64.1274187425.git.m.nazarewicz@samsung.com>
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
 drivers/usb/gadget/Kconfig |   67 +++++++++++------
 drivers/usb/gadget/multi.c |  166 +++++++++++++++++++------------------------
 2 files changed, 116 insertions(+), 117 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 1a3270d..1309e46 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -861,43 +861,62 @@ config USB_G_NOKIA
 
 config USB_G_MULTI
 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
-	depends on BLOCK && NET
-	select USB_G_MULTI_CDC if ! USB_G_MULTI_RNDIS
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
index cd7d1c1..454622e 100644
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
 	[MULTI_STRING_PRODUCT_IDX     ].s = DRIVER_DESC,
-#ifdef CONFIG_USB_G_MULTI_RNDIS
-	[MULTI_STRING_RNDIS_CONFIG_IDX].s = "Multifunction with RNDIS",
-#endif
-#ifdef CONFIG_USB_G_MULTI_CDC
-	[MULTI_STRING_CDC_CONFIG_IDX  ].s = "Multifunction with CDC ECM",
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

