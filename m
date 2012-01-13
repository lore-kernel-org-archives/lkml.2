Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2AMPUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:37 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:46157 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758353Ab2AMPUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:33 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/8] mfd/db8500-prcmu: update abstract dbx500 interface
Date: Fri, 13 Jan 2012 16:20:20 +0100
Message-ID: <1326468020-11756-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This prefixes a number of accessor functions with db8500_* since
they are DB8500-specific and we need to move to this naming
scheme.

We also replace numerous instances of machine_is() with cpu_is()
which covers the right type of ASICs rather than entire machines
i.e. boards.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   42 +++++-----
 include/linux/mfd/db8500-prcmu.h |   61 +++++++-------
 include/linux/mfd/dbx500-prcmu.h |  175 +++++++++++++++++++++++++++++++++-----
 3 files changed, 204 insertions(+), 74 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 1251993..5179abf 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -884,23 +884,23 @@ int db8500_prcmu_get_arm_opp(void)
 }
 
 /**
- * prcmu_get_ddr_opp - get the current DDR OPP
+ * db8500_prcmu_get_ddr_opp - get the current DDR OPP
  *
  * Returns: the current DDR OPP
  */
-int prcmu_get_ddr_opp(void)
+int db8500_prcmu_get_ddr_opp(void)
 {
 	return readb(PRCM_DDR_SUBSYS_APE_MINBW);
 }
 
 /**
- * set_ddr_opp - set the appropriate DDR OPP
+ * db8500_set_ddr_opp - set the appropriate DDR OPP
  * @opp: The new DDR operating point to which transition is to be made
  * Returns: 0 on success, non-zero on failure
  *
  * This function sets the operating point of the DDR.
  */
-int prcmu_set_ddr_opp(u8 opp)
+int db8500_prcmu_set_ddr_opp(u8 opp)
 {
 	if (opp < DDR_100_OPP || opp > DDR_25_OPP)
 		return -EINVAL;
@@ -911,13 +911,13 @@ int prcmu_set_ddr_opp(u8 opp)
 	return 0;
 }
 /**
- * set_ape_opp - set the appropriate APE OPP
+ * db8500_set_ape_opp - set the appropriate APE OPP
  * @opp: The new APE operating point to which transition is to be made
  * Returns: 0 on success, non-zero on failure
  *
  * This function sets the operating point of the APE.
  */
-int prcmu_set_ape_opp(u8 opp)
+int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	int r = 0;
 
@@ -943,11 +943,11 @@ int prcmu_set_ape_opp(u8 opp)
 }
 
 /**
- * prcmu_get_ape_opp - get the current APE OPP
+ * db8500_prcmu_get_ape_opp - get the current APE OPP
  *
  * Returns: the current APE OPP
  */
-int prcmu_get_ape_opp(void)
+int db8500_prcmu_get_ape_opp(void)
 {
 	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_APE_OPP);
 }
@@ -1451,7 +1451,7 @@ int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	return 0;
 }
 
-int prcmu_config_hotdog(u8 threshold)
+int db8500_prcmu_config_hotdog(u8 threshold)
 {
 	mutex_lock(&mb4_transfer.lock);
 
@@ -1469,7 +1469,7 @@ int prcmu_config_hotdog(u8 threshold)
 	return 0;
 }
 
-int prcmu_config_hotmon(u8 low, u8 high)
+int db8500_prcmu_config_hotmon(u8 low, u8 high)
 {
 	mutex_lock(&mb4_transfer.lock);
 
@@ -1508,7 +1508,7 @@ static int config_hot_period(u16 val)
 	return 0;
 }
 
-int prcmu_start_temp_sense(u16 cycles32k)
+int db8500_prcmu_start_temp_sense(u16 cycles32k)
 {
 	if (cycles32k == 0xFFFF)
 		return -EINVAL;
@@ -1516,7 +1516,7 @@ int prcmu_start_temp_sense(u16 cycles32k)
 	return config_hot_period(cycles32k);
 }
 
-int prcmu_stop_temp_sense(void)
+int db8500_prcmu_stop_temp_sense(void)
 {
 	return config_hot_period(0xFFFF);
 }
@@ -1545,7 +1545,7 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 
 }
 
-int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
 	BUG_ON(num == 0 || num > 0xf);
 	return prcmu_a9wdog(MB4H_A9WDOG_CONF, num, 0, 0,
@@ -1553,17 +1553,17 @@ int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 			    A9WDOG_AUTO_OFF_DIS);
 }
 
-int prcmu_enable_a9wdog(u8 id)
+int db8500_prcmu_enable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
 }
 
-int prcmu_disable_a9wdog(u8 id)
+int db8500_prcmu_disable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
 }
 
-int prcmu_kick_a9wdog(u8 id)
+int db8500_prcmu_kick_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
 }
@@ -1572,7 +1572,7 @@ int prcmu_kick_a9wdog(u8 id)
  * timeout is 28 bit, in ms.
  */
 #define MAX_WATCHDOG_TIMEOUT 131000
-int prcmu_load_a9wdog(u8 id, u32 timeout)
+int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 {
 	if (timeout > MAX_WATCHDOG_TIMEOUT)
 		/*
@@ -1825,9 +1825,9 @@ u16 db8500_prcmu_get_reset_code(void)
 }
 
 /**
- * prcmu_reset_modem - ask the PRCMU to reset modem
+ * db8500_prcmu_reset_modem - ask the PRCMU to reset modem
  */
-void prcmu_modem_reset(void)
+void db8500_prcmu_modem_reset(void)
 {
 	mutex_lock(&mb1_transfer.lock);
 
@@ -2147,7 +2147,7 @@ void __init db8500_prcmu_early_init(void)
 	}
 }
 
-static void __init db8500_prcmu_init_clkforce(void)
+static void __init init_prcm_registers(void)
 {
 	u32 val;
 
@@ -2405,7 +2405,7 @@ static int __init db8500_prcmu_probe(struct platform_device *pdev)
 	if (ux500_is_svp())
 		return -ENODEV;
 
-	db8500_prcmu_init_clkforce();
+	init_prcm_registers();
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
 	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 1895917..c5028f1 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -512,13 +512,9 @@ int prcmu_set_rc_a2p(enum romcode_write);
 enum romcode_read prcmu_get_rc_p2a(void);
 enum ap_pwrst prcmu_get_xp70_current_state(void);
 bool prcmu_has_arm_maxopp(void);
-int prcmu_set_ape_opp(u8 opp);
-int prcmu_get_ape_opp(void);
 struct prcmu_fw_version *prcmu_get_fw_version(void);
 int prcmu_request_ape_opp_100_voltage(bool enable);
 int prcmu_release_usb_wakeup_state(void);
-int prcmu_set_ddr_opp(u8 opp);
-int prcmu_get_ddr_opp(void);
 /* NOTE! Use regulator framework instead */
 int prcmu_set_hwacc(u16 hw_acc_dev, u8 state);
 void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
@@ -527,24 +523,24 @@ bool prcmu_is_auto_pm_enabled(void);
 
 int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
 int prcmu_set_clock_divider(u8 clock, u8 divider);
-int prcmu_config_hotdog(u8 threshold);
-int prcmu_config_hotmon(u8 low, u8 high);
-int prcmu_start_temp_sense(u16 cycles32k);
-int prcmu_stop_temp_sense(void);
+int db8500_prcmu_config_hotdog(u8 threshold);
+int db8500_prcmu_config_hotmon(u8 low, u8 high);
+int db8500_prcmu_start_temp_sense(u16 cycles32k);
+int db8500_prcmu_stop_temp_sense(void);
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 
 void prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
-void prcmu_modem_reset(void);
+void db8500_prcmu_modem_reset(void);
 void prcmu_enable_spi2(void);
 void prcmu_disable_spi2(void);
 
-int prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
-int prcmu_enable_a9wdog(u8 id);
-int prcmu_disable_a9wdog(u8 id);
-int prcmu_kick_a9wdog(u8 id);
-int prcmu_load_a9wdog(u8 id, u32 val);
+int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
+int db8500_prcmu_enable_a9wdog(u8 id);
+int db8500_prcmu_disable_a9wdog(u8 id);
+int db8500_prcmu_kick_a9wdog(u8 id);
+int db8500_prcmu_load_a9wdog(u8 id, u32 val);
 
 void db8500_prcmu_system_reset(u16 reset_code);
 int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
@@ -561,6 +557,10 @@ u16 db8500_prcmu_get_reset_code(void);
 bool db8500_prcmu_is_ac_wake_requested(void);
 int db8500_prcmu_set_arm_opp(u8 opp);
 int db8500_prcmu_get_arm_opp(void);
+int db8500_prcmu_set_ape_opp(u8 opp);
+int db8500_prcmu_get_ape_opp(void);
+int db8500_prcmu_set_ddr_opp(u8 opp);
+int db8500_prcmu_get_ddr_opp(void);
 
 #else /* !CONFIG_MFD_DB8500_PRCMU */
 
@@ -591,12 +591,12 @@ static inline struct prcmu_fw_version *prcmu_get_fw_version(void)
 	return NULL;
 }
 
-static inline int prcmu_set_ape_opp(u8 opp)
+static inline int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	return 0;
 }
 
-static inline int prcmu_get_ape_opp(void)
+static inline int db8500_prcmu_get_ape_opp(void)
 {
 	return APE_100_OPP;
 }
@@ -611,12 +611,12 @@ static inline int prcmu_release_usb_wakeup_state(void)
 	return 0;
 }
 
-static inline int prcmu_set_ddr_opp(u8 opp)
+static inline int db8500_prcmu_set_ddr_opp(u8 opp)
 {
 	return 0;
 }
 
-static inline int prcmu_get_ddr_opp(void)
+static inline int db8500_prcmu_get_ddr_opp(void)
 {
 	return DDR_100_OPP;
 }
@@ -625,7 +625,6 @@ static inline int prcmu_set_hwacc(u16 hw_acc_dev, u8 state)
 {
 	return 0;
 }
-
 static inline void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle)
 {
@@ -646,22 +645,22 @@ static inline int prcmu_set_clock_divider(u8 clock, u8 divider)
 	return 0;
 }
 
-static inline int prcmu_config_hotdog(u8 threshold)
+static inline int db8500_prcmu_config_hotdog(u8 threshold)
 {
 	return 0;
 }
 
-static inline int prcmu_config_hotmon(u8 low, u8 high)
+static inline int db8500_prcmu_config_hotmon(u8 low, u8 high)
 {
 	return 0;
 }
 
-static inline int prcmu_start_temp_sense(u16 cycles32k)
+static inline int db8500_prcmu_start_temp_sense(u16 cycles32k)
 {
 	return 0;
 }
 
-static inline int prcmu_stop_temp_sense(void)
+static inline int db8500_prcmu_stop_temp_sense(void)
 {
 	return 0;
 }
@@ -680,7 +679,9 @@ static inline void prcmu_ac_wake_req(void) {}
 
 static inline void prcmu_ac_sleep_req(void) {}
 
-static inline void prcmu_modem_reset(void) {}
+static inline void db8500_prcmu_modem_reset(void) {}
+
+static inline void db8500_prcmu_system_reset(u16 reset_code) {}
 
 static inline int prcmu_enable_spi2(void)
 {
@@ -692,8 +693,6 @@ static inline int prcmu_disable_spi2(void)
 	return 0;
 }
 
-static inline void db8500_prcmu_system_reset(u16 reset_code) {}
-
 static inline int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 	bool keep_ap_pll)
 {
@@ -741,27 +740,27 @@ static inline u16 db8500_prcmu_get_reset_code(void)
 	return 0;
 }
 
-static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+static inline int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
 	return 0;
 }
 
-static inline int prcmu_enable_a9wdog(u8 id)
+static inline int db8500_prcmu_enable_a9wdog(u8 id)
 {
 	return 0;
 }
 
-static inline int prcmu_disable_a9wdog(u8 id)
+static inline int db8500_prcmu_disable_a9wdog(u8 id)
 {
 	return 0;
 }
 
-static inline int prcmu_kick_a9wdog(u8 id)
+static inline int db8500_prcmu_kick_a9wdog(u8 id)
 {
 	return 0;
 }
 
-static inline int prcmu_load_a9wdog(u8 id, u32 val)
+static inline int db8500_prcmu_load_a9wdog(u8 id, u32 val)
 {
 	return 0;
 }
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index bac942f..f73b9d9 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -10,7 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
-#include <asm/mach-types.h>
+#include <linux/err.h>
 
 /* PRCMU Wakeup defines */
 enum prcmu_wakeup_index {
@@ -218,9 +218,11 @@ enum ddr_pwrst {
 
 #if defined(CONFIG_UX500_SOC_DB8500) || defined(CONFIG_UX500_SOC_DB5500)
 
+#include <mach/id.h>
+
 static inline void __init prcmu_early_init(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_early_init();
 	else
 		return db8500_prcmu_early_init();
@@ -229,7 +231,7 @@ static inline void __init prcmu_early_init(void)
 static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 		bool keep_ap_pll)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_set_power_state(state, keep_ulp_clk,
 			keep_ap_pll);
 	else
@@ -239,7 +241,7 @@ static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return -EINVAL;
 	else
 		return db8500_prcmu_set_epod(epod_id, epod_state);
@@ -247,7 +249,7 @@ static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 
 static inline void prcmu_enable_wakeups(u32 wakeups)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		db5500_prcmu_enable_wakeups(wakeups);
 	else
 		db8500_prcmu_enable_wakeups(wakeups);
@@ -260,7 +262,7 @@ static inline void prcmu_disable_wakeups(void)
 
 static inline void prcmu_config_abb_event_readout(u32 abb_events)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		db5500_prcmu_config_abb_event_readout(abb_events);
 	else
 		db8500_prcmu_config_abb_event_readout(abb_events);
@@ -268,7 +270,7 @@ static inline void prcmu_config_abb_event_readout(u32 abb_events)
 
 static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		db5500_prcmu_get_abb_event_buffer(buf);
 	else
 		db8500_prcmu_get_abb_event_buffer(buf);
@@ -281,20 +283,34 @@ int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
 
 static inline int prcmu_request_clock(u8 clock, bool enable)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_request_clock(clock, enable);
 	else
 		return db8500_prcmu_request_clock(clock, enable);
 }
 
-int prcmu_set_ape_opp(u8 opp);
-int prcmu_get_ape_opp(void);
-int prcmu_set_ddr_opp(u8 opp);
-int prcmu_get_ddr_opp(void);
+unsigned long prcmu_clock_rate(u8 clock);
+long prcmu_round_clock_rate(u8 clock, unsigned long rate);
+int prcmu_set_clock_rate(u8 clock, unsigned long rate);
+
+static inline int prcmu_set_ddr_opp(u8 opp)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_set_ddr_opp(opp);
+}
+static inline int prcmu_get_ddr_opp(void)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_get_ddr_opp();
+}
 
 static inline int prcmu_set_arm_opp(u8 opp)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return -EINVAL;
 	else
 		return db8500_prcmu_set_arm_opp(opp);
@@ -302,15 +318,31 @@ static inline int prcmu_set_arm_opp(u8 opp)
 
 static inline int prcmu_get_arm_opp(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return -EINVAL;
 	else
 		return db8500_prcmu_get_arm_opp();
 }
 
+static inline int prcmu_set_ape_opp(u8 opp)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_set_ape_opp(opp);
+}
+
+static inline int prcmu_get_ape_opp(void)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_get_ape_opp();
+}
+
 static inline void prcmu_system_reset(u16 reset_code)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_system_reset(reset_code);
 	else
 		return db8500_prcmu_system_reset(reset_code);
@@ -318,7 +350,7 @@ static inline void prcmu_system_reset(u16 reset_code)
 
 static inline u16 prcmu_get_reset_code(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_get_reset_code();
 	else
 		return db8500_prcmu_get_reset_code();
@@ -326,10 +358,17 @@ static inline u16 prcmu_get_reset_code(void)
 
 void prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
-void prcmu_modem_reset(void);
+static inline void prcmu_modem_reset(void)
+{
+	if (cpu_is_u5500())
+		return;
+	else
+		return db8500_prcmu_modem_reset();
+}
+
 static inline bool prcmu_is_ac_wake_requested(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_is_ac_wake_requested();
 	else
 		return db8500_prcmu_is_ac_wake_requested();
@@ -337,7 +376,7 @@ static inline bool prcmu_is_ac_wake_requested(void)
 
 static inline int prcmu_set_display_clocks(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_set_display_clocks();
 	else
 		return db8500_prcmu_set_display_clocks();
@@ -345,7 +384,7 @@ static inline int prcmu_set_display_clocks(void)
 
 static inline int prcmu_disable_dsipll(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_disable_dsipll();
 	else
 		return db8500_prcmu_disable_dsipll();
@@ -353,7 +392,7 @@ static inline int prcmu_disable_dsipll(void)
 
 static inline int prcmu_enable_dsipll(void)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return db5500_prcmu_enable_dsipll();
 	else
 		return db8500_prcmu_enable_dsipll();
@@ -361,11 +400,83 @@ static inline int prcmu_enable_dsipll(void)
 
 static inline int prcmu_config_esram0_deep_sleep(u8 state)
 {
-	if (machine_is_u5500())
+	if (cpu_is_u5500())
 		return -EINVAL;
 	else
 		return db8500_prcmu_config_esram0_deep_sleep(state);
 }
+
+static inline int prcmu_config_hotdog(u8 threshold)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_config_hotdog(threshold);
+}
+
+static inline int prcmu_config_hotmon(u8 low, u8 high)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_config_hotmon(low, high);
+}
+
+static inline int prcmu_start_temp_sense(u16 cycles32k)
+{
+	if (cpu_is_u5500())
+		return  -EINVAL;
+	else
+		return  db8500_prcmu_start_temp_sense(cycles32k);
+}
+
+static inline int prcmu_stop_temp_sense(void)
+{
+	if (cpu_is_u5500())
+		return  -EINVAL;
+	else
+		return  db8500_prcmu_stop_temp_sense();
+}
+
+static inline int prcmu_enable_a9wdog(u8 id)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_enable_a9wdog(id);
+}
+
+static inline int prcmu_disable_a9wdog(u8 id)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_disable_a9wdog(id);
+}
+
+static inline int prcmu_kick_a9wdog(u8 id)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_kick_a9wdog(id);
+}
+
+static inline int prcmu_load_a9wdog(u8 id, u32 timeout)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_load_a9wdog(id, timeout);
+}
+
+static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_config_a9wdog(num, sleep_auto_off);
+}
 #else
 
 static inline void __init prcmu_early_init(void) {}
@@ -480,6 +591,26 @@ static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
 	*buf = NULL;
 }
 
+static inline int prcmu_config_hotdog(u8 threshold)
+{
+	return 0;
+}
+
+static inline int prcmu_config_hotmon(u8 low, u8 high)
+{
+	return 0;
+}
+
+static inline int prcmu_start_temp_sense(u16 cycles32k)
+{
+	return 0;
+}
+
+static inline int prcmu_stop_temp_sense(void)
+{
+	return 0;
+}
+
 #endif
 
 /* PRCMU QoS APE OPP class */
-- 
1.7.8

