Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2DPQvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:51:36 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48296 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754809Ab2DPQvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:51:35 -0400
Message-ID: <4F8C784B.2040402@xenotime.net>
Date: Mon, 16 Apr 2012 12:51:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH -next] wireless: TI wlxxx depends on MAC80211
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
In-Reply-To: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

wl12xx build fails with many undefined symbol errors when MAC80211
and CFG80211 are not enabled, so make WLCORE and WL12XX depend
on MAC80211 (which already depends on CFG80211).

Here are a few of the many build errors:

drivers/built-in.o: In function `wl1271_register_hw':
main.c:(.text+0x4197cd): undefined reference to `ieee80211_register_hw'
drivers/built-in.o: In function `wl1271_rx_streaming_timer':
main.c:(.text+0x419818): undefined reference to `ieee80211_queue_work'
drivers/built-in.o: In function `wl1271_flush_deferred_work':
main.c:(.text+0x419910): undefined reference to `ieee80211_rx'
main.c:(.text+0x419938): undefined reference to `ieee80211_tx_status'
drivers/built-in.o: In function `wl12xx_op_channel_switch':
main.c:(.text+0x419afc): undefined reference to `ieee80211_chswitch_done'
drivers/built-in.o: In function `wl1271_ssid_set':
drivers/built-in.o: In function `wl1271_event_process':
event.c:(.text+0x41fec4): undefined reference to `ieee80211_sched_scan_stopped'
event.c:(.text+0x41ff88): undefined reference to `ieee80211_cqm_rssi_notify'
event.c:(.text+0x42000d): undefined reference to `ieee80211_stop_rx_ba_session'
event.c:(.text+0x420048): undefined reference to `ieee80211_stop_rx_ba_session'
event.c:(.text+0x4200b8): undefined reference to `ieee80211_chswitch_done'
event.c:(.text+0x4201ae): undefined reference to `ieee80211_find_sta'
event.c:(.text+0x4201ba): undefined reference to `ieee80211_report_low_ack'
event.c:(.text+0x42021b): undefined reference to `ieee80211_connection_loss'
drivers/built-in.o: In function `wl1271_tx_complete_packet':
tx.c:(.text+0x4206a6): undefined reference to `ieee80211_get_hdrlen_from_skb'
drivers/built-in.o: In function `wl1271_tx_fill_hdr':
tx.c:(.text+0x4208ca): undefined reference to `ieee80211_hdrlen'
drivers/built-in.o: In function `wl1271_handle_tx_low_watermark':
(.text+0x420e25): undefined reference to `ieee80211_wake_queue'
drivers/built-in.o: In function `wl12xx_rearm_rx_streaming':
(.text+0x420ed9): undefined reference to `ieee80211_queue_work'
drivers/built-in.o: In function `wl1271_tx_work_locked':
(.text+0x421008): undefined reference to `ieee80211_free_txskb'
drivers/built-in.o: In function `wl1271_rx_status.clone.2':
rx.c:(.text+0x421593): undefined reference to `ieee80211_channel_to_frequency'
drivers/built-in.o: In function `wl1271_ps_filter_frames':
ps.c:(.text+0x421a41): undefined reference to `ieee80211_tx_status'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Luciano Coelho <coelho@ti.com>
Cc:	linux-wireless@vger.kernel.org
Cc:	"John W. Linville" <linville@tuxdriver.com>
---
 drivers/net/wireless/ti/wl12xx/Kconfig |    1 +
 drivers/net/wireless/ti/wlcore/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20120416.orig/drivers/net/wireless/ti/wl12xx/Kconfig
+++ linux-next-20120416/drivers/net/wireless/ti/wl12xx/Kconfig
@@ -1,5 +1,6 @@
 config WL12XX
        tristate "TI wl12xx support"
+	depends on MAC80211
        select WLCORE
        ---help---
 	  This module adds support for wireless adapters based on TI wl1271,
--- linux-next-20120416.orig/drivers/net/wireless/ti/wlcore/Kconfig
+++ linux-next-20120416/drivers/net/wireless/ti/wlcore/Kconfig
@@ -1,6 +1,6 @@
 config WLCORE
 	tristate "TI wlcore support"
-	depends on WL_TI && GENERIC_HARDIRQS
+	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
 	depends on INET
 	select FW_LOADER
 	---help---
