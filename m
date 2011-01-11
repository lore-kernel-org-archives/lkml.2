Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1AKMoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1AKMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:48 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, linux-mmc@vger.kernel.org
Subject: [PATCH 13/16] MMC: jz4740: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:50 +0000
Message-Id: <1294749833-32019-14-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: linux-mmc@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/mmc/host/jz4740_mmc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index b3a0ab0..74218ad 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/mmc/host.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
@@ -827,8 +828,8 @@ static int __devinit jz4740_mmc_probe(struct platform_device* pdev)
 	}
 
 	host->clk = clk_get(&pdev->dev, "mmc");
-	if (!host->clk) {
-		ret = -ENOENT;
+	if (IS_ERR(host->clk)) {
+		ret = PTR_ERR(host->clk);
 		dev_err(&pdev->dev, "Failed to get mmc clock\n");
 		goto err_free_host;
 	}
-- 
1.7.3.4

