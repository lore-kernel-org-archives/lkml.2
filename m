Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0L3IxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:53:19 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:53949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0L3IxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:53:17 -0500
Subject: Re: [PATCH] mac80211: fix mesh forwarding when ratelimited too
From: Johannes Berg <johannes@sipsolutions.net>
To: Milton Miller <miltonm@bga.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Javier Cardona <javier@cozybit.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <mac80211-rx-ratelimit-goto@mdm.bga.com>
References: <1293009307.3531.13.camel@jlt3.sipsolutions.net>
	 <AANLkTik9PS-wKYg=XC0bUaZ=a99d-FdUmzZfvALVQ9Tv@mail.gmail.com>
	 <201012262159.oBQLxOsw008865@hera.kernel.org>
	 <mac80211-rx-ratelimit-goto@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 09:53:09 +0100
Message-ID: <1293699189.4055.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 02:01 -0600, Milton Miller wrote:
> Commit b51aff057c9d0ef6c529dc25fd9f775faf7b6c63 said:
> 
>     Under memory pressure, the mac80211 mesh code
>     may helpfully print a message that it failed
>     to clone a mesh frame and then will proceed
>     to crash trying to use it anyway. Fix that.
>     
> Avoid the reference whenever the frame copy is unsuccessful
> regardless of the debug message being suppressed or printed.
> 
> Cc: stable@kernel.org [2.6.27+] 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> ---
> I chose a seperate if vs nesting the ratelimit check to avoid shifting
> the printk further to the right.
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b01e467..e98668f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1788,11 +1788,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
>  
>  			fwd_skb = skb_copy(skb, GFP_ATOMIC);
>  
> -			if (!fwd_skb && net_ratelimit()) {
> +			if (!fwd_skb && net_ratelimit())
>  				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
>  						   sdata->name);
> +			if (!fwd_skb)
>  				goto out;
> -			}

Oops, good catch! Thanks.

johannes

