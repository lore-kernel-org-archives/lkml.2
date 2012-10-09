Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2JISNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:13:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:44254 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab2JISNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="202452518"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH 1/2] power_supply: Add support for CHARGE_CONTROL_* attributes
Date: Tue,  9 Oct 2012 22:25:29 +0530
Message-Id: <1349801729-19604-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for power supply attributes CHARGE_CONTROL_LIMIT
and CHARGE_CONTROL_LIMIT_MAX.

These new attributes will enable the user space to implement
custom charging algorithms based on platform state.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    3 +++
 drivers/power/power_supply_sysfs.c         |    2 ++
 include/linux/power_supply.h               |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 9c647bd..3f10b39 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -123,6 +123,9 @@ CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
 CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by the
 power supply object.
 
+CHARGE_CONTROL_LIMIT - current charge control limit setting
+CHARGE_CONTROL_LIMIT_MAX - maximum charge control limit setting
+
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 395c2cf..40fa3b7 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -164,6 +164,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(constant_charge_current_max),
 	POWER_SUPPLY_ATTR(constant_charge_voltage),
 	POWER_SUPPLY_ATTR(constant_charge_voltage_max),
+	POWER_SUPPLY_ATTR(charge_control_limit),
+	POWER_SUPPLY_ATTR(charge_control_limit_max),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index e5ef458..445b4b2 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -114,6 +114,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
+	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
-- 
1.7.0.4

