Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1IBHds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:33:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39818 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1IBHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:33:47 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 1/1] Staging: comedi: fix line over 80 character issue in usbduxfast.c
Date: Fri,  2 Sep 2011 13:03:33 +0530
Message-Id: <1314948813-3583-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix line over 80 character issue in usbduxfast.c>
References: <[PATCH 1/1]Staging: comedi: fix line over 80 character issue in usbduxfast.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a line 0ver 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   47 ++++++++++++++------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2a8e725..62ca2a3 100644
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
+			USBDUXFASTSUB_FIRMWARE,
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			USBDUXFASTSUB_CPUCS,	/* Value */
+			0x0000,	/* Index */
+			/* address of the transfer buffer */
+			local_transfer_buffer,
+			1,	/* Length */
+			EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -477,12 +478,13 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer, 1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+			USBDUXFASTSUB_FIRMWARE,
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			USBDUXFASTSUB_CPUCS,	/* Value */
+			0x0000,	/* Index */
+			local_transfer_buffer, 1,	/* Length */
+			EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
 		       "(stop)\n");
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
+			USBDUXFASTSUB_FIRMWARE,
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			startAddr,	/* value */
+			0x0000,	/* index */
+			/* our local safe buffer */
+			local_transfer_buffer,
+			len,	/* length */
+			EZTIMEOUT);	/* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
-- 
1.6.5.2

