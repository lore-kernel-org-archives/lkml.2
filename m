Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2CKOIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 10:08:52 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:58678 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2CKOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 10:08:50 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-usb@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs with CONFIG_USB_FUNCTIONFS_ETH
Date: Sun, 11 Mar 2012 15:08:46 +0100
Message-Id: <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please ignore the previous message. I sent the patch out too early.
Here is a revised version.

 commit 28824b18ac4705e876a282a15ea0de8fc957551f:
 |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
 |Date:   Wed May 5 12:53:13 2010 +0200
 |
 |    USB: gadget: __init and __exit tags removed
 |
 |    __init, __initdata and __exit tags have have been removed from
 |    various files to make it possible for gadgets that do not use
 |    the __init/__exit tags to use those.
 obviously missed (at least) this case leading to a section mismatch in
 g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/gadget/f_subset.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index c154064..21ab474 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -74,7 +74,7 @@ static inline struct f_gether *func_to_geth(struct usb_function *f)
 
 /* interface descriptor: */
 
-static struct usb_interface_descriptor subset_data_intf __initdata = {
+static struct usb_interface_descriptor subset_data_intf = {
 	.bLength =		sizeof subset_data_intf,
 	.bDescriptorType =	USB_DT_INTERFACE,
 
@@ -87,7 +87,7 @@ static struct usb_interface_descriptor subset_data_intf __initdata = {
 	/* .iInterface = DYNAMIC */
 };
 
-static struct usb_cdc_header_desc mdlm_header_desc __initdata = {
+static struct usb_cdc_header_desc mdlm_header_desc = {
 	.bLength =		sizeof mdlm_header_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_HEADER_TYPE,
@@ -95,7 +95,7 @@ static struct usb_cdc_header_desc mdlm_header_desc __initdata = {
 	.bcdCDC =		cpu_to_le16(0x0110),
 };
 
-static struct usb_cdc_mdlm_desc mdlm_desc __initdata = {
+static struct usb_cdc_mdlm_desc mdlm_desc = {
 	.bLength =		sizeof mdlm_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_MDLM_TYPE,
@@ -111,7 +111,7 @@ static struct usb_cdc_mdlm_desc mdlm_desc __initdata = {
  * can't really use its struct.  All we do here is say that we're using
  * the submode of "SAFE" which directly matches the CDC Subset.
  */
-static u8 mdlm_detail_desc[] __initdata = {
+static u8 mdlm_detail_desc[] = {
 	6,
 	USB_DT_CS_INTERFACE,
 	USB_CDC_MDLM_DETAIL_TYPE,
@@ -121,7 +121,7 @@ static u8 mdlm_detail_desc[] __initdata = {
 	0,	/* network data capabilities ("raw" encapsulation) */
 };
 
-static struct usb_cdc_ether_desc ether_desc __initdata = {
+static struct usb_cdc_ether_desc ether_desc = {
 	.bLength =		sizeof ether_desc,
 	.bDescriptorType =	USB_DT_CS_INTERFACE,
 	.bDescriptorSubType =	USB_CDC_ETHERNET_TYPE,
@@ -136,7 +136,7 @@ static struct usb_cdc_ether_desc ether_desc __initdata = {
 
 /* full speed support: */
 
-static struct usb_endpoint_descriptor fs_subset_in_desc __initdata = {
+static struct usb_endpoint_descriptor fs_subset_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -144,7 +144,7 @@ static struct usb_endpoint_descriptor fs_subset_in_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_endpoint_descriptor fs_subset_out_desc __initdata = {
+static struct usb_endpoint_descriptor fs_subset_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -152,7 +152,7 @@ static struct usb_endpoint_descriptor fs_subset_out_desc __initdata = {
 	.bmAttributes =		USB_ENDPOINT_XFER_BULK,
 };
 
-static struct usb_descriptor_header *fs_eth_function[] __initdata = {
+static struct usb_descriptor_header *fs_eth_function[] = {
 	(struct usb_descriptor_header *) &subset_data_intf,
 	(struct usb_descriptor_header *) &mdlm_header_desc,
 	(struct usb_descriptor_header *) &mdlm_desc,
@@ -165,7 +165,7 @@ static struct usb_descriptor_header *fs_eth_function[] __initdata = {
 
 /* high speed support: */
 
-static struct usb_endpoint_descriptor hs_subset_in_desc __initdata = {
+static struct usb_endpoint_descriptor hs_subset_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -173,7 +173,7 @@ static struct usb_endpoint_descriptor hs_subset_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_endpoint_descriptor hs_subset_out_desc __initdata = {
+static struct usb_endpoint_descriptor hs_subset_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -181,7 +181,7 @@ static struct usb_endpoint_descriptor hs_subset_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(512),
 };
 
-static struct usb_descriptor_header *hs_eth_function[] __initdata = {
+static struct usb_descriptor_header *hs_eth_function[] = {
 	(struct usb_descriptor_header *) &subset_data_intf,
 	(struct usb_descriptor_header *) &mdlm_header_desc,
 	(struct usb_descriptor_header *) &mdlm_desc,
@@ -194,7 +194,7 @@ static struct usb_descriptor_header *hs_eth_function[] __initdata = {
 
 /* super speed support: */
 
-static struct usb_endpoint_descriptor ss_subset_in_desc __initdata = {
+static struct usb_endpoint_descriptor ss_subset_in_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -202,7 +202,7 @@ static struct usb_endpoint_descriptor ss_subset_in_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(1024),
 };
 
-static struct usb_endpoint_descriptor ss_subset_out_desc __initdata = {
+static struct usb_endpoint_descriptor ss_subset_out_desc = {
 	.bLength =		USB_DT_ENDPOINT_SIZE,
 	.bDescriptorType =	USB_DT_ENDPOINT,
 
@@ -210,7 +210,7 @@ static struct usb_endpoint_descriptor ss_subset_out_desc __initdata = {
 	.wMaxPacketSize =	cpu_to_le16(1024),
 };
 
-static struct usb_ss_ep_comp_descriptor ss_subset_bulk_comp_desc __initdata = {
+static struct usb_ss_ep_comp_descriptor ss_subset_bulk_comp_desc = {
 	.bLength =		sizeof ss_subset_bulk_comp_desc,
 	.bDescriptorType =	USB_DT_SS_ENDPOINT_COMP,
 
@@ -219,7 +219,7 @@ static struct usb_ss_ep_comp_descriptor ss_subset_bulk_comp_desc __initdata = {
 	/* .bmAttributes =	0, */
 };
 
-static struct usb_descriptor_header *ss_eth_function[] __initdata = {
+static struct usb_descriptor_header *ss_eth_function[] = {
 	(struct usb_descriptor_header *) &subset_data_intf,
 	(struct usb_descriptor_header *) &mdlm_header_desc,
 	(struct usb_descriptor_header *) &mdlm_desc,
@@ -290,7 +290,7 @@ static void geth_disable(struct usb_function *f)
 
 /* serial function driver setup/binding */
 
-static int __init
+static int
 geth_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
@@ -404,7 +404,7 @@ geth_unbind(struct usb_configuration *c, struct usb_function *f)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_gether	*geth;
 	int		status;
-- 
1.7.2.5

