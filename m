Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0HRF52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:57:28 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42489 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0HRF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:57:21 -0400
Date: Wed, 18 Aug 2010 14:57:16 +0900
From: Simon Horman <horms@verge.net.au>
To: xiaoyu Du <tingsrain@gmail.com>
Cc: David Miller <davem@davemloft.net>, ja@ssi.bg,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
Message-ID: <20100818055716.GA32429@verge.net.au>
References: <20100817070036.GB742@verge.net.au>
 <Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
 <20100818002149.GA18114@verge.net.au>
 <20100817.172602.193696444.davem@davemloft.net>
 <AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 12:20:14PM +0800, xiaoyu Du wrote:
> 2010/8/18 David Miller <davem@davemloft.net>:
> > From: Simon Horman <horms@verge.net.au>
> > Date: Wed, 18 Aug 2010 09:21:49 +0900
> >
> >> [ CCing netdev for comment ]
> >>
> >> On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
> >  ...
> >>>      May be ip_vs_checksum_complete() is not needed here?
> >>> Also, skb->csum is not valid for every ip_summed value.
> >>> May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
> >>> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
> >>> Later dev_queue_xmit() and skb_checksum_help() should take care
> >>> for the next steps. Something like this can be tested:
> >>>
> >>>      icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
> >>>              &iph->daddr,
> >>>              skb->len - icmp_offset, IPPROTO_ICMPV6,
> >>>              0);
> >>>      skb->csum_start = skb_network_header(skb) - skb->head +
> >>>                        icmp_offset;
> >>>      skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
> >>>      skb->ip_summed = CHECKSUM_PARTIAL;
> >>>
> >
> > Yes, using CHECKSUM_PARTIAL unconditionally would work.
> >
> Thanks, I learned this. You gave me a big cake.

[ please don't top-post ]

Xiaoyu, are you in a position to test the code proposed by Julian?
