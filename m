Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3AGBDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:03:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60365 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3AGBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:03:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: max77686: Avoid double free at remove time
Date: Mon,  7 Jan 2013 02:05:19 +0100
Message-Id: <1357520719-3782-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_lookup entry is dropped at remove time by a call to
clkdev_drop(). That function frees the entry, which is also freed by the
driver core as it has been allocated through devm_kzalloc(). This
results in a double free.

Use kzalloc() instead of devm_kzalloc() to fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/clk/clk-max77686.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index d098f72..6de05c5 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -130,8 +130,7 @@ static int max77686_clk_register(struct device *dev,
 	if (IS_ERR(clk))
 		return -ENOMEM;
 
-	max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
-					GFP_KERNEL);
+	max77686->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
 	if (IS_ERR(max77686->lookup))
 		return -ENOMEM;
 
-- 
Regards,

Laurent Pinchart

