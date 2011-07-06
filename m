Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1GFKO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:14:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52058 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GFKO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:14:56 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 4/4] Staging: comedi: fix warning: line over 80 character issue in usbduxfast.c
Date: Wed,  6 Jul 2011 15:44:39 +0530
Message-Id: <1309947279-2443-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Re:[PATCH]Staging: comedi: fix Renaming variable name usbduxfast_firmware_request_complete_handler issues in usbduxfast.c>
References: <Re:[PATCH]Staging: comedi: fix Renaming variable name usbduxfast_firmware_request_complete_handler issues in usbduxfast.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the usbduxfast.c file that fixes up a  warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index de2e34c..97ecc84 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1439,7 +1439,7 @@ static void tidy_up(struct usbduxfastsub_s *udfs)
 	udfs->ai_cmd_running = 0;
 }
 
-static void usbduxfast_firmware_request_complete_handler(const struct firmware
+static void usbduxfast_firmware_req_complete_handler(const struct firmware
 							 *fw, void *context)
 {
 	struct usbduxfastsub_s *usbduxfastsub_tmp = context;
@@ -1574,14 +1574,13 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].probed = 1;
 	up(&start_stop_sem);
 
-	ret =
-	request_firmware_nowait(THIS_MODULE,
+	ret = request_firmware_nowait(THIS_MODULE,
 				FW_ACTION_HOTPLUG,
 				"usbduxfast_firmware.bin",
 				&udev->dev,
 				GFP_KERNEL,
 				usbduxfastsub + index,
-				usbduxfast_firmware_request_complete_handler);
+				usbduxfast_firmware_req_complete_handler);
 
 
 	if (ret) {
-- 
1.7.1.1

