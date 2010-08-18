Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0HREUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:20:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0HREUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hlcBv4/Lh+Ml9D+oGUtIudBN6r2zDbj0iHzoJjvf7tdjAAyxIbME808kZ0GgTcs19+
         i5Gaguo6VedlNumwHgLgiTrq9XpP3PtI1cxN0Tmk5F5pUXHajePy8kwlffF+F11uneed
         nr9rTKUjENAKgBYERFSnFQOCbBJ4dtUeQsT3M=
MIME-Version: 1.0
In-Reply-To: <20100817.172602.193696444.davem@davemloft.net>
References: <20100817070036.GB742@verge.net.au>
	<Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
	<20100818002149.GA18114@verge.net.au>
	<20100817.172602.193696444.davem@davemloft.net>
Date: Wed, 18 Aug 2010 12:20:14 +0800
Message-ID: <AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
From: xiaoyu Du <tingsrain@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: horms@verge.net.au, ja@ssi.bg, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kaber@trash.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I learned this. You gave me a big cake.


2010/8/18 David Miller <davem@davemloft.net>:
> From: Simon Horman <horms@verge.net.au>
> Date: Wed, 18 Aug 2010 09:21:49 +0900
>
>> [ CCing netdev for comment ]
>>
>> On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
>  ...
>>>      May be ip_vs_checksum_complete() is not needed here?
>>> Also, skb->csum is not valid for every ip_summed value.
>>> May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
>>> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
>>> Later dev_queue_xmit() and skb_checksum_help() should take care
>>> for the next steps. Something like this can be tested:
>>>
>>>      icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
>>>              &iph->daddr,
>>>              skb->len - icmp_offset, IPPROTO_ICMPV6,
>>>              0);
>>>      skb->csum_start = skb_network_header(skb) - skb->head +
>>>                        icmp_offset;
>>>      skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
>>>      skb->ip_summed = CHECKSUM_PARTIAL;
>>>
>
> Yes, using CHECKSUM_PARTIAL unconditionally would work.
>
