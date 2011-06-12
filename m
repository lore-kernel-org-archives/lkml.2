Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1FLMlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 08:41:50 -0400
Received: from chi.die-welt.net ([84.246.123.210]:59084 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1FLMlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 08:41:49 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jun 2011 08:41:48 EDT
From: Evgeni Golov <sargentd@die-welt.net>
To: wey-yi.w.guy@intel.com, ilw@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Evgeni Golov <sargentd@die-welt.net>
Subject: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware field
Date: Sun, 12 Jun 2011 14:34:31 +0200
Message-Id: <1307882071-767-1-git-send-email-sargentd@die-welt.net>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently (3.0-rc2), modinfo iwlagn shows:
    firmware:       iwlwifi-5150-IWL5150_UCODE_API_MAX.ucode
    firmware:       iwlwifi-5000-IWL5000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000g2b-IWL6000G2_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000g2a-IWL6000G2_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6050-IWL6050_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000-IWL6000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-100-IWL100_UCODE_API_MAX.ucode
    firmware:       iwlwifi-1000-IWL1000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-105-IWL105_UCODE_API_MAX.ucode
    firmware:       iwlwifi-2030-IWL2030_UCODE_API_MAX.ucode
    firmware:       iwlwifi-2000-IWL2000_UCODE_API_MAX.ucode

which is obviously wrong, the user should not see the *_UCODE_API_MAX
macros but the actual ucode API versions here.

The problem are the
    #define *_MODULE_FIRMWARE(api) *_FW_PRE #api ".ucode"
which do not expand api correctly (because this is a macro itself).

Fixed by using __stringify() from linux/stringify.h.

Further information about macro stringification can be found here:
    http://gcc.gnu.org/onlinedocs/cpp/Stringification.html

Signed-off-by: Evgeni Golov <sargentd@die-welt.net>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-2000.c |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    9 +++++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 61d4a11..2a88e73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -55,10 +56,10 @@
 #define IWL100_UCODE_API_MIN 5
 
 #define IWL1000_FW_PRE "iwlwifi-1000-"
-#define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
+#define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE __stringify(api) ".ucode"
 
 #define IWL100_FW_PRE "iwlwifi-100-"
-#define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
+#define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE __stringify(api) ".ucode"
 
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 86feec8..1044309 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -58,13 +59,13 @@
 #define IWL105_UCODE_API_MIN 5
 
 #define IWL2030_FW_PRE "iwlwifi-2030-"
-#define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE #api ".ucode"
+#define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE __stringify(api) ".ucode"
 
 #define IWL2000_FW_PRE "iwlwifi-2000-"
-#define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE #api ".ucode"
+#define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE __stringify(api) ".ucode"
 
 #define IWL105_FW_PRE "iwlwifi-105-"
-#define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE #api ".ucode"
+#define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE __stringify(api) ".ucode"
 
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a70b8cf..168153d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -37,6 +37,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -57,10 +58,10 @@
 #define IWL5150_UCODE_API_MIN 1
 
 #define IWL5000_FW_PRE "iwlwifi-5000-"
-#define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE #api ".ucode"
+#define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE __stringify(api) ".ucode"
 
 #define IWL5150_FW_PRE "iwlwifi-5150-"
-#define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
+#define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE __stringify(api) ".ucode"
 
 /* NIC configuration for 5000 series */
 static void iwl5000_nic_config(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fda6fe0..443a191 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -58,16 +59,16 @@
 #define IWL6000G2_UCODE_API_MIN 4
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
-#define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
+#define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE __stringify(api) ".ucode"
 
 #define IWL6050_FW_PRE "iwlwifi-6050-"
-#define IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
+#define IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE __stringify(api) ".ucode"
 
 #define IWL6005_FW_PRE "iwlwifi-6000g2a-"
-#define IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE #api ".ucode"
+#define IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE __stringify(api) ".ucode"
 
 #define IWL6030_FW_PRE "iwlwifi-6000g2b-"
-#define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE #api ".ucode"
+#define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE __stringify(api) ".ucode"
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
-- 
1.7.2.5

