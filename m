Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab3AIVsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:48:53 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:46239 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab3AIVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:48:51 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: w.sang@pengutronix.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: i2c-nforce2: fix coding style issues
Date: Wed,  9 Jan 2013 21:50:24 +0100
Message-Id: <1357764624-32134-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avoid these checkpatch.pl issues :
- ERROR: "foo * bar" should be "foo *bar"
- ERROR: switch and case should be at the same indent
- ERROR: "(foo*)" should be "(foo *)"
- ERROR: do not use assignment in if condition
- ERROR: space required before the open parenthesis '('
- WARNING: suspect code indent for conditional statements
- WARNING: quoted string split across lines
- WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/i2c/busses/i2c-nforce2.c |  153 +++++++++++++++++++-------------------
 1 file changed, 76 insertions(+), 77 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 392303b..90357a2 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -60,7 +60,7 @@
 #include <linux/io.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR ("Hans-Frieder Vogt <hfvogt@gmx.net>");
+MODULE_AUTHOR("Hans-Frieder Vogt <hfvogt@gmx.net>");
 MODULE_DESCRIPTION("nForce2/3/4/5xx SMBus driver");
 
 
@@ -188,9 +188,9 @@ static int nforce2_check_status(struct i2c_adapter *adap)
 }
 
 /* Return negative errno on error */
-static s32 nforce2_access(struct i2c_adapter * adap, u16 addr,
+static s32 nforce2_access(struct i2c_adapter *adap, u16 addr,
 		unsigned short flags, char read_write,
-		u8 command, int size, union i2c_smbus_data * data)
+		u8 command, int size, union i2c_smbus_data *data)
 {
 	struct nforce2_smbus *smbus = adap->algo_data;
 	unsigned char protocol, pec;
@@ -202,56 +202,54 @@ static s32 nforce2_access(struct i2c_adapter * adap, u16 addr,
 	pec = (flags & I2C_CLIENT_PEC) ? NVIDIA_SMB_PRTCL_PEC : 0;
 
 	switch (size) {
+	case I2C_SMBUS_QUICK:
+		protocol |= NVIDIA_SMB_PRTCL_QUICK;
+		read_write = I2C_SMBUS_WRITE;
+		break;
 
-		case I2C_SMBUS_QUICK:
-			protocol |= NVIDIA_SMB_PRTCL_QUICK;
-			read_write = I2C_SMBUS_WRITE;
-			break;
-
-		case I2C_SMBUS_BYTE:
-			if (read_write == I2C_SMBUS_WRITE)
-				outb_p(command, NVIDIA_SMB_CMD);
-			protocol |= NVIDIA_SMB_PRTCL_BYTE;
-			break;
-
-		case I2C_SMBUS_BYTE_DATA:
-			outb_p(command, NVIDIA_SMB_CMD);
-			if (read_write == I2C_SMBUS_WRITE)
-				outb_p(data->byte, NVIDIA_SMB_DATA);
-			protocol |= NVIDIA_SMB_PRTCL_BYTE_DATA;
-			break;
-
-		case I2C_SMBUS_WORD_DATA:
+	case I2C_SMBUS_BYTE:
+		if (read_write == I2C_SMBUS_WRITE)
 			outb_p(command, NVIDIA_SMB_CMD);
-			if (read_write == I2C_SMBUS_WRITE) {
-				 outb_p(data->word, NVIDIA_SMB_DATA);
-				 outb_p(data->word >> 8, NVIDIA_SMB_DATA+1);
-			}
-			protocol |= NVIDIA_SMB_PRTCL_WORD_DATA | pec;
-			break;
-
-		case I2C_SMBUS_BLOCK_DATA:
-			outb_p(command, NVIDIA_SMB_CMD);
-			if (read_write == I2C_SMBUS_WRITE) {
-				len = data->block[0];
-				if ((len == 0) || (len > I2C_SMBUS_BLOCK_MAX)) {
-					dev_err(&adap->dev,
-						"Transaction failed "
-						"(requested block size: %d)\n",
-						len);
-					return -EINVAL;
-				}
-				outb_p(len, NVIDIA_SMB_BCNT);
-				for (i = 0; i < I2C_SMBUS_BLOCK_MAX; i++)
-					outb_p(data->block[i + 1],
-					       NVIDIA_SMB_DATA+i);
+		protocol |= NVIDIA_SMB_PRTCL_BYTE;
+		break;
+
+	case I2C_SMBUS_BYTE_DATA:
+		outb_p(command, NVIDIA_SMB_CMD);
+		if (read_write == I2C_SMBUS_WRITE)
+			outb_p(data->byte, NVIDIA_SMB_DATA);
+		protocol |= NVIDIA_SMB_PRTCL_BYTE_DATA;
+		break;
+
+	case I2C_SMBUS_WORD_DATA:
+		outb_p(command, NVIDIA_SMB_CMD);
+		if (read_write == I2C_SMBUS_WRITE) {
+			outb_p(data->word, NVIDIA_SMB_DATA);
+			outb_p(data->word >> 8, NVIDIA_SMB_DATA + 1);
+		}
+		protocol |= NVIDIA_SMB_PRTCL_WORD_DATA | pec;
+		break;
+
+	case I2C_SMBUS_BLOCK_DATA:
+		outb_p(command, NVIDIA_SMB_CMD);
+		if (read_write == I2C_SMBUS_WRITE) {
+			len = data->block[0];
+			if ((len == 0) || (len > I2C_SMBUS_BLOCK_MAX)) {
+				dev_err(&adap->dev,
+					"Transaction failed (requested block size: %d)\n",
+					len);
+				return -EINVAL;
 			}
-			protocol |= NVIDIA_SMB_PRTCL_BLOCK_DATA | pec;
-			break;
+			outb_p(len, NVIDIA_SMB_BCNT);
+			for (i = 0; i < I2C_SMBUS_BLOCK_MAX; i++)
+				outb_p(data->block[i + 1],
+				       NVIDIA_SMB_DATA + i);
+		}
+		protocol |= NVIDIA_SMB_PRTCL_BLOCK_DATA | pec;
+		break;
 
-		default:
-			dev_err(&adap->dev, "Unsupported transaction %d\n", size);
-			return -EOPNOTSUPP;
+	default:
+		dev_err(&adap->dev, "Unsupported transaction %d\n", size);
+		return -EOPNOTSUPP;
 	}
 
 	outb_p((addr & 0x7f) << 1, NVIDIA_SMB_ADDR);
@@ -265,28 +263,27 @@ static s32 nforce2_access(struct i2c_adapter * adap, u16 addr,
 		return 0;
 
 	switch (size) {
-
-		case I2C_SMBUS_BYTE:
-		case I2C_SMBUS_BYTE_DATA:
-			data->byte = inb_p(NVIDIA_SMB_DATA);
-			break;
-
-		case I2C_SMBUS_WORD_DATA:
-			data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA+1) << 8);
-			break;
-
-		case I2C_SMBUS_BLOCK_DATA:
-			len = inb_p(NVIDIA_SMB_BCNT);
-			if ((len <= 0) || (len > I2C_SMBUS_BLOCK_MAX)) {
-				dev_err(&adap->dev, "Transaction failed "
-					"(received block size: 0x%02x)\n",
-					len);
-				return -EPROTO;
-			}
-			for (i = 0; i < len; i++)
-				data->block[i+1] = inb_p(NVIDIA_SMB_DATA + i);
-			data->block[0] = len;
-			break;
+	case I2C_SMBUS_BYTE:
+	case I2C_SMBUS_BYTE_DATA:
+		data->byte = inb_p(NVIDIA_SMB_DATA);
+		break;
+
+	case I2C_SMBUS_WORD_DATA:
+		data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA + 1) << 8);
+		break;
+
+	case I2C_SMBUS_BLOCK_DATA:
+		len = inb_p(NVIDIA_SMB_BCNT);
+		if ((len <= 0) || (len > I2C_SMBUS_BLOCK_MAX)) {
+			dev_err(&adap->dev,
+				"Transaction failed (received block size: 0x%02x)\n",
+				len);
+			return -EPROTO;
+		}
+		for (i = 0; i < len; i++)
+			data->block[i + 1] = inb_p(NVIDIA_SMB_DATA + i);
+		data->block[0] = len;
+		break;
 	}
 
 	return 0;
@@ -299,7 +296,7 @@ static u32 nforce2_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
 	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
 	       I2C_FUNC_SMBUS_PEC |
-	       (((struct nforce2_smbus*)adapter->algo_data)->blockops ?
+	       (((struct nforce2_smbus *)adapter->algo_data)->blockops ?
 		I2C_FUNC_SMBUS_BLOCK_DATA : 0);
 }
 
@@ -327,10 +324,10 @@ static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
 	{ 0 }
 };
 
-MODULE_DEVICE_TABLE (pci, nforce2_ids);
+MODULE_DEVICE_TABLE(pci, nforce2_ids);
 
 
-static int __devinit nforce2_probe_smb (struct pci_dev *dev, int bar,
+static int __devinit nforce2_probe_smb(struct pci_dev *dev, int bar,
 	int alt_reg, struct nforce2_smbus *smbus, const char *name)
 {
 	int error;
@@ -377,7 +374,8 @@ static int __devinit nforce2_probe_smb (struct pci_dev *dev, int bar,
 		release_region(smbus->base, smbus->size);
 		return error;
 	}
-	dev_info(&smbus->adapter.dev, "nForce2 SMBus adapter at %#x\n", smbus->base);
+	dev_info(&smbus->adapter.dev, "nForce2 SMBus adapter at %#x\n",
+		smbus->base);
 	return 0;
 }
 
@@ -388,11 +386,12 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
 	int res1, res2;
 
 	/* we support 2 SMBus adapters */
-	if (!(smbuses = kzalloc(2*sizeof(struct nforce2_smbus), GFP_KERNEL)))
+	smbuses = kzalloc(2 * sizeof(struct nforce2_smbus), GFP_KERNEL);
+	if (!smbuses)
 		return -ENOMEM;
 	pci_set_drvdata(dev, smbuses);
 
-	switch(dev->device) {
+	switch (dev->device) {
 	case PCI_DEVICE_ID_NVIDIA_NFORCE2_SMBUS:
 	case PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS:
 	case PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS:
-- 
1.7.10.4

