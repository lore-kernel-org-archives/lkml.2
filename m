Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2LRHn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:43:57 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38309 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:43:56 -0500
X-Greylist: delayed 21704 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 02:43:56 EST
Message-ID: <1355816625.32595.0.camel@phoenix>
Subject: [PATCH] clk: max77686: Fix return value checking for devm_kzalloc
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 15:43:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kzalloc returns NULL on failure.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clk/clk-max77686.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index d098f72..8944214 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -132,7 +132,7 @@ static int max77686_clk_register(struct device *dev,
 
 	max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
 					GFP_KERNEL);
-	if (IS_ERR(max77686->lookup))
+	if (!max77686->lookup)
 		return -ENOMEM;
 
 	max77686->lookup->con_id = hw->init->name;
@@ -151,13 +151,13 @@ static int max77686_clk_probe(struct platform_device *pdev)
 
 	max77686_clks = devm_kzalloc(&pdev->dev, sizeof(struct max77686_clk *)
 					* MAX77686_CLKS_NUM, GFP_KERNEL);
-	if (IS_ERR(max77686_clks))
+	if (!max77686_clks)
 		return -ENOMEM;
 
 	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
 		max77686_clks[i] = devm_kzalloc(&pdev->dev,
 					sizeof(struct max77686_clk), GFP_KERNEL);
-		if (IS_ERR(max77686_clks[i]))
+		if (!max77686_clks[i])
 			return -ENOMEM;
 	}
 
-- 
1.7.9.5



