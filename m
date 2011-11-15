Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1KOHx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:53:56 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49806 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443Ab1KOHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:53:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 04/13] usb: storage: ene_ub6250: fix sparse warnings
Date: Tue, 15 Nov 2011 09:53:31 +0200
Message-Id: <1321343620-10794-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321343620-10794-1-git-send-email-balbi@ti.com>
References: <1321343620-10794-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

| drivers/usb/storage/ene_ub6250.c:45:22: warning: symbol
|	'ene_ub6250_usb_ids' was not declared. Should it
|	be static?
|
| drivers/usb/storage/ene_ub6250.c:780:5: warning: symbol
|	'ms_lib_alloc_logicalmap' was not declared. Should it
|	be static?
|
| drivers/usb/storage/ene_ub6250.c:2251:5: warning: symbol
|	'ms_scsi_irp' was not declared. Should it be static?
|
| drivers/usb/storage/ene_ub6250.c:638:29: warning: right shift by bigger
|	than source value
|
| drivers/usb/storage/ene_ub6250.c:639:29: warning: right shift by bigger
|	than source value

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/storage/ene_ub6250.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 9fbe742..b990726 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -42,7 +42,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
 	.driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id ene_ub6250_usb_ids[] = {
+static struct usb_device_id ene_ub6250_usb_ids[] = {
 #	include "unusual_ene_ub6250.h"
 	{ }		/* Terminating entry */
 };
@@ -607,8 +607,8 @@ static int sd_scsi_mode_sense(struct us_data *us, struct scsi_cmnd *srb)
 
 static int sd_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
-	u32   bl_num;
-	u16    bl_len;
+	u32	bl_num;
+	u32	bl_len;
 	unsigned int offset = 0;
 	unsigned char    buf[8];
 	struct scatterlist *sg = NULL;
@@ -622,7 +622,7 @@ static int sd_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 		else
 			bl_num = (info->HC_C_SIZE + 1) * 1024 - 1;
 	} else {
-		bl_len = 1<<(info->SD_READ_BL_LEN);
+		bl_len = 1 << (info->SD_READ_BL_LEN);
 		bl_num = info->SD_Block_Mult * (info->SD_C_SIZE + 1)
 				* (1 << (info->SD_C_SIZE_MULT + 2)) - 1;
 	}
@@ -777,7 +777,7 @@ static int ms_lib_free_logicalmap(struct us_data *us)
 	return 0;
 }
 
-int ms_lib_alloc_logicalmap(struct us_data *us)
+static int ms_lib_alloc_logicalmap(struct us_data *us)
 {
 	u32  i;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
@@ -2248,7 +2248,7 @@ static int sd_scsi_irp(struct us_data *us, struct scsi_cmnd *srb)
 /*
  * ms_scsi_irp()
  */
-int ms_scsi_irp(struct us_data *us, struct scsi_cmnd *srb)
+static int ms_scsi_irp(struct us_data *us, struct scsi_cmnd *srb)
 {
 	int result;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)us->extra;
-- 
1.7.8.rc0

