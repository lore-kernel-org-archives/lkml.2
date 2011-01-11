Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1AKMrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:47:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1AKMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:30 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Vincent Sanders <support@simtec.co.uk>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 05/16] s3c2410fb: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:42 +0000
Message-Id: <1294749833-32019-6-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Vincent Sanders <support@simtec.co.uk>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/video/s3c2410fb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 46b4309..61c819e 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -918,9 +919,9 @@ static int __devinit s3c24xxfb_probe(struct platform_device *pdev,
 	}
 
 	info->clk = clk_get(NULL, "lcd");
-	if (!info->clk || IS_ERR(info->clk)) {
+	if (IS_ERR(info->clk)) {
 		printk(KERN_ERR "failed to get lcd clock source\n");
-		ret = -ENOENT;
+		ret = PTR_ERR(info->clk);
 		goto release_irq;
 	}
 
-- 
1.7.3.4

