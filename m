Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab2GFJ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:26:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab2GFJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:26:15 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] pwm: Use pr_* functions in pwm-samsung.c file
Date: Fri,  6 Jul 2012 14:43:50 +0530
Message-Id: <1341566030-3902-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk with pr_* functions to avoid checkpatch warnings.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pwm/pwm-samsung.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 35fa0e8..d103865 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -11,6 +11,8 @@
  * the Free Software Foundation; either version 2 of the License.
 */
 
+#define pr_fmt(fmt) "pwm-samsung: " fmt
+
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
@@ -340,13 +342,13 @@ static int __init pwm_init(void)
 	clk_scaler[1] = clk_get(NULL, "pwm-scaler1");
 
 	if (IS_ERR(clk_scaler[0]) || IS_ERR(clk_scaler[1])) {
-		printk(KERN_ERR "%s: failed to get scaler clocks\n", __func__);
+		pr_err("failed to get scaler clocks\n");
 		return -EINVAL;
 	}
 
 	ret = platform_driver_register(&s3c_pwm_driver);
 	if (ret)
-		printk(KERN_ERR "%s: failed to add pwm driver\n", __func__);
+		pr_err("failed to add pwm driver\n");
 
 	return ret;
 }
-- 
1.7.4.1

