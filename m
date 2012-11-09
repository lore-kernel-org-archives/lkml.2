Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KIK5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:57:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39273 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2KIK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:57:30 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, philipspatches@gmail.com,
        patches@linaro.org
Subject: [PATCH] regulator: core: Update regulator_is_supported_voltage for fixed voltages
Date: Fri,  9 Nov 2012 16:21:49 +0530
Message-Id: <1352458309-18141-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c5f3939b8fe0 ("regulator: core: Support fixed voltages in
regulator_is_supported_voltage()") adds support for fixed regulators
in regulator_is_supported_voltage.

In case of fixed regulators for which voltage cannot be changed,
regulator_is_supported_voltage should return success only if the
min_uV and max_uV parameters are same and it is equal to the current
voltage of the regulator.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---

Currently this patch breaks MMC support for boards on which vmmc is a
fixed regulator and the voltage is not equal to either of 3.3v, 3.0v
or 1.8v. Earlier it used to work if the voltage was less than 3.3v.

 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1a35251..4a377a7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1974,7 +1974,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		ret = regulator_get_voltage(regulator);
 		if (ret >= 0)
-			return (min_uV >= ret && ret <= max_uV);
+			return (ret == min_uV && ret == max_uV);
 		else
 			return ret;
 	}
-- 
1.7.4.1

