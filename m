Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2CMA65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:58:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47718 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab2CMAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Marius B. Kotsbak" <marius@kotsbak.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 073/196] USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.
Date: Mon, 12 Mar 2012 20:19:46 -0400
Message-Id: <1331598109-31424-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Marius B. Kotsbak" <marius@kotsbak.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 80f9df3e0093ad9f1eeefd2ff7fd27daaa518d25 upstream.

Bind only modem AT command endpoint to option.

Signed-off-by: Marius B. Kotsbak <marius@kotsbak.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d1baa77..335dbed 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -408,6 +408,10 @@ static int  option_resume(struct usb_serial *serial);
 /* ONDA MT825UP HSDPA 14.2 modem */
 #define ONDA_MT825UP         0x000b
 
+/* Samsung products */
+#define SAMSUNG_VENDOR_ID                       0x04e8
+#define SAMSUNG_PRODUCT_GT_B3730                0x6889
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -962,6 +966,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
+	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730/GT-B3710 LTE USB modem.*/
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.7.9.3

