Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2E3U35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:29:57 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38378 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2E3U3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:29:55 -0400
Message-ID: <4FC68336.3000806@candelatech.com>
Date: Wed, 30 May 2012 13:29:42 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mac80211: Fix likely misuse of | for &
References: <cover.1338408931.git.joe@perches.com> <aa9c55edda55d38111660c0b250d12d79f6e1755.1338408931.git.joe@perches.com>
In-Reply-To: <aa9c55edda55d38111660c0b250d12d79f6e1755.1338408931.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 01:25 PM, Joe Perches wrote:
> Using | with a constant is always true.
> Likely this should have be&.

Yes, I think your change is correct.  Looks like something
a compiler or static analysis tool could catch and warn about...

Sorry for the bug!

Ben

>
> cc: Ben Greear<greearb@candelatech.com>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   net/mac80211/cfg.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 495831e..e9cecca 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -533,16 +533,16 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
>   		sinfo.filled = 0;
>   		sta_set_sinfo(sta,&sinfo);
>
> -		if (sinfo.filled | STATION_INFO_TX_BITRATE)
> +		if (sinfo.filled&  STATION_INFO_TX_BITRATE)
>   			data[i] = 100000 *
>   				cfg80211_calculate_bitrate(&sinfo.txrate);
>   		i++;
> -		if (sinfo.filled | STATION_INFO_RX_BITRATE)
> +		if (sinfo.filled&  STATION_INFO_RX_BITRATE)
>   			data[i] = 100000 *
>   				cfg80211_calculate_bitrate(&sinfo.rxrate);
>   		i++;
>
> -		if (sinfo.filled | STATION_INFO_SIGNAL_AVG)
> +		if (sinfo.filled&  STATION_INFO_SIGNAL_AVG)
>   			data[i] = (u8)sinfo.signal_avg;
>   		i++;
>   	} else {


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

