Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3AHIjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:39:36 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61890 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3AHIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:39:35 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
Date: Tue,  8 Jan 2013 14:01:22 +0530
Message-Id: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_regulator_bulk_get is device managed and saves some cleanup
and exit code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested against linux-next tree (20130108).
---
 drivers/mfd/wm8994-core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 57c488d..803e93f 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -467,7 +467,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		goto err;
 	}
 		
-	ret = regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
+	ret = devm_regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
 				 wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
@@ -478,7 +478,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 				    wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
-		goto err_get;
+		goto err;
 	}
 
 	ret = wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET);
@@ -658,8 +658,6 @@ err_irq:
 err_enable:
 	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
-err_get:
-	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 err:
 	mfd_remove_devices(wm8994->dev);
 	return ret;
@@ -672,7 +670,6 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 	wm8994_irq_exit(wm8994);
 	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
-	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
 }
 
 static const struct of_device_id wm8994_of_match[] = {
-- 
1.7.4.1

