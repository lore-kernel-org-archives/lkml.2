Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1DSUq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:46:29 -0400
Received: from kroah.org ([198.145.64.141]:58978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab1DSUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:18 2011
Message-Id: <20110419204118.600700383@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [18/28] USB: option: Add new ONDA vendor id and product id for ONDA MT825UP
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit c6991b6fd2b4201174dc4620d0c8c4f5ff27b36f upstream.

This patch, adds to the option driver the Onda Communication
(http://www.ondacommunication.com) vendor id, and the MT825UP modem
device id.

Note that many variants of this same device are being release here in
Italy (at least one or two per telephony operator).

These devices are perfectly equivalent except for some predefined
settings (which can be changed of course).

It should be noted that most ONDA devices are allready supported (they
used other vendor's ids in the past). The patch seems working fine here,
and the rest of the driver seems uninfluenced.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -388,6 +388,12 @@ static int  option_resume(struct usb_ser
 #define CELOT_VENDOR_ID				0x211f
 #define CELOT_PRODUCT_CT680M			0x6801
 
+/* ONDA Communication vendor id */
+#define ONDA_VENDOR_ID       0x1ee8
+
+/* ONDA MT825UP HSDPA 14.2 modem */
+#define ONDA_MT825UP         0x000b
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -917,6 +923,7 @@ static struct usb_device_id option_ids[]
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
+	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


