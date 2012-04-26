Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2DZRlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:41:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53806 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab2DZRlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:35 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 06/10] ARM: OMAP2+: Voltage: Move the omap_volt_data structure to plat
Date: Thu, 26 Apr 2012 23:10:37 +0530
Message-ID: <1335462041-4949-7-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

Move the omap_volt_data structure from mach-omap2/ directory
to arch/arm/plat-omap/include/plat/ so that it is accessible
from both mach-omap2 and drivers directories.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/mach-omap2/voltage.h             |   21 ++-------------------
 arch/arm/plat-omap/include/plat/voltage.h |   21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/voltage.h b/arch/arm/mach-omap2/voltage.h
index 16a1b09..34ef504 100644
--- a/arch/arm/mach-omap2/voltage.h
+++ b/arch/arm/mach-omap2/voltage.h
@@ -16,6 +16,8 @@
 
 #include <linux/err.h>
 
+#include <plat/voltage.h>
+
 #include "vc.h"
 #include "vp.h"
 
@@ -91,25 +93,6 @@ struct voltagedomain {
 };
 
 /**
- * struct omap_volt_data - Omap voltage specific data.
- * @voltage_nominal:	The possible voltage value in uV
- * @sr_efuse_offs:	The offset of the efuse register(from system
- *			control module base address) from where to read
- *			the n-target value for the smartreflex module.
- * @sr_errminlimit:	Error min limit value for smartreflex. This value
- *			differs at differnet opp and thus is linked
- *			with voltage.
- * @vp_errorgain:	Error gain value for the voltage processor. This
- *			field also differs according to the voltage/opp.
- */
-struct omap_volt_data {
-	u32	volt_nominal;
-	u32	sr_efuse_offs;
-	u8	sr_errminlimit;
-	u8	vp_errgain;
-};
-
-/**
  * struct omap_voltdm_pmic - PMIC specific data required by voltage driver.
  * @slew_rate:	PMIC slew rate (in uv/us)
  * @step_size:	PMIC voltage step size (in uv)
diff --git a/arch/arm/plat-omap/include/plat/voltage.h b/arch/arm/plat-omap/include/plat/voltage.h
index 0a6a482..5be4d5d 100644
--- a/arch/arm/plat-omap/include/plat/voltage.h
+++ b/arch/arm/plat-omap/include/plat/voltage.h
@@ -11,10 +11,29 @@
 #ifndef __ARCH_ARM_OMAP_VOLTAGE_H
 #define __ARCH_ARM_OMAP_VOLTAGE_H
 
+/**
+ * struct omap_volt_data - Omap voltage specific data.
+ * @voltage_nominal:	The possible voltage value in uV
+ * @sr_efuse_offs:	The offset of the efuse register(from system
+ *			control module base address) from where to read
+ *			the n-target value for the smartreflex module.
+ * @sr_errminlimit:	Error min limit value for smartreflex. This value
+ *			differs at differnet opp and thus is linked
+ *			with voltage.
+ * @vp_errorgain:	Error gain value for the voltage processor. This
+ *			field also differs according to the voltage/opp.
+ */
+struct omap_volt_data {
+	u32	volt_nominal;
+	u32	sr_efuse_offs;
+	u8	sr_errminlimit;
+	u8	vp_errgain;
+};
 struct voltagedomain;
 
 struct voltagedomain *voltdm_lookup(const char *name);
 int voltdm_scale(struct voltagedomain *voltdm, unsigned long target_volt);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm);
-
+struct omap_volt_data *omap_voltage_get_voltdata(struct voltagedomain *voltdm,
+		unsigned long volt);
 #endif
-- 
1.7.5.4

