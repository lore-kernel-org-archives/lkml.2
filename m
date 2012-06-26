Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2FZKrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:47:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47739 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab2FZKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:47:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Check for failed voltage sets before checking for delay
Date: Tue, 26 Jun 2012 11:47:32 +0100
Message-Id: <1340707652-29329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to consider waiting for the voltage to ramp if we
didn't manage to set it and looking at the return value is going to be
cheaper than is_enabled().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 531441a..da31b8a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2123,7 +2123,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		best_val = _regulator_get_voltage(rdev);
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
-	if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
+	if (ret == 0 && _regulator_is_enabled(rdev) && old_selector >= 0 &&
 	    rdev->desc->ops->set_voltage_time_sel) {
 
 		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
-- 
1.7.10

