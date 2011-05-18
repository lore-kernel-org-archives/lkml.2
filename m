Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1ERKm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:42:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab1ERKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KEoM6OHnvFS8R5W2FlL/Zq/KS+tCsxbd/PXZ21NJfQpiG+tdF0CgwidxoEMklbURMx
         378LtswjIJSywDok4AVtk/Pth6PFl4ppgfIthdrP4bXtNtmYDePE2cNh2T/evUulCgnj
         QIEQSCBziFb/yDCPbLTtUTiMtwMmWW7g6byMc=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 1/7] staging/keucr: fix keucr ms coding style
Date: Wed, 18 May 2011 18:40:09 +0800
Message-Id: <567d9c942e94cb8bd6248634712c43f5f10814dd.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr ms.c and ms.h coding style

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/ms.c |  693 ++++++++++++++++++++++++-------------------
 drivers/staging/keucr/ms.h |  338 ++++++++++++----------
 2 files changed, 566 insertions(+), 465 deletions(-)

diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index 52fe0a6..087ad73 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -6,13 +6,17 @@
 #include "transport.h"
 #include "ms.h"
 
-//----- MS_ReaderCopyBlock() ------------------------------------------
-int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlockAddr, BYTE PageNum, PBYTE buf, WORD len)
+/*
+ * MS_ReaderCopyBlock()
+ */
+int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy,
+			WORD PhyBlockAddr, BYTE PageNum, PBYTE buf, WORD len)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 
-	//printk("MS_ReaderCopyBlock --- PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum);
+	/* printk(KERN_INFO "MS_ReaderCopyBlock --- PhyBlockAddr = %x,
+				PageNum = %x\n", PhyBlockAddr, PageNum); */
 	result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -40,21 +44,25 @@ int MS_ReaderCopyBlock(struct us_data *us, WORD oldphy, WORD newphy, WORD PhyBlo
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_ReaderReadPage() ------------------------------------------
-int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWORD PageBuf, MS_LibTypeExtdat *ExtraDat)
+/*
+ * MS_ReaderReadPage()
+ */
+int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr,
+		BYTE PageNum, PDWORD PageBuf, MS_LibTypeExtdat *ExtraDat)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	BYTE	ExtBuf[4];
 	DWORD	bn = PhyBlockAddr * 0x20 + PageNum;
 
-	//printk("MS --- MS_ReaderReadPage,  PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum);
+	/* printk(KERN_INFO "MS --- MS_ReaderReadPage,
+		PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum); */
 
 	result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// Read Page Data
+	/* Read Page Data */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = 0x200;
@@ -65,12 +73,12 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 	bcb->CDB[4]			= (BYTE)(bn>>8);
 	bcb->CDB[3]			= (BYTE)(bn>>16);
 	bcb->CDB[2]			= (BYTE)(bn>>24);
-	
+
 	result = ENE_SendScsiCmd(us, FDIR_READ, PageBuf, 0);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	// Read Extra Data
+	/* Read Extra Data */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = 0x4;
@@ -88,9 +96,9 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 		return USB_STOR_TRANSPORT_ERROR;
 
 	ExtraDat->reserved = 0;
-	ExtraDat->intr     = 0x80;  // Not yet, 安砞, 单 fireware support
-	ExtraDat->status0  = 0x10;  // Not yet, 安砞, 单 fireware support
-	ExtraDat->status1  = 0x00;  // Not yet, 安砞, 单 fireware support
+	ExtraDat->intr     = 0x80;  /* Not yet,fireware support */
+	ExtraDat->status0  = 0x10;  /* Not yet,fireware support */
+	ExtraDat->status1  = 0x00;  /* Not yet,fireware support */
 	ExtraDat->ovrflg   = ExtBuf[0];
 	ExtraDat->mngflg   = ExtBuf[1];
 	ExtraDat->logadr   = MemStickLogAddr(ExtBuf[2], ExtBuf[3]);
@@ -98,14 +106,17 @@ int MS_ReaderReadPage(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, PDWO
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_ReaderEraseBlock() ----------------------------------------
+/*
+ * MS_ReaderEraseBlock()
+ */
 int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	DWORD	bn = PhyBlockAddr;
 
-	//printk("MS --- MS_ReaderEraseBlock,  PhyBlockAddr = %x\n", PhyBlockAddr);
+	/* printk(KERN_INFO "MS --- MS_ReaderEraseBlock,
+		PhyBlockAddr = %x\n", PhyBlockAddr); */
 	result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -119,7 +130,7 @@ int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
 	bcb->CDB[4]			= (BYTE)(bn);
 	bcb->CDB[3]			= (BYTE)(bn>>8);
 	bcb->CDB[2]			= (BYTE)(bn>>16);
-	
+
 	result = ENE_SendScsiCmd(us, FDIR_READ, NULL, 0);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -127,23 +138,25 @@ int MS_ReaderEraseBlock(struct us_data *us, DWORD PhyBlockAddr)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_CardInit() ------------------------------------------------
+/*
+ * MS_CardInit()
+ */
 int MS_CardInit(struct us_data *us)
 {
-	DWORD			result=0;
+	DWORD			result = 0;
 	WORD			TmpBlock;
 	PBYTE			PageBuffer0 = NULL, PageBuffer1 = NULL;
 	MS_LibTypeExtdat	extdat;
 	WORD			btBlk1st, btBlk2nd;
 	DWORD			btBlk1stErred;
 
-	printk("MS_CardInit start\n");
+	printk(KERN_INFO "MS_CardInit start\n");
 
 	MS_LibFreeAllocatedArea(us);
 
-	if (((PageBuffer0 = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL)) == NULL) ||
-	    ((PageBuffer1 = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL)) == NULL))
-	{
+	PageBuffer0 = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer1 = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	if ((PageBuffer0 == NULL) || (PageBuffer1 == NULL)) {
 		result = MS_NO_MEMORY_ERROR;
 		goto exit;
 	}
@@ -151,16 +164,16 @@ int MS_CardInit(struct us_data *us)
 	btBlk1st = btBlk2nd = MS_LB_NOT_USED;
 	btBlk1stErred = 0;
 
-	for (TmpBlock=0; TmpBlock < MS_MAX_INITIAL_ERROR_BLOCKS+2; TmpBlock++)
-	{
-		switch (MS_ReaderReadPage(us, TmpBlock, 0, (DWORD *)PageBuffer0, &extdat))
-		{
-			case MS_STATUS_SUCCESS:
+	for (TmpBlock = 0; TmpBlock < MS_MAX_INITIAL_ERROR_BLOCKS+2;
+		TmpBlock++) {
+		switch (MS_ReaderReadPage(us, TmpBlock, 0,
+			(DWORD *)PageBuffer0, &extdat)) {
+		case MS_STATUS_SUCCESS:
 			break;
-			case MS_STATUS_INT_ERROR:
+		case MS_STATUS_INT_ERROR:
 			break;
-			case MS_STATUS_ERROR:
-			default:
+		case MS_STATUS_ERROR:
+		default:
 			continue;
 		}
 
@@ -173,38 +186,37 @@ int MS_CardInit(struct us_data *us)
 			(((MemStickBootBlockPage0 *)PageBuffer0)->header.bNumberOfDataEntry != MS_BOOT_BLOCK_DATA_ENTRIES))
 				continue;
 
-		if (btBlk1st != MS_LB_NOT_USED)
-		{
+		if (btBlk1st != MS_LB_NOT_USED) {
 			btBlk2nd = TmpBlock;
 			break;
 		}
 
 		btBlk1st = TmpBlock;
 		memcpy(PageBuffer1, PageBuffer0, MS_BYTES_PER_PAGE);
-		if (extdat.status1 & (MS_REG_ST1_DTER | MS_REG_ST1_EXER | MS_REG_ST1_FGER))
+		if (extdat.status1 &
+			(MS_REG_ST1_DTER | MS_REG_ST1_EXER | MS_REG_ST1_FGER))
 			btBlk1stErred = 1;
 	}
 
-	if (btBlk1st == MS_LB_NOT_USED)
-	{
+	if (btBlk1st == MS_LB_NOT_USED) {
 		result = MS_STATUS_ERROR;
 		goto exit;
 	}
 
-	// write protect
+	/* write protect */
 	if ((extdat.status0 & MS_REG_ST0_WP) == MS_REG_ST0_WP_ON)
 		MS_LibCtrlSet(us, MS_LIB_CTRL_WRPROTECT);
 
 	result = MS_STATUS_ERROR;
-	// 1st Boot Block
+	/* 1st Boot Block */
 	if (btBlk1stErred == 0)
-		result = MS_LibProcessBootBlock(us, btBlk1st, PageBuffer1);   // 1st
-	// 2nd Boot Block
+		result = MS_LibProcessBootBlock(us, btBlk1st, PageBuffer1);
+		/* 1st */
+	/* 2nd Boot Block */
 	if (result && (btBlk2nd != MS_LB_NOT_USED))
 		result = MS_LibProcessBootBlock(us, btBlk2nd, PageBuffer0);
 
-	if (result)
-	{
+	if (result) {
 		result = MS_STATUS_ERROR;
 		goto exit;
 	}
@@ -214,8 +226,7 @@ int MS_CardInit(struct us_data *us)
 
 	us->MS_Lib.Phy2LogMap[btBlk1st] = MS_LB_BOOT_BLOCK;
 
-	if (btBlk2nd != MS_LB_NOT_USED)
-	{
+	if (btBlk2nd != MS_LB_NOT_USED) {
 		for (TmpBlock = btBlk1st + 1; TmpBlock < btBlk2nd; TmpBlock++)
 			us->MS_Lib.Phy2LogMap[TmpBlock] = MS_LB_INITIAL_ERROR;
 		us->MS_Lib.Phy2LogMap[btBlk2nd] = MS_LB_BOOT_BLOCK;
@@ -225,18 +236,17 @@ int MS_CardInit(struct us_data *us)
 	if (result)
 		goto exit;
 
-	for (TmpBlock=MS_PHYSICAL_BLOCKS_PER_SEGMENT; TmpBlock<us->MS_Lib.NumberOfPhyBlock; TmpBlock+=MS_PHYSICAL_BLOCKS_PER_SEGMENT)
-	{
-		if (MS_CountFreeBlock(us, TmpBlock) == 0)
-		{
+	for (TmpBlock = MS_PHYSICAL_BLOCKS_PER_SEGMENT;
+		TmpBlock < us->MS_Lib.NumberOfPhyBlock;
+		TmpBlock += MS_PHYSICAL_BLOCKS_PER_SEGMENT) {
+		if (MS_CountFreeBlock(us, TmpBlock) == 0) {
 			MS_LibCtrlSet(us, MS_LIB_CTRL_WRPROTECT);
 			break;
 		}
 	}
 
-	// write
-	if (MS_LibAllocWriteBuf(us))
-	{
+	/* write */
+	if (MS_LibAllocWriteBuf(us)) {
 		result = MS_NO_MEMORY_ERROR;
 		goto exit;
 	}
@@ -245,46 +255,48 @@ int MS_CardInit(struct us_data *us)
 
 exit:
 	kfree(PageBuffer1);
-    	kfree(PageBuffer0);
+	kfree(PageBuffer0);
 
-	printk("MS_CardInit end\n");
+	printk(KERN_INFO "MS_CardInit end\n");
 	return result;
 }
 
-//----- MS_LibCheckDisableBlock() ------------------------------------
+/*
+ * MS_LibCheckDisableBlock()
+ */
 int MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock)
 {
-	PWORD			PageBuf=NULL;
-	DWORD			result=MS_STATUS_SUCCESS;
-	DWORD			blk, index=0;
+	PWORD			PageBuf = NULL;
+	DWORD			result = MS_STATUS_SUCCESS;
+	DWORD			blk, index = 0;
 	MS_LibTypeExtdat	extdat;
 
-	if (((PageBuf = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL)) == NULL))
-	{
+	PageBuf = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	if (PageBuf == NULL) {
 		result = MS_NO_MEMORY_ERROR;
 		goto exit;
 	}
 
 	MS_ReaderReadPage(us, PhyBlock, 1, (DWORD *)PageBuf, &extdat);
-	do
-	{
+	do {
 		blk = be16_to_cpu(PageBuf[index]);
 		if (blk == MS_LB_NOT_USED)
 			break;
-		if (blk == us->MS_Lib.Log2PhyMap[0])
-		{
+		if (blk == us->MS_Lib.Log2PhyMap[0]) {
 			result = MS_ERROR_FLASH_READ;
 			break;
 		}
 		index++;
-	} while(1);
+	} while (1);
 
 exit:
 	kfree(PageBuf);
 	return result;
 }
 
-//----- MS_LibFreeAllocatedArea() ------------------------------------
+/*
+ * MS_LibFreeAllocatedArea()
+ */
 void MS_LibFreeAllocatedArea(struct us_data *us)
 {
 	MS_LibFreeWriteBuf(us);
@@ -302,26 +314,31 @@ void MS_LibFreeAllocatedArea(struct us_data *us)
 	us->MS_Lib.NumberOfLogBlock	= 0;
 }
 
-//----- MS_LibFreeWriteBuf() -----------------------------------------
+/*
+ * MS_LibFreeWriteBuf()
+ */
 void MS_LibFreeWriteBuf(struct us_data *us)
 {
-	us->MS_Lib.wrtblk = (WORD)-1; //set to -1
-	MS_LibClearPageMap(us); // memset((fdoExt)->MS_Lib.pagemap, 0, sizeof((fdoExt)->MS_Lib.pagemap))
+	us->MS_Lib.wrtblk = (WORD)-1; /* set to -1 */
 
-	if (us->MS_Lib.blkpag)
-	{
-		kfree((BYTE *)(us->MS_Lib.blkpag));  // Arnold test ...
+	/* memset((fdoExt)->MS_Lib.pagemap, 0,
+			sizeof((fdoExt)->MS_Lib.pagemap)) */
+	MS_LibClearPageMap(us);
+
+	if (us->MS_Lib.blkpag) {
+		kfree((BYTE *)(us->MS_Lib.blkpag));  /* Arnold test ... */
 		us->MS_Lib.blkpag = NULL;
 	}
 
-	if (us->MS_Lib.blkext)
-	{
-		kfree((BYTE *)(us->MS_Lib.blkext));  // Arnold test ...
+	if (us->MS_Lib.blkext) {
+		kfree((BYTE *)(us->MS_Lib.blkext));  /* Arnold test ... */
 		us->MS_Lib.blkext = NULL;
 	}
 }
 
-//----- MS_LibFreeLogicalMap() ---------------------------------------
+/*
+ * MS_LibFreeLogicalMap()
+ */
 int MS_LibFreeLogicalMap(struct us_data *us)
 {
 	kfree(us->MS_Lib.Phy2LogMap);
@@ -330,10 +347,12 @@ int MS_LibFreeLogicalMap(struct us_data *us)
 	kfree(us->MS_Lib.Log2PhyMap);
 	us->MS_Lib.Log2PhyMap = NULL;
 
-    return 0;
+	return 0;
 }
 
-//----- MS_LibProcessBootBlock() -------------------------------------
+/*
+ * MS_LibProcessBootBlock()
+ */
 int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 {
 	MemStickBootBlockSysEnt  *SysEntry;
@@ -343,144 +362,165 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 	BYTE                     *PageBuffer;
 	MS_LibTypeExtdat         ExtraData;
 
-	if ((PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL))==NULL)
+
+	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	if (PageBuffer == NULL)
 		return (DWORD)-1;
 
 	result = (DWORD)-1;
 
-	SysInfo= &(((MemStickBootBlockPage0 *)PageData)->sysinf);
+	SysInfo = &(((MemStickBootBlockPage0 *)PageData)->sysinf);
 
-	if ((SysInfo->bMsClass != MS_SYSINF_MSCLASS_TYPE_1)                                   ||
-		(be16_to_cpu(SysInfo->wPageSize) != MS_SYSINF_PAGE_SIZE)                       ||
+	if ((SysInfo->bMsClass != MS_SYSINF_MSCLASS_TYPE_1) ||
+		(be16_to_cpu(SysInfo->wPageSize) != MS_SYSINF_PAGE_SIZE) ||
 		((SysInfo->bSecuritySupport & MS_SYSINF_SECURITY) == MS_SYSINF_SECURITY_SUPPORT) ||
-		(SysInfo->bReserved1 != MS_SYSINF_RESERVED1)                                     ||
-		(SysInfo->bReserved2 != MS_SYSINF_RESERVED2)                                     ||
-		(SysInfo->bFormatType!= MS_SYSINF_FORMAT_FAT)                                    ||
+		(SysInfo->bReserved1 != MS_SYSINF_RESERVED1) ||
+		(SysInfo->bReserved2 != MS_SYSINF_RESERVED2) ||
+		(SysInfo->bFormatType != MS_SYSINF_FORMAT_FAT) ||
 		(SysInfo->bUsage != MS_SYSINF_USAGE_GENERAL))
 		goto exit;
 
-	switch (us->MS_Lib.cardType = SysInfo->bCardType)
-	{
-		case MS_SYSINF_CARDTYPE_RDONLY:
-			MS_LibCtrlSet(us, MS_LIB_CTRL_RDONLY);
-			break;
-		case MS_SYSINF_CARDTYPE_RDWR:
-			MS_LibCtrlReset(us, MS_LIB_CTRL_RDONLY);
-			break;
-		case MS_SYSINF_CARDTYPE_HYBRID:
-		default:
-			goto exit;
+	switch (us->MS_Lib.cardType = SysInfo->bCardType) {
+	case MS_SYSINF_CARDTYPE_RDONLY:
+		MS_LibCtrlSet(us, MS_LIB_CTRL_RDONLY);
+		break;
+	case MS_SYSINF_CARDTYPE_RDWR:
+		MS_LibCtrlReset(us, MS_LIB_CTRL_RDONLY);
+		break;
+	case MS_SYSINF_CARDTYPE_HYBRID:
+	default:
+		goto exit;
 	}
 
 	us->MS_Lib.blockSize        = be16_to_cpu(SysInfo->wBlockSize);
 	us->MS_Lib.NumberOfPhyBlock = be16_to_cpu(SysInfo->wBlockNumber);
-	us->MS_Lib.NumberOfLogBlock = be16_to_cpu(SysInfo->wTotalBlockNumber) - 2;
-	us->MS_Lib.PagesPerBlock    = us->MS_Lib.blockSize * SIZE_OF_KIRO / MS_BYTES_PER_PAGE;
-	us->MS_Lib.NumberOfSegment  = us->MS_Lib.NumberOfPhyBlock / MS_PHYSICAL_BLOCKS_PER_SEGMENT;
+	us->MS_Lib.NumberOfLogBlock = be16_to_cpu(SysInfo->wTotalBlockNumber)
+									-2;
+	us->MS_Lib.PagesPerBlock    = us->MS_Lib.blockSize * SIZE_OF_KIRO /
+							MS_BYTES_PER_PAGE;
+	us->MS_Lib.NumberOfSegment  = us->MS_Lib.NumberOfPhyBlock /
+					MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 	us->MS_Model                = be16_to_cpu(SysInfo->wMemorySize);
 
-	if (MS_LibAllocLogicalMap(us))			//Allocate to all number of logicalblock and physicalblock
+	/*Allocate to all number of logicalblock and physicalblock */
+	if (MS_LibAllocLogicalMap(us))
 		goto exit;
 
-	MS_LibSetBootBlockMark(us, PhyBlock);		//Mark the book block
+	/* Mark the book block */
+	MS_LibSetBootBlockMark(us, PhyBlock);
 
 	SysEntry = &(((MemStickBootBlockPage0 *)PageData)->sysent);
 
-	for (i=0; i<MS_NUMBER_OF_SYSTEM_ENTRY; i++)
-	{
+	for (i = 0; i < MS_NUMBER_OF_SYSTEM_ENTRY; i++) {
 		DWORD  EntryOffset, EntrySize;
 
-		if ((EntryOffset = be32_to_cpu(SysEntry->entry[i].dwStart)) == 0xffffff)
+		EntryOffset = be32_to_cpu(SysEntry->entry[i].dwStart);
+
+		if (EntryOffset == 0xffffff)
 			continue;
+		EntrySize = be32_to_cpu(SysEntry->entry[i].dwSize);
 
-		if ((EntrySize = be32_to_cpu(SysEntry->entry[i].dwSize)) == 0)
+		if (EntrySize == 0)
 			continue;
 
-		if (EntryOffset + MS_BYTES_PER_PAGE + EntrySize > us->MS_Lib.blockSize * (DWORD)SIZE_OF_KIRO)
+		if (EntryOffset + MS_BYTES_PER_PAGE + EntrySize >
+			us->MS_Lib.blockSize * (DWORD)SIZE_OF_KIRO)
 			continue;
 
-		if (i == 0)
-		{
+		if (i == 0) {
 			BYTE  PrevPageNumber = 0;
 			WORD  phyblk;
 
-			if (SysEntry->entry[i].bType != MS_SYSENT_TYPE_INVALID_BLOCK)
+			if (SysEntry->entry[i].bType !=
+				MS_SYSENT_TYPE_INVALID_BLOCK)
 				goto exit;
 
-			while (EntrySize > 0)
-			{
-				if ((PageNumber = (BYTE)(EntryOffset / MS_BYTES_PER_PAGE + 1)) != PrevPageNumber)
-				{
-					switch (MS_ReaderReadPage(us, PhyBlock, PageNumber, (DWORD *)PageBuffer, &ExtraData))
-					{
-						case MS_STATUS_SUCCESS:
-							break;
-						case MS_STATUS_WRITE_PROTECT:
-						case MS_ERROR_FLASH_READ:
-						case MS_STATUS_ERROR:
-						default:
-							goto exit;
+			while (EntrySize > 0) {
+
+				PageNumber = (BYTE)(EntryOffset /
+							MS_BYTES_PER_PAGE + 1);
+				if (PageNumber != PrevPageNumber) {
+					switch (MS_ReaderReadPage(us, PhyBlock,
+						PageNumber, (DWORD *)PageBuffer,
+						&ExtraData)) {
+					case MS_STATUS_SUCCESS:
+						break;
+					case MS_STATUS_WRITE_PROTECT:
+					case MS_ERROR_FLASH_READ:
+					case MS_STATUS_ERROR:
+					default:
+						goto exit;
 					}
 
 					PrevPageNumber = PageNumber;
 				}
 
-				if ((phyblk = be16_to_cpu(*(WORD *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))) < 0x0fff)
+				phyblk = be16_to_cpu(*(WORD *)(PageBuffer +
+					(EntryOffset % MS_BYTES_PER_PAGE)));
+				if (phyblk < 0x0fff)
 					MS_LibSetInitialErrorBlock(us, phyblk);
 
 				EntryOffset += 2;
 				EntrySize -= 2;
 			}
-		}
-		else if (i == 1)
-		{  // CIS/IDI
+		} else if (i == 1) {  /* CIS/IDI */
 			MemStickBootBlockIDI  *idi;
 
 			if (SysEntry->entry[i].bType != MS_SYSENT_TYPE_CIS_IDI)
 				goto exit;
 
-			switch (MS_ReaderReadPage(us, PhyBlock, (BYTE)(EntryOffset / MS_BYTES_PER_PAGE + 1), (DWORD *)PageBuffer, &ExtraData))
-			{
-				case MS_STATUS_SUCCESS:
-					break;
-				case MS_STATUS_WRITE_PROTECT:
-				case MS_ERROR_FLASH_READ:
-				case MS_STATUS_ERROR:
-				default:
-					goto exit;
+			switch (MS_ReaderReadPage(us, PhyBlock,
+				(BYTE)(EntryOffset / MS_BYTES_PER_PAGE + 1),
+				(DWORD *)PageBuffer, &ExtraData)) {
+			case MS_STATUS_SUCCESS:
+				break;
+			case MS_STATUS_WRITE_PROTECT:
+			case MS_ERROR_FLASH_READ:
+			case MS_STATUS_ERROR:
+			default:
+				goto exit;
 			}
 
-			idi = &((MemStickBootBlockCIS_IDI *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))->idi.idi;
-			if (le16_to_cpu(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
+			idi = &((MemStickBootBlockCIS_IDI *)(PageBuffer +
+				(EntryOffset % MS_BYTES_PER_PAGE)))->idi.idi;
+			if (le16_to_cpu(idi->wIDIgeneralConfiguration) !=
+							MS_IDI_GENERAL_CONF)
 				goto exit;
 
-			us->MS_Lib.BytesPerSector = le16_to_cpu(idi->wIDIbytesPerSector);
+			us->MS_Lib.BytesPerSector =
+				le16_to_cpu(idi->wIDIbytesPerSector);
 			if (us->MS_Lib.BytesPerSector != MS_BYTES_PER_PAGE)
 				goto exit;
 		}
-	} // End for ..
+	} /* End for .. */
 
 	result = 0;
 
 exit:
-	if (result)		MS_LibFreeLogicalMap(us);
+	if (result)
+		MS_LibFreeLogicalMap(us);
+
 	kfree(PageBuffer);
 
 	result = 0;
 	return result;
 }
 
-//----- MS_LibAllocLogicalMap() --------------------------------------
+/*
+ * MS_LibAllocLogicalMap()
+ */
 int MS_LibAllocLogicalMap(struct us_data *us)
 {
 	DWORD  i;
 
 
-	us->MS_Lib.Phy2LogMap = kmalloc(us->MS_Lib.NumberOfPhyBlock * sizeof(WORD), GFP_KERNEL);
-	us->MS_Lib.Log2PhyMap = kmalloc(us->MS_Lib.NumberOfLogBlock * sizeof(WORD), GFP_KERNEL);
+	us->MS_Lib.Phy2LogMap = kmalloc(us->MS_Lib.NumberOfPhyBlock *
+						sizeof(WORD), GFP_KERNEL);
+	us->MS_Lib.Log2PhyMap = kmalloc(us->MS_Lib.NumberOfLogBlock *
+						sizeof(WORD), GFP_KERNEL);
 
-	if ((us->MS_Lib.Phy2LogMap == NULL) || (us->MS_Lib.Log2PhyMap == NULL))
-	{
+	if ((us->MS_Lib.Phy2LogMap == NULL) ||
+		(us->MS_Lib.Log2PhyMap == NULL)) {
 		MS_LibFreeLogicalMap(us);
 		return (DWORD)-1;
 	}
@@ -489,128 +529,142 @@ int MS_LibAllocLogicalMap(struct us_data *us)
 		us->MS_Lib.Phy2LogMap[i] = MS_LB_NOT_USED;
 
 	for (i = 0; i < us->MS_Lib.NumberOfLogBlock; i++)
-	us->MS_Lib.Log2PhyMap[i] = MS_LB_NOT_USED;
+		us->MS_Lib.Log2PhyMap[i] = MS_LB_NOT_USED;
 
 	return 0;
 }
 
-//----- MS_LibSetBootBlockMark() -------------------------------------
+/*
+ * MS_LibSetBootBlockMark()
+ */
 int MS_LibSetBootBlockMark(struct us_data *us, WORD phyblk)
 {
-    return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_BOOT_BLOCK);
+	return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_BOOT_BLOCK);
 }
 
-//----- MS_LibSetLogicalBlockMark() ----------------------------------
+/*
+ * MS_LibSetLogicalBlockMark()
+ */
 int MS_LibSetLogicalBlockMark(struct us_data *us, WORD phyblk, WORD mark)
 {
-    if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
-        return (DWORD)-1;
+	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
+		return (DWORD)-1;
 
-    us->MS_Lib.Phy2LogMap[phyblk] = mark;
+	us->MS_Lib.Phy2LogMap[phyblk] = mark;
 
-    return 0;
+	return 0;
 }
 
-//----- MS_LibSetInitialErrorBlock() ---------------------------------
+/*
+ * MS_LibSetInitialErrorBlock()
+ */
 int MS_LibSetInitialErrorBlock(struct us_data *us, WORD phyblk)
 {
-    return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_INITIAL_ERROR);
+	return MS_LibSetLogicalBlockMark(us, phyblk, MS_LB_INITIAL_ERROR);
 }
 
-//----- MS_LibScanLogicalBlockNumber() -------------------------------
+/*
+ * MS_LibScanLogicalBlockNumber()
+ */
 int MS_LibScanLogicalBlockNumber(struct us_data *us, WORD btBlk1st)
 {
 	WORD			PhyBlock, newblk, i;
 	WORD			LogStart, LogEnde;
 	MS_LibTypeExtdat	extdat;
 	BYTE			buf[0x200];
-	DWORD			count=0, index=0;
+	DWORD			count = 0, index = 0;
 
-	for (PhyBlock = 0; PhyBlock < us->MS_Lib.NumberOfPhyBlock;)
-	{
+	for (PhyBlock = 0; PhyBlock < us->MS_Lib.NumberOfPhyBlock;) {
 		MS_LibPhy2LogRange(PhyBlock, &LogStart, &LogEnde);
 
-		for (i=0; i<MS_PHYSICAL_BLOCKS_PER_SEGMENT; i++, PhyBlock++)
-		{
-			switch (MS_LibConv2Logical(us, PhyBlock))
-			{
-				case MS_STATUS_ERROR:
-					continue;
-				default:
-					break;
+		for (i = 0; i < MS_PHYSICAL_BLOCKS_PER_SEGMENT;
+			i++, PhyBlock++) {
+			switch (MS_LibConv2Logical(us, PhyBlock)) {
+			case MS_STATUS_ERROR:
+				continue;
+			default:
+				break;
 			}
 
-			if (count == PhyBlock)
-			{
-				MS_LibReadExtraBlock(us, PhyBlock, 0, 0x80, &buf);
+			if (count == PhyBlock) {
+				MS_LibReadExtraBlock(us, PhyBlock,
+							0, 0x80, &buf);
 				count += 0x80;
 			}
 			index = (PhyBlock % 0x80) * 4;
 
 			extdat.ovrflg = buf[index];
 			extdat.mngflg = buf[index+1];
-			extdat.logadr = MemStickLogAddr(buf[index+2], buf[index+3]);
+			extdat.logadr = MemStickLogAddr(buf[index+2],
+							buf[index+3]);
 
-			if ((extdat.ovrflg & MS_REG_OVR_BKST) != MS_REG_OVR_BKST_OK)
-			{
+			if ((extdat.ovrflg & MS_REG_OVR_BKST) !=
+				MS_REG_OVR_BKST_OK) {
 				MS_LibSetAcquiredErrorBlock(us, PhyBlock);
 				continue;
 			}
 
-			if ((extdat.mngflg & MS_REG_MNG_ATFLG) == MS_REG_MNG_ATFLG_ATTBL)
-			{
+			if ((extdat.mngflg & MS_REG_MNG_ATFLG) ==
+				MS_REG_MNG_ATFLG_ATTBL) {
 				MS_LibErasePhyBlock(us, PhyBlock);
 				continue;
 			}
 
-			if (extdat.logadr != MS_LB_NOT_USED)
-			{
-				if ((extdat.logadr < LogStart) || (LogEnde <= extdat.logadr))
-				{
+			if (extdat.logadr != MS_LB_NOT_USED) {
+				if ((extdat.logadr < LogStart) ||
+					(LogEnde <= extdat.logadr)) {
 					MS_LibErasePhyBlock(us, PhyBlock);
 					continue;
 				}
 
-				if ((newblk = MS_LibConv2Physical(us, extdat.logadr)) != MS_LB_NOT_USED)
-				{
-					if (extdat.logadr==0)
-					{
-						MS_LibSetLogicalPair(us, extdat.logadr, PhyBlock);
-						if ( MS_LibCheckDisableBlock(us, btBlk1st) )
-						{
-							MS_LibSetLogicalPair(us, extdat.logadr, newblk);
+				newblk = MS_LibConv2Physical(us, extdat.logadr);
+
+				if (newblk != MS_LB_NOT_USED) {
+					if (extdat.logadr == 0) {
+						MS_LibSetLogicalPair(us,
+								extdat.logadr,
+								PhyBlock);
+						if (MS_LibCheckDisableBlock(us,
+							btBlk1st)) {
+							MS_LibSetLogicalPair(us,
+							extdat.logadr, newblk);
 							continue;
 						}
 					}
 
 					MS_LibReadExtra(us, newblk, 0, &extdat);
-					if ((extdat.ovrflg & MS_REG_OVR_UDST) == MS_REG_OVR_UDST_UPDATING)
-					{
-						MS_LibErasePhyBlock(us, PhyBlock);
+					if ((extdat.ovrflg & MS_REG_OVR_UDST) ==
+						MS_REG_OVR_UDST_UPDATING) {
+						MS_LibErasePhyBlock(us,
+								PhyBlock);
 						continue;
-					}
-					else
+					} else {
 						MS_LibErasePhyBlock(us, newblk);
+					}
 				}
 
-				MS_LibSetLogicalPair(us, extdat.logadr, PhyBlock);
+				MS_LibSetLogicalPair(us, extdat.logadr,
+								PhyBlock);
 			}
 		}
-	} //End for ...
+	} /* End for ... */
 
 	return MS_STATUS_SUCCESS;
 }
 
-//----- MS_LibAllocWriteBuf() ----------------------------------------
+/*
+ * MS_LibAllocWriteBuf()
+ */
 int MS_LibAllocWriteBuf(struct us_data *us)
 {
 	us->MS_Lib.wrtblk = (WORD)-1;
 
-	us->MS_Lib.blkpag = kmalloc(us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector, GFP_KERNEL);
-	us->MS_Lib.blkext = kmalloc(us->MS_Lib.PagesPerBlock * sizeof(MS_LibTypeExtdat), GFP_KERNEL);
+	us->MS_Lib.blkpag = kmalloc(us->MS_Lib.PagesPerBlock *
+					us->MS_Lib.BytesPerSector, GFP_KERNEL);
+	us->MS_Lib.blkext = kmalloc(us->MS_Lib.PagesPerBlock *
+					sizeof(MS_LibTypeExtdat), GFP_KERNEL);
 
-	if ((us->MS_Lib.blkpag == NULL) || (us->MS_Lib.blkext == NULL))
-	{
+	if ((us->MS_Lib.blkpag == NULL) || (us->MS_Lib.blkext == NULL)) {
 		MS_LibFreeWriteBuf(us);
 		return (DWORD)-1;
 	}
@@ -620,7 +674,9 @@ int MS_LibAllocWriteBuf(struct us_data *us)
 	return 0;
 }
 
-//----- MS_LibClearWriteBuf() ----------------------------------------
+/*
+ * MS_LibClearWriteBuf()
+ */
 void MS_LibClearWriteBuf(struct us_data *us)
 {
 	int i;
@@ -629,12 +685,11 @@ void MS_LibClearWriteBuf(struct us_data *us)
 	MS_LibClearPageMap(us);
 
 	if (us->MS_Lib.blkpag)
-		memset(us->MS_Lib.blkpag, 0xff, us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector);
+		memset(us->MS_Lib.blkpag, 0xff,
+			us->MS_Lib.PagesPerBlock * us->MS_Lib.BytesPerSector);
 
-	if (us->MS_Lib.blkext)
-	{
-		for (i = 0; i < us->MS_Lib.PagesPerBlock; i++)
-		{
+	if (us->MS_Lib.blkext) {
+		for (i = 0; i < us->MS_Lib.PagesPerBlock; i++) {
 			us->MS_Lib.blkext[i].status1 = MS_REG_ST1_DEFAULT;
 			us->MS_Lib.blkext[i].ovrflg = MS_REG_OVR_DEFAULT;
 			us->MS_Lib.blkext[i].mngflg = MS_REG_MNG_DEFAULT;
@@ -643,32 +698,36 @@ void MS_LibClearWriteBuf(struct us_data *us)
 	}
 }
 
-//----- MS_LibPhy2LogRange() -----------------------------------------
+/*
+ * MS_LibPhy2LogRange()
+ */
 void MS_LibPhy2LogRange(WORD PhyBlock, WORD *LogStart, WORD *LogEnde)
 {
 	PhyBlock /= MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 
-	if (PhyBlock)
-	{
-		*LogStart = MS_LOGICAL_BLOCKS_IN_1ST_SEGMENT + (PhyBlock - 1) * MS_LOGICAL_BLOCKS_PER_SEGMENT;//496
-		*LogEnde = *LogStart + MS_LOGICAL_BLOCKS_PER_SEGMENT;//496
-	}
-	else
-	{
+	if (PhyBlock) {
+		*LogStart = MS_LOGICAL_BLOCKS_IN_1ST_SEGMENT +
+			(PhyBlock - 1) * MS_LOGICAL_BLOCKS_PER_SEGMENT;/*496*/
+		*LogEnde = *LogStart + MS_LOGICAL_BLOCKS_PER_SEGMENT;/*496*/
+	} else {
 		*LogStart = 0;
-		*LogEnde = MS_LOGICAL_BLOCKS_IN_1ST_SEGMENT;//494
+		*LogEnde = MS_LOGICAL_BLOCKS_IN_1ST_SEGMENT;/*494*/
 	}
 }
 
-//----- MS_LibReadExtraBlock() --------------------------------------------
-int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE blen, void *buf)
+/*
+ * MS_LibReadExtraBlock()
+ */
+int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock,
+				BYTE PageNum, BYTE blen, void *buf)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 
-	//printk("MS_LibReadExtraBlock --- PhyBlock = %x, PageNum = %x, blen = %x\n", PhyBlock, PageNum, blen);
+	/* printk("MS_LibReadExtraBlock --- PhyBlock = %x,
+		PageNum = %x, blen = %x\n", PhyBlock, PageNum, blen); */
 
-	// Read Extra Data
+	/* Read Extra Data */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = 0x4 * blen;
@@ -688,14 +747,18 @@ int MS_LibReadExtraBlock(struct us_data *us, DWORD PhyBlock, BYTE PageNum, BYTE
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_LibReadExtra() --------------------------------------------
-int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibTypeExtdat *ExtraDat)
+/*
+ * MS_LibReadExtra()
+ */
+int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock,
+		BYTE PageNum, MS_LibTypeExtdat *ExtraDat)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	BYTE	ExtBuf[4];
 
-	//printk("MS_LibReadExtra --- PhyBlock = %x, PageNum = %x\n", PhyBlock, PageNum);
+	/* printk("MS_LibReadExtra --- PhyBlock = %x, PageNum = %x\n"
+						, PhyBlock, PageNum); */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->DataTransferLength = 0x4;
@@ -707,23 +770,25 @@ int MS_LibReadExtra(struct us_data *us, DWORD PhyBlock, BYTE PageNum, MS_LibType
 	bcb->CDB[3]			= (BYTE)(PhyBlock>>8);
 	bcb->CDB[2]			= (BYTE)(PhyBlock>>16);
 	bcb->CDB[6]			= 0x01;
-	
+
 	result = ENE_SendScsiCmd(us, FDIR_READ, &ExtBuf, 0);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	ExtraDat->reserved = 0;
-	ExtraDat->intr     = 0x80;  // Not yet, waiting for fireware support
-	ExtraDat->status0  = 0x10;  // Not yet, waiting for fireware support
-	ExtraDat->status1  = 0x00;  // Not yet, waiting for fireware support
+	ExtraDat->intr     = 0x80;  /* Not yet, waiting for fireware support */
+	ExtraDat->status0  = 0x10;  /* Not yet, waiting for fireware support */
+	ExtraDat->status1  = 0x00;  /* Not yet, waiting for fireware support */
 	ExtraDat->ovrflg   = ExtBuf[0];
 	ExtraDat->mngflg   = ExtBuf[1];
 	ExtraDat->logadr   = MemStickLogAddr(ExtBuf[2], ExtBuf[3]);
-	
+
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_LibSetAcquiredErrorBlock() --------------------------------
+/*
+ * MS_LibSetAcquiredErrorBlock()
+ */
 int MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk)
 {
 	WORD log;
@@ -731,7 +796,9 @@ int MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk)
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
 		return (DWORD)-1;
 
-	if ((log = us->MS_Lib.Phy2LogMap[phyblk]) < us->MS_Lib.NumberOfLogBlock)
+	log = us->MS_Lib.Phy2LogMap[phyblk];
+
+	if (log  < us->MS_Lib.NumberOfLogBlock)
 		us->MS_Lib.Log2PhyMap[log] = MS_LB_NOT_USED;
 
 	if (us->MS_Lib.Phy2LogMap[phyblk] != MS_LB_INITIAL_ERROR)
@@ -740,7 +807,9 @@ int MS_LibSetAcquiredErrorBlock(struct us_data *us, WORD phyblk)
 	return 0;
 }
 
-//----- MS_LibErasePhyBlock() ----------------------------------------
+/*
+ * MS_LibErasePhyBlock()
+ */
 int MS_LibErasePhyBlock(struct us_data *us, WORD phyblk)
 {
 	WORD  log;
@@ -748,27 +817,27 @@ int MS_LibErasePhyBlock(struct us_data *us, WORD phyblk)
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
 		return MS_STATUS_ERROR;
 
-	if ((log = us->MS_Lib.Phy2LogMap[phyblk]) < us->MS_Lib.NumberOfLogBlock)
+	log = us->MS_Lib.Phy2LogMap[phyblk];
+
+	if (log < us->MS_Lib.NumberOfLogBlock)
 		us->MS_Lib.Log2PhyMap[log] = MS_LB_NOT_USED;
 
 	us->MS_Lib.Phy2LogMap[phyblk] = MS_LB_NOT_USED;
 
-	if (MS_LibIsWritable(us))
-	{
-		switch (MS_ReaderEraseBlock(us, phyblk))
-		{
-			case MS_STATUS_SUCCESS:
-				us->MS_Lib.Phy2LogMap[phyblk] = MS_LB_NOT_USED_ERASED;
-				return MS_STATUS_SUCCESS;
-			case MS_ERROR_FLASH_ERASE:
-			case MS_STATUS_INT_ERROR :
-				MS_LibErrorPhyBlock(us, phyblk);
-				return MS_ERROR_FLASH_ERASE;
-			case MS_STATUS_ERROR:
-			default:
-				MS_LibCtrlSet(us, MS_LIB_CTRL_RDONLY);
-				MS_LibSetAcquiredErrorBlock(us, phyblk);
-				return MS_STATUS_ERROR;
+	if (MS_LibIsWritable(us)) {
+		switch (MS_ReaderEraseBlock(us, phyblk)) {
+		case MS_STATUS_SUCCESS:
+			us->MS_Lib.Phy2LogMap[phyblk] = MS_LB_NOT_USED_ERASED;
+			return MS_STATUS_SUCCESS;
+		case MS_ERROR_FLASH_ERASE:
+		case MS_STATUS_INT_ERROR:
+			MS_LibErrorPhyBlock(us, phyblk);
+			return MS_ERROR_FLASH_ERASE;
+		case MS_STATUS_ERROR:
+		default:
+			MS_LibCtrlSet(us, MS_LIB_CTRL_RDONLY);
+			MS_LibSetAcquiredErrorBlock(us, phyblk);
+			return MS_STATUS_ERROR;
 		}
 	}
 
@@ -777,29 +846,35 @@ int MS_LibErasePhyBlock(struct us_data *us, WORD phyblk)
 	return MS_STATUS_SUCCESS;
 }
 
-//----- MS_LibErrorPhyBlock() ----------------------------------------
+/*
+ * MS_LibErrorPhyBlock()
+ */
 int MS_LibErrorPhyBlock(struct us_data *us, WORD phyblk)
 {
-    if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
-        return MS_STATUS_ERROR;
+	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
+		return MS_STATUS_ERROR;
 
-    MS_LibSetAcquiredErrorBlock(us, phyblk);
+	MS_LibSetAcquiredErrorBlock(us, phyblk);
 
-    if (MS_LibIsWritable(us))
-        return MS_LibOverwriteExtra(us, phyblk, 0,
+	if (MS_LibIsWritable(us))
+		return MS_LibOverwriteExtra(us, phyblk, 0,
 				(BYTE)(~MS_REG_OVR_BKST & BYTE_MASK));
 
 
-    return MS_STATUS_SUCCESS;
+	return MS_STATUS_SUCCESS;
 }
 
-//----- MS_LibOverwriteExtra() ---------------------------------------
-int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, BYTE OverwriteFlag)
+/*
+ * MS_LibOverwriteExtra()
+ */
+int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr,
+				BYTE PageNum, BYTE OverwriteFlag)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 
-	//printk("MS --- MS_LibOverwriteExtra,  PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum);
+	/* printk("MS --- MS_LibOverwriteExtra,  \
+		PhyBlockAddr = %x, PageNum = %x\n", PhyBlockAddr, PageNum); */
 	result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -818,7 +893,7 @@ int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, B
 	bcb->CDB[7]			= 0xFF;
 	bcb->CDB[8]			= 0xFF;
 	bcb->CDB[9]			= 0xFF;
-	
+
 	result = ENE_SendScsiCmd(us, FDIR_READ, NULL, 0);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -826,13 +901,16 @@ int MS_LibOverwriteExtra(struct us_data *us, DWORD PhyBlockAddr, BYTE PageNum, B
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-//----- MS_LibForceSetLogicalPair() ----------------------------------
+/*
+ * MS_LibForceSetLogicalPair()
+ */
 int MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 {
 	if (logblk == MS_LB_NOT_USED)
 		return 0;
 
-	if ((logblk >= us->MS_Lib.NumberOfLogBlock) || (phyblk >= us->MS_Lib.NumberOfPhyBlock))
+	if ((logblk >= us->MS_Lib.NumberOfLogBlock) ||
+		(phyblk >= us->MS_Lib.NumberOfPhyBlock))
 		return (DWORD)-1;
 
 	us->MS_Lib.Phy2LogMap[phyblk] = logblk;
@@ -841,10 +919,13 @@ int MS_LibForceSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 	return 0;
 }
 
-//----- MS_LibSetLogicalPair() ---------------------------------------
+/*
+ * MS_LibSetLogicalPair()
+ */
 int MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 {
-	if ((logblk >= us->MS_Lib.NumberOfLogBlock) || (phyblk >= us->MS_Lib.NumberOfPhyBlock))
+	if ((logblk >= us->MS_Lib.NumberOfLogBlock) ||
+		(phyblk >= us->MS_Lib.NumberOfPhyBlock))
 		return (DWORD)-1;
 
 	us->MS_Lib.Phy2LogMap[phyblk] = logblk;
@@ -853,28 +934,30 @@ int MS_LibSetLogicalPair(struct us_data *us, WORD logblk, WORD phyblk)
 	return 0;
 }
 
-//----- MS_CountFreeBlock() ------------------------------------------
+/*
+ * MS_CountFreeBlock()
+ */
 int MS_CountFreeBlock(struct us_data *us, WORD PhyBlock)
 {
 	DWORD Ende, Count;
 
 	Ende = PhyBlock + MS_PHYSICAL_BLOCKS_PER_SEGMENT;
-	for (Count = 0; PhyBlock < Ende; PhyBlock++)
-	{
-		switch (us->MS_Lib.Phy2LogMap[PhyBlock])
-		{
-			case MS_LB_NOT_USED:
-			case MS_LB_NOT_USED_ERASED:
-				Count++;
-			default:
-				break;
+	for (Count = 0; PhyBlock < Ende; PhyBlock++) {
+		switch (us->MS_Lib.Phy2LogMap[PhyBlock]) {
+		case MS_LB_NOT_USED:
+		case MS_LB_NOT_USED_ERASED:
+			Count++;
+		default:
+			break;
 		}
 	}
 
 	return Count;
 }
 
-//----- MS_LibSearchBlockFromPhysical() ------------------------------
+/*
+ * MS_LibSearchBlockFromPhysical()
+ */
 int MS_LibSearchBlockFromPhysical(struct us_data *us, WORD phyblk)
 {
 	WORD			Newblk;
@@ -884,70 +967,68 @@ int MS_LibSearchBlockFromPhysical(struct us_data *us, WORD phyblk)
 	if (phyblk >= us->MS_Lib.NumberOfPhyBlock)
 		return MS_LB_ERROR;
 
-	for (blk = phyblk + 1; blk != phyblk; blk++)
-	{
+	for (blk = phyblk + 1; blk != phyblk; blk++) {
 		if ((blk & MS_PHYSICAL_BLOCKS_PER_SEGMENT_MASK) == 0)
 			blk -= MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 
 		Newblk = us->MS_Lib.Phy2LogMap[blk];
 		if (us->MS_Lib.Phy2LogMap[blk] == MS_LB_NOT_USED_ERASED)
 			return blk;
-		else if (us->MS_Lib.Phy2LogMap[blk] == MS_LB_NOT_USED)
-		{
-			switch (MS_LibReadExtra(us, blk, 0, &extdat))
-			{
-				case MS_STATUS_SUCCESS :
-				case MS_STATUS_SUCCESS_WITH_ECC:
-					break;
-				case MS_NOCARD_ERROR:
-					return MS_NOCARD_ERROR;
-				case MS_STATUS_INT_ERROR:
-					return MS_LB_ERROR;
-				case MS_ERROR_FLASH_READ:
-				default:
-					MS_LibSetAcquiredErrorBlock(us, blk);     // MS_LibErrorPhyBlock(fdoExt, blk);
-					continue;
-			} // End switch
+		else if (us->MS_Lib.Phy2LogMap[blk] == MS_LB_NOT_USED) {
+			switch (MS_LibReadExtra(us, blk, 0, &extdat)) {
+			case MS_STATUS_SUCCESS:
+			case MS_STATUS_SUCCESS_WITH_ECC:
+				break;
+			case MS_NOCARD_ERROR:
+				return MS_NOCARD_ERROR;
+			case MS_STATUS_INT_ERROR:
+				return MS_LB_ERROR;
+			case MS_ERROR_FLASH_READ:
+			default:
+				MS_LibSetAcquiredErrorBlock(us, blk);
+				/* MS_LibErrorPhyBlock(fdoExt, blk); */
+				continue;
+			} /* End switch */
 
-			if ((extdat.ovrflg & MS_REG_OVR_BKST) != MS_REG_OVR_BKST_OK)
-			{
+			if ((extdat.ovrflg & MS_REG_OVR_BKST) !=
+						MS_REG_OVR_BKST_OK) {
 				MS_LibSetAcquiredErrorBlock(us, blk);
 				continue;
 			}
 
-			switch (MS_LibErasePhyBlock(us, blk))
-			{
-				case MS_STATUS_SUCCESS:
-					return blk;
-				case MS_STATUS_ERROR:
-					return MS_LB_ERROR;
-				case MS_ERROR_FLASH_ERASE:
-				default:
-					MS_LibErrorPhyBlock(us, blk);
-					break;
+			switch (MS_LibErasePhyBlock(us, blk)) {
+			case MS_STATUS_SUCCESS:
+				return blk;
+			case MS_STATUS_ERROR:
+				return MS_LB_ERROR;
+			case MS_ERROR_FLASH_ERASE:
+			default:
+				MS_LibErrorPhyBlock(us, blk);
+				break;
 			}
 		}
-	} // End for
+	} /* End for */
 
 	return MS_LB_ERROR;
 }
 
-//----- MS_LibSearchBlockFromLogical() -------------------------------
+/*
+ * MS_LibSearchBlockFromLogical()
+ */
 int MS_LibSearchBlockFromLogical(struct us_data *us, WORD logblk)
 {
 	WORD phyblk;
 
-	if ((phyblk=MS_LibConv2Physical(us, logblk)) >= MS_LB_ERROR)
-	{
+	phyblk = MS_LibConv2Physical(us, logblk);
+	if (phyblk >= MS_LB_ERROR) {
 		if (logblk >= us->MS_Lib.NumberOfLogBlock)
 			return MS_LB_ERROR;
 
-		phyblk = (logblk + MS_NUMBER_OF_BOOT_BLOCK) / MS_LOGICAL_BLOCKS_PER_SEGMENT;
+		phyblk = (logblk + MS_NUMBER_OF_BOOT_BLOCK) /
+					MS_LOGICAL_BLOCKS_PER_SEGMENT;
 		phyblk *= MS_PHYSICAL_BLOCKS_PER_SEGMENT;
 		phyblk += MS_PHYSICAL_BLOCKS_PER_SEGMENT - 1;
 	}
 
 	return MS_LibSearchBlockFromPhysical(us, phyblk);
 }
-
-
diff --git a/drivers/staging/keucr/ms.h b/drivers/staging/keucr/ms.h
index 4509db7..a3da4be 100644
--- a/drivers/staging/keucr/ms.h
+++ b/drivers/staging/keucr/ms.h
@@ -4,41 +4,41 @@
 #include <linux/blkdev.h>
 #include "common.h"
 
-// MemoryStick Register
-// Status Register 0
-#define MS_REG_ST0_MB                           0x80    // media busy
-#define MS_REG_ST0_FB0                          0x40    // flush busy 0
-#define MS_REG_ST0_BE                           0x20    // buffer empty
-#define MS_REG_ST0_BF                           0x10    // buffer full
-#define MS_REG_ST0_SL                           0x02    // sleep
-#define MS_REG_ST0_WP                           0x01    // write protected
+/* MemoryStick Register */
+/* Status Register 0 */
+#define MS_REG_ST0_MB                           0x80    /* media busy */
+#define MS_REG_ST0_FB0                          0x40    /* flush busy 0 */
+#define MS_REG_ST0_BE                           0x20    /* buffer empty */
+#define MS_REG_ST0_BF                           0x10    /* buffer full */
+#define MS_REG_ST0_SL                           0x02    /* sleep */
+#define MS_REG_ST0_WP                           0x01    /* write protected */
 #define MS_REG_ST0_WP_ON                        MS_REG_ST0_WP
 #define MS_REG_ST0_WP_OFF                       0x00
 
-// Status Register 1
-#define MS_REG_ST1_MB                           0x80    // media busy
-#define MS_REG_ST1_FB1                          0x40    // flush busy 1
-#define MS_REG_ST1_DTER                         0x20    // error on data(corrected)
-#define MS_REG_ST1_UCDT                         0x10    // unable to correct data
-#define MS_REG_ST1_EXER                         0x08    // error on extra(corrected)
-#define MS_REG_ST1_UCEX                         0x04    // unable to correct extra
-#define MS_REG_ST1_FGER                         0x02    // error on overwrite flag(corrected)
-#define MS_REG_ST1_UCFG                         0x01    // unable to correct overwrite flag
-#define MS_REG_ST1_DEFAULT                      (MS_REG_ST1_MB   | MS_REG_ST1_FB1  | \
-                                                 MS_REG_ST1_DTER | MS_REG_ST1_UCDT | \
-                                                 MS_REG_ST1_EXER | MS_REG_ST1_UCEX | \
-                                                 MS_REG_ST1_FGER | MS_REG_ST1_UCFG)
-
-// System Parameter
-#define MS_REG_SYSPAR_BAMD                      0x80                // block address mode
-#define MS_REG_SYSPAR_BAND_LINEAR               MS_REG_SYSPAR_BAMD  //   linear mode
-#define MS_REG_SYSPAR_BAND_CHIP                 0x00                //  chip mode
-#define MS_REG_SYSPAR_ATEN                      0x40                // attribute ROM enable
-#define MS_REG_SYSPAR_ATEN_ENABLE               MS_REG_SYSPAR_ATEN  //  enable
-#define MS_REG_SYSPAR_ATEN_DISABLE              0x00                //  disable
+/* Status Register 1 */
+#define MS_REG_ST1_MB		0x80    /* media busy */
+#define MS_REG_ST1_FB1		0x40    /* flush busy 1 */
+#define MS_REG_ST1_DTER		0x20    /* error on data(corrected) */
+#define MS_REG_ST1_UCDT		0x10    /* unable to correct data */
+#define MS_REG_ST1_EXER		0x08    /* error on extra(corrected) */
+#define MS_REG_ST1_UCEX		0x04    /* unable to correct extra */
+#define MS_REG_ST1_FGER		0x02    /* error on overwrite flag(corrected) */
+#define MS_REG_ST1_UCFG		0x01    /* unable to correct overwrite flag */
+#define MS_REG_ST1_DEFAULT	(MS_REG_ST1_MB   | MS_REG_ST1_FB1  | \
+				MS_REG_ST1_DTER | MS_REG_ST1_UCDT | \
+				MS_REG_ST1_EXER | MS_REG_ST1_UCEX | \
+				MS_REG_ST1_FGER | MS_REG_ST1_UCFG)
+
+/* System Parameter */
+#define MS_REG_SYSPAR_BAMD		0x80	/* block address mode */
+#define MS_REG_SYSPAR_BAND_LINEAR	MS_REG_SYSPAR_BAMD  /*   linear mode */
+#define MS_REG_SYSPAR_BAND_CHIP		0x00	/*  chip mode */
+#define MS_REG_SYSPAR_ATEN		0x40	/* attribute ROM enable */
+#define MS_REG_SYSPAR_ATEN_ENABLE	MS_REG_SYSPAR_ATEN	/*  enable */
+#define MS_REG_SYSPAR_ATEN_DISABLE	0x00	/*  disable */
 #define MS_REG_SYSPAR_RESERVED                  0x2f
 
-// Command Parameter
+/* Command Parameter */
 #define MS_REG_CMDPAR_CP2                       0x80
 #define MS_REG_CMDPAR_CP1                       0x40
 #define MS_REG_CMDPAR_CP0                       0x20
@@ -48,44 +48,44 @@
 #define MS_REG_CMDPAR_OVERWRITE                 MS_REG_CMDPAR_CP2
 #define MS_REG_CMDPAR_RESERVED                  0x1f
 
-// Overwrite Area
-#define MS_REG_OVR_BKST                         0x80            // block status
-#define MS_REG_OVR_BKST_OK                      MS_REG_OVR_BKST     // OK
-#define MS_REG_OVR_BKST_NG                      0x00            // NG
-#define MS_REG_OVR_PGST0                        0x40            // page status
+/* Overwrite Area */
+#define MS_REG_OVR_BKST		0x80            /* block status */
+#define MS_REG_OVR_BKST_OK                      MS_REG_OVR_BKST     /* OK */
+#define MS_REG_OVR_BKST_NG                      0x00            /* NG */
+#define MS_REG_OVR_PGST0	0x40            /* page status */
 #define MS_REG_OVR_PGST1                        0x20
-#define MS_REG_OVR_PGST_MASK                    (MS_REG_OVR_PGST0 | MS_REG_OVR_PGST1)
-#define MS_REG_OVR_PGST_OK                      (MS_REG_OVR_PGST0 | MS_REG_OVR_PGST1) // OK
-#define MS_REG_OVR_PGST_NG                      MS_REG_OVR_PGST1                      // NG
-#define MS_REG_OVR_PGST_DATA_ERROR              0x00        // data error
-#define MS_REG_OVR_UDST                         0x10        // update status
-#define MS_REG_OVR_UDST_UPDATING                0x00        // updating
+#define MS_REG_OVR_PGST_MASK	(MS_REG_OVR_PGST0 | MS_REG_OVR_PGST1)
+#define MS_REG_OVR_PGST_OK	(MS_REG_OVR_PGST0 | MS_REG_OVR_PGST1) /* OK */
+#define MS_REG_OVR_PGST_NG	MS_REG_OVR_PGST1                      /* NG */
+#define MS_REG_OVR_PGST_DATA_ERROR              0x00        /* data error */
+#define MS_REG_OVR_UDST                         0x10        /* update status */
+#define MS_REG_OVR_UDST_UPDATING                0x00        /* updating */
 #define MS_REG_OVR_UDST_NO_UPDATE               MS_REG_OVR_UDST
 #define MS_REG_OVR_RESERVED                     0x08
 #define MS_REG_OVR_DEFAULT                      (MS_REG_OVR_BKST_OK |      \
-                                                 MS_REG_OVR_PGST_OK |      \
-                                                 MS_REG_OVR_UDST_NO_UPDATE |   \
-                                                 MS_REG_OVR_RESERVED)
-// Management Flag
-#define MS_REG_MNG_SCMS0                        0x20    // serial copy management system
+						MS_REG_OVR_PGST_OK |      \
+						MS_REG_OVR_UDST_NO_UPDATE |   \
+						MS_REG_OVR_RESERVED)
+/* Management Flag */
+#define MS_REG_MNG_SCMS0	0x20    /* serial copy management system */
 #define MS_REG_MNG_SCMS1                        0x10
-#define MS_REG_MNG_SCMS_MASK                    (MS_REG_MNG_SCMS0 | MS_REG_MNG_SCMS1)
-#define MS_REG_MNG_SCMS_COPY_OK                 (MS_REG_MNG_SCMS0 | MS_REG_MNG_SCMS1)
+#define MS_REG_MNG_SCMS_MASK		(MS_REG_MNG_SCMS0 | MS_REG_MNG_SCMS1)
+#define MS_REG_MNG_SCMS_COPY_OK		(MS_REG_MNG_SCMS0 | MS_REG_MNG_SCMS1)
 #define MS_REG_MNG_SCMS_ONE_COPY                MS_REG_MNG_SCMS1
 #define MS_REG_MNG_SCMS_NO_COPY                 0x00
-#define MS_REG_MNG_ATFLG                        0x08    // address transfer table flag
-#define MS_REG_MNG_ATFLG_OTHER                  MS_REG_MNG_ATFLG    // other
-#define MS_REG_MNG_ATFLG_ATTBL                  0x00    // address transfer table
-#define MS_REG_MNG_SYSFLG                       0x04    // system flag
-#define MS_REG_MNG_SYSFLG_USER                  MS_REG_MNG_SYSFLG   // user block
-#define MS_REG_MNG_SYSFLG_BOOT                  0x00            // system block
+#define MS_REG_MNG_ATFLG	0x08	/* address transfer table flag */
+#define MS_REG_MNG_ATFLG_OTHER                  MS_REG_MNG_ATFLG    /* other */
+#define MS_REG_MNG_ATFLG_ATTBL		0x00	/* address transfer table */
+#define MS_REG_MNG_SYSFLG                       0x04    /* system flag */
+#define MS_REG_MNG_SYSFLG_USER		MS_REG_MNG_SYSFLG   /* user block */
+#define MS_REG_MNG_SYSFLG_BOOT                  0x00    /* system block */
 #define MS_REG_MNG_RESERVED                     0xc3
 #define MS_REG_MNG_DEFAULT		(MS_REG_MNG_SCMS_COPY_OK |	\
 					 MS_REG_MNG_ATFLG_OTHER |	\
 					 MS_REG_MNG_SYSFLG_USER |	\
 					 MS_REG_MNG_RESERVED)
 
-// Error codes
+/* Error codes */
 #define MS_STATUS_SUCCESS                       0x0000
 #define MS_ERROR_OUT_OF_SPACE                   0x0103
 #define MS_STATUS_WRITE_PROTECT                 0x0106
@@ -110,29 +110,41 @@
 #define MS_LB_ACQUIRED_ERROR                    0xfff4
 #define MS_LB_NOT_USED_ERASED                   0xfff5
 
-#define MS_LibConv2Physical(pdx, LogBlock)      (((LogBlock) >= (pdx)->MS_Lib.NumberOfLogBlock) ? MS_STATUS_ERROR : (pdx)->MS_Lib.Log2PhyMap[LogBlock])
-#define MS_LibConv2Logical(pdx, PhyBlock)       (((PhyBlock) >= (pdx)->MS_Lib.NumberOfPhyBlock) ? MS_STATUS_ERROR : (pdx)->MS_Lib.Phy2LogMap[PhyBlock]) //琩phy->log table
+#define MS_LibConv2Physical(pdx, LogBlock) \
+	(((LogBlock) >= (pdx)->MS_Lib.NumberOfLogBlock) ? \
+	MS_STATUS_ERROR : (pdx)->MS_Lib.Log2PhyMap[LogBlock])
+#define MS_LibConv2Logical(pdx, PhyBlock) \
+	(((PhyBlock) >= (pdx)->MS_Lib.NumberOfPhyBlock) ? \
+	MS_STATUS_ERROR : (pdx)->MS_Lib.Phy2LogMap[PhyBlock])
+	/*dphy->log table */
 
 #define MS_LIB_CTRL_RDONLY                      0
 #define MS_LIB_CTRL_WRPROTECT                   1
-#define MS_LibCtrlCheck(pdx, Flag)              ((pdx)->MS_Lib.flags & (1 << (Flag)))
+#define MS_LibCtrlCheck(pdx, Flag)	((pdx)->MS_Lib.flags & (1 << (Flag)))
 
-#define MS_LibCtrlSet(pdx, Flag)                (pdx)->MS_Lib.flags |= (1 << (Flag))
-#define MS_LibCtrlReset(pdx, Flag)              (pdx)->MS_Lib.flags &= ~(1 << (Flag))
-#define MS_LibIsWritable(pdx)                   ((MS_LibCtrlCheck((pdx), MS_LIB_CTRL_RDONLY) == 0) && (MS_LibCtrlCheck(pdx, MS_LIB_CTRL_WRPROTECT) == 0))
+#define MS_LibCtrlSet(pdx, Flag)	((pdx)->MS_Lib.flags |= (1 << (Flag)))
+#define MS_LibCtrlReset(pdx, Flag)	((pdx)->MS_Lib.flags &= ~(1 << (Flag)))
+#define MS_LibIsWritable(pdx) \
+	((MS_LibCtrlCheck((pdx), MS_LIB_CTRL_RDONLY) == 0) && \
+	(MS_LibCtrlCheck(pdx, MS_LIB_CTRL_WRPROTECT) == 0))
 
 #define MS_MAX_PAGES_PER_BLOCK                  32
 #define MS_LIB_BITS_PER_BYTE                    8
 
-#define MS_LibPageMapIdx(n)                     ((n) / MS_LIB_BITS_PER_BYTE)
-#define MS_LibPageMapBit(n)                     (1 << ((n) % MS_LIB_BITS_PER_BYTE))
-#define MS_LibCheckPageMapBit(pdx, n)           ((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] & MS_LibPageMapBit(n))
-#define MS_LibSetPageMapBit(pdx, n)             ((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] |= MS_LibPageMapBit(n))
-#define MS_LibResetPageMapBit(pdx, n)           ((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] &= ~MS_LibPageMapBit(n))
-#define MS_LibClearPageMap(pdx)                 memset((pdx)->MS_Lib.pagemap, 0, sizeof((pdx)->MS_Lib.pagemap))
+#define MS_LibPageMapIdx(n) ((n) / MS_LIB_BITS_PER_BYTE)
+#define MS_LibPageMapBit(n) (1 << ((n) % MS_LIB_BITS_PER_BYTE))
+#define MS_LibCheckPageMapBit(pdx, n) \
+	((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] & MS_LibPageMapBit(n))
+#define MS_LibSetPageMapBit(pdx, n) \
+	((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] |= MS_LibPageMapBit(n))
+#define MS_LibResetPageMapBit(pdx, n) \
+	((pdx)->MS_Lib.pagemap[MS_LibPageMapIdx(n)] &= ~MS_LibPageMapBit(n))
+#define MS_LibClearPageMap(pdx) \
+	memset((pdx)->MS_Lib.pagemap, 0, sizeof((pdx)->MS_Lib.pagemap))
 
 
-#define MemStickLogAddr(logadr1, logadr0)       ((((WORD)(logadr1)) << 8) | (logadr0))
+#define MemStickLogAddr(logadr1, logadr0) \
+	((((WORD)(logadr1)) << 8) | (logadr0))
 
 #define MS_BYTES_PER_PAGE                       512
 
@@ -144,7 +156,7 @@
 #define MS_NUMBER_OF_SYSTEM_BLOCK               4
 #define MS_LOGICAL_BLOCKS_PER_SEGMENT           496
 #define MS_LOGICAL_BLOCKS_IN_1ST_SEGMENT        494
-#define MS_PHYSICAL_BLOCKS_PER_SEGMENT          0x200   // 512
+#define MS_PHYSICAL_BLOCKS_PER_SEGMENT          0x200   /* 512 */
 #define MS_PHYSICAL_BLOCKS_PER_SEGMENT_MASK     0x1ff
 
 #define MS_SECTOR_SIZE                          512
@@ -165,51 +177,53 @@
 #define MS_SYSINF_SECURITY                      0x01
 #define MS_SYSINF_SECURITY_NO_SUPPORT           MS_SYSINF_SECURITY
 #define MS_SYSINF_SECURITY_SUPPORT              0
-#define MS_SYSINF_FORMAT_MAT                    0   // ?
+#define MS_SYSINF_FORMAT_MAT                    0   /* ? */
 #define MS_SYSINF_FORMAT_FAT                    1
 #define MS_SYSINF_USAGE_GENERAL                 0
-#define MS_SYSINF_PAGE_SIZE                     MS_BYTES_PER_PAGE // fixed
+#define MS_SYSINF_PAGE_SIZE                     MS_BYTES_PER_PAGE /* fixed */
 #define MS_SYSINF_RESERVED1                     1
 #define MS_SYSINF_RESERVED2                     1
 
 #define MS_SYSENT_TYPE_INVALID_BLOCK            0x01
-#define MS_SYSENT_TYPE_CIS_IDI                  0x0a    // CIS/IDI
+#define MS_SYSENT_TYPE_CIS_IDI                  0x0a    /* CIS/IDI */
 
 #define SIZE_OF_KIRO                            1024
 
-// BOOT BLOCK
+/* BOOT BLOCK */
 #define MS_NUMBER_OF_SYSTEM_ENTRY               4
 
-//----- MemStickRegisters --------------------------------------------
-// Status registers (16 bytes)
+/*
+ * MemStickRegisters
+ */
+/* Status registers (16 bytes) */
 typedef struct {
-	BYTE Reserved0;		// 00
-	BYTE INTRegister;	// 01
-	BYTE StatusRegister0;	// 02
-	BYTE StatusRegister1;	// 03
-	BYTE Reserved1[12];	// 04-0F
+	BYTE Reserved0;		/* 00 */
+	BYTE INTRegister;	/* 01 */
+	BYTE StatusRegister0;	/* 02 */
+	BYTE StatusRegister1;	/* 03 */
+	BYTE Reserved1[12];	/* 04-0F */
 } MemStickStatusRegisters;
 
-// Parameter registers (6 bytes)
+/* Parameter registers (6 bytes) */
 typedef struct {
-	BYTE SystemParameter;	// 10
-	BYTE BlockAddress2;	// 11
-	BYTE BlockAddress1;	// 12
-	BYTE BlockAddress0;	// 13
-	BYTE CMDParameter;	// 14
-	BYTE PageAddress;	// 15
+	BYTE SystemParameter;	/* 10 */
+	BYTE BlockAddress2;	/* 11 */
+	BYTE BlockAddress1;	/* 12 */
+	BYTE BlockAddress0;	/* 13 */
+	BYTE CMDParameter;	/* 14 */
+	BYTE PageAddress;	/* 15 */
 } MemStickParameterRegisters;
 
-// Extra registers (9 bytes)
+/* Extra registers (9 bytes) */
 typedef struct {
-	BYTE OverwriteFlag;	// 16
-	BYTE ManagementFlag;	// 17
-	BYTE LogicalAddress1;	// 18
-	BYTE LogicalAddress0;	// 19
-	BYTE ReservedArea[5];	// 1A-1E
+	BYTE OverwriteFlag;	/* 16 */
+	BYTE ManagementFlag;	/* 17 */
+	BYTE LogicalAddress1;	/* 18 */
+	BYTE LogicalAddress0;	/* 19 */
+	BYTE ReservedArea[5];	/* 1A-1E */
 } MemStickExtraDataRegisters;
 
-// All registers in Memory Stick (32 bytes, includes 1 byte padding)
+/* All registers in Memory Stick (32 bytes, includes 1 byte padding) */
 typedef struct {
 	MemStickStatusRegisters status;
 	MemStickParameterRegisters param;
@@ -217,7 +231,9 @@ typedef struct {
 	BYTE padding;
 } MemStickRegisters, *PMemStickRegisters;
 
-//----- MemStickBootBlockPage0 ---------------------------------------
+/*
+ * MemStickBootBlockPage0
+ */
 typedef struct {
 	WORD wBlockID;
 	WORD wFormatVersion;
@@ -238,13 +254,13 @@ typedef struct {
 } MemStickBootBlockSysEnt;
 
 typedef struct {
-	BYTE bMsClass;		// must be 1
-	BYTE bCardType;		// see below
-	WORD wBlockSize;	// n KB
-	WORD wBlockNumber;	// number of physical block
-	WORD wTotalBlockNumber;	// number of logical block
-	WORD wPageSize;		// must be 0x200
-	BYTE bExtraSize;	// 0x10
+	BYTE bMsClass;		/* must be 1 */
+	BYTE bCardType;		/* see below */
+	WORD wBlockSize;	/* n KB */
+	WORD wBlockNumber;	/* number of physical block */
+	WORD wTotalBlockNumber;	/* number of logical block */
+	WORD wPageSize;		/* must be 0x200 */
+	BYTE bExtraSize;	/* 0x10 */
 	BYTE bSecuritySupport;
 	BYTE bAssemblyDate[8];
 	BYTE bFactoryArea[4];
@@ -258,10 +274,10 @@ typedef struct {
 	BYTE bVCC;
 	BYTE bVPP;
 	WORD wControllerChipNumber;
-	WORD wControllerFunction;	// New MS
-	BYTE bReserved3[9];		// New MS
-	BYTE bParallelSupport;		// New MS
-	WORD wFormatValue;		// New MS
+	WORD wControllerFunction;	/* New MS */
+	BYTE bReserved3[9];		/* New MS */
+	BYTE bParallelSupport;		/* New MS */
+	WORD wFormatValue;		/* New MS */
 	BYTE bFormatType;
 	BYTE bUsage;
 	BYTE bDeviceType;
@@ -277,60 +293,62 @@ typedef struct {
 	MemStickBootBlockSysInf sysinf;
 } MemStickBootBlockPage0;
 
-//----- MemStickBootBlockCIS_IDI -------------------------------------
+/*
+ * MemStickBootBlockCIS_IDI
+ */
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
+	BYTE bCistplDEVICE[6];            /* 0 */
+	BYTE bCistplDEVICE0C[6];          /* 6 */
+	BYTE bCistplJEDECC[4];            /* 12 */
+	BYTE bCistplMANFID[6];            /* 16 */
+	BYTE bCistplVER1[32];             /* 22 */
+	BYTE bCistplFUNCID[4];            /* 54 */
+	BYTE bCistplFUNCE0[4];            /* 58 */
+	BYTE bCistplFUNCE1[5];            /* 62 */
+	BYTE bCistplCONF[7];              /* 67 */
+	BYTE bCistplCFTBLENT0[10];        /* 74 */
+	BYTE bCistplCFTBLENT1[8];         /* 84 */
+	BYTE bCistplCFTBLENT2[12];        /* 92 */
+	BYTE bCistplCFTBLENT3[8];         /* 104 */
+	BYTE bCistplCFTBLENT4[17];        /* 112 */
+	BYTE bCistplCFTBLENT5[8];         /* 129 */
+	BYTE bCistplCFTBLENT6[17];        /* 137 */
+	BYTE bCistplCFTBLENT7[8];         /* 154 */
+	BYTE bCistplNOLINK[3];            /* 162 */
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
+	WORD wIDIgeneralConfiguration;     /* 0 */
+	WORD wIDInumberOfCylinder;         /* 1 */
+	WORD wIDIreserved0;                /* 2 */
+	WORD wIDInumberOfHead;             /* 3 */
+	WORD wIDIbytesPerTrack;            /* 4 */
+	WORD wIDIbytesPerSector;           /* 5 */
+	WORD wIDIsectorsPerTrack;          /* 6 */
+	WORD wIDItotalSectors[2];          /* 7-8  high,low */
+	WORD wIDIreserved1[11];            /* 9-19 */
+	WORD wIDIbufferType;               /* 20 */
+	WORD wIDIbufferSize;               /* 21 */
+	WORD wIDIlongCmdECC;               /* 22 */
+	WORD wIDIfirmVersion[4];           /* 23-26 */
+	WORD wIDImodelName[20];            /* 27-46 */
+	WORD wIDIreserved2;                /* 47 */
+	WORD wIDIlongWordSupported;        /* 48 */
+	WORD wIDIdmaSupported;             /* 49 */
+	WORD wIDIreserved3;                /* 50 */
+	WORD wIDIpioTiming;                /* 51 */
+	WORD wIDIdmaTiming;                /* 52 */
+	WORD wIDItransferParameter;        /* 53 */
+	WORD wIDIformattedCylinder;        /* 54 */
+	WORD wIDIformattedHead;            /* 55 */
+	WORD wIDIformattedSectorsPerTrack; /* 56 */
+	WORD wIDIformattedTotalSectors[2]; /* 57-58 */
+	WORD wIDImultiSector;              /* 59 */
+	WORD wIDIlbaSectors[2];            /* 60-61 */
+	WORD wIDIsingleWordDMA;            /* 62 */
+	WORD wIDImultiWordDMA;             /* 63 */
+	WORD wIDIreserved4[192];           /* 64-255 */
 } MemStickBootBlockIDI;
 
 typedef struct {
@@ -346,7 +364,9 @@ typedef struct {
 
 } MemStickBootBlockCIS_IDI;
 
-//----- MS_LibControl ------------------------------------------------
+/*
+ * MS_LibControl
+ */
 typedef struct {
 	BYTE reserved;
 	BYTE intr;
@@ -362,14 +382,14 @@ typedef struct {
 	DWORD BytesPerSector;
 	DWORD NumberOfCylinder;
 	DWORD SectorsPerCylinder;
-	WORD cardType;			// R/W, RO, Hybrid
+	WORD cardType;			/* R/W, RO, Hybrid */
 	WORD blockSize;
 	WORD PagesPerBlock;
 	WORD NumberOfPhyBlock;
 	WORD NumberOfLogBlock;
 	WORD NumberOfSegment;
-	WORD *Phy2LogMap;		// phy2log table
-	WORD *Log2PhyMap;		// log2phy table
+	WORD *Phy2LogMap;		/* phy2log table */
+	WORD *Log2PhyMap;		/* log2phy table */
 	WORD wrtblk;
 	BYTE pagemap[(MS_MAX_PAGES_PER_BLOCK + (MS_LIB_BITS_PER_BYTE-1)) /
 		     MS_LIB_BITS_PER_BYTE];
-- 
1.7.1

