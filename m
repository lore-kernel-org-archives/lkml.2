Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2JRLMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2JRLMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020537"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 4/7] power_supply: add throttle state
Date: Thu, 18 Oct 2012 22:14:03 +0530
Message-Id: <1350578646-3315-5-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger and battery temperature contribute to the
platform thermal. The only way to control the temperature
is to control the charging. The charging can be controlled in different
way. This could be disabling charger, disabling charging, adjusting CC,
or by adjusting the INLMT. This patch adds a structure to define the
charger throttle actions. Also this patch adds a throttle_states
field to the struct power_supply which can be used by the charger
driver to define it's throttle actions for different states

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/power_supply.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index eea1709..b4eb0af 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -183,6 +183,18 @@ union power_supply_propval {
 	const char *strval;
 };
 
+enum psy_throttle_action {
+
+	PSY_THROTTLE_DISABLE_CHARGER = 0,
+	PSY_THROTTLE_DISABLE_CHARGING,
+	PSY_THROTTLE_CC_LIMIT,
+	PSY_THROTTLE_INPUT_LIMIT,
+};
+
+struct power_supply_throttle {
+	enum psy_throttle_action throttle_action;
+	unsigned throttle_val;
+};
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
@@ -192,6 +204,7 @@ struct power_supply {
 	char **supplied_to;
 	unsigned long supported_cables;
 	size_t num_supplicants;
+	struct power_supply_throttle *throttle_states;
 
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
-- 
1.7.9.5

