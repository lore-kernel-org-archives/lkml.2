Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab2FQS3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:29:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50335 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757953Ab2FQSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:53 -0400
Message-Id: <20120617175946.692684847@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 38/69] iwlwifi: use correct supported firmware for 6035 and 6000g2
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit d2c8b15d0cb486f4938ba7f2af349d9d1220cb10 upstream.

My patch

   iwlwifi: use correct released ucode version

did not correctly report supported firmware
for the 6035 device. This patch fixes it. The
minimum supported firmware version for 6035
is v6.

Also correct the minimum supported firmware
version for the 6000g2 series of devices.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - adjust context
 - make IWL_DEVICE_6035 identical for IWL_DEVICE_6030 except for the
   ucode_api_* fields]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -49,17 +49,20 @@
 #define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
+#define IWL6035_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
 #define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
 #define IWL6050_UCODE_API_OK 5
 #define IWL6000G2B_UCODE_API_OK 6
+#define IWL6035_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
-#define IWL6000G2_UCODE_API_MIN 4
+#define IWL6000G2_UCODE_API_MIN 5
+#define IWL6035_UCODE_API_MIN 6
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE __stringify(api) ".ucode"
@@ -436,9 +439,24 @@
 	IWL_DEVICE_6030,
 };
 
+#define IWL_DEVICE_6035						\
+	.fw_name_pre = IWL6030_FW_PRE,				\
+	.ucode_api_max = IWL6035_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL6035_UCODE_API_OK,			\
+	.ucode_api_min = IWL6035_UCODE_API_MIN,			\
+	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
+	.lib = &iwl6030_lib,					\
+	.base_params = &iwl6000_g2_base_params,			\
+	.bt_params = &iwl6000_bt_params,			\
+	.need_dc_calib = true,					\
+	.need_temp_offset_calib = true,				\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.adv_pm = true
+
 struct iwl_cfg iwl6035_2agn_cfg = {
 	.name = "6035 Series 2x2 AGN/BT",
-	IWL_DEVICE_6030,
+	IWL_DEVICE_6035,
 	.ht_params = &iwl6000_ht_params,
 };
 


