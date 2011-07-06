Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1GFI1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:27:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59134 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1GFI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:27:09 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix warning: line over 80 characters issue in usbduxfast.c
Date: Wed,  6 Jul 2011 13:56:50 +0530
Message-Id: <1309940810-2381-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi: fix warning line over 80 character issues in usbduxfast.c>
References: <[PATCH]Staging: comedi: fix warning line over 80 character issues in usbduxfast.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the usbduxfast.c file that fixes up a warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2a8e725..de2e34c 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -453,7 +453,8 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+				USBDUXFASTSUB_FIRMWARE,
 				VENDOR_DIR_OUT,	/* bmRequestType */
 				USBDUXFASTSUB_CPUCS,	/* Value */
 				0x0000,	/* Index */
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
@@ -504,7 +506,8 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	       startAddr, local_transfer_buffer[0]);
 #endif
 	/* brequest, firmware */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
+				USBDUXFASTSUB_FIRMWARE,
 				VENDOR_DIR_OUT,	/* bmRequestType */
 				startAddr,	/* value */
 				0x0000,	/* index */
@@ -1571,13 +1574,15 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].probed = 1;
 	up(&start_stop_sem);
 
-	ret = request_firmware_nowait(THIS_MODULE,
-				      FW_ACTION_HOTPLUG,
-				      "usbduxfast_firmware.bin",
-				      &udev->dev,
-				      GFP_KERNEL,
-				      usbduxfastsub + index,
-				      usbduxfast_firmware_request_complete_handler);
+	ret =
+	request_firmware_nowait(THIS_MODULE,
+				FW_ACTION_HOTPLUG,
+				"usbduxfast_firmware.bin",
+				&udev->dev,
+				GFP_KERNEL,
+				usbduxfastsub + index,
+				usbduxfast_firmware_request_complete_handler);
+
 
 	if (ret) {
 		dev_err(&udev->dev, "could not load firmware (err=%d)\n", ret);
-- 
1.7.1.1

