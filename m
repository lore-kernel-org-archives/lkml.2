Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2FTJcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:32:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:44887 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab2FTJcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167924200"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add charge_rate_limit power supply attribute
Date: Wed, 20 Jun 2012 13:38:03 +0530
Message-Id: <1340179683-6548-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During charging battery temperature and charger chip(die) temperature
will go up and this intern adds upto the overall platform temperature.
On mobile devices this can have huge impact on the user(user experience).

This patch adds a new power supply property charge_rate_limit which can
be used by user space app/framework(Ex: Thermal Manager) to control the
overall platform temperature by changing the charge rate property.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    4 ++++
 drivers/power/power_supply_sysfs.c         |    1 +
 include/linux/power_supply.h               |    8 ++++++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index c0f62ae..8345f93 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -116,6 +116,10 @@ CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
 
 CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
 
+CHARGE_RATE_LIMIT - interface to limit or control the charge rate from
+user space, values corresponds to POWER_SUPPLY_CHARGE_RATE_* as defined
+in power_supply.h
+
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 58846d9..7e4272a 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -161,6 +161,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(charge_counter),
 	POWER_SUPPLY_ATTR(constant_charge_current),
 	POWER_SUPPLY_ATTR(constant_charge_voltage),
+	POWER_SUPPLY_ATTR(charge_rate_limit),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 53f177d..b9993d4 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -47,6 +47,13 @@ enum {
 };
 
 enum {
+	POWER_SUPPLY_CHARGE_RATE_LOW = 0,
+	POWER_SUPPLY_CHARGE_RATE_MEDIUM,
+	POWER_SUPPLY_CHARGE_RATE_HIGH,
+	POWER_SUPPLY_CHARGE_RATE_FULL,
+};
+
+enum {
 	POWER_SUPPLY_HEALTH_UNKNOWN = 0,
 	POWER_SUPPLY_HEALTH_GOOD,
 	POWER_SUPPLY_HEALTH_OVERHEAT,
@@ -111,6 +118,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
+	POWER_SUPPLY_PROP_CHARGE_RATE_LIMIT,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
-- 
1.7.0.4

