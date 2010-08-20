Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab0HTNnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:43:33 -0400
Received: from ja.ssi.bg ([178.16.129.10]:55725 "EHLO u.domain.uli"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977Ab0HTNnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:43:32 -0400
Date: Fri, 20 Aug 2010 16:48:20 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: xiaoyu Du <tingsrain@gmail.com>
cc: Simon Horman <horms@verge.net.au>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
In-Reply-To: <AANLkTi=tVieTnz1R=9Jh45LweUwJ=mtszM1U9XAEVrK7@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.1008201643260.4539@u.domain.uli>
References: <20100817070036.GB742@verge.net.au> <Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
 <20100818002149.GA18114@verge.net.au> <20100817.172602.193696444.davem@davemloft.net>
 <AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
 <20100818055716.GA32429@verge.net.au> <AANLkTi=tVieTnz1R=9Jh45LweUwJ=mtszM1U9XAEVrK7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Fri, 20 Aug 2010, xiaoyu Du wrote:

> I just replied to thank for his idea then, as he gived me some ideas
> on how to manipulate
> checksum. I tested the code today, but it doesn't seem to work. (I just wrote a
> netfilter module and hooked the code on local_out , then ping6 the
> address on another PC,
> It failed.). I'll find out why.

	May be because I copied csum_ipv6_magic() code from
your patch. Please, try with one '~' before csum_ipv6_magic.

> >> >>>      icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
> >> >>>              &iph->daddr,
> >> >>>              skb->len - icmp_offset, IPPROTO_ICMPV6,
> >> >>>              0);
> >> >>>      skb->csum_start = skb_network_header(skb) - skb->head +
> >> >>>                        icmp_offset;
> >> >>>      skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
> >> >>>      skb->ip_summed = CHECKSUM_PARTIAL;

Regards

--
Julian Anastasov <ja@ssi.bg>
