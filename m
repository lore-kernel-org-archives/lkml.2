Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1CZQQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:16:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1CZQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=onlnVk+jXksg0d8sRPPgOXOG/Nav8RHWi0WaQgpoH5EMYXx+EXI7Gd9pqx3lqUSnYs
         5MX327gVqWQ+n/fnYSBBNXiW5y+qcB1MN89W+B0PKdFGQeo5jZs0i6dfzqSdzoxoHpIV
         7nv6u6s5XbRJt13PuVAD7bYTvTp9W481PMOcU=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH 1/4] staging: keucr: smscsi: Fixed most checkpatch warnings and errors.
Date: Sat, 26 Mar 2011 17:16:17 +0100
Message-Id: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup fixes most of the checkpatch warnings and errors.
Remaining warnings and errors are left untouched on purpose to
avoid making the code less readable. This cleanup also removes
some worthless comments.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/keucr/smscsi.c |  148 +++++++++++++++++++++-------------------
 1 files changed, 79 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index 6211686..c3db085 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -9,26 +9,24 @@
 #include "usb.h"
 #include "scsiglue.h"
 #include "transport.h"
-//#include "smcommon.h"
 #include "smil.h"
 
-int SM_SCSI_Test_Unit_Ready (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Inquiry         (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Mode_Sense      (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Start_Stop      (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Read_Capacity   (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Read            (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Write           (struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Start_Stop(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb);
 
-extern struct SSFDCTYPE     Ssfdc;
-extern struct ADDRESS       Media;
-extern PBYTE                SMHostAddr;
-extern DWORD                ErrXDCode;
+extern struct SSFDCTYPE Ssfdc;
+extern struct ADDRESS Media;
+extern PBYTE SMHostAddr;
+extern DWORD ErrXDCode;
 
-//----- SM_SCSIIrp() --------------------------------------------------
 int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 {
-	int    result;
+	int result;
 
 	us->SrbStatus = SS_SUCCESS;
 	switch (srb->cmnd[0])
@@ -48,99 +46,108 @@ int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 	return result;
 }
 
-//----- SM_SCSI_Test_Unit_Ready() --------------------------------------------------
 int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("SM_SCSI_Test_Unit_Ready\n");
-	if (us->SM_Status.Insert && us->SM_Status.Ready)
+	/* printk("SM_SCSI_Test_Unit_Ready\n"); */
+	if (us->SM_Status.Insert && us->SM_Status.Ready) {
 		return USB_STOR_TRANSPORT_GOOD;
-	else
-	{
+	} else {
 		ENE_SMInit(us);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
-		
+
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Inquiry() --------------------------------------------------
 int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("SM_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+	/* printk("SM_SCSI_Inquiry\n"); */
+	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00,
+				0x00, 0x00, 0x55, 0x53, 0x42, 0x32,
+				0x2E, 0x30, 0x20, 0x20, 0x43, 0x61,
+				0x72, 0x64, 0x52, 0x65, 0x61, 0x64,
+				0x65, 0x72, 0x20, 0x20, 0x20, 0x20,
+				0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
 
-//----- SM_SCSI_Mode_Sense() --------------------------------------------------
 int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	BYTE mediaNoWP[12] = {0x0b, 0x00, 0x00, 0x08, 0x00, 0x00,
+				0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
+	BYTE mediaWP[12] = {0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
+				0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
 
 	if (us->SM_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
 	else
 		usb_stor_set_xfer_buf(us, mediaNoWP, 12, srb, TO_XFER_BUF);
 
-
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Read_Capacity() --------------------------------------------------
 int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
-	DWORD   bl_num;
-	WORD    bl_len;
-	BYTE    buf[8];
+	DWORD bl_num;
+	WORD bl_len;
+	BYTE buf[8];
 
 	printk("SM_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
 	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
-	//printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
-	//printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
-	//printk("MaxZones     = %x\n", Ssfdc.MaxZones);
-	//printk("bl_num       = %x\n", bl_num);
+
+	/*
+	 * printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
+	 * printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
+	 * printk("MaxZones     = %x\n", Ssfdc.MaxZones);
+	 * printk("bl_num       = %x\n", bl_num);
+	 */
 
 	us->bl_num = bl_num;
 	printk("bl_len = %x\n", bl_len);
 	printk("bl_num = %x\n", bl_num);
 
-	//srb->request_bufflen = 8;
-	buf[0] = (bl_num>>24) & 0xff;
-	buf[1] = (bl_num>>16) & 0xff;
-	buf[2] = (bl_num>> 8) & 0xff;
-	buf[3] = (bl_num>> 0) & 0xff;
-	buf[4] = (bl_len>>24) & 0xff;
-	buf[5] = (bl_len>>16) & 0xff;
-	buf[6] = (bl_len>> 8) & 0xff;
-	buf[7] = (bl_len>> 0) & 0xff;
-	
+	buf[0] = (bl_num >> 24) & 0xff;
+	buf[1] = (bl_num >> 16) & 0xff;
+	buf[2] = (bl_num >> 8) & 0xff;
+	buf[3] = (bl_num >> 0) & 0xff;
+	buf[4] = (bl_len >> 24) & 0xff;
+	buf[5] = (bl_len >> 16) & 0xff;
+	buf[6] = (bl_len >> 8) & 0xff;
+	buf[7] = (bl_len >> 0) & 0xff;
+
 	usb_stor_access_xfer_buf(us, buf, 8, srb, &sg, &offset, TO_XFER_BUF);
-	//usb_stor_set_xfer_buf(us, buf, srb->request_bufflen, srb, TO_XFER_BUF);
+	/*
+	 * usb_stor_set_xfer_buf(us, buf, srb->request_bufflen,
+	 *			srb, TO_XFER_BUF);
+	 */
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Read() --------------------------------------------------
 int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
-	void	*buf;
-
-	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
-	
+	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
+	int result = 0;
+	PBYTE Cdb = srb->cmnd;
+	DWORD bn =
+		((Cdb[2] << 24) & 0xff000000) | ((Cdb[3] << 16) & 0x00ff0000) |
+		((Cdb[4] << 8) & 0x0000ff00) | ((Cdb[5] << 0) & 0x000000ff);
+	WORD blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
+	DWORD blenByte = blen * 0x200;
+	void *buf;
+
+	/*
+	 * printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n",
+	 *				bn, blen, srb->use_sg);
+	 */
+
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -159,19 +166,22 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Write() --------------------------------------------------
 int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
-	void	*buf;
-
-	//printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
+	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
+	int result = 0;
+	PBYTE Cdb = srb->cmnd;
+	DWORD bn =
+		((Cdb[2] << 24) & 0xff000000) | ((Cdb[3] << 16) & 0x00ff0000) |
+		((Cdb[4] << 8) & 0x0000ff00) | ((Cdb[5] << 0) & 0x000000ff);
+	WORD blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
+	DWORD blenByte = blen * 0x200;
+	void *buf;
+
+	/*
+	 * printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n",
+	 *				bn, blen, srb->use_sg);
+	 */
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
-- 
1.7.4.1

