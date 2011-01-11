Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1AKMo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1AKMox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:53 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/16] w1: mxc_w1: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:53 +0000
Message-Id: <1294749833-32019-17-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/w1/masters/mxc_w1.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index a3b6a74..67ea082 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -118,8 +119,8 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mdev->clk = clk_get(&pdev->dev, "owire");
-	if (!mdev->clk) {
-		err = -ENODEV;
+	if (IS_ERR(mdev->clk)) {
+		err = PTR_ERR(mdev->clk);
 		goto failed_clk;
 	}
 
-- 
1.7.3.4

