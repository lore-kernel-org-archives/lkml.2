Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1GGHwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:52:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56633 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1GGHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:52:22 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-c0-4e1565b4f2b6
Date: Thu, 07 Jul 2011 16:51:56 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] regulator: max8997: Fix setting inappropriate value for
 ramp_delay variable
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Message-id: <1310025116-30787-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 07 Jul 2011 07:52:32.0073 (UTC)
 FILETIME=[D39B0390:01CC3C7A]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramp_delay variable can be set lower than the desired value.
This patch fixes it.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8997.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 10d5a1d..682bc79 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -543,7 +543,8 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 			rid == MAX8997_BUCK4 || rid == MAX8997_BUCK5) {
 		/* If the voltage is increasing */
 		if (org < i)
-			udelay(desc->step * (i - org) / max8997->ramp_delay);
+			udelay(DIV_ROUND_UP(desc->step * (i - org),
+						max8997->ramp_delay));
 	}
 
 	return ret;
-- 
1.7.4.1

