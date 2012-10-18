Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2JRLMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2JRLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020495"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 3/7] power_supply : add supported charger cable  feature
Date: Thu, 18 Oct 2012 22:14:02 +0530
Message-Id: <1350578646-3315-4-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A charger can support different types of charger sources (cables).
It make sense to define a field to inform the power supply subsystem
what kind of cable  a charger driver supports. Since a bitmask would
be the easy way to do define, it's good to have a enum which has
the bitmask definition for each cable types

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/power_supply.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 7c06956..eea1709 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -163,6 +163,21 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_USB_ACA,	/* Accessory Charger Adapters */
 };
 
+enum power_supply_charger_cable_type {
+	POWER_SUPPLY_CHARGER_TYPE_NONE = 0,
+	POWER_SUPPLY_CHARGER_TYPE_USB_SDP = 1 << 0,
+	POWER_SUPPLY_CHARGER_TYPE_USB_DCP = 1 << 1,
+	POWER_SUPPLY_CHARGER_TYPE_USB_CDP = 1 << 2,
+	POWER_SUPPLY_CHARGER_TYPE_USB_ACA = 1 << 3,
+	POWER_SUPPLY_CHARGER_TYPE_AC = 1 << 4,
+};
+
+#define POWER_SUPPLY_CHARGER_TYPE_USB \
+	(POWER_SUPPLY_CHARGER_TYPE_USB_SDP | \
+	POWER_SUPPLY_CHARGER_TYPE_USB_DCP | \
+	POWER_SUPPLY_CHARGER_TYPE_USB_CDP | \
+	POWER_SUPPLY_CHARGER_TYPE_USB_ACA)
+
 union power_supply_propval {
 	int intval;
 	const char *strval;
@@ -175,6 +190,7 @@ struct power_supply {
 	size_t num_properties;
 
 	char **supplied_to;
+	unsigned long supported_cables;
 	size_t num_supplicants;
 
 	int (*get_property)(struct power_supply *psy,
-- 
1.7.9.5

