Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2HZU62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 16:58:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58182 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab2HZU60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 16:58:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Free MICDET IRQ on error during probe
Date: Sun, 26 Aug 2012 13:58:20 -0700
Message-Id: <1346014700-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index fa2114f..13eafcb 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -488,11 +488,13 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 	ret = input_register_device(info->input);
 	if (ret) {
 		dev_err(&pdev->dev, "Can't register input device: %d\n", ret);
-		goto err_fall_wake;
+		goto err_micdet;
 	}
 
 	return 0;
 
+err_micdet:
+	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
 err_fall_wake:
 	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 0);
 err_fall:
-- 
1.7.10.4

