Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0EHCMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 22:12:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57454 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0EHCMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 22:12:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the suspend tree
Date: Sat, 8 May 2010 04:13:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Helmut Schaa <Helmut.Schaa@gmx.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20100507130821.3fb72c9d.sfr@canb.auug.org.au>
In-Reply-To: <20100507130821.3fb72c9d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005080413.24465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 May 2010, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> net/mac80211/scan.c: In function 'ieee80211_scan_state_decision':
> net/mac80211/scan.c:510: error: implicit declaration of function 'pm_qos_requirement'
> 
> Caused by commit 62bad14fc6e0911a99882c261390968977d43283 ("PM QOS
> update") from the suspend tree interacting with commit
> df13cce53a7b28a81460e6bfc4857e9df4956141 ("mac80211: Improve software
> scan timing") from the net tree.
> 
> I have added the following merge fixup patch and can carry it as
> necessary:

Thanks a lot, please do so if that's not a problem.

Both trees are based on Linus' current and I don't see a good way of fixing
this issue in any of them individually.

Rafael


> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 7 May 2010 13:02:54 +1000
> Subject: [PATCH] wireless: update for pm_qos_requirement to pm_qos_request rename
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/mac80211/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index e14c441..e1b0be7 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -510,7 +510,7 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
>  		bad_latency = time_after(jiffies +
>  				ieee80211_scan_get_channel_time(next_chan),
>  				local->leave_oper_channel_time +
> -				usecs_to_jiffies(pm_qos_requirement(PM_QOS_NETWORK_LATENCY)));
> +				usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
>  
>  		listen_int_exceeded = time_after(jiffies +
>  				ieee80211_scan_get_channel_time(next_chan),
> 

