Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1BBAqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:46:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:59575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1BBApY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028715"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: moinejf@free.fr, mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [135/139] gspca - sonixj: Add a flag in the driver_info table
Message-Id: <20110202004535.086623E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

commit c6c14330717f9850b4b4c054b81424b9979cd07d upstream.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/gspca/sonixj.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/media/video/gspca/sonixj.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/gspca/sonixj.c
+++ linux-2.6.35.y/drivers/media/video/gspca/sonixj.c
@@ -57,6 +57,7 @@ struct sd {
 	u8 jpegqual;			/* webcam quality */
 
 	u8 reg18;
+	u8 flags;
 
 	s8 ag_cnt;
 #define AG_CNT_START 13
@@ -1777,7 +1778,8 @@ static int sd_config(struct gspca_dev *g
 	struct cam *cam;
 
 	sd->bridge = id->driver_info >> 16;
-	sd->sensor = id->driver_info;
+	sd->sensor = id->driver_info >> 8;
+	sd->flags = id->driver_info;
 
 	cam = &gspca_dev->cam;
 	if (sd->sensor == SENSOR_ADCM1700) {
@@ -3001,7 +3003,11 @@ static const struct sd_desc sd_desc = {
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
