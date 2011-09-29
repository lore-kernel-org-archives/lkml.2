Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1I2LLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:11:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47705 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab1I2LLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:11:53 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Support driver probe deferral
Date: Thu, 29 Sep 2011 12:11:01 +0100
Message-Id: <1317294661-22080-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to locate a requested regulator return -EAGAIN. If drivers
pass this error code through to their caller (which they really should)
then this will ensure that the probe is retried later when further devices
become available.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This depends on Grant's change to implement deferred probing, the error
code for which is going to change in the next revision.  Liam, if you're
also OK with this change I propose that we both ack it and let it get
carried along with the deferred probing change.

 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d5656b7..b39ec9f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1154,7 +1154,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 {
 	struct regulator_dev *rdev;
 	struct regulator_map *map;
-	struct regulator *regulator = ERR_PTR(-ENODEV);
+	struct regulator *regulator = ERR_PTR(-EAGAIN);
 	const char *devname = NULL;
 	int ret;
 
@@ -2727,7 +2727,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 		if (!found) {
 			dev_err(dev, "Failed to find supply %s\n",
 				init_data->supply_regulator);
-			ret = -ENODEV;
+			ret = -EAGAIN;
 			goto scrub;
 		}
 
-- 
1.7.6.3

