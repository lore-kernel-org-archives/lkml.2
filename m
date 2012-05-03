Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2ECM4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:56:04 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42572 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439Ab2ECM4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:56:02 -0400
Message-ID: <1336049755.12189.30.camel@cumari.coelho.fi>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
From: Luciano Coelho <coelho@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 03 May 2012 15:55:55 +0300
In-Reply-To: <4F8C784B.2040402@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
	 <4F8C784B.2040402@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> wl12xx build fails with many undefined symbol errors when MAC80211
> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
> on MAC80211 (which already depends on CFG80211).
> 
> Here are a few of the many build errors:
> 
> drivers/built-in.o: In function `wl1271_register_hw':
> main.c:(.text+0x4197cd): undefined reference to `ieee80211_register_hw'
> drivers/built-in.o: In function `wl1271_rx_streaming_timer':
> main.c:(.text+0x419818): undefined reference to `ieee80211_queue_work'
> drivers/built-in.o: In function `wl1271_flush_deferred_work':
> main.c:(.text+0x419910): undefined reference to `ieee80211_rx'
> main.c:(.text+0x419938): undefined reference to `ieee80211_tx_status'
> drivers/built-in.o: In function `wl12xx_op_channel_switch':
> main.c:(.text+0x419afc): undefined reference to `ieee80211_chswitch_done'
> drivers/built-in.o: In function `wl1271_ssid_set':
> drivers/built-in.o: In function `wl1271_event_process':
> event.c:(.text+0x41fec4): undefined reference to `ieee80211_sched_scan_stopped'
> event.c:(.text+0x41ff88): undefined reference to `ieee80211_cqm_rssi_notify'
> event.c:(.text+0x42000d): undefined reference to `ieee80211_stop_rx_ba_session'
> event.c:(.text+0x420048): undefined reference to `ieee80211_stop_rx_ba_session'
> event.c:(.text+0x4200b8): undefined reference to `ieee80211_chswitch_done'
> event.c:(.text+0x4201ae): undefined reference to `ieee80211_find_sta'
> event.c:(.text+0x4201ba): undefined reference to `ieee80211_report_low_ack'
> event.c:(.text+0x42021b): undefined reference to `ieee80211_connection_loss'
> drivers/built-in.o: In function `wl1271_tx_complete_packet':
> tx.c:(.text+0x4206a6): undefined reference to `ieee80211_get_hdrlen_from_skb'
> drivers/built-in.o: In function `wl1271_tx_fill_hdr':
> tx.c:(.text+0x4208ca): undefined reference to `ieee80211_hdrlen'
> drivers/built-in.o: In function `wl1271_handle_tx_low_watermark':
> (.text+0x420e25): undefined reference to `ieee80211_wake_queue'
> drivers/built-in.o: In function `wl12xx_rearm_rx_streaming':
> (.text+0x420ed9): undefined reference to `ieee80211_queue_work'
> drivers/built-in.o: In function `wl1271_tx_work_locked':
> (.text+0x421008): undefined reference to `ieee80211_free_txskb'
> drivers/built-in.o: In function `wl1271_rx_status.clone.2':
> rx.c:(.text+0x421593): undefined reference to `ieee80211_channel_to_frequency'
> drivers/built-in.o: In function `wl1271_ps_filter_frames':
> ps.c:(.text+0x421a41): undefined reference to `ieee80211_tx_status'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Luciano Coelho <coelho@ti.com>
> Cc:	linux-wireless@vger.kernel.org
> Cc:	"John W. Linville" <linville@tuxdriver.com>
> ---

Applied! Thanks Randy, and sorry for the delay in pushing this through
my tree.


