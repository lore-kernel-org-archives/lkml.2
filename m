Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1DKRPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:15:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43059 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1DKRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:15:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH] iwlegacy: make iwl3945 and iwl4965 select IWLWIFI_LEGACY
Date: Mon, 11 Apr 2011 13:06:39 -0400
Message-Id: <1302541599-15383-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <BANLkTimoDVMcvFdoUedyfw4Thv8=DsV-5A@mail.gmail.com>
References: <BANLkTimoDVMcvFdoUedyfw4Thv8=DsV-5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, IWLWIFI_LEGACY has to be selected independently before the
drivers are made available.

Reported-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlegacy/Kconfig |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index 2a45dd4..aef65cd 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -1,6 +1,5 @@
 config IWLWIFI_LEGACY
-	tristate "Intel Wireless Wifi legacy devices"
-	depends on PCI && MAC80211
+	tristate
 	select FW_LOADER
 	select NEW_LEDS
 	select LEDS_CLASS
@@ -65,7 +64,8 @@ endmenu
 
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN (iwl4965)"
-	depends on IWLWIFI_LEGACY
+	depends on PCI && MAC80211
+	select IWLWIFI_LEGACY
 	---help---
 	  This option enables support for
 
@@ -92,7 +92,8 @@ config IWL4965
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
-	depends on IWLWIFI_LEGACY
+	depends on PCI && MAC80211
+	select IWLWIFI_LEGACY
 	---help---
 	  Select to build the driver supporting the:
 
-- 
1.7.4

