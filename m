Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1BBAqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:46:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:26982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1BBApX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418486"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: moinejf@free.fr, mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [134/139] gspca - sonixj: Set the flag for some devices
Message-Id: <20110202004533.F20193E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

commit b2272a49e7df37732d73988f00468ce31e1ebc92 upstream.

The flag PDN_INV indicates that the sensor pin S_PWR_DN has not the same
value as other webcams with the same sensor. For now, only two webcams have
been so detected: the Microsoft's VX1000 and VX3000.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/gspca/sonixj.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/media/video/gspca/sonixj.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/gspca/sonixj.c
+++ linux-2.6.35.y/drivers/media/video/gspca/sonixj.c
@@ -88,6 +88,9 @@ enum {
 	u8 jpeg_hdr[JPEG_HDR_SZ];
 };
 
+/* device flags */
+#define PDN_INV	1		/* inverse pin S_PWR_DN / sn_xxx tables */
+
 /* V4L2 controls supported by the driver */
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
@@ -3004,8 +3007,8 @@ static const __devinitdata struct usb_de
 	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},
 	{USB_DEVICE(0x0458, 0x702e), BS(SN9C120, OV7660)},
 #endif
-	{USB_DEVICE(0x045e, 0x00f5), BS(SN9C105, OV7660)},
-	{USB_DEVICE(0x045e, 0x00f7), BS(SN9C105, OV7660)},
+	{USB_DEVICE(0x045e, 0x00f5), BSF(SN9C105, OV7660, PDN_INV)},
+	{USB_DEVICE(0x045e, 0x00f7), BSF(SN9C105, OV7660, PDN_INV)},
 	{USB_DEVICE(0x0471, 0x0327), BS(SN9C105, MI0360)},
 	{USB_DEVICE(0x0471, 0x0328), BS(SN9C105, MI0360)},
 	{USB_DEVICE(0x0471, 0x0330), BS(SN9C105, MI0360)},
