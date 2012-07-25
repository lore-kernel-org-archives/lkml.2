Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab2GYDwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:52:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2GYDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:28 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 14/52] ACPI Battery: Added capacity
Date: Tue, 24 Jul 2012 23:41:10 -0400
Message-Id: <a58e1150225cc9e554b76da5519b2bb5bb6e46ff.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: srinivas pandruvada <srinivas.pandruvada@intel.com>

Added Capacity field, which is a pre-defined power_supply
property. Calculating capacity using current charge/energy and
full charge/energy.
Some user mode implementations are relying on capacity field to
show battery strength and power down decision.

Signed-off-by: srinivas pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/battery.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7dd3f9f..5662d64 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -250,6 +250,13 @@ static int acpi_battery_get_property(struct power_supply *psy,
 		else
 			val->intval = battery->capacity_now * 1000;
 		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		if (battery->capacity_now && battery->full_charge_capacity)
+			val->intval = battery->capacity_now * 100/
+					battery->full_charge_capacity;
+		else
+			val->intval = 0;
+		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->model_number;
 		break;
@@ -276,6 +283,7 @@ static enum power_supply_property charge_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
@@ -292,6 +300,7 @@ static enum power_supply_property energy_battery_props[] = {
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
 	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
-- 
1.7.12.rc0

