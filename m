Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3AILfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:35:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62397 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab3AILfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:35:18 -0500
Message-ID: <1357731297.5239.1.camel@phoenix>
Subject: [PATCH v2] regulator: max8998: Ensure enough delay time for
 max8998_set_voltage_buck_time_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jan 2013 19:34:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: Only fix integer division truncation issue, remove other optimization.
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 06be8cc..1f0df40 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -447,7 +447,7 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 
 	difference = (new_selector - old_selector) * desc->step / 1000;
 	if (difference > 0)
-		return difference / ((val & 0x0f) + 1);
+		return DIV_ROUND_UP(difference, (val & 0x0f) + 1);
 
 	return 0;
 }
-- 
1.7.9.5



