Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0GLCuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:50:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51048 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab0GLCuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MuBstRbqsimNWXNy11L1RUeCmcZJ0iCBeNXeRcfepgMkJ3C7mPJgZZQIa4wOcptSzP
         uP60Dr9NZovJIdnata0OKk1tKs09rTDXf8VJA0iFx7v/QBvRXvyUQ0R5Hh3Ypn/EvDB5
         GVEbmMGZ8RAqgmdlP+PFvnex0GbL/KYaQubtI=
Message-ID: <4C3A82DF.8080604@gmail.com>
Date: Sun, 11 Jul 2010 21:50:07 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] Mtd: fixed space related issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 5af46680b31132acbd587b953d390317796700de Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 17:26:13 -0500
Subject: [PATCH 3/6] Mtd: fixed space related issues found by the 
checkpatch.pl tool
      Signed-off-by: Neal Buckendahl <nealb001@gmail.com>
---
  drivers/mtd/inftlcore.c |   16 ++++++++--------
  1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index 015a7fe..d318270 100644
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -114,7 +114,7 @@ static void inftl_add_mtd(struct mtd_blktrans_ops 
*tr, struct mtd_info *mtd)
  			"(== 0x%lx sects)\n",
  			inftl->cylinders, inftl->heads , inftl->sectors,
  			(long)inftl->cylinders * (long)inftl->heads *
-			(long)inftl->sectors );
+			(long)inftl->sectors);
  	}

  	if (add_mtd_blktrans_dev(&inftl->mbd)) {
@@ -279,7 +279,7 @@ static u16 INFTL_foldchain(struct INFTLrecord 
*inftl, unsigned thisVUC, unsigned
  	 */
  	silly = MAX_LOOPS;
  	while (thisEUN < inftl->nb_blocks) {
-		for (block = 0; block < inftl->EraseSize/SECTORSIZE; block ++) {
+		for (block = 0; block < inftl->EraseSize/SECTORSIZE; block++) {
  			if ((BlockMap[block] != BLOCK_NIL) ||
  			    BlockDeleted[block])
  				continue;
@@ -291,7 +291,7 @@ static u16 INFTL_foldchain(struct INFTLrecord 
*inftl, unsigned thisVUC, unsigned
  			else
  				status = oob.b.Status | oob.b.Status1;

-			switch(status) {
+			switch (status) {
  			case SECTOR_FREE:
  			case SECTOR_IGNORE:
  				break;
@@ -341,7 +341,7 @@ static u16 INFTL_foldchain(struct INFTLrecord 
*inftl, unsigned thisVUC, unsigned

  		/*
  		 * Copy only in non free block (free blocks can only
-                 * happen in case of media errors or deleted blocks).
+		 * happen in case of media errors or deleted blocks).
  		 */
  		if (BlockMap[block] == BLOCK_NIL)
  			continue;
@@ -476,7 +476,7 @@ static inline u16 INFTL_findwriteunit(struct 
INFTLrecord *inftl, unsigned block)
  {
  	unsigned int thisVUC = block / (inftl->EraseSize / SECTORSIZE);
  	unsigned int thisEUN, writeEUN, prev_block, status;
-	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize -1);
+	unsigned long blockofs = (block * SECTORSIZE) & (inftl->EraseSize - 1);
  	struct mtd_info *mtd = inftl->mbd.mtd;
  	struct inftl_oob oob;
  	struct inftl_bci bci;
@@ -504,7 +504,7 @@ static inline u16 INFTL_findwriteunit(struct 
INFTLrecord *inftl, unsigned block)
  			DEBUG(MTD_DEBUG_LEVEL3, "INFTL: status of block %d in "
  				"EUN %d is %x\n", block , writeEUN, status);

-			switch(status) {
+			switch (status) {
  			case SECTOR_FREE:
  				writeEUN = thisEUN;
  				break;
@@ -677,7 +677,7 @@ static void INFTL_trydeletechain(struct INFTLrecord 
*inftl, unsigned thisVUC)
  			else
  				status = bci.Status | bci.Status1;

-			switch(status) {
+			switch (status) {
  			case SECTOR_FREE:
  			case SECTOR_IGNORE:
  				break;
@@ -943,7 +943,7 @@ static struct mtd_blktrans_ops inftl_tr = {
  	.name		= "inftl",
  	.major		= INFTL_MAJOR,
  	.part_bits	= INFTL_PARTN_BITS,
-	.blksize 	= 512,
+	.blksize	= 512,
  	.getgeo		= inftl_getgeo,
  	.readsect	= inftl_readblock,
  	.writesect	= inftl_writeblock,
-- 
1.7.1


