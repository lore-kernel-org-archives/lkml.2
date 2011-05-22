Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1EVOGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:06:50 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39447 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1EVOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:06:43 -0400
Date: Sun, 22 May 2011 10:05:26 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, mcgrof@gmail.com, joe@perches.com, nsingh@atheros.com
Subject: [PATCH] staging: ath6kl: ATH6KL_LEGACY should depend on CFG80211
Message-id: <alpine.LNX.2.00.1105220940460.16961@linux.foleyremote.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ATH6KL_LEGACY should depend on CFG80211 to fix this build error:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ieee80211_get_channel':
include/net/cfg80211.h:2078: undefined reference to `__ieee80211_get_channel'
drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
drivers/staging/ath6kl/os/linux/cfg80211.c:798: undefined reference to `cfg80211_inform_bss_frame'
drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
drivers/staging/ath6kl/os/linux/cfg80211.c:493: undefined reference to `cfg80211_get_bss'
drivers/staging/ath6kl/os/linux/cfg80211.c:548: undefined reference to `cfg80211_put_bss'
drivers/built-in.o: In function `ieee80211_get_channel':
include/net/cfg80211.h:2078: undefined reference to `__ieee80211_get_channel'
drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
drivers/staging/ath6kl/os/linux/cfg80211.c:569: undefined reference to `cfg80211_inform_bss_frame'
drivers/staging/ath6kl/os/linux/cfg80211.c:574: undefined reference to `cfg80211_put_bss'
drivers/staging/ath6kl/os/linux/cfg80211.c:577: undefined reference to `cfg80211_ibss_joined'
drivers/staging/ath6kl/os/linux/cfg80211.c:584: undefined reference to `cfg80211_connect_result'
drivers/staging/ath6kl/os/linux/cfg80211.c:590: undefined reference to `cfg80211_roamed'
drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
drivers/staging/ath6kl/os/linux/cfg80211.c:650: undefined reference to `cfg80211_scan_done'
drivers/staging/ath6kl/os/linux/cfg80211.c:660: undefined reference to `cfg80211_ibss_joined'
drivers/staging/ath6kl/os/linux/cfg80211.c:724: undefined reference to `cfg80211_connect_result'
drivers/staging/ath6kl/os/linux/cfg80211.c:730: undefined reference to `cfg80211_disconnected'
drivers/built-in.o: In function `ar6k_cfg80211_scanComplete_event':
drivers/staging/ath6kl/os/linux/cfg80211.c:875: undefined reference to `cfg80211_scan_done'
drivers/built-in.o: In function `ar6k_cfg80211_tkip_micerr_event':
drivers/staging/ath6kl/os/linux/cfg80211.c:1141: undefined reference to `cfg80211_michael_mic_failure'
drivers/built-in.o: In function `ar6k_cfg80211_init':
drivers/staging/ath6kl/os/linux/cfg80211.c:1648: undefined reference to `wiphy_new'
drivers/staging/ath6kl/os/linux/cfg80211.c:1670: undefined reference to `wiphy_register'
drivers/staging/ath6kl/os/linux/cfg80211.c:1674: undefined reference to `wiphy_free'
drivers/built-in.o: In function `ar6k_cfg80211_deinit':
drivers/staging/ath6kl/os/linux/cfg80211.c:1689: undefined reference to `cfg80211_scan_done'
drivers/staging/ath6kl/os/linux/cfg80211.c:1696: undefined reference to `wiphy_unregister'
drivers/staging/ath6kl/os/linux/cfg80211.c:1697: undefined reference to `wiphy_free'
make[2]: *** [.tmp_vmlinux1] Error 1
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 drivers/staging/ath6kl/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/Kconfig b/drivers/staging/ath6kl/Kconfig
index 1f15e1f..a5a9909 100644
--- a/drivers/staging/ath6kl/Kconfig
+++ b/drivers/staging/ath6kl/Kconfig
@@ -1,6 +1,6 @@
 config ATH6K_LEGACY
 	tristate "Atheros AR6003 support (non mac80211)"
-        depends on MMC && WLAN
+        depends on MMC && WLAN && CFG80211
         select WIRELESS_EXT
         select WEXT_PRIV
 	help
-- 
1.7.5.rc3

