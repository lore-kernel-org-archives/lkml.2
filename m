Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1DZV0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:26:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DZVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483691"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: mrkiko.rs@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [70/106] USB: option: Add new ONDA vendor id and product id for ONDA MT825UP
Message-Id: <20110426211351.74E513E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/option.c
+++ linux-2.6.35.y/drivers/usb/serial/option.c
@@ -381,6 +381,12 @@ static void option_instat_callback(struc
 #define CELOT_VENDOR_ID				0x211f
 #define CELOT_PRODUCT_CT680M			0x6801
 
+/* ONDA Communication vendor id */
+#define ONDA_VENDOR_ID       0x1ee8
+
+/* ONDA MT825UP HSDPA 14.2 modem */
+#define ONDA_MT825UP         0x000b
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -934,6 +940,7 @@ static const struct usb_device_id option
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
+	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
