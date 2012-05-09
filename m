Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2EIGDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:03:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab2EIFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:40 -0400
Message-Id: <20120509055051.788682782@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [ 161/167] [PATCH] iwlagn: allow up to uCode API 6 for 6000 devices
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b914811524fbe9e91fe50845f5d7bd4316b8a6ee upstream.

Since the uCode hasn't been released (yet?),
warn only if using older than API 4, but load
anything up to API 6.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 09f0378..617ad1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,11 +46,12 @@
 #include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 4
+#define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
+#define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
 
 /* Lowest firmware API version supported */
@@ -457,6 +458,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 #define IWL_DEVICE_6000i					\
 	.fw_name_pre = IWL6000_FW_PRE,				\
 	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL6000_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
@@ -535,6 +537,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_ok = IWL6000_UCODE_API_OK,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
@@ -544,7 +547,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.led_mode = IWL_LED_BLINK,
 };
 
-MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-- 
1.7.10



