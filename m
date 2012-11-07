Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2KGEvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:51:16 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:18225 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2KGEvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:51:14 -0500
X-Authority-Analysis: v=2.0 cv=KMfY/S5o c=1 sm=0 a=5n8MYtQuEtJVLSjGe4Mkvw==:17 a=XAgHJMm7m9YA:10 a=wom5GMh1gUkA:10 a=F_H1hkrVRygA:10 a=zz6odIEfzeQA:10 a=kj9zAlcOel0A:10 a=7kYe3NcsAAAA:8 a=R-BXuYY-LwQA:10 a=aLX-4j0Fmed6UHGNywYA:9 a=CjuIK1q_8ugA:10 a=-XA83Ip703gA:10 a=5n8MYtQuEtJVLSjGe4Mkvw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 108.176.196.169
Date: Tue, 6 Nov 2012 23:51:05 -0500
From: "Daniel M. Weeks" <dan@danweeks.net>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2] gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m
Message-ID: <20121107045059.GA12752@dev.danweeks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has both SPI and I2C pieces. The appropriate pieces are built based
on whether SPI and/or I2C is/are enabled. However, it was only checking if I2C
was built-in, never if it was built as a module. This patch checks for either
since building both this driver and I2C as modules is possible.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
---
v2: use IS_ENABLED macro

 drivers/gpio/gpio-mcp23s08.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 0f42518..ce1c847 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -77,7 +77,7 @@ struct mcp23s08_driver_data {
 
 /*----------------------------------------------------------------------*/
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 
 static int mcp23008_read(struct mcp23s08 *mcp, unsigned reg)
 {
@@ -399,7 +399,7 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 		break;
 #endif /* CONFIG_SPI_MASTER */
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 	case MCP_TYPE_008:
 		mcp->ops = &mcp23008_ops;
 		mcp->chip.ngpio = 8;
@@ -473,7 +473,7 @@ fail:
 
 /*----------------------------------------------------------------------*/
 
-#ifdef CONFIG_I2C
+#if IS_ENABLED(CONFIG_I2C)
 
 static int __devinit mcp230xx_probe(struct i2c_client *client,
 				    const struct i2c_device_id *id)
-- 
Daniel M. Weeks

