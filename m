Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0LCPH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:07:26 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:37688 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965Ab0LCPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:07:22 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 20/20] i2c/nomadik: some checkpatch warnings
Date: Fri, 3 Dec 2010 20:35:53 +0530
Message-ID: <1291388753-14662-21-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/i2c/busses/i2c-nomadik.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index baa8ff7..3ead1b6 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -62,11 +62,11 @@
 /* Master controller (MCR) register */
 #define I2C_MCR_OP		(0x1 << 0)	/* Operation */
 #define I2C_MCR_A7		(0x7f << 1)	/* 7-bit address */
-#define I2C_MCR_EA10		(0x7 << 8) 	/* 10-bit Extended address */
+#define I2C_MCR_EA10		(0x7 << 8)	/* 10-bit Extended address */
 #define I2C_MCR_SB		(0x1 << 11)	/* Extended address */
 #define I2C_MCR_AM		(0x3 << 12)	/* Address type */
-#define I2C_MCR_STOP		(0x1 << 14) 	/* Stop condition */
-#define I2C_MCR_LENGTH		(0x7ff << 15) 	/* Transaction length */
+#define I2C_MCR_STOP		(0x1 << 14)	/* Stop condition */
+#define I2C_MCR_LENGTH		(0x7ff << 15)	/* Transaction length */
 
 /* Status register (SR) */
 #define I2C_SR_OP		(0x3 << 0)	/* Operation */
@@ -76,7 +76,7 @@
 #define I2C_SR_LENGTH		(0x7ff << 9)	/* Transfer length */
 
 /* Interrupt mask set/clear (IMSCR) bits */
-#define I2C_IT_TXFE 		(0x1 << 0)
+#define I2C_IT_TXFE		(0x1 << 0)
 #define I2C_IT_TXFNE		(0x1 << 1)
 #define I2C_IT_TXFF		(0x1 << 2)
 #define I2C_IT_TXFOVR		(0x1 << 3)
@@ -154,15 +154,15 @@ struct i2c_nmk_client {
  */
 struct nmk_i2c_dev {
 	struct platform_device		*pdev;
-	struct i2c_adapter 		adap;
-	int 				irq;
+	struct i2c_adapter		adap;
+	int				irq;
 	void __iomem			*virtbase;
 	struct clk			*clk;
 	struct nmk_i2c_controller	cfg;
 	struct i2c_nmk_client		cli;
-	int 				stop;
+	int				stop;
 	struct completion		xfer_complete;
-	int 				result;
+	int				result;
 };
 
 /* controller's abort causes */
@@ -275,7 +275,7 @@ static int init_hw(struct nmk_i2c_dev *dev)
 }
 
 /* enable peripheral, master mode operation */
-#define DEFAULT_I2C_REG_CR 	((1 << 1) | I2C_CR_PE)
+#define DEFAULT_I2C_REG_CR	((1 << 1) | I2C_CR_PE)
 
 /**
  * load_i2c_mcr_reg() - load the MCR register
@@ -519,13 +519,13 @@ static int write_i2c(struct nmk_i2c_dev *dev)
  *
  * NOTE:
  * READ TRANSFER : We impose a restriction of the first message to be the
- * 		index message for any read transaction.
- * 		- a no index is coded as '0',
- * 		- 2byte big endian index is coded as '3'
- * 		!!! msg[0].buf holds the actual index.
- * 		This is compatible with generic messages of smbus emulator
- * 		that send a one byte index.
- * 		eg. a I2C transation to read 2 bytes from index 0
+ *		index message for any read transaction.
+ *		- a no index is coded as '0',
+ *		- 2byte big endian index is coded as '3'
+ *		!!! msg[0].buf holds the actual index.
+ *		This is compatible with generic messages of smbus emulator
+ *		that send a one byte index.
+ *		eg. a I2C transation to read 2 bytes from index 0
  *			idx = 0;
  *			msg[0].addr = client->addr;
  *			msg[0].flags = 0x0;
@@ -841,7 +841,7 @@ static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 	}
 
 	if (request_mem_region(res->start, resource_size(res),
-		DRIVER_NAME "I/O region") == 	NULL)	{
+		DRIVER_NAME "I/O region") ==	NULL)	{
 		ret = -EBUSY;
 		goto err_no_region;
 	}
-- 
1.7.2.dirty

