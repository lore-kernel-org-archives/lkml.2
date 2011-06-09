Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1FIPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:22:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58898 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752520Ab1FIPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:22:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: Include the device name in the microamps_requested_ file
Date: Thu,  9 Jun 2011 16:22:21 +0100
Message-Id: <1307632942-667-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307632942-667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1307632942-667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may have multiple devices requesting a supply with the same name so
include the device name in the generated filename for microamps_requested
to avoid duplicate files.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d2d5001..5aa1beb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1055,8 +1055,9 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	if (dev) {
 		/* create a 'requested_microamps_name' sysfs entry */
-		size = scnprintf(buf, REG_STR_SIZE, "microamps_requested_%s",
-			supply_name);
+		size = scnprintf(buf, REG_STR_SIZE,
+				 "microamps_requested_%s-%s",
+				 dev_name(dev), supply_name);
 		if (size >= REG_STR_SIZE)
 			goto overflow_err;
 
-- 
1.7.5.3

