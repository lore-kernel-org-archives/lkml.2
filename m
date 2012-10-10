Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2JJEvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:51:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:7433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2JJEvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,563,1344236400"; 
   d="scan'208";a="232817322"
From: Jenny TC <jenny.tc@intel.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
Cc: jenny.tc@intel.com
Subject: [PATCH] extcon : callback function to read cable property
Date: Wed, 10 Oct 2012 15:53:48 +0530
Message-Id: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some cables a boolean variable will not be enough to represent
the state and properties of the cable. For example a charger cable can
have states CONNECT,DISCOONECT,SUSPEND(Host suspend for SDP cable),
RESUME(Host wakeup), and UPDATE (to increase the charge
current after USB enumaeration).Also the properties of the cable may
vary based on the state. FOr example in SUSPENDED state platforms can
support 0/100/500/950(USB 3.0) mA based on the HW. To initiate charging
the consumer should be able to get the charger properties dynamically.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 include/linux/extcon.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 073fd49..2e61ee0 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -122,6 +122,7 @@ struct extcon_dev {
 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
 	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
+	int (*get_cable_properties)(const char *cable_name, void *cable_props);
 
 	/* --- Internal data. Please do not set. --- */
 	struct device	*dev;
@@ -177,6 +178,19 @@ struct extcon_specific_cable_nb {
 	unsigned long previous_value;
 };
 
+enum extcon_chrgr_cbl_stat {
+	EXTCON_CHRGR_CABLE_CONNECTED,
+	EXTCON_CHRGR_CABLE_DISCONNECTED,
+	EXTCON_CHRGR_CABLE_SUSPENDED,
+	EXTCON_CHRGR_CABLE_RESUMED,
+	EXTCON_CHRGR_CABLE_UPDATED,
+};
+
+struct extcon_chrgr_cbl_props {
+	enum extcon_chrgr_cbl_stat cable_stat;
+	unsigned long mA;
+};
+
 #if IS_ENABLED(CONFIG_EXTCON)
 
 /*
-- 
1.7.9.5

