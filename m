Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3AGHTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:19:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab3AGHSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732836"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 7/9] Thermal: Make PER_ZONE values configurable
Date: Mon,  7 Jan 2013 12:43:24 +0530
Message-Id: <1357542806-20449-8-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes MAX_SENSORS_PER_ZONE and
MAX_CDEVS_PER_ZONE values configurable. The
default value is 1, and range is 1-12.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/Kconfig |   14 ++++++++++++++
 include/linux/thermal.h |    6 +++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index d96da07..c5ba3340 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -15,6 +15,20 @@ menuconfig THERMAL
 
 if THERMAL
 
+config THERMAL_MAX_SENSORS_PER_ZONE
+	int "Maximum number of sensors allowed per thermal zone"
+	default 1
+	range 1 12
+	---help---
+	  Specify the number of sensors allowed per zone
+
+config THERMAL_MAX_CDEVS_PER_ZONE
+	int "Maximum number of cooling devices allowed per thermal zone"
+	default 1
+	range 1 12
+	---help---
+	  Specify the number of cooling devices allowed per zone
+
 config THERMAL_HWMON
 	bool
 	depends on HWMON=y || HWMON=THERMAL
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 187fadb..cf19fba 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -50,9 +50,9 @@
 /* Default Thermal Governor: Does Linear Throttling */
 #define DEFAULT_THERMAL_GOVERNOR	"step_wise"
 
-#define MAX_SENSORS_PER_ZONE		5
-
-#define MAX_CDEVS_PER_ZONE		5
+/* Maximum number of sensors/cdevs per zone, defined through Kconfig */
+#define MAX_SENSORS_PER_ZONE	CONFIG_THERMAL_MAX_SENSORS_PER_ZONE
+#define MAX_CDEVS_PER_ZONE	CONFIG_THERMAL_MAX_CDEVS_PER_ZONE
 
 /* If we map each sensor with every possible cdev for a zone */
 #define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
-- 
1.7.9.5

