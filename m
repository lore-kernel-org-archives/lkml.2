Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1DZVPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:60554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1DZVOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327598"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: marius@kotsbak.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [71/106] USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.
Message-Id: <20110426211352.7F6C83E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Marius B. Kotsbak <marius@kotsbak.com>

commit 80f9df3e0093ad9f1eeefd2ff7fd27daaa518d25 upstream.

Bind only modem AT command endpoint to option.

Signed-off-by: Marius B. Kotsbak <marius@kotsbak.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/option.c
+++ linux-2.6.35.y/drivers/usb/serial/option.c
@@ -387,6 +387,10 @@ static void option_instat_callback(struc
 /* ONDA MT825UP HSDPA 14.2 modem */
 #define ONDA_MT825UP         0x000b
 
+/* Samsung products */
+#define SAMSUNG_VENDOR_ID                       0x04e8
+#define SAMSUNG_PRODUCT_GT_B3730                0x6889
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -941,6 +945,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
+	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730/GT-B3710 LTE USB modem.*/
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
