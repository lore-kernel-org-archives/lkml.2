Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2BFRnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:43:03 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64549 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab2BFRnB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:43:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120206.120740.1750013890695365167.davem@davemloft.net>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<d8ad7b1e88df72e284cbc8b8fba1745530923375.1328445742.git.netdev@pradeepdalvi.com>
	<20120206.120740.1750013890695365167.davem@davemloft.net>
Date: Mon, 6 Feb 2012 23:13:00 +0530
Message-ID: <CA+Dx6HaRFw-zACqQb-VWCnGyA5jagZmNhQx=Os=Nbv626O4msg@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] netdev: ethernet dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 10:37 PM, David Miller <davem@davemloft.net> wrote:
> From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
> Date: Sun,  5 Feb 2012 18:21:05 +0530
>
>> From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
>>
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>   - Removed extra skb->dev = dev after netdev_alloc_skb
>>
>> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>
>
> I'm not applying this, you screw up the code formatting in too
> many locations.
>
> Do NOT take the output of checkpatch literally, look at the result
> and determine on your own whether it looks reasonable or not:
>
>> -             struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
>> +             struct sk_buff *skb =
>> +                     netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
>
> This, looks like crap.  The longer line is better.
>
>> -                     struct sk_buff *skb = dev_alloc_skb(hmp->rx_buf_sz + 2);
>> +                     struct sk_buff *skb = netdev_alloc_skb(dev,
>> +                                     hmp->rx_buf_sz + 2);
>
> Same thing here.
>
>> -                     struct sk_buff *skb = dev_alloc_skb(yp->rx_buf_sz + 2);
>> +                     struct sk_buff *skb = netdev_alloc_skb(dev,
>> +                                     yp->rx_buf_sz + 2);
>
> Column line-up rule violated, and this looks like crap as a result.  The long
> single line would look 100 times better.
>
> And there are many other instances of this problem.
>
> Here's my advice, just do the textual change of the function name and add
> the network device argument, don't mess with the coding style at all.
>
> You're fare much better than how these patches ended up in the cases where
> you tried to "improve" things.

I shall fix these and resubmit patch again.

Thanks & regards,
Pradeep A. Dalvi
