Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0KIDPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:15:54 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:47976 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0KIDPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:15:50 -0500
Subject: Re: PROBLEM: brcm80211 unable to survive suspend/resume cycle
From: Jon Masters <jonathan@jonmasters.org>
To: devel <devel@linuxdriverproject.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 22:16:07 -0500
Message-ID: <1289272567.3916.442.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 22:13 -0500, Jon Masters wrote:

> I reported this before, but let me open up a new thread for this now
> that this driver has landed in 2.6.37-rc1 and been out for a while. I am
> able to use this driver (more or less) for daily use on my netbook, but
> it is unable survive a suspend/resume cycle without being unloaded and
> then reloaded again on resume. That actually seems to work quite well.
> 
> I believe the problem is firmware related:

Here's the log on the driver successfully re(loading):

[  592.212928] brcm80211: module is from the staging directory, the
quality is unknown, you have been warned.
[  592.252769] brcm80211 0000:02:00.0: PCI INT A -> GSI 17 (level, low)
-> IRQ 17
[  592.252851] brcm80211 0000:02:00.0: setting latency timer to 64
[  592.301703] Found chip type AI (0x13814313)
[  592.307394] Changing max_res_mask to 0xffff
[  592.307404] Changing min_res_mask to 0x200d
[  592.313694] Applying 4313 WARs
[  592.315470] wlc_bmac_attach:: deviceid 0x4727 nbands 1 board 0x2047
macaddr: 74:f0:6d:7e:ae:bc
[  592.325680] ieee80211 phy0: Selected rate control algorithm
'minstrel_ht'
[  592.347629] wl_set_hint: Sending country code US to MAC80211
[  592.348371] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver 5.75.11
(1.82.8.0) (Compiled in . at 19:32:54 on Nov  8 2010)
[  592.350243] cfg80211: Calling CRDA for country: US
[  592.440596] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  592.452998] cfg80211: Regulatory domain changed to country: US
[  592.453126]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  592.453143]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[  592.453157]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
1700 mBm)
[  592.453171]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  592.453186]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  592.453209]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  592.453231]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
3000 mBm)
[  594.936591] wlan0: deauthenticating from X by local choice (reason=3)
[  595.131413] wlan0: authenticate with X (try 1)
[  595.332109] wlan0: authenticate with X (try 2)
[  595.334992] wlan0: authenticated
[  595.340928] wlan0: associate with X (try 1)
[  595.348910] wlan0: RX AssocResp from X (capab=0x411 status=0 aid=4)
[  595.348928] wlan0: associated
[  595.357809] Associated:      True
[  595.376614] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  595.559868] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
374/256 dur 3498/1504
[  596.740255] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
170/256 dur 1866/1504
[  596.745966] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
170/256 dur 1866/1504
[  596.748859] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
170/256 dur 1866/1504
[  596.781364] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
163/256 dur 1810/1504
[  596.790354] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
163/256 dur 1810/1504
[  596.798995] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
163/256 dur 1810/1504
[  602.093109] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen
644/256 dur 5658/1504
[  605.554079] wlan0: no IPv6 routers present

Jon.


