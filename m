Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0HRAZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:25:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47209
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab0HRAZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:25:44 -0400
Date: Tue, 17 Aug 2010 17:26:02 -0700 (PDT)
Message-Id: <20100817.172602.193696444.davem@davemloft.net>
To: horms@verge.net.au
Cc: ja@ssi.bg, linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net, tingsrain@gmail.com
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100818002149.GA18114@verge.net.au>
References: <20100817070036.GB742@verge.net.au>
	<Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
	<20100818002149.GA18114@verge.net.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Wed, 18 Aug 2010 09:21:49 +0900

> [ CCing netdev for comment ]
> 
> On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
 ...
>> 	May be ip_vs_checksum_complete() is not needed here?
>> Also, skb->csum is not valid for every ip_summed value.
>> May be we need to apply CHECKSUM_PARTIAL kind of setup for the IPv6.
>> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
>> Later dev_queue_xmit() and skb_checksum_help() should take care
>> for the next steps. Something like this can be tested:
>> 
>> 	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
>> 		&iph->daddr,
>> 		skb->len - icmp_offset, IPPROTO_ICMPV6,
>> 		0);
>> 	skb->csum_start = skb_network_header(skb) - skb->head +
>> 			  icmp_offset;
>> 	skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
>> 	skb->ip_summed = CHECKSUM_PARTIAL;
>> 

Yes, using CHECKSUM_PARTIAL unconditionally would work.
