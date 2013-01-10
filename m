Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3AJMEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:04:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab3AJMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/11] extcon: arizona: Convert to devm_input_allocate_device()
Date: Thu, 10 Jan 2013 12:04:12 +0000
Message-Id: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130110120231.GL20956@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 414aed5..4454d2d 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -418,7 +418,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	arizona_extcon_set_mode(info, 0);
 
-	info->input = input_allocate_device();
+	info->input = devm_input_allocate_device(&pdev->dev);
 	if (!info->input) {
 		dev_err(arizona->dev, "Can't allocate input dev\n");
 		ret = -ENOMEM;
@@ -510,7 +510,6 @@ err_rise_wake:
 err_rise:
 	arizona_free_irq(arizona, ARIZONA_IRQ_JD_RISE, info);
 err_input:
-	input_free_device(info->input);
 err_register:
 	pm_runtime_disable(&pdev->dev);
 	extcon_dev_unregister(&info->edev);
@@ -533,7 +532,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-	input_unregister_device(info->input);
 	extcon_dev_unregister(&info->edev);
 
 	return 0;
-- 
1.7.10.4

