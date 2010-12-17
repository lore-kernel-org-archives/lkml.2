Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0LQQFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:05:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52239 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755300Ab0LQQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:05:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Clean up logging a bit
Date: Fri, 17 Dec 2010 16:05:05 +0000
Message-Id: <1292601905-21953-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent introduction of standard regulator API logging macros means
that all our log messages have at least the function name in them and
logging that the constraints are for the regulator API is probably a
bit much.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ab419f8..911b774 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -739,7 +739,7 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
-	rdev_info(rdev, "regulator: %s\n", buf);
+	rdev_info(rdev, "%s\n", buf);
 }
 
 static int machine_constraints_voltage(struct regulator_dev *rdev,
-- 
1.7.1

