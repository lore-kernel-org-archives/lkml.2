Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1AFAcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:32:04 -0500
Received: from kroah.org ([198.145.64.141]:36168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1AFAcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:32:01 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.826545803@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [151/152] [media] gspca - sonixj: Set the flag for some devices
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Francois Moine <moinejf@free.fr>

commit b2272a49e7df37732d73988f00468ce31e1ebc92 upstream.

The flag PDN_INV indicates that the sensor pin S_PWR_DN has not the same
value as other webcams with the same sensor. For now, only two webcams have
been so detected: the Microsoft's VX1000 and VX3000.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -87,6 +87,9 @@ enum sensors {
 	SENSOR_SP80708,
 };
 
+/* device flags */
+#define PDN_INV	1		/* inverse pin S_PWR_DN / sn_xxx tables */
+
 /* V4L2 controls supported by the driver */
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
@@ -2990,8 +2993,8 @@ static const __devinitdata struct usb_de
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


