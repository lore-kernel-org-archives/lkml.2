Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2LRHzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:55:01 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37936 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2LRHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:54:58 -0500
Message-ID: <1355817292.32595.2.camel@phoenix>
Subject: [PATCH] clk: max77686: Remove unnecessary NULL checking for
 container_of()
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 15:54:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

container_of() never returns NULL, thus remove the NULL checking for it.
Also rename get_max77686_clk() to to_max77686_clk() for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/clk/clk-max77686.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index 8944214..3680f66 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -44,48 +44,34 @@ struct max77686_clk {
 	struct clk_lookup *lookup;
 };
 
-static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
+static struct max77686_clk *to_max77686_clk(struct clk_hw *hw)
 {
 	return container_of(hw, struct max77686_clk, hw);
 }
 
 static int max77686_clk_prepare(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
-	int ret;
-
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return -ENOMEM;
-
-	ret = regmap_update_bits(max77686->iodev->regmap,
-		MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 
-	return ret;
+	return regmap_update_bits(max77686->iodev->regmap,
+				  MAX77686_REG_32KHZ, max77686->mask,
+				  max77686->mask);
 }
 
 static void max77686_clk_unprepare(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
-
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return;
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 
 	regmap_update_bits(max77686->iodev->regmap,
-		MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
+			   MAX77686_REG_32KHZ, max77686->mask, 0);
 }
 
 static int max77686_clk_is_enabled(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 	int ret;
 	u32 val;
 
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return -ENOMEM;
-
 	ret = regmap_read(max77686->iodev->regmap,
 				MAX77686_REG_32KHZ, &val);
 
-- 
1.7.9.5



