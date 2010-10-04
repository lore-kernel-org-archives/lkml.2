Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0JDHwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:52:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21991 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab0JDHwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:52:03 -0400
From: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: linux-kernel@vger.kernel.org, ext-heikki.krogerus@nokia.com
Subject: [PATCH 1/2] power_supply: add types for USB chargers
Date: Mon,  4 Oct 2010 10:51:37 +0300
Message-Id: <1286178698-28428-2-git-send-email-ext-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
References: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
X-OriginalArrivalTime: 04 Oct 2010 07:51:47.0520 (UTC) FILETIME=[FF09C400:01CB6398]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>

This adds power supply types for USB chargers defined in
Battery Charging Specification 1.1.

Signed-off-by: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
---
 drivers/power/power_supply_sysfs.c |    3 ++-
 include/linux/power_supply.h       |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 9d30eeb..88f5e43 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -42,7 +42,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf) {
 	static char *type_text[] = {
-		"Battery", "UPS", "Mains", "USB"
+		"Battery", "UPS", "Mains", "USB",
+		"USB_DCP", "USB_CDP", "USB_ACA"
 	};
 	static char *status_text[] = {
 		"Unknown", "Charging", "Discharging", "Not charging", "Full"
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 30083a8..d37fef6 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -125,7 +125,10 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_BATTERY = 0,
 	POWER_SUPPLY_TYPE_UPS,
 	POWER_SUPPLY_TYPE_MAINS,
-	POWER_SUPPLY_TYPE_USB,
+	POWER_SUPPLY_TYPE_USB,		/* Standard Downstream Port */
+	POWER_SUPPLY_TYPE_USB_DCP,	/* Dedicated Charging Port */
+	POWER_SUPPLY_TYPE_USB_CDP,	/* Charging Downstream Port */
+	POWER_SUPPLY_TYPE_USB_ACA,	/* Accessory Charger Adapters */
 };
 
 union power_supply_propval {
-- 
1.7.0.4

