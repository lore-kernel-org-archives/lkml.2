Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2DBPzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:55:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63538 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2DBPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:55:49 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: sameo@linux.intel.com
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd : dbx500 : fix compilation error
Date: Mon,  2 Apr 2012 17:55:48 +0200
Message-Id: <1333382148-14137-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ux500 default config enables the db5500 and the db8500.
The incoming cpuidle driver uses the 'prcmu_enable_wakeups'
and the 'prcmu_set_power_state' functions but these ones
are defined but not implemented for the db5500, leading to
an unresolved symbol error at link time. In order to compile,
we have to disable the db5500 support which is not acceptable
for the default config.

I noticed there are also some other functions which are
defined but not implemented.

This patch fix this by removing the functions definitions
and move out of the config section the empty functions which
are normally used when the DB550 config is disabled.
Only the functions which are not implemented are concerned
by this modification.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/mfd/db5500-prcmu.h |   88 ++++++++++++++++----------------------
 1 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/include/linux/mfd/db5500-prcmu.h b/include/linux/mfd/db5500-prcmu.h
index 9890687..5a049df 100644
--- a/include/linux/mfd/db5500-prcmu.h
+++ b/include/linux/mfd/db5500-prcmu.h
@@ -8,41 +8,14 @@
 #ifndef __MFD_DB5500_PRCMU_H
 #define __MFD_DB5500_PRCMU_H
 
-#ifdef CONFIG_MFD_DB5500_PRCMU
-
-void db5500_prcmu_early_init(void);
-int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state);
-int db5500_prcmu_set_display_clocks(void);
-int db5500_prcmu_disable_dsipll(void);
-int db5500_prcmu_enable_dsipll(void);
-int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
-int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
-void db5500_prcmu_enable_wakeups(u32 wakeups);
-int db5500_prcmu_request_clock(u8 clock, bool enable);
-void db5500_prcmu_config_abb_event_readout(u32 abb_events);
-void db5500_prcmu_get_abb_event_buffer(void __iomem **buf);
-int prcmu_resetout(u8 resoutn, u8 state);
-int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll);
-int db5500_prcmu_config_esram0_deep_sleep(u8 state);
-void db5500_prcmu_system_reset(u16 reset_code);
-u16 db5500_prcmu_get_reset_code(void);
-bool db5500_prcmu_is_ac_wake_requested(void);
-int db5500_prcmu_set_arm_opp(u8 opp);
-int db5500_prcmu_get_arm_opp(void);
-
-#else /* !CONFIG_UX500_SOC_DB5500 */
-
-static inline void db5500_prcmu_early_init(void) {}
-
-static inline int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+static inline int prcmu_resetout(u8 resoutn, u8 state)
 {
-	return -ENOSYS;
+	return 0;
 }
 
-static inline int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+static inline int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
-	return -ENOSYS;
+	return 0;
 }
 
 static inline int db5500_prcmu_request_clock(u8 clock, bool enable)
@@ -50,69 +23,82 @@ static inline int db5500_prcmu_request_clock(u8 clock, bool enable)
 	return 0;
 }
 
-static inline int db5500_prcmu_set_display_clocks(void)
+static inline int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+	bool keep_ap_pll)
 {
 	return 0;
 }
 
-static inline int db5500_prcmu_disable_dsipll(void)
+static inline int db5500_prcmu_config_esram0_deep_sleep(u8 state)
 {
 	return 0;
 }
 
-static inline int db5500_prcmu_enable_dsipll(void)
+static inline u16 db5500_prcmu_get_reset_code(void)
 {
 	return 0;
 }
 
-static inline int db5500_prcmu_config_esram0_deep_sleep(u8 state)
+static inline bool db5500_prcmu_is_ac_wake_requested(void)
 {
 	return 0;
 }
 
-static inline void db5500_prcmu_enable_wakeups(u32 wakeups) {}
-
-static inline int prcmu_resetout(u8 resoutn, u8 state)
+static inline int db5500_prcmu_set_arm_opp(u8 opp)
 {
 	return 0;
 }
 
-static inline int db5500_prcmu_set_epod(u16 epod_id, u8 epod_state)
+static inline int db5500_prcmu_get_arm_opp(void)
 {
 	return 0;
 }
 
-static inline void db5500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
 static inline void db5500_prcmu_config_abb_event_readout(u32 abb_events) {}
 
-static inline int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll)
-{
-	return 0;
-}
+static inline void db5500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
 
 static inline void db5500_prcmu_system_reset(u16 reset_code) {}
 
-static inline u16 db5500_prcmu_get_reset_code(void)
+static inline void db5500_prcmu_enable_wakeups(u32 wakeups) {}
+
+#ifdef CONFIG_MFD_DB5500_PRCMU
+
+void db5500_prcmu_early_init(void);
+int db5500_prcmu_set_display_clocks(void);
+int db5500_prcmu_disable_dsipll(void);
+int db5500_prcmu_enable_dsipll(void);
+int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
+int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+
+#else /* !CONFIG_UX500_SOC_DB5500 */
+
+static inline void db5500_prcmu_early_init(void) {}
+
+static inline int db5500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 {
-	return 0;
+	return -ENOSYS;
 }
 
-static inline bool db5500_prcmu_is_ac_wake_requested(void)
+static inline int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 {
-	return 0;
+	return -ENOSYS;
 }
 
-static inline int db5500_prcmu_set_arm_opp(u8 opp)
+static inline int db5500_prcmu_set_display_clocks(void)
 {
 	return 0;
 }
 
-static inline int db5500_prcmu_get_arm_opp(void)
+static inline int db5500_prcmu_disable_dsipll(void)
 {
 	return 0;
 }
 
+static inline int db5500_prcmu_enable_dsipll(void)
+{
+	return 0;
+}
 
 #endif /* CONFIG_MFD_DB5500_PRCMU */
 
-- 
1.7.5.4

