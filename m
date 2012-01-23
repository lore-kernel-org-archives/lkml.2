Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2AWNPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:15:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58544 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321Ab2AWNPj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <CA+Dx6HbqAhjS6TNy=t+jvrwrmpTuQ3c=Wq0UnMzFRr9Q+JKpKQ@mail.gmail.com>
References: <1327179463-13980-1-git-send-email-netdev@pradeepdalvi.com>
	<1327311925.2525.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CA+Dx6HbqAhjS6TNy=t+jvrwrmpTuQ3c=Wq0UnMzFRr9Q+JKpKQ@mail.gmail.com>
Date: Mon, 23 Jan 2012 18:45:37 +0530
Message-ID: <CA+Dx6HY6x7B0Z7hL8EpuPVz2cAKUc6S3f7prjjQZ8ycS79Rjew@mail.gmail.com>
Subject: Re: [PATCH] netdev/ethernet: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:07 PM, Pradeep A. Dalvi
<netdev@pradeepdalvi.com> wrote:
> On Mon, Jan 23, 2012 at 3:15 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Le dimanche 22 janvier 2012 à 02:27 +0530, Pradeep A. Dalvi a écrit :
>>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>>
>>
>> ...
>>
>>
>>> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
>>> index f67a5d3..68fd765 100644
>>> --- a/drivers/net/ethernet/3com/3c515.c
>>> +++ b/drivers/net/ethernet/3com/3c515.c
>>> @@ -826,7 +826,7 @@ static int corkscrew_open(struct net_device *dev)
>>>                               vp->rx_ring[i].next = 0;
>>>                       vp->rx_ring[i].status = 0;      /* Clear complete bit. */
>>>                       vp->rx_ring[i].length = PKT_BUF_SZ | 0x80000000;
>>> -                     skb = dev_alloc_skb(PKT_BUF_SZ);
>>> +                     skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>>>                       vp->rx_skbuff[i] = skb;
>>>                       if (skb == NULL)
>>>                               break;  /* Bad news!  */
>>
>>
>> One of the difference between netdev_alloc_skb() and dev_alloc_skb() is
>> the former initializes skb->dev.
>>
>> So you should remove the extra "skb->dev = dev;" lines that sometimes
>> are after the dev_alloc_skb() calls.
>>
>> [ They were redundant anyway because eth_type_trans() also sets skb->dev
>> ]
>
> Thanks! Shall take extra skb->dev = dev into consideration.
>
> Eric, is this ok to assume that the memory address given to
> dma_map_single & received from dma_unmap_single would remain same
> across all platforms? Thanks in advance!

Eric, please ignore last question. Realized my mistake! :-)
