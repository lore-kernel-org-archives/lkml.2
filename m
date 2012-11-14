Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab2KNEAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 23:00:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2KNEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 23:00:23 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH v2] regulator: core: Update regulator_is_supported_voltage for fixed voltages
Date: Wed, 14 Nov 2012 09:24:26 +0530
Message-Id: <1352865266-25286-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c5f3939b8fe0 ("regulator: core: Support fixed voltages in
regulator_is_supported_voltage()") returns success when the regulator
voltage is less than both min_uV and max_uV. Modify this to return
success only when the regulator voltage is within the specified range.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since v1:
	* Return success when the regulator voltage is within the
	specified range.

 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1a35251..e90e5c3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1974,7 +1974,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		ret = regulator_get_voltage(regulator);
 		if (ret >= 0)
-			return (min_uV >= ret && ret <= max_uV);
+			return (ret >= min_uV && ret <= max_uV);
 		else
 			return ret;
 	}
-- 
1.7.4.1

