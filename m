Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2IGPPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:15:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2IGPPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:15:14 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <axel.lin@gmail.com>, <lrg@ti.com>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH] regulator: core: fix rdev->regmap NULL pointer
Date: Fri, 7 Sep 2012 20:45:05 +0530
Message-ID: <1347030905-17722-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes rdev->regmap NULL pointer if regmap for regulator device
is NULL. If it is NULL then get regmap for regulator device
from its parent (MFD).

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/regulator/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4838531..7d85402 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3189,8 +3189,10 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->desc = regulator_desc;
 	if (config->regmap)
 		rdev->regmap = config->regmap;
-	else
+	else if (dev_get_regmap(dev, NULL))
 		rdev->regmap = dev_get_regmap(dev, NULL);
+	else if (dev->parent)
+		rdev->regmap = dev_get_regmap(dev->parent, NULL);
 	INIT_LIST_HEAD(&rdev->consumer_list);
 	INIT_LIST_HEAD(&rdev->list);
 	BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
-- 
1.7.9.5

