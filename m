Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031921Ab2COQr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:47:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031761Ab2COQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:25 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 02/10] ARM: OMAP2+: SmartReflex: move the platform specific macros in plat-omap
Date: Thu, 15 Mar 2012 17:43:57 +0100
Message-Id: <1331829845-9526-3-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Move the platform specific macros from the smartreflex header file
(arch/arm/mach-omap2/smartreflex.h) in a new header file in plat-omap
(arch/arm/plat-omap/include/plat/smartreflex.h).

This change makes the SmartReflex implementation ready for the move
to drivers/.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c    |    3 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c    |    3 +-
 arch/arm/mach-omap2/smartreflex.h             |   42 ----------------
 arch/arm/mach-omap2/sr_device.c               |    2 +-
 arch/arm/plat-omap/include/plat/smartreflex.h |   65 +++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/plat/smartreflex.h

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 0cc6a40..1f681e8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -26,10 +26,9 @@
 #include <plat/mcbsp.h>
 #include <plat/mcspi.h>
 #include <plat/dmtimer.h>
+#include <plat/smartreflex.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "prm-regbits-34xx.h"
 #include "cm-regbits-34xx.h"
 #include "wd_timer.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 48e5834..a1e359f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -30,10 +30,9 @@
 #include <plat/mmc.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
+#include <plat/smartreflex.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "cm1_44xx.h"
 #include "cm2_44xx.h"
 #include "prm44xx.h"
diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
index 5809141..cb8d98a 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/arch/arm/mach-omap2/smartreflex.h
@@ -152,14 +152,6 @@ struct omap_sr_pmic_data {
 	void (*sr_pmic_init) (void);
 };
 
-/**
- * struct omap_smartreflex_dev_attr - Smartreflex Device attribute.
- *
- * @sensor_voltdm_name:       Name of voltdomain of SR instance
- */
-struct omap_smartreflex_dev_attr {
-	const char      *sensor_voltdm_name;
-};
 
 #ifdef CONFIG_OMAP_SMARTREFLEX
 /*
@@ -194,40 +186,6 @@ struct omap_sr_class_data {
 	u8 class_type;
 };
 
-/**
- * struct omap_sr_nvalue_table	- Smartreflex n-target value info
- *
- * @efuse_offs:	The offset of the efuse where n-target values are stored.
- * @nvalue:	The n-target value.
- */
-struct omap_sr_nvalue_table {
-	u32 efuse_offs;
-	u32 nvalue;
-};
-
-/**
- * struct omap_sr_data - Smartreflex platform data.
- *
- * @ip_type:		Smartreflex IP type.
- * @senp_mod:		SENPENABLE value for the sr
- * @senn_mod:		SENNENABLE value for sr
- * @nvalue_count:	Number of distinct nvalues in the nvalue table
- * @enable_on_init:	whether this sr module needs to enabled at
- *			boot up or not.
- * @nvalue_table:	table containing the  efuse offsets and nvalues
- *			corresponding to them.
- * @voltdm:		Pointer to the voltage domain associated with the SR
- */
-struct omap_sr_data {
-	int				ip_type;
-	u32				senp_mod;
-	u32				senn_mod;
-	int				nvalue_count;
-	bool				enable_on_init;
-	struct omap_sr_nvalue_table	*nvalue_table;
-	struct voltagedomain		*voltdm;
-};
-
 /* Smartreflex module enable/disable interface */
 void omap_sr_enable(struct voltagedomain *voltdm);
 void omap_sr_disable(struct voltagedomain *voltdm);
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index a503e1e..dad1473 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -23,8 +23,8 @@
 #include <linux/io.h>
 
 #include <plat/omap_device.h>
+#include <plat/smartreflex.h>
 
-#include "smartreflex.h"
 #include "voltage.h"
 #include "control.h"
 #include "pm.h"
diff --git a/arch/arm/plat-omap/include/plat/smartreflex.h b/arch/arm/plat-omap/include/plat/smartreflex.h
new file mode 100644
index 0000000..baa296f
--- /dev/null
+++ b/arch/arm/plat-omap/include/plat/smartreflex.h
@@ -0,0 +1,65 @@
+/*
+ * OMAP Platform Smartreflex Defines and Routines
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ * Jean Pihet <j-pihet@ti.com>
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Kalle Jokiniemi
+ *
+ * Copyright (C) 2007 Texas Instruments, Inc.
+ * Lesly A M <x0080970@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_ARM_PLATOMAP_SMARTREFLEX_H
+#define __ASM_ARM_PLATOMAP_SMARTREFLEX_H
+
+#include "voltage.h"
+
+/**
+ * struct omap_sr_nvalue_table	- Smartreflex n-target value info
+ *
+ * @efuse_offs:	The offset of the efuse where n-target values are stored.
+ * @nvalue:	The n-target value.
+ */
+struct omap_sr_nvalue_table {
+	u32 efuse_offs;
+	u32 nvalue;
+};
+
+/**
+ * struct omap_sr_data - Smartreflex platform data.
+ *
+ * @ip_type:		Smartreflex IP type.
+ * @senp_mod:		SENPENABLE value for the sr
+ * @senn_mod:		SENNENABLE value for sr
+ * @nvalue_count:	Number of distinct nvalues in the nvalue table
+ * @enable_on_init:	whether this sr module needs to enabled at
+ *			boot up or not.
+ * @nvalue_table:	table containing the  efuse offsets and nvalues
+ *			corresponding to them.
+ * @voltdm:		Pointer to the voltage domain associated with the SR
+ */
+struct omap_sr_data {
+	int				ip_type;
+	u32				senp_mod;
+	u32				senn_mod;
+	int				nvalue_count;
+	bool				enable_on_init;
+	struct omap_sr_nvalue_table	*nvalue_table;
+	struct voltagedomain		*voltdm;
+};
+
+/**
+ * struct omap_smartreflex_dev_attr - Smartreflex Device attribute.
+ *
+ * @sensor_voltdm_name:       Name of voltdomain of SR instance
+ */
+struct omap_smartreflex_dev_attr {
+	const char      *sensor_voltdm_name;
+};
+
+#endif
-- 
1.7.5.4

