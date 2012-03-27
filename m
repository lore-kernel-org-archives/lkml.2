Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2C0HRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:17:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2C0HRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:17:34 -0400
Message-ID: <1332832646.9942.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: wm831x-dcdc: Fix the logic to choose best
 current limit setting
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 15:17:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code in wm831x_buckv_set_current_limit actually set the current limit
setting greater than specified range.

Fix the logic in wm831x_buckv_set_current_limit to choose the
smallest current limit setting falls within the specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 3044001..ff810e7 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -380,7 +380,8 @@ static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_dcdc_ilim); i++) {
-		if (max_uA <= wm831x_dcdc_ilim[i])
+		if ((min_uA <= wm831x_dcdc_ilim[i]) &&
+		    (wm831x_dcdc_ilim[i] <= max_uA))
 			break;
 	}
 	if (i == ARRAY_SIZE(wm831x_dcdc_ilim))
-- 
1.7.5.4



