Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2AWVaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:30:16 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40985 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068Ab2AWVaN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:30:13 -0500
MIME-Version: 1.0
In-Reply-To: <1327352667.2587.4.camel@edumazet-laptop>
References: <1327352046-6896-1-git-send-email-netdev@pradeepdalvi.com>
	<1327352667.2587.4.camel@edumazet-laptop>
Date: Tue, 24 Jan 2012 03:00:12 +0530
Message-ID: <CA+Dx6HZK2ns94pG79FfPZpVO9+QY8LQ00zFyeK5zZjc6HLq-cQ@mail.gmail.com>
Subject: Re: [PATCH/RESEND net 5/5][NON-TRIVIAL] drivers/net/ethernet:
 dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 2:34 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 24 janvier 2012 à 02:24 +0530, Pradeep A. Dalvi a écrit :
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>   - Removed extra skb->dev = dev after netdev_alloc_skb
>>
>
>
>>
>>  /* Initialize the LANCE Rx and Tx rings. */
>>  static void
>> -lance_init_ring(struct net_device *dev, gfp_t gfp)
>> +lance_init_ring(struct net_device *dev)
>>  {
>>       struct lance_private *lp = dev->ml_priv;
>>       int i;
>> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>               struct sk_buff *skb;
>>               void *rx_buff;
>>
>> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>> +             skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>>               lp->rx_skbuff[i] = skb;
>> -             if (skb) {
>> -                     skb->dev = dev;
>> +             if (skb)
>>                       rx_buff = skb->data;
>> -             } else
>> -                     rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
>> +             else
>> +                     rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | GFP_AUTOMIC);
>>               if (rx_buff == NULL)
>>                       lp->rx_ring[i].base = 0;
>>               else
>
> Thats really crap, please dont send us such patches, not even compiled.
>
> alloc_skb() has nothing to do with dev_alloc_skb(), and there is a
> reason GFP_DMA is used in this driver.

Would drop these changes and resubmit the patch. Thanks!
