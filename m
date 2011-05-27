Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1E0UDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:03:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55718 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab1E0UDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:03:42 -0400
Date: Fri, 27 May 2011 13:03:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Joe Perches <joe@perches.com>,
        Naveen Singh <nsingh@atheros.com>
Subject: [PATCH -next] staging: fix ath6kl build when CFG80211 is not
 enabled
Message-Id: <20110527130321.18a51d63.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DE00395.0047:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is still needed in linux-next:


Begin forwarded message:

Date: Tue, 17 May 2011 15:15:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, driverdevel <devel@driverdev.osuosl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH -next] staging: fix ath6kl build when CFG80211 is not enabled


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when CONFIG_CFG80211 is not enabled:

drivers/built-in.o: In function `ar6k_cfg80211_deinit':
(.text+0x189b71): undefined reference to `cfg80211_scan_done'
drivers/built-in.o: In function `ar6k_cfg80211_deinit':
(.text+0x189b86): undefined reference to `wiphy_unregister'
drivers/built-in.o: In function `ar6k_cfg80211_deinit':
(.text+0x189b8d): undefined reference to `wiphy_free'
drivers/built-in.o: In function `ar6k_cfg80211_init':
(.text+0x18add7): undefined reference to `wiphy_new'
drivers/built-in.o: In function `ar6k_cfg80211_init':
(.text+0x18ae48): undefined reference to `wiphy_register'
drivers/built-in.o: In function `ar6k_cfg80211_tkip_micerr_event':
(.text+0x18ae95): undefined reference to `cfg80211_michael_mic_failure'
drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
(.text+0x18afb5): undefined reference to `__ieee80211_get_channel'
drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
(.text+0x18afd2): undefined reference to `cfg80211_inform_bss_frame'
drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
(.text+0x18b046): undefined reference to `cfg80211_ibss_joined'
drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
(.text+0x18b176): undefined reference to `cfg80211_connect_result'
drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
(.text+0x18b190): undefined reference to `cfg80211_disconnected'
drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
(.text+0x18b291): undefined reference to `cfg80211_get_bss'
drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
(.text+0x18b457): undefined reference to `cfg80211_put_bss'
drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
(.text+0x18b4fa): undefined reference to `cfg80211_roamed'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Naveen Singh <nsingh@atheros.com>
---
 drivers/staging/ath6kl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110517.orig/drivers/staging/ath6kl/Kconfig
+++ linux-next-20110517/drivers/staging/ath6kl/Kconfig
@@ -1,6 +1,7 @@
 config ATH6K_LEGACY
 	tristate "Atheros AR6003 support (non mac80211)"
         depends on MMC && WLAN
+	depends on CFG80211
         select WIRELESS_EXT
         select WEXT_PRIV
 	help


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
