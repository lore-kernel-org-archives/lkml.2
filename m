Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2KVS4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48736 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2KVS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:36 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 2/3] mfd: stmpe-i2c: Move .driver structure fields inside {} in stmpe_i2c_driver
Date: Fri, 23 Nov 2012 00:26:19 +0530
Message-Id: <53b984826890cf263d3b3ae06b7f19ed8f57311e.1353610437.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
In-Reply-To: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, few fields in stmpe_i2c_driver are initialized as:
.driver.owner = THIS_MODULE,

Group them under {}, like:
.driver = {
	.owner = THIS_MODULE,
	...
},

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mfd/stmpe-i2c.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 947a06a..c734dc3 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -82,11 +82,13 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 MODULE_DEVICE_TABLE(i2c, stmpe_id);
 
 static struct i2c_driver stmpe_i2c_driver = {
-	.driver.name	= "stmpe-i2c",
-	.driver.owner	= THIS_MODULE,
+	.driver = {
+		.name = "stmpe-i2c",
+		.owner = THIS_MODULE,
 #ifdef CONFIG_PM
-	.driver.pm	= &stmpe_dev_pm_ops,
+		.pm = &stmpe_dev_pm_ops,
 #endif
+	},
 	.probe		= stmpe_i2c_probe,
 	.remove		= __devexit_p(stmpe_i2c_remove),
 	.id_table	= stmpe_i2c_id,
-- 
1.7.12.rc2.18.g61b472e

