Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2G1GKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:10:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab2G1GKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:10:22 -0400
From: Chandrabhanu Mahapatra <cmahapatra@ti.com>
To: <linus.walleij@stericsson.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <leed.aguilar@ti.com>, Chandrabhanu Mahapatra <cmahapatra@ti.com>
Subject: [PATCH V1 1/3] GPIO: PCA953X: Increase size of invert variable to support 24 bit
Date: Sat, 28 Jul 2012 11:37:27 +0530
Message-ID: <a7d63a5023b354c3f0ac8b1aa181b57f03db199c.1343026861.git.cmahapatra@ti.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1343026861.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com> <cover.1343026861.git.cmahapatra@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCA6424 is a low voltage 24 bit I2C and SMBus I/O expander of pca953x family
similar to its 16 bit predecessor TCA6416. It comes with three 8-bit active
Input, Output, Polarity Inversion and Configuration registers each. The polarity
of Input ports can be reversed by setting the appropiate bit in Polarity
Inversion registers.

The variables corresponding to Input, Output and Configuration registers have
already been updated to support 24 bit values. This patch thus updates the
invert variable of PCA953X platform data to support 24 bit.

Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>
---
 drivers/gpio/gpio-pca953x.c |   11 ++++++-----
 include/linux/i2c/pca953x.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 1c313c7..af7024f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -564,7 +564,7 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
  * WARNING: This is DEPRECATED and will be removed eventually!
  */
 static void
-pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
+pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, u32 *invert)
 {
 	struct device_node *node;
 	const __be32 *val;
@@ -592,13 +592,13 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 }
 #else
 static void
-pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
+pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, u32 *invert)
 {
 	*gpio_base = -1;
 }
 #endif
 
-static int __devinit device_pca953x_init(struct pca953x_chip *chip, int invert)
+static int __devinit device_pca953x_init(struct pca953x_chip *chip, u32 invert)
 {
 	int ret;
 
@@ -617,7 +617,7 @@ out:
 	return ret;
 }
 
-static int __devinit device_pca957x_init(struct pca953x_chip *chip, int invert)
+static int __devinit device_pca957x_init(struct pca953x_chip *chip, u32 invert)
 {
 	int ret;
 	u32 val = 0;
@@ -653,8 +653,9 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int irq_base=0, invert=0;
+	int irq_base = 0;
 	int ret;
+	u32 invert = 0;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index 139ba52..3c98dd4 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -11,7 +11,7 @@ struct pca953x_platform_data {
 	unsigned	gpio_base;
 
 	/* initial polarity inversion setting */
-	uint16_t	invert;
+	u32		invert;
 
 	/* interrupt base */
 	int		irq_base;
-- 
1.7.10

