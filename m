Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0JXBP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:15:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25934 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0JXBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:15:25 -0400
Date: Sat, 23 Oct 2010 18:14:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, driverdevel <devel@driverdev.osuosl.org>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>,
        Vipin Mehta <vmehta@atheros.com>
Subject: [PATCH -mmotm] staging/ath6kl: ATH6KL_CFG80211 depends on CFG80211
Message-Id: <20101023181405.801574be.randy.dunlap@oracle.com>
In-Reply-To: <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
References: <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ATH6KL_CFG80211 should depend on CFG80211 to fix build errors:

ERROR: "wiphy_free" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_inform_bss_frame" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "__ieee80211_get_channel" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_get_bss" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "wiphy_unregister" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_connect_result" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_michael_mic_failure" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_ibss_joined" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_roamed" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_put_bss" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "wiphy_new" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "wiphy_register" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_disconnected" [drivers/staging/ath6kl/ath6kl.ko] undefined!
ERROR: "cfg80211_scan_done" [drivers/staging/ath6kl/ath6kl.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2010-1022-1636.orig/drivers/staging/ath6kl/Kconfig
+++ mmotm-2010-1022-1636/drivers/staging/ath6kl/Kconfig
@@ -102,7 +102,7 @@ config AR600x_BT_RESET_PIN
 
 config ATH6KL_CFG80211
 	bool "CFG80211 support"
-	depends on ATH6K_LEGACY
+	depends on ATH6K_LEGACY && CFG80211
 	help
 	Enables support for CFG80211 APIs. The default option is to use WEXT. Even with this option enabled, WEXT is not explicitly disabled and the onus of not exercising WEXT lies on the application(s) running in the user space.
 
