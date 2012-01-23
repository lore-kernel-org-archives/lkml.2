Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2AWVxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:53:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58928 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2AWVxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:53:40 -0500
Date: Mon, 23 Jan 2012 16:53:29 -0500 (EST)
Message-Id: <20120123.165329.738852681807240808.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: joe@perches.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+Dx6HbxEFLTMMGJ-ASY=4zNthRtWps6KnFiPNLAz6o+HVmS9g@mail.gmail.com>
References: <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
	<1327348561.7527.0.camel@joe2Laptop>
	<CA+Dx6HbxEFLTMMGJ-ASY=4zNthRtWps6KnFiPNLAz6o+HVmS9g@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 13:53:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Tue, 24 Jan 2012 02:11:43 +0530

> On Tue, Jan 24, 2012 at 1:26 AM, Joe Perches <joe@perches.com> wrote:
>> On Tue, 2012-01-24 at 00:49 +0530, Pradeep A. Dalvi wrote:
>>> On Tue, Jan 24, 2012 at 12:10 AM, Joe Perches <joe@perches.com> wrote:
>>> > On Mon, 2012-01-23 at 23:58 +0530, Pradeep A. Dalvi wrote:
>>> >> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>> >>   - Removed extra skb->dev = dev after netdev_alloc_skb
>>> > []
>>> >> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
>>> > []
>>> >> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>> >>               struct sk_buff *skb;
>>> >>               void *rx_buff;
>>> >>
>>> >> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>>> >> +             skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>>> >
>>> > This change seems suspect.
>>> Not really sure what made you suspect something in here. If you could
>>> help me understand possibly broken scenarios, would essentially be
>>> helpful. Thanks in advance!
>>
>> Where did the GFP_DMA go?
> 
> Aah! Is that really needed? Cause from my understanding, priority GFP
> flag __GFP_DMA is anyway negated in __alloc_skb, in a way from all
> sources i.e. netdev_alloc_skb or dev_alloc_skb or even alloc_skb. Am I
> missing something here?

GFP_DATA is negated for the SKB metadata allocation, but preserved for
the actual packet data allocation.

Could you please back off a bit and take your time on these changes?

Your transformations are adding bugs, and you make it clear that you
don't even understand how the allocation functions work semantically.

I don't really think you are knowledgable enough to make these
transformations safely at this time, and this is needlessly wasting
patch reviewer resources.
