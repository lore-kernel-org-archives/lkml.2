Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2AWTTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:19:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49968 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab2AWTTe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <1327344034.6317.3.camel@joe2Laptop>
References: <1327343283-4830-1-git-send-email-netdev@pradeepdalvi.com>
	<1327344034.6317.3.camel@joe2Laptop>
Date: Tue, 24 Jan 2012 00:49:32 +0530
Message-ID: <CA+Dx6HY92Z8KtDXf73O3QMWLj__+Q2g7PxjiZ7omn+tuh8YK5A@mail.gmail.com>
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:10 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-01-23 at 23:58 +0530, Pradeep A. Dalvi wrote:
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>   - Removed extra skb->dev = dev after netdev_alloc_skb
> []
>> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
> []
>> @@ -871,13 +871,12 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>               struct sk_buff *skb;
>>               void *rx_buff;
>>
>> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>> +             skb = netdev_alloc_skb(dev, PKT_BUF_SZ);
>
> This change seems suspect.
> I stopped reading here.
>
> Perhaps you should break this large patch
> into multiple separate patches.
>
> The trivial, obviously correct
> and the possibly broken.

Not really sure what made you suspect something in here. If you could
help me understand possibly broken scenarios, would essentially be
helpful. Thanks in advance!
