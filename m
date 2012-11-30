Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2K3Jm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:42:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:9125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2K3Jmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:42:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="227076086"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: add watchdog and safety timer expiries under PROP_HEALTH_*
Date: Fri, 30 Nov 2012 13:57:46 +0530
Message-Id: <1354264066-3523-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As most of the charger chips come with two kinds of safety features
related to timing.
1. Watchdog Timer (interms of seconds/mins)
2. Safety Timer (interms of hours)

This patch adds these to fault causes in POWER_SUPPLY_PROP_HEALTH_*
enums so that whenever there is either watchdog timeout or safety timer
timeout driver could notify the user space accurately about the fault
and will also be helpful for debug.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/power_supply_sysfs.c |    3 ++-
 include/linux/power_supply.h       |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 40fa3b7..29178f7 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -55,7 +55,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 	};
 	static char *health_text[] = {
 		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
-		"Unspecified failure", "Cold",
+		"Unspecified failure", "Cold", "Watchdog timer expire",
+		"Safety timer expire"
 	};
 	static char *technology_text[] = {
 		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 35cdf2c..4e672e1 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -54,6 +54,8 @@ enum {
 	POWER_SUPPLY_HEALTH_OVERVOLTAGE,
 	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
 	POWER_SUPPLY_HEALTH_COLD,
+	POWER_SUPPLY_HEALTH_WATCHDOG_TIMER_EXPIRE,
+	POWER_SUPPLY_HEALTH_SAFETY_TIMER_EXPIRE,
 };
 
 enum {
-- 
1.7.0.4

