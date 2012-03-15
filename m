Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031884Ab2COQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:48:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47749 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031769Ab2COQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:24 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 01/10] ARM: OMAP3+: voltage: export functions to plat/voltage.h
Date: Thu, 15 Mar 2012 17:43:56 +0100
Message-Id: <1331829845-9526-2-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
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
 arch/arm/mach-omap2/voltage.h             |    1 -
 arch/arm/mach-omap2/vp.h                  |    2 --
 arch/arm/plat-omap/include/plat/voltage.h |    3 +++
 3 files changed, 3 insertions(+), 3 deletions(-)

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

