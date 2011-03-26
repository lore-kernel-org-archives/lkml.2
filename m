Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1CZQQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:16:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1CZQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QVMlFObuZ78jOpuKQo6T21PGiYimi3mz2guIbJxUiudBigmxOFvuGkVn/7d6ECXFol
         ZkKieM/Xehdg4CdAeSQxnE51g1zdXSsPkY4WDKsMCJw5ae+ukK3WmeoHp+HduxsABmfH
         3edNXHDMnl+mVMc/O/qNZ1A+wTPtNluJfd+Jw=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH 3/4] staging: keucr: smscsi: Removed commented declarations and statements.
Date: Sat, 26 Mar 2011 17:16:19 +0100
Message-Id: <1301156180-12192-3-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed commented declarations and statements.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/keucr/smscsi.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index 20386ce..f857be7 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -48,7 +48,6 @@ int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
 
 int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 {
-	/* printk("SM_SCSI_Test_Unit_Ready\n"); */
 	if (us->SM_Status.Insert && us->SM_Status.Ready) {
 		return USB_STOR_TRANSPORT_GOOD;
 	} else {
@@ -61,7 +60,6 @@ int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 
 int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
 {
-	/* printk("SM_SCSI_Inquiry\n"); */
 	BYTE data_ptr[36] = {0x00, 0x80, 0x02, 0x00, 0x1F, 0x00,
 				0x00, 0x00, 0x55, 0x53, 0x42, 0x32,
 				0x2E, 0x30, 0x20, 0x20, 0x43, 0x61,
@@ -102,13 +100,6 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	bl_len = 0x200;
 	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
 
-	/*
-	 * printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
-	 * printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
-	 * printk("MaxZones     = %x\n", Ssfdc.MaxZones);
-	 * printk("bl_num       = %x\n", bl_num);
-	 */
-
 	us->bl_num = bl_num;
 	printk(KERN_DEBUG, "bl_len = %x\n", bl_len);
 	printk(KERN_DEBUG, "bl_num = %x\n", bl_num);
@@ -123,17 +114,12 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	buf[7] = (bl_len >> 0) & 0xff;
 
 	usb_stor_access_xfer_buf(us, buf, 8, srb, &sg, &offset, TO_XFER_BUF);
-	/*
-	 * usb_stor_set_xfer_buf(us, buf, srb->request_bufflen,
-	 *			srb, TO_XFER_BUF);
-	 */
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
 int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 {
-	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
 	int result = 0;
 	PBYTE Cdb = srb->cmnd;
 	DWORD bn =
@@ -143,11 +129,6 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 	DWORD blenByte = blen * 0x200;
 	void *buf;
 
-	/*
-	 * printk("SCSIOP_READ --- bn = %X, blen = %X, srb->use_sg = %X\n",
-	 *				bn, blen, srb->use_sg);
-	 */
-
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -168,7 +149,6 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 
 int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 {
-	/* struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf; */
 	int result = 0;
 	PBYTE Cdb = srb->cmnd;
 	DWORD bn =
@@ -178,11 +158,6 @@ int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 	DWORD blenByte = blen * 0x200;
 	void *buf;
 
-	/*
-	 * printk("SCSIOP_Write --- bn = %X, blen = %X, srb->use_sg = %X\n",
-	 *				bn, blen, srb->use_sg);
-	 */
-
 	if (bn > us->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-- 
1.7.4.1

