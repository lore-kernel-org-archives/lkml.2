Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0DFRmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:42:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35776 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0DFRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:42:27 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Cc: Chaithrika U S <chaithrika@ti.com>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Philby John <pjohn@in.mvista.com>,
       "Srinivasan, Nageswari" <nageswari@ti.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] i2c: davinci: misc. cleanups: remove MOD_REG_BIT and IO_ADDRESS usage
Date: Tue,  6 Apr 2010 10:42:14 -0700
Message-Id: <1270575738-22388-3-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
References: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaithrika U S <chaithrika@ti.com>

Cleanup the DaVinci I2C driver. Remove MOD_REG_BIT macro.
Also use ioremap instead of IO_ADDRESS macro.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   77 +++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 3b9ab23..9327cc9 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-
 #include <mach/i2c.h>
 
 /* ----- global defines ----------------------------------------------- */
@@ -71,37 +70,29 @@
 #define DAVINCI_I2C_IVR_NACK	0x02
 #define DAVINCI_I2C_IVR_AL	0x01
 
-#define DAVINCI_I2C_STR_BB	(1 << 12)
-#define DAVINCI_I2C_STR_RSFULL	(1 << 11)
-#define DAVINCI_I2C_STR_SCD	(1 << 5)
-#define DAVINCI_I2C_STR_ARDY	(1 << 2)
-#define DAVINCI_I2C_STR_NACK	(1 << 1)
-#define DAVINCI_I2C_STR_AL	(1 << 0)
-
-#define DAVINCI_I2C_MDR_NACK	(1 << 15)
-#define DAVINCI_I2C_MDR_STT	(1 << 13)
-#define DAVINCI_I2C_MDR_STP	(1 << 11)
-#define DAVINCI_I2C_MDR_MST	(1 << 10)
-#define DAVINCI_I2C_MDR_TRX	(1 << 9)
-#define DAVINCI_I2C_MDR_XA	(1 << 8)
-#define DAVINCI_I2C_MDR_RM	(1 << 7)
-#define DAVINCI_I2C_MDR_IRS	(1 << 5)
-
-#define DAVINCI_I2C_IMR_AAS	(1 << 6)
-#define DAVINCI_I2C_IMR_SCD	(1 << 5)
-#define DAVINCI_I2C_IMR_XRDY	(1 << 4)
-#define DAVINCI_I2C_IMR_RRDY	(1 << 3)
-#define DAVINCI_I2C_IMR_ARDY	(1 << 2)
-#define DAVINCI_I2C_IMR_NACK	(1 << 1)
-#define DAVINCI_I2C_IMR_AL	(1 << 0)
-
-#define MOD_REG_BIT(val, mask, set) do { \
-	if (set) { \
-		val |= mask; \
-	} else { \
-		val &= ~mask; \
-	} \
-} while (0)
+#define DAVINCI_I2C_STR_BB	BIT(12)
+#define DAVINCI_I2C_STR_RSFULL	BIT(11)
+#define DAVINCI_I2C_STR_SCD	BIT(5)
+#define DAVINCI_I2C_STR_ARDY	BIT(2)
+#define DAVINCI_I2C_STR_NACK	BIT(1)
+#define DAVINCI_I2C_STR_AL	BIT(0)
+
+#define DAVINCI_I2C_MDR_NACK	BIT(15)
+#define DAVINCI_I2C_MDR_STT	BIT(13)
+#define DAVINCI_I2C_MDR_STP	BIT(11)
+#define DAVINCI_I2C_MDR_MST	BIT(10)
+#define DAVINCI_I2C_MDR_TRX	BIT(9)
+#define DAVINCI_I2C_MDR_XA	BIT(8)
+#define DAVINCI_I2C_MDR_RM	BIT(7)
+#define DAVINCI_I2C_MDR_IRS	BIT(5)
+
+#define DAVINCI_I2C_IMR_AAS	BIT(6)
+#define DAVINCI_I2C_IMR_SCD	BIT(5)
+#define DAVINCI_I2C_IMR_XRDY	BIT(4)
+#define DAVINCI_I2C_IMR_RRDY	BIT(3)
+#define DAVINCI_I2C_IMR_ARDY	BIT(2)
+#define DAVINCI_I2C_IMR_NACK	BIT(1)
+#define DAVINCI_I2C_IMR_AL	BIT(0)
 
 struct davinci_i2c_dev {
 	struct device           *dev;
@@ -155,7 +146,7 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 
 	/* put I2C into reset */
 	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	MOD_REG_BIT(w, DAVINCI_I2C_MDR_IRS, 0);
+	w &= ~DAVINCI_I2C_MDR_IRS;
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 
 	/* NOTE: I2C Clock divider programming info
@@ -205,7 +196,7 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 
 	/* Take the I2C module out of reset: */
 	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	MOD_REG_BIT(w, DAVINCI_I2C_MDR_IRS, 1);
+	w |= DAVINCI_I2C_MDR_IRS;
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 
 	/* Enable interrupts */
@@ -287,9 +278,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 	/* Enable receive or transmit interrupts */
 	w = davinci_i2c_read_reg(dev, DAVINCI_I2C_IMR_REG);
 	if (msg->flags & I2C_M_RD)
-		MOD_REG_BIT(w, DAVINCI_I2C_IMR_RRDY, 1);
+		w |= DAVINCI_I2C_IMR_RRDY;
 	else
-		MOD_REG_BIT(w, DAVINCI_I2C_IMR_XRDY, 1);
+		w |= DAVINCI_I2C_IMR_XRDY;
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, w);
 
 	dev->terminate = 0;
@@ -348,7 +339,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 			return msg->len;
 		if (stop) {
 			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-			MOD_REG_BIT(w, DAVINCI_I2C_MDR_STP, 1);
+			w |= DAVINCI_I2C_MDR_STP;
 			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 		}
 		return -EREMOTEIO;
@@ -484,7 +475,7 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 
 				w = davinci_i2c_read_reg(dev,
 							 DAVINCI_I2C_IMR_REG);
-				MOD_REG_BIT(w, DAVINCI_I2C_IMR_XRDY, 0);
+				w &= ~DAVINCI_I2C_IMR_XRDY;
 				davinci_i2c_write_reg(dev,
 						      DAVINCI_I2C_IMR_REG,
 						      w);
@@ -563,7 +554,12 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	}
 	clk_enable(dev->clk);
 
-	dev->base = (void __iomem *)IO_ADDRESS(mem->start);
+	dev->base = ioremap(mem->start, resource_size(mem));
+	if (!dev->base) {
+		r = -EBUSY;
+		goto err_mem_ioremap;
+	}
+
 	i2c_davinci_init(dev);
 
 	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
@@ -593,6 +589,8 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 err_free_irq:
 	free_irq(dev->irq, dev);
 err_unuse_clocks:
+	iounmap(dev->base);
+err_mem_ioremap:
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
@@ -621,6 +619,7 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
 	free_irq(IRQ_I2C, dev);
+	iounmap(dev->base);
 	kfree(dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.0.2

