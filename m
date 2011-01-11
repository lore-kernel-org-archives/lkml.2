Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1AKMoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab1AKMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:36 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Wan ZongShun <mcuos.com@gmail.com>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 06/16] nuc900fb: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:43 +0000
Message-Id: <1294749833-32019-7-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/video/nuc900fb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 81687ed..62498bd 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -15,6 +15,7 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -597,9 +598,9 @@ static int __devinit nuc900fb_probe(struct platform_device *pdev)
 	}
 
 	fbi->clk = clk_get(&pdev->dev, NULL);
-	if (!fbi->clk || IS_ERR(fbi->clk)) {
+	if (IS_ERR(fbi->clk)) {
 		printk(KERN_ERR "nuc900-lcd:failed to get lcd clock source\n");
-		ret = -ENOENT;
+		ret = PTR_ERR(fbi->clk);
 		goto release_irq;
 	}
 
-- 
1.7.3.4

