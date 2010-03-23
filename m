Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0CWWwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:52:46 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:33227 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab0CWWwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:52:45 -0400
From: Steve Cave <steve.cave@ntlworld.com>
To: gregkh@suse.de, wfp5p@virginia.edu, m.kozlowski@tuxland.pl, julia@diku.dk
Subject: Linux kernel patch
Date: Tue, 23 Mar 2010 22:52:35 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-default; KDE/4.3.5; i686; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003232252.35958.steve.cave@ntlworld.com>
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=kj9zAlcOel0A:10 a=NLZqzBF-AAAA:8 a=zY1qkl3GX2YEuk8poQcA:9 a=a5ij9Eb42_f-0R3kUFoA:7 a=RJ3kFhfqzBfnX264DaSfWiacOsUA:4 a=CjuIK1q_8ugA:10 a=_dQi-Dcv4p4A:10 a=D9ESiI_n3Q8lxNlh:21 a=CojFZMiy18ceOAr7:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find enclosed a patch (my first) to fix checkpatch.pl issues with the
 usbduxfast.c in the comedi driver. Please note that there is one outstanding
issue, with semaphores and mutex, that I do not feel qualified to patch.

Regards

Steve Cave

---
>From 93c6eae8685fe87c4796e5e177ea136a155bfe2f Mon Sep 17 00:00:00 
2001
From: Steve Cave <steve.cave@ntlworld.com>
Date: Wed, 17 Mar 2010 20:58:35 +0000
Subject: [PATCH] Staging: comedi: fix line lengths and indentation in 
usbduxfast.c

This is a patch to the usbduxfast.c file that reformats and breaks up a
number of code lines greater than 80 characters long, standardizing
indents and replacing some spaces with tabs to fix warnings found by the
checkpatch tool; also replacing a foo * bar with foo *bar to fix an error
found by checkpatch

Signed-off-by: Steve Cave <steve.cave@ntlworld.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   66 
++++++++++++++-------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c 
b/drivers/staging/comedi/drivers/usbduxfast.c
index e89b818..b407bc0 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -177,8 +177,8 @@ struct usbduxfastsub_s {
 	int16_t *insnBuffer;	/* input buffer for single insn */
 	int ifnum;		/* interface number */
 	struct usb_interface *interface;	/* interface structure */
-	struct comedi_device *comedidev;	/* comedi device for the 
interrupt
-						   context */
+	struct comedi_device *comedidev;	/* comedi device for the
+						   interrupt context */
 	short int ai_cmd_running;	/* asynchronous command is running */
 	short int ai_continous;	/* continous aquisition */
 	long int ai_sample_count;	/* number of samples to acquire */
@@ -271,7 +271,8 @@ static int usbduxfast_ai_stop(struct 
usbduxfastsub_s *udfs, int do_unlink)
 	udfs->ai_cmd_running = 0;
 
 	if (do_unlink)
-		ret = usbduxfastsub_unlink_InURBs(udfs);	/* stop aquistion */
+		ret = usbduxfastsub_unlink_InURBs(udfs);
+						/* stop acquistion */
 
 	return ret;
 }
@@ -451,13 +452,14 @@ static int usbduxfastsub_start(struct 
usbduxfastsub_s *udfs)
 
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer,	/* address of the transfer buffer 
*/
-			      1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0),
+			USBDUXFASTSUB_FIRMWARE,	/* bRequest, 
"Firmware" */
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			USBDUXFASTSUB_CPUCS,	/* Value */
+			0x0000,	/* Index */
+			local_transfer_buffer,	/* transfer buffer address  */
+			1,	/* Length */
+			EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -473,12 +475,13 @@ static int usbduxfastsub_stop(struct 
usbduxfastsub_s *udfs)
 
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer, 1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0),
+			USBDUXFASTSUB_FIRMWARE,	/* bRequest, 
"Firmware" */
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			USBDUXFASTSUB_CPUCS,	/* Value */
+			0x0000,	/* Index */
+			local_transfer_buffer, 1,	/* Length */
+			EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
 		       "(stop)\n");
@@ -499,13 +502,14 @@ static int usbduxfastsub_upload(struct 
usbduxfastsub_s *udfs,
 	printk(KERN_DEBUG " to addr %d, first byte=%d.\n",
 	       startAddr, local_transfer_buffer[0]);
 #endif
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0), USBDUXFASTSUB_FIRMWARE,	/* brequest, firmware */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      startAddr,	/* value */
-			      0x0000,	/* index */
-			      local_transfer_buffer,	/* our local safe buffer */
-			      len,	/* length */
-			      EZTIMEOUT);	/* timeout */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 
0),
+			USBDUXFASTSUB_FIRMWARE,	/* brequest, firmware 
*/
+			VENDOR_DIR_OUT,	/* bmRequestType */
+			startAddr,	/* value */
+			0x0000,	/* index */
+			local_transfer_buffer,	/* our local safe buffer */
+			len,	/* length */
+			EZTIMEOUT);	/* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
@@ -1347,7 +1351,7 @@ static int usbduxfast_ai_insn_read(struct 
comedi_device *dev,
 #define FIRMWARE_MAX_LEN 0x2000
 
 static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
-			  const u8 * firmwareBinary, int sizeFirmware)
+			  const u8 *firmwareBinary, int sizeFirmware)
 {
 	int ret;
 	uint8_t *fwBuf;
@@ -1357,7 +1361,7 @@ static int firmwareUpload(struct usbduxfastsub_s 
*usbduxfastsub,
 
 	if (sizeFirmware > FIRMWARE_MAX_LEN) {
 		dev_err(&usbduxfastsub->interface->dev,
-			"comedi_: usbduxfast firmware binary it too large for FX2.
\n");
+		"comedi_: usbduxfast firmware binary too large for FX2.\n");
 		return -ENOMEM;
 	}
 
@@ -1567,12 +1571,12 @@ static int usbduxfastsub_probe(struct 
usb_interface *uinterf,
 	up(&start_stop_sem);
 
 	ret = request_firmware_nowait(THIS_MODULE,
-				      FW_ACTION_HOTPLUG,
-				      "usbduxfast_firmware.bin",
-				      &udev->dev,
-				      GFP_KERNEL,
-				      usbduxfastsub + index,
-				      usbduxfast_firmware_request_complete_handler);
+				FW_ACTION_HOTPLUG,
+				"usbduxfast_firmware.bin",
+				&udev->dev,
+				GFP_KERNEL,
+				usbduxfastsub + index,
+				usbduxfast_firmware_request_complete_handler);
 
 	if (ret) {
 		dev_err(&udev->dev, "could not load firmware (err=%d)\n", ret);
-- 
1.6.4.2

