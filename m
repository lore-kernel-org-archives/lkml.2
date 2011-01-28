Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1A1OB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:01:29 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:45289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1A1OB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:01:27 -0500
Subject: Re: [PATCH 1/2] net/wireless/nl80211.c: Avoid call to
 genlmsg_cancel
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296224232-8115-1-git-send-email-julia@diku.dk>
References: <1296224232-8115-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 15:01:07 +0100
Message-ID: <1296223267.5118.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 15:17 +0100, Julia Lawall wrote:

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 9b62710..864ddfb 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2718,7 +2718,7 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
>  	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
>  			     NL80211_CMD_GET_MESH_CONFIG);
>  	if (!hdr)
> -		goto nla_put_failure;
> +		goto out;


> @@ -2954,7 +2955,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
>  	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
>  			     NL80211_CMD_GET_REG);
>  	if (!hdr)
> -		goto nla_put_failure;
> +		goto put_failure;
>  
>  	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2,
>  		cfg80211_regdomain->alpha2);

Seems fine. Actually, since the message is freed anyhow, the call to
genlmsg_cancel is *completely* unnecessary, I just put it in to make it
nest better and not rely on it not having side effects.

But why did you call the label differently? :)

johannes

