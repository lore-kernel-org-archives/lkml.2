Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1GUOHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:07:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60052 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802Ab1GUOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:07:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix argument format type errors in error prints
Date: Thu, 21 Jul 2011 15:07:37 +0100
Message-Id: <1311257257-26498-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to dereference the pointers to print their values.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3700d09..412e281 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -153,7 +153,7 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
 
 	if (*min_uV > *max_uV) {
 		rdev_err(rdev, "unsupportable voltage range: %d-%duV\n",
-			 min_uV, max_uV);
+			 *min_uV, *max_uV);
 		return -EINVAL;
 	}
 
@@ -210,7 +210,7 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
 
 	if (*min_uA > *max_uA) {
 		rdev_err(rdev, "unsupportable current range: %d-%duA\n",
-			 min_uA, max_uA);
+			 *min_uA, *max_uA);
 		return -EINVAL;
 	}
 
-- 
1.7.5.4

