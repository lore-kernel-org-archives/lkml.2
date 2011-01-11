Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1AKMob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1AKMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:28 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 04/16] input: tnetv107x-touchscreen: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:41 +0000
Message-Id: <1294749833-32019-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Cyril Chemparathy <cyril@ti.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/input/touchscreen/tnetv107x-ts.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
index cf1dba2..22a3411 100644
--- a/drivers/input/touchscreen/tnetv107x-ts.c
+++ b/drivers/input/touchscreen/tnetv107x-ts.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
@@ -289,9 +290,9 @@ static int __devinit tsc_probe(struct platform_device *pdev)
 	}
 
 	ts->clk = clk_get(dev, NULL);
-	if (!ts->clk) {
+	if (IS_ERR(ts->clk)) {
 		dev_err(dev, "cannot claim device clock\n");
-		error = -EINVAL;
+		error = PTR_ERR(ts->clk);
 		goto error_clk;
 	}
 
-- 
1.7.3.4

