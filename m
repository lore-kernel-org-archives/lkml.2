Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0KATuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:50:15 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52720 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0KATuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:50:09 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/2] w35und: Merge wbhal_f.h to wbhal_s.h
Date: Mon,  1 Nov 2010 21:50:05 +0200
Message-Id: <1288641006-30100-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges HAL struct and function definitions into one header file.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c             |    3 +-
 drivers/staging/winbond/mto.c             |    4 +-
 drivers/staging/winbond/phy_calibration.c |    4 +-
 drivers/staging/winbond/phy_calibration.h |    2 +-
 drivers/staging/winbond/reg.c             |    4 +-
 drivers/staging/winbond/wb35reg_s.h       |   74 ++++++++++++++++++++++++++
 drivers/staging/winbond/wb35tx_f.h        |    1 -
 drivers/staging/winbond/wbhal_f.h         |   81 -----------------------------
 drivers/staging/winbond/wbusb.c           |    5 ++-
 9 files changed, 90 insertions(+), 88 deletions(-)
 delete mode 100644 drivers/staging/winbond/wbhal_f.h

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 9217762..2128e6e 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -2,8 +2,9 @@
 #include "mlmetxrx_f.h"
 #include "mto.h"
 #include "sysdef.h"
-#include "wbhal_f.h"
+#include "wbhal_s.h"
 #include "wblinux_f.h"
+#include "wb35tx_f.h"
 
 unsigned char
 Mds_initial(struct wbsoft_priv *adapter)
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 9cd2127..05d1262 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -19,7 +19,9 @@
 
 #include "sysdef.h"
 #include "sme_api.h"
-#include "wbhal_f.h"
+#include "wbhal_s.h"
+#include "wb35reg_f.h"
+#include "core.h"
 
 /* Declare SQ3 to rate and fragmentation threshold table */
 /* Declare fragmentation thresholds table */
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 2b375ba..08cec74 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -12,7 +12,9 @@
 /****************** INCLUDE FILES SECTION ***********************************/
 #include "sysdef.h"
 #include "phy_calibration.h"
-#include "wbhal_f.h"
+#include "wbhal_s.h"
+#include "wb35reg_f.h"
+#include "core.h"
 
 
 /****************** DEBUG CONSTANT AND MACRO SECTION ************************/
diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
index 3032031..9fcdab1 100644
--- a/drivers/staging/winbond/phy_calibration.h
+++ b/drivers/staging/winbond/phy_calibration.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_PHY_CALIBRATION_H
 #define __WINBOND_PHY_CALIBRATION_H
 
-#include "wbhal_f.h"
+#include "wbhal_s.h"
 
 #define REG_AGC_CTRL1		0x1000
 #define REG_AGC_CTRL2		0x1004
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 990f9d4..8df05c4 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1,5 +1,7 @@
 #include "sysdef.h"
-#include "wbhal_f.h"
+#include "wbhal_s.h"
+#include "wb35reg_f.h"
+#include "core.h"
 
 /*
  * ====================================================
diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index 4eff009..9d5993b 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <asm/atomic.h>
 
+struct hw_data;
+
 /* =========================================================================
  *
  *			HAL setting function
@@ -168,4 +170,76 @@ struct wb35_reg {
 	u32	SQ3_filter[MAX_SQ3_FILTER_SIZE];
 	u32	SQ3_index;
 };
+
+/* =====================================================================
+ * Function declaration
+ * =====================================================================
+ */
+void hal_remove_mapping_key(struct hw_data *hw_data, u8 *mac_addr);
+void hal_remove_default_key(struct hw_data *hw_data, u32 index);
+unsigned char hal_set_mapping_key(struct hw_data *adapter, u8 *mac_addr,
+				  u8 null_key, u8 wep_on, u8 *tx_tsc,
+				  u8 *rx_tsc, u8 key_type, u8 key_len,
+				  u8 *key_data);
+unsigned char hal_set_default_key(struct hw_data *adapter, u8 index,
+				  u8 null_key, u8 wep_on, u8 *tx_tsc,
+				  u8 *rx_tsc, u8 key_type, u8 key_len,
+				  u8 *key_data);
+void hal_clear_all_default_key(struct hw_data *hw_data);
+void hal_clear_all_group_key(struct hw_data *hw_data);
+void hal_clear_all_mapping_key(struct hw_data *hw_data);
+void hal_clear_all_key(struct hw_data *hw_data);
+void hal_set_power_save_mode(struct hw_data *hw_data, unsigned char power_save,
+			     unsigned char wakeup, unsigned char dtim);
+void hal_get_power_save_mode(struct hw_data *hw_data, u8 *in_pwr_save);
+void hal_set_slot_time(struct hw_data *hw_data, u8 type);
+
+#define hal_set_atim_window(_A, _ATM)
+
+void hal_start_bss(struct hw_data *hw_data, u8 mac_op_mode);
+
+/* 0:BSS STA 1:IBSS STA */
+void hal_join_request(struct hw_data *hw_data, u8 bss_type);
+
+void hal_stop_sync_bss(struct hw_data *hw_data);
+void hal_resume_sync_bss(struct hw_data *hw_data);
+void hal_set_aid(struct hw_data *hw_data, u16 aid);
+void hal_set_bssid(struct hw_data *hw_data, u8 *bssid);
+void hal_get_bssid(struct hw_data *hw_data, u8 *bssid);
+void hal_set_listen_interval(struct hw_data *hw_data, u16 listen_interval);
+void hal_set_cap_info(struct hw_data *hw_data, u16 capability_info);
+void hal_set_ssid(struct hw_data *hw_data, u8 *ssid, u8 ssid_len);
+void hal_start_tx0(struct hw_data *hw_data);
+
+#define hal_get_cwmin(_A)	((_A)->cwmin)
+
+void hal_set_cwmax(struct hw_data *hw_data, u16 cwin_max);
+
+#define hal_get_cwmax(_A)	((_A)->cwmax)
+
+void hal_set_rsn_wpa(struct hw_data *hw_data, u32 *rsn_ie_bitmap,
+		     u32 *rsn_oui_type , unsigned char desired_auth_mode);
+void hal_set_connect_info(struct hw_data *hw_data, unsigned char bo_connect);
+u8 hal_get_est_sq3(struct hw_data *hw_data, u8 count);
+void hal_descriptor_indicate(struct hw_data *hw_data,
+			     struct wb35_descriptor *des);
+u8 hal_get_antenna_number(struct hw_data *hw_data);
+u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
+
+#define hal_get_region_from_EEPROM(_A)	((_A)->reg.EEPROMRegion)
+#define hal_get_tx_buffer(_A, _B)	Wb35Tx_get_tx_buffer(_A, _B)
+#define hal_software_set(_A)		(_A->SoftwareSet)
+#define hal_driver_init_OK(_A)		(_A->IsInitOK)
+#define hal_rssi_boundary_high(_A)	(_A->RSSI_high)
+#define hal_rssi_boundary_low(_A)	(_A->RSSI_low)
+#define hal_scan_interval(_A)		(_A->Scan_Interval)
+
+#define PHY_DEBUG(msg, args...)
+
+/* return 100ms count */
+#define hal_get_time_count(_P)		(_P->time_count / 10)
+#define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
+
+#define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
+
 #endif
diff --git a/drivers/staging/winbond/wb35tx_f.h b/drivers/staging/winbond/wb35tx_f.h
index 1d3b515..018fd35 100644
--- a/drivers/staging/winbond/wb35tx_f.h
+++ b/drivers/staging/winbond/wb35tx_f.h
@@ -2,7 +2,6 @@
 #define __WINBOND_WB35TX_F_H
 
 #include "core.h"
-#include "wbhal_f.h"
 
 /*
  * ====================================
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
deleted file mode 100644
index fc78c14..0000000
--- a/drivers/staging/winbond/wbhal_f.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * =====================================================================
- * Device related include
- * =====================================================================
-*/
-#include "wb35reg_f.h"
-#include "wb35tx_f.h"
-#include "wb35rx_f.h"
-
-#include "core.h"
-
-/* =====================================================================
- * Function declaration
- * =====================================================================
- */
-void hal_remove_mapping_key(struct hw_data *hw_data, u8 *mac_addr);
-void hal_remove_default_key(struct hw_data *hw_data, u32 index);
-unsigned char hal_set_mapping_key(struct hw_data *adapter, u8 *mac_addr,
-				  u8 null_key, u8 wep_on, u8 *tx_tsc,
-				  u8 *rx_tsc, u8 key_type, u8 key_len,
-				  u8 *key_data);
-unsigned char hal_set_default_key(struct hw_data *adapter, u8 index,
-				  u8 null_key, u8 wep_on, u8 *tx_tsc,
-				  u8 *rx_tsc, u8 key_type, u8 key_len,
-				  u8 *key_data);
-void hal_clear_all_default_key(struct hw_data *hw_data);
-void hal_clear_all_group_key(struct hw_data *hw_data);
-void hal_clear_all_mapping_key(struct hw_data *hw_data);
-void hal_clear_all_key(struct hw_data *hw_data);
-void hal_set_power_save_mode(struct hw_data *hw_data, unsigned char power_save,
-			     unsigned char wakeup, unsigned char dtim);
-void hal_get_power_save_mode(struct hw_data *hw_data, u8 *in_pwr_save);
-void hal_set_slot_time(struct hw_data *hw_data, u8 type);
-
-#define hal_set_atim_window(_A, _ATM)
-
-void hal_start_bss(struct hw_data *hw_data, u8 mac_op_mode);
-
-/* 0:BSS STA 1:IBSS STA */
-void hal_join_request(struct hw_data *hw_data, u8 bss_type);
-
-void hal_stop_sync_bss(struct hw_data *hw_data);
-void hal_resume_sync_bss(struct hw_data *hw_data);
-void hal_set_aid(struct hw_data *hw_data, u16 aid);
-void hal_set_bssid(struct hw_data *hw_data, u8 *bssid);
-void hal_get_bssid(struct hw_data *hw_data, u8 *bssid);
-void hal_set_listen_interval(struct hw_data *hw_data, u16 listen_interval);
-void hal_set_cap_info(struct hw_data *hw_data, u16 capability_info);
-void hal_set_ssid(struct hw_data *hw_data, u8 *ssid, u8 ssid_len);
-void hal_start_tx0(struct hw_data *hw_data);
-
-#define hal_get_cwmin(_A)	((_A)->cwmin)
-
-void hal_set_cwmax(struct hw_data *hw_data, u16 cwin_max);
-
-#define hal_get_cwmax(_A)	((_A)->cwmax)
-
-void hal_set_rsn_wpa(struct hw_data *hw_data, u32 *rsn_ie_bitmap,
-		     u32 *rsn_oui_type , unsigned char desired_auth_mode);
-void hal_set_connect_info(struct hw_data *hw_data, unsigned char bo_connect);
-u8 hal_get_est_sq3(struct hw_data *hw_data, u8 count);
-void hal_descriptor_indicate(struct hw_data *hw_data,
-			     struct wb35_descriptor *des);
-u8 hal_get_antenna_number(struct hw_data *hw_data);
-u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
-
-#define hal_get_region_from_EEPROM(_A)	((_A)->reg.EEPROMRegion)
-#define hal_get_tx_buffer(_A, _B)	Wb35Tx_get_tx_buffer(_A, _B)
-#define hal_software_set(_A)		(_A->SoftwareSet)
-#define hal_driver_init_OK(_A)		(_A->IsInitOK)
-#define hal_rssi_boundary_high(_A)	(_A->RSSI_high)
-#define hal_rssi_boundary_low(_A)	(_A->RSSI_low)
-#define hal_scan_interval(_A)		(_A->Scan_Interval)
-
-#define PHY_DEBUG(msg, args...)
-
-/* return 100ms count */
-#define hal_get_time_count(_P)		(_P->time_count / 10)
-#define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
-
-#define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3f60cf7..a053bbb 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -16,7 +16,10 @@
 #include "mds_f.h"
 #include "mlmetxrx_f.h"
 #include "mto.h"
-#include "wbhal_f.h"
+#include "wbhal_s.h"
+#include "wb35reg_f.h"
+#include "wb35tx_f.h"
+#include "wb35rx_f.h"
 #include "wblinux_f.h"
 
 MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
-- 
1.7.0.4

