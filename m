Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2EAGZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:25:35 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53847 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2EAGZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:31 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/5] Staging: comedi: fix line over 80 character issue in usbduxfast.c
Date: Tue,  1 May 2012 11:55:06 +0530
Message-Id: <1335853510-29545-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   37 ++++++++++++++------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2a8e725..0732856 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -453,14 +453,15 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-				VENDOR_DIR_OUT,	/* bmRequestType */
-				USBDUXFASTSUB_CPUCS,	/* Value */
-				0x0000,	/* Index */
-				/* address of the transfer buffer */
-				local_transfer_buffer,
-				1,	/* Length */
-				EZTIMEOUT);	/* Timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
+			      VENDOR_DIR_OUT,	  /* bmRequestType */
+			      USBDUXFASTSUB_CPUCS,    /* Value */
+			      0x0000,	/* Index */
+			      /* address of the transfer buffer */
+			      local_transfer_buffer,
+			      1,      /* Length */
+			      EZTIMEOUT);    /* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -477,7 +478,8 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
 			      VENDOR_DIR_OUT,	/* bmRequestType */
 			      USBDUXFASTSUB_CPUCS,	/* Value */
 			      0x0000,	/* Index */
@@ -504,14 +506,15 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	       startAddr, local_transfer_buffer[0]);
 #endif
 	/* brequest, firmware */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-				VENDOR_DIR_OUT,	/* bmRequestType */
-				startAddr,	/* value */
-				0x0000,	/* index */
-				/* our local safe buffer */
-				local_transfer_buffer,
-				len,	/* length */
-				EZTIMEOUT);	/* timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
+			      VENDOR_DIR_OUT,	/* bmRequestType */
+			      startAddr,	/* value */
+			      0x0000,	 /* index */
+			      /* our local safe buffer */
+			      local_transfer_buffer,
+			      len,	/* length */
+			      EZTIMEOUT);      /* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
-- 
1.7.0.4

