Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0HTLOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:14:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34166 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0HTLOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kv5PYZtAa38C3Dcic7OS/ZDeWGs9o2NvayDAgzIMG+/nUUmyjOiqNZGGF5TZiaNVAw
         3bSIsO/0NPDxS1swfn3D0oCpA7seFKJ8iv9DXaERyAxnaVB7DR+BaKtBttAJKvexp1k5
         7PUfBj5HIZTFUPYoQhI9Kwl/YnFMvwKuHv47Y=
MIME-Version: 1.0
In-Reply-To: <20100818055716.GA32429@verge.net.au>
References: <20100817070036.GB742@verge.net.au>
	<Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
	<20100818002149.GA18114@verge.net.au>
	<20100817.172602.193696444.davem@davemloft.net>
	<AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
	<20100818055716.GA32429@verge.net.au>
Date: Fri, 20 Aug 2010 19:14:38 +0800
Message-ID: <AANLkTi=tVieTnz1R=9Jh45LweUwJ=mtszM1U9XAEVrK7@mail.gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
From: xiaoyu Du <tingsrain@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: David Miller <davem@davemloft.net>, ja@ssi.bg,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just replied to thank for his idea then, as he gived me some ideas
on how to manipulate
checksum. I tested the code today, but it doesn't seem to work. (I just wrote a
netfilter module and hooked the code on local_out , then ping6 the
address on another PC,
It failed.). I'll find out why.

2010/8/18 Simon Horman <horms@verge.net.au>:
> On Wed, Aug 18, 2010 at 12:20:14PM +0800, xiaoyu Du wrote:
>> 2010/8/18 David Miller <davem@davemloft.net>:
>> > From: Simon Horman <horms@verge.net.au>
>> > Date: Wed, 18 Aug 2010 09:21:49 +0900
>> >
>> >> [ CCing netdev for comment ]
>> >>
>> >> On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
>> >  ...
>> >>>      May be ip_vs_checksum_complete() is not needed here?
>> >>> Also, skb->csum is not valid for every ip_summed value.
>> >>> May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
>> >>> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
>> >>> Later dev_queue_xmit() and skb_checksum_help() should take care
>> >>> for the next steps. Something like this can be tested:
>> >>>
>> >>>      icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
>> >>>              &iph->daddr,
>> >>>              skb->len - icmp_offset, IPPROTO_ICMPV6,
>> >>>              0);
>> >>>      skb->csum_start = skb_network_header(skb) - skb->head +
>> >>>                        icmp_offset;
>> >>>      skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
>> >>>      skb->ip_summed = CHECKSUM_PARTIAL;
>> >>>
>> >
>> > Yes, using CHECKSUM_PARTIAL unconditionally would work.
>> >
>> Thanks, I learned this. You gave me a big cake.
>
> [ please don't top-post ]
>
> Xiaoyu, are you in a position to test the code proposed by Julian?
>
