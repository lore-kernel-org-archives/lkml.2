Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1BXRiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:38:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41590 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753211Ab1BXRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:38:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: If we fail when setting up a supply say which supply
Date: Thu, 24 Feb 2011 17:39:09 +0000
Message-Id: <1298569149-9169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it a bit easier to identify if it's a problem with the supplies,
the usual error would be omitting the supply name entirely.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..a2dc622 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2565,8 +2565,11 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 			init_data->consumer_supplies[i].dev,
 			init_data->consumer_supplies[i].dev_name,
 			init_data->consumer_supplies[i].supply);
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(dev, "Failed to set supply %s\n",
+				init_data->consumer_supplies[i].supply);
 			goto unset_supplies;
+		}
 	}
 
 	list_add(&rdev->list, &regulator_list);
-- 
1.7.2.3

