Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2K1RKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:10:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59003 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab2K1RKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:10:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Log when a device causes a voltage constraint fail
Date: Wed, 28 Nov 2012 17:09:57 +0000
Message-Id: <1354122597-4602-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps with figuring out when things went wrong.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fe4a1b6..af97b62 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -199,8 +199,11 @@ static int regulator_check_consumers(struct regulator_dev *rdev,
 			*min_uV = regulator->min_uV;
 	}
 
-	if (*min_uV > *max_uV)
+	if (*min_uV > *max_uV) {
+		dev_err(regulator->dev, "Restricting voltage, %u-%uuV\n",
+			regulator->min_uV, regulator->max_uV);
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
1.7.10.4

