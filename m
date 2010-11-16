Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab0KPGNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:13:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55338 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0KPGM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=D08bNIg2zeb/AUjoosfkpMFLghUuvJMorx8a3sM1RMv2aBIfZviBNB/le21yUBN7Bo
         J10mKhOSfiHQPgyj+/o/pLaxMWqg+Kps/s9Gm0vINn2HN5LIf5dXhsUGPP9VmMrSySCW
         zZPTr63VgIV90Tvq+fTLOV1mx37dtgtBp9x60=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, acho@novell.com,
        segooon@gmail.com
Subject: [PATCH 3/3] staging/keucr: fix keucr msscsi code style
Date: Tue, 16 Nov 2010 14:13:34 +0800
Message-Id: <1289888014-2992-1-git-send-email-acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr msscsi code style

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/msscsi.c |  238 ++++++++++++++++++++++------------------
 drivers/staging/keucr/msscsi.h |   12 ++
 2 files changed, 144 insertions(+), 106 deletions(-)
 create mode 100644 drivers/staging/keucr/msscsi.h

diff --git a/drivers/staging/keucr/msscsi.c b/drivers/staging/keucr/msscsi.c
index ad0c5c6..59f4dac 100644
--- a/drivers/staging/keucr/msscsi.c
+++ b/drivers/staging/keucr/msscsi.c
@@ -9,69 +9,88 @@
 #include "usb.h"
 #include "scsiglue.h"
 #include "transport.h"
+#include "msscsi.h"
 
-int MS_SCSI_Test_Unit_Ready (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Inquiry         (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Mode_Sense      (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Start_Stop      (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Read_Capacity   (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Read            (struct us_data *us, struct scsi_cmnd *srb);
-int MS_SCSI_Write           (struct us_data *us, struct scsi_cmnd *srb);
 
-//----- MS_SCSIIrp() --------------------------------------------------
+/*
+ * MS_SCSIIrp()
+ */
 int MS_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 {
 	int    result;
 
 	us->SrbStatus = SS_SUCCESS;
-	switch (srb->cmnd[0])
-	{
-		case TEST_UNIT_READY :  result = MS_SCSI_Test_Unit_Ready (us, srb);  break; //0x00
-		case INQUIRY         :  result = MS_SCSI_Inquiry         (us, srb);  break; //0x12
-		case MODE_SENSE      :  result = MS_SCSI_Mode_Sense      (us, srb);  break; //0x1A
-		case READ_CAPACITY   :  result = MS_SCSI_Read_Capacity   (us, srb);  break; //0x25
-		case READ_10         :  result = MS_SCSI_Read            (us, srb);  break; //0x28
-		case WRITE_10        :  result = MS_SCSI_Write           (us, srb);  break; //0x2A
-
-		default:
-			us->SrbStatus = SS_ILLEGAL_REQUEST;
-			result = USB_STOR_TRANSPORT_FAILED;
-			break;
+	switch (srb->cmnd[0]) {
+	case TEST_UNIT_READY:
+		result = MS_SCSI_Test_Unit_Ready(us, srb);
+		break; /* 0x00 */
+	case INQUIRY:
+		result = MS_SCSI_Inquiry(us, srb);
+		break; /* 0x12 */
+	case MODE_SENSE:
+		result = MS_SCSI_Mode_Sense(us, srb);
+		break; /* 0x1A */
+	case READ_CAPACITY:
+		result = MS_SCSI_Read_Capacity(us, srb);
+		break; /* 0x25 */
+	case READ_10:
+		result = MS_SCSI_Read(us, srb);
+		break; /* 0x28 */
+	case WRITE_10:
+		result = MS_SCSI_Write(us, srb);
+		break; /* 0x2A */
+
+	default:
+		us->SrbStatus = SS_ILLEGAL_REQUEST;
+		result = USB_STOR_TRANSPORT_FAILED;
+		break;
 	}
 	return result;
 }
 
-//----- MS_SCSI_Test_Unit_Ready() --------------------------------------------------
+/*
+ * MS_SCSI_Test_Unit_Ready()
+ */
 int MS_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("MS_SCSI_Test_Unit_Ready\n");
+	/* printk("MS_SCSI_Test_Unit_Ready\n"); */
 	if (us->MS_Status.Insert && us->MS_Status.Ready)
 		return USB_STOR_TRANSPORT_GOOD;
-	else
-	{
+	else {
 		ENE_MSInit(us);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
-		
+
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_SCSI_Inquiry() --------------------------------------------------
+/*
+ * MS_SCSI_Inquiry()
+ */
 int MS_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
-	//printk("MS_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
-
+	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00,
+			     0x00, 0x00, 0x55, 0x53, 0x42, 0x32,
+			     0x2E, 0x30, 0x20, 0x20, 0x43, 0x61,
+			     0x72, 0x64, 0x52, 0x65, 0x61, 0x64,
+			     0x65, 0x72, 0x20, 0x20, 0x20, 0x20,
+			     0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+
+	/* printk(KERN_INFO "MS_SCSI_Inquiry\n"); */
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
 
-//----- MS_SCSI_Mode_Sense() --------------------------------------------------
+/*
+ * MS_SCSI_Mode_Sense()
+ */
 int MS_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	BYTE	mediaNoWP[12] = {0x0b, 0x00, 0x00, 0x08, 0x00, 0x00,
+				 0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
+	BYTE	mediaWP[12]   = {0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
+				 0x71, 0xc0, 0x00, 0x00, 0x02, 0x00};
 
 	if (us->MS_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
@@ -82,7 +101,9 @@ int MS_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_SCSI_Read_Capacity() --------------------------------------------------
+/*
+ * MS_SCSI_Read_Capacity()
+ */
 int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
@@ -91,60 +112,66 @@ int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	WORD    bl_len;
 	BYTE    buf[8];
 
-	printk("MS_SCSI_Read_Capacity\n");
+	printk(KERN_INFO "MS_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
-	if ( us->MS_Status.IsMSPro )
+	if (us->MS_Status.IsMSPro)
 		bl_num = us->MSP_TotalBlock - 1;
 	else
-		bl_num = us->MS_Lib.NumberOfLogBlock * us->MS_Lib.blockSize * 2 - 1;
+		bl_num = us->MS_Lib.NumberOfLogBlock *
+			 us->MS_Lib.blockSize * 2 - 1;
 
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
+	printk(KERN_INFO "bl_len = %x\n", bl_len);
+	printk(KERN_INFO "bl_num = %x\n", bl_num);
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
+	/* usb_stor_set_xfer_buf(us, buf,
+		srb->request_bufflen, srb, TO_XFER_BUF); */
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_SCSI_Read() --------------------------------------------------
+/*
+ * MS_SCSI_Read()
+ */
 int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
+	int result = 0;
 	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	DWORD bn  =  ((Cdb[2] << 24) & 0xff000000) |
+		     ((Cdb[3] << 16) & 0x00ff0000) |
+		     ((Cdb[4] << 8) & 0x0000ff00) |
+		     ((Cdb[5] << 0) & 0x000000ff);
+	WORD  blen = ((Cdb[7] << 8) & 0xff00) |
+		     ((Cdb[8] << 0) & 0x00ff);
 	DWORD	blenByte = blen * 0x200;
 
-	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
-	
+	/* printk("SCSIOP_READ --- bn = %X, blen = %X,
+		  srb->use_sg = %X\n", bn, blen, srb->use_sg); */
+
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (us->MS_Status.IsMSPro)
-	{
+	if (us->MS_Status.IsMSPro) {
 		result = ENE_LoadBinCode(us, MSP_RW_PATTERN);
-		if (result != USB_STOR_XFER_GOOD)
-		{
-			printk("Load MSP RW pattern Fail !!\n");
+		if (result != USB_STOR_XFER_GOOD) {
+			printk(KERN_ERR "Load MSP RW pattern Fail !!\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
-		// set up the command wrapper
+		/* set up the command wrapper */
 		memset(bcb, 0, sizeof(bcb));
 		bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 		bcb->DataTransferLength = blenByte;
@@ -157,11 +184,9 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		bcb->CDB[2] = (BYTE)(bn>>24);
 
 		result = ENE_SendScsiCmd(us, FDIR_READ, scsi_sglist(srb), 1);
-	}
-	else
-	{
+	} else {
 		void	*buf;
-		int	offset=0;
+		int	offset = 0;
 		WORD	phyblk, logblk;
 		BYTE	PageNum;
 		WORD	len;
@@ -172,9 +197,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			return USB_STOR_TRANSPORT_ERROR;
 
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
-		if (result != USB_STOR_XFER_GOOD)
-		{
-			printk("Load MS RW pattern Fail !!\n");
+		if (result != USB_STOR_XFER_GOOD) {
+			printk(KERN_ERR "Load MS RW pattern Fail !!\n");
 			result = USB_STOR_TRANSPORT_ERROR;
 			goto exit;
 		}
@@ -182,9 +206,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		logblk  = (WORD)(bn / us->MS_Lib.PagesPerBlock);
 		PageNum = (BYTE)(bn % us->MS_Lib.PagesPerBlock);
 
-		while(1)
-		{
-			if (blen > (us->MS_Lib.PagesPerBlock-PageNum) )
+		while (1) {
+			if (blen > (us->MS_Lib.PagesPerBlock-PageNum))
 				len = us->MS_Lib.PagesPerBlock-PageNum;
 			else
 				len = blen;
@@ -192,7 +215,7 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			phyblk = MS_LibConv2Physical(us, logblk);
 			blkno  = phyblk * 0x20 + PageNum;
 
-			// set up the command wrapper
+			/* set up the command wrapper */
 			memset(bcb, 0, sizeof(bcb));
 			bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 			bcb->DataTransferLength = 0x200 * len;
@@ -205,15 +228,16 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			bcb->CDB[2] = (BYTE)(blkno>>24);
 
 			result = ENE_SendScsiCmd(us, FDIR_READ, buf+offset, 0);
-			if (result != USB_STOR_XFER_GOOD)
-			{
-				printk("MS_SCSI_Read --- result = %x\n", result);
-				result =  USB_STOR_TRANSPORT_ERROR;
+			if (result != USB_STOR_XFER_GOOD) {
+				printk(KERN_ERR
+				       "MS_SCSI_Read --- result = %x\n",
+				       result);
+				result = USB_STOR_TRANSPORT_ERROR;
 				goto exit;
 			}
 
 			blen -= len;
-			if (blen<=0)
+			if (blen <= 0)
 				break;
 			logblk++;
 			PageNum = 0;
@@ -226,30 +250,33 @@ exit:
 	return result;
 }
 
-//----- MS_SCSI_Write() --------------------------------------------------
+/*
+ * MS_SCSI_Write()
+ */
 int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	int result=0;
+	int result = 0;
 	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-                   ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	DWORD bn  =  ((Cdb[2] << 24) & 0xff000000) |
+		     ((Cdb[3] << 16) & 0x00ff0000) |
+		     ((Cdb[4] << 8) & 0x0000ff00) |
+		     ((Cdb[5] << 0) & 0x000000ff);
+	WORD  blen = ((Cdb[7] << 8) & 0xff00) |
+		     ((Cdb[8] << 0) & 0x00ff);
 	DWORD	blenByte = blen * 0x200;
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (us->MS_Status.IsMSPro)
-	{
+	if (us->MS_Status.IsMSPro) {
 		result = ENE_LoadBinCode(us, MSP_RW_PATTERN);
-		if (result != USB_STOR_XFER_GOOD)
-		{
-			printk("Load MSP RW pattern Fail !!\n");
+		if (result != USB_STOR_XFER_GOOD) {
+			printk(KERN_ERR "Load MSP RW pattern Fail !!\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
-		// set up the command wrapper
+		/* set up the command wrapper */
 		memset(bcb, 0, sizeof(bcb));
 		bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 		bcb->DataTransferLength = blenByte;
@@ -262,11 +289,9 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		bcb->CDB[2] = (BYTE)(bn>>24);
 
 		result = ENE_SendScsiCmd(us, FDIR_WRITE, scsi_sglist(srb), 1);
-	}
-	else
-	{
+	} else {
 		void	*buf;
-		int	offset=0;
+		int	offset = 0;
 		WORD	PhyBlockAddr;
 		BYTE	PageNum;
 		DWORD	result;
@@ -278,9 +303,8 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		usb_stor_set_xfer_buf(us, buf, blenByte, srb, FROM_XFER_BUF);
 
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
-		if (result != USB_STOR_XFER_GOOD)
-		{
-			printk("Load MS RW pattern Fail !!\n");
+		if (result != USB_STOR_XFER_GOOD) {
+			printk(KERN_ERR "Load MS RW pattern Fail !!\n");
 			result = USB_STOR_TRANSPORT_ERROR;
 			goto exit;
 		}
@@ -288,9 +312,8 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		PhyBlockAddr = (WORD)(bn / us->MS_Lib.PagesPerBlock);
 		PageNum      = (BYTE)(bn % us->MS_Lib.PagesPerBlock);
 
-		while(1)
-		{
-			if (blen > (us->MS_Lib.PagesPerBlock-PageNum) )
+		while (1) {
+			if (blen > (us->MS_Lib.PagesPerBlock-PageNum))
 				len = us->MS_Lib.PagesPerBlock-PageNum;
 			else
 				len = blen;
@@ -298,10 +321,13 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 			oldphy = MS_LibConv2Physical(us, PhyBlockAddr);
 			newphy = MS_LibSearchBlockFromLogical(us, PhyBlockAddr);
 
-			result = MS_ReaderCopyBlock(us, oldphy, newphy, PhyBlockAddr, PageNum, buf+offset, len);
-			if (result != USB_STOR_XFER_GOOD)
-			{
-				printk("MS_SCSI_Write --- result = %x\n", result);
+			result = MS_ReaderCopyBlock(us, oldphy, newphy,
+						    PhyBlockAddr, PageNum,
+						    buf+offset, len);
+			if (result != USB_STOR_XFER_GOOD) {
+				printk(KERN_ERR
+				       "MS_SCSI_Write --- \
+				       result = %x\n", result);
 				result =  USB_STOR_TRANSPORT_ERROR;
 				goto exit;
 			}
@@ -310,7 +336,7 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 			MS_LibForceSetLogicalPair(us, PhyBlockAddr, newphy);
 
 			blen -= len;
-			if (blen<=0)
+			if (blen <= 0)
 				break;
 			PhyBlockAddr++;
 			PageNum = 0;
diff --git a/drivers/staging/keucr/msscsi.h b/drivers/staging/keucr/msscsi.h
new file mode 100644
index 0000000..147c0b9
--- /dev/null
+++ b/drivers/staging/keucr/msscsi.h
@@ -0,0 +1,12 @@
+/*
+ *
+ */
+
+int MS_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Start_Stop(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb);
+int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb);
+
-- 
1.7.1

