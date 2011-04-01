Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1DAGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45590 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DAGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pi/SXSNsngtApvYOWztKhfSepIS7vQw0yTXM0ULQrJHt7spEZoXmxT5tPLiyjFAzpO
         isL19H14xSurIaS8Qjy7iYpQhN5vJhN6aP7hvkSxypx2CccWwLj3CpySKPxnQRlQhdYL
         PfKpx+SFkJL0nt0cci9gWZWTUr4uNUDhwZXZY=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 2/5] staging/keucr: msscsi use pr_<level> for messages
Date: Fri,  1 Apr 2011 14:38:40 +0800
Message-Id: <32d911d6fd431320a766c1b5cf64f1946dc1c1b2.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msscsi.c use pr_<level> for messages

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/msscsi.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/keucr/msscsi.c b/drivers/staging/keucr/msscsi.c
index cb92d25..d1a919b 100644
--- a/drivers/staging/keucr/msscsi.c
+++ b/drivers/staging/keucr/msscsi.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -44,7 +46,7 @@ int MS_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 //----- MS_SCSI_Test_Unit_Ready() --------------------------------------------------
 int MS_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("MS_SCSI_Test_Unit_Ready\n");
+	/* pr_info("MS_SCSI_Test_Unit_Ready\n"); */
 	if (us->MS_Status.Insert && us->MS_Status.Ready)
 		return USB_STOR_TRANSPORT_GOOD;
 	else
@@ -59,7 +61,7 @@ int MS_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 //----- MS_SCSI_Inquiry() --------------------------------------------------
 int MS_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("MS_SCSI_Inquiry\n");
+	/* pr_info("MS_SCSI_Inquiry\n"); */
 	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
@@ -91,7 +93,7 @@ int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	WORD    bl_len;
 	BYTE    buf[8];
 
-	printk("MS_SCSI_Read_Capacity\n");
+	pr_info("MS_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
 	if ( us->MS_Status.IsMSPro )
@@ -100,8 +102,8 @@ int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 		bl_num = us->MS_Lib.NumberOfLogBlock * us->MS_Lib.blockSize * 2 - 1;
 
 	us->bl_num = bl_num;
-	printk("bl_len = %x\n", bl_len);
-	printk("bl_num = %x\n", bl_num);
+	pr_info("bl_len = %x\n", bl_len);
+	pr_info("bl_num = %x\n", bl_num);
 
 	//srb->request_bufflen = 8;
 	buf[0] = (bl_num>>24) & 0xff;
@@ -130,7 +132,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
 	DWORD	blenByte = blen * 0x200;
 
-	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
+	/* pr_info("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n",
+						bn, blen, srb->use_sg); */
 	
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -140,7 +143,7 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		result = ENE_LoadBinCode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD)
 		{
-			printk("Load MSP RW pattern Fail !!\n");
+			pr_info("Load MSP RW pattern Fail !!\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
@@ -174,7 +177,7 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD)
 		{
-			printk("Load MS RW pattern Fail !!\n");
+			pr_info("Load MS RW pattern Fail !!\n");
 			result = USB_STOR_TRANSPORT_ERROR;
 			goto exit;
 		}
@@ -207,7 +210,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			result = ENE_SendScsiCmd(us, FDIR_READ, buf+offset, 0);
 			if (result != USB_STOR_XFER_GOOD)
 			{
-				printk("MS_SCSI_Read --- result = %x\n", result);
+				pr_info("MS_SCSI_Read --- result = %x\n",
+								result);
 				result =  USB_STOR_TRANSPORT_ERROR;
 				goto exit;
 			}
@@ -245,7 +249,7 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		result = ENE_LoadBinCode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD)
 		{
-			printk("Load MSP RW pattern Fail !!\n");
+			pr_info("Load MSP RW pattern Fail !!\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
@@ -280,7 +284,7 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD)
 		{
-			printk("Load MS RW pattern Fail !!\n");
+			pr_info("Load MS RW pattern Fail !!\n");
 			result = USB_STOR_TRANSPORT_ERROR;
 			goto exit;
 		}
@@ -301,7 +305,8 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 			result = MS_ReaderCopyBlock(us, oldphy, newphy, PhyBlockAddr, PageNum, buf+offset, len);
 			if (result != USB_STOR_XFER_GOOD)
 			{
-				printk("MS_SCSI_Write --- result = %x\n", result);
+				pr_info("MS_SCSI_Write --- result = %x\n",
+								result);
 				result =  USB_STOR_TRANSPORT_ERROR;
 				goto exit;
 			}
-- 
1.7.1

