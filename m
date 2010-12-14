Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab0LNCWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:22:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56849 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046Ab0LNCWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:22:42 -0500
Date: Tue, 14 Dec 2010 13:22:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20101214132235.4b29a2a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-1000.c
drivers/net/wireless/iwlwifi/iwl-6000.c
drivers/net/wireless/iwlwifi/iwl-core.h between commit
6942fec92d3d1b6918425730de31b4c6d0d5c196 ("iwlagn: implement
layout-agnostic EEPROM reading") from the wireless-current tree and
commit 564b344c10b694d433cef5b89f8ff8ac5e33898d ("iwlwifi: change default
led mode for different devices") from the wireless tree.

I fixed it up (hopefully, see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-1000.c
index 0e027f7,3c983e4..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@@ -315,7 -310,7 +310,8 @@@ struct iwl_cfg iwl100_bgn_cfg = 
  	.mod_params = &iwlagn_mod_params,
  	.base_params = &iwl1000_base_params,
  	.ht_params = &iwl1000_ht_params,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
  struct iwl_cfg iwl100_bg_cfg = {
@@@ -331,7 -323,7 +324,8 @@@
  	.ops = &iwl1000_ops,
  	.mod_params = &iwlagn_mod_params,
  	.base_params = &iwl1000_base_params,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
  MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --cc drivers/net/wireless/iwlwifi/iwl-6000.c
index 0ceeaac,808942c..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@@ -561,11 -563,11 +563,12 @@@ struct iwl_cfg iwl6005_2agn_cfg = 
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
- struct iwl_cfg iwl6000g2a_2abg_cfg = {
- 	.name = "6000 Series 2x2 ABG Gen2a",
+ struct iwl_cfg iwl6005_2abg_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6205 ABG",
  	.fw_name_pre = IWL6000G2A_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -579,11 -578,11 +579,12 @@@
  	.base_params = &iwl6000_base_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
- struct iwl_cfg iwl6000g2a_2bg_cfg = {
- 	.name = "6000 Series 2x2 BG Gen2a",
+ struct iwl_cfg iwl6005_2bg_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6205 BG",
  	.fw_name_pre = IWL6000G2A_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -597,11 -593,11 +595,12 @@@
  	.base_params = &iwl6000_base_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
- struct iwl_cfg iwl6000g2b_2agn_cfg = {
- 	.name = "6000 Series 2x2 AGN Gen2b",
+ struct iwl_cfg iwl6030_2agn_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -617,13 -610,14 +613,15 @@@
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
- struct iwl_cfg iwl6000g2b_2abg_cfg = {
- 	.name = "6000 Series 2x2 ABG Gen2b",
+ struct iwl_cfg iwl6030_2abg_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6230 ABG",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -638,13 -629,14 +633,15 @@@
  	.bt_params = &iwl6000_bt_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
- struct iwl_cfg iwl6000g2b_2bgn_cfg = {
- 	.name = "6000 Series 2x2 BGN Gen2b",
+ struct iwl_cfg iwl6030_2bgn_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BGN",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -660,13 -649,14 +654,15 @@@
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
- struct iwl_cfg iwl6000g2b_2bg_cfg = {
- 	.name = "6000 Series 2x2 BG Gen2b",
+ struct iwl_cfg iwl6030_2bg_cfg = {
+ 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BG",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -681,13 -668,14 +674,15 @@@
  	.bt_params = &iwl6000_bt_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
- struct iwl_cfg iwl6000g2b_bgn_cfg = {
- 	.name = "6000 Series 1x2 BGN Gen2b",
+ struct iwl_cfg iwl1030_bgn_cfg = {
+ 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -703,13 -688,14 +695,15 @@@
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
- struct iwl_cfg iwl6000g2b_bg_cfg = {
- 	.name = "6000 Series 1x2 BG Gen2b",
+ struct iwl_cfg iwl1030_bg_cfg = {
+ 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BG",
  	.fw_name_pre = IWL6000G2B_FW_PRE,
  	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
  	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
@@@ -724,9 -707,10 +715,11 @@@
  	.bt_params = &iwl6000_bt_params,
  	.need_dc_calib = true,
  	.need_temp_offset_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
  /*
@@@ -813,7 -792,7 +801,8 @@@ struct iwl_cfg iwl6150_bgn_cfg = 
  	.base_params = &iwl6050_base_params,
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
 +	.use_new_eeprom_reading = true,
+ 	.led_mode = IWL_LED_RF_STATE,
  };
  
  struct iwl_cfg iwl6050_2abg_cfg = {
@@@ -865,9 -837,10 +847,11 @@@ struct iwl_cfg iwl130_bgn_cfg = 
  	.bt_params = &iwl6000_bt_params,
  	.ht_params = &iwl6000_ht_params,
  	.need_dc_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
  struct iwl_cfg iwl130_bg_cfg = {
@@@ -885,9 -855,10 +866,11 @@@
  	.base_params = &iwl6000_coex_base_params,
  	.bt_params = &iwl6000_bt_params,
  	.need_dc_calib = true,
+ 	.led_mode = IWL_LED_RF_STATE,
+ 	.adv_pm = true,
  	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
  	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 +	.use_new_eeprom_reading = true,
  };
  
  MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --cc drivers/net/wireless/iwlwifi/iwl-core.h
index 954ecc2,568920a..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@@ -390,7 -410,8 +410,9 @@@ struct iwl_cfg 
  	const bool need_temp_offset_calib; /* if used set to true */
  	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
  	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 +	const bool use_new_eeprom_reading; /* temporary, remove later */
+ 	enum iwl_led_mode led_mode;
+ 	const bool adv_pm;
  };
  
  /***************************
