Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0DITXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:23:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19726 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab0DITVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:21:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 09 Apr 2010 21:21:20 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 3/8] USB: gadget: __init and __exit tags removed
In-reply-to: <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
References: <cover.1270835924.git.mina86@mina86.com>
 <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
 <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init, __initdata and __exit tags have have been removed from
various files to make it possible for gadgets that do not use
the __init/__exit tags to use those.

Files in question are related to:
* the core composite framework,
* the mass storage function (fixing a section mismatch) and
* ethernet driver (ACM, ECM, RNDIS).

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/composite.c      |   21 ++++++++++-----------
 drivers/usb/gadget/config.c         |    4 ++--
 drivers/usb/gadget/epautoconf.c     |   12 ++++++------
 drivers/usb/gadget/f_acm.c          |   32 ++++++++++++++++----------------
 drivers/usb/gadget/f_ecm.c          |   33 +++++++++++++++++----------------
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/f_rndis.c        |   34 ++++++++++++++++++----------------
 drivers/usb/gadget/u_ether.c        |    4 ++--
 8 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 09289bb..ff155ca 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -85,7 +85,7 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
  * This function returns the value of the function's bind(), which is
  * zero for success else a negative errno value.
  */
-int __init usb_add_function(struct usb_configuration *config,
+int __cold usb_add_function(struct usb_configuration *config,
 		struct usb_function *function)
 {
 	int	value = -EINVAL;
@@ -215,7 +215,7 @@ int usb_function_activate(struct usb_function *function)
  * Returns the interface ID which was allocated; or -ENODEV if no
  * more interface IDs can be allocated.
  */
-int __init usb_interface_id(struct usb_configuration *config,
+int __cold usb_interface_id(struct usb_configuration *config,
 		struct usb_function *function)
 {
 	unsigned id = config->next_interface_id;
@@ -480,7 +480,7 @@ done:
  * assigns global resources including string IDs, and per-configuration
  * resources such as interface IDs and endpoints.
  */
-int __init usb_add_config(struct usb_composite_dev *cdev,
+int __cold usb_add_config(struct usb_composite_dev *cdev,
 		struct usb_configuration *config)
 {
 	int				status = -EINVAL;
@@ -677,7 +677,7 @@ static int get_string(struct usb_composite_dev *cdev,
  * ensure that for example different functions don't wrongly assign
  * different meanings to the same identifier.
  */
-int __init usb_string_id(struct usb_composite_dev *cdev)
+int __cold usb_string_id(struct usb_composite_dev *cdev)
 {
 	if (cdev->next_string_id < 254) {
 		/* string id 0 is reserved */
@@ -898,7 +898,7 @@ static void composite_disconnect(struct usb_gadget *gadget)
 
 /*-------------------------------------------------------------------------*/
 
-static void /* __init_or_exit */
+static void __cold
 composite_unbind(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
@@ -947,7 +947,7 @@ composite_unbind(struct usb_gadget *gadget)
 	composite = NULL;
 }
 
-static void __init
+static void __cold
 string_override_one(struct usb_gadget_strings *tab, u8 id, const char *s)
 {
 	struct usb_string		*str = tab->strings;
@@ -960,7 +960,7 @@ string_override_one(struct usb_gadget_strings *tab, u8 id, const char *s)
 	}
 }
 
-static void __init
+static void __cold
 string_override(struct usb_gadget_strings **tab, u8 id, const char *s)
 {
 	while (*tab) {
@@ -969,7 +969,7 @@ string_override(struct usb_gadget_strings **tab, u8 id, const char *s)
 	}
 }
 
-static int __init composite_bind(struct usb_gadget *gadget)
+static int __cold composite_bind(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev;
 	int				status = -ENOMEM;
@@ -1092,7 +1092,6 @@ static struct usb_gadget_driver composite_driver = {
 	.speed		= USB_SPEED_HIGH,
 
 	.bind		= composite_bind,
-	/* .unbind		= __exit_p(composite_unbind), */
 	.unbind		= composite_unbind,
 
 	.setup		= composite_setup,
@@ -1121,7 +1120,7 @@ static struct usb_gadget_driver composite_driver = {
  * while it was binding.  That would usually be done in order to wait for
  * some userspace participation.
  */
-int __init usb_composite_register(struct usb_composite_driver *driver)
+int __cold usb_composite_register(struct usb_composite_driver *driver)
 {
 	if (!driver || !driver->dev || !driver->bind || composite)
 		return -EINVAL;
@@ -1142,7 +1141,7 @@ int __init usb_composite_register(struct usb_composite_driver *driver)
  * This function is used to unregister drivers using the composite
  * driver framework.
  */
-void /* __exit */ usb_composite_unregister(struct usb_composite_driver *driver)
+void __cold usb_composite_unregister(struct usb_composite_driver *driver)
 {
 	if (composite != driver)
 		return;
diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index e1191b9..a256138 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -127,7 +127,7 @@ int usb_gadget_config_buf(
  * with identifiers (for interfaces, strings, endpoints, and more)
  * as needed by a given function instance.
  */
-struct usb_descriptor_header **__init
+struct usb_descriptor_header **__cold
 usb_copy_descriptors(struct usb_descriptor_header **src)
 {
 	struct usb_descriptor_header **tmp;
@@ -174,7 +174,7 @@ usb_copy_descriptors(struct usb_descriptor_header **src)
  * intended use is to help remembering the endpoint descriptor to use
  * when enabling a given endpoint.
  */
-struct usb_endpoint_descriptor *__init
+struct usb_endpoint_descriptor *__cold
 usb_find_endpoint(
 	struct usb_descriptor_header **src,
 	struct usb_descriptor_header **copy,
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 3568de2..dceaa35 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -34,12 +34,12 @@
 
 
 /* we must assign addresses for configurable endpoints (like net2280) */
-static __initdata unsigned epnum;
+static unsigned epnum;
 
 // #define MANY_ENDPOINTS
 #ifdef MANY_ENDPOINTS
 /* more than 15 configurable endpoints */
-static __initdata unsigned in_epnum;
+static unsigned in_epnum;
 #endif
 
 
@@ -59,7 +59,7 @@ static __initdata unsigned in_epnum;
  * NOTE:  each endpoint is unidirectional, as specified by its USB
  * descriptor; and isn't specific to a configuration or altsetting.
  */
-static int __init
+static int __cold
 ep_matches (
 	struct usb_gadget		*gadget,
 	struct usb_ep			*ep,
@@ -187,7 +187,7 @@ ep_matches (
 	return 1;
 }
 
-static struct usb_ep * __init
+static struct usb_ep *__cold
 find_ep (struct usb_gadget *gadget, const char *name)
 {
 	struct usb_ep	*ep;
@@ -229,7 +229,7 @@ find_ep (struct usb_gadget *gadget, const char *name)
  *
  * On failure, this returns a null endpoint descriptor.
  */
-struct usb_ep * __init usb_ep_autoconfig (
+struct usb_ep *__cold usb_ep_autoconfig (
 	struct usb_gadget		*gadget,
 	struct usb_endpoint_descriptor	*desc
 )
@@ -304,7 +304,7 @@ struct usb_ep * __init usb_ep_autoconfig (
  * state such as ep->driver_data and the record of assigned endpoints
  * used by usb_ep_autoconfig().
  */
-void __init usb_ep_autoconfig_reset (struct usb_gadget *gadget)
+void __cold usb_ep_autoconfig_reset (struct usb_gadget *gadget)
 {
 	struct usb_ep	*ep;
 
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index e49c732..a098ff3 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -115,7 +115,7 @@ acm_iad_descriptor = {
 };
 
 
-static struct usb_interface_descriptor acm_control_interface_desc __initdata = {
+static struct usb_interface_descriptor acm_control_interface_desc = {
 	.bLength =		USB_DT_INTERFACE_SIZE,
 	.bDescriptorType =	USB_DT_INTERFACE,
 	/* .bInterfaceNumber = DYNAMIC */
@@ -126,7 +126,7 @@ static struct usb_interface_descriptor acm_control_interface_desc __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_interface_descriptor acm_data_interface_desc __initdata = {
+static struct usb_interface_descriptor acm_data_interface_desc = {
 	.bLength =		USB_DT_INTERFACE_SIZE,
 	.bDescriptorType =	USB_DT_INTERFACE,
 	/* .bInterfaceNumber = DYNAMIC */
@@ -137,7 +137,7 @@ static struct usb_interface_descriptor acm_data_interface_desc __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc acm_header_desc __initdata = {
+static struct usb_cdc_header_desc acm_header_desc = {
 	.bLength =		sizeof(acm_header_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -145,7 +145,7 @@ static struct usb_cdc_header_desc acm_header_desc __initdata = {
 };
 
 static struct usb_cdc_call_mgmt_descriptor
-acm_call_mgmt_descriptor __initdata = {
+acm_call_mgmt_descriptor = {
 	.bLength =		sizeof(acm_call_mgmt_descriptor),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_CALL_MANAGEMENT_TYPE,
@@ -153,14 +153,14 @@ acm_call_mgmt_descriptor __initdata = {
 	/* .bDataInterface = DYNAMIC */
 };
 
-static struct usb_cdc_acm_descriptor acm_descriptor __initdata = {
+static struct usb_cdc_acm_descriptor acm_descriptor = {
 	.bLength =		sizeof(acm_descriptor),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ACM_TYPE,
 	.bmCapabilities =	USB_CDC_CAP_LINE,
 };
 
-static struct usb_cdc_union_desc acm_union_desc __initdata = {
+static struct usb_cdc_union_desc acm_union_desc = {
 	.bLength =		sizeof(acm_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -170,7 +170,7 @@ static struct usb_cdc_union_desc acm_union_desc __initdata = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor acm_fs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
@@ -179,21 +179,21 @@ static struct usb_endpoint_descriptor acm_fs_notify_desc __initdata = {
 	.bInterval =		1 << GS_LOG2_NOTIFY_INTERVAL,
 };
 
-static struct usb_endpoint_descriptor acm_fs_in_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor acm_fs_out_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_OUT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *acm_fs_function[] __initdata = {
+static struct usb_descriptor_header *acm_fs_function[] = {
 	(struct usb_descriptor_header *) &acm_iad_descriptor,
 	(struct usb_descriptor_header *) &acm_control_interface_desc,
 	(struct usb_descriptor_header *) &acm_header_desc,
@@ -209,7 +209,7 @@ static struct usb_descriptor_header *acm_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor acm_hs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
@@ -218,21 +218,21 @@ static struct usb_endpoint_descriptor acm_hs_notify_desc __initdata = {
 	.bInterval =		GS_LOG2_NOTIFY_INTERVAL+4,
 };
 
-static struct usb_endpoint_descriptor acm_hs_in_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor acm_hs_out_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *acm_hs_function[] __initdata = {
+static struct usb_descriptor_header *acm_hs_function[] = {
 	(struct usb_descriptor_header *) &acm_iad_descriptor,
 	(struct usb_descriptor_header *) &acm_control_interface_desc,
 	(struct usb_descriptor_header *) &acm_header_desc,
@@ -570,7 +570,7 @@ static int acm_send_break(struct gserial *port, int duration)
 /*-------------------------------------------------------------------------*/
 
 /* ACM function driver setup/binding */
-static int __init
+static int __cold
 acm_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -718,7 +718,7 @@ static inline bool can_support_cdc(struct usb_configuration *c)
  * handle all the ones it binds.  Caller is also responsible
  * for calling @gserial_cleanup() before module unload.
  */
-int __init acm_bind_config(struct usb_configuration *c, u8 port_num)
+int __cold acm_bind_config(struct usb_configuration *c, u8 port_num)
 {
 	struct f_acm	*acm;
 	int		status;
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 2fff530..e24ced7 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -112,7 +112,7 @@ static inline unsigned ecm_bitrate(struct usb_gadget *g)
 
 /* interface descriptor: */
 
-static struct usb_interface_descriptor ecm_control_intf __initdata = {
+static struct usb_interface_descriptor ecm_control_intf = {
 	.bLength =		sizeof ecm_control_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -125,7 +125,7 @@ static struct usb_interface_descriptor ecm_control_intf __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc ecm_header_desc __initdata = {
+static struct usb_cdc_header_desc ecm_header_desc = {
 	.bLength =		sizeof ecm_header_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -133,7 +133,7 @@ static struct usb_cdc_header_desc ecm_header_desc __initdata = {
 	.bcdCDC =		cpu_to_le16(0x0110),
 };
 
-static struct usb_cdc_union_desc ecm_union_desc __initdata = {
+static struct usb_cdc_union_desc ecm_union_desc = {
 	.bLength =		sizeof(ecm_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -141,7 +141,7 @@ static struct usb_cdc_union_desc ecm_union_desc __initdata = {
 	/* .bSlaveInterface0 =	DYNAMIC */
 };
 
-static struct usb_cdc_ether_desc ecm_desc __initdata = {
+static struct usb_cdc_ether_desc ecm_desc = {
 	.bLength =		sizeof ecm_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ETHERNET_TYPE,
@@ -156,7 +156,7 @@ static struct usb_cdc_ether_desc ecm_desc __initdata = {
 
 /* the default data interface has no endpoints ... */
 
-static struct usb_interface_descriptor ecm_data_nop_intf __initdata = {
+static struct usb_interface_descriptor ecm_data_nop_intf = {
 	.bLength =		sizeof ecm_data_nop_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -171,7 +171,7 @@ static struct usb_interface_descriptor ecm_data_nop_intf __initdata = {
 
 /* ... but the "real" data interface has two bulk endpoints */
 
-static struct usb_interface_descriptor ecm_data_intf __initdata = {
+static struct usb_interface_descriptor ecm_data_intf = {
 	.bLength =		sizeof ecm_data_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -186,7 +186,7 @@ static struct usb_interface_descriptor ecm_data_intf __initdata = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor fs_ecm_notify_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -196,7 +196,7 @@ static struct usb_endpoint_descriptor fs_ecm_notify_desc __initdata = {
 	.bInterval =		1 << LOG2_STATUS_INTERVAL_MSEC,
 };
 
-static struct usb_endpoint_descriptor fs_ecm_in_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -204,7 +204,7 @@ static struct usb_endpoint_descriptor fs_ecm_in_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor fs_ecm_out_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -212,7 +212,7 @@ static struct usb_endpoint_descriptor fs_ecm_out_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *ecm_fs_function[] __initdata = {
+static struct usb_descriptor_header *ecm_fs_function[] = {
 	/* CDC ECM control descriptors */
 	(struct usb_descriptor_header *) &ecm_control_intf,
 	(struct usb_descriptor_header *) &ecm_header_desc,
@@ -230,7 +230,7 @@ static struct usb_descriptor_header *ecm_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor hs_ecm_notify_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -239,7 +239,7 @@ static struct usb_endpoint_descriptor hs_ecm_notify_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(ECM_STATUS_BYTECOUNT),
 	.bInterval =		LOG2_STATUS_INTERVAL_MSEC + 4,
 };
-static struct usb_endpoint_descriptor hs_ecm_in_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -248,7 +248,7 @@ static struct usb_endpoint_descriptor hs_ecm_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor hs_ecm_out_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -257,7 +257,7 @@ static struct usb_endpoint_descriptor hs_ecm_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *ecm_hs_function[] __initdata = {
+static struct usb_descriptor_header *ecm_hs_function[] = {
 	/* CDC ECM control descriptors */
 	(struct usb_descriptor_header *) &ecm_control_intf,
 	(struct usb_descriptor_header *) &ecm_header_desc,
@@ -596,7 +596,7 @@ static void ecm_close(struct gether *geth)
 
 /* ethernet function driver setup/binding */
 
-static int __init
+static int __cold
 ecm_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -762,7 +762,8 @@ ecm_unbind(struct usb_configuration *c, struct usb_function *f)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init ecm_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int __cold
+ecm_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_ecm	*ecm;
 	int		status;
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..e1d1454 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2910,7 +2910,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 }
 
 
-static int __init fsg_bind(struct usb_configuration *c, struct usb_function *f)
+static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct fsg_dev		*fsg = fsg_from_func(f);
 	struct usb_gadget	*gadget = c->cdev->gadget;
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index a30e60c..c1d6985 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -121,7 +121,7 @@ static unsigned int bitrate(struct usb_gadget *g)
 
 /* interface descriptor: */
 
-static struct usb_interface_descriptor rndis_control_intf __initdata = {
+static struct usb_interface_descriptor rndis_control_intf = {
 	.bLength =		sizeof rndis_control_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -134,7 +134,7 @@ static struct usb_interface_descriptor rndis_control_intf __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc header_desc __initdata = {
+static struct usb_cdc_header_desc header_desc = {
 	.bLength =		sizeof header_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -142,7 +142,8 @@ static struct usb_cdc_header_desc header_desc __initdata = {
 	.bcdCDC =		cpu_to_le16(0x0110),
 };
 
-static struct usb_cdc_call_mgmt_descriptor call_mgmt_descriptor __initdata = {
+static struct usb_cdc_call_mgmt_descriptor
+call_mgmt_descriptor = {
 	.bLength =		sizeof call_mgmt_descriptor,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_CALL_MANAGEMENT_TYPE,
@@ -151,7 +152,7 @@ static struct usb_cdc_call_mgmt_descriptor call_mgmt_descriptor __initdata = {
 	.bDataInterface =	0x01,
 };
 
-static struct usb_cdc_acm_descriptor rndis_acm_descriptor __initdata = {
+static struct usb_cdc_acm_descriptor rndis_acm_descriptor = {
 	.bLength =		sizeof rndis_acm_descriptor,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ACM_TYPE,
@@ -159,7 +160,7 @@ static struct usb_cdc_acm_descriptor rndis_acm_descriptor __initdata = {
 	.bmCapabilities =	0x00,
 };
 
-static struct usb_cdc_union_desc rndis_union_desc __initdata = {
+static struct usb_cdc_union_desc rndis_union_desc = {
 	.bLength =		sizeof(rndis_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -169,7 +170,7 @@ static struct usb_cdc_union_desc rndis_union_desc __initdata = {
 
 /* the data interface has two bulk endpoints */
 
-static struct usb_interface_descriptor rndis_data_intf __initdata = {
+static struct usb_interface_descriptor rndis_data_intf = {
 	.bLength =		sizeof rndis_data_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -197,7 +198,7 @@ rndis_iad_descriptor = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor fs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor fs_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -207,7 +208,7 @@ static struct usb_endpoint_descriptor fs_notify_desc __initdata = {
 	.bInterval =		1 << LOG2_STATUS_INTERVAL_MSEC,
 };
 
-static struct usb_endpoint_descriptor fs_in_desc __initdata = {
+static struct usb_endpoint_descriptor fs_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -215,7 +216,7 @@ static struct usb_endpoint_descriptor fs_in_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor fs_out_desc __initdata = {
+static struct usb_endpoint_descriptor fs_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -223,7 +224,7 @@ static struct usb_endpoint_descriptor fs_out_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *eth_fs_function[] __initdata = {
+static struct usb_descriptor_header *eth_fs_function[] = {
 	(struct usb_descriptor_header *) &rndis_iad_descriptor,
 	/* control interface matches ACM, not Ethernet */
 	(struct usb_descriptor_header *) &rndis_control_intf,
@@ -241,7 +242,7 @@ static struct usb_descriptor_header *eth_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor hs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor hs_notify_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -250,7 +251,7 @@ static struct usb_endpoint_descriptor hs_notify_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(STATUS_BYTECOUNT),
 	.bInterval =		LOG2_STATUS_INTERVAL_MSEC + 4,
 };
-static struct usb_endpoint_descriptor hs_in_desc __initdata = {
+static struct usb_endpoint_descriptor hs_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -259,7 +260,7 @@ static struct usb_endpoint_descriptor hs_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor hs_out_desc __initdata = {
+static struct usb_endpoint_descriptor hs_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -268,7 +269,7 @@ static struct usb_endpoint_descriptor hs_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *eth_hs_function[] __initdata = {
+static struct usb_descriptor_header *eth_hs_function[] = {
 	(struct usb_descriptor_header *) &rndis_iad_descriptor,
 	/* control interface matches ACM, not Ethernet */
 	(struct usb_descriptor_header *) &rndis_control_intf,
@@ -593,7 +594,7 @@ static void rndis_close(struct gether *geth)
 
 /* ethernet function driver setup/binding */
 
-static int __init
+static int __cold
 rndis_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -785,7 +786,8 @@ static inline bool can_support_rndis(struct usb_configuration *c)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init rndis_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int __cold
+rndis_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_rndis	*rndis;
 	int		status;
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 84ca195..e629d91 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -714,7 +714,7 @@ static u8 __init nibble(unsigned char c)
 	return 0;
 }
 
-static int __init get_ether_addr(const char *str, u8 *dev_addr)
+static int __cold get_ether_addr(const char *str, u8 *dev_addr)
 {
 	if (str) {
 		unsigned	i;
@@ -763,7 +763,7 @@ static struct device_type gadget_type = {
  *
  * Returns negative errno, or zero on success
  */
-int __init gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
+int __cold gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
 {
 	struct eth_dev		*dev;
 	struct net_device	*net;
-- 
1.7.0

