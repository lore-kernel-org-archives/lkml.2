Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2AUPyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:54:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49341 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2AUPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:54:05 -0500
Message-ID: <1327161238.2574.3.camel@edumazet-laptop>
Subject: Re: [PATCH 1/1] netdev/ethernet: dev_alloc_skb to netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Date: Sat, 21 Jan 2012 16:53:58 +0100
In-Reply-To: <1327156996-12505-1-git-send-email-netdev@pradeepdalvi.com>
References: <1327156996-12505-1-git-send-email-netdev@pradeepdalvi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 21 janvier 2012 à 20:13 +0530, Pradeep A. Dalvi a écrit :
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
> 
> Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
> ---

...

>  114 files changed, 257 insertions(+), 203 deletions(-)
> 
> diff --git a/drivers/net/ethernet/3com/3c501.c b/drivers/net/ethernet/3com/3c501.c
> index 68da81d..9ebc739 100644
> --- a/drivers/net/ethernet/3com/3c501.c
> +++ b/drivers/net/ethernet/3com/3c501.c
> @@ -702,7 +702,7 @@ static void el_receive(struct net_device *dev)
>  	 */
>  
>  	outb(AX_SYS, AX_CMD);
> -	skb = dev_alloc_skb(pkt_len+2);
> +	skb = netdev_alloc_skb(dev, pkt_len + NET_IP_ALIGN);
>  
>  	/*
>  	 *	Start of frame
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c


So the very first chunk of this huge patch is wrong, since it adds a
true bug.  (You dont change the skb_reserve(skb, 2); later)

I stopped my review at this first chunk.

Please dont add NET_IP_ALIGN on drivers if you cant test the change
yourself.
 
Some hardware really need the hardcoded 2 value.



