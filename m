Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2IYQQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:16:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48198 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab2IYQOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:19 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 53/57] power: ab8500_fg: Moving structure definitions to header file
Date: Tue, 25 Sep 2012 10:12:50 -0600
Message-Id: <1348589574-25655-54-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/ab8500_fg.c |  196 +------------------------------------------
 drivers/power/ab8500_fg.h |  201 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 206 insertions(+), 191 deletions(-)
 create mode 100644 drivers/power/ab8500_fg.h

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 5b5c7ea..145c1f1 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -32,51 +32,7 @@
 #include <linux/time.h>
 #include <linux/completion.h>
 #include <linux/kernel.h>
-
-#define MILLI_TO_MICRO			1000
-#define FG_LSB_IN_MA			1627
-#define QLSB_NANO_AMP_HOURS_X10		1129
-#define INS_CURR_TIMEOUT		(3 * HZ)
-
-#define SEC_TO_SAMPLE(S)		(S * 4)
-
-#define NBR_AVG_SAMPLES			20
-
-#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
-
-#define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
-#define BATT_OK_MIN			2360 /* mV */
-#define BATT_OK_INCREMENT		50 /* mV */
-#define BATT_OK_MAX_NR_INCREMENTS	0xE
-
-/* FG constants */
-#define BATT_OVV			0x01
-
-#define interpolate(x, x1, y1, x2, y2) \
-	((y1) + ((((y2) - (y1)) * ((x) - (x1))) / ((x2) - (x1))));
-
-#define to_ab8500_fg_device_info(x) container_of((x), \
-	struct ab8500_fg, fg_psy);
-
-/**
- * struct ab8500_fg_interrupts - ab8500 fg interupts
- * @name:	name of the interrupt
- * @isr		function pointer to the isr
- */
-struct ab8500_fg_interrupts {
-	char *name;
-	irqreturn_t (*isr)(int irq, void *data);
-};
-
-enum ab8500_fg_discharge_state {
-	AB8500_FG_DISCHARGE_INIT,
-	AB8500_FG_DISCHARGE_INITMEASURING,
-	AB8500_FG_DISCHARGE_INIT_RECOVERY,
-	AB8500_FG_DISCHARGE_RECOVERY,
-	AB8500_FG_DISCHARGE_READOUT_INIT,
-	AB8500_FG_DISCHARGE_READOUT,
-	AB8500_FG_DISCHARGE_WAKEUP,
-};
+#include "ab8500_fg.h"
 
 static char *discharge_state[] = {
 	"DISCHARGE_INIT",
@@ -87,159 +43,17 @@ static char *discharge_state[] = {
 	"DISCHARGE_READOUT",
 	"DISCHARGE_WAKEUP",
 };
-
-enum ab8500_fg_charge_state {
-	AB8500_FG_CHARGE_INIT,
-	AB8500_FG_CHARGE_READOUT,
-};
-
 static char *charge_state[] = {
 	"CHARGE_INIT",
 	"CHARGE_READOUT",
 };
 
-enum ab8500_fg_calibration_state {
-	AB8500_FG_CALIB_INIT,
-	AB8500_FG_CALIB_WAIT,
-	AB8500_FG_CALIB_END,
-};
-
-struct ab8500_fg_avg_cap {
-	int avg;
-	int samples[NBR_AVG_SAMPLES];
-	__kernel_time_t time_stamps[NBR_AVG_SAMPLES];
-	int pos;
-	int nbr_samples;
-	int sum;
-};
-
-struct ab8500_fg_cap_scaling {
-	bool enable;
-	int cap_to_scale[2];
-	int disable_cap_level;
-	int scaled_cap;
-};
-
-struct ab8500_fg_battery_capacity {
-	int max_mah_design;
-	int max_mah;
-	int mah;
-	int permille;
-	int level;
-	int prev_mah;
-	int prev_percent;
-	int prev_level;
-	int user_mah;
-	struct ab8500_fg_cap_scaling cap_scale;
-};
-
-struct ab8500_fg_flags {
-	bool fg_enabled;
-	bool conv_done;
-	bool charging;
-	bool fully_charged;
-	bool force_full;
-	bool low_bat_delay;
-	bool low_bat;
-	bool bat_ovv;
-	bool batt_unknown;
-	bool calibrate;
-	bool user_cap;
-	bool batt_id_received;
-};
+#define interpolate(x, x1, y1, x2, y2) \
+	((y1) + ((((y2) - (y1)) * ((x) - (x1))) / ((x2) - (x1))));
 
-struct inst_curr_result_list {
-	struct list_head list;
-	int *result;
-};
+#define to_ab8500_fg_device_info(x) container_of((x), \
+	struct ab8500_fg, fg_psy);
 
-/**
- * struct ab8500_fg - ab8500 FG device information
- * @dev:		Pointer to the structure device
- * @node:		a list of AB8500 FGs, hence prepared for reentrance
- * @irq			holds the CCEOC interrupt number
- * @vbat:		Battery voltage in mV
- * @vbat_nom:		Nominal battery voltage in mV
- * @inst_curr:		Instantenous battery current in mA
- * @avg_curr:		Average battery current in mA
- * @bat_temp		battery temperature
- * @fg_samples:		Number of samples used in the FG accumulation
- * @accu_charge:	Accumulated charge from the last conversion
- * @recovery_cnt:	Counter for recovery mode
- * @high_curr_cnt:	Counter for high current mode
- * @init_cnt:		Counter for init mode
- * @low_bat_cnt		Counter for number of consecutive low battery measures
- * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
- * @recovery_needed:	Indicate if recovery is needed
- * @high_curr_mode:	Indicate if we're in high current mode
- * @init_capacity:	Indicate if initial capacity measuring should be done
- * @turn_off_fg:	True if fg was off before current measurement
- * @calib_state		State during offset calibration
- * @discharge_state:	Current discharge state
- * @charge_state:	Current charge state
- * @ab8500_fg_started	Completion struct used for the instant current start
- * @ab8500_fg_complete	Completion struct used for the instant current reading
- * @flags:		Structure for information about events triggered
- * @bat_cap:		Structure for battery capacity specific parameters
- * @avg_cap:		Average capacity filter
- * @parent:		Pointer to the struct ab8500
- * @gpadc:		Pointer to the struct gpadc
- * @pdata:		Pointer to the abx500_fg platform data
- * @bat:		Pointer to the abx500_bm platform data
- * @fg_psy:		Structure that holds the FG specific battery properties
- * @fg_wq:		Work queue for running the FG algorithm
- * @fg_periodic_work:	Work to run the FG algorithm periodically
- * @fg_low_bat_work:	Work to check low bat condition
- * @fg_reinit_work	Work used to reset and reinitialise the FG algorithm
- * @fg_work:		Work to run the FG algorithm instantly
- * @fg_acc_cur_work:	Work to read the FG accumulator
- * @fg_check_hw_failure_work:	Work for checking HW state
- * @cc_lock:		Mutex for locking the CC
- * @fg_kobject:		Structure of type kobject
- */
-struct ab8500_fg {
-	struct device *dev;
-	struct list_head node;
-	int irq;
-	int vbat;
-	int vbat_nom;
-	int inst_curr;
-	int avg_curr;
-	int bat_temp;
-	int fg_samples;
-	int accu_charge;
-	int recovery_cnt;
-	int high_curr_cnt;
-	int init_cnt;
-	int low_bat_cnt;
-	int nbr_cceoc_irq_cnt;
-	bool recovery_needed;
-	bool high_curr_mode;
-	bool init_capacity;
-	bool turn_off_fg;
-	enum ab8500_fg_calibration_state calib_state;
-	enum ab8500_fg_discharge_state discharge_state;
-	enum ab8500_fg_charge_state charge_state;
-	struct completion ab8500_fg_started;
-	struct completion ab8500_fg_complete;
-	struct ab8500_fg_flags flags;
-	struct ab8500_fg_battery_capacity bat_cap;
-	struct ab8500_fg_avg_cap avg_cap;
-	struct ab8500 *parent;
-	struct ab8500_gpadc *gpadc;
-	struct abx500_fg_platform_data *pdata;
-	struct abx500_bm_data *bat;
-	struct power_supply fg_psy;
-	struct workqueue_struct *fg_wq;
-	struct delayed_work fg_periodic_work;
-	struct delayed_work fg_low_bat_work;
-	struct delayed_work fg_reinit_work;
-	struct work_struct fg_work;
-	struct work_struct fg_acc_cur_work;
-	struct delayed_work fg_check_hw_failure_work;
-	struct mutex cc_lock;
-	struct kobject fg_kobject;
-};
 static LIST_HEAD(ab8500_fg_list);
 
 /**
diff --git a/drivers/power/ab8500_fg.h b/drivers/power/ab8500_fg.h
new file mode 100644
index 0000000..5cfadc2
--- /dev/null
+++ b/drivers/power/ab8500_fg.h
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ *
+ * Main and Back-up battery management driver.
+ *
+ * Note: Backup battery management is required in case of Li-Ion battery and not
+ * for capacitive battery. HREF boards have capacitive battery and hence backup
+ * battery management is not used and the supported code is available in this
+ * driver.
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Johan Palsson <johan.palsson@stericsson.com>
+ * Author: Karl Komierowski <karl.komierowski@stericsson.com>
+ */
+
+#define MILLI_TO_MICRO			1000
+#define FG_LSB_IN_MA			1627
+#define QLSB_NANO_AMP_HOURS_X10		1129
+#define INS_CURR_TIMEOUT		(3 * HZ)
+
+#define SEC_TO_SAMPLE(S)		(S * 4)
+
+#define NBR_AVG_SAMPLES			20
+
+#define LOW_BAT_CHECK_INTERVAL		(HZ / 16) /* 62.5 ms */
+
+#define VALID_CAPACITY_SEC		(45 * 60) /* 45 minutes */
+#define BATT_OK_MIN			2360 /* mV */
+#define BATT_OK_INCREMENT		50 /* mV */
+#define BATT_OK_MAX_NR_INCREMENTS	0xE
+
+/* FG constants */
+#define BATT_OVV			0x01
+
+/**
+ * struct ab8500_fg_interrupts - ab8500 fg interupts
+ * @name:	name of the interrupt
+ * @isr		function pointer to the isr
+ */
+struct ab8500_fg_interrupts {
+	char *name;
+	irqreturn_t (*isr)(int irq, void *data);
+};
+
+enum ab8500_fg_discharge_state {
+	AB8500_FG_DISCHARGE_INIT,
+	AB8500_FG_DISCHARGE_INITMEASURING,
+	AB8500_FG_DISCHARGE_INIT_RECOVERY,
+	AB8500_FG_DISCHARGE_RECOVERY,
+	AB8500_FG_DISCHARGE_READOUT_INIT,
+	AB8500_FG_DISCHARGE_READOUT,
+	AB8500_FG_DISCHARGE_WAKEUP,
+};
+
+enum ab8500_fg_charge_state {
+	AB8500_FG_CHARGE_INIT,
+	AB8500_FG_CHARGE_READOUT,
+};
+
+enum ab8500_fg_calibration_state {
+	AB8500_FG_CALIB_INIT,
+	AB8500_FG_CALIB_WAIT,
+	AB8500_FG_CALIB_END,
+};
+
+struct ab8500_fg_avg_cap {
+	int avg;
+	int samples[NBR_AVG_SAMPLES];
+	__kernel_time_t time_stamps[NBR_AVG_SAMPLES];
+	int pos;
+	int nbr_samples;
+	int sum;
+};
+
+struct ab8500_fg_cap_scaling {
+	bool enable;
+	int cap_to_scale[2];
+	int disable_cap_level;
+	int scaled_cap;
+};
+
+struct ab8500_fg_battery_capacity {
+	int max_mah_design;
+	int max_mah;
+	int mah;
+	int permille;
+	int level;
+	int prev_mah;
+	int prev_percent;
+	int prev_level;
+	int user_mah;
+	struct ab8500_fg_cap_scaling cap_scale;
+};
+
+struct ab8500_fg_flags {
+	bool fg_enabled;
+	bool conv_done;
+	bool charging;
+	bool fully_charged;
+	bool force_full;
+	bool low_bat_delay;
+	bool low_bat;
+	bool bat_ovv;
+	bool batt_unknown;
+	bool calibrate;
+	bool user_cap;
+	bool batt_id_received;
+};
+
+struct inst_curr_result_list {
+	struct list_head list;
+	int *result;
+};
+
+/**
+ * struct ab8500_fg - ab8500 FG device information
+ * @dev:		Pointer to the structure device
+ * @node:		a list of AB8500 FGs, hence prepared for reentrance
+ * @irq			holds the CCEOC interrupt number
+ * @vbat:		Battery voltage in mV
+ * @vbat_nom:		Nominal battery voltage in mV
+ * @inst_curr:		Instantenous battery current in mA
+ * @avg_curr:		Average battery current in mA
+ * @bat_temp		battery temperature
+ * @fg_samples:		Number of samples used in the FG accumulation
+ * @accu_charge:	Accumulated charge from the last conversion
+ * @recovery_cnt:	Counter for recovery mode
+ * @high_curr_cnt:	Counter for high current mode
+ * @init_cnt:		Counter for init mode
+ * @low_bat_cnt		Counter for number of consecutive low battery measures
+ * @nbr_cceoc_irq_cnt	Counter for number of CCEOC irqs received since enabled
+ * @recovery_needed:	Indicate if recovery is needed
+ * @high_curr_mode:	Indicate if we're in high current mode
+ * @init_capacity:	Indicate if initial capacity measuring should be done
+ * @turn_off_fg:	True if fg was off before current measurement
+ * @calib_state		State during offset calibration
+ * @discharge_state:	Current discharge state
+ * @charge_state:	Current charge state
+ * @ab8500_fg_started	Completion struct used for the instant current start
+ * @ab8500_fg_complete	Completion struct used for the instant current reading
+ * @flags:		Structure for information about events triggered
+ * @bat_cap:		Structure for battery capacity specific parameters
+ * @avg_cap:		Average capacity filter
+ * @parent:		Pointer to the struct ab8500
+ * @gpadc:		Pointer to the struct gpadc
+ * @pdata:		Pointer to the abx500_fg platform data
+ * @bat:		Pointer to the abx500_bm platform data
+ * @fg_psy:		Structure that holds the FG specific battery properties
+ * @fg_wq:		Work queue for running the FG algorithm
+ * @fg_periodic_work:	Work to run the FG algorithm periodically
+ * @fg_low_bat_work:	Work to check low bat condition
+ * @fg_reinit_work	Work used to reset and reinitialise the FG algorithm
+ * @fg_work:		Work to run the FG algorithm instantly
+ * @fg_acc_cur_work:	Work to read the FG accumulator
+ * @fg_check_hw_failure_work:	Work for checking HW state
+ * @cc_lock:		Mutex for locking the CC
+ * @fg_kobject:		Structure of type kobject
+ */
+struct ab8500_fg {
+	struct device *dev;
+	struct list_head node;
+	int irq;
+	int vbat;
+	int vbat_nom;
+	int inst_curr;
+	int avg_curr;
+	int bat_temp;
+	int fg_samples;
+	int accu_charge;
+	int recovery_cnt;
+	int high_curr_cnt;
+	int init_cnt;
+	int low_bat_cnt;
+	int nbr_cceoc_irq_cnt;
+	bool recovery_needed;
+	bool high_curr_mode;
+	bool init_capacity;
+	bool turn_off_fg;
+	enum ab8500_fg_calibration_state calib_state;
+	enum ab8500_fg_discharge_state discharge_state;
+	enum ab8500_fg_charge_state charge_state;
+	struct completion ab8500_fg_started;
+	struct completion ab8500_fg_complete;
+	struct ab8500_fg_flags flags;
+	struct ab8500_fg_battery_capacity bat_cap;
+	struct ab8500_fg_avg_cap avg_cap;
+	struct ab8500 *parent;
+	struct ab8500_gpadc *gpadc;
+	struct abx500_fg_platform_data *pdata;
+	struct abx500_bm_data *bat;
+	struct power_supply fg_psy;
+	struct workqueue_struct *fg_wq;
+	struct delayed_work fg_periodic_work;
+	struct delayed_work fg_low_bat_work;
+	struct delayed_work fg_reinit_work;
+	struct work_struct fg_work;
+	struct work_struct fg_acc_cur_work;
+	struct delayed_work fg_check_hw_failure_work;
+	struct mutex cc_lock;
+	struct kobject fg_kobject;
+};
-- 
1.7.5.4

