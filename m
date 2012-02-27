Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2B0Shy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:37:54 -0500
Received: from que31.charter.net ([209.225.8.23]:47153 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2B0Shd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:37:33 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Feb 2012 13:37:31 EST
X-Authority-Analysis: v=1.1 cv=rvNqJbVGdbt4egs52VbhtoJZG7AoPDG9H2iogr/sNfs=
 c=1 sm=1 a=mKTHn6b3k78A:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=ZYzLib7_pByLTZkW7_IA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 1/4] iwlegacy: Kconfig: Move Debugging Options
Date: Mon, 27 Feb 2012 12:25:30 -0600
Message-Id: <1330367133-26465-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the debug options so they appear below the 3945 / 4965 options.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/Kconfig |   78 ++++++++++++++++----------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index 05bd375..4d81b80 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -6,45 +6,6 @@ config IWLEGACY
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 
-menu "Debugging Options"
-	depends on IWLEGACY
-
-config IWLEGACY_DEBUG
-	bool "Enable full debugging output in iwlegacy (iwl 3945/4965) drivers"
-	depends on IWLEGACY
-	---help---
-	  This option will enable debug tracing output for the iwlegacy
-	  drivers.
-
-	  This will result in the kernel module being ~100k larger.  You can
-	  control which debug output is sent to the kernel log by setting the
-	  value in
-
-		/sys/class/net/wlan0/device/debug_level
-
-	  This entry will only exist if this option is enabled.
-
-	  To set a value, simply echo an 8-byte hex value to the same file:
-
-		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
-
-	  You can find the list of debug mask values in:
-		  drivers/net/wireless/iwlegacy/common.h
-
-	  If this is your first time using this driver, you should say Y here
-	  as the debug information can assist others in helping you resolve
-	  any problems you may encounter.
-
-config IWLEGACY_DEBUGFS
-        bool "iwlegacy (iwl 3945/4965) debugfs support"
-        depends on IWLEGACY && MAC80211_DEBUGFS
-        ---help---
-	  Enable creation of debugfs files for the iwlegacy drivers. This
-	  is a low-impact option that allows getting insight into the
-	  driver's state at runtime.
-
-endmenu
-
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN (iwl4965)"
 	depends on PCI && MAC80211
@@ -98,3 +59,42 @@ config IWL3945
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.
+
+menu "Debugging Options"
+	depends on IWLEGACY
+
+config IWLEGACY_DEBUG
+	bool "Enable full debugging output in iwlegacy (iwl 3945/4965) drivers"
+	depends on IWLEGACY
+	---help---
+	  This option will enable debug tracing output for the iwlegacy
+	  drivers.
+
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
+
+		/sys/class/net/wlan0/device/debug_level
+
+	  This entry will only exist if this option is enabled.
+
+	  To set a value, simply echo an 8-byte hex value to the same file:
+
+		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
+
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlegacy/common.h
+
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
+
+config IWLEGACY_DEBUGFS
+        bool "iwlegacy (iwl 3945/4965) debugfs support"
+        depends on IWLEGACY && MAC80211_DEBUGFS
+        ---help---
+	  Enable creation of debugfs files for the iwlegacy drivers. This
+	  is a low-impact option that allows getting insight into the
+	  driver's state at runtime.
+
+endmenu
-- 
1.7.6.4

