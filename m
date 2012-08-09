Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031194Ab2HIPpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:45:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49282 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030969Ab2HIPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:45:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Use list_voltage() to read single voltage regulators
Date: Thu,  9 Aug 2012 16:45:11 +0100
Message-Id: <1344527111-29611-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regulator doesn't supply a way of reading back the voltage but does
provide a list_voltage() operation then use that with a selector of zero
to read the voltage.

Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 157def1..ff8f544 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2395,6 +2395,8 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->list_voltage(rdev, sel);
 	} else if (rdev->desc->ops->get_voltage) {
 		ret = rdev->desc->ops->get_voltage(rdev);
+	} else if (rdev->desc->ops->list_voltage) {
+		ret = rdev->desc->ops->list_voltage(rdev, 0);
 	} else {
 		return -EINVAL;
 	}
-- 
1.7.10.4

