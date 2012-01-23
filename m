Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2AWXEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:04:12 -0500
Received: from mail-lpp01m010-f66.google.com ([209.85.215.66]:51759 "EHLO
	mail-lpp01m010-f66.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab2AWXEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:04:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120123.165329.738852681807240808.davem@davemloft.net>
References: <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
	<1327348561.7527.0.camel@joe2Laptop>
	<CA+Dx6HbxEFLTMMGJ-ASY=4zNthRtWps6KnFiPNLAz6o+HVmS9g@mail.gmail.com>
	<20120123.165329.738852681807240808.davem@davemloft.net>
Date: Tue, 24 Jan 2012 04:34:08 +0530
Message-ID: <CA+Dx6HZJpZnvJG91G4ybC_-dNWRhVkPcqa+ANCcBOHU0nY9Djg@mail.gmail.com>
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 3:23 AM, David Miller <davem@davemloft.net> wrote:
> From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
> Date: Tue, 24 Jan 2012 02:11:43 +0530
>
>> On Tue, Jan 24, 2012 at 1:26 AM, Joe Perches <joe@perches.com> wrote:
>>> On Tue, 2012-01-24 at 00:49 +0530, Pradeep A. Dalvi wrote:
>>>> On Tue, Jan 24, 2012 at 12:10 AM, Joe Perches <joe@perches.com> wrote:
>>>> > On Mon, 2012-01-23 at 23:58 +0530, Pradeep A. Dalvi wrote:
>>>> >> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>>> >>   - Removed extra skb->dev = dev after netdev_alloc_skb
>>>> > []
>>>> >> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
>>>> > []
>>>> >> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>>> >>               struct sk_buff *skb;
>>>> >>               void *rx_buff;
>>>> >>
>>>> >> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>>>> >> +             skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>>>> >
>>>> > This change seems suspect.
>>>> Not really sure what made you suspect something in here. If you could
>>>> help me understand possibly broken scenarios, would essentially be
>>>> helpful. Thanks in advance!
>>>
>>> Where did the GFP_DMA go?
>>
>> Aah! Is that really needed? Cause from my understanding, priority GFP
>> flag __GFP_DMA is anyway negated in __alloc_skb, in a way from all
>> sources i.e. netdev_alloc_skb or dev_alloc_skb or even alloc_skb. Am I
>> missing something here?
>
> GFP_DATA is negated for the SKB metadata allocation, but preserved for
> the actual packet data allocation.

Pardon my ignorance! Although this error occurred _exactly like_ the
typo in above statement. At the same time, I also called for help for
this special case.

> Could you please back off a bit and take your time on these changes?
>
> Your transformations are adding bugs, and you make it clear that you
> don't even understand how the allocation functions work semantically.
>
> I don't really think you are knowledgable enough to make these
> transformations safely at this time, and this is needlessly wasting
> patch reviewer resources.

There are first 4 patches with trivial changes. And 5th patch
(including first 4) has been resubmitted reverting errors in this
file. I know I made a mistake, which I've accepted and corrected as
well. Although above statements are kind of discouraging &
unnecessary, especially when changes in 1 file are incorrect out of
118 files.

If I expected your assistance, it was for certain special cases. And
so far has received correct directions, and above typo/spell-mistake
doesn't really redefine you or reconstruct somebody else in our eyes.
I still would expect your help wherever possible. And needlessly, you
remain the same.

Cheers,
Pradeep A. Dalvi
