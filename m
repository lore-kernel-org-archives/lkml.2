Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2AWVEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:04:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48935 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2AWVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:04:32 -0500
Message-ID: <1327352667.2587.4.camel@edumazet-laptop>
Subject: Re: [PATCH/RESEND net 5/5][NON-TRIVIAL] drivers/net/ethernet:
 dev_alloc_skb to netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date: Mon, 23 Jan 2012 22:04:27 +0100
In-Reply-To: <1327352046-6896-1-git-send-email-netdev@pradeepdalvi.com>
References: <1327352046-6896-1-git-send-email-netdev@pradeepdalvi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 02:24 +0530, Pradeep A. Dalvi a écrit :
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 


>  
>  /* Initialize the LANCE Rx and Tx rings. */
>  static void
> -lance_init_ring(struct net_device *dev, gfp_t gfp)
> +lance_init_ring(struct net_device *dev)
>  {
>  	struct lance_private *lp = dev->ml_priv;
>  	int i;
> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>  		struct sk_buff *skb;
>  		void *rx_buff;
>  
> -		skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
> +		skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>  		lp->rx_skbuff[i] = skb;
> -		if (skb) {
> -			skb->dev = dev;
> +		if (skb)
>  			rx_buff = skb->data;
> -		} else
> -			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
> +		else
> +			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | GFP_AUTOMIC);
>  		if (rx_buff == NULL)
>  			lp->rx_ring[i].base = 0;
>  		else

Thats really crap, please dont send us such patches, not even compiled.

alloc_skb() has nothing to do with dev_alloc_skb(), and there is a
reason GFP_DMA is used in this driver.



