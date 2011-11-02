Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1KBLsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 07:48:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46071 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab1KBLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 07:48:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Don't report zero volts for the fixed voltage regulator
Date: Wed,  2 Nov 2011 11:48:04 +0000
Message-Id: <1320234484-13093-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't know what voltage the regulator is set to return an error
rather than reporting zero volts.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 21ecf21..ccbead0 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -80,7 +80,10 @@ static int fixed_voltage_get_voltage(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
-	return data->microvolts;
+	if (data->microvolts)
+		return data->microvolts;
+	else
+		return -EINVAL;
 }
 
 static int fixed_voltage_list_voltage(struct regulator_dev *dev,
-- 
1.7.7.1

