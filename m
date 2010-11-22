Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0KVNv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:51:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33749 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754646Ab0KVNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:51:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Fix obfuscated log messages
Date: Mon, 22 Nov 2010 13:51:18 +0000
Message-Id: <1290433879-6184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use %s to format fixed static strings into log messages, it just
makes searching for and reading the message in the kernel source
needlessly hard.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8d492f4..fe47860 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -760,7 +760,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* else require explicit machine-level constraints */
 		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			pr_err("%s '%s' voltage constraints\n", "invalid",
+			pr_err("invalid '%s' voltage constraints\n",
 				name);
 			return -EINVAL;
 		}
@@ -782,22 +782,20 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 		/* final: [min_uV..max_uV] valid iff constraints valid */
 		if (max_uV < min_uV) {
-			pr_err("%s '%s' voltage constraints\n", "unsupportable",
+			pr_err("unsupportable '%s' voltage constraints\n",
 				name);
 			return -EINVAL;
 		}
 
 		/* use regulator's subset of machine constraints */
 		if (constraints->min_uV < min_uV) {
-			pr_debug("override '%s' %s, %d -> %d\n",
-				 name, "min_uV",
-				 constraints->min_uV, min_uV);
+			pr_debug("override '%s' min_uV, %d -> %d\n",
+				 name, constraints->min_uV, min_uV);
 			constraints->min_uV = min_uV;
 		}
 		if (constraints->max_uV > max_uV) {
-			pr_debug("override '%s' %s, %d -> %d\n",
-				 name, "max_uV",
-				 constraints->max_uV, max_uV);
+			pr_debug("override '%s' max_uV, %d -> %d\n",
+				 name, constraints->max_uV, max_uV);
 			constraints->max_uV = max_uV;
 		}
 	}
-- 
1.7.1

