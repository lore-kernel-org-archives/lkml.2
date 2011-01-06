Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1AFAcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:32:06 -0500
Received: from kroah.org ([198.145.64.141]:36173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1AFAcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:32:02 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:11 2011
Message-Id: <20110106002310.929742038@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [152/152] [media] gspca - sonixj: Add a flag in the driver_info table
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Francois Moine <moinejf@free.fr>

commit c6c14330717f9850b4b4c054b81424b9979cd07d upstream.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -56,6 +56,7 @@ struct sd {
 	u8 jpegqual;			/* webcam quality */
 
 	u8 reg18;
+	u8 flags;
 
 	s8 ag_cnt;
 #define AG_CNT_START 13
@@ -1780,7 +1781,8 @@ static int sd_config(struct gspca_dev *g
 	struct cam *cam;
 
 	sd->bridge = id->driver_info >> 16;
-	sd->sensor = id->driver_info;
+	sd->sensor = id->driver_info >> 8;
+	sd->flags = id->driver_info;
 
 	cam = &gspca_dev->cam;
 	if (sd->sensor == SENSOR_ADCM1700) {
@@ -2987,7 +2989,11 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 #define BS(bridge, sensor) \
 	.driver_info = (BRIDGE_ ## bridge << 16) \
-			| SENSOR_ ## sensor
+			| (SENSOR_ ## sensor << 8)
+#define BSF(bridge, sensor, flags) \
+	.driver_info = (BRIDGE_ ## bridge << 16) \
+			| (SENSOR_ ## sensor << 8) \
+			| (flags)
 static const __devinitdata struct usb_device_id device_table[] = {
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},


