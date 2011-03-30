Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab1C3VGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789Ab1C3VGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132960"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dario.lombardo@libero.it, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [64/275] drivers: update to pl2303 usb-serial to support Motorola cables
Message-Id: <20110330210501.14FCE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dario Lombardo <dario.lombardo@libero.it>

commit 96a3e79edff6f41b0f115a82f1a39d66218077a7 upstream.

Added 0x0307 device id to support Motorola cables to the pl2303 usb
serial driver. This cable has a modified chip that is a pl2303, but
declares itself as 0307. Fixed by adding the right device id to the
supported devices list, assigning it the code labeled
PL2303_PRODUCT_ID_MOTOROLA.

Signed-off-by: Dario Lombardo <dario.lombardo@libero.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/pl2303.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/pl2303.c	2011-03-29 23:02:58.484338952 -0700
+++ linux-2.6.35.y/drivers/usb/serial/pl2303.c	2011-03-29 23:02:59.516312546 -0700
@@ -50,6 +50,7 @@
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
Index: linux-2.6.35.y/drivers/usb/serial/pl2303.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/pl2303.h	2011-03-29 22:51:44.319589141 -0700
+++ linux-2.6.35.y/drivers/usb/serial/pl2303.h	2011-03-29 23:02:59.516312546 -0700
@@ -21,6 +21,7 @@
 #define PL2303_PRODUCT_ID_MMX		0x0612
 #define PL2303_PRODUCT_ID_GPRS		0x0609
 #define PL2303_PRODUCT_ID_HCR331	0x331a
+#define PL2303_PRODUCT_ID_MOTOROLA	0x0307
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
