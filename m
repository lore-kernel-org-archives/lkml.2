Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2FHF06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:26:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43167 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760272Ab2FHFHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:16 -0400
Message-Id: <20120608041843.820819627@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 22/82] iwlwifi: do not use shadow registers by default
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit 66a770729a5cdd24efed8afa5258f81232d8bba2 upstream.

Shadow registers in the device are meant to
allow the driver to update certain device
registers without needing to wake up all
components of the device. However, using
this feature in the device causes
communication between the driver and the
device to become unreliable, resulting in
host command timeouts.

Disable this feature by default till a fix is
available for the bug.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -211,7 +211,7 @@
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
@@ -230,7 +230,7 @@
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -308,7 +308,7 @@
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static struct iwl_base_params iwl6050_base_params = {
@@ -325,7 +325,7 @@
 	.chain_noise_scale = 1500,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 static struct iwl_base_params iwl6000_g2_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
@@ -341,7 +341,7 @@
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static struct iwl_ht_params iwl6000_ht_params = {


