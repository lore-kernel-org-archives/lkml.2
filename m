Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2DZRn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:43:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53791 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab2DZRla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:30 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 01/10] ARM: OMAP2+: SmartReflex: move the smartreflex header to include/linux/power 
Date: Thu, 26 Apr 2012 23:10:32 +0530
Message-ID: <1335462041-4949-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Move the smartreflex header file
(arch/arm/mach-omap2/smartreflex.h) in a new header file
include/linux/power/smartreflex.h.

This change makes the SmartReflex implementation ready for the move
to drivers/.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    4 ++--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    3 +--
 arch/arm/mach-omap2/smartreflex-class3.c           |    3 ++-
 arch/arm/mach-omap2/smartreflex.c                  |    3 +--
 arch/arm/mach-omap2/sr_device.c                    |    2 +-
 .../linux/power}/smartreflex.h                     |    7 ++++---
 6 files changed, 11 insertions(+), 11 deletions(-)
 rename {arch/arm/mach-omap2 => include/linux/power}/smartreflex.h (98%)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 0c65079..144d118 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -14,6 +14,8 @@
  *
  * XXX these should be marked initdata for multi-OMAP kernels
  */
+#include <linux/power/smartreflex.h>
+
 #include <plat/omap_hwmod.h>
 #include <mach/irqs.h>
 #include <plat/cpu.h>
@@ -29,8 +31,6 @@
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "prm-regbits-34xx.h"
 #include "cm-regbits-34xx.h"
 #include "wd_timer.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 4906129..1079c79 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/power/smartreflex.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/cpu.h>
@@ -32,8 +33,6 @@
 #include <plat/common.h>
 
 #include "omap_hwmod_common_data.h"
-
-#include "smartreflex.h"
 #include "cm1_44xx.h"
 #include "cm2_44xx.h"
 #include "prm44xx.h"
diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index 955566e..ab8cf83 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -11,7 +11,8 @@
  * published by the Free Software Foundation.
  */
 
-#include "smartreflex.h"
+#include <linux/power/smartreflex.h>
+#include "voltage.h"
 
 static int sr_class3_enable(struct voltagedomain *voltdm)
 {
diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 008fbd7..98309d3 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -25,11 +25,10 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/power/smartreflex.h>
 
 #include "common.h"
-
 #include "pm.h"
-#include "smartreflex.h"
 
 #define SMARTREFLEX_NAME_LEN	16
 #define NVALUE_NAME_LEN		40
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index a503e1e..86e438e 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -17,6 +17,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/power/smartreflex.h>
 
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -24,7 +25,6 @@
 
 #include <plat/omap_device.h>
 
-#include "smartreflex.h"
 #include "voltage.h"
 #include "control.h"
 #include "pm.h"
diff --git a/arch/arm/mach-omap2/smartreflex.h b/include/linux/power/smartreflex.h
similarity index 98%
rename from arch/arm/mach-omap2/smartreflex.h
rename to include/linux/power/smartreflex.h
index 5809141..69eb270 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -17,12 +17,13 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __ASM_ARM_OMAP_SMARTREFLEX_H
-#define __ASM_ARM_OMAP_SMARTREFLEX_H
+#ifndef __POWER_SMARTREFLEX_H
+#define __POWER_SMARTREFLEX_H
 
+#include <linux/types.h>
 #include <linux/platform_device.h>
 
-#include "voltage.h"
+#include <plat/voltage.h>
 
 /*
  * Different Smartreflex IPs version. The v1 is the 65nm version used in
-- 
1.7.5.4

