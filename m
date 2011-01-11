Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1AKMoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64793 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab1AKMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:09 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 01/16] crypto: omap-aes: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:38 +0000
Message-Id: <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/omap-aes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 799ca51..24d0f3f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
@@ -830,9 +831,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 	/* Initializing the clock */
 	dd->iclk = clk_get(dev, "ick");
-	if (!dd->iclk) {
+	if (IS_ERR(dd->iclk)) {
 		dev_err(dev, "clock intialization failed.\n");
-		err = -ENODEV;
+		err = PTR_ERR(dd->iclk);
 		goto err_res;
 	}
 
-- 
1.7.3.4

