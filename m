Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2EIF55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:57:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833Ab2EIFxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:49 -0400
Message-Id: <20120509055051.921087402@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 162/167] [PATCH] iwlwifi: use correct released ucode version
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit 78cbcf2b9dbe0565820dc7721316f9c401000a68 upstream.

Report correctly the latest released version
of the iwlwifi firmware for all
iwlwifi-supported devices.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-2000.c |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |   10 ++++++----
 4 files changed, 27 insertions(+), 18 deletions(-)

--- linux.orig/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -45,8 +45,8 @@
 #include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 6
-#define IWL100_UCODE_API_MAX 6
+#define IWL1000_UCODE_API_MAX 5
+#define IWL100_UCODE_API_MAX 5
 
 /* Oldest version we won't warn about */
 #define IWL1000_UCODE_API_OK 5
@@ -244,5 +244,5 @@
 	IWL_DEVICE_100,
 };
 
-MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_OK));
--- linux.orig/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -51,10 +51,10 @@
 #define IWL135_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
-#define IWL2030_UCODE_API_OK 5
-#define IWL2000_UCODE_API_OK 5
-#define IWL105_UCODE_API_OK 5
-#define IWL135_UCODE_API_OK 5
+#define IWL2030_UCODE_API_OK 6
+#define IWL2000_UCODE_API_OK 6
+#define IWL105_UCODE_API_OK 6
+#define IWL135_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
@@ -372,7 +372,7 @@
 	.ht_params = &iwl2000_ht_params,
 };
 
-MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_OK));
+MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_OK));
+MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_OK));
--- linux.orig/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -50,6 +50,10 @@
 #define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
+/* Oldest version we won't warn about */
+#define IWL5000_UCODE_API_OK 5
+#define IWL5150_UCODE_API_OK 2
+
 /* Lowest firmware API version supported */
 #define IWL5000_UCODE_API_MIN 1
 #define IWL5150_UCODE_API_MIN 1
@@ -373,6 +377,7 @@
 #define IWL_DEVICE_5000						\
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL5000_UCODE_API_OK,			\
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
@@ -416,6 +421,7 @@
 	.name = "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_ok = IWL5000_UCODE_API_OK,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
@@ -429,6 +435,7 @@
 #define IWL_DEVICE_5150						\
 	.fw_name_pre = IWL5150_FW_PRE,				\
 	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL5150_UCODE_API_OK,			\
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
@@ -450,5 +457,5 @@
 	IWL_DEVICE_5150,
 };
 
-MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_OK));
--- linux.orig/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -53,6 +53,8 @@
 /* Oldest version we won't warn about */
 #define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
+#define IWL6050_UCODE_API_OK 5
+#define IWL6000G2B_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
@@ -359,7 +361,7 @@
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
+	.ucode_api_ok = IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
@@ -573,6 +575,6 @@
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
-MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_OK));


