Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab0KPGK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:10:58 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38405 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0KPGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Z2C0la8NGVZiUjQZSmDXkJEgCFqBwgHIIq9dsSMHq+9pNe4FUGFBMnlA9JVg6ChOVx
         9EW6/LwmWoP36fmEZ+jAiojLh8ICLioY03qh/or5OLLDYcgwajZwYF9ENuihi6Ue3EoK
         0dBI+dMm/0v6S6WhimTsjZnR5syb9eG5yR8Xs=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, acho@novell.com,
        segooon@gmail.com
Subject: [PATCH 1/3] staging/keucr: fix keucr init code style
Date: Tue, 16 Nov 2010 14:10:56 +0800
Message-Id: <1289887856-2884-1-git-send-email-acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr init.c init.h code style

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/init.c |  408 +++++++++++++++++++++--------------------
 drivers/staging/keucr/init.h |    3 +
 2 files changed, 212 insertions(+), 199 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 1934805..a3c8114 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -13,41 +13,35 @@
 
 BYTE		IsSSFDCCompliance;
 BYTE		IsXDCompliance;
-extern DWORD MediaChange;
-extern int	Check_D_MediaFmt(struct us_data *);
 
-//----- ENE_InitMedia() ----------------------------------------
+/*
+ * ENE_InitMedia():
+ */
 int ENE_InitMedia(struct us_data *us)
 {
 	int	result;
 	BYTE	MiscReg03 = 0;
 
-	printk("--- Initial Nedia ---\n");
+	printk(KERN_INFO "--- Initial Nedia ---\n");
 	result = ENE_Read_BYTE(us, REG_CARD_STATUS, &MiscReg03);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Read register fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Read register fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
-	printk("MiscReg03 = %x\n", MiscReg03);
+	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
 
-	if (MiscReg03 & 0x01)
-	{
-		if (!us->SD_Status.Ready)
-		{
+	if (MiscReg03 & 0x01) {
+		if (!us->SD_Status.Ready) {
 			result = ENE_SDInit(us);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
 
-	if (MiscReg03 & 0x02)
-	{
-		if (!us->SM_Status.Ready && !us->MS_Status.Ready)
-		{
+	if (MiscReg03 & 0x02) {
+		if (!us->SM_Status.Ready && !us->MS_Status.Ready) {
 			result = ENE_SMInit(us);
-			if (result != USB_STOR_XFER_GOOD)
-			{
+			if (result != USB_STOR_XFER_GOOD) {
 				result = ENE_MSInit(us);
 				if (result != USB_STOR_XFER_GOOD)
 					return USB_STOR_TRANSPORT_ERROR;
@@ -58,7 +52,9 @@ int ENE_InitMedia(struct us_data *us)
 	return result;
 }
 
-//----- ENE_Read_BYTE() ----------------------------------------
+/*
+ * ENE_Read_BYTE() :
+ */
 int ENE_Read_BYTE(struct us_data *us, WORD index, void *buf)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
@@ -76,19 +72,20 @@ int ENE_Read_BYTE(struct us_data *us, WORD index, void *buf)
 	return result;
 }
 
-//----- ENE_SDInit() ---------------------
+/*
+ * ENE_SDInit():
+ */
 int ENE_SDInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	BYTE	buf[0x200];
 
-	printk("transport --- ENE_SDInit\n");
-	// SD Init Part-1
+	printk(KERN_INFO "transport --- ENE_SDInit\n");
+	/* SD Init Part-1 */
 	result = ENE_LoadBinCode(us, SD_INIT1_PATTERN);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Load SD Init Code Part-1 Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Load SD Init Code Part-1 Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -98,17 +95,15 @@ int ENE_SDInit(struct us_data *us)
 	bcb->CDB[0] = 0xF2;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, NULL, 0);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Exection SD Init Code Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Exection SD Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	// SD Init Part-2
+	/* SD Init Part-2 */
 	result = ENE_LoadBinCode(us, SD_INIT2_PATTERN);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Load SD Init Code Part-2 Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Load SD Init Code Part-2 Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -119,45 +114,41 @@ int ENE_SDInit(struct us_data *us)
 	bcb->CDB[0]			= 0xF1;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Exection SD Init Code Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Exection SD Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	us->SD_Status =  *(PSD_STATUS)&buf[0];
-	if (us->SD_Status.Insert && us->SD_Status.Ready)
-	{
+	if (us->SD_Status.Insert && us->SD_Status.Ready) {
 		ENE_ReadSDReg(us, (PBYTE)&buf);
-		printk("Insert     = %x\n", us->SD_Status.Insert);
-		printk("Ready      = %x\n", us->SD_Status.Ready);
-		printk("IsMMC      = %x\n", us->SD_Status.IsMMC);
-		printk("HiCapacity = %x\n", us->SD_Status.HiCapacity);
-		printk("HiSpeed    = %x\n", us->SD_Status.HiSpeed);
-		printk("WtP        = %x\n", us->SD_Status.WtP);
-	}
-	else
-	{
-		printk("SD Card Not Ready --- %x\n", buf[0]);
+		printk(KERN_INFO "Insert     = %x\n", us->SD_Status.Insert);
+		printk(KERN_INFO "Ready      = %x\n", us->SD_Status.Ready);
+		printk(KERN_INFO "IsMMC      = %x\n", us->SD_Status.IsMMC);
+		printk(KERN_INFO "HiCapacity = %x\n", us->SD_Status.HiCapacity);
+		printk(KERN_INFO "HiSpeed    = %x\n", us->SD_Status.HiSpeed);
+		printk(KERN_INFO "WtP        = %x\n", us->SD_Status.WtP);
+	} else {
+		printk(KERN_ERR "SD Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_MSInit() ----------------------------------------
+/*
+ * ENE_MSInit():
+ */
 int ENE_MSInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	BYTE	buf[0x200];
 	WORD	MSP_BlockSize, MSP_UserAreaBlocks;
-	
 
-	printk("transport --- ENE_MSInit\n");
+	printk(KERN_INFO "transport --- ENE_MSInit\n");
 	result = ENE_LoadBinCode(us, MS_INIT_PATTERN);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Load MS Init Code Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Load MS Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -169,53 +160,49 @@ int ENE_MSInit(struct us_data *us)
 	bcb->CDB[1]			= 0x01;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Exection MS Init Code Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Exection MS Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	us->MS_Status = *(PMS_STATUS)&buf[0];
 
-	if (us->MS_Status.Insert && us->MS_Status.Ready)
-	{
-		printk("Insert     = %x\n", us->MS_Status.Insert);
-		printk("Ready      = %x\n", us->MS_Status.Ready);
-		printk("IsMSPro    = %x\n", us->MS_Status.IsMSPro);
-		printk("IsMSPHG    = %x\n", us->MS_Status.IsMSPHG);
-		printk("WtP        = %x\n", us->MS_Status.WtP);
-		if (us->MS_Status.IsMSPro)
-		{
-			MSP_BlockSize      = (buf[6] <<8) | buf[7];
-			MSP_UserAreaBlocks = (buf[10]<<8) | buf[11];
+	if (us->MS_Status.Insert && us->MS_Status.Ready) {
+		printk(KERN_INFO "Insert     = %x\n", us->MS_Status.Insert);
+		printk(KERN_INFO "Ready      = %x\n", us->MS_Status.Ready);
+		printk(KERN_INFO "IsMSPro    = %x\n", us->MS_Status.IsMSPro);
+		printk(KERN_INFO "IsMSPHG    = %x\n", us->MS_Status.IsMSPHG);
+		printk(KERN_INFO "WtP        = %x\n", us->MS_Status.WtP);
+		if (us->MS_Status.IsMSPro) {
+			MSP_BlockSize      = (buf[6] << 8) | buf[7];
+			MSP_UserAreaBlocks = (buf[10] << 8) | buf[11];
 			us->MSP_TotalBlock = MSP_BlockSize * MSP_UserAreaBlocks;
-		}
-		else
+		} else {
 			MS_CardInit(us);
-		printk("MS Init Code OK !!\n");
-	}
-	else
-	{
-		printk("MS Card Not Ready --- %x\n", buf[0]);
+		}
+		printk(KERN_INFO "MS Init Code OK !!\n");
+	} else {
+		printk(KERN_ERR "MS Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_SMInit() ----------------------------------------
+/*
+ *ENE_SMInit()
+ */
 int ENE_SMInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	BYTE	buf[0x200];
 
-	printk("transport --- ENE_SMInit\n");
+	printk(KERN_INFO "transport --- ENE_SMInit\n");
 
 	result = ENE_LoadBinCode(us, SM_INIT_PATTERN);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Load SM Init Code Fail !!\n");
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "Load SM Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -227,9 +214,9 @@ int ENE_SMInit(struct us_data *us)
 	bcb->CDB[1]			= 0x01;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("Exection SM Init Code Fail !! result = %x\n", result);
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR \
+		       "Exection SM Init Code Fail !! result = %x\n", result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -238,32 +225,31 @@ int ENE_SMInit(struct us_data *us)
 	us->SM_DeviceID = buf[1];
 	us->SM_CardID   = buf[2];
 
-	if (us->SM_Status.Insert && us->SM_Status.Ready)
-	{
-		printk("Insert     = %x\n", us->SM_Status.Insert);
-		printk("Ready      = %x\n", us->SM_Status.Ready);
-		printk("WtP        = %x\n", us->SM_Status.WtP);
-		printk("DeviceID   = %x\n", us->SM_DeviceID);
-		printk("CardID     = %x\n", us->SM_CardID);
+	if (us->SM_Status.Insert && us->SM_Status.Ready) {
+		printk(KERN_INFO "Insert     = %x\n", us->SM_Status.Insert);
+		printk(KERN_INFO "Ready      = %x\n", us->SM_Status.Ready);
+		printk(KERN_INFO "WtP        = %x\n", us->SM_Status.WtP);
+		printk(KERN_INFO "DeviceID   = %x\n", us->SM_DeviceID);
+		printk(KERN_INFO "CardID     = %x\n", us->SM_CardID);
 		MediaChange = 1;
 		Check_D_MediaFmt(us);
-	}
-	else
-	{
-		printk("SM Card Not Ready --- %x\n", buf[0]);
+	} else {
+		printk(KERN_ERR "SM Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_ReadSDReg() ----------------------------------------------
+/*
+ * ENE_ReadSDReg()
+ */
 int ENE_ReadSDReg(struct us_data *us, u8 *RdBuf)
 {
 	WORD	tmpreg;
 	DWORD	reg4b;
-	
-	//printk("transport --- ENE_ReadSDReg\n");
+
+	/* printk("transport --- ENE_ReadSDReg\n"); */
 	reg4b = *(PDWORD)&RdBuf[0x18];
 	us->SD_READ_BL_LEN = (BYTE)((reg4b >> 8) & 0x0f);
 
@@ -277,74 +263,75 @@ int ENE_ReadSDReg(struct us_data *us, u8 *RdBuf)
 	if (us->SD_Status.HiCapacity && us->SD_Status.IsMMC)
 		us->HC_C_SIZE = *(PDWORD)(&RdBuf[0x100]);
 
-	if (us->SD_READ_BL_LEN > SD_BLOCK_LEN)
-	{
-		us->SD_Block_Mult = 1 << (us->SD_READ_BL_LEN - SD_BLOCK_LEN);		us->SD_READ_BL_LEN = SD_BLOCK_LEN;
-	}
-	else
-	{		us->SD_Block_Mult = 1;
+	if (us->SD_READ_BL_LEN > SD_BLOCK_LEN) {
+		us->SD_Block_Mult =
+			1 << (us->SD_READ_BL_LEN - SD_BLOCK_LEN);
+		us->SD_READ_BL_LEN = SD_BLOCK_LEN;
+	} else {
+		us->SD_Block_Mult = 1;
 	}
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_LoadBinCode() ---------------------
+/*
+ * ENE_LoadBinCode()
+ */
 int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result;
-	//void *buf;
+	/* void *buf; */
 	PBYTE buf;
 
-	//printk("transport --- ENE_LoadBinCode\n");
+	/* printk("transport --- ENE_LoadBinCode\n"); */
 	if (us->BIN_FLAG == flag)
 		return USB_STOR_TRANSPORT_GOOD;
 
 	buf = kmalloc(0x800, GFP_KERNEL);
 	if (buf == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
-	switch ( flag )
-	{
-		// For SD
-		case SD_INIT1_PATTERN:
-			printk("SD_INIT1_PATTERN\n");
-			memcpy(buf, SD_Init1, 0x800);
+	switch (flag) {
+	/* For SD */
+	case SD_INIT1_PATTERN:
+		printk(KERN_INFO "SD_INIT1_PATTERN\n");
+		memcpy(buf, SD_Init1, 0x800);
 		break;
-		case SD_INIT2_PATTERN:
-			printk("SD_INIT2_PATTERN\n");
-			memcpy(buf, SD_Init2, 0x800);
+	case SD_INIT2_PATTERN:
+		printk(KERN_INFO "SD_INIT2_PATTERN\n");
+		memcpy(buf, SD_Init2, 0x800);
 		break;
-		case SD_RW_PATTERN:
-			printk("SD_RW_PATTERN\n");
-			memcpy(buf, SD_Rdwr, 0x800);
+	case SD_RW_PATTERN:
+		printk(KERN_INFO "SD_RW_PATTERN\n");
+		memcpy(buf, SD_Rdwr, 0x800);
 		break;
-		// For MS
-		case MS_INIT_PATTERN:
-			printk("MS_INIT_PATTERN\n");
-			memcpy(buf, MS_Init, 0x800);
+	/* For MS */
+	case MS_INIT_PATTERN:
+		printk(KERN_INFO "MS_INIT_PATTERN\n");
+		memcpy(buf, MS_Init, 0x800);
 		break;
-		case MSP_RW_PATTERN:
-			printk("MSP_RW_PATTERN\n");
-			memcpy(buf, MSP_Rdwr, 0x800);
+	case MSP_RW_PATTERN:
+		printk(KERN_INFO "MSP_RW_PATTERN\n");
+		memcpy(buf, MSP_Rdwr, 0x800);
 		break;
-		case MS_RW_PATTERN:
-			printk("MS_RW_PATTERN\n");
-			memcpy(buf, MS_Rdwr, 0x800);
+	case MS_RW_PATTERN:
+		printk(KERN_INFO "MS_RW_PATTERN\n");
+		memcpy(buf, MS_Rdwr, 0x800);
 		break;
-		// For SS
-		case SM_INIT_PATTERN:
-			printk("SM_INIT_PATTERN\n");
-			memcpy(buf, SM_Init, 0x800);
+	/* For SS */
+	case SM_INIT_PATTERN:
+		printk(KERN_INFO "SM_INIT_PATTERN\n");
+		memcpy(buf, SM_Init, 0x800);
 		break;
-		case SM_RW_PATTERN:
-			printk("SM_RW_PATTERN\n");
-			memcpy(buf, SM_Rdwr, 0x800);
+	case SM_RW_PATTERN:
+		printk(KERN_INFO "SM_RW_PATTERN\n");
+		memcpy(buf, SM_Rdwr, 0x800);
 		break;
 	}
 
 	memset(bcb, 0, sizeof(bcb));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = 0x800;
-	bcb->Flags =0x00;
+	bcb->Flags = 0x00;
 	bcb->CDB[0] = 0xEF;
 
 	result = ENE_SendScsiCmd(us, FDIR_WRITE, buf, 0);
@@ -354,54 +341,58 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	return result;
 }
 
-//----- ENE_SendScsiCmd() ---------------------
+/*
+ * ENE_SendScsiCmd():
+ */
 int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 
 	int result;
-	unsigned int transfer_length=bcb->DataTransferLength, cswlen=0, partial=0;
+	unsigned int transfer_length = bcb->DataTransferLength,
+		     cswlen = 0, partial = 0;
 	unsigned int residue;
 
-	//printk("transport --- ENE_SendScsiCmd\n");
-	// send cmd to out endpoint
-	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcb, US_BULK_CB_WRAP_LEN, NULL);
-	if (result != USB_STOR_XFER_GOOD)
-	{
-		printk("send cmd to out endpoint fail ---\n");
+	/*printk("transport --- ENE_SendScsiCmd\n");*/
+	/* send cmd to out endpoint */
+	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
+					    bcb, US_BULK_CB_WRAP_LEN, NULL);
+	if (result != USB_STOR_XFER_GOOD) {
+		printk(KERN_ERR "send cmd to out endpoint fail ---\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (buf)
-	{
-		unsigned int pipe = fDir == FDIR_READ ? us->recv_bulk_pipe : us->send_bulk_pipe;
-		// Bulk
+	if (buf) {
+		unsigned int pipe = fDir == \
+			FDIR_READ ? us->recv_bulk_pipe : us->send_bulk_pipe;
+		/* Bulk */
 		if (use_sg)
 			result = usb_stor_bulk_srb(us, pipe, us->srb);
 		else
-			result = usb_stor_bulk_transfer_sg(us, pipe, buf, transfer_length, 0, &partial);
-		if (result != USB_STOR_XFER_GOOD)
-		{
-			printk("data transfer fail ---\n");
+			result = usb_stor_bulk_transfer_sg(us, pipe,
+				 buf, transfer_length, 0, &partial);
+		if (result != USB_STOR_XFER_GOOD) {
+			printk(KERN_ERR "data transfer fail ---\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
 
-	// Get CSW for device status
-	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+	/* Get CSW for device status */
+	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
+					    bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 
-	if (result == USB_STOR_XFER_SHORT && cswlen == 0)
-	{
-		printk("Received 0-length CSW; retrying...\n");
-		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
+		printk(KERN_WARNING "Received 0-length CSW; retrying...\n");
+		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
+			 bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
-	if (result == USB_STOR_XFER_STALLED)
-	{
+	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
-		printk("Attempting to get CSW (2nd try)...\n");
-		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
+		printk(KERN_WARNING "Attempting to get CSW (2nd try)...\n");
+		result = usb_stor_bulk_transfer_buf(us,
+			 us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
 
 	if (result != USB_STOR_XFER_GOOD)
@@ -410,12 +401,14 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
 
-	/* try to compute the actual residue, based on how much data
-	 * was really transferred and what the device tells us */
-	if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE))
-	{
+	/*
+	 * try to compute the actual residue, based on how much data
+	 * was really transferred and what the device tells us.
+	 */
+	if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE)) {
 		residue = min(residue, transfer_length);
-		scsi_set_resid(us->srb, max(scsi_get_resid(us->srb), (int) residue));
+		scsi_set_resid(us->srb,
+			       max(scsi_get_resid(us->srb), (int) residue));
 	}
 
 	if (bcs->Status != US_BULK_STAT_OK)
@@ -424,35 +417,40 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_Read_Data() ---------------------
+/*
+ * ENE_Read_Data()
+ */
 int ENE_Read_Data(struct us_data *us, void *buf, unsigned int length)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 	int result;
 
-	//printk("transport --- ENE_Read_Data\n");
-	// set up the command wrapper
+	/* printk("transport --- ENE_Read_Data\n"); */
+	/* set up the command wrapper */
 	memset(bcb, 0, sizeof(bcb));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = length;
-	bcb->Flags =0x80;
+	bcb->Flags = 0x80;
 	bcb->CDB[0] = 0xED;
 	bcb->CDB[2] = 0xFF;
 	bcb->CDB[3] = 0x81;
 
-	// send cmd to out endpoint
-	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcb, US_BULK_CB_WRAP_LEN, NULL);
+	/* send cmd to out endpoint */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->send_bulk_pipe, bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// R/W data
-	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, buf, length, NULL);
+	/* R/W data */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->recv_bulk_pipe, buf, length, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// Get CSW for device status
-	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
+	/* Get CSW for device status */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 	if (bcs->Status != US_BULK_STAT_OK)
@@ -461,35 +459,40 @@ int ENE_Read_Data(struct us_data *us, void *buf, unsigned int length)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- ENE_Write_Data() ---------------------
+/*
+ * ENE_Write_Data():
+ */
 int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 	int result;
 
-	//printk("transport --- ENE_Write_Data\n");
-	// set up the command wrapper
+	/* printk("transport --- ENE_Write_Data\n"); */
+	/* set up the command wrapper */
 	memset(bcb, 0, sizeof(bcb));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = length;
-	bcb->Flags =0x00;
+	bcb->Flags = 0x00;
 	bcb->CDB[0] = 0xEE;
 	bcb->CDB[2] = 0xFF;
 	bcb->CDB[3] = 0x81;
 
-	// send cmd to out endpoint
-	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcb, US_BULK_CB_WRAP_LEN, NULL);
+	/* send cmd to out endpoint */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->send_bulk_pipe, bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// R/W data
-	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, buf, length, NULL);
+	/* R/W data */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->send_bulk_pipe, buf, length, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// Get CSW for device status
-	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
+	/* Get CSW for device status */
+	result = usb_stor_bulk_transfer_buf(us,
+			us->recv_bulk_pipe, bcs, US_BULK_CS_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 	if (bcs->Status != US_BULK_STAT_OK)
@@ -498,42 +501,49 @@ int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- usb_stor_print_cmd() ---------------------
+/*
+ * usb_stor_print_cmd():
+ */
 void usb_stor_print_cmd(struct scsi_cmnd *srb)
 {
 	PBYTE	Cdb = srb->cmnd;
 	DWORD	cmd = Cdb[0];
-	DWORD	bn  =	((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
-			((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD	blen = ((Cdb[7]<< 8) & 0xff00) | ((Cdb[8]<< 0) & 0x00ff);
+	DWORD	bn = ((Cdb[2] << 24) & 0xff000000) |
+		     ((Cdb[3] << 16) & 0x00ff0000) |
+		     ((Cdb[4] << 8) & 0x0000ff00) |
+		     ((Cdb[5] << 0) & 0x000000ff);
+	WORD	blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
-		//printk("scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd);
+		/* printk("scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
 		break;
 	case INQUIRY:
-		printk("scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
+		printk(KERN_INFO "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
 		break;
 	case MODE_SENSE:
-		printk("scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
+		printk(KERN_INFO "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
 		break;
 	case START_STOP:
-		printk("scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
+		printk(KERN_INFO "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
 		break;
 	case READ_CAPACITY:
-		printk("scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
+		printk(KERN_INFO "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
 		break;
 	case READ_10:
-		//printk("scsi cmd %X --- SCSIOP_READ, bn = %X, blen = %X\n", cmd, bn, blen);
+		/* printk(KERN_INFO "scsi cmd %X --- \
+			SCSIOP_READ, bn = %X, blen = %X\n", cmd, bn, blen); */
 		break;
 	case WRITE_10:
-		//printk("scsi cmd %X --- SCSIOP_WRITE, bn = %X, blen = %X\n", cmd, bn, blen);
+		/* printk(KERN_INFO "scsi cmd %X --- \
+			SCSIOP_WRITE, bn = %X, blen = %X\n", cmd, bn, blen); */
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		printk("scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
+		printk(KERN_INFO
+			"scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
 		break;
 	default:
-		printk("scsi cmd %X --- Other cmd\n", cmd);
+		printk(KERN_INFO "scsi cmd %X --- Other cmd\n", cmd);
 		break;
 	}
 	bn = 0;
diff --git a/drivers/staging/keucr/init.h b/drivers/staging/keucr/init.h
index cd199fc..5706829 100644
--- a/drivers/staging/keucr/init.h
+++ b/drivers/staging/keucr/init.h
@@ -1,5 +1,8 @@
 #include "common.h"
 
+extern DWORD MediaChange;
+extern int      Check_D_MediaFmt(struct us_data *);
+
 BYTE SD_Init1[] = {
 0x90, 0xFF, 0x09, 0xE0, 0x30, 0xE1, 0x06, 0x90,
 0xFF, 0x23, 0x74, 0x80, 0xF0, 0x90, 0xFF, 0x09,
-- 
1.7.1

