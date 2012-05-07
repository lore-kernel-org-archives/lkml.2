Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2EGGXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:23:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:28244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2EGGXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139673508"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: Support CHARGE_COUNTER power supply attribute
Date: Mon,  7 May 2012 10:25:58 +0530
Message-Id: <1336366558-27137-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for CHARGE_COUNTER power supply
attribute to max17042/47 driver.

Note:QH(Charge Counter) register is not documented in max17042 the Spec.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 140788b..74abc6c 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -113,6 +113,7 @@ static enum power_supply_property max17042_battery_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_OCV,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
@@ -201,6 +202,13 @@ static int max17042_get_property(struct power_supply *psy,
 
 		val->intval = ret * 1000 / 2;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret = max17042_read_reg(chip->client, MAX17042_QH);
+		if (ret < 0)
+			return ret;
+
+		val->intval = ret * 1000 / 2;
+		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = max17042_read_reg(chip->client, MAX17042_TEMP);
 		if (ret < 0)
-- 
1.7.0.4

