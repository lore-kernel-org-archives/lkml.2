Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2EJVZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:25:18 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42097 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758899Ab2EJVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:25:15 -0400
Message-ID: <4FAC3249.3060107@xenotime.net>
Date: Thu, 10 May 2012 14:25:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>	 <4F8C784B.2040402@xenotime.net> <1336049755.12189.30.camel@cumari.coelho.fi>
In-Reply-To: <1336049755.12189.30.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:55 AM, Luciano Coelho wrote:

> On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> wl12xx build fails with many undefined symbol errors when MAC80211
>> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
>> on MAC80211 (which already depends on CFG80211).
>>
>> Here are a few of the many build errors:
>>
>> drivers/built-in.o: In function `wl1271_register_hw':
>> main.c:(.text+0x4197cd): undefined reference to `ieee80211_register_hw'
>> drivers/built-in.o: In function `wl1271_rx_streaming_timer':
>> main.c:(.text+0x419818): undefined reference to `ieee80211_queue_work'
>> drivers/built-in.o: In function `wl1271_flush_deferred_work':
>> main.c:(.text+0x419910): undefined reference to `ieee80211_rx'
>> main.c:(.text+0x419938): undefined reference to `ieee80211_tx_status'
>> drivers/built-in.o: In function `wl12xx_op_channel_switch':
>> main.c:(.text+0x419afc): undefined reference to `ieee80211_chswitch_done'
>> drivers/built-in.o: In function `wl1271_ssid_set':
>> drivers/built-in.o: In function `wl1271_event_process':
>> event.c:(.text+0x41fec4): undefined reference to `ieee80211_sched_scan_stopped'
>> event.c:(.text+0x41ff88): undefined reference to `ieee80211_cqm_rssi_notify'
>> event.c:(.text+0x42000d): undefined reference to `ieee80211_stop_rx_ba_session'
>> event.c:(.text+0x420048): undefined reference to `ieee80211_stop_rx_ba_session'
>> event.c:(.text+0x4200b8): undefined reference to `ieee80211_chswitch_done'
>> event.c:(.text+0x4201ae): undefined reference to `ieee80211_find_sta'
>> event.c:(.text+0x4201ba): undefined reference to `ieee80211_report_low_ack'
>> event.c:(.text+0x42021b): undefined reference to `ieee80211_connection_loss'
>> drivers/built-in.o: In function `wl1271_tx_complete_packet':
>> tx.c:(.text+0x4206a6): undefined reference to `ieee80211_get_hdrlen_from_skb'
>> drivers/built-in.o: In function `wl1271_tx_fill_hdr':
>> tx.c:(.text+0x4208ca): undefined reference to `ieee80211_hdrlen'
>> drivers/built-in.o: In function `wl1271_handle_tx_low_watermark':
>> (.text+0x420e25): undefined reference to `ieee80211_wake_queue'
>> drivers/built-in.o: In function `wl12xx_rearm_rx_streaming':
>> (.text+0x420ed9): undefined reference to `ieee80211_queue_work'
>> drivers/built-in.o: In function `wl1271_tx_work_locked':
>> (.text+0x421008): undefined reference to `ieee80211_free_txskb'
>> drivers/built-in.o: In function `wl1271_rx_status.clone.2':
>> rx.c:(.text+0x421593): undefined reference to `ieee80211_channel_to_frequency'
>> drivers/built-in.o: In function `wl1271_ps_filter_frames':
>> ps.c:(.text+0x421a41): undefined reference to `ieee80211_tx_status'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc:	Luciano Coelho <coelho@ti.com>
>> Cc:	linux-wireless@vger.kernel.org
>> Cc:	"John W. Linville" <linville@tuxdriver.com>
>> ---
> 
> Applied! Thanks Randy, and sorry for the delay in pushing this through
> my tree.



Ping.

This patch is still needed in linux-next of 20120510.


-- 
~Randy
