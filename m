Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2AWVzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:55:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58968 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2AWVzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:55:38 -0500
Date: Mon, 23 Jan 2012 16:55:30 -0500 (EST)
Message-Id: <20120123.165530.944969261195932179.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@pradeepdalvi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH/RESEND net 5/5][NON-TRIVIAL] drivers/net/ethernet:
 dev_alloc_skb to netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327352667.2587.4.camel@edumazet-laptop>
References: <1327352046-6896-1-git-send-email-netdev@pradeepdalvi.com>
	<1327352667.2587.4.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 13:55:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 23 Jan 2012 22:04:27 +0100

> Le mardi 24 janvier 2012 à 02:24 +0530, Pradeep A. Dalvi a écrit :
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>   - Removed extra skb->dev = dev after netdev_alloc_skb
>> 
> 
> 
>>  
>>  /* Initialize the LANCE Rx and Tx rings. */
>>  static void
>> -lance_init_ring(struct net_device *dev, gfp_t gfp)
>> +lance_init_ring(struct net_device *dev)
>>  {
>>  	struct lance_private *lp = dev->ml_priv;
>>  	int i;
>> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>  		struct sk_buff *skb;
>>  		void *rx_buff;
>>  
>> -		skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>> +		skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>>  		lp->rx_skbuff[i] = skb;
>> -		if (skb) {
>> -			skb->dev = dev;
>> +		if (skb)
>>  			rx_buff = skb->data;
>> -		} else
>> -			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
>> +		else
>> +			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | GFP_AUTOMIC);
>>  		if (rx_buff == NULL)
>>  			lp->rx_ring[i].base = 0;
>>  		else
> 
> Thats really crap, please dont send us such patches, not even compiled.
> 
> alloc_skb() has nothing to do with dev_alloc_skb(), and there is a
> reason GFP_DMA is used in this driver.

This is really terrible.

Pradeep please stop sending these changes until you have your house
in order.  Your patches are buggy and ill conceived.

Please do not submit more patches in this area until you spend the
necessary time to truly understand these interfaces and how these code
snippets actually work.
