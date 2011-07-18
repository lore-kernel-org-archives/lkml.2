Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1GRIXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:23:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1GRIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:23:20 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-80-4e23ed7631ac
Date: Mon, 18 Jul 2011 17:22:36 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] power_supply: MAX8997 Charger: Provide status field with more
 information
To: cbou@mail.ru
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Message-id: <1310977356-24032-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 18 Jul 2011 08:23:43.0069 (UTC)
 FILETIME=[015998D0:01CC4524]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides additional three values for STATUS property.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/power/max8997_charger.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 7106b49..790b325 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -55,8 +55,17 @@ static int max8997_battery_get_property(struct power_supply *psy,
 		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
+
 		if ((reg & (1 << 0)) == 0x1)
 			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else if ((reg & (1 << 1)) && !(reg & (1 << 2)) &&
+			 (reg & (1 << 3)) && (reg & (3 << 4)) &&
+			 !(reg & (1 << 6)))
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else if ((reg & (1 << 1)) && !(reg & (1 << 6)))
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-- 
1.7.4.1

