Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab1CATaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:30:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46347 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab1CATaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rXDazhwyHxmSCBibv9foQtfGwmKYX/+1aoYuDa1Nls1TRbNn3pOSzBnO6PPl35fXJf
         qfdXUuHON4qTdP9z/xX0MQgEE/GqAxigmek5bTVtGOg/Fj7F7h30k7fquoskbN/sOznP
         mmWd6p34/HnrYGA5LYNl3uOPxcxrl+rR4HAos=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, acho@novell.com,
        Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: keucr: Remove all type defines
Date: Tue,  1 Mar 2011 20:29:50 +0100
Message-Id: <1299007790-5315-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all type defines from driver and replace them with kernel built-in types.

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/keucr/common.h    |    9 -
 drivers/staging/keucr/init.c      |   54 +++---
 drivers/staging/keucr/init.h      |   18 +-
 drivers/staging/keucr/ms.c        |  208 ++++++++++----------
 drivers/staging/keucr/ms.h        |  262 ++++++++++++------------
 drivers/staging/keucr/msscsi.c    |   76 ++++----
 drivers/staging/keucr/sdscsi.c    |   48 +++---
 drivers/staging/keucr/smcommon.h  |    4 +-
 drivers/staging/keucr/smil.h      |  128 ++++++------
 drivers/staging/keucr/smilecc.c   |   88 ++++----
 drivers/staging/keucr/smilmain.c  |  156 ++++++++--------
 drivers/staging/keucr/smilsub.c   |  396 ++++++++++++++++++------------------
 drivers/staging/keucr/smscsi.c    |   32 ++--
 drivers/staging/keucr/transport.c |    4 +-
 drivers/staging/keucr/transport.h |   48 +++---
 drivers/staging/keucr/usb.c       |    4 +-
 drivers/staging/keucr/usb.h       |   86 ++++----
 17 files changed, 806 insertions(+), 815 deletions(-)

diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
index 8693c54..5dda691 100644
--- a/drivers/staging/keucr/common.h
+++ b/drivers/staging/keucr/common.h
@@ -1,15 +1,6 @@
 #ifndef COMMON_INCD
 #define COMMON_INCD
 
-typedef void VOID;
-typedef u8 BOOLEAN;
-typedef u8 BYTE;
-typedef u8 *PBYTE;
-typedef u16 WORD;
-typedef u16 *PWORD;
-typedef u32 DWORD;
-typedef u32 *PDWORD;
-
 #define swapWORD(w)	((((unsigned short)(w) << 8) & 0xff00) |	\
 			 (((unsigned short)(w) >> 8) & 0x00ff))
 #define swapDWORD(dw)	((((unsigned long)(dw) << 24) & 0xff000000) |	\
diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 515e448..f4a6537 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -11,8 +11,8 @@
 #include "transport.h"
 #include "init.h"
 
-BYTE IsSSFDCCompliance;
-BYTE IsXDCompliance;
+u8 IsSSFDCCompliance;
+u8 IsXDCompliance;
 
 /*
  * ENE_InitMedia():
@@ -20,7 +20,7 @@ BYTE IsXDCompliance;
 int ENE_InitMedia(struct us_data *us)
 {
 	int	result;
-	BYTE	MiscReg03 = 0;
+	u8	MiscReg03 = 0;
 
 	printk(KERN_INFO "--- Init Media ---\n");
 	result = ENE_Read_BYTE(us, REG_CARD_STATUS, &MiscReg03);
@@ -55,7 +55,7 @@ int ENE_InitMedia(struct us_data *us)
 /*
  * ENE_Read_BYTE() :
  */
-int ENE_Read_BYTE(struct us_data *us, WORD index, void *buf)
+int ENE_Read_BYTE(struct us_data *us, u16 index, void *buf)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result;
@@ -65,8 +65,8 @@ int ENE_Read_BYTE(struct us_data *us, WORD index, void *buf)
 	bcb->DataTransferLength	= 0x01;
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xED;
-	bcb->CDB[2]			= (BYTE)(index>>8);
-	bcb->CDB[3]			= (BYTE)index;
+	bcb->CDB[2]			= (u8)(index>>8);
+	bcb->CDB[3]			= (u8)index;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, buf, 0);
 	return result;
@@ -79,7 +79,7 @@ int ENE_SDInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	BYTE	buf[0x200];
+	u8	buf[0x200];
 
 	printk(KERN_INFO "transport --- ENE_SDInit\n");
 	/* SD Init Part-1 */
@@ -121,7 +121,7 @@ int ENE_SDInit(struct us_data *us)
 
 	us->SD_Status =  *(PSD_STATUS)&buf[0];
 	if (us->SD_Status.Insert && us->SD_Status.Ready) {
-		ENE_ReadSDReg(us, (PBYTE)&buf);
+		ENE_ReadSDReg(us, (u8 *)&buf);
 		printk(KERN_INFO "Insert     = %x\n", us->SD_Status.Insert);
 		printk(KERN_INFO "Ready      = %x\n", us->SD_Status.Ready);
 		printk(KERN_INFO "IsMMC      = %x\n", us->SD_Status.IsMMC);
@@ -142,8 +142,8 @@ int ENE_MSInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	BYTE	buf[0x200];
-	WORD	MSP_BlockSize, MSP_UserAreaBlocks;
+	u8	buf[0x200];
+	u16	MSP_BlockSize, MSP_UserAreaBlocks;
 
 	printk(KERN_INFO "transport --- ENE_MSInit\n");
 	result = ENE_LoadBinCode(us, MS_INIT_PATTERN);
@@ -196,7 +196,7 @@ int ENE_SMInit(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	BYTE	buf[0x200];
+	u8	buf[0x200];
 
 	printk(KERN_INFO "transport --- ENE_SMInit\n");
 
@@ -246,22 +246,22 @@ int ENE_SMInit(struct us_data *us)
  */
 int ENE_ReadSDReg(struct us_data *us, u8 *RdBuf)
 {
-	WORD	tmpreg;
-	DWORD	reg4b;
+	u16	tmpreg;
+	u32	reg4b;
 
 	/* printk(KERN_INFO "transport --- ENE_ReadSDReg\n"); */
-	reg4b = *(PDWORD)&RdBuf[0x18];
-	us->SD_READ_BL_LEN = (BYTE)((reg4b >> 8) & 0x0f);
+	reg4b = *(u32 *)&RdBuf[0x18];
+	us->SD_READ_BL_LEN = (u8)((reg4b >> 8) & 0x0f);
 
-	tmpreg = (WORD) reg4b;
-	reg4b = *(PDWORD)(&RdBuf[0x14]);
+	tmpreg = (u16) reg4b;
+	reg4b = *(u32 *)(&RdBuf[0x14]);
 	if (us->SD_Status.HiCapacity && !us->SD_Status.IsMMC)
 		us->HC_C_SIZE = (reg4b >> 8) & 0x3fffff;
 
-	us->SD_C_SIZE = ((tmpreg & 0x03) << 10) | (WORD)(reg4b >> 22);
-	us->SD_C_SIZE_MULT = (BYTE)(reg4b >> 7)  & 0x07;
+	us->SD_C_SIZE = ((tmpreg & 0x03) << 10) | (u16)(reg4b >> 22);
+	us->SD_C_SIZE_MULT = (u8)(reg4b >> 7)  & 0x07;
 	if (us->SD_Status.HiCapacity && us->SD_Status.IsMMC)
-		us->HC_C_SIZE = *(PDWORD)(&RdBuf[0x100]);
+		us->HC_C_SIZE = *(u32 *)(&RdBuf[0x100]);
 
 	if (us->SD_READ_BL_LEN > SD_BLOCK_LEN) {
 		us->SD_Block_Mult =
@@ -276,12 +276,12 @@ int ENE_ReadSDReg(struct us_data *us, u8 *RdBuf)
 /*
  * ENE_LoadBinCode()
  */
-int ENE_LoadBinCode(struct us_data *us, BYTE flag)
+int ENE_LoadBinCode(struct us_data *us, u8 flag)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result;
 	/* void *buf; */
-	PBYTE buf;
+	u8 * buf;
 
 	/* printk(KERN_INFO "transport --- ENE_LoadBinCode\n"); */
 	if (us->BIN_FLAG == flag)
@@ -344,7 +344,7 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 /*
  * ENE_SendScsiCmd():
  */
-int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
+int ENE_SendScsiCmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
@@ -511,13 +511,13 @@ int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
  */
 void usb_stor_print_cmd(struct scsi_cmnd *srb)
 {
-	PBYTE	Cdb = srb->cmnd;
-	DWORD	cmd = Cdb[0];
-	DWORD	bn  =	((Cdb[2] << 24) & 0xff000000) |
+	u8 *	Cdb = srb->cmnd;
+	u32	cmd = Cdb[0];
+	u32	bn  =	((Cdb[2] << 24) & 0xff000000) |
 			((Cdb[3] << 16) & 0x00ff0000) |
 			((Cdb[4] << 8) & 0x0000ff00) |
 			((Cdb[5] << 0) & 0x000000ff);
-	WORD	blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
+	u16	blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
diff --git a/drivers/staging/keucr/init.h b/drivers/staging/keucr/init.h
index 5223132..c758b11 100644
--- a/drivers/staging/keucr/init.h
+++ b/drivers/staging/keucr/init.h
@@ -1,9 +1,9 @@
 #include "common.h"
 
-extern DWORD MediaChange;
+extern u32 MediaChange;
 extern int Check_D_MediaFmt(struct us_data *);
 
-BYTE SD_Init1[] = {
+u8 SD_Init1[] = {
 0x90, 0xFF, 0x09, 0xE0, 0x30, 0xE1, 0x06, 0x90,
 0xFF, 0x23, 0x74, 0x80, 0xF0, 0x90, 0xFF, 0x09,
 0xE0, 0x30, 0xE5, 0xFC, 0x90, 0xFF, 0x83, 0xE0,
@@ -261,7 +261,7 @@ BYTE SD_Init1[] = {
 0x53, 0x44, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x31,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-BYTE SD_Init2[] = {
+u8 SD_Init2[] = {
 0x90, 0xFF, 0x09, 0xE0, 0x30, 0xE1, 0x06, 0x90,
 0xFF, 0x23, 0x74, 0x80, 0xF0, 0x90, 0xFF, 0x09,
 0xE0, 0x30, 0xE5, 0xFC, 0x90, 0xFF, 0x83, 0xE0,
@@ -519,7 +519,7 @@ BYTE SD_Init2[] = {
 0x53, 0x44, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x32,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-BYTE SD_Rdwr[] = {
+u8 SD_Rdwr[] = {
 0x90, 0xF0, 0x11, 0xE0, 0x90, 0xEB, 0x2A, 0xF0,
 0x90, 0xF0, 0x12, 0xE0, 0x90, 0xEB, 0x2B, 0xF0,
 0x90, 0xF0, 0x13, 0xE0, 0x90, 0xEB, 0x2C, 0xF0,
@@ -777,7 +777,7 @@ BYTE SD_Rdwr[] = {
 0x53, 0x44, 0x2D, 0x52, 0x57, 0x20, 0x20, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-BYTE MS_Init[] = {
+u8 MS_Init[] = {
 0x90, 0xF0, 0x15, 0xE0, 0xF5, 0x1C, 0x11, 0x2C,
 0x90, 0xFF, 0x09, 0xE0, 0x30, 0xE1, 0x06, 0x90,
 0xFF, 0x23, 0x74, 0x80, 0xF0, 0x90, 0xFF, 0x09,
@@ -1035,7 +1035,7 @@ BYTE MS_Init[] = {
 0x4D, 0x53, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x30 };
 
-BYTE MSP_Rdwr[] = {
+u8 MSP_Rdwr[] = {
 0x90, 0xF0, 0x10, 0xE0, 0x90, 0xEA, 0x46, 0xF0,
 0xB4, 0x04, 0x03, 0x02, 0xE1, 0x1E, 0x90, 0xFF,
 0x09, 0xE0, 0x30, 0xE1, 0x06, 0x90, 0xFF, 0x23,
@@ -1293,7 +1293,7 @@ BYTE MSP_Rdwr[] = {
 0x4D, 0x53, 0x50, 0x2D, 0x52, 0x57, 0x20, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x30 };
 
-BYTE MS_Rdwr[] = {
+u8 MS_Rdwr[] = {
 0x90, 0xF0, 0x10, 0xE0, 0x90, 0xEA, 0x46, 0xF0,
 0xB4, 0x02, 0x02, 0x80, 0x36, 0x90, 0xF0, 0x11,
 0xE0, 0xF5, 0x17, 0x90, 0xF0, 0x12, 0xE0, 0xF5,
@@ -1551,7 +1551,7 @@ BYTE MS_Rdwr[] = {
 0x4D, 0x53, 0x2D, 0x52, 0x57, 0x20, 0x20, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x30 };
 
-BYTE SM_Init[] = {
+u8 SM_Init[] = {
 0x7B, 0x09, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xCC,
 0xE0, 0xB4, 0x07, 0x12, 0x90, 0xFF, 0x09, 0xE0,
@@ -1809,7 +1809,7 @@ BYTE SM_Init[] = {
 0x58, 0x44, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-BYTE SM_Rdwr[] = {
+u8 SM_Rdwr[] = {
 0x7B, 0x0C, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xC3,
 0xE0, 0xB4, 0x73, 0x04, 0x74, 0x40, 0x80, 0x09,
diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index 452ea8f..69c2fdd 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -5,7 +5,7 @@
 #include "ms.h"
 
 //----- MS_ReaderCopyBlock() ------------------------------------------
-int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlockAddr, BYTE PageNum, PBYTE buf, WORD len)
+int MS_ReaderCopyBlock(struct us_data *us, u16 oldphy, u16 newphy, u16 PhyBlockAddr, u8 PageNum, u8 * buf, u16 len)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
@@ -21,14 +21,14 @@ int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlo
 	bcb->Flags			= 0x00;
 	bcb->CDB[0]			= 0xF0;
 	bcb->CDB[1]			= 0x08;
-	bcb->CDB[4]			= (BYTE)(oldphy);
-	bcb->CDB[3]			= (BYTE)(oldphy>>8);
-	bcb->CDB[2]			= (BYTE)(oldphy>>16);
-	bcb->CDB[7]			= (BYTE)(newphy);
-	bcb->CDB[6]			= (BYTE)(newphy>>8);
-	bcb->CDB[5]			= (BYTE)(newphy>>16);
-	bcb->CDB[9]			= (BYTE)(PhyBlockAddr);
-	bcb->CDB[8]			= (BYTE)(PhyBlockAddr>>8);
+	bcb->CDB[4]			= (u8)(oldphy);
+	bcb->CDB[3]			= (u8)(oldphy>>8);
+	bcb->CDB[2]			= (u8)(oldphy>>16);
+	bcb->CDB[7]			= (u8)(newphy);
+	bcb->CDB[6]			= (u8)(newphy>>8);
+	bcb->CDB[5]			= (u8)(newphy>>16);
+	bcb->CDB[9]			= (u8)(PhyBlockAddr);
+	bcb->CDB[8]			= (u8)(PhyBlockAddr>>8);
 	bcb->CDB[10]		= PageNum;
 
 	result = ENE_SendScsiCmd(us, FDIR_WRITE, buf, 0);
@@ -39,12 +39,12 @@ int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlo
 }
 
 //----- MS_ReaderReadPage() ------------------------------------------
-int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWORD PageBuf, MS_LibTypeExtdat *ExtraDat)
+int MS_ReaderReadPage(struct us_data *us, u32 PhyBlockAddr, u8 PageNum, u32 * PageBuf, MS_LibTypeExtdat *ExtraDat)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	BYTE	ExtBuf[4];
-	DWORD	bn = PhyBlockAddr * 0x20 + PageNum;
+	u8	ExtBuf[4];
+	u32	bn = PhyBlockAddr * 0x20 + PageNum;
 
 	//printk("MS --- MS_ReaderReadPage,  PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum);
 
@@ -59,10 +59,10 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x02;
-	bcb->CDB[5]			= (BYTE)(bn);
-	bcb->CDB[4]			= (BYTE)(bn>>8);
-	bcb->CDB[3]			= (BYTE)(bn>>16);
-	bcb->CDB[2]			= (BYTE)(bn>>24);
+	bcb->CDB[5]			= (u8)(bn);
+	bcb->CDB[4]			= (u8)(bn>>8);
+	bcb->CDB[3]			= (u8)(bn>>16);
+	bcb->CDB[2]			= (u8)(bn>>24);
 	
 	result = ENE_SendScsiCmd(us, FDIR_READ, PageBuf, 0);
 	if (result != USB_STOR_XFER_GOOD)
@@ -75,10 +75,10 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[5]			= (BYTE)(PageNum);
-	bcb->CDB[4]			= (BYTE)(PhyBlockAddr);
-	bcb->CDB[3]			= (BYTE)(PhyBlockAddr>>8);
-	bcb->CDB[2]			= (BYTE)(PhyBlockAddr>>16);
+	bcb->CDB[5]			= (u8)(PageNum);
+	bcb->CDB[4]			= (u8)(PhyBlockAddr);
+	bcb->CDB[3]			= (u8)(PhyBlockAddr>>8);
+	bcb->CDB[2]			= (u8)(PhyBlockAddr>>16);
 	bcb->CDB[6]			= 0x01;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &ExtBuf, 0);
@@ -97,11 +97,11 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 }
 
 //----- MS_ReaderEraseBlock() ----------------------------------------
-int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
+int MS_ReaderEraseBlock(struct us_data *us, u32 PhyBlockAddr)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	DWORD	bn = PhyBlockAddr;
+	u32	bn = PhyBlockAddr;
 
 	//printk("MS --- MS_ReaderEraseBlock,  PhyBlockAddr = %x\n", PhyBlockAddr);
 	result = ENE_LoadBinCode(us, MS_RW_PATTERN);
@@ -114,9 +114,9 @@ int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF2;
 	bcb->CDB[1]			= 0x06;
-	bcb->CDB[4]			= (BYTE)(bn);
-	bcb->CDB[3]			= (BYTE)(bn>>8);
-	bcb->CDB[2]			= (BYTE)(bn>>16);
+	bcb->CDB[4]			= (u8)(bn);
+	bcb->CDB[3]			= (u8)(bn>>8);
+	bcb->CDB[2]			= (u8)(bn>>16);
 	
 	result = ENE_SendScsiCmd(us, FDIR_READ, NULL, 0);
 	if (result != USB_STOR_XFER_GOOD)
@@ -128,12 +128,12 @@ int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
 //----- MS_CardInit() ------------------------------------------------
 int MS_CardInit(struct us_data *us)
 {
-	DWORD			result=0;
-	WORD			TmpBlock;
-	PBYTE			PageBuffer0 = NULL, PageBuffer1 = NULL;
+	u32			result=0;
+	u16			TmpBlock;
+	u8 *PageBuffer0 = NULL, *PageBuffer1 = NULL;
 	MS_LibTypeExtdat	extdat;
-	WORD			btBlk1st, btBlk2nd;
-	DWORD			btBlk1stErred;
+	u16			btBlk1st, btBlk2nd;
+	u32			btBlk1stErred;
 
 	printk("MS_CardInit start\n");
 
@@ -151,7 +151,7 @@ int MS_CardInit(struct us_data *us)
 
 	for (TmpBlock=0; TmpBlock < MS_MAX_INITIAL_ERROR_BLOCKS+2; TmpBlock++)
 	{
-		switch (MS_ReaderReadPage(us, TmpBlock, 0, (DWORD *)PageBuffer0, &extdat))
+		switch (MS_ReaderReadPage(us, TmpBlock, 0, (u32 *)PageBuffer0, &extdat))
 		{
 			case MS_STATUS_SUCCESS:
 			break;
@@ -250,11 +250,11 @@ exit:
 }
 
 //----- MS_LibCheckDisableBlock() ------------------------------------
-int MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock)
+int MS_LibCheckDisableBlock(struct us_data *us, u16 PhyBlock)
 {
-	PWORD			PageBuf=NULL;
-	DWORD			result=MS_STATUS_SUCCESS;
-	DWORD			blk, index=0;
+	u16 *			PageBuf=NULL;
+	u32			result=MS_STATUS_SUCCESS;
+	u32			blk, index=0;
 	MS_LibTypeExtdat	extdat;
 
 	if (((PageBuf = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL)) == NULL))
@@ -263,7 +263,7 @@ int MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock)
 		goto exit;
 	}
 
-	MS_ReaderReadPage(us, PhyBlock, 1, (DWORD *)PageBuf, &extdat);
+	MS_ReaderReadPage(us, PhyBlock, 1, (u32 *)PageBuf, &extdat);
 	do
 	{
 		blk = BigEndianWORD(PageBuf[index]);
@@ -303,18 +303,18 @@ void MS_LibFreeAllocatedArea(struct us_data *us)
 //----- MS_LibFreeWriteBuf() -----------------------------------------
 void MS_LibFreeWriteBuf(struct us_data *us)
 {
-	us->MS_Lib.wrtblk = (WORD)-1; //set to -1
+	us->MS_Lib.wrtblk = (u16)-1; //set to -1
 	MS_LibClearPageMap(us); // memset((fdoExt)->MS_Lib.pagemap, 0, sizeof((fdoExt)->MS_Lib.pagemap))
 
 	if (us->MS_Lib.blkpag)
 	{
-		kfree((BYTE *)(us->MS_Lib.blkpag));  // Arnold test ...
+		kfree((u8 *)(us->MS_Lib.blkpag));  // Arnold test ...
 		us->MS_Lib.blkpag = NULL;
 	}
 
 	if (us->MS_Lib.blkext)
 	{
-		kfree((BYTE *)(us->MS_Lib.blkext));  // Arnold test ...
+		kfree((u8 *)(us->MS_Lib.blkext));  // Arnold test ...
 		us->MS_Lib.blkext = NULL;
 	}
 }
@@ -338,19 +338,19 @@ int MS_LibFreeLogicalMap(struct us_data *us)
 }
 
 //----- MS_LibProcessBootBlock() -------------------------------------
-int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
+int MS_LibProcessBootBlock(struct us_data *us, u16 PhyBlock, u8 *PageData)
 {
 	MemStickBootBlockSysEnt  *SysEntry;
 	MemStickBootBlockSysInf  *SysInfo;
-	DWORD                    i, result;
-	BYTE                     PageNumber;
-	BYTE                     *PageBuffer;
+	u32                    i, result;
+	u8                     PageNumber;
+	u8                     *PageBuffer;
 	MS_LibTypeExtdat         ExtraData;
 
 	if ((PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL))==NULL)
-		return (DWORD)-1;
+		return (u32)-1;
 
-	result = (DWORD)-1;
+	result = (u32)-1;
 
 	SysInfo= &(((MemStickBootBlockPage0 *)PageData)->sysinf);
 
@@ -392,7 +392,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 
 	for (i=0; i<MS_NUMBER_OF_SYSTEM_ENTRY; i++)
 	{
-		DWORD  EntryOffset, EntrySize;
+		u32  EntryOffset, EntrySize;
 
 		if ((EntryOffset = BigEndianDWORD(SysEntry->entry[i].dwStart)) == 0xffffff)
 			continue;
@@ -400,22 +400,22 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 		if ((EntrySize = BigEndianDWORD(SysEntry->entry[i].dwSize)) == 0)
 			continue;
 
-		if (EntryOffset + MS_BYTES_PER_PAGE + EntrySize > us->MS_Lib.blockSize * (DWORD)SIZE_OF_KIRO)
+		if (EntryOffset + MS_BYTES_PER_PAGE + EntrySize > us->MS_Lib.blockSize * (u32)SIZE_OF_KIRO)
 			continue;
 
 		if (i == 0)
 		{
-			BYTE  PrevPageNumber = 0;
-			WORD  phyblk;
+			u8  PrevPageNumber = 0;
+			u16  phyblk;
 
 			if (SysEntry->entry[i].bType != MS_SYSENT_TYPE_INVALID_BLOCK)
 				goto exit;
 
 			while (EntrySize > 0)
 			{
-				if ((PageNumber = (BYTE)(EntryOffset / MS_BYTES_PER_PAGE + 1)) != PrevPageNumber)
+				if ((PageNumber = (u8)(EntryOffset / MS_BYTES_PER_PAGE + 1)) != PrevPageNumber)
 				{
-					switch (MS_ReaderReadPage(us, PhyBlock, PageNumber, (DWORD *)PageBuffer, &ExtraData))
+					switch (MS_ReaderReadPage(us, PhyBlock, PageNumber, (u32 *)PageBuffer, &ExtraData))
 					{
 						case MS_STATUS_SUCCESS:
 							break;
@@ -429,7 +429,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 					PrevPageNumber = PageNumber;
 				}
 
-				if ((phyblk = BigEndianWORD(*(WORD *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))) < 0x0fff)
+				if ((phyblk = BigEndianWORD(*(u16 *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))) < 0x0fff)
 					MS_LibSetInitialErrorBlock(us, phyblk);
 
 				EntryOffset += 2;
@@ -443,7 +443,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 			if (SysEntry->entry[i].bType != MS_SYSENT_TYPE_CIS_IDI)
 				goto exit;
 
-			switch (MS_ReaderReadPage(us, PhyBlock, (BYTE)(EntryOffset / MS_BYTES_PER_PAGE + 1), (DWORD *)PageBuffer, &ExtraData))
+			switch (MS_ReaderReadPage(us, PhyBlock, (u8)(EntryOffset / MS_BYTES_PER_PAGE + 1), (u32 *)PageBuffer, &ExtraData))
 			{
 				case MS_STATUS_SUCCESS:
 					break;
@@ -477,16 +477,16 @@ exit:
 //----- MS_LibAllocLogicalMap() --------------------------------------
 int MS_LibAllocLogicalMap(struct us_data *us)
 {
-	DWORD  i;
+	u32  i;
 
 
-	us->MS_Lib.Phy2LogMap = kmalloc(us->MS_Lib.NumberOfPhyBlock * sizeof(WORD), GFP_KERNEL);
-	us->MS_Lib.Log2PhyMap = kmalloc(us->MS_Lib.NumberOfLogBlock * sizeof(WORD), GFP_KERNEL);
+	us->MS_Lib.Phy2LogMap = kmalloc(us->MS_Lib.NumberOfPhyBlock * sizeof(u16), GFP_KERNEL);
+	us->MS_Lib.Log2PhyMap = kmalloc(us->MS_Lib.NumberOfLogBlock * sizeof(u16), GFP_KERNEL);
 
 	if ((us->MS_Lib.Phy2LogMap == NULL) || (us->MS_Lib.Log2PhyMap == NULL))
 	{
 		MS_LibFreeLogicalMap(us);
-		return (DWORD)-1;
+		return (u32)-1;
 	}
 
 	for (i = 0; i < us->MS_Lib.NumberOfPhyBlock; i++)
@@ -499,16 +499,16 @@ int MS_LibAllocLogicalMap(struct us_data *us)
 }
 
 //----- MS_LibSetBootBlockMark() -------------------------------------
-int MS_LibSetBootBlockMark(struct us_data *us, WORD phyblk)
+int MS_LibSetBootBlockMark(struct us_data *us, u16 phyblk)
 {
     return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_BOOT_BLOCK);
 }
 
 //----- MS_LibSetLogicalBlockMark() ----------------------------------
-int MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk, WORD mark)
+int MS_LibSetLogicalBlockMark(struct us_data *us, u16 phyblk, u16 mark)
 {
     if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
-        return (DWORD)-1;
+        return (u32)-1;
 
     us->MS_Lib.Phy2LogMap[phyblk] = mark;
 
@@ -516,19 +516,19 @@ int MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk, WORD mark)
 }
 
 //----- MS_LibSetInitialErrorBlock() ---------------------------------
-int MS_LibSetInitialErrorBlock(struct us_data *us, WORD phyblk)
+int MS_LibSetInitialErrorBlock(struct us_data *us, u16 phyblk)
 {
     return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_INITIAL_ERROR);
 }
 
 //----- MS_LibScanLogicalBlockNumber() -------------------------------
-int MS_LibScanLogicalBlockNumber(struct us_data *us, WORD btBlk1st)
+int MS_LibScanLogicalBlockNumber(struct us_data *us, u16 btBlk1st)
 {
-	WORD			PhyBlock, newblk, i;
-	WORD			LogStart, LogEnde;
+	u16			PhyBlock, newblk, i;
+	u16			LogStart, LogEnde;
 	MS_LibTypeExtdat	extdat;
-	BYTE			buf[0x200];
-	DWORD			count=0, index=0;
+	u8			buf[0x200];
+	u32			count=0, index=0;
 
 	for (PhyBlock = 0; PhyBlock < us->MS_Lib.NumberOfPhyBlock;)
 	{
@@ -608,7 +608,7 @@ int MS_LibScanLogicalBlockNumber(struct us_data *us, WORD btBlk1st)
 //----- MS_LibAllocWriteBuf() ----------------------------------------
 int MS_LibAllocWriteBuf(struct us_data *us)
 {
-	us->MS_Lib.wrtblk = (WORD)-1;
+	us->MS_Lib.wrtblk = (u16)-1;
 
 	us->MS_Lib.blkpag = kmalloc(us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector, GFP_KERNEL);
 	us->MS_Lib.blkext = kmalloc(us->MS_Lib.PagesPerBlock * sizeof(MS_LibTypeExtdat), GFP_KERNEL);
@@ -616,7 +616,7 @@ int MS_LibAllocWriteBuf(struct us_data *us)
 	if ((us->MS_Lib.blkpag == NULL) || (us->MS_Lib.blkext == NULL))
 	{
 		MS_LibFreeWriteBuf(us);
-		return (DWORD)-1;
+		return (u32)-1;
 	}
 
 	MS_LibClearWriteBuf(us);
@@ -629,7 +629,7 @@ void MS_LibClearWriteBuf(struct us_data *us)
 {
 	int i;
 
-	us->MS_Lib.wrtblk = (WORD)-1;
+	us->MS_Lib.wrtblk = (u16)-1;
 	MS_LibClearPageMap(us);
 
 	if (us->MS_Lib.blkpag)
@@ -648,7 +648,7 @@ void MS_LibClearWriteBuf(struct us_data *us)
 }
 
 //----- MS_LibPhy2LogRange() -----------------------------------------
-void MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart, WORD *LogEnde)
+void MS_LibPhy2LogRange(u16 PhyBlock, u16 *LogStart, u16 *LogEnde)
 {
 	PhyBlock /= MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 
@@ -665,7 +665,7 @@ void MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart, WORD *LogEnde)
 }
 
 //----- MS_LibReadExtraBlock() --------------------------------------------
-int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE blen, void *buf)
+int MS_LibReadExtraBlock(struct us_data *us, u32 PhyBlock, u8 PageNum, u8 blen, void *buf)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
@@ -679,10 +679,10 @@ int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[5]			= (BYTE)(PageNum);
-	bcb->CDB[4]			= (BYTE)(PhyBlock);
-	bcb->CDB[3]			= (BYTE)(PhyBlock>>8);
-	bcb->CDB[2]			= (BYTE)(PhyBlock>>16);
+	bcb->CDB[5]			= (u8)(PageNum);
+	bcb->CDB[4]			= (u8)(PhyBlock);
+	bcb->CDB[3]			= (u8)(PhyBlock>>8);
+	bcb->CDB[2]			= (u8)(PhyBlock>>16);
 	bcb->CDB[6]			= blen;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, buf, 0);
@@ -693,11 +693,11 @@ int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE
 }
 
 //----- MS_LibReadExtra() --------------------------------------------
-int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibTypeExtdat *ExtraDat)
+int MS_LibReadExtra(struct us_data *us, u32 PhyBlock, u8 PageNum, MS_LibTypeExtdat *ExtraDat)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	BYTE	ExtBuf[4];
+	u8	ExtBuf[4];
 
 	//printk("MS_LibReadExtra --- PhyBlock = %x, PageNum = %x\n", PhyBlock, PageNum);
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
@@ -706,10 +706,10 @@ int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibType
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[5]			= (BYTE)(PageNum);
-	bcb->CDB[4]			= (BYTE)(PhyBlock);
-	bcb->CDB[3]			= (BYTE)(PhyBlock>>8);
-	bcb->CDB[2]			= (BYTE)(PhyBlock>>16);
+	bcb->CDB[5]			= (u8)(PageNum);
+	bcb->CDB[4]			= (u8)(PhyBlock);
+	bcb->CDB[3]			= (u8)(PhyBlock>>8);
+	bcb->CDB[2]			= (u8)(PhyBlock>>16);
 	bcb->CDB[6]			= 0x01;
 	
 	result = ENE_SendScsiCmd(us, FDIR_READ, &ExtBuf, 0);
@@ -728,12 +728,12 @@ int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibType
 }
 
 //----- MS_LibSetAcquiredErrorBlock() --------------------------------
-int MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk)
+int MS_LibSetAcquiredErrorBlock(struct us_data *us, u16 phyblk)
 {
-	WORD log;
+	u16 log;
 
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
-		return (DWORD)-1;
+		return (u32)-1;
 
 	if ((log = us->MS_Lib.Phy2LogMap[phyblk]) < us->MS_Lib.NumberOfLogBlock)
 		us->MS_Lib.Log2PhyMap[log] = MS_LB_NOT_USED;
@@ -745,9 +745,9 @@ int MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk)
 }
 
 //----- MS_LibErasePhyBlock() ----------------------------------------
-int MS_LibErasePhyBlock(struct us_data *us, WORD phyblk)
+int MS_LibErasePhyBlock(struct us_data *us, u16 phyblk)
 {
-	WORD  log;
+	u16  log;
 
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
 		return MS_STATUS_ERROR;
@@ -782,7 +782,7 @@ int MS_LibErasePhyBlock(struct us_data *us, WORD phyblk)
 }
 
 //----- MS_LibErrorPhyBlock() ----------------------------------------
-int MS_LibErrorPhyBlock(struct us_data *us, WORD phyblk)
+int MS_LibErrorPhyBlock(struct us_data *us, u16 phyblk)
 {
     if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
         return MS_STATUS_ERROR;
@@ -790,14 +790,14 @@ int MS_LibErrorPhyBlock(struct us_data *us, WORD phyblk)
     MS_LibSetAcquiredErrorBlock(us, phyblk);
 
     if (MS_LibIsWritable(us))
-        return MS_LibOverwriteExtra(us, phyblk, 0, (BYTE)(~MS_REG_OVR_BKST));
+        return MS_LibOverwriteExtra(us, phyblk, 0, (u8)(~MS_REG_OVR_BKST));
 
 
     return MS_STATUS_SUCCESS;
 }
 
 //----- MS_LibOverwriteExtra() ---------------------------------------
-int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, BYTE OverwriteFlag)
+int MS_LibOverwriteExtra(struct us_data *us, u32 PhyBlockAddr, u8 PageNum, u8 OverwriteFlag)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
@@ -813,10 +813,10 @@ int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, B
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF2;
 	bcb->CDB[1]			= 0x05;
-	bcb->CDB[5]			= (BYTE)(PageNum);
-	bcb->CDB[4]			= (BYTE)(PhyBlockAddr);
-	bcb->CDB[3]			= (BYTE)(PhyBlockAddr>>8);
-	bcb->CDB[2]			= (BYTE)(PhyBlockAddr>>16);
+	bcb->CDB[5]			= (u8)(PageNum);
+	bcb->CDB[4]			= (u8)(PhyBlockAddr);
+	bcb->CDB[3]			= (u8)(PhyBlockAddr>>8);
+	bcb->CDB[2]			= (u8)(PhyBlockAddr>>16);
 	bcb->CDB[6]			= OverwriteFlag;
 	bcb->CDB[7]			= 0xFF;
 	bcb->CDB[8]			= 0xFF;
@@ -830,13 +830,13 @@ int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, B
 }
 
 //----- MS_LibForceSetLogicalPair() ----------------------------------
-int MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
+int MS_LibForceSetLogicalPair(struct us_data *us, u16 logblk, u16 phyblk)
 {
 	if (logblk == MS_LB_NOT_USED)
 		return 0;
 
 	if ((logblk >= us->MS_Lib.NumberOfLogBlock) || (phyblk >= us->MS_Lib.NumberOfPhyBlock))
-		return (DWORD)-1;
+		return (u32)-1;
 
 	us->MS_Lib.Phy2LogMap[phyblk] = logblk;
 	us->MS_Lib.Log2PhyMap[logblk] = phyblk;
@@ -845,10 +845,10 @@ int MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 }
 
 //----- MS_LibSetLogicalPair() ---------------------------------------
-int MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
+int MS_LibSetLogicalPair(struct us_data *us, u16 logblk, u16 phyblk)
 {
 	if ((logblk >= us->MS_Lib.NumberOfLogBlock) || (phyblk >= us->MS_Lib.NumberOfPhyBlock))
-		return (DWORD)-1;
+		return (u32)-1;
 
 	us->MS_Lib.Phy2LogMap[phyblk] = logblk;
 	us->MS_Lib.Log2PhyMap[logblk] = phyblk;
@@ -857,9 +857,9 @@ int MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 }
 
 //----- MS_CountFreeBlock() ------------------------------------------
-int MS_CountFreeBlock(struct us_data *us, WORD PhyBlock)
+int MS_CountFreeBlock(struct us_data *us, u16 PhyBlock)
 {
-	DWORD Ende, Count;
+	u32 Ende, Count;
 
 	Ende = PhyBlock + MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 	for (Count = 0; PhyBlock < Ende; PhyBlock++)
@@ -878,10 +878,10 @@ int MS_CountFreeBlock(struct us_data *us, WORD PhyBlock)
 }
 
 //----- MS_LibSearchBlockFromPhysical() ------------------------------
-int MS_LibSearchBlockFromPhysical(struct us_data *us, WORD phyblk)
+int MS_LibSearchBlockFromPhysical(struct us_data *us, u16 phyblk)
 {
-	WORD			Newblk;
-	WORD			blk;
+	u16			Newblk;
+	u16			blk;
 	MS_LibTypeExtdat	extdat;
 
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
@@ -936,9 +936,9 @@ int MS_LibSearchBlockFromPhysical(struct us_data *us, WORD phyblk)
 }
 
 //----- MS_LibSearchBlockFromLogical() -------------------------------
-int MS_LibSearchBlockFromLogical(struct us_data *us, WORD logblk)
+int MS_LibSearchBlockFromLogical(struct us_data *us, u16 logblk)
 {
-	WORD phyblk;
+	u16 phyblk;
 
 	if ((phyblk=MS_LibConv2Physical(us, logblk)) >= MS_LB_ERROR)
 	{
diff --git a/drivers/staging/keucr/ms.h b/drivers/staging/keucr/ms.h
index 4509db7..63b3098 100644
--- a/drivers/staging/keucr/ms.h
+++ b/drivers/staging/keucr/ms.h
@@ -132,7 +132,7 @@
 #define MS_LibClearPageMap(pdx)                 memset((pdx)->MS_Lib.pagemap, 0, sizeof((pdx)->MS_Lib.pagemap))
 
 
-#define MemStickLogAddr(logadr1, logadr0)       ((((WORD)(logadr1)) << 8) | (logadr0))
+#define MemStickLogAddr(logadr1, logadr0)       ((((u16)(logadr1)) << 8) | (logadr0))
 
 #define MS_BYTES_PER_PAGE                       512
 
@@ -183,30 +183,30 @@
 //----- MemStickRegisters --------------------------------------------
 // Status registers (16 bytes)
 typedef struct {
-	BYTE Reserved0;		// 00
-	BYTE INTRegister;	// 01
-	BYTE StatusRegister0;	// 02
-	BYTE StatusRegister1;	// 03
-	BYTE Reserved1[12];	// 04-0F
+	u8 Reserved0;		// 00
+	u8 INTRegister;	// 01
+	u8 StatusRegister0;	// 02
+	u8 StatusRegister1;	// 03
+	u8 Reserved1[12];	// 04-0F
 } MemStickStatusRegisters;
 
 // Parameter registers (6 bytes)
 typedef struct {
-	BYTE SystemParameter;	// 10
-	BYTE BlockAddress2;	// 11
-	BYTE BlockAddress1;	// 12
-	BYTE BlockAddress0;	// 13
-	BYTE CMDParameter;	// 14
-	BYTE PageAddress;	// 15
+	u8 SystemParameter;	// 10
+	u8 BlockAddress2;	// 11
+	u8 BlockAddress1;	// 12
+	u8 BlockAddress0;	// 13
+	u8 CMDParameter;	// 14
+	u8 PageAddress;	// 15
 } MemStickParameterRegisters;
 
 // Extra registers (9 bytes)
 typedef struct {
-	BYTE OverwriteFlag;	// 16
-	BYTE ManagementFlag;	// 17
-	BYTE LogicalAddress1;	// 18
-	BYTE LogicalAddress0;	// 19
-	BYTE ReservedArea[5];	// 1A-1E
+	u8 OverwriteFlag;	// 16
+	u8 ManagementFlag;	// 17
+	u8 LogicalAddress1;	// 18
+	u8 LogicalAddress0;	// 19
+	u8 ReservedArea[5];	// 1A-1E
 } MemStickExtraDataRegisters;
 
 // All registers in Memory Stick (32 bytes, includes 1 byte padding)
@@ -214,23 +214,23 @@ typedef struct {
 	MemStickStatusRegisters status;
 	MemStickParameterRegisters param;
 	MemStickExtraDataRegisters extra;
-	BYTE padding;
+	u8 padding;
 } MemStickRegisters, *PMemStickRegisters;
 
 //----- MemStickBootBlockPage0 ---------------------------------------
 typedef struct {
-	WORD wBlockID;
-	WORD wFormatVersion;
-	BYTE bReserved1[184];
-	BYTE bNumberOfDataEntry;
-	BYTE bReserved2[179];
+	u16 wBlockID;
+	u16 wFormatVersion;
+	u8 bReserved1[184];
+	u8 bNumberOfDataEntry;
+	u8 bReserved2[179];
 } MemStickBootBlockHeader;
 
 typedef struct {
-	DWORD dwStart;
-	DWORD dwSize;
-	BYTE bType;
-	BYTE bReserved[3];
+	u32 dwStart;
+	u32 dwSize;
+	u8 bType;
+	u8 bReserved[3];
 } MemStickBootBlockSysEntRec;
 
 typedef struct {
@@ -238,37 +238,37 @@ typedef struct {
 } MemStickBootBlockSysEnt;
 
 typedef struct {
-	BYTE bMsClass;		// must be 1
-	BYTE bCardType;		// see below
-	WORD wBlockSize;	// n KB
-	WORD wBlockNumber;	// number of physical block
-	WORD wTotalBlockNumber;	// number of logical block
-	WORD wPageSize;		// must be 0x200
-	BYTE bExtraSize;	// 0x10
-	BYTE bSecuritySupport;
-	BYTE bAssemblyDate[8];
-	BYTE bFactoryArea[4];
-	BYTE bAssemblyMakerCode;
-	BYTE bAssemblyMachineCode[3];
-	WORD wMemoryMakerCode;
-	WORD wMemoryDeviceCode;
-	WORD wMemorySize;
-	BYTE bReserved1;
-	BYTE bReserved2;
-	BYTE bVCC;
-	BYTE bVPP;
-	WORD wControllerChipNumber;
-	WORD wControllerFunction;	// New MS
-	BYTE bReserved3[9];		// New MS
-	BYTE bParallelSupport;		// New MS
-	WORD wFormatValue;		// New MS
-	BYTE bFormatType;
-	BYTE bUsage;
-	BYTE bDeviceType;
-	BYTE bReserved4[22];
-	BYTE bFUValue3;
-	BYTE bFUValue4;
-	BYTE bReserved5[15];
+	u8 bMsClass;		// must be 1
+	u8 bCardType;		// see below
+	u16 wBlockSize;	// n KB
+	u16 wBlockNumber;	// number of physical block
+	u16 wTotalBlockNumber;	// number of logical block
+	u16 wPageSize;		// must be 0x200
+	u8 bExtraSize;	// 0x10
+	u8 bSecuritySupport;
+	u8 bAssemblyDate[8];
+	u8 bFactoryArea[4];
+	u8 bAssemblyMakerCode;
+	u8 bAssemblyMachineCode[3];
+	u16 wMemoryMakerCode;
+	u16 wMemoryDeviceCode;
+	u16 wMemorySize;
+	u8 bReserved1;
+	u8 bReserved2;
+	u8 bVCC;
+	u8 bVPP;
+	u16 wControllerChipNumber;
+	u16 wControllerFunction;	// New MS
+	u8 bReserved3[9];		// New MS
+	u8 bParallelSupport;		// New MS
+	u16 wFormatValue;		// New MS
+	u8 bFormatType;
+	u8 bUsage;
+	u8 bDeviceType;
+	u8 bReserved4[22];
+	u8 bFUValue3;
+	u8 bFUValue4;
+	u8 bReserved5[15];
 } MemStickBootBlockSysInf;
 
 typedef struct {
@@ -279,103 +279,103 @@ typedef struct {
 
 //----- MemStickBootBlockCIS_IDI -------------------------------------
 typedef struct {
-	BYTE bCistplDEVICE[6];            // 0
-	BYTE bCistplDEVICE0C[6];          // 6
-	BYTE bCistplJEDECC[4];            // 12
-	BYTE bCistplMANFID[6];            // 16
-	BYTE bCistplVER1[32];             // 22
-	BYTE bCistplFUNCID[4];            // 54
-	BYTE bCistplFUNCE0[4];            // 58
-	BYTE bCistplFUNCE1[5];            // 62
-	BYTE bCistplCONF[7];              // 67
-	BYTE bCistplCFTBLENT0[10];        // 74
-	BYTE bCistplCFTBLENT1[8];         // 84
-	BYTE bCistplCFTBLENT2[12];        // 92
-	BYTE bCistplCFTBLENT3[8];         // 104
-	BYTE bCistplCFTBLENT4[17];        // 112
-	BYTE bCistplCFTBLENT5[8];         // 129
-	BYTE bCistplCFTBLENT6[17];        // 137
-	BYTE bCistplCFTBLENT7[8];         // 154
-	BYTE bCistplNOLINK[3];            // 162
+	u8 bCistplDEVICE[6];            // 0
+	u8 bCistplDEVICE0C[6];          // 6
+	u8 bCistplJEDECC[4];            // 12
+	u8 bCistplMANFID[6];            // 16
+	u8 bCistplVER1[32];             // 22
+	u8 bCistplFUNCID[4];            // 54
+	u8 bCistplFUNCE0[4];            // 58
+	u8 bCistplFUNCE1[5];            // 62
+	u8 bCistplCONF[7];              // 67
+	u8 bCistplCFTBLENT0[10];        // 74
+	u8 bCistplCFTBLENT1[8];         // 84
+	u8 bCistplCFTBLENT2[12];        // 92
+	u8 bCistplCFTBLENT3[8];         // 104
+	u8 bCistplCFTBLENT4[17];        // 112
+	u8 bCistplCFTBLENT5[8];         // 129
+	u8 bCistplCFTBLENT6[17];        // 137
+	u8 bCistplCFTBLENT7[8];         // 154
+	u8 bCistplNOLINK[3];            // 162
 } MemStickBootBlockCIS;
 
 typedef struct {
 #define MS_IDI_GENERAL_CONF         0x848A
-	WORD wIDIgeneralConfiguration;     // 0
-	WORD wIDInumberOfCylinder;         // 1
-	WORD wIDIreserved0;                // 2
-	WORD wIDInumberOfHead;             // 3
-	WORD wIDIbytesPerTrack;            // 4
-	WORD wIDIbytesPerSector;           // 5
-	WORD wIDIsectorsPerTrack;          // 6
-	WORD wIDItotalSectors[2];          // 7-8  high,low
-	WORD wIDIreserved1[11];            // 9-19
-	WORD wIDIbufferType;               // 20
-	WORD wIDIbufferSize;               // 21
-	WORD wIDIlongCmdECC;               // 22
-	WORD wIDIfirmVersion[4];           // 23-26
-	WORD wIDImodelName[20];            // 27-46
-	WORD wIDIreserved2;                // 47
-	WORD wIDIlongWordSupported;        // 48
-	WORD wIDIdmaSupported;             // 49
-	WORD wIDIreserved3;                // 50
-	WORD wIDIpioTiming;                // 51
-	WORD wIDIdmaTiming;                // 52
-	WORD wIDItransferParameter;        // 53
-	WORD wIDIformattedCylinder;        // 54
-	WORD wIDIformattedHead;            // 55
-	WORD wIDIformattedSectorsPerTrack; // 56
-	WORD wIDIformattedTotalSectors[2]; // 57-58
-	WORD wIDImultiSector;              // 59
-	WORD wIDIlbaSectors[2];            // 60-61
-	WORD wIDIsingleWordDMA;            // 62
-	WORD wIDImultiWordDMA;             // 63
-	WORD wIDIreserved4[192];           // 64-255
+	u16 wIDIgeneralConfiguration;     // 0
+	u16 wIDInumberOfCylinder;         // 1
+	u16 wIDIreserved0;                // 2
+	u16 wIDInumberOfHead;             // 3
+	u16 wIDIbytesPerTrack;            // 4
+	u16 wIDIbytesPerSector;           // 5
+	u16 wIDIsectorsPerTrack;          // 6
+	u16 wIDItotalSectors[2];          // 7-8  high,low
+	u16 wIDIreserved1[11];            // 9-19
+	u16 wIDIbufferType;               // 20
+	u16 wIDIbufferSize;               // 21
+	u16 wIDIlongCmdECC;               // 22
+	u16 wIDIfirmVersion[4];           // 23-26
+	u16 wIDImodelName[20];            // 27-46
+	u16 wIDIreserved2;                // 47
+	u16 wIDIlongWordSupported;        // 48
+	u16 wIDIdmaSupported;             // 49
+	u16 wIDIreserved3;                // 50
+	u16 wIDIpioTiming;                // 51
+	u16 wIDIdmaTiming;                // 52
+	u16 wIDItransferParameter;        // 53
+	u16 wIDIformattedCylinder;        // 54
+	u16 wIDIformattedHead;            // 55
+	u16 wIDIformattedSectorsPerTrack; // 56
+	u16 wIDIformattedTotalSectors[2]; // 57-58
+	u16 wIDImultiSector;              // 59
+	u16 wIDIlbaSectors[2];            // 60-61
+	u16 wIDIsingleWordDMA;            // 62
+	u16 wIDImultiWordDMA;             // 63
+	u16 wIDIreserved4[192];           // 64-255
 } MemStickBootBlockIDI;
 
 typedef struct {
 	union {
 		MemStickBootBlockCIS cis;
-		BYTE dmy[256];
+		u8 dmy[256];
 	} cis;
 
 	union {
 	MemStickBootBlockIDI idi;
-	BYTE dmy[256];
+	u8 dmy[256];
 	} idi;
 
 } MemStickBootBlockCIS_IDI;
 
 //----- MS_LibControl ------------------------------------------------
 typedef struct {
-	BYTE reserved;
-	BYTE intr;
-	BYTE status0;
-	BYTE status1;
-	BYTE ovrflg;
-	BYTE mngflg;
-	WORD logadr;
+	u8 reserved;
+	u8 intr;
+	u8 status0;
+	u8 status1;
+	u8 ovrflg;
+	u8 mngflg;
+	u16 logadr;
 } MS_LibTypeExtdat;
 
 typedef struct {
-	DWORD flags;
-	DWORD BytesPerSector;
-	DWORD NumberOfCylinder;
-	DWORD SectorsPerCylinder;
-	WORD cardType;			// R/W, RO, Hybrid
-	WORD blockSize;
-	WORD PagesPerBlock;
-	WORD NumberOfPhyBlock;
-	WORD NumberOfLogBlock;
-	WORD NumberOfSegment;
-	WORD *Phy2LogMap;		// phy2log table
-	WORD *Log2PhyMap;		// log2phy table
-	WORD wrtblk;
-	BYTE pagemap[(MS_MAX_PAGES_PER_BLOCK + (MS_LIB_BITS_PER_BYTE-1)) /
+	u32 flags;
+	u32 BytesPerSector;
+	u32 NumberOfCylinder;
+	u32 SectorsPerCylinder;
+	u16 cardType;			// R/W, RO, Hybrid
+	u16 blockSize;
+	u16 PagesPerBlock;
+	u16 NumberOfPhyBlock;
+	u16 NumberOfLogBlock;
+	u16 NumberOfSegment;
+	u16 *Phy2LogMap;		// phy2log table
+	u16 *Log2PhyMap;		// log2phy table
+	u16 wrtblk;
+	u8 pagemap[(MS_MAX_PAGES_PER_BLOCK + (MS_LIB_BITS_PER_BYTE-1)) /
 		     MS_LIB_BITS_PER_BYTE];
-	BYTE *blkpag;
+	u8 *blkpag;
 	MS_LibTypeExtdat *blkext;
-	BYTE copybuf[512];
+	u8 copybuf[512];
 } MS_LibControl;
 
 #endif
diff --git a/drivers/staging/keucr/msscsi.c b/drivers/staging/keucr/msscsi.c
index cb92d25..6e4bd81 100644
--- a/drivers/staging/keucr/msscsi.c
+++ b/drivers/staging/keucr/msscsi.c
@@ -60,7 +60,7 @@ int MS_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 int MS_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
 	//printk("MS_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+	u8 data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
@@ -70,8 +70,8 @@ int MS_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 //----- MS_SCSI_Mode_Sense() --------------------------------------------------
 int MS_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
 
 	if (us->MS_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
@@ -87,9 +87,9 @@ int MS_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
-	DWORD   bl_num;
-	WORD    bl_len;
-	BYTE    buf[8];
+	u32   bl_num;
+	u16    bl_len;
+	u8    buf[8];
 
 	printk("MS_SCSI_Read_Capacity\n");
 
@@ -124,11 +124,11 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32	blenByte = blen * 0x200;
 
 	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
 	
@@ -151,10 +151,10 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		bcb->Flags  = 0x80;
 		bcb->CDB[0] = 0xF1;
 		bcb->CDB[1] = 0x02;
-		bcb->CDB[5] = (BYTE)(bn);
-		bcb->CDB[4] = (BYTE)(bn>>8);
-		bcb->CDB[3] = (BYTE)(bn>>16);
-		bcb->CDB[2] = (BYTE)(bn>>24);
+		bcb->CDB[5] = (u8)(bn);
+		bcb->CDB[4] = (u8)(bn>>8);
+		bcb->CDB[3] = (u8)(bn>>16);
+		bcb->CDB[2] = (u8)(bn>>24);
 
 		result = ENE_SendScsiCmd(us, FDIR_READ, scsi_sglist(srb), 1);
 	}
@@ -162,10 +162,10 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	{
 		void	*buf;
 		int	offset=0;
-		WORD	phyblk, logblk;
-		BYTE	PageNum;
-		WORD	len;
-		DWORD	blkno;
+		u16	phyblk, logblk;
+		u8	PageNum;
+		u16	len;
+		u32	blkno;
 
 		buf = kmalloc(blenByte, GFP_KERNEL);
 		if (buf == NULL)
@@ -179,8 +179,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			goto exit;
 		}
 
-		logblk  = (WORD)(bn / us->MS_Lib.PagesPerBlock);
-		PageNum = (BYTE)(bn % us->MS_Lib.PagesPerBlock);
+		logblk  = (u16)(bn / us->MS_Lib.PagesPerBlock);
+		PageNum = (u8)(bn % us->MS_Lib.PagesPerBlock);
 
 		while(1)
 		{
@@ -199,10 +199,10 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 			bcb->Flags  = 0x80;
 			bcb->CDB[0] = 0xF1;
 			bcb->CDB[1] = 0x02;
-			bcb->CDB[5] = (BYTE)(blkno);
-			bcb->CDB[4] = (BYTE)(blkno>>8);
-			bcb->CDB[3] = (BYTE)(blkno>>16);
-			bcb->CDB[2] = (BYTE)(blkno>>24);
+			bcb->CDB[5] = (u8)(blkno);
+			bcb->CDB[4] = (u8)(blkno>>8);
+			bcb->CDB[3] = (u8)(blkno>>16);
+			bcb->CDB[2] = (u8)(blkno>>24);
 
 			result = ENE_SendScsiCmd(us, FDIR_READ, buf+offset, 0);
 			if (result != USB_STOR_XFER_GOOD)
@@ -231,11 +231,11 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32	blenByte = blen * 0x200;
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -256,10 +256,10 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		bcb->Flags  = 0x00;
 		bcb->CDB[0] = 0xF0;
 		bcb->CDB[1] = 0x04;
-		bcb->CDB[5] = (BYTE)(bn);
-		bcb->CDB[4] = (BYTE)(bn>>8);
-		bcb->CDB[3] = (BYTE)(bn>>16);
-		bcb->CDB[2] = (BYTE)(bn>>24);
+		bcb->CDB[5] = (u8)(bn);
+		bcb->CDB[4] = (u8)(bn>>8);
+		bcb->CDB[3] = (u8)(bn>>16);
+		bcb->CDB[2] = (u8)(bn>>24);
 
 		result = ENE_SendScsiCmd(us, FDIR_WRITE, scsi_sglist(srb), 1);
 	}
@@ -267,10 +267,10 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 	{
 		void	*buf;
 		int	offset=0;
-		WORD	PhyBlockAddr;
-		BYTE	PageNum;
-		DWORD	result;
-		WORD	len, oldphy, newphy;
+		u16	PhyBlockAddr;
+		u8	PageNum;
+		u32	result;
+		u16	len, oldphy, newphy;
 
 		buf = kmalloc(blenByte, GFP_KERNEL);
 		if (buf == NULL)
@@ -285,8 +285,8 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 			goto exit;
 		}
 
-		PhyBlockAddr = (WORD)(bn / us->MS_Lib.PagesPerBlock);
-		PageNum      = (BYTE)(bn % us->MS_Lib.PagesPerBlock);
+		PhyBlockAddr = (u16)(bn / us->MS_Lib.PagesPerBlock);
+		PageNum      = (u8)(bn % us->MS_Lib.PagesPerBlock);
 
 		while(1)
 		{
diff --git a/drivers/staging/keucr/sdscsi.c b/drivers/staging/keucr/sdscsi.c
index d646507..968b98a 100644
--- a/drivers/staging/keucr/sdscsi.c
+++ b/drivers/staging/keucr/sdscsi.c
@@ -61,7 +61,7 @@ int SD_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 int SD_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
 	//printk("SD_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+	u8 data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
@@ -71,8 +71,8 @@ int SD_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 //----- SD_SCSI_Mode_Sense() --------------------------------------------------
 int SD_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
 
 	if (us->SD_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
@@ -88,9 +88,9 @@ int SD_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
-	DWORD   bl_num;
-	WORD    bl_len;
-	BYTE    buf[8];
+	u32   bl_num;
+	u16    bl_len;
+	u8    buf[8];
 
 	printk("SD_SCSI_Read_Capacity\n");
 	if ( us->SD_Status.HiCapacity )
@@ -131,12 +131,12 @@ int SD_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD bnByte = bn * 0x200;
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32 bnByte = bn * 0x200;
+	u32	blenByte = blen * 0x200;
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -157,10 +157,10 @@ int SD_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	bcb->DataTransferLength = blenByte;
 	bcb->Flags  = 0x80;
 	bcb->CDB[0] = 0xF1;
-	bcb->CDB[5] = (BYTE)(bnByte);
-	bcb->CDB[4] = (BYTE)(bnByte>>8);
-	bcb->CDB[3] = (BYTE)(bnByte>>16);
-	bcb->CDB[2] = (BYTE)(bnByte>>24);
+	bcb->CDB[5] = (u8)(bnByte);
+	bcb->CDB[4] = (u8)(bnByte>>8);
+	bcb->CDB[3] = (u8)(bnByte>>16);
+	bcb->CDB[2] = (u8)(bnByte>>24);
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, scsi_sglist(srb), 1);
 	return result;
@@ -171,12 +171,12 @@ int SD_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD bnByte = bn * 0x200;
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32 bnByte = bn * 0x200;
+	u32	blenByte = blen * 0x200;
 
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -197,10 +197,10 @@ int SD_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 	bcb->DataTransferLength = blenByte;
 	bcb->Flags  = 0x00;
 	bcb->CDB[0] = 0xF0;
-	bcb->CDB[5] = (BYTE)(bnByte);
-	bcb->CDB[4] = (BYTE)(bnByte>>8);
-	bcb->CDB[3] = (BYTE)(bnByte>>16);
-	bcb->CDB[2] = (BYTE)(bnByte>>24);
+	bcb->CDB[5] = (u8)(bnByte);
+	bcb->CDB[4] = (u8)(bnByte>>8);
+	bcb->CDB[3] = (u8)(bnByte>>16);
+	bcb->CDB[2] = (u8)(bnByte>>24);
 
 	result = ENE_SendScsiCmd(us, FDIR_WRITE, scsi_sglist(srb), 1);
 	return result;
diff --git a/drivers/staging/keucr/smcommon.h b/drivers/staging/keucr/smcommon.h
index 1694605..39ac859 100644
--- a/drivers/staging/keucr/smcommon.h
+++ b/drivers/staging/keucr/smcommon.h
@@ -25,8 +25,8 @@ Define Difinetion
 #define ERR_NoSmartMedia    0x003A /* Medium Not Present */
 
 /***************************************************************************/
-char Bit_D_Count(BYTE);
-char Bit_D_CountWord(WORD);
+char Bit_D_Count(u8);
+char Bit_D_CountWord(u16);
 void StringCopy(char *, char *, int);
 int  StringCmp(char *, char *, int);
 
diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
index 4226813..b222941 100644
--- a/drivers/staging/keucr/smil.h
+++ b/drivers/staging/keucr/smil.h
@@ -165,44 +165,44 @@ Struct Definition
 ***************************************************************************/
 struct SSFDCTYPE
 {
-	BYTE Model;
-	BYTE Attribute;
-	BYTE MaxZones;
-	BYTE MaxSectors;
-	WORD MaxBlocks;
-	WORD MaxLogBlocks;
+	u8 Model;
+	u8 Attribute;
+	u8 MaxZones;
+	u8 MaxSectors;
+	u16 MaxBlocks;
+	u16 MaxLogBlocks;
 };
 
 typedef struct SSFDCTYPE_T
 {
-	BYTE Model;
-	BYTE Attribute;
-	BYTE MaxZones;
-	BYTE MaxSectors;
-	WORD MaxBlocks;
-	WORD MaxLogBlocks;
+	u8 Model;
+	u8 Attribute;
+	u8 MaxZones;
+	u8 MaxSectors;
+	u16 MaxBlocks;
+	u16 MaxLogBlocks;
 } *SSFDCTYPE_T;
 
 struct ADDRESS
 {
-	BYTE Zone;	/* Zone Number */
-	BYTE Sector;	/* Sector(512byte) Number on Block */
-	WORD PhyBlock;	/* Physical Block Number on Zone */
-	WORD LogBlock;	/* Logical Block Number of Zone */
+	u8 Zone;	/* Zone Number */
+	u8 Sector;	/* Sector(512byte) Number on Block */
+	u16 PhyBlock;	/* Physical Block Number on Zone */
+	u16 LogBlock;	/* Logical Block Number of Zone */
 };
 
 typedef struct ADDRESS_T
 {
-	BYTE Zone;	/* Zone Number */
-	BYTE Sector;	/* Sector(512byte) Number on Block */
-	WORD PhyBlock;	/* Physical Block Number on Zone */
-	WORD LogBlock;	/* Logical Block Number of Zone */
+	u8 Zone;	/* Zone Number */
+	u8 Sector;	/* Sector(512byte) Number on Block */
+	u16 PhyBlock;	/* Physical Block Number on Zone */
+	u16 LogBlock;	/* Logical Block Number of Zone */
 } *ADDRESS_T;
 
 struct CIS_AREA
 {
-	BYTE Sector;	/* Sector(512byte) Number on Block */
-	WORD PhyBlock;	/* Physical Block Number on Zone 0 */
+	u8 Sector;	/* Sector(512byte) Number on Block */
+	u16 PhyBlock;	/* Physical Block Number on Zone 0 */
 };
 
 
@@ -211,52 +211,52 @@ struct CIS_AREA
 int         Init_D_SmartMedia           (void);
 int         Pwoff_D_SmartMedia          (void);
 int         Check_D_SmartMedia          (void);
-int         Check_D_Parameter           (struct us_data *,WORD *,BYTE *,BYTE *);
-int         Media_D_ReadSector          (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_WriteSector         (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_CopySector          (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_EraseBlock          (struct us_data *,DWORD,WORD);
+int         Check_D_Parameter           (struct us_data *,u16 *,u8 *,u8 *);
+int         Media_D_ReadSector          (struct us_data *,u32,u16,u8 *);
+int         Media_D_WriteSector         (struct us_data *,u32,u16,u8 *);
+int         Media_D_CopySector          (struct us_data *,u32,u16,u8 *);
+int         Media_D_EraseBlock          (struct us_data *,u32,u16);
 int         Media_D_EraseAll            (struct us_data *);
 /******************************************/
-int         Media_D_OneSectWriteStart   (struct us_data *,DWORD,BYTE *);
-int         Media_D_OneSectWriteNext    (struct us_data *,BYTE *);
+int         Media_D_OneSectWriteStart   (struct us_data *,u32,u8 *);
+int         Media_D_OneSectWriteNext    (struct us_data *,u8 *);
 int         Media_D_OneSectWriteFlush   (struct us_data *);
 
 /******************************************/
-void        SM_EnableLED                (struct us_data *,BOOLEAN);
+void        SM_EnableLED                (struct us_data *,u8);
 void        Led_D_TernOn                (void);
 void        Led_D_TernOff               (void);
 
-int         Media_D_EraseAllRedtData    (DWORD Index, BOOLEAN CheckBlock);
-//DWORD       Media_D_GetMediaInfo        (struct us_data * fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut);
+int         Media_D_EraseAllRedtData    (u32 Index, u8 CheckBlock);
+//u32       Media_D_GetMediaInfo        (struct us_data * fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut);
 
 //----- SMILSub.c ----------------------------------------------------
 /******************************************/
-int  Check_D_DataBlank            (BYTE *);
-int  Check_D_FailBlock            (BYTE *);
-int  Check_D_DataStatus           (BYTE *);
-int  Load_D_LogBlockAddr          (BYTE *);
-void Clr_D_RedundantData          (BYTE *);
-void Set_D_LogBlockAddr           (BYTE *);
-void Set_D_FailBlock              (BYTE *);
-void Set_D_DataStaus              (BYTE *);
+int  Check_D_DataBlank            (u8 *);
+int  Check_D_FailBlock            (u8 *);
+int  Check_D_DataStatus           (u8 *);
+int  Load_D_LogBlockAddr          (u8 *);
+void Clr_D_RedundantData          (u8 *);
+void Set_D_LogBlockAddr           (u8 *);
+void Set_D_FailBlock              (u8 *);
+void Set_D_DataStaus              (u8 *);
 
 /******************************************/
 void Ssfdc_D_Reset                (struct us_data *);
-int  Ssfdc_D_ReadCisSect          (struct us_data *, BYTE *,BYTE *);
+int  Ssfdc_D_ReadCisSect          (struct us_data *, u8 *,u8 *);
 void Ssfdc_D_WriteRedtMode        (void);
-void Ssfdc_D_ReadID               (BYTE *, BYTE);
-int  Ssfdc_D_ReadSect             (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_ReadBlock            (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect            (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteBlock           (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_CopyBlock            (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSectForCopy     (struct us_data *, BYTE *,BYTE *);
+void Ssfdc_D_ReadID               (u8 *, u8);
+int  Ssfdc_D_ReadSect             (struct us_data *, u8 *,u8 *);
+int  Ssfdc_D_ReadBlock            (struct us_data *, u16, u8 *,u8 *);
+int  Ssfdc_D_WriteSect            (struct us_data *, u8 *,u8 *);
+int  Ssfdc_D_WriteBlock           (struct us_data *, u16, u8 *,u8 *);
+int  Ssfdc_D_CopyBlock            (struct us_data *, u16, u8 *,u8 *);
+int  Ssfdc_D_WriteSectForCopy     (struct us_data *, u8 *,u8 *);
 int  Ssfdc_D_EraseBlock           (struct us_data *);
-int  Ssfdc_D_ReadRedtData         (struct us_data *, BYTE *);
-int  Ssfdc_D_WriteRedtData        (struct us_data *, BYTE *);
+int  Ssfdc_D_ReadRedtData         (struct us_data *, u8 *);
+int  Ssfdc_D_WriteRedtData        (struct us_data *, u8 *);
 int  Ssfdc_D_CheckStatus          (void);
-int  Set_D_SsfdcModel             (BYTE);
+int  Set_D_SsfdcModel             (u8);
 void Cnt_D_Reset                  (void);
 int  Cnt_D_PowerOn                (void);
 void Cnt_D_PowerOff               (void);
@@ -266,24 +266,24 @@ int  Check_D_CntPower             (void);
 int  Check_D_CardExist            (void);
 int  Check_D_CardStsChg           (void);
 int  Check_D_SsfdcWP              (void);
-int  SM_ReadBlock                 (struct us_data *, BYTE *,BYTE *);
+int  SM_ReadBlock                 (struct us_data *, u8 *,u8 *);
 
-int  Ssfdc_D_ReadSect_DMA         (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_ReadSect_PIO         (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect_DMA        (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect_PIO        (struct us_data *, BYTE *,BYTE *);
+int  Ssfdc_D_ReadSect_DMA         (struct us_data *, u8 *,u8 *);
+int  Ssfdc_D_ReadSect_PIO         (struct us_data *, u8 *,u8 *);
+int  Ssfdc_D_WriteSect_DMA        (struct us_data *, u8 *,u8 *);
+int  Ssfdc_D_WriteSect_PIO        (struct us_data *, u8 *,u8 *);
 
 /******************************************/
-int  Check_D_ReadError            (BYTE *);
-int  Check_D_Correct              (BYTE *,BYTE *);
-int  Check_D_CISdata              (BYTE *,BYTE *);
-void Set_D_RightECC               (BYTE *);
+int  Check_D_ReadError            (u8 *);
+int  Check_D_Correct              (u8 *,u8 *);
+int  Check_D_CISdata              (u8 *,u8 *);
+void Set_D_RightECC               (u8 *);
 
 //----- SMILECC.c ----------------------------------------------------
-void calculate_ecc                (BYTE *, BYTE *, BYTE *, BYTE *, BYTE *);
-BYTE correct_data                 (BYTE *, BYTE *, BYTE,   BYTE,   BYTE);
-int  _Correct_D_SwECC             (BYTE *,BYTE *,BYTE *);
-void _Calculate_D_SwECC           (BYTE *,BYTE *);
+void calculate_ecc                (u8 *, u8 *, u8 *, u8 *, u8 *);
+u8 correct_data                 (u8 *, u8 *, u8,   u8,   u8);
+int  _Correct_D_SwECC             (u8 *,u8 *,u8 *);
+void _Calculate_D_SwECC           (u8 *,u8 *);
 
 void SM_Init        (void);
 
diff --git a/drivers/staging/keucr/smilecc.c b/drivers/staging/keucr/smilecc.c
index 5659dea..4d0e9e7 100644
--- a/drivers/staging/keucr/smilecc.c
+++ b/drivers/staging/keucr/smilecc.c
@@ -14,7 +14,7 @@
 //#include "EMCRIOS.h"
 
 // CP0-CP5 code table
-static BYTE ecctable[256] = {
+static u8 ecctable[256] = {
 0x00,0x55,0x56,0x03,0x59,0x0C,0x0F,0x5A,0x5A,0x0F,0x0C,0x59,0x03,0x56,0x55,0x00,
 0x65,0x30,0x33,0x66,0x3C,0x69,0x6A,0x3F,0x3F,0x6A,0x69,0x3C,0x66,0x33,0x30,0x65,
 0x66,0x33,0x30,0x65,0x3F,0x6A,0x69,0x3C,0x3C,0x69,0x6A,0x3F,0x65,0x30,0x33,0x66,
@@ -33,7 +33,7 @@ static BYTE ecctable[256] = {
 0x00,0x55,0x56,0x03,0x59,0x0C,0x0F,0x5A,0x5A,0x0F,0x0C,0x59,0x03,0x56,0x55,0x00
 };
 
-static void   trans_result  (BYTE,   BYTE,   BYTE *, BYTE *);
+static void   trans_result  (u8,   u8,   u8 *, u8 *);
 
 #define BIT7        0x80
 #define BIT6        0x40
@@ -49,14 +49,14 @@ static void   trans_result  (BYTE,   BYTE,   BYTE *, BYTE *);
 #define CORRECTABLE 0x00555554L
 
 static void trans_result(reg2,reg3,ecc1,ecc2)
-BYTE reg2; // LP14,LP12,LP10,...
-BYTE reg3; // LP15,LP13,LP11,...
-BYTE *ecc1; // LP15,LP14,LP13,...
-BYTE *ecc2; // LP07,LP06,LP05,...
+u8 reg2; // LP14,LP12,LP10,...
+u8 reg3; // LP15,LP13,LP11,...
+u8 *ecc1; // LP15,LP14,LP13,...
+u8 *ecc2; // LP07,LP06,LP05,...
 {
-    BYTE a; // Working for reg2,reg3
-    BYTE b; // Working for ecc1,ecc2
-    BYTE i; // For counting
+    u8 a; // Working for reg2,reg3
+    u8 b; // Working for ecc1,ecc2
+    u8 i; // For counting
 
     a=BIT7; b=BIT7; // 80h=10000000b
     *ecc1=*ecc2=0; // Clear ecc1,ecc2
@@ -84,17 +84,17 @@ BYTE *ecc2; // LP07,LP06,LP05,...
 
 //static void calculate_ecc(table,data,ecc1,ecc2,ecc3)
 void calculate_ecc(table,data,ecc1,ecc2,ecc3)
-BYTE *table; // CP0-CP5 code table
-BYTE *data; // DATA
-BYTE *ecc1; // LP15,LP14,LP13,...
-BYTE *ecc2; // LP07,LP06,LP05,...
-BYTE *ecc3; // CP5,CP4,CP3,...,"1","1"
+u8 *table; // CP0-CP5 code table
+u8 *data; // DATA
+u8 *ecc1; // LP15,LP14,LP13,...
+u8 *ecc2; // LP07,LP06,LP05,...
+u8 *ecc3; // CP5,CP4,CP3,...,"1","1"
 {
-    DWORD  i;    // For counting
-    BYTE a;    // Working for table
-    BYTE reg1; // D-all,CP5,CP4,CP3,...
-    BYTE reg2; // LP14,LP12,L10,...
-    BYTE reg3; // LP15,LP13,L11,...
+    u32  i;    // For counting
+    u8 a;    // Working for table
+    u8 reg1; // D-all,CP5,CP4,CP3,...
+    u8 reg2; // LP14,LP12,L10,...
+    u8 reg3; // LP15,LP13,L11,...
 
     reg1=reg2=reg3=0;   // Clear parameter
     for(i=0; i<256; ++i) {
@@ -102,8 +102,8 @@ BYTE *ecc3; // CP5,CP4,CP3,...,"1","1"
         reg1^=(a&MASK_CPS); // XOR with a
         if ((a&BIT6)!=0)
         { // If D_all(all bit XOR) = 1
-            reg3^=(BYTE)i; // XOR with counter
-            reg2^=~((BYTE)i); // XOR with inv. of counter
+            reg3^=(u8)i; // XOR with counter
+            reg2^=~((u8)i); // XOR with inv. of counter
         }
     }
 
@@ -113,27 +113,27 @@ BYTE *ecc3; // CP5,CP4,CP3,...,"1","1"
     *ecc3=((~reg1)<<2)|BIT1BIT0; // Make TEL format
 }
 
-BYTE correct_data(data,eccdata,ecc1,ecc2,ecc3)
-BYTE *data; // DATA
-BYTE *eccdata; // ECC DATA
-BYTE ecc1; // LP15,LP14,LP13,...
-BYTE ecc2; // LP07,LP06,LP05,...
-BYTE ecc3; // CP5,CP4,CP3,...,"1","1"
+u8 correct_data(data,eccdata,ecc1,ecc2,ecc3)
+u8 *data; // DATA
+u8 *eccdata; // ECC DATA
+u8 ecc1; // LP15,LP14,LP13,...
+u8 ecc2; // LP07,LP06,LP05,...
+u8 ecc3; // CP5,CP4,CP3,...,"1","1"
 {
-    DWORD l; // Working to check d
-    DWORD d; // Result of comparison
-    DWORD i; // For counting
-    BYTE d1,d2,d3; // Result of comparison
-    BYTE a; // Working for add
-    BYTE add; // Byte address of cor. DATA
-    BYTE b; // Working for bit
-    BYTE bit; // Bit address of cor. DATA
+    u32 l; // Working to check d
+    u32 d; // Result of comparison
+    u32 i; // For counting
+    u8 d1,d2,d3; // Result of comparison
+    u8 a; // Working for add
+    u8 add; // Byte address of cor. DATA
+    u8 b; // Working for bit
+    u8 bit; // Bit address of cor. DATA
 
     d1=ecc1^eccdata[1]; d2=ecc2^eccdata[0]; // Compare LP's
     d3=ecc3^eccdata[2]; // Comapre CP's
-    d=((DWORD)d1<<16) // Result of comparison
-    +((DWORD)d2<<8)
-    +(DWORD)d3;
+    d=((u32)d1<<16) // Result of comparison
+    +((u32)d2<<8)
+    +(u32)d3;
 
     if (d==0) return(0); // If No error, return
 
@@ -178,11 +178,11 @@ BYTE ecc3; // CP5,CP4,CP3,...,"1","1"
 }
 
 int _Correct_D_SwECC(buf,redundant_ecc,calculate_ecc)
-BYTE *buf;
-BYTE *redundant_ecc;
-BYTE *calculate_ecc;
+u8 *buf;
+u8 *redundant_ecc;
+u8 *calculate_ecc;
 {
-	DWORD err;
+	u32 err;
 
 	err = correct_data(buf, redundant_ecc, *(calculate_ecc + 1),
 			   *(calculate_ecc), *(calculate_ecc + 2));
@@ -196,8 +196,8 @@ BYTE *calculate_ecc;
 }
 
 void _Calculate_D_SwECC(buf,ecc)
-BYTE *buf;
-BYTE *ecc;
+u8 *buf;
+u8 *ecc;
 {
     calculate_ecc(ecctable,buf,ecc+1,ecc+0,ecc+2);
 }
diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index 2cbe9f8..5d4782f 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -4,7 +4,7 @@
 #include "smcommon.h"
 #include "smil.h"
 
-int         Check_D_LogCHS              (WORD *,BYTE *,BYTE *);
+int         Check_D_LogCHS              (u16 *,u8 *,u8 *);
 void        Initialize_D_Media          (void);
 void        PowerOff_D_Media            (void);
 int         Check_D_MediaPower          (void);
@@ -12,18 +12,18 @@ int         Check_D_MediaExist          (void);
 int         Check_D_MediaWP             (void);
 int         Check_D_MediaFmt            (struct us_data *);
 int         Check_D_MediaFmtForEraseAll (struct us_data *);
-int         Conv_D_MediaAddr            (struct us_data *, DWORD);
+int         Conv_D_MediaAddr            (struct us_data *, u32);
 int         Inc_D_MediaAddr             (struct us_data *);
 int         Check_D_FirstSect           (void);
 int         Check_D_LastSect            (void);
-int         Media_D_ReadOneSect         (struct us_data *, WORD, BYTE *);
-int         Media_D_WriteOneSect        (struct us_data *, WORD, BYTE *);
+int         Media_D_ReadOneSect         (struct us_data *, u16, u8 *);
+int         Media_D_WriteOneSect        (struct us_data *, u16, u8 *);
 int         Media_D_CopyBlockHead       (struct us_data *);
 int         Media_D_CopyBlockTail       (struct us_data *);
 int         Media_D_EraseOneBlock       (void);
 int         Media_D_EraseAllBlock       (void);
 
-int  Copy_D_BlockAll             (struct us_data *, DWORD);
+int  Copy_D_BlockAll             (struct us_data *, u32);
 int  Copy_D_BlockHead            (struct us_data *);
 int  Copy_D_BlockTail            (struct us_data *);
 int  Reassign_D_BlockHead        (struct us_data *);
@@ -34,8 +34,8 @@ int  Release_D_WriteBlock        (struct us_data *);
 int  Release_D_CopySector        (struct us_data *);
 
 int  Copy_D_PhyOneSect           (struct us_data *);
-int  Read_D_PhyOneSect           (struct us_data *, WORD, BYTE *);
-int  Write_D_PhyOneSect          (struct us_data *, WORD, BYTE *);
+int  Read_D_PhyOneSect           (struct us_data *, u16, u8 *);
+int  Write_D_PhyOneSect          (struct us_data *, u16, u8 *);
 int  Erase_D_PhyOneBlock         (struct us_data *);
 
 int  Set_D_PhyFmtValue           (struct us_data *);
@@ -45,34 +45,34 @@ void Check_D_BlockIsFull         (void);
 
 int  MarkFail_D_PhyOneBlock      (struct us_data *);
 
-DWORD ErrXDCode;
-DWORD ErrCode;
-//BYTE  SectBuf[SECTSIZE];
-BYTE  WorkBuf[SECTSIZE];
-BYTE  Redundant[REDTSIZE];
-BYTE  WorkRedund[REDTSIZE];
-//WORD  Log2Phy[MAX_ZONENUM][MAX_LOGBLOCK];
-WORD  *Log2Phy[MAX_ZONENUM];                 // 128 x 1000,   Log2Phy[MAX_ZONENUM][MAX_LOGBLOCK];
-BYTE  Assign[MAX_ZONENUM][MAX_BLOCKNUM/8];
-WORD  AssignStart[MAX_ZONENUM];
-WORD  ReadBlock;
-WORD  WriteBlock;
-DWORD MediaChange;
-DWORD SectCopyMode;
+u32 ErrXDCode;
+u32 ErrCode;
+//u8  SectBuf[SECTSIZE];
+u8  WorkBuf[SECTSIZE];
+u8  Redundant[REDTSIZE];
+u8  WorkRedund[REDTSIZE];
+//u16  Log2Phy[MAX_ZONENUM][MAX_LOGBLOCK];
+u16  *Log2Phy[MAX_ZONENUM];                 // 128 x 1000,   Log2Phy[MAX_ZONENUM][MAX_LOGBLOCK];
+u8  Assign[MAX_ZONENUM][MAX_BLOCKNUM/8];
+u16  AssignStart[MAX_ZONENUM];
+u16  ReadBlock;
+u16  WriteBlock;
+u32 MediaChange;
+u32 SectCopyMode;
 
 extern struct SSFDCTYPE  Ssfdc;
 extern struct ADDRESS    Media;
 extern struct CIS_AREA   CisArea;
 
 //BIT Controll Macro
-BYTE BitData[] = { 0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80 } ;
-#define Set_D_Bit(a,b)    (a[(BYTE)((b)/8)]|= BitData[(b)%8])
-#define Clr_D_Bit(a,b)    (a[(BYTE)((b)/8)]&=~BitData[(b)%8])
-#define Chk_D_Bit(a,b)    (a[(BYTE)((b)/8)] & BitData[(b)%8])
+u8 BitData[] = { 0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80 } ;
+#define Set_D_Bit(a,b)    (a[(u8)((b)/8)]|= BitData[(b)%8])
+#define Clr_D_Bit(a,b)    (a[(u8)((b)/8)]&=~BitData[(b)%8])
+#define Chk_D_Bit(a,b)    (a[(u8)((b)/8)] & BitData[(b)%8])
 
-//extern PBYTE    SMHostAddr;
-extern BYTE     IsSSFDCCompliance;
-extern BYTE     IsXDCompliance;
+//extern u8 *    SMHostAddr;
+extern u8     IsSSFDCCompliance;
+extern u8     IsXDCompliance;
 
 
 //
@@ -132,7 +132,7 @@ int SM_FreeMem(void)
 //}
 //
 ////----- Check_D_Parameter() --------------------------------------------
-//int Check_D_Parameter(PFDO_DEVICE_EXTENSION fdoExt,WORD *pcyl,BYTE *phead,BYTE *psect)
+//int Check_D_Parameter(PFDO_DEVICE_EXTENSION fdoExt,u16 *pcyl,u8 *phead,u8 *psect)
 //{
 //    if (Check_D_MediaPower())
 //        return(ErrCode);
@@ -148,9 +148,9 @@ int SM_FreeMem(void)
 
 //SmartMedia Read/Write/Erase Function
 //----- Media_D_ReadSector() -------------------------------------------
-int Media_D_ReadSector(struct us_data *us, DWORD start,WORD count,BYTE *buf)
+int Media_D_ReadSector(struct us_data *us, u32 start,u16 count,u8 *buf)
 {
-	WORD len, bn;
+	u16 len, bn;
 
 	//if (Check_D_MediaPower())        ; ¦b 6250 don't care
 	//    return(ErrCode);
@@ -190,11 +190,11 @@ int Media_D_ReadSector(struct us_data *us, DWORD start,WORD count,BYTE *buf)
 }
 // here
 //----- Media_D_CopySector() ------------------------------------------
-int Media_D_CopySector(struct us_data *us, DWORD start,WORD count,BYTE *buf)
+int Media_D_CopySector(struct us_data *us, u32 start,u16 count,u8 *buf)
 {
-	//DWORD mode;
+	//u32 mode;
 	//int i;
-	WORD len, bn;
+	u16 len, bn;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -266,10 +266,10 @@ int Release_D_CopySector(struct us_data *us)
 }
 /*
 //----- Media_D_WriteSector() ------------------------------------------
-int Media_D_WriteSector(PFDO_DEVICE_EXTENSION fdoExt, DWORD start,WORD count,BYTE *buf)
+int Media_D_WriteSector(PFDO_DEVICE_EXTENSION fdoExt, u32 start,u16 count,u8 *buf)
 {
     int i;
-    WORD len, bn;
+    u16 len, bn;
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -362,7 +362,7 @@ int Media_D_WriteSector(PFDO_DEVICE_EXTENSION fdoExt, DWORD start,WORD count,BYT
 }
 //
 ////----- Media_D_EraseBlock() -------------------------------------------
-//int Media_D_EraseBlock(PFDO_DEVICE_EXTENSION fdoExt, DWORD start,WORD count)
+//int Media_D_EraseBlock(PFDO_DEVICE_EXTENSION fdoExt, u32 start,u16 count)
 //{
 //    if (Check_D_MediaPower())
 //        return(ErrCode);
@@ -421,7 +421,7 @@ int Media_D_WriteSector(PFDO_DEVICE_EXTENSION fdoExt, DWORD start,WORD count,BYT
 
 //SmartMedia Write Function for One Sector Write Mode
 //----- Media_D_OneSectWriteStart() ------------------------------------
-int Media_D_OneSectWriteStart(PFDO_DEVICE_EXTENSION fdoExt,DWORD start,BYTE *buf)
+int Media_D_OneSectWriteStart(PFDO_DEVICE_EXTENSION fdoExt,u32 start,u8 *buf)
 {
 //  int i;
 //  SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
@@ -471,7 +471,7 @@ int Media_D_OneSectWriteStart(PFDO_DEVICE_EXTENSION fdoExt,DWORD start,BYTE *buf
 }
 
 //----- Media_D_OneSectWriteNext() -------------------------------------
-int Media_D_OneSectWriteNext(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf)
+int Media_D_OneSectWriteNext(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf)
 {
 //  int i;
 //  SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
@@ -527,7 +527,7 @@ int Media_D_OneSectWriteFlush(PFDO_DEVICE_EXTENSION fdoExt)
 //
 ////LED Tern On/Off Subroutine
 ////----- SM_EnableLED() -----------------------------------------------
-//void SM_EnableLED(PFDO_DEVICE_EXTENSION fdoExt, BOOLEAN enable)
+//void SM_EnableLED(PFDO_DEVICE_EXTENSION fdoExt, u8 enable)
 //{
 //    if (fdoExt->Drive_IsSWLED)
 //    {
@@ -558,7 +558,7 @@ int Media_D_OneSectWriteFlush(PFDO_DEVICE_EXTENSION fdoExt)
 //
 ////SmartMedia Logical Format Subroutine
 ////----- Check_D_LogCHS() -----------------------------------------------
-//int Check_D_LogCHS(WORD *c,BYTE *h,BYTE *s)
+//int Check_D_LogCHS(u16 *c,u8 *h,u8 *s)
 //{
 //    switch(Ssfdc.Model) {
 //        case SSFDC1MB:   *c=125; *h= 4; *s= 4; break;
@@ -740,15 +740,15 @@ int Check_D_MediaFmt(struct us_data *us)
 */
 //SmartMedia Physical Address Controll Subroutine
 //----- Conv_D_MediaAddr() ---------------------------------------------
-int Conv_D_MediaAddr(struct us_data *us, DWORD addr)
+int Conv_D_MediaAddr(struct us_data *us, u32 addr)
 {
-	DWORD temp;
+	u32 temp;
 	//ULONG  zz;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
 	temp           = addr/Ssfdc.MaxSectors;
-	Media.Zone     = (BYTE) (temp/Ssfdc.MaxLogBlocks);
+	Media.Zone     = (u8) (temp/Ssfdc.MaxLogBlocks);
 
 	if (Log2Phy[Media.Zone]==NULL)
 	{
@@ -759,8 +759,8 @@ int Conv_D_MediaAddr(struct us_data *us, DWORD addr)
 		}
 	}
 
-	Media.Sector   = (BYTE) (addr%Ssfdc.MaxSectors);
-	Media.LogBlock = (WORD) (temp%Ssfdc.MaxLogBlocks);
+	Media.Sector   = (u8) (addr%Ssfdc.MaxSectors);
+	Media.LogBlock = (u16) (temp%Ssfdc.MaxLogBlocks);
 
 	if (Media.Zone<Ssfdc.MaxZones)
 	{
@@ -777,7 +777,7 @@ int Conv_D_MediaAddr(struct us_data *us, DWORD addr)
 //----- Inc_D_MediaAddr() ----------------------------------------------
 int Inc_D_MediaAddr(struct us_data *us)
 {
-	WORD        LogBlock = Media.LogBlock;
+	u16        LogBlock = Media.LogBlock;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -857,9 +857,9 @@ int Check_D_LastSect(void)
 */
 //SmartMedia Read/Write Subroutine with Retry
 //----- Media_D_ReadOneSect() ------------------------------------------
-int Media_D_ReadOneSect(struct us_data *us, WORD count, BYTE *buf)
+int Media_D_ReadOneSect(struct us_data *us, u16 count, u8 *buf)
 {
-	DWORD err, retry;
+	u32 err, retry;
 
 	if (!Read_D_PhyOneSect(us, count, buf))
 		return(SUCCESS);
@@ -901,9 +901,9 @@ int Media_D_ReadOneSect(struct us_data *us, WORD count, BYTE *buf)
 }
 /*
 //----- Media_D_WriteOneSect() -----------------------------------------
-int Media_D_WriteOneSect(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf)
+int Media_D_WriteOneSect(PFDO_DEVICE_EXTENSION fdoExt, u16 count, u8 *buf)
 {
-    DWORD retry;
+    u32 retry;
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -939,7 +939,7 @@ int Media_D_WriteOneSect(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf)
 //----- Media_D_CopyBlockHead() ----------------------------------------
 int Media_D_CopyBlockHead(PFDO_DEVICE_EXTENSION fdoExt)
 {
-    DWORD retry;
+    u32 retry;
 
     for(retry=0; retry<2; retry++)
     {
@@ -956,7 +956,7 @@ int Media_D_CopyBlockHead(PFDO_DEVICE_EXTENSION fdoExt)
 //----- Media_D_CopyBlockTail() ----------------------------------------
 int Media_D_CopyBlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 {
-    DWORD retry;
+    u32 retry;
 
     if (!Copy_D_BlockTail(fdoExt))
         return(SUCCESS);
@@ -989,8 +989,8 @@ int Media_D_CopyBlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 ////----- Media_D_EraseOneBlock() ----------------------------------------
 //int Media_D_EraseOneBlock(void)
 //{
-//    WORD        LogBlock = Media.LogBlock;
-//    WORD        PhyBlock = Media.PhyBlock;
+//    u16        LogBlock = Media.LogBlock;
+//    u16        PhyBlock = Media.PhyBlock;
 //    SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 //    ADDRESS_T   bb = (ADDRESS_T) &Media;
 //
@@ -1030,7 +1030,7 @@ int Media_D_CopyBlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 ////----- Media_D_EraseAllBlock() ----------------------------------------
 //int Media_D_EraseAllBlock(void)
 //{
-//    WORD cis=0;
+//    u16 cis=0;
 //
 //    SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 //    ADDRESS_T   bb = (ADDRESS_T) &Media;
@@ -1081,9 +1081,9 @@ int Media_D_CopyBlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 */
 //SmartMedia Physical Sector Data Copy Subroutine
 //----- Copy_D_BlockAll() ----------------------------------------------
-int Copy_D_BlockAll(struct us_data *us, DWORD mode)
+int Copy_D_BlockAll(struct us_data *us, u32 mode)
 {
-	BYTE sect;
+	u8 sect;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1122,7 +1122,7 @@ int Copy_D_BlockAll(struct us_data *us, DWORD mode)
 //----- Copy_D_BlockHead() ---------------------------------------------
 int Copy_D_BlockHead(PFDO_DEVICE_EXTENSION fdoExt)
 {
-    BYTE sect;
+    u8 sect;
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1155,7 +1155,7 @@ int Copy_D_BlockHead(PFDO_DEVICE_EXTENSION fdoExt)
 //----- Copy_D_BlockTail() ---------------------------------------------
 int Copy_D_BlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 {
-    BYTE sect;
+    u8 sect;
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1184,9 +1184,9 @@ int Copy_D_BlockTail(PFDO_DEVICE_EXTENSION fdoExt)
 //----- Reassign_D_BlockHead() -----------------------------------------
 int Reassign_D_BlockHead(PFDO_DEVICE_EXTENSION fdoExt)
 {
-    DWORD  mode;
-    WORD   block;
-    BYTE   sect;
+    u32  mode;
+    u16   block;
+    u8   sect;
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1274,7 +1274,7 @@ int Assign_D_WriteBlock(void)
 //----- Release_D_ReadBlock() ------------------------------------------
 int Release_D_ReadBlock(struct us_data *us)
 {
-	DWORD mode;
+	u32 mode;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1330,7 +1330,7 @@ int Release_D_WriteBlock(struct us_data *us)
 int Copy_D_PhyOneSect(struct us_data *us)
 {
 	int           i;
-	DWORD  err, retry;
+	u32  err, retry;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1391,10 +1391,10 @@ int Copy_D_PhyOneSect(struct us_data *us)
 
 //SmartMedia Physical Sector Read/Write/Erase Subroutine
 //----- Read_D_PhyOneSect() --------------------------------------------
-int Read_D_PhyOneSect(struct us_data *us, WORD count, BYTE *buf)
+int Read_D_PhyOneSect(struct us_data *us, u16 count, u8 *buf)
 {
 	int           i;
-	DWORD  retry;
+	u32  retry;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1435,7 +1435,7 @@ int Read_D_PhyOneSect(struct us_data *us, WORD count, BYTE *buf)
 }
 /*
 //----- Write_D_PhyOneSect() -------------------------------------------
-int Write_D_PhyOneSect(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf)
+int Write_D_PhyOneSect(PFDO_DEVICE_EXTENSION fdoExt, u16 count, u8 *buf)
 {
     SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
     ADDRESS_T   bb = (ADDRESS_T) &Media;
@@ -1468,8 +1468,8 @@ int Erase_D_PhyOneBlock(struct us_data *us)
 int Set_D_PhyFmtValue(struct us_data *us)
 {
 //    PPDO_DEVICE_EXTENSION   pdoExt;
-//    BYTE      idcode[4];
-//    DWORD     UserDefData_1, UserDefData_2, Data, mask;
+//    u8      idcode[4];
+//    u32     UserDefData_1, UserDefData_2, Data, mask;
 //
 //    //if (!fdoExt->ChildDeviceObject)       return(ERROR);
 //    //pdoExt = fdoExt->ChildDeviceObject->DeviceExtension;
@@ -1613,13 +1613,13 @@ int Search_D_CIS(struct us_data *us)
 //----- Make_D_LogTable() ----------------------------------------------
 int Make_D_LogTable(struct us_data *us)
 {
-	WORD  phyblock,logblock;
+	u16  phyblock,logblock;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
 	if (Log2Phy[Media.Zone]==NULL)
 	{
-		Log2Phy[Media.Zone] = kmalloc(MAX_LOGBLOCK*sizeof(WORD), GFP_KERNEL);
+		Log2Phy[Media.Zone] = kmalloc(MAX_LOGBLOCK*sizeof(u16), GFP_KERNEL);
 		//printk("ExAllocatePool Zone = %x, Addr = %x\n", Media.Zone, Log2Phy[Media.Zone]);
 		if (Log2Phy[Media.Zone]==NULL)
 			return(ERROR);
@@ -1673,7 +1673,7 @@ int Make_D_LogTable(struct us_data *us)
 
 			phyblock     = Media.PhyBlock;
 			logblock     = Media.LogBlock;
-			Media.Sector = (BYTE)(Ssfdc.MaxSectors-1);
+			Media.Sector = (u8)(Ssfdc.MaxSectors-1);
 
 			if (Ssfdc_D_ReadRedtData(us, Redundant))
 			{ Ssfdc_D_Reset(us); return(ERROR); }
@@ -1741,7 +1741,7 @@ int Make_D_LogTable(struct us_data *us)
 //----- MarkFail_D_PhyOneBlock() ---------------------------------------
 int MarkFail_D_PhyOneBlock(struct us_data *us)
 {
-	BYTE sect;
+	u8 sect;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -1778,9 +1778,9 @@ int MarkFail_D_PhyOneBlock(struct us_data *us)
 //}
 //
 ////----- Media_D_EraseAllRedtData() -----------------------------------
-//int Media_D_EraseAllRedtData(DWORD Index, BOOLEAN CheckBlock)
+//int Media_D_EraseAllRedtData(u32 Index, u8 CheckBlock)
 //{
-//    BYTE    i;
+//    u8    i;
 //
 //    if (Check_D_MediaPower())
 //        return(ErrCode);
@@ -1791,7 +1791,7 @@ int MarkFail_D_PhyOneBlock(struct us_data *us)
 //    for (i=0; i<REDTSIZE; i++)
 //        WorkRedund[i] = 0xFF;
 //
-//    Media.Zone = (BYTE)Index;
+//    Media.Zone = (u8)Index;
 //    for (Media.PhyBlock=0; Media.PhyBlock<Ssfdc.MaxBlocks; Media.PhyBlock++)
 //    {
 //        if ((!Media.Zone) && (Media.PhyBlock<=CisArea.PhyBlock))
@@ -1825,7 +1825,7 @@ int MarkFail_D_PhyOneBlock(struct us_data *us)
 //}
 //
 ////----- Media_D_GetMediaInfo() ---------------------------------------
-//DWORD Media_D_GetMediaInfo(PFDO_DEVICE_EXTENSION fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut)
+//u32 Media_D_GetMediaInfo(PFDO_DEVICE_EXTENSION fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut)
 //{
 //    pParamOut->ErrCode = STATUS_CMD_FAIL;
 //
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 6dbc81d..c430197 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -9,47 +9,47 @@
 #include "smcommon.h"
 #include "smil.h"
 
-void   _Set_D_SsfdcRdCmd     (BYTE);
-void   _Set_D_SsfdcRdAddr    (BYTE);
+void   _Set_D_SsfdcRdCmd     (u8);
+void   _Set_D_SsfdcRdAddr    (u8);
 void   _Set_D_SsfdcRdChip    (void);
 void   _Set_D_SsfdcRdStandby (void);
 void   _Start_D_SsfdcRdHwECC (void);
 void   _Stop_D_SsfdcRdHwECC  (void);
-void   _Load_D_SsfdcRdHwECC  (BYTE);
-void   _Set_D_SsfdcWrCmd     (BYTE);
-void   _Set_D_SsfdcWrAddr    (BYTE);
+void   _Load_D_SsfdcRdHwECC  (u8);
+void   _Set_D_SsfdcWrCmd     (u8);
+void   _Set_D_SsfdcWrAddr    (u8);
 void   _Set_D_SsfdcWrBlock   (void);
 void   _Set_D_SsfdcWrStandby (void);
 void   _Start_D_SsfdcWrHwECC (void);
-void   _Load_D_SsfdcWrHwECC  (BYTE);
-int    _Check_D_SsfdcBusy    (WORD);
+void   _Load_D_SsfdcWrHwECC  (u8);
+int    _Check_D_SsfdcBusy    (u16);
 int    _Check_D_SsfdcStatus  (void);
 void   _Reset_D_SsfdcErr     (void);
-void   _Read_D_SsfdcBuf      (BYTE *);
-void   _Write_D_SsfdcBuf     (BYTE *);
-void   _Read_D_SsfdcByte     (BYTE *);
-void   _ReadRedt_D_SsfdcBuf  (BYTE *);
-void   _WriteRedt_D_SsfdcBuf (BYTE *);
-BYTE   _Check_D_DevCode      (BYTE);
+void   _Read_D_SsfdcBuf      (u8 *);
+void   _Write_D_SsfdcBuf     (u8 *);
+void   _Read_D_SsfdcByte     (u8 *);
+void   _ReadRedt_D_SsfdcBuf  (u8 *);
+void   _WriteRedt_D_SsfdcBuf (u8 *);
+u8   _Check_D_DevCode      (u8);
 
-void   _Set_D_ECCdata        (BYTE,BYTE *);
-void   _Calc_D_ECCdata       (BYTE *);
+void   _Set_D_ECCdata        (u8,u8 *);
+void   _Calc_D_ECCdata       (u8 *);
 
-//void   SM_ReadDataWithDMA      (PFDO_DEVICE_EXTENSION, BYTE *, WORD);
-//void   SM_WriteDataWithDMA     (PFDO_DEVICE_EXTENSION, BYTE *, WORD);
+//void   SM_ReadDataWithDMA      (PFDO_DEVICE_EXTENSION, u8 *, u16);
+//void   SM_WriteDataWithDMA     (PFDO_DEVICE_EXTENSION, u8 *, u16);
 //
 struct SSFDCTYPE                Ssfdc;
 struct ADDRESS                  Media;
 struct CIS_AREA                 CisArea;
 
-BYTE                            EccBuf[6];
-extern PBYTE                    SMHostAddr;
-extern BYTE                     IsSSFDCCompliance;
-extern BYTE                     IsXDCompliance;
-extern DWORD                    ErrXDCode;
+u8                            EccBuf[6];
+extern u8 *                    SMHostAddr;
+extern u8                     IsSSFDCCompliance;
+extern u8                     IsXDCompliance;
+extern u32                    ErrXDCode;
 
-extern WORD  ReadBlock;
-extern WORD  WriteBlock;
+extern u16  ReadBlock;
+extern u16  WriteBlock;
 
 //KEVENT                          SM_DMADoneEvent;
 
@@ -59,7 +59,7 @@ extern WORD  WriteBlock;
 
 //SmartMedia Redundant buffer data Controll Subroutine
 //----- Check_D_DataBlank() --------------------------------------------
-int Check_D_DataBlank(BYTE *redundant)
+int Check_D_DataBlank(u8 *redundant)
 {
 	char i;
 
@@ -71,7 +71,7 @@ int Check_D_DataBlank(BYTE *redundant)
 }
 
 //----- Check_D_FailBlock() --------------------------------------------
-int Check_D_FailBlock(BYTE *redundant)
+int Check_D_FailBlock(u8 *redundant)
 {
 	redundant+=REDT_BLOCK;
 
@@ -86,7 +86,7 @@ int Check_D_FailBlock(BYTE *redundant)
 }
 
 //----- Check_D_DataStatus() -------------------------------------------
-int Check_D_DataStatus(BYTE *redundant)
+int Check_D_DataStatus(u8 *redundant)
 {
 	redundant+=REDT_DATA;
 
@@ -107,20 +107,20 @@ int Check_D_DataStatus(BYTE *redundant)
 }
 
 //----- Load_D_LogBlockAddr() ------------------------------------------
-int Load_D_LogBlockAddr(BYTE *redundant)
+int Load_D_LogBlockAddr(u8 *redundant)
 {
-	WORD addr1,addr2;
+	u16 addr1,addr2;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
-	addr1=(WORD)*(redundant+REDT_ADDR1H)*0x0100+(WORD)*(redundant+REDT_ADDR1L);
-	addr2=(WORD)*(redundant+REDT_ADDR2H)*0x0100+(WORD)*(redundant+REDT_ADDR2L);
+	addr1=(u16)*(redundant+REDT_ADDR1H)*0x0100+(u16)*(redundant+REDT_ADDR1L);
+	addr2=(u16)*(redundant+REDT_ADDR2H)*0x0100+(u16)*(redundant+REDT_ADDR2L);
 
 	if (addr1==addr2)
 		if ((addr1 &0xF000)==0x1000)
 		{ Media.LogBlock=(addr1 &0x0FFF)/2; return(SUCCESS); }
 
-	if (Bit_D_CountWord((WORD)(addr1^addr2))!=0x01) return(ERROR);
+	if (Bit_D_CountWord((u16)(addr1^addr2))!=0x01) return(ERROR);
 
 	if ((addr1 &0xF000)==0x1000)
 		if (!(Bit_D_CountWord(addr1) &0x01))
@@ -134,7 +134,7 @@ int Load_D_LogBlockAddr(BYTE *redundant)
 }
 
 //----- Clr_D_RedundantData() ------------------------------------------
-void Clr_D_RedundantData(BYTE *redundant)
+void Clr_D_RedundantData(u8 *redundant)
 {
 	char i;
 
@@ -143,9 +143,9 @@ void Clr_D_RedundantData(BYTE *redundant)
 }
 
 //----- Set_D_LogBlockAddr() -------------------------------------------
-void Set_D_LogBlockAddr(BYTE *redundant)
+void Set_D_LogBlockAddr(u8 *redundant)
 {
-	WORD addr;
+	u16 addr;
 
 	*(redundant+REDT_BLOCK)=0xFF;
 	*(redundant+REDT_DATA) =0xFF;
@@ -154,21 +154,21 @@ void Set_D_LogBlockAddr(BYTE *redundant)
 	if ((Bit_D_CountWord(addr)%2))
 		addr++;
 
-	*(redundant+REDT_ADDR1H)=*(redundant+REDT_ADDR2H)=(BYTE)(addr/0x0100);
-	*(redundant+REDT_ADDR1L)=*(redundant+REDT_ADDR2L)=(BYTE)addr;
+	*(redundant+REDT_ADDR1H)=*(redundant+REDT_ADDR2H)=(u8)(addr/0x0100);
+	*(redundant+REDT_ADDR1L)=*(redundant+REDT_ADDR2L)=(u8)addr;
 }
 
 //----- Set_D_FailBlock() ----------------------------------------------
-void Set_D_FailBlock(BYTE *redundant)
+void Set_D_FailBlock(u8 *redundant)
 {
     char i;
 
     for(i=0; i<REDTSIZE; i++)
-        *redundant++=(BYTE)((i==REDT_BLOCK)?0xF0:0xFF);
+        *redundant++=(u8)((i==REDT_BLOCK)?0xF0:0xFF);
 }
 
 //----- Set_D_DataStaus() ----------------------------------------------
-void Set_D_DataStaus(BYTE *redundant)
+void Set_D_DataStaus(u8 *redundant)
 {
     redundant+=REDT_DATA;
     *redundant=0x00;
@@ -181,7 +181,7 @@ void Ssfdc_D_Reset(struct us_data *us)
 {
 	//NTSTATUS        ntStatus = STATUS_SUCCESS;
 	//PBULK_CBW       pBulkCbw = fdoExt->pBulkCbw;
-	//BYTE            buf[0x200];
+	//u8            buf[0x200];
 
 	//printk("Ssfdc_D_Reset --- But do nothing !!\n");
 	return;
@@ -203,10 +203,10 @@ void Ssfdc_D_Reset(struct us_data *us)
 }
 
 //----- Ssfdc_D_ReadCisSect() ------------------------------------------
-int Ssfdc_D_ReadCisSect(struct us_data *us, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_ReadCisSect(struct us_data *us, u8 *buf,u8 *redundant)
 {
-	BYTE zone,sector;
-	WORD block;
+	u8 zone,sector;
+	u16 block;
 	//SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 	//ADDRESS_T   bb = (ADDRESS_T) &Media;
 
@@ -236,7 +236,7 @@ int Ssfdc_D_ReadCisSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 //}
 //
 ////----- Ssfdc_D_ReadID() -----------------------------------------------
-//void Ssfdc_D_ReadID(BYTE *buf, BYTE ReadID)
+//void Ssfdc_D_ReadID(u8 *buf, u8 ReadID)
 //{
 //    _Set_D_SsfdcRdCmd     (ReadID);
 //    _Set_D_SsfdcRdChip    ();
@@ -249,11 +249,11 @@ int Ssfdc_D_ReadCisSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 */
 // 6250 CMD 1
 //----- Ssfdc_D_ReadSect() ---------------------------------------------
-int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_ReadSect(struct us_data *us, u8 *buf,u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	WORD	addr;
+	u16	addr;
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
@@ -262,8 +262,8 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+	addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
 	// Read sect data
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
@@ -272,8 +272,8 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x02;
-	bcb->CDB[4]			= (BYTE)addr;
-	bcb->CDB[3]			= (BYTE)(addr/0x0100);
+	bcb->CDB[4]			= (u8)addr;
+	bcb->CDB[3]			= (u8)(addr/0x0100);
 	bcb->CDB[2]			= Media.Zone/2;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, buf, 0);
@@ -287,8 +287,8 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[4]			= (BYTE)addr;
-	bcb->CDB[3]			= (BYTE)(addr/0x0100);
+	bcb->CDB[4]			= (u8)addr;
+	bcb->CDB[3]			= (u8)(addr/0x0100);
 	bcb->CDB[2]			= Media.Zone/2;
 	bcb->CDB[8]			= 0;
 	bcb->CDB[9]			= 1;
@@ -301,11 +301,11 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf,BYTE *redundant)
 }
 
 //----- Ssfdc_D_ReadBlock() ---------------------------------------------
-int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_ReadBlock(struct us_data *us, u16 count, u8 *buf,u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	WORD	addr;
+	u16	addr;
 
 	//printk("Ssfdc_D_ReadBlock\n");
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
@@ -315,8 +315,8 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+	addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
 	// Read sect data
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
@@ -325,8 +325,8 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x02;
-	bcb->CDB[4]			= (BYTE)addr;
-	bcb->CDB[3]			= (BYTE)(addr/0x0100);
+	bcb->CDB[4]			= (u8)addr;
+	bcb->CDB[3]			= (u8)(addr/0x0100);
 	bcb->CDB[2]			= Media.Zone/2;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, buf, 0);
@@ -340,8 +340,8 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[4]			= (BYTE)addr;
-	bcb->CDB[3]			= (BYTE)(addr/0x0100);
+	bcb->CDB[4]			= (u8)addr;
+	bcb->CDB[3]			= (u8)(addr/0x0100);
 	bcb->CDB[2]			= Media.Zone/2;
 	bcb->CDB[8]			= 0;
 	bcb->CDB[9]			= 1;
@@ -354,26 +354,26 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 }
 /*
 ////----- Ssfdc_D_ReadSect_DMA() ---------------------------------------------
-//int Ssfdc_D_ReadSect_DMA(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+//int Ssfdc_D_ReadSect_DMA(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 //{
-//    WORD    SectByteCount, addr;
-//    DWORD   Buffer[4];
-//    WORD    len;
+//    u16    SectByteCount, addr;
+//    u32   Buffer[4];
+//    u16    len;
 //
 //    if (!_Hw_D_ChkCardIn())
 //       return(ERROR);
-//    addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-//    addr=addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+//    addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+//    addr=addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 //    // cycle starting address
 //    SM_STARTADDR_LSB = 0x00;
-//    SM_STARTADDR_IISB = (BYTE)addr;
-//    SM_STARTADDR_IIISB = (BYTE)(addr/0x0100);
+//    SM_STARTADDR_IISB = (u8)addr;
+//    SM_STARTADDR_IIISB = (u8)(addr/0x0100);
 //    SM_STARTADDR_MSB = Media.Zone/2;
 //
 //    //Sector byte count = 0x200(DMA)
 //    SectByteCount = 0x20f;
-//    SM_BYTECNT_LO = (BYTE)SectByteCount;
-//    SM_CMD_CTRL3 = (SM_CMD_CTRL3 & 0xFC) | (BYTE)(SectByteCount/0x0100);
+//    SM_BYTECNT_LO = (u8)SectByteCount;
+//    SM_CMD_CTRL3 = (SM_CMD_CTRL3 & 0xFC) | (u8)(SectByteCount/0x0100);
 //    if ( ((fdoExt->ChipID==READER_CB712)&&(fdoExt->RevID==CHIP_A)) || fdoExt->IsHibernate )
 //       SM_FIFO_CTRL = (SM_APB08_MASK | SM_DMAEN_MASK | SM_DMA_UPSTREAM_MASK | SM_FIFOSHLDVLU_8_MASK);
 //    else
@@ -388,7 +388,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 //    SectByteCount = 0x1ff;
 //    //SM_ReadDataWithDMA(fdoExt, buf, SectByteCount);
 //    //_ReadRedt_D_SsfdcBuf(redundant);
-//    len = 0x1000 - ((WORD)(buf) & 0x0FFF);
+//    len = 0x1000 - ((u16)(buf) & 0x0FFF);
 //    if (len < 0x200)
 //    {
 //       SM_ReadDataWithDMA(fdoExt, buf, len-1);
@@ -432,7 +432,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 //}
 //
 ////----- Ssfdc_D_ReadSect_PIO() ---------------------------------------------
-//int Ssfdc_D_ReadSect_PIO(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+//int Ssfdc_D_ReadSect_PIO(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 //{
 //    _Set_D_SsfdcRdCmd(READ);
 //    _Set_D_SsfdcRdAddr(EVEN);
@@ -456,17 +456,17 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 
 // 6250 CMD 3
 //----- Ssfdc_D_WriteSect() --------------------------------------------
-int Ssfdc_D_WriteSect(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_WriteSect(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 {
     PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
     NTSTATUS                ntStatus;
-    WORD                    addr;
+    u16                    addr;
 
     //ENE_Print("SMILSUB --- Ssfdc_D_WriteSect\n");
     ENE_LoadBinCode(fdoExt, SM_RW_PATTERN);
 
-    addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-    addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+    addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+    addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
     // Write sect data
     RtlZeroMemory(pBulkCbw, sizeof(struct _BULK_CBW));
@@ -476,13 +476,13 @@ int Ssfdc_D_WriteSect(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
     pBulkCbw->bmCBWFlags             = 0x00;
     pBulkCbw->CBWCb[0]               = 0xF0;
     pBulkCbw->CBWCb[1]               = 0x04;
-    //pBulkCbw->CBWCb[4]               = (BYTE)addr;
-    //pBulkCbw->CBWCb[3]               = (BYTE)(addr/0x0100);
+    //pBulkCbw->CBWCb[4]               = (u8)addr;
+    //pBulkCbw->CBWCb[3]               = (u8)(addr/0x0100);
     //pBulkCbw->CBWCb[2]               = Media.Zone/2;
     //pBulkCbw->CBWCb[5]               = *(redundant+REDT_ADDR1H);
     //pBulkCbw->CBWCb[6]               = *(redundant+REDT_ADDR1L);
-    pBulkCbw->CBWCb[7]               = (BYTE)addr;
-    pBulkCbw->CBWCb[6]               = (BYTE)(addr/0x0100);
+    pBulkCbw->CBWCb[7]               = (u8)addr;
+    pBulkCbw->CBWCb[6]               = (u8)(addr/0x0100);
     pBulkCbw->CBWCb[5]               = Media.Zone/2;
     pBulkCbw->CBWCb[8]               = *(redundant+REDT_ADDR1H);
     pBulkCbw->CBWCb[9]               = *(redundant+REDT_ADDR1L);
@@ -494,7 +494,7 @@ int Ssfdc_D_WriteSect(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
 
 //  // For Test
 //  {
-//     BYTE   bf[0x200], rdd[0x10];
+//     u8   bf[0x200], rdd[0x10];
 //     ULONG  i;
 //
 //     RtlZeroMemory(bf, 0x200);
@@ -513,13 +513,13 @@ int Ssfdc_D_WriteSect(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
 }
 */
 //----- Ssfdc_D_CopyBlock() --------------------------------------------
-int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_CopyBlock(struct us_data *us, u16 count, u8 *buf,u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
     //PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
     //NTSTATUS                ntStatus;
-	WORD	ReadAddr, WriteAddr;
+	u16	ReadAddr, WriteAddr;
 
 	//printk("Ssfdc_D_WriteSect --- ZONE = %x, ReadBlock = %x, WriteBlock = %x\n", Media.Zone, ReadBlock, WriteBlock);
 
@@ -530,10 +530,10 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	ReadAddr = (WORD)Media.Zone*Ssfdc.MaxBlocks+ReadBlock;
-	ReadAddr = ReadAddr*(WORD)Ssfdc.MaxSectors;
-	WriteAddr = (WORD)Media.Zone*Ssfdc.MaxBlocks+WriteBlock;
-	WriteAddr = WriteAddr*(WORD)Ssfdc.MaxSectors;
+	ReadAddr = (u16)Media.Zone*Ssfdc.MaxBlocks+ReadBlock;
+	ReadAddr = ReadAddr*(u16)Ssfdc.MaxSectors;
+	WriteAddr = (u16)Media.Zone*Ssfdc.MaxBlocks+WriteBlock;
+	WriteAddr = WriteAddr*(u16)Ssfdc.MaxSectors;
 
 	// Write sect data
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
@@ -542,8 +542,8 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 	bcb->Flags			= 0x00;
 	bcb->CDB[0]			= 0xF0;
 	bcb->CDB[1]			= 0x08;
-	bcb->CDB[7]			= (BYTE)WriteAddr;
-	bcb->CDB[6]			= (BYTE)(WriteAddr/0x0100);
+	bcb->CDB[7]			= (u8)WriteAddr;
+	bcb->CDB[6]			= (u8)(WriteAddr/0x0100);
 	bcb->CDB[5]			= Media.Zone/2;
 	bcb->CDB[8]			= *(redundant+REDT_ADDR1H);
 	bcb->CDB[9]			= *(redundant+REDT_ADDR1L);
@@ -551,8 +551,8 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 
 	if (ReadBlock != NO_ASSIGN)
 	{
-		bcb->CDB[4]		= (BYTE)ReadAddr;
-		bcb->CDB[3]		= (BYTE)(ReadAddr/0x0100);
+		bcb->CDB[4]		= (u8)ReadAddr;
+		bcb->CDB[3]		= (u8)(ReadAddr/0x0100);
 		bcb->CDB[2]		= Media.Zone/2;
 	}
 	else
@@ -566,17 +566,17 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,BYTE *redundant)
 }
 /*
 //----- Ssfdc_D_WriteBlock() --------------------------------------------
-int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE *redundant)
+int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, u16 count, u8 *buf,u8 *redundant)
 {
     PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
     NTSTATUS                ntStatus;
-    WORD                    addr;
+    u16                    addr;
 
     //ENE_Print("SMILSUB --- Ssfdc_D_WriteSect\n");
     ENE_LoadBinCode(fdoExt, SM_RW_PATTERN);
 
-    addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-    addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+    addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+    addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
     // Write sect data
     RtlZeroMemory(pBulkCbw, sizeof(struct _BULK_CBW));
@@ -586,8 +586,8 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
     pBulkCbw->bmCBWFlags             = 0x00;
     pBulkCbw->CBWCb[0]               = 0xF0;
     pBulkCbw->CBWCb[1]               = 0x04;
-    pBulkCbw->CBWCb[7]               = (BYTE)addr;
-    pBulkCbw->CBWCb[6]               = (BYTE)(addr/0x0100);
+    pBulkCbw->CBWCb[7]               = (u8)addr;
+    pBulkCbw->CBWCb[6]               = (u8)(addr/0x0100);
     pBulkCbw->CBWCb[5]               = Media.Zone/2;
     pBulkCbw->CBWCb[8]               = *(redundant+REDT_ADDR1H);
     pBulkCbw->CBWCb[9]               = *(redundant+REDT_ADDR1L);
@@ -599,7 +599,7 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 
 //  // For Test
 //  {
-//     BYTE   bf[0x200], rdd[0x10];
+//     u8   bf[0x200], rdd[0x10];
 //     ULONG  i;
 //
 //     RtlZeroMemory(bf, 0x200);
@@ -618,26 +618,26 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 }
 //
 ////----- Ssfdc_D_WriteSect_DMA() --------------------------------------------
-//int Ssfdc_D_WriteSect_DMA(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+//int Ssfdc_D_WriteSect_DMA(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 //{
-//    WORD    SectByteCount, addr;
-//    DWORD   Buffer[4];
-//    WORD    len;
+//    u16    SectByteCount, addr;
+//    u32   Buffer[4];
+//    u16    len;
 //
 //    if (!_Hw_D_ChkCardIn())
 //       return(ERROR);
-//    addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-//    addr=addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+//    addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+//    addr=addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 //    // cycle starting address
 //    SM_STARTADDR_LSB = 0x00;
-//    SM_STARTADDR_IISB = (BYTE)addr;
-//    SM_STARTADDR_IIISB = (BYTE)(addr/0x0100);
+//    SM_STARTADDR_IISB = (u8)addr;
+//    SM_STARTADDR_IIISB = (u8)(addr/0x0100);
 //    SM_STARTADDR_MSB = Media.Zone/2;
 //
 //    //Sector byte count (DMA)
 //    SectByteCount = 0x20f;
-//    SM_BYTECNT_LO = (BYTE)SectByteCount;
-//    SM_CMD_CTRL3 = (SM_CMD_CTRL3 & 0xFC) | 0x20 | (BYTE)(SectByteCount/0x0100);
+//    SM_BYTECNT_LO = (u8)SectByteCount;
+//    SM_CMD_CTRL3 = (SM_CMD_CTRL3 & 0xFC) | 0x20 | (u8)(SectByteCount/0x0100);
 //    if ( ((fdoExt->ChipID==READER_CB712)&&(fdoExt->RevID==CHIP_A)) || fdoExt->IsHibernate )
 //       SM_FIFO_CTRL = (SM_APB08_MASK | SM_DMAEN_MASK | SM_DMA_DOWNSTREAM_MASK | SM_FIFOSHLDVLU_8_MASK);
 //    else
@@ -652,7 +652,7 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 //    SectByteCount = 0x1ff;
 //    //SM_WriteDataWithDMA(fdoExt, buf, SectByteCount);
 //    //_WriteRedt_D_SsfdcBuf(redundant);
-//    len = 0x1000 - ((WORD)(buf) & 0x0FFF);
+//    len = 0x1000 - ((u16)(buf) & 0x0FFF);
 //    if (len < 0x200)
 //    {
 //       SM_WriteDataWithDMA(fdoExt, buf, len-1);
@@ -668,9 +668,9 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 //    //   ENE_Print("Ssfdc_D_WriteSect_DMA !!! buf = %p, T1 = %p, T2 = %p\n", buf, T1, T2);
 //    //if (T2-T1)
 //    //{
-//    //   l1 = (WORD)(T2 - (ULONGLONG)buf);
+//    //   l1 = (u16)(T2 - (ULONGLONG)buf);
 //    //   SM_WriteDataWithDMA(fdoExt, buf, l1-1);
-//    //   SM_WriteDataWithDMA(fdoExt, (PBYTE)T2, SectByteCount-l1);
+//    //   SM_WriteDataWithDMA(fdoExt, (u8 *)T2, SectByteCount-l1);
 //    //}
 //    //else
 //    //  SM_WriteDataWithDMA(fdoExt, buf, SectByteCount);
@@ -708,7 +708,7 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 //}
 //
 ////----- Ssfdc_D_WriteSect_PIO() --------------------------------------------
-//int Ssfdc_D_WriteSect_PIO(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+//int Ssfdc_D_WriteSect_PIO(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 //{
 //    _Calc_D_ECCdata(buf);
 //    _Set_D_SsfdcWrCmd(WRDATA);
@@ -733,13 +733,13 @@ int Ssfdc_D_WriteBlock(PFDO_DEVICE_EXTENSION fdoExt, WORD count, BYTE *buf,BYTE
 //}
 */
 //----- Ssfdc_D_WriteSectForCopy() -------------------------------------
-int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
+int Ssfdc_D_WriteSectForCopy(struct us_data *us, u8 *buf, u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	//PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
 	//NTSTATUS                ntStatus;
-	WORD                    addr;
+	u16                    addr;
 
 	//printk("SMILSUB --- Ssfdc_D_WriteSectForCopy\n");
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
@@ -750,8 +750,8 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 	}
 
 
-	addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+	addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
 	// Write sect data
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
@@ -760,8 +760,8 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 	bcb->Flags			= 0x00;
 	bcb->CDB[0]			= 0xF0;
 	bcb->CDB[1]			= 0x04;
-	bcb->CDB[7]			= (BYTE)addr;
-	bcb->CDB[6]			= (BYTE)(addr/0x0100);
+	bcb->CDB[7]			= (u8)addr;
+	bcb->CDB[6]			= (u8)(addr/0x0100);
 	bcb->CDB[5]			= Media.Zone/2;
 	bcb->CDB[8]			= *(redundant+REDT_ADDR1H);
 	bcb->CDB[9]			= *(redundant+REDT_ADDR1L);
@@ -779,7 +779,7 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	WORD	addr;
+	u16	addr;
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
@@ -788,8 +788,8 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr=addr*(WORD)Ssfdc.MaxSectors;
+	addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr=addr*(u16)Ssfdc.MaxSectors;
 
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -797,8 +797,8 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF2;
 	bcb->CDB[1]			= 0x06;
-	bcb->CDB[7]			= (BYTE)addr;
-	bcb->CDB[6]			= (BYTE)(addr/0x0100);
+	bcb->CDB[7]			= (u8)addr;
+	bcb->CDB[6]			= (u8)(addr/0x0100);
 	bcb->CDB[5]			= Media.Zone/2;
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, NULL, 0);
@@ -810,12 +810,12 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 
 // 6250 CMD 2
 //----- Ssfdc_D_ReadRedtData() -----------------------------------------
-int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
+int Ssfdc_D_ReadRedtData(struct us_data *us, u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
-	WORD	addr;
-	BYTE  *buf;
+	u16	addr;
+	u8  *buf;
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
@@ -824,8 +824,8 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+	addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -833,8 +833,8 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF1;
 	bcb->CDB[1]			= 0x03;
-	bcb->CDB[4]			= (BYTE)addr;
-	bcb->CDB[3]			= (BYTE)(addr/0x0100);
+	bcb->CDB[4]			= (u8)addr;
+	bcb->CDB[3]			= (u8)(addr/0x0100);
 	bcb->CDB[2]			= Media.Zone/2;
 	bcb->CDB[8]			= 0;
 	bcb->CDB[9]			= 1;
@@ -852,13 +852,13 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 
 // 6250 CMD 4
 //----- Ssfdc_D_WriteRedtData() ----------------------------------------
-int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
+int Ssfdc_D_WriteRedtData(struct us_data *us, u8 *redundant)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	//PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
 	//NTSTATUS                ntStatus;
-	WORD                    addr;
+	u16                    addr;
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
@@ -867,8 +867,8 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-	addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+	addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+	addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -876,8 +876,8 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
 	bcb->Flags			= 0x80;
 	bcb->CDB[0]			= 0xF2;
 	bcb->CDB[1]			= 0x05;
-	bcb->CDB[7]			= (BYTE)addr;
-	bcb->CDB[6]			= (BYTE)(addr/0x0100);
+	bcb->CDB[7]			= (u8)addr;
+	bcb->CDB[6]			= (u8)(addr/0x0100);
 	bcb->CDB[5]			= Media.Zone/2;
 	bcb->CDB[8]			= *(redundant+REDT_ADDR1H);
 	bcb->CDB[9]			= *(redundant+REDT_ADDR1L);
@@ -905,7 +905,7 @@ int Ssfdc_D_CheckStatus(void)
 /*
 ////NAND Memory (SmartMedia) Control Subroutine for Read Data
 ////----- _Set_D_SsfdcRdCmd() --------------------------------------------
-//void _Set_D_SsfdcRdCmd(BYTE cmd)
+//void _Set_D_SsfdcRdCmd(u8 cmd)
 //{
 //    _Hw_D_SetRdCmd();
 //    _Hw_D_OutData(cmd);
@@ -913,25 +913,25 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Set_D_SsfdcRdAddr() -------------------------------------------
-//void _Set_D_SsfdcRdAddr(BYTE add)
+//void _Set_D_SsfdcRdAddr(u8 add)
 //{
-//    WORD addr;
+//    u16 addr;
 //    SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 //    ADDRESS_T   bb = (ADDRESS_T) &Media;
 //
-//    addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-//    addr=addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+//    addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+//    addr=addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 //
 //    //if ((Ssfdc.Attribute &MPS)==PS256) // for 256byte/page
-//    //    addr=addr*2+(WORD)add;
+//    //    addr=addr*2+(u16)add;
 //
 //    _Hw_D_SetRdAddr();
 //    _Hw_D_OutData(0x00);
-//    _Hw_D_OutData((BYTE)addr);
-//    _Hw_D_OutData((BYTE)(addr/0x0100));
+//    _Hw_D_OutData((u8)addr);
+//    _Hw_D_OutData((u8)(addr/0x0100));
 //
 //    if ((Ssfdc.Attribute &MADC)==AD4CYC)
-//        _Hw_D_OutData((BYTE)(Media.Zone/2)); // Patch
+//        _Hw_D_OutData((u8)(Media.Zone/2)); // Patch
 //
 //    _Hw_D_SetRdData();
 //}
@@ -969,7 +969,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Load_D_SsfdcRdHwECC() -----------------------------------------
-//void _Load_D_SsfdcRdHwECC(BYTE add)
+//void _Load_D_SsfdcRdHwECC(u8 add)
 //{
 //#ifdef HW_ECC_SUPPORTED
 //    _Hw_D_EccRdRead();
@@ -994,7 +994,7 @@ int Ssfdc_D_CheckStatus(void)
 ////NAND Memory (SmartMedia) Control Subroutine for Write Data
 //
 ////----- _Set_D_SsfdcWrCmd() -----------------------------------------
-//void _Set_D_SsfdcWrCmd(BYTE cmd)
+//void _Set_D_SsfdcWrCmd(u8 cmd)
 //{
 //    _Hw_D_SetWrCmd();
 //    _Hw_D_OutData(cmd);
@@ -1002,25 +1002,25 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Set_D_SsfdcWrAddr() -----------------------------------------
-//void _Set_D_SsfdcWrAddr(BYTE add)
+//void _Set_D_SsfdcWrAddr(u8 add)
 //{
-//    WORD addr;
+//    u16 addr;
 //    SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 //    ADDRESS_T   bb = (ADDRESS_T) &Media;
 //
-//    addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-//    addr=addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+//    addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+//    addr=addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 //
 //    //if ((Ssfdc.Attribute &MPS)==PS256) // for 256byte/page
-//    //    addr=addr*2+(WORD)add;
+//    //    addr=addr*2+(u16)add;
 //
 //    _Hw_D_SetWrAddr();
 //    _Hw_D_OutData(0x00);
-//    _Hw_D_OutData((BYTE)addr);
-//    _Hw_D_OutData((BYTE)(addr/0x0100));
+//    _Hw_D_OutData((u8)addr);
+//    _Hw_D_OutData((u8)(addr/0x0100));
 //
 //    if ((Ssfdc.Attribute &MADC)==AD4CYC)
-//        _Hw_D_OutData((BYTE)(Media.Zone/2)); // Patch
+//        _Hw_D_OutData((u8)(Media.Zone/2)); // Patch
 //
 //    _Hw_D_SetWrData();
 //}
@@ -1028,22 +1028,22 @@ int Ssfdc_D_CheckStatus(void)
 ////----- _Set_D_SsfdcWrBlock() -----------------------------------------
 //void _Set_D_SsfdcWrBlock(void)
 //{
-//    WORD addr;
+//    u16 addr;
 //    SSFDCTYPE_T aa = (SSFDCTYPE_T ) &Ssfdc;
 //    ADDRESS_T   bb = (ADDRESS_T) &Media;
 //
-//    addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-//    addr=addr*(WORD)Ssfdc.MaxSectors;
+//    addr=(u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+//    addr=addr*(u16)Ssfdc.MaxSectors;
 //
 //    //if ((Ssfdc.Attribute &MPS)==PS256) // for 256byte/page
 //    //    addr=addr*2;
 //
 //    _Hw_D_SetWrAddr();
-//    _Hw_D_OutData((BYTE)addr);
-//    _Hw_D_OutData((BYTE)(addr/0x0100));
+//    _Hw_D_OutData((u8)addr);
+//    _Hw_D_OutData((u8)(addr/0x0100));
 //
 //    if ((Ssfdc.Attribute &MADC)==AD4CYC)
-//        _Hw_D_OutData((BYTE)(Media.Zone/2)); // Patch
+//        _Hw_D_OutData((u8)(Media.Zone/2)); // Patch
 //
 //    _Hw_D_SetWrData();
 //}
@@ -1065,7 +1065,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Load_D_SsfdcWrHwECC() -----------------------------------------
-//void _Load_D_SsfdcWrHwECC(BYTE add)
+//void _Load_D_SsfdcWrHwECC(u8 add)
 //{
 //#ifdef HW_ECC_SUPPORTED
 //    _Hw_D_EccWrRead();
@@ -1089,9 +1089,9 @@ int Ssfdc_D_CheckStatus(void)
 //
 ////NAND Memory (SmartMedia) Control Subroutine
 ////----- _Check_D_SsfdcBusy() -------------------------------------------
-//int _Check_D_SsfdcBusy(WORD time)
+//int _Check_D_SsfdcBusy(u16 time)
 //{
-//    WORD  count = 0;
+//    u16  count = 0;
 //
 //    do {
 //        if (!_Hw_D_ChkBusy())
@@ -1116,7 +1116,7 @@ int Ssfdc_D_CheckStatus(void)
 ////----- _Reset_D_SsfdcErr() -----------------------------------------
 //void _Reset_D_SsfdcErr(void)
 //{
-//    WORD  count = 0;
+//    u16  count = 0;
 //
 //    _Hw_D_SetRdCmd();
 //    _Hw_D_OutData(RST_CHIP);
@@ -1134,7 +1134,7 @@ int Ssfdc_D_CheckStatus(void)
 //
 ////NAND Memory (SmartMedia) Buffer Data Xfer Subroutine
 ////----- SM_ReadDataWithDMA() -----------------------------------------
-//void SM_ReadDataWithDMA(PFDO_DEVICE_EXTENSION fdoExt, BYTE *databuf, WORD SectByteCount)
+//void SM_ReadDataWithDMA(PFDO_DEVICE_EXTENSION fdoExt, u8 *databuf, u16 SectByteCount)
 //{
 //    PHYSICAL_ADDRESS        Addr;
 //    LARGE_INTEGER           ptimeout ;
@@ -1143,7 +1143,7 @@ int Ssfdc_D_CheckStatus(void)
 //
 //    Addr = MmGetPhysicalAddress(databuf);
 //
-//    WRITE_PORT_DWORD(SM_DMA_ADDR_REG, (DWORD)Addr.LowPart);
+//    WRITE_PORT_DWORD(SM_DMA_ADDR_REG, (u32)Addr.LowPart);
 //    WRITE_PORT_BYTE(SM_DMA_DATA_CTRL, 0);
 //    WRITE_PORT_WORD(SM_DMA_BYTE_COUNT_REG, SectByteCount);
 //
@@ -1161,7 +1161,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- SM_WriteDataWithDMA() -----------------------------------------
-//void SM_WriteDataWithDMA(PFDO_DEVICE_EXTENSION fdoExt, BYTE *databuf, WORD SectByteCount)
+//void SM_WriteDataWithDMA(PFDO_DEVICE_EXTENSION fdoExt, u8 *databuf, u16 SectByteCount)
 //{
 //    PHYSICAL_ADDRESS        Addr;
 //    LARGE_INTEGER           ptimeout ;
@@ -1170,7 +1170,7 @@ int Ssfdc_D_CheckStatus(void)
 //
 //    Addr = MmGetPhysicalAddress(databuf);
 //
-//    WRITE_PORT_DWORD(SM_DMA_ADDR_REG, (DWORD)Addr.LowPart);
+//    WRITE_PORT_DWORD(SM_DMA_ADDR_REG, (u32)Addr.LowPart);
 //    WRITE_PORT_BYTE(SM_DMA_DATA_CTRL, 2);
 //    WRITE_PORT_WORD(SM_DMA_BYTE_COUNT_REG, SectByteCount);
 //
@@ -1188,7 +1188,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Read_D_SsfdcBuf() -----------------------------------------
-//void _Read_D_SsfdcBuf(BYTE *databuf)
+//void _Read_D_SsfdcBuf(u8 *databuf)
 //{
 //    int i;
 //
@@ -1198,7 +1198,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Write_D_SsfdcBuf() -----------------------------------------
-//void _Write_D_SsfdcBuf(BYTE *databuf)
+//void _Write_D_SsfdcBuf(u8 *databuf)
 //{
 //    int i;
 //
@@ -1208,13 +1208,13 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _Read_D_SsfdcByte() -----------------------------------------
-//void _Read_D_SsfdcByte(BYTE *databuf)
+//void _Read_D_SsfdcByte(u8 *databuf)
 //{
-//    *databuf=(BYTE)_Hw_D_InData();
+//    *databuf=(u8)_Hw_D_InData();
 //}
 //
 ////----- _ReadRedt_D_SsfdcBuf() -----------------------------------------
-//void _ReadRedt_D_SsfdcBuf(BYTE *redundant)
+//void _ReadRedt_D_SsfdcBuf(u8 *redundant)
 //{
 //    char i;
 //
@@ -1224,7 +1224,7 @@ int Ssfdc_D_CheckStatus(void)
 //}
 //
 ////----- _WriteRedt_D_SsfdcBuf() -----------------------------------------
-//void _WriteRedt_D_SsfdcBuf(BYTE *redundant)
+//void _WriteRedt_D_SsfdcBuf(u8 *redundant)
 //{
 //    char i;
 //
@@ -1235,7 +1235,7 @@ int Ssfdc_D_CheckStatus(void)
 */
 //SmartMedia ID Code Check & Mode Set Subroutine
 //----- Set_D_SsfdcModel() ---------------------------------------------
-int Set_D_SsfdcModel(BYTE dcode)
+int Set_D_SsfdcModel(u8 dcode)
 {
     switch (_Check_D_DevCode(dcode)) {
         case SSFDC1MB:
@@ -1343,7 +1343,7 @@ int Set_D_SsfdcModel(BYTE dcode)
 }
 
 //----- _Check_D_DevCode() ---------------------------------------------
-BYTE _Check_D_DevCode(BYTE dcode)
+u8 _Check_D_DevCode(u8 dcode)
 {
     switch(dcode){
         case 0x6E:
@@ -1480,21 +1480,21 @@ BYTE _Check_D_DevCode(BYTE dcode)
 */
 //SmartMedia ECC Controll Subroutine
 //----- Check_D_ReadError() ----------------------------------------------
-int Check_D_ReadError(BYTE *redundant)
+int Check_D_ReadError(u8 *redundant)
 {
 	return SUCCESS;
 }
 
 //----- Check_D_Correct() ----------------------------------------------
-int Check_D_Correct(BYTE *buf,BYTE *redundant)
+int Check_D_Correct(u8 *buf,u8 *redundant)
 {
 	return SUCCESS;
 }
 
 //----- Check_D_CISdata() ----------------------------------------------
-int Check_D_CISdata(BYTE *buf, BYTE *redundant)
+int Check_D_CISdata(u8 *buf, u8 *redundant)
 {
-	BYTE cis[] = {0x01, 0x03, 0xD9, 0x01, 0xFF, 0x18, 0x02,
+	u8 cis[] = {0x01, 0x03, 0xD9, 0x01, 0xFF, 0x18, 0x02,
 		      0xDF, 0x01, 0x20};
 
 	int cis_len = sizeof(cis);
@@ -1519,7 +1519,7 @@ int Check_D_CISdata(BYTE *buf, BYTE *redundant)
 }
 
 //----- Set_D_RightECC() ----------------------------------------------
-void Set_D_RightECC(BYTE *redundant)
+void Set_D_RightECC(u8 *redundant)
 {
     // Driver ¤£°µ ECC Check
     return;
@@ -1528,7 +1528,7 @@ void Set_D_RightECC(BYTE *redundant)
 }
 /*
 ////----- _Calc_D_ECCdata() ----------------------------------------------
-//void _Calc_D_ECCdata(BYTE *buf)
+//void _Calc_D_ECCdata(u8 *buf)
 //{
 //#ifdef HW_ECC_SUPPORTED
 //#else
@@ -1539,7 +1539,7 @@ void Set_D_RightECC(BYTE *redundant)
 //}
 //
 ////----- _Set_D_ECCdata() ----------------------------------------------
-//void _Set_D_ECCdata(BYTE add,BYTE *redundant)
+//void _Set_D_ECCdata(u8 add,u8 *redundant)
 //{
 //    //if (add==EVEN && (Ssfdc.Attribute &MPS)==PS256)
 //    //    return;
@@ -1550,12 +1550,12 @@ void Set_D_RightECC(BYTE *redundant)
 //}
 */
 //Common Subroutine
-char Bit_D_Count(BYTE cdata)
+char Bit_D_Count(u8 cdata)
 {
-    WORD bitcount=0;
+    u16 bitcount=0;
 
     while(cdata) {
-        bitcount+=(WORD)(cdata &0x01);
+        bitcount+=(u16)(cdata &0x01);
         cdata /=2;
     }
 
@@ -1563,9 +1563,9 @@ char Bit_D_Count(BYTE cdata)
 }
 
 //-----
-char Bit_D_CountWord(WORD cdata)
+char Bit_D_CountWord(u16 cdata)
 {
-    WORD bitcount=0;
+    u16 bitcount=0;
 
     while(cdata) {
         bitcount+=(cdata &0x01);
@@ -1577,16 +1577,16 @@ char Bit_D_CountWord(WORD cdata)
 
 /*
 //----- SM_ReadBlock() ---------------------------------------------
-int SM_ReadBlock(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
+int SM_ReadBlock(PFDO_DEVICE_EXTENSION fdoExt, u8 *buf,u8 *redundant)
 {
     PBULK_CBW               pBulkCbw = fdoExt->pBulkCbw;
     NTSTATUS                ntStatus;
-    WORD                    addr;
+    u16                    addr;
 
     ENE_LoadBinCode(fdoExt, SM_RW_PATTERN);
 
-    addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
-    addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;
+    addr = (u16)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
+    addr = addr*(u16)Ssfdc.MaxSectors+Media.Sector;
 
     // Read sect data
     RtlZeroMemory(pBulkCbw, sizeof(struct _BULK_CBW));
@@ -1596,8 +1596,8 @@ int SM_ReadBlock(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
     pBulkCbw->bmCBWFlags             = 0x80;
     pBulkCbw->CBWCb[0]               = 0xF1;
     pBulkCbw->CBWCb[1]               = 0x02;
-    pBulkCbw->CBWCb[4]               = (BYTE)addr;
-    pBulkCbw->CBWCb[3]               = (BYTE)(addr/0x0100);
+    pBulkCbw->CBWCb[4]               = (u8)addr;
+    pBulkCbw->CBWCb[3]               = (u8)(addr/0x0100);
     pBulkCbw->CBWCb[2]               = Media.Zone/2;
 
     ntStatus = ENE_SendScsiCmd(fdoExt, FDIR_READ, buf);
@@ -1613,8 +1613,8 @@ int SM_ReadBlock(PFDO_DEVICE_EXTENSION fdoExt, BYTE *buf,BYTE *redundant)
     pBulkCbw->bmCBWFlags             = 0x80;
     pBulkCbw->CBWCb[0]               = 0xF1;
     pBulkCbw->CBWCb[1]               = 0x03;
-    pBulkCbw->CBWCb[4]               = (BYTE)addr;
-    pBulkCbw->CBWCb[3]               = (BYTE)(addr/0x0100);
+    pBulkCbw->CBWCb[4]               = (u8)addr;
+    pBulkCbw->CBWCb[3]               = (u8)(addr/0x0100);
     pBulkCbw->CBWCb[2]               = Media.Zone/2;
     pBulkCbw->CBWCb[5]               = 0;
     pBulkCbw->CBWCb[6]               = 1;
diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index 6211686..5673a07 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -22,8 +22,8 @@ int SM_SCSI_Write           (struct us_data *us, struct scsi_cmnd *srb);
 
 extern struct SSFDCTYPE     Ssfdc;
 extern struct ADDRESS       Media;
-extern PBYTE                SMHostAddr;
-extern DWORD                ErrXDCode;
+extern u8 *                SMHostAddr;
+extern u32                ErrXDCode;
 
 //----- SM_SCSIIrp() --------------------------------------------------
 int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
@@ -67,7 +67,7 @@ int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
 	//printk("SM_SCSI_Inquiry\n");
-	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
+	u8 data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x55, 0x53, 0x42, 0x32, 0x2E, 0x30, 0x20, 0x20, 0x43, 0x61, 0x72, 0x64, 0x52, 0x65, 0x61, 0x64, 0x65, 0x72, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x31, 0x30, 0x30};
 
 	usb_stor_set_xfer_buf(us, data_ptr, 36, srb, TO_XFER_BUF);
 	return USB_STOR_TRANSPORT_GOOD;
@@ -77,8 +77,8 @@ int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 //----- SM_SCSI_Mode_Sense() --------------------------------------------------
 int SM_SCSI_Mode_Sense(struct us_data *us, struct scsi_cmnd *srb)
 {
-	BYTE	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
-	BYTE	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaNoWP[12] = {0x0b,0x00,0x00,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
+	u8	mediaWP[12]   = {0x0b,0x00,0x80,0x08,0x00,0x00,0x71,0xc0,0x00,0x00,0x02,0x00};
 
 	if (us->SM_Status.WtP)
 		usb_stor_set_xfer_buf(us, mediaWP, 12, srb, TO_XFER_BUF);
@@ -94,9 +94,9 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
-	DWORD   bl_num;
-	WORD    bl_len;
-	BYTE    buf[8];
+	u32   bl_num;
+	u16    bl_len;
+	u8    buf[8];
 
 	printk("SM_SCSI_Read_Capacity\n");
 
@@ -132,11 +132,11 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
 	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32	blenByte = blen * 0x200;
 	void	*buf;
 
 	//printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
@@ -164,11 +164,11 @@ int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
 	//struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int result=0;
-	PBYTE	Cdb = srb->cmnd;
-	DWORD bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
+	u8 *	Cdb = srb->cmnd;
+	u32 bn  =  ((Cdb[2]<<24) & 0xff000000) | ((Cdb[3]<<16) & 0x00ff0000) |
                    ((Cdb[4]<< 8) & 0x0000ff00) | ((Cdb[5]<< 0) & 0x000000ff);
-	WORD  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
-	DWORD	blenByte = blen * 0x200;
+	u16  blen = ((Cdb[7]<< 8) & 0xff00)     | ((Cdb[8]<< 0) & 0x00ff);
+	u32	blenByte = blen * 0x200;
 	void	*buf;
 
 	//printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n", bn, blen, srb->use_sg);
diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 111160c..e47d4d4 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -486,8 +486,8 @@ Handle_Errors:
 //----- BuildSenseBuffer() -------------------------------------------
 void BuildSenseBuffer(struct scsi_cmnd *srb, int SrbStatus)
 {
-    BYTE    *buf = srb->sense_buffer;
-    BYTE    asc;
+    u8    *buf = srb->sense_buffer;
+    u8    asc;
 
     printk("transport --- BuildSenseBuffer\n");
     switch (SrbStatus)
diff --git a/drivers/staging/keucr/transport.h b/drivers/staging/keucr/transport.h
index ae9b5ee..e48c978 100644
--- a/drivers/staging/keucr/transport.h
+++ b/drivers/staging/keucr/transport.h
@@ -96,9 +96,9 @@ extern int ENE_SDInit(struct us_data*);
 extern int ENE_MSInit(struct us_data*);
 extern int ENE_SMInit(struct us_data*);
 extern int ENE_ReadSDReg(struct us_data*, u8*);
-extern int ENE_SendScsiCmd(struct us_data*, BYTE, void*, int);
-extern int ENE_LoadBinCode(struct us_data*, BYTE);
-extern int ENE_Read_BYTE(struct us_data*, WORD index, void *buf);
+extern int ENE_SendScsiCmd(struct us_data*, u8, void*, int);
+extern int ENE_LoadBinCode(struct us_data*, u8);
+extern int ENE_Read_BYTE(struct us_data*, u16 index, void *buf);
 extern int ENE_Read_Data(struct us_data*, void *buf, unsigned int length);
 extern int ENE_Write_Data(struct us_data*, void *buf, unsigned int length);
 extern void BuildSenseBuffer(struct scsi_cmnd *, int);
@@ -113,30 +113,30 @@ extern int 	MS_CardInit(struct us_data *us);
 extern void	MS_LibFreeAllocatedArea(struct us_data *us);
 extern void	MS_LibFreeWriteBuf(struct us_data *us);
 extern int	MS_LibFreeLogicalMap(struct us_data *us);
-extern int	MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk);
-extern int	MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, DWORD *PageBuf, MS_LibTypeExtdat *ExtraDat);
-extern int	MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlockAddr, BYTE PageNum, PBYTE buf, WORD len);
-extern int	MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr);
-extern int	MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData);
+extern int	MS_LibForceSetLogicalPair(struct us_data *us, u16 logblk, u16 phyblk);
+extern int	MS_ReaderReadPage(struct us_data *us, u32 PhyBlockAddr, u8 PageNum, u32 *PageBuf, MS_LibTypeExtdat *ExtraDat);
+extern int	MS_ReaderCopyBlock(struct us_data *us, u16 oldphy, u16 newphy, u16 PhyBlockAddr, u8 PageNum, u8 * buf, u16 len);
+extern int	MS_ReaderEraseBlock(struct us_data *us, u32 PhyBlockAddr);
+extern int	MS_LibProcessBootBlock(struct us_data *us, u16 PhyBlock, u8 *PageData);
 extern int	MS_LibAllocLogicalMap(struct us_data *us);
-extern int	MS_LibSetBootBlockMark(struct us_data *us, WORD phyblk);
-extern int	MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk, WORD mark);
-extern int	MS_LibSetInitialErrorBlock(struct us_data *us, WORD phyblk);
-extern int	MS_LibScanLogicalBlockNumber(struct us_data *us, WORD phyblk);
+extern int	MS_LibSetBootBlockMark(struct us_data *us, u16 phyblk);
+extern int	MS_LibSetLogicalBlockMark(struct us_data *us, u16 phyblk, u16 mark);
+extern int	MS_LibSetInitialErrorBlock(struct us_data *us, u16 phyblk);
+extern int	MS_LibScanLogicalBlockNumber(struct us_data *us, u16 phyblk);
 extern int	MS_LibAllocWriteBuf(struct us_data *us);
 void		MS_LibClearWriteBuf(struct us_data *us);
-void		MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart, WORD *LogEnde);
-extern int	MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibTypeExtdat *ExtraDat);
-extern int	MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE blen, void *buf);
-extern int	MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk);
-extern int	MS_LibErasePhyBlock(struct us_data *us, WORD phyblk);
-extern int	MS_LibErrorPhyBlock(struct us_data *us, WORD phyblk);
-extern int	MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, BYTE OverwriteFlag);
-extern int	MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk);
-extern int	MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock);
-extern int	MS_CountFreeBlock(struct us_data *us, WORD PhyBlock);
-extern int	MS_LibSearchBlockFromLogical(struct us_data *us, WORD logblk);
-extern int	MS_LibSearchBlockFromPhysical(struct us_data *us, WORD phyblk);
+void		MS_LibPhy2LogRange(u16 PhyBlock, u16 *LogStart, u16 *LogEnde);
+extern int	MS_LibReadExtra(struct us_data *us, u32 PhyBlock, u8 PageNum, MS_LibTypeExtdat *ExtraDat);
+extern int	MS_LibReadExtraBlock(struct us_data *us, u32 PhyBlock, u8 PageNum, u8 blen, void *buf);
+extern int	MS_LibSetAcquiredErrorBlock(struct us_data *us, u16 phyblk);
+extern int	MS_LibErasePhyBlock(struct us_data *us, u16 phyblk);
+extern int	MS_LibErrorPhyBlock(struct us_data *us, u16 phyblk);
+extern int	MS_LibOverwriteExtra(struct us_data *us, u32 PhyBlockAddr, u8 PageNum, u8 OverwriteFlag);
+extern int	MS_LibSetLogicalPair(struct us_data *us, u16 logblk, u16 phyblk);
+extern int	MS_LibCheckDisableBlock(struct us_data *us, u16 PhyBlock);
+extern int	MS_CountFreeBlock(struct us_data *us, u16 PhyBlock);
+extern int	MS_LibSearchBlockFromLogical(struct us_data *us, u16 logblk);
+extern int	MS_LibSearchBlockFromPhysical(struct us_data *us, u16 phyblk);
 
 // ENE SM function
 extern int	SM_FreeMem(void);
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index c65b988..7226344 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -57,7 +57,7 @@ int eucr_suspend(struct usb_interface *iface, pm_message_t message)
 
 int eucr_resume(struct usb_interface *iface)
 {
-	BYTE    tmp = 0;
+	u8    tmp = 0;
 
 	struct us_data *us = usb_get_intfdata(iface);
 	printk("--- eucr_resume---\n");
@@ -83,7 +83,7 @@ int eucr_resume(struct usb_interface *iface)
 //EXPORT_SYMBOL_GPL(eucr_resume);
 int eucr_reset_resume(struct usb_interface *iface)
 {
-	BYTE    tmp = 0;
+	u8    tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 
 	printk("--- eucr_reset_resume---\n");
diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
index bbf578a..dd4d7d2 100644
--- a/drivers/staging/keucr/usb.h
+++ b/drivers/staging/keucr/usb.h
@@ -53,34 +53,34 @@ struct us_unusual_dev {
 #define FDIR_READ         1
 
 typedef struct _SD_STATUS {
-    BYTE    Insert:1;
-    BYTE    Ready:1;
-    BYTE    MediaChange:1;
-    BYTE    IsMMC:1;
-    BYTE    HiCapacity:1;
-    BYTE    HiSpeed:1;
-    BYTE    WtP:1;
-    BYTE    Reserved:1;
+    u8    Insert:1;
+    u8    Ready:1;
+    u8    MediaChange:1;
+    u8    IsMMC:1;
+    u8    HiCapacity:1;
+    u8    HiSpeed:1;
+    u8    WtP:1;
+    u8    Reserved:1;
 } SD_STATUS, *PSD_STATUS;
 
 typedef struct _MS_STATUS {
-    BYTE    Insert:1;
-    BYTE    Ready:1;
-    BYTE    MediaChange:1;
-    BYTE    IsMSPro:1;
-    BYTE    IsMSPHG:1;
-    BYTE    Reserved1:1;
-    BYTE    WtP:1;
-    BYTE    Reserved2:1;
+    u8    Insert:1;
+    u8    Ready:1;
+    u8    MediaChange:1;
+    u8    IsMSPro:1;
+    u8    IsMSPHG:1;
+    u8    Reserved1:1;
+    u8    WtP:1;
+    u8    Reserved2:1;
 } MS_STATUS, *PMS_STATUS;
 
 typedef struct _SM_STATUS {
-    BYTE    Insert:1;
-    BYTE    Ready:1;
-    BYTE    MediaChange:1;
-    BYTE    Reserved:3;
-    BYTE    WtP:1;
-    BYTE    IsMS:1;
+    u8    Insert:1;
+    u8    Ready:1;
+    u8    MediaChange:1;
+    u8    Reserved:3;
+    u8    WtP:1;
+    u8    IsMS:1;
 } SM_STATUS, *PSM_STATUS;
 
 // SD Block Length
@@ -184,38 +184,38 @@ struct us_data {
 
 	//----- SD Control Data ----------------
 	//SD_REGISTER SD_Regs;
-	WORD        SD_Block_Mult;
-	BYTE        SD_READ_BL_LEN;
-	WORD        SD_C_SIZE;
-	BYTE        SD_C_SIZE_MULT;
+	u16        SD_Block_Mult;
+	u8        SD_READ_BL_LEN;
+	u16        SD_C_SIZE;
+	u8        SD_C_SIZE_MULT;
 
 	// SD/MMC New spec.
-	BYTE        SD_SPEC_VER;
-	BYTE        SD_CSD_VER;
-	BYTE        SD20_HIGH_CAPACITY;
-	DWORD       HC_C_SIZE;
-	BYTE        MMC_SPEC_VER;
-	BYTE        MMC_BusWidth;
-	BYTE        MMC_HIGH_CAPACITY;
+	u8        SD_SPEC_VER;
+	u8        SD_CSD_VER;
+	u8        SD20_HIGH_CAPACITY;
+	u32       HC_C_SIZE;
+	u8        MMC_SPEC_VER;
+	u8        MMC_BusWidth;
+	u8        MMC_HIGH_CAPACITY;
 	
 	//----- MS Control Data ----------------
-	BOOLEAN             MS_SWWP;
-	DWORD               MSP_TotalBlock;
+	u8             MS_SWWP;
+	u32               MSP_TotalBlock;
 	MS_LibControl       MS_Lib;
-	BOOLEAN             MS_IsRWPage;
-	WORD                MS_Model;
+	u8             MS_IsRWPage;
+	u16                MS_Model;
 
 	//----- SM Control Data ----------------
-	BYTE		SM_DeviceID;
-	BYTE		SM_CardID;
+	u8		SM_DeviceID;
+	u8		SM_CardID;
 
-	PBYTE		testbuf;
-	BYTE		BIN_FLAG;
-	DWORD		bl_num;
+	u8 *		testbuf;
+	u8		BIN_FLAG;
+	u32		bl_num;
 	int		SrbStatus;
 	
 	//------Power Managerment ---------------
-	BOOLEAN         Power_IsResum;	
+	u8         Power_IsResum;	
 };
 
 /* Convert between us_data and the corresponding Scsi_Host */
-- 
1.7.1

