Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0DGNnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:43:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26250 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0DGNmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:22 -0400
Date: Wed, 07 Apr 2010 15:41:31 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 4/8] USB: Ethernet: allow optional removal of __init and
 __init_data tags
In-reply-to: <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the __usb_init and __usb_initdata tags in Ethernet
composite function related files to allow disabling the init
section micro-optimisation in drivers that require this.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/f_acm.c   |   34 ++++++++++++++++++----------------
 drivers/usb/gadget/f_ecm.c   |   33 +++++++++++++++++----------------
 drivers/usb/gadget/f_rndis.c |   34 ++++++++++++++++++----------------
 drivers/usb/gadget/u_ether.c |    6 ++++--
 4 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 400e1eb..449296c 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -116,7 +116,8 @@ acm_iad_descriptor = {
 };
 
 
-static struct usb_interface_descriptor acm_control_interface_desc __initdata = {
+static struct usb_interface_descriptor
+acm_control_interface_desc __usb_initdata = {
 	.bLength =		USB_DT_INTERFACE_SIZE,
 	.bDescriptorType =	USB_DT_INTERFACE,
 	/* .bInterfaceNumber = DYNAMIC */
@@ -127,7 +128,8 @@ static struct usb_interface_descriptor acm_control_interface_desc __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_interface_descriptor acm_data_interface_desc __initdata = {
+static struct usb_interface_descriptor
+acm_data_interface_desc __usb_initdata = {
 	.bLength =		USB_DT_INTERFACE_SIZE,
 	.bDescriptorType =	USB_DT_INTERFACE,
 	/* .bInterfaceNumber = DYNAMIC */
@@ -138,7 +140,7 @@ static struct usb_interface_descriptor acm_data_interface_desc __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc acm_header_desc __initdata = {
+static struct usb_cdc_header_desc acm_header_desc __usb_initdata = {
 	.bLength =		sizeof(acm_header_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -146,7 +148,7 @@ static struct usb_cdc_header_desc acm_header_desc __initdata = {
 };
 
 static struct usb_cdc_call_mgmt_descriptor
-acm_call_mgmt_descriptor __initdata = {
+acm_call_mgmt_descriptor __usb_initdata = {
 	.bLength =		sizeof(acm_call_mgmt_descriptor),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_CALL_MANAGEMENT_TYPE,
@@ -154,14 +156,14 @@ acm_call_mgmt_descriptor __initdata = {
 	/* .bDataInterface = DYNAMIC */
 };
 
-static struct usb_cdc_acm_descriptor acm_descriptor __initdata = {
+static struct usb_cdc_acm_descriptor acm_descriptor __usb_initdata = {
 	.bLength =		sizeof(acm_descriptor),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ACM_TYPE,
 	.bmCapabilities =	USB_CDC_CAP_LINE,
 };
 
-static struct usb_cdc_union_desc acm_union_desc __initdata = {
+static struct usb_cdc_union_desc acm_union_desc __usb_initdata = {
 	.bLength =		sizeof(acm_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -171,7 +173,7 @@ static struct usb_cdc_union_desc acm_union_desc __initdata = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor acm_fs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
@@ -180,21 +182,21 @@ static struct usb_endpoint_descriptor acm_fs_notify_desc __initdata = {
 	.bInterval =		1 << GS_LOG2_NOTIFY_INTERVAL,
 };
 
-static struct usb_endpoint_descriptor acm_fs_in_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor acm_fs_out_desc __initdata = {
+static struct usb_endpoint_descriptor acm_fs_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_OUT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *acm_fs_function[] __initdata = {
+static struct usb_descriptor_header *acm_fs_function[] __usb_initdata = {
 	(struct usb_descriptor_header *) &acm_iad_descriptor,
 	(struct usb_descriptor_header *) &acm_control_interface_desc,
 	(struct usb_descriptor_header *) &acm_header_desc,
@@ -210,7 +212,7 @@ static struct usb_descriptor_header *acm_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor acm_hs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bEndpointAddress =	USB_DIR_IN,
@@ -219,21 +221,21 @@ static struct usb_endpoint_descriptor acm_hs_notify_desc __initdata = {
 	.bInterval =		GS_LOG2_NOTIFY_INTERVAL+4,
 };
 
-static struct usb_endpoint_descriptor acm_hs_in_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor acm_hs_out_desc __initdata = {
+static struct usb_endpoint_descriptor acm_hs_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *acm_hs_function[] __initdata = {
+static struct usb_descriptor_header *acm_hs_function[] __usb_initdata = {
 	(struct usb_descriptor_header *) &acm_iad_descriptor,
 	(struct usb_descriptor_header *) &acm_control_interface_desc,
 	(struct usb_descriptor_header *) &acm_header_desc,
@@ -571,7 +573,7 @@ static int acm_send_break(struct gserial *port, int duration)
 /*-------------------------------------------------------------------------*/
 
 /* ACM function driver setup/binding */
-static int __init
+static int __usb_init
 acm_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -719,7 +721,7 @@ static inline bool can_support_cdc(struct usb_configuration *c)
  * handle all the ones it binds.  Caller is also responsible
  * for calling @gserial_cleanup() before module unload.
  */
-int __init acm_bind_config(struct usb_configuration *c, u8 port_num)
+int __usb_init acm_bind_config(struct usb_configuration *c, u8 port_num)
 {
 	struct f_acm	*acm;
 	int		status;
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 4e59532..c880d45 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -113,7 +113,7 @@ static inline unsigned ecm_bitrate(struct usb_gadget *g)
 
 /* interface descriptor: */
 
-static struct usb_interface_descriptor ecm_control_intf __initdata = {
+static struct usb_interface_descriptor ecm_control_intf __usb_initdata = {
 	.bLength =		sizeof ecm_control_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -126,7 +126,7 @@ static struct usb_interface_descriptor ecm_control_intf __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc ecm_header_desc __initdata = {
+static struct usb_cdc_header_desc ecm_header_desc __usb_initdata = {
 	.bLength =		sizeof ecm_header_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -134,7 +134,7 @@ static struct usb_cdc_header_desc ecm_header_desc __initdata = {
 	.bcdCDC =		cpu_to_le16(0x0110),
 };
 
-static struct usb_cdc_union_desc ecm_union_desc __initdata = {
+static struct usb_cdc_union_desc ecm_union_desc __usb_initdata = {
 	.bLength =		sizeof(ecm_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -142,7 +142,7 @@ static struct usb_cdc_union_desc ecm_union_desc __initdata = {
 	/* .bSlaveInterface0 =	DYNAMIC */
 };
 
-static struct usb_cdc_ether_desc ecm_desc __initdata = {
+static struct usb_cdc_ether_desc ecm_desc __usb_initdata = {
 	.bLength =		sizeof ecm_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ETHERNET_TYPE,
@@ -157,7 +157,7 @@ static struct usb_cdc_ether_desc ecm_desc __initdata = {
 
 /* the default data interface has no endpoints ... */
 
-static struct usb_interface_descriptor ecm_data_nop_intf __initdata = {
+static struct usb_interface_descriptor ecm_data_nop_intf __usb_initdata = {
 	.bLength =		sizeof ecm_data_nop_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -172,7 +172,7 @@ static struct usb_interface_descriptor ecm_data_nop_intf __initdata = {
 
 /* ... but the "real" data interface has two bulk endpoints */
 
-static struct usb_interface_descriptor ecm_data_intf __initdata = {
+static struct usb_interface_descriptor ecm_data_intf __usb_initdata = {
 	.bLength =		sizeof ecm_data_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -187,7 +187,7 @@ static struct usb_interface_descriptor ecm_data_intf __initdata = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor fs_ecm_notify_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -197,7 +197,7 @@ static struct usb_endpoint_descriptor fs_ecm_notify_desc __initdata = {
 	.bInterval =		1 << LOG2_STATUS_INTERVAL_MSEC,
 };
 
-static struct usb_endpoint_descriptor fs_ecm_in_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -205,7 +205,7 @@ static struct usb_endpoint_descriptor fs_ecm_in_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor fs_ecm_out_desc __initdata = {
+static struct usb_endpoint_descriptor fs_ecm_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -213,7 +213,7 @@ static struct usb_endpoint_descriptor fs_ecm_out_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *ecm_fs_function[] __initdata = {
+static struct usb_descriptor_header *ecm_fs_function[] __usb_initdata = {
 	/* CDC ECM control descriptors */
 	(struct usb_descriptor_header *) &ecm_control_intf,
 	(struct usb_descriptor_header *) &ecm_header_desc,
@@ -231,7 +231,7 @@ static struct usb_descriptor_header *ecm_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor hs_ecm_notify_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -240,7 +240,7 @@ static struct usb_endpoint_descriptor hs_ecm_notify_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(ECM_STATUS_BYTECOUNT),
 	.bInterval =		LOG2_STATUS_INTERVAL_MSEC + 4,
 };
-static struct usb_endpoint_descriptor hs_ecm_in_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -249,7 +249,7 @@ static struct usb_endpoint_descriptor hs_ecm_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor hs_ecm_out_desc __initdata = {
+static struct usb_endpoint_descriptor hs_ecm_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -258,7 +258,7 @@ static struct usb_endpoint_descriptor hs_ecm_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *ecm_hs_function[] __initdata = {
+static struct usb_descriptor_header *ecm_hs_function[] __usb_initdata = {
 	/* CDC ECM control descriptors */
 	(struct usb_descriptor_header *) &ecm_control_intf,
 	(struct usb_descriptor_header *) &ecm_header_desc,
@@ -597,7 +597,7 @@ static void ecm_close(struct gether *geth)
 
 /* ethernet function driver setup/binding */
 
-static int __init
+static int __usb_init
 ecm_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -763,7 +763,8 @@ ecm_unbind(struct usb_configuration *c, struct usb_function *f)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init ecm_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int __usb_init
+ecm_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_ecm	*ecm;
 	int		status;
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 56b0221..35e8744 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -122,7 +122,7 @@ static unsigned int bitrate(struct usb_gadget *g)
 
 /* interface descriptor: */
 
-static struct usb_interface_descriptor rndis_control_intf __initdata = {
+static struct usb_interface_descriptor rndis_control_intf __usb_initdata = {
 	.bLength =		sizeof rndis_control_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -135,7 +135,7 @@ static struct usb_interface_descriptor rndis_control_intf __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc header_desc __initdata = {
+static struct usb_cdc_header_desc header_desc __usb_initdata = {
 	.bLength =		sizeof header_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -143,7 +143,8 @@ static struct usb_cdc_header_desc header_desc __initdata = {
 	.bcdCDC =		cpu_to_le16(0x0110),
 };
 
-static struct usb_cdc_call_mgmt_descriptor call_mgmt_descriptor __initdata = {
+static struct usb_cdc_call_mgmt_descriptor
+call_mgmt_descriptor __usb_initdata = {
 	.bLength =		sizeof call_mgmt_descriptor,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_CALL_MANAGEMENT_TYPE,
@@ -152,7 +153,7 @@ static struct usb_cdc_call_mgmt_descriptor call_mgmt_descriptor __initdata = {
 	.bDataInterface =	0x01,
 };
 
-static struct usb_cdc_acm_descriptor rndis_acm_descriptor __initdata = {
+static struct usb_cdc_acm_descriptor rndis_acm_descriptor __usb_initdata = {
 	.bLength =		sizeof rndis_acm_descriptor,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ACM_TYPE,
@@ -160,7 +161,7 @@ static struct usb_cdc_acm_descriptor rndis_acm_descriptor __initdata = {
 	.bmCapabilities =	0x00,
 };
 
-static struct usb_cdc_union_desc rndis_union_desc __initdata = {
+static struct usb_cdc_union_desc rndis_union_desc __usb_initdata = {
 	.bLength =		sizeof(rndis_union_desc),
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_UNION_TYPE,
@@ -170,7 +171,7 @@ static struct usb_cdc_union_desc rndis_union_desc __initdata = {
 
 /* the data interface has two bulk endpoints */
 
-static struct usb_interface_descriptor rndis_data_intf __initdata = {
+static struct usb_interface_descriptor rndis_data_intf __usb_initdata = {
 	.bLength =		sizeof rndis_data_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -198,7 +199,7 @@ rndis_iad_descriptor = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor fs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor fs_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -208,7 +209,7 @@ static struct usb_endpoint_descriptor fs_notify_desc __initdata = {
 	.bInterval =		1 << LOG2_STATUS_INTERVAL_MSEC,
 };
 
-static struct usb_endpoint_descriptor fs_in_desc __initdata = {
+static struct usb_endpoint_descriptor fs_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -216,7 +217,7 @@ static struct usb_endpoint_descriptor fs_in_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor fs_out_desc __initdata = {
+static struct usb_endpoint_descriptor fs_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -224,7 +225,7 @@ static struct usb_endpoint_descriptor fs_out_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *eth_fs_function[] __initdata = {
+static struct usb_descriptor_header *eth_fs_function[] __usb_initdata = {
 	(struct usb_descriptor_header *) &rndis_iad_descriptor,
 	/* control interface matches ACM, not Ethernet */
 	(struct usb_descriptor_header *) &rndis_control_intf,
@@ -242,7 +243,7 @@ static struct usb_descriptor_header *eth_fs_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor hs_notify_desc __initdata = {
+static struct usb_endpoint_descriptor hs_notify_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -251,7 +252,7 @@ static struct usb_endpoint_descriptor hs_notify_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(STATUS_BYTECOUNT),
 	.bInterval =		LOG2_STATUS_INTERVAL_MSEC + 4,
 };
-static struct usb_endpoint_descriptor hs_in_desc __initdata = {
+static struct usb_endpoint_descriptor hs_in_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -260,7 +261,7 @@ static struct usb_endpoint_descriptor hs_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor hs_out_desc __initdata = {
+static struct usb_endpoint_descriptor hs_out_desc __usb_initdata = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -269,7 +270,7 @@ static struct usb_endpoint_descriptor hs_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *eth_hs_function[] __initdata = {
+static struct usb_descriptor_header *eth_hs_function[] __usb_initdata = {
 	(struct usb_descriptor_header *) &rndis_iad_descriptor,
 	/* control interface matches ACM, not Ethernet */
 	(struct usb_descriptor_header *) &rndis_control_intf,
@@ -594,7 +595,7 @@ static void rndis_close(struct gether *geth)
 
 /* ethernet function driver setup/binding */
 
-static int __init
+static int __usb_init
 rndis_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -786,7 +787,8 @@ static inline bool can_support_rndis(struct usb_configuration *c)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init rndis_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int __usb_init
+rndis_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_rndis	*rndis;
 	int		status;
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 07f4178..2d46412 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -31,6 +31,8 @@
 
 #include "u_ether.h"
 
+#include "usb-init-exit.h"
+
 
 /*
  * This component encapsulates the Ethernet link glue needed to provide
@@ -715,7 +717,7 @@ static u8 __init nibble(unsigned char c)
 	return 0;
 }
 
-static int __init get_ether_addr(const char *str, u8 *dev_addr)
+static int __usb_init get_ether_addr(const char *str, u8 *dev_addr)
 {
 	if (str) {
 		unsigned	i;
@@ -764,7 +766,7 @@ static struct device_type gadget_type = {
  *
  * Returns negative errno, or zero on success
  */
-int __init gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
+int __usb_init gether_setup(struct usb_gadget *g, u8 ethaddr[ETH_ALEN])
 {
 	struct eth_dev		*dev;
 	struct net_device	*net;
-- 
1.7.0

