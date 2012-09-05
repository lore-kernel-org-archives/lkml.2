Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab2IEWBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:01:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36372 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab2IEWBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:01:36 -0400
From: Fabio Estevam <festevam@gmail.com>
To: zbr@ioremap.net
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/3] w1: mxc_w1: Adapt the clock name to the new clock framework
Date: Wed,  5 Sep 2012 19:01:18 -0300
Message-Id: <1346882480-18254-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

With the new i.mx clock framework the mxc_w1 clock is registered as:

clk_register_clkdev(clk[owire_gate], NULL, "mxc_w1.0"

So we do not need to pass "owire" string and can use NULL instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/w1/masters/mxc_w1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1cc61a7..14f0f66 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -117,7 +117,7 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->clk = clk_get(&pdev->dev, "owire");
+	mdev->clk = clk_get(&pdev->dev, NULL);
 	if (!mdev->clk) {
 		err = -ENODEV;
 		goto failed_clk;
-- 
1.7.9.5

