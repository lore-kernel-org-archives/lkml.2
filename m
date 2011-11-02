Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1KBLsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 07:48:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab1KBLse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 07:48:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Don't create voltage sysfs entries if we can't read voltage
Date: Wed,  2 Nov 2011 11:48:32 +0000
Message-Id: <1320234513-13150-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 669d021..dc3b31a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2503,7 +2503,8 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 	int			status = 0;
 
 	/* some attributes need specific methods to be displayed */
-	if (ops->get_voltage || ops->get_voltage_sel) {
+	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
+	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0) {
 		status = device_create_file(dev, &dev_attr_microvolts);
 		if (status < 0)
 			return status;
-- 
1.7.7.1

