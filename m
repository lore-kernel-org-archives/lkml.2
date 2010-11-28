Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0K1QHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 11:07:05 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53543 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0K1QHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 11:07:02 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: aaro.koskinen@iki.fi
Subject: [PATCH] i2c-iop3xx: add iomem annotation
Date: Sun, 28 Nov 2010 18:07:00 +0200
Message-Id: <1290960420-7484-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate unnecessary casts and the following sparse warnings:

	drivers/i2c/busses/i2c-iop3xx.c:65:9: warning: incorrect type in argument 1 (different base types)
	drivers/i2c/busses/i2c-iop3xx.c:65:9:    expected void const volatile [noderef] <asn:2>*<noident>
	drivers/i2c/busses/i2c-iop3xx.c:65:9:    got unsigned int

	[ the previous warning is repeated 18 times ]

	drivers/i2c/busses/i2c-iop3xx.c:456:33: warning: cast removes address space of expression

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/i2c/busses/i2c-iop3xx.c |    6 +++---
 drivers/i2c/busses/i2c-iop3xx.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 112c61f..f09c931 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -409,7 +409,7 @@ iop3xx_i2c_remove(struct platform_device *pdev)
 		IOP3XX_ICR_RXFULL_IE | IOP3XX_ICR_TXEMPTY_IE);
 	__raw_writel(cr, adapter_data->ioaddr + CR_OFFSET);
 
-	iounmap((void __iomem*)adapter_data->ioaddr);
+	iounmap(adapter_data->ioaddr);
 	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
 	kfree(adapter_data);
 	kfree(padapter);
@@ -453,7 +453,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	/* set the adapter enumeration # */
 	adapter_data->id = i2c_id++;
 
-	adapter_data->ioaddr = (u32)ioremap(res->start, IOP3XX_I2C_IO_SIZE);
+	adapter_data->ioaddr = ioremap(res->start, IOP3XX_I2C_IO_SIZE);
 	if (!adapter_data->ioaddr) {
 		ret = -ENOMEM;
 		goto release_region;
@@ -498,7 +498,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 unmap:
-	iounmap((void __iomem*)adapter_data->ioaddr);
+	iounmap(adapter_data->ioaddr);
 
 release_region:
 	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
diff --git a/drivers/i2c/busses/i2c-iop3xx.h b/drivers/i2c/busses/i2c-iop3xx.h
index 8485861..a63b9f1 100644
--- a/drivers/i2c/busses/i2c-iop3xx.h
+++ b/drivers/i2c/busses/i2c-iop3xx.h
@@ -97,7 +97,7 @@
 #define	IOP3XX_I2C_IO_SIZE	0x18
 
 struct i2c_algo_iop3xx_data {
-	u32 ioaddr;
+	char __iomem *ioaddr;
 	wait_queue_head_t waitq;
 	spinlock_t lock;
 	u32 SR_enabled, SR_received;
-- 
1.5.6.5

