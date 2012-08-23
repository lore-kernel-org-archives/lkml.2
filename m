Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2HWClT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:41:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:64873 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab2HWClQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,297,1344236400"; 
   d="scan'208";a="190207112"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add new power supply AUTHENTIC property
Date: Thu, 23 Aug 2012 06:50:21 +0530
Message-Id: <1345684821-13890-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that users can use non-standard chargers
or use invalid batteries especially with mobile devices.

This patch adds a new power supply property called 'AUTHENTIC' to
indicate this to the user(user space).

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    3 +++
 drivers/power/power_supply_sysfs.c         |    1 +
 include/linux/power_supply.h               |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 2f0ddc1..29a1fcd 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -81,6 +81,9 @@ This defines trickle and fast charges.  For batteries that
 are already charged or discharging, 'n/a' can be displayed (or
 'unknown', if the status is not known).
 
+AUTHENTIC - indicates the power supp(battery or charger) connected
+to the platform is authentic(1) or non authentic(0).
+
 HEALTH - represents health of the battery, values corresponds to
 POWER_SUPPLY_HEALTH_*, defined in battery.h.
 
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 1d96614..be34a6d 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -138,6 +138,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(health),
 	POWER_SUPPLY_ATTR(present),
 	POWER_SUPPLY_ATTR(online),
+	POWER_SUPPLY_ATTR(authentic),
 	POWER_SUPPLY_ATTR(technology),
 	POWER_SUPPLY_ATTR(cycle_count),
 	POWER_SUPPLY_ATTR(voltage_max),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3cfee0c..729768c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -88,6 +88,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_AUTHENTIC,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX,
-- 
1.7.0.4

