Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1HQBSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:18:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65011 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:18:37 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-4d-4e4b16eb4663
Date: Wed, 17 Aug 2011 10:18:34 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] power: max17042: bugfix of incorrect voltage register value
 interpretation.
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Philip Rakity <prakity@marvell.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Message-id: <1313543914-19992-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 17 Aug 2011 01:19:08.0231 (UTC)
 FILETIME=[A98E4D70:01CC5C7B]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation had error in getting voltage values from
MAX17042 registers. The least bit denotes 78.125uV (625/8).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max17042_battery.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 61fb6d7..a6dc9c7 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -111,12 +111,12 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval *= 10000; /* Units of LSB = 10mV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
+		val->intval = max17042_read_reg(chip->client, MAX17042_VCELL)
+			    * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-		val->intval = max17042_read_reg(chip->client,
-				MAX17042_AvgVCELL) * 83;
+		val->intval = max17042_read_reg(chip->client, MAX17042_AvgVCELL)
+			    * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = max17042_read_reg(chip->client,
-- 
1.7.4.1

