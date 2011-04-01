Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1DAGlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45590 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DAGlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=oPsnwxmz0EJZmoLQT3rMnCPsNe5I8uBnttFJAw2LnBQg+COmy1vYwE6uoDfRXfWG2D
         rX9DTHZiYDtjISxIH/UOH6khQIm/NInLSThekfwGjRDFyCnsr51ifoKgWU8tcwpcD6Va
         y5FDA7YKNUAJ/vQC98iGTxYgaoQKT8vsCs37I=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 1/5] staging/keucr: init use pr_<level> for messages
Date: Fri,  1 Apr 2011 14:38:39 +0800
Message-Id: <76f478d6f68cb72cc615e380ba595514c4e10da7.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init.c use pr_<level> for messages

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/init.c |   95 ++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 5c01f28..0727de8 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -22,13 +24,13 @@ int ENE_InitMedia(struct us_data *us)
 	int	result;
 	BYTE	MiscReg03 = 0;
 
-	printk(KERN_INFO "--- Init Media ---\n");
+	pr_info("--- Init Media ---\n");
 	result = ENE_Read_BYTE(us, REG_CARD_STATUS, &MiscReg03);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "Read register fail !!\n");
+		pr_err("Read register fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
-	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
+	pr_info("MiscReg03 = %x\n", MiscReg03);
 
 	if (MiscReg03 & 0x02) {
 		if (!us->SM_Status.Ready && !us->MS_Status.Ready) {
@@ -74,10 +76,10 @@ int ENE_MSInit(struct us_data *us)
 	BYTE	buf[0x200];
 	WORD	MSP_BlockSize, MSP_UserAreaBlocks;
 
-	printk(KERN_INFO "transport --- ENE_MSInit\n");
+	pr_info("transport --- ENE_MSInit\n");
 	result = ENE_LoadBinCode(us, MS_INIT_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "Load MS Init Code Fail !!\n");
+		pr_err("Load MS Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -90,18 +92,18 @@ int ENE_MSInit(struct us_data *us)
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "Exection MS Init Code Fail !!\n");
+		pr_err("Exection MS Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	us->MS_Status = *(PMS_STATUS)&buf[0];
 
 	if (us->MS_Status.Insert && us->MS_Status.Ready) {
-		printk(KERN_INFO "Insert     = %x\n", us->MS_Status.Insert);
-		printk(KERN_INFO "Ready      = %x\n", us->MS_Status.Ready);
-		printk(KERN_INFO "IsMSPro    = %x\n", us->MS_Status.IsMSPro);
-		printk(KERN_INFO "IsMSPHG    = %x\n", us->MS_Status.IsMSPHG);
-		printk(KERN_INFO "WtP        = %x\n", us->MS_Status.WtP);
+		pr_info("Insert     = %x\n", us->MS_Status.Insert);
+		pr_info("Ready      = %x\n", us->MS_Status.Ready);
+		pr_info("IsMSPro    = %x\n", us->MS_Status.IsMSPro);
+		pr_info("IsMSPHG    = %x\n", us->MS_Status.IsMSPHG);
+		pr_info("WtP        = %x\n", us->MS_Status.WtP);
 		if (us->MS_Status.IsMSPro) {
 			MSP_BlockSize      = (buf[6] << 8) | buf[7];
 			MSP_UserAreaBlocks = (buf[10] << 8) | buf[11];
@@ -109,9 +111,9 @@ int ENE_MSInit(struct us_data *us)
 		} else {
 			MS_CardInit(us);
 		}
-		printk(KERN_INFO "MS Init Code OK !!\n");
+		pr_info("MS Init Code OK !!\n");
 	} else {
-		printk(KERN_INFO "MS Card Not Ready --- %x\n", buf[0]);
+		pr_info("MS Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -127,11 +129,11 @@ int ENE_SMInit(struct us_data *us)
 	int	result;
 	BYTE	buf[0x200];
 
-	printk(KERN_INFO "transport --- ENE_SMInit\n");
+	pr_info("transport --- ENE_SMInit\n");
 
 	result = ENE_LoadBinCode(us, SM_INIT_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_INFO "Load SM Init Code Fail !!\n");
+		pr_info("Load SM Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -144,8 +146,7 @@ int ENE_SMInit(struct us_data *us)
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR
-		       "Exection SM Init Code Fail !! result = %x\n", result);
+		pr_err("Exection SM Init Code Fail !! result = %x\n", result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -155,15 +156,15 @@ int ENE_SMInit(struct us_data *us)
 	us->SM_CardID   = buf[2];
 
 	if (us->SM_Status.Insert && us->SM_Status.Ready) {
-		printk(KERN_INFO "Insert     = %x\n", us->SM_Status.Insert);
-		printk(KERN_INFO "Ready      = %x\n", us->SM_Status.Ready);
-		printk(KERN_INFO "WtP        = %x\n", us->SM_Status.WtP);
-		printk(KERN_INFO "DeviceID   = %x\n", us->SM_DeviceID);
-		printk(KERN_INFO "CardID     = %x\n", us->SM_CardID);
+		pr_info("Insert     = %x\n", us->SM_Status.Insert);
+		pr_info("Ready      = %x\n", us->SM_Status.Ready);
+		pr_info("WtP        = %x\n", us->SM_Status.WtP);
+		pr_info("DeviceID   = %x\n", us->SM_DeviceID);
+		pr_info("CardID     = %x\n", us->SM_CardID);
 		MediaChange = 1;
 		Check_D_MediaFmt(us);
 	} else {
-		printk(KERN_ERR "SM Card Not Ready --- %x\n", buf[0]);
+		pr_err("SM Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -180,7 +181,7 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	/* void *buf; */
 	PBYTE buf;
 
-	/* printk(KERN_INFO "transport --- ENE_LoadBinCode\n"); */
+	/* pr_info("transport --- ENE_LoadBinCode\n"); */
 	if (us->BIN_FLAG == flag)
 		return USB_STOR_TRANSPORT_GOOD;
 
@@ -190,24 +191,24 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	switch (flag) {
 	/* For MS */
 	case MS_INIT_PATTERN:
-		printk(KERN_INFO "MS_INIT_PATTERN\n");
+		pr_info("MS_INIT_PATTERN\n");
 		memcpy(buf, MS_Init, 0x800);
 		break;
 	case MSP_RW_PATTERN:
-		printk(KERN_INFO "MSP_RW_PATTERN\n");
+		pr_info("MSP_RW_PATTERN\n");
 		memcpy(buf, MSP_Rdwr, 0x800);
 		break;
 	case MS_RW_PATTERN:
-		printk(KERN_INFO "MS_RW_PATTERN\n");
+		pr_info("MS_RW_PATTERN\n");
 		memcpy(buf, MS_Rdwr, 0x800);
 		break;
 	/* For SS */
 	case SM_INIT_PATTERN:
-		printk(KERN_INFO "SM_INIT_PATTERN\n");
+		pr_info("SM_INIT_PATTERN\n");
 		memcpy(buf, SM_Init, 0x800);
 		break;
 	case SM_RW_PATTERN:
-		printk(KERN_INFO "SM_RW_PATTERN\n");
+		pr_info("SM_RW_PATTERN\n");
 		memcpy(buf, SM_Rdwr, 0x800);
 		break;
 	}
@@ -238,12 +239,12 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 		     cswlen = 0, partial = 0;
 	unsigned int residue;
 
-	/* printk(KERN_INFO "transport --- ENE_SendScsiCmd\n"); */
+	/* pr_info("transport --- ENE_SendScsiCmd\n"); */
 	/* send cmd to out endpoint */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 					    bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "send cmd to out endpoint fail ---\n");
+		pr_err("send cmd to out endpoint fail ---\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -262,7 +263,7 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 			result = usb_stor_bulk_transfer_sg(us, pipe, buf,
 						transfer_length, 0, &partial);
 		if (result != USB_STOR_XFER_GOOD) {
-			printk(KERN_ERR "data transfer fail ---\n");
+			pr_err("data transfer fail ---\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
@@ -272,14 +273,14 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 						US_BULK_CS_WRAP_LEN, &cswlen);
 
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
-		printk(KERN_WARNING "Received 0-length CSW; retrying...\n");
+		pr_warning("Received 0-length CSW; retrying...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 					bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
 	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
-		printk(KERN_WARNING "Attempting to get CSW (2nd try)...\n");
+		pr_warning("Attempting to get CSW (2nd try)...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 						bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
@@ -316,7 +317,7 @@ int ENE_Read_Data(struct us_data *us, void *buf, unsigned int length)
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 	int result;
 
-	/* printk(KERN_INFO "transport --- ENE_Read_Data\n"); */
+	/* pr_info("transport --- ENE_Read_Data\n"); */
 	/* set up the command wrapper */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -358,7 +359,7 @@ int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 	int result;
 
-	/* printk("transport --- ENE_Write_Data\n"); */
+	/* pr_info("transport --- ENE_Write_Data\n"); */
 	/* set up the command wrapper */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -406,37 +407,33 @@ void usb_stor_print_cmd(struct scsi_cmnd *srb)
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
-		/* printk(KERN_INFO
-			 "scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
+		/* pr_info("scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
 		break;
 	case INQUIRY:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
+		pr_info("scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
 		break;
 	case MODE_SENSE:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
+		pr_info("scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
 		break;
 	case START_STOP:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
+		pr_info("scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
 		break;
 	case READ_CAPACITY:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
+		pr_info("scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
 		break;
 	case READ_10:
-		/*  printk(KERN_INFO
-			   "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
+		/*  pr_info("scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
 			   ,cmd, bn, blen); */
 		break;
 	case WRITE_10:
-		/* printk(KERN_INFO
-			  "scsi cmd %X --- SCSIOP_WRITE,
+		/* pr_ifno("scsi cmd %X --- SCSIOP_WRITE,
 			  bn = %X, blen = %X\n" , cmd, bn, blen); */
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		printk(KERN_INFO
-			"scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
+		pr_info("scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
 		break;
 	default:
-		printk(KERN_INFO "scsi cmd %X --- Other cmd\n", cmd);
+		pr_info("scsi cmd %X --- Other cmd\n", cmd);
 		break;
 	}
 	bn = 0;
-- 
1.7.1

