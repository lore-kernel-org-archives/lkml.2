Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1CVVVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:21:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54194 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1CVVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lwrZ3r5rYAlu5caPZLGWgoVAFEkW1+nqyuap0KC2wcz4l3DV2RTgxcseRUJmTyis8i
         1TPAs2uFmgStIA3B3OfMCIK1F8fBXTopAt/945/2b34bFmlUw8EFQGCL7+uKuCsG8sVO
         5DvXkLjlFjRdUaUW7Rw0Gdvcsc3Lzbkh7Bums=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: egooon@gmail.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] staging: keucr: smscsi: fixed coding style issues
Date: Tue, 22 Mar 2011 22:21:29 +0100
Message-Id: <1300828889-8273-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/keucr/smscsi.c |  155 +++++++++++++++++++++-------------------
 drivers/staging/keucr/smscsi.h |   12 +++
 2 files changed, 93 insertions(+), 74 deletions(-)
 create mode 100644 drivers/staging/keucr/smscsi.h

diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index 6211686..821a162 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -9,76 +9,78 @@
 #include "usb.h"
 #include "scsiglue.h"
 #include "transport.h"
-//#include "smcommon.h"
+/* #include "smcommon.h" */
 #include "smil.h"
 
-int SM_SCSI_Test_Unit_Ready (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Inquiry         (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Mode_Sense      (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Start_Stop      (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Read_Capacity   (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Read            (struct us_data *us, struct scsi_cmnd *srb);
-int SM_SCSI_Write           (struct us_data *us, struct scsi_cmnd *srb);
-
-extern struct SSFDCTYPE     Ssfdc;
-extern struct ADDRESS       Media;
-extern PBYTE                SMHostAddr;
-extern DWORD                ErrXDCode;
-
-//----- SM_SCSIIrp() --------------------------------------------------
+/* ----- SM_SCSIIrp() -------------------------------------------------- */
 int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 {
 	int    result;
 
 	us->SrbStatus = SS_SUCCESS;
-	switch (srb->cmnd[0])
-	{
-		case TEST_UNIT_READY :  result = SM_SCSI_Test_Unit_Ready (us, srb);  break; //0x00
-		case INQUIRY         :  result = SM_SCSI_Inquiry         (us, srb);  break; //0x12
-		case MODE_SENSE      :  result = SM_SCSI_Mode_Sense      (us, srb);  break; //0x1A
-		case READ_CAPACITY   :  result = SM_SCSI_Read_Capacity   (us, srb);  break; //0x25
-		case READ_10         :  result = SM_SCSI_Read            (us, srb);  break; //0x28
-		case WRITE_10        :  result = SM_SCSI_Write           (us, srb);  break; //0x2A
-
-		default:
-			us->SrbStatus = SS_ILLEGAL_REQUEST;
-			result = USB_STOR_TRANSPORT_FAILED;
-			break;
+	switch (srb->cmnd[0]) {
+	case TEST_UNIT_READY:
+		result = SM_SCSI_Test_Unit_Ready(us, srb);
+		break; /* 0x00 */
+	case INQUIRY:
+		result = SM_SCSI_Inquiry(us, srb);
+		break; /* 0x12 */
+	case MODE_SENSE:
+		result = SM_SCSI_Mode_Sense(us, srb);
+		break; /* 0x1A */
+	case READ_CAPACITY:
+		result = SM_SCSI_Read_Capacity(us, srb);
+		break; /* 0x25 */
+	case READ_10:
+		result = SM_SCSI_Read(us, srb);
+		break; /* 0x28 */
+	case WRITE_10:
+		result = SM_SCSI_Write(us, srb);
+		break; /* 0x2A */
+	default:
+		us->SrbStatus = SS_ILLEGAL_REQUEST;
+		result = USB_STOR_TRANSPORT_FAILED;
+		break;
 	}
 	return result;
 }
 
-//----- SM_SCSI_Test_Unit_Ready() --------------------------------------------------
+/* ----- SM_SCSI_Test_Unit_Ready() ----------------------------------------- */
 int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("SM_SCSI_Test_Unit_Ready\n");
+	/* printk("SM_SCSI_Test_Unit_Ready\n"); */
 	if (us->SM_Status.Insert && us->SM_Status.Ready)
 		return USB_STOR_TRANSPORT_GOOD;
-	else
-	{
+	else {
 		ENE_SMInit(us);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
-		
+
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Inquiry() --------------------------------------------------
+/* ----- SM_SCSI_Inquiry() ------------------------------------------------- */
 int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("SM_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+	/* printk("SM_SCSI_Inquiry\n"); */
+	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00,
+				0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20,
+				0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64,
+				0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20,
+				0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
 
-//----- SM_SCSI_Mode_Sense() --------------------------------------------------
+/* ----- SM_SCSI_Mode_Sense() ---------------------------------------------- */
 int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	BYTE	mediaNoWP[12] = {0x0b, 0x00, 0x00, 0x08, 0x00, 0x00,
+				0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
+	BYTE	mediaWP[12] = { 0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
+				0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
 
 	if (us->SM_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
@@ -89,7 +91,7 @@ int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Read_Capacity() --------------------------------------------------
+/* ----- SM_SCSI_Read_Capacity() ------------------------------------------- */
 int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
@@ -98,49 +100,52 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	WORD    bl_len;
 	BYTE    buf[8];
 
-	printk("SM_SCSI_Read_Capacity\n");
+	printk(KERN_INFO, "SM_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
 	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
-	//printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
-	//printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
-	//printk("MaxZones     = %x\n", Ssfdc.MaxZones);
-	//printk("bl_num       = %x\n", bl_num);
+	/* printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
+	printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
+	printk("MaxZones     = %x\n", Ssfdc.MaxZones);
+	printk("bl_num       = %x\n", bl_num); */
 
 	us->bl_num = bl_num;
-	printk("bl_len = %x\n", bl_len);
-	printk("bl_num = %x\n", bl_num);
-
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
+	printk(KERN_INFO, "bl_len = %x\n", bl_len);
+	printk(KERN_INFO, "bl_num = %x\n", bl_num);
+
+	/* srb->request_bufflen = 8; */
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
+	/* usb_stor_set_xfer_buf(us, buf, srb->request_bufflen,
+							srb, TO_XFER_BUF); */
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Read() --------------------------------------------------
+/* ----- SM_SCSI_Read() -------------------------------------------------- */
 int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
+	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
+	int result = 0;
 	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	DWORD bn  =
+		((Cdb[2] << 24) & 0xff000000) | ((Cdb[3] << 16) & 0x00ff0000) |
+		((Cdb[4] << 8) & 0x0000ff00) | ((Cdb[5] << 0) & 0x000000ff);
+	WORD  blen = ((Cdb[7] << 8) & 0xff00)     | ((Cdb[8] << 0) & 0x00ff);
 	DWORD	blenByte = blen * 0x200;
 	void	*buf;
 
-	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
-	
+	/* printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n",
+						bn, blen, srb->use_sg); */
+
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -159,19 +164,21 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- SM_SCSI_Write() --------------------------------------------------
+/* ----- SM_SCSI_Write() -------------------------------------------------- */
 int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
+	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
+	int result = 0;
 	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	DWORD bn  =
+		((Cdb[2] << 24) & 0xff000000) | ((Cdb[3] << 16) & 0x00ff0000) |
+		((Cdb[4] << 8) & 0x0000ff00) | ((Cdb[5] << 0) & 0x000000ff);
+	WORD  blen = ((Cdb[7] << 8) & 0xff00)     | ((Cdb[8] << 0) & 0x00ff);
 	DWORD	blenByte = blen * 0x200;
 	void	*buf;
 
-	//printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
+	/* printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n", bn,
+		blen, srb->use_sg); */
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
diff --git a/drivers/staging/keucr/smscsi.h b/drivers/staging/keucr/smscsi.h
new file mode 100644
index 0000000..8f032f3
--- /dev/null
+++ b/drivers/staging/keucr/smscsi.h
@@ -0,0 +1,12 @@
+#ifndef _SMSCSI_H_
+#define _SMSCSI_H_
+
+int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Start_Stop(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb);
+int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb);
+
+#endif
-- 
1.7.4.1

