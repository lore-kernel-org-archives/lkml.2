Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2FGEPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:15:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2FGEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:15:50 -0400
Message-Id: <20120607040338.032562268@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:47 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 11/82] iwlwifi: do not use shadow registers by default
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -183,7 +183,7 @@ static const struct iwl_base_params iwl2
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
@@ -202,7 +202,7 @@ static const struct iwl_base_params iwl2
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 	.hd_v2 = true,
 };
 
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -282,7 +282,7 @@ static const struct iwl_base_params iwl6
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_base_params iwl6050_base_params = {
@@ -299,7 +299,7 @@ static const struct iwl_base_params iwl6
 	.chain_noise_scale = 1500,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_base_params iwl6000_g2_base_params = {
@@ -316,7 +316,7 @@ static const struct iwl_base_params iwl6
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.shadow_reg_enable = true,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
 };
 
 static const struct iwl_ht_params iwl6000_ht_params = {


