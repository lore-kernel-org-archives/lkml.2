Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1KIReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:34:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1KIReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:34:19 -0500
Message-ID: <1320860080.24903.2.camel@dcbw.foobar.com>
Subject: Re: [PATCH] wireless: libertas: fix unaligned le64 accesses
From: Dan Williams <dcbw@redhat.com>
To: Steven Miao <realmz6@gmail.com>
Cc: "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 09 Nov 2011 11:34:40 -0600
In-Reply-To: <1320827440-16904-1-git-send-email-realmz6@gmail.com>
References: <1320827440-16904-1-git-send-email-realmz6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 16:30 +0800, Steven Miao wrote:
> use get_unaligned_le64() to get timestamp
> 
> Signed-off-by: Steven Miao <realmz6@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index b456a53..f23c2b1 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -630,7 +630,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
>  			if (channel &&
>  			    !(channel->flags & IEEE80211_CHAN_DISABLED))
>  				cfg80211_inform_bss(wiphy, channel,
> -					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
> +					bssid, get_unaligned_le64(tsfdesc),
>  					capa, intvl, ie, ielen,
>  					LBS_SCAN_RSSI_TO_MBM(rssi),
>  					GFP_KERNEL);


