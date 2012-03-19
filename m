Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162117Ab2CSQU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:20:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab2CSQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:13:20 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 1/9] ARM: OMAP3+: voltage: export functions to plat/voltage.h
Date: Mon, 19 Mar 2012 17:12:50 +0100
Message-Id: <1332173578-27422-2-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Move some functions from mach-omap2/ dir to the plat/ dir.
The SmartReflex class driver is a user of the basic voltage domains
functions (enable, disable, reset).

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c  |    1 +
 arch/arm/mach-omap2/smartreflex.h         |    2 +-
 arch/arm/mach-omap2/voltage.h             |    1 -
 arch/arm/mach-omap2/vp.h                  |    2 --
 arch/arm/plat-omap/include/plat/voltage.h |    3 +++
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index 955566e..e12c51e 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -12,6 +12,7 @@
  */
 
 #include "smartreflex.h"
+#include "voltage.h"
 
 static int sr_class3_enable(struct voltagedomain *voltdm)
 {
diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
index 5809141..c4e8530 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/arch/arm/mach-omap2/smartreflex.h
@@ -22,7 +22,7 @@
 
 #include <linux/platform_device.h>
 
-#include "voltage.h"
+#include <plat/voltage.h>
 
 /*
  * Different Smartreflex IPs version. The v1 is the 65nm version used in
diff --git a/arch/arm/mach-omap2/voltage.h b/arch/arm/mach-omap2/voltage.h
index 16a1b09..a81dea8 100644
--- a/arch/arm/mach-omap2/voltage.h
+++ b/arch/arm/mach-omap2/voltage.h
@@ -167,6 +167,5 @@ int voltdm_for_each_pwrdm(struct voltagedomain *voltdm,
 			  int (*fn)(struct voltagedomain *voltdm,
 				    struct powerdomain *pwrdm));
 int voltdm_scale(struct voltagedomain *voltdm, unsigned long target_volt);
-void voltdm_reset(struct voltagedomain *voltdm);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm);
 #endif
diff --git a/arch/arm/mach-omap2/vp.h b/arch/arm/mach-omap2/vp.h
index 7c155d2..837cb8d 100644
--- a/arch/arm/mach-omap2/vp.h
+++ b/arch/arm/mach-omap2/vp.h
@@ -118,8 +118,6 @@ extern struct omap_vp_instance omap4_vp_iva;
 extern struct omap_vp_instance omap4_vp_core;
 
 void omap_vp_init(struct voltagedomain *voltdm);
-void omap_vp_enable(struct voltagedomain *voltdm);
-void omap_vp_disable(struct voltagedomain *voltdm);
 int omap_vp_forceupdate_scale(struct voltagedomain *voltdm,
 			      unsigned long target_volt);
 int omap_vp_update_errorgain(struct voltagedomain *voltdm,
diff --git a/arch/arm/plat-omap/include/plat/voltage.h b/arch/arm/plat-omap/include/plat/voltage.h
index 0a6a482..1842709 100644
--- a/arch/arm/plat-omap/include/plat/voltage.h
+++ b/arch/arm/plat-omap/include/plat/voltage.h
@@ -16,5 +16,8 @@ struct voltagedomain;
 struct voltagedomain *voltdm_lookup(const char *name);
 int voltdm_scale(struct voltagedomain *voltdm, unsigned long target_volt);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm);
+void voltdm_reset(struct voltagedomain *voltdm);
 
+void omap_vp_enable(struct voltagedomain *voltdm);
+void omap_vp_disable(struct voltagedomain *voltdm);
 #endif
-- 
1.7.5.4

