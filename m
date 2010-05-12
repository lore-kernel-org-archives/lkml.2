Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0ELVTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:19:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53065 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0ELVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XJ7kJdyE7IvlDrdpoFQ+PdFO646FxsSqhuZRJ6QHrgvQd0QcaunUIO8OxC85cfdsEP
         HhlmsFX5NCE6QmmDvtFgN0mJRNXhSQmYg0BmBZD0GRRNk09FMUzeawrDcLUNac0O+VNy
         hTnA9a8ym/luTHY1qbA7DY9bPucmDjGAbULhg=
From: Farid Hammane <farid.hammane@gmail.com>
To: khali@linux-fr.org
Cc: ben-linux@fluff.org, seth.heasley@intel.com, nm127@freemail.hu,
       felixru@gmail.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Farid Hammane <farid.hammane@gmail.com>
Subject: [PATCH] i2c-i801: fix all coding style issues found by checkpatch.pl
Date: Wed, 12 May 2010 23:16:48 +0200
Message-Id: <1273699009-915-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up all coding style issues found by the checkpatch.pl tool.
After applying this patch the binary object is still exactly the same.

Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
---
 drivers/i2c/busses/i2c-i801.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 299b918..76a010a 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -22,8 +22,8 @@
 /*
   Supports the following Intel I/O Controller Hubs (ICH):
 
-                                  I/O                     Block   I2C
-                                  region  SMBus   Block   proc.   block
+				  I/O                     Block   I2C
+				  region  SMBus   Block   proc.   block
   Chip name             PCI ID    size    PEC     buffer  call    read
   ----------------------------------------------------------------------
   82801AA  (ICH)        0x2413     16      no      no      no      no
@@ -341,8 +341,7 @@ static int i801_block_transaction_byte_by_byte(union i2c_smbus_data *data,
 		do {
 			msleep(1);
 			status = inb_p(SMBHSTSTS);
-		}
-		while ((!(status & SMBHSTSTS_BYTE_DONE))
+		} while ((!(status & SMBHSTSTS_BYTE_DONE))
 		       && (timeout++ < MAX_TIMEOUT));
 
 		result = i801_check_post(status, timeout > MAX_TIMEOUT);
@@ -440,9 +439,9 @@ static int i801_block_transaction(union i2c_smbus_data *data, char read_write,
 }
 
 /* Return negative errno on error. */
-static s32 i801_access(struct i2c_adapter * adap, u16 addr,
+static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 		       unsigned short flags, char read_write, u8 command,
-		       int size, union i2c_smbus_data * data)
+		       int size, union i2c_smbus_data *data)
 {
 	int hwpec;
 	int block = 0;
@@ -511,7 +510,7 @@ static s32 i801_access(struct i2c_adapter * adap, u16 addr,
 	else
 		outb_p(inb_p(SMBAUXCTL) & (~SMBAUXCTL_CRC), SMBAUXCTL);
 
-	if(block)
+	if (block)
 		ret = i801_block_transaction(data, read_write, size, hwpec);
 	else
 		ret = i801_transaction(xact | ENABLE_INT9);
@@ -523,9 +522,9 @@ static s32 i801_access(struct i2c_adapter * adap, u16 addr,
 		outb_p(inb_p(SMBAUXCTL) & ~(SMBAUXCTL_CRC | SMBAUXCTL_E32B),
 		       SMBAUXCTL);
 
-	if(block)
+	if (block)
 		return ret;
-	if(ret)
+	if (ret)
 		return ret;
 	if ((read_write == I2C_SMBUS_WRITE) || (xact == I801_QUICK))
 		return 0;
@@ -585,7 +584,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ 0, }
 };
 
-MODULE_DEVICE_TABLE (pci, i801_ids);
+MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_INPUT_APANEL || defined CONFIG_INPUT_APANEL_MODULE
 static unsigned char apanel_addr;
@@ -689,7 +688,8 @@ static void __devinit dmi_check_onboard_devices(const struct dmi_header *dm,
 }
 #endif
 
-static int __devinit i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
+static int __devinit i801_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
 {
 	unsigned char temp;
 	int err;
-- 
1.7.0

