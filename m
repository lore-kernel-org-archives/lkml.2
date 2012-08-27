Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2H0Shv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:37:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59066 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466Ab2H0Shu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:37:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Report microvolts in sysfs even with only list_voltage()
Date: Mon, 27 Aug 2012 11:37:46 -0700
Message-Id: <1346092666-17772-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator only supports a single voltage list_voltage() can be used
to report what that voltage is so add this as one of the criteria for
creating the microvolts file in sysfs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 06186ba..db7d59a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3020,7 +3020,8 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 
 	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
-	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0)) {
+	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0) ||
+	    (ops->list_voltage && ops->list_voltage(rdev, 0) >= 0)) {
 		status = device_create_file(dev, &dev_attr_microvolts);
 		if (status < 0)
 			return status;
-- 
1.7.10.4

