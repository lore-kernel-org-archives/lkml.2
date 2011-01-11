Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1AKMpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:45:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40202 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab1AKMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:52 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 15/16] spi: dw_spi: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:52 +0000
Message-Id: <1294749833-32019-16-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: spi-devel-general@lists.sourceforge.net
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/spi/dw_spi_mmio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/dw_spi_mmio.c b/drivers/spi/dw_spi_mmio.c
index db35bd9..2fa012c 100644
--- a/drivers/spi/dw_spi_mmio.c
+++ b/drivers/spi/dw_spi_mmio.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -68,8 +69,8 @@ static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
 	}
 
 	dwsmmio->clk = clk_get(&pdev->dev, NULL);
-	if (!dwsmmio->clk) {
-		ret = -ENODEV;
+	if (IS_ERR(dwsmmio->clk)) {
+		ret = PTR_ERR(dwsmmio->clk);
 		goto err_irq;
 	}
 	clk_enable(dwsmmio->clk);
-- 
1.7.3.4

