Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab1GDLKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:10:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46948 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab1GDLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:10:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: paul@pwsan.com, b-cousson@ti.com, vishwanath.bs@ti.com, p-basak2@ti.com,
        peter.ujfalusi@ti.com, jhnikula@gmail.com, kishon@ti.com, charu@ti.com
Subject: [PATCH v3 1/2] OMAP: omap_hwmod: API to modify AUTOIDLE and SMARTIDLE bits
Date: Mon, 4 Jul 2011 16:38:32 +0530
Message-ID: <1309777713-17528-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309777713-17528-1-git-send-email-kishon@ti.com>
References: <1309777713-17528-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide APIs to be used by the omap_device layer in order to modify AUTOIDLE
and SIDLE bits.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod.c             |   93 ++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |   11 +++
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index e034294..a1b13e8 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -1340,6 +1340,34 @@ int omap_hwmod_set_ocp_autoidle(struct omap_hwmod *oh, u8 autoidle)
 }
 
 /**
+ * omap_hwmod_enable_autoidle - set the hwmod's OCP autoidle bit
+ * @oh: struct omap_hwmod *
+ *
+ * Sets the IP block's OCP autoidle bit in hardware.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.
+ * Returns the return value from omap_hwmod_set_ocp_autoidle.
+ */
+int omap_hwmod_enable_autoidle(struct omap_hwmod *oh)
+{
+	return omap_hwmod_set_ocp_autoidle(oh, HWMOD_IDLEMODE_ENABLEAUTO);
+}
+
+/**
+ * omap_hwmod_disable_autoidle - reset the hwmod's OCP autoidle bit
+ * @oh: struct omap_hwmod *
+ *
+ * Resets the IP block's OCP autoidle bit in hardware.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.
+ * Returns the return value from omap_hwmod_set_ocp_autoidle.
+ */
+int omap_hwmod_disable_autoidle(struct omap_hwmod *oh)
+{
+	return omap_hwmod_set_ocp_autoidle(oh, HWMOD_IDLEMODE_DISABLEAUTO);
+}
+
+/**
  * _shutdown - shutdown an omap_hwmod
  * @oh: struct omap_hwmod *
  *
@@ -1594,6 +1622,71 @@ int omap_hwmod_set_slave_idlemode(struct omap_hwmod *oh, u8 idlemode)
 }
 
 /**
+ * omap_hwmod_noidle - set the hwmod's slave idlemode to no idle
+ * @oh: struct omap_hwmod *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to no idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.
+ * Returns the return value from omap_hwmod_set_slave_idlemode().
+ */
+int omap_hwmod_noidle(struct omap_hwmod *oh)
+{
+	return omap_hwmod_set_slave_idlemode(oh, HWMOD_IDLEMODE_NO);
+}
+
+/**
+ * omap_hwmod_smartidle - set the hwmod's slave idlemode to smart idle
+ * @oh: struct omap_hwmod *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to smart idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.
+ * Returns the return value from omap_hwmod_set_slave_idlemode().
+ */
+int omap_hwmod_smartidle(struct omap_hwmod *oh)
+{
+	return omap_hwmod_set_slave_idlemode(oh, HWMOD_IDLEMODE_SMART);
+}
+
+/**
+ * omap_hwmod_forceidle - set the hwmod's slave idlemode to force idle
+ * @oh: struct omap_hwmod *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to force idle.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits.
+ * Returns the return value from omap_hwmod_set_slave_idlemode().
+ */
+int omap_hwmod_forceidle(struct omap_hwmod *oh)
+{
+	return omap_hwmod_set_slave_idlemode(oh, HWMOD_IDLEMODE_FORCE);
+}
+
+/**
+ * omap_hwmod_default_idle - set the hwmod's slave idlemode to no idle or
+ * smart idle based on the hwmod flag
+ * @oh: struct omap_hwmod *
+ *
+ * Sets the IP block's OCP slave idlemode in hardware to no idle or smart idle
+ * based on the hwmod flag.
+ * Intended to be used by drivers that have some erratum that requires direct
+ * manipulation of the SIDLEMODE bits. Returns -EINVAL if @oh is NULL,
+ * or passes along the return value from omap_hwmod_set_slave_idlemode().
+ */
+int omap_hwmod_default_idle(struct omap_hwmod *oh)
+{
+	u8 idlemode;
+
+	if (!oh)
+		return -EINVAL;
+
+	idlemode = (oh->flags & HWMOD_SWSUP_SIDLE) ?
+				HWMOD_IDLEMODE_NO : HWMOD_IDLEMODE_SMART;
+	return omap_hwmod_set_slave_idlemode(oh, idlemode);
+}
+
+/**
  * omap_hwmod_lookup - look up a registered omap_hwmod by name
  * @name: name of the omap_hwmod to look up
  *
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index 1adea9c..166a866 100644
--- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
+++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
@@ -80,6 +80,9 @@ extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type2;
 /* Slave idle mode flag only */
 #define HWMOD_IDLEMODE_SMART_WKUP	(1 << 3)
 
+#define HWMOD_IDLEMODE_ENABLEAUTO	(1 << 0)
+#define HWMOD_IDLEMODE_DISABLEAUTO	0x0
+
 /**
  * struct omap_hwmod_mux_info - hwmod specific mux configuration
  * @pads:              array of omap_device_pad entries
@@ -567,6 +570,14 @@ int omap_hwmod_disable_clocks(struct omap_hwmod *oh);
 int omap_hwmod_set_slave_idlemode(struct omap_hwmod *oh, u8 idlemode);
 int omap_hwmod_set_ocp_autoidle(struct omap_hwmod *oh, u8 autoidle);
 
+int omap_hwmod_noidle(struct omap_hwmod *oh);
+int omap_hwmod_smartidle(struct omap_hwmod *oh);
+int omap_hwmod_forceidle(struct omap_hwmod *oh);
+int omap_hwmod_default_idle(struct omap_hwmod *oh);
+
+int omap_hwmod_enable_autoidle(struct omap_hwmod *oh);
+int omap_hwmod_disable_autoidle(struct omap_hwmod *oh);
+
 int omap_hwmod_reset(struct omap_hwmod *oh);
 void omap_hwmod_ocp_barrier(struct omap_hwmod *oh);
 
-- 
1.7.0.4

