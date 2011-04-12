Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1DLTfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:35:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:40343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab1DLTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:35:20 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] usb/gadget: don't deploy SS descriptors if SS is not enabled.
Date: Tue, 12 Apr 2011 21:34:55 +0200
Message-Id: <1302636896-12717-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/composite.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 92cc238..ac30e2f 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -74,10 +74,12 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
 static char composite_manufacturer[50];
 
 /* Default endpoint companion descriptor */
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
 static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
 		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
 		.bLength = sizeof(struct usb_ss_ep_comp_descriptor),
 };
+#endif
 
 /**
  * usb_create_ss_descriptors() - Generate SuperSpeed descriptors
@@ -93,6 +95,7 @@ static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
  */
 void usb_create_ss_descriptors(struct usb_function *f)
 {
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
 	struct usb_ss_ep_comp_descriptor	*ep_comp_desc;
 	struct usb_endpoint_descriptor		*ep_desc;
 	struct usb_descriptor_header		**src = f->hs_descriptors;
@@ -185,6 +188,7 @@ void usb_create_ss_descriptors(struct usb_function *f)
 	 */
 	*tmp = NULL;
 	f->ss_desc_allocated = true;
+#endif
 }
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4

