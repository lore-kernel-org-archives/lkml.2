Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2GVKKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 06:10:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42479 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2GVKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 06:10:22 -0400
MIME-Version: 1.0
X-Originating-IP: [121.7.229.38]
In-Reply-To: <CAMVG2su3DfOTRHDr7oFPLM5LVOBEXtChPEy4LL_2QS-VT9vBgg@mail.gmail.com>
References: <CAMVG2su3DfOTRHDr7oFPLM5LVOBEXtChPEy4LL_2QS-VT9vBgg@mail.gmail.com>
Date: Sun, 22 Jul 2012 18:10:21 +0800
Message-ID: <CAMVG2suiMXojoptfNNJEZWhiBfgVcU99BTvG6jqdKAFGBf65MA@mail.gmail.com>
Subject: Re: 3.5.0 iwlagn AP crash...
From: Daniel J Blueman <daniel@quora.org>
To: Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2012 17:15, Daniel J Blueman <daniel@quora.org> wrote:
> Hi Johannes et al,
>
> When running my Centrino Wireless-N 130 BGN (rev 0xb0) card in nl80211
> AP mode with hostapd on linux 3.5.0, I immediately hit this fatal
> pagefault [1].
>
> I can cook a debug kernel, reproduce, disassemble the code and do some
> quick analysis, if that helps get the ball rolling?
>
> Thanks!
>   Daniel
>
> --- [1]
>
> BUG: unable to handle kernel NULL pointer dereference at      (null)
> IP: [<ffffffffa02e869d>] ieee80211_ave_rssi+0xd/0x50 [mac80211]

>From my debug kernel, sdata is clearly NULL:

(gdb) list *0xffffffff815b74f8
0xffffffff815b74f8 is in ieee80211_ave_rssi (net/mac80211/util.c:1801).
1796	int ieee80211_ave_rssi(struct ieee80211_vif *vif)
1797	{
1798		struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
1799		struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
1800	
1801		if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION)) {
1802			/* non-managed type inferfaces */
1803			return 0;
1804		}
1805		return ifmgd->ave_beacon_signal;
-- 
Daniel J Blueman
