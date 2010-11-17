Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0KQXap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:30:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61200 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0KQXao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:30:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6170"; a="63112546"
From: Daniel Walker <dwalker@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        bleong@codeaurora.org
Subject: [PATCH 1/2] drivers: regulator: core: use pr_fmt
Date: Wed, 17 Nov 2010 15:30:27 -0800
Message-Id: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a pr_fmt line which uses the __func__ macro. I also
convert the current pr_ lines to remove their __func__ usage.

Cc: bleong@codeaurora.org
Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/regulator/core.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..a3ca3d6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) "%s:" fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -765,8 +767,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* else require explicit machine-level constraints */
 		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			pr_err("%s: %s '%s' voltage constraints\n",
-				       __func__, "invalid", name);
+			pr_err("%s '%s' voltage constraints\n", "invalid",
+				name);
 			return -EINVAL;
 		}
 
@@ -787,22 +789,22 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* final: [min_uV..max_uV] valid iff constraints valid */
 		if (max_uV < min_uV) {
-			pr_err("%s: %s '%s' voltage constraints\n",
-				       __func__, "unsupportable", name);
+			pr_err("%s '%s' voltage constraints\n", "unsupportable",
+				name);
 			return -EINVAL;
 		}
 
 		/* use regulator's subset of machine constraints */
 		if (constraints->min_uV < min_uV) {
-			pr_debug("%s: override '%s' %s, %d -> %d\n",
-				       __func__, name, "min_uV",
-					constraints->min_uV, min_uV);
+			pr_debug("override '%s' %s, %d -> %d\n",
+				 name, "min_uV",
+				 constraints->min_uV, min_uV);
 			constraints->min_uV = min_uV;
 		}
 		if (constraints->max_uV > max_uV) {
-			pr_debug("%s: override '%s' %s, %d -> %d\n",
-				       __func__, name, "max_uV",
-					constraints->max_uV, max_uV);
+			pr_debug("override '%s' %s, %d -> %d\n",
+				 name, "max_uV",
+				 constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
 	}
-- 
1.7.1

