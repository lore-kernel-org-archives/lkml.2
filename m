Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2AYSzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:55:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46231 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2AYSzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:55:10 -0500
Message-ID: <1327517706.2605.7.camel@edumazet-laptop>
Subject: Re: [PATCH net] amd/lance.c: dev_alloc_skb to netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2012 19:55:06 +0100
In-Reply-To: <1327517188-14088-1-git-send-email-netdev@pradeepdalvi.com>
References: <1327517188-14088-1-git-send-email-netdev@pradeepdalvi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 00:16 +0530, Pradeep A. Dalvi a écrit :
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb for amd/lance.c
>   - Removed extra skb->dev = dev
> 
> Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
> ---
>  drivers/net/ethernet/amd/lance.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
> index a6e2e84..a8a6b45 100644
> --- a/drivers/net/ethernet/amd/lance.c
> +++ b/drivers/net/ethernet/amd/lance.c
> @@ -871,12 +871,11 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>  		struct sk_buff *skb;
>  		void *rx_buff;
>  
> -		skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
> +		skb = __netdev_alloc_skb(dev, PKT_BUF_SZ, GFP_DMA | gfp);

Nack

As I already explained, alloc_skb() and netdev_alloc_skb() are
different.

Why do you repost this ?

nedev_alloc_skb() adds NET_SKB_PAD bytes.

This driver doesnt need this extra space.

(In fact it could use kmalloc(), since the skb themselves are not used
at all : At RX time, we perform a copybreak)



