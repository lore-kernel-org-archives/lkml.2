Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2GEMxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:53:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:64500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2GEMxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:53:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164331923"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add min/max alert properties for CAPACITY, TEMP, TEMP_AMBIENT
Date: Thu,  5 Jul 2012 16:59:12 +0530
Message-Id: <1341487752-2724-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimum and maximum alerts on power supply properties will help or allow the
user space to "proactively" create policies like connect/disconnect charger
or stop/start the user apps based on capacity or temperature parameters.

These parameters can be used to avoid unnecessary polling from user space and
even from kernel space if the underlying HW can support INT triggers(ex: max17042/47).

This patch adds the following power supply alert type properties:
CAPACITY_ALERT_MIN
CAPACITY_ALERT_MAX
TEMP_ALERT_MIN
TEMP_ALERT_MAX
TEMP_AMBIENT_ALERT_MIN
TEMP_AMBIENT_ALERT_MAX

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    6 ++++++
 drivers/power/power_supply_sysfs.c         |    6 ++++++
 include/linux/power_supply.h               |    6 ++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index c0f62ae..2f0ddc1 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -119,11 +119,17 @@ CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
+CAPACITY_ALERT_MIN - minimum capacity alert value in percents.
+CAPACITY_ALERT_MAX - maximum capacity alert value in percents.
 CAPACITY_LEVEL - capacity level. This corresponds to
 POWER_SUPPLY_CAPACITY_LEVEL_*.
 
 TEMP - temperature of the power supply.
+TEMP_ALERT_MIN - minimum battery temperature alert value in milli centigrade.
+TEMP_ALERT_MAX - maximum battery temperature alert value in milli centigrade.
 TEMP_AMBIENT - ambient temperature.
+TEMP_AMBIENT_ALERT_MIN - minimum ambient temperature alert value in milli centigrade.
+TEMP_AMBIENT_ALERT_MAX - maximum ambient temperature alert value in milli centigrade.
 
 TIME_TO_EMPTY - seconds left for battery to be considered empty (i.e.
 while battery powers a load)
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 58846d9..1d96614 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -168,9 +168,15 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(energy_now),
 	POWER_SUPPLY_ATTR(energy_avg),
 	POWER_SUPPLY_ATTR(capacity),
+	POWER_SUPPLY_ATTR(capacity_alert_min),
+	POWER_SUPPLY_ATTR(capacity_alert_max),
 	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
+	POWER_SUPPLY_ATTR(temp_alert_min),
+	POWER_SUPPLY_ATTR(temp_alert_max),
 	POWER_SUPPLY_ATTR(temp_ambient),
+	POWER_SUPPLY_ATTR(temp_ambient_alert_min),
+	POWER_SUPPLY_ATTR(temp_ambient_alert_max),
 	POWER_SUPPLY_ATTR(time_to_empty_now),
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 53f177d..0bafbb1 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -118,9 +118,15 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 	POWER_SUPPLY_PROP_ENERGY_AVG,
 	POWER_SUPPLY_PROP_CAPACITY, /* in percents! */
+	POWER_SUPPLY_PROP_CAPACITY_ALERT_MIN, /* in percents! */
+	POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX, /* in percents! */
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TEMP_ALERT_MIN,
+	POWER_SUPPLY_PROP_TEMP_ALERT_MAX,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MIN,
+	POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MAX,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
-- 
1.7.0.4

