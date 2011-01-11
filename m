Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1AKMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab1AKMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:20 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 02/16] crypto: omap-sham: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:39 +0000
Message-Id: <1294749833-32019-3-git-send-email-jamie@jamieiles.com>
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
 drivers/crypto/omap-sham.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a081c7c..1acfcd2 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1150,9 +1150,9 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 
 	/* Initializing the clock */
 	dd->iclk = clk_get(dev, "ick");
-	if (!dd->iclk) {
+	if (IS_ERR(dd->iclk)) {
 		dev_err(dev, "clock intialization failed.\n");
-		err = -ENODEV;
+		err = PTR_ERR(dd->iclk);
 		goto clk_err;
 	}
 
-- 
1.7.3.4

