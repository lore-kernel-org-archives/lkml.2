Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0HWCyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:54:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57157 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0HWCyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DYIkvOSuN9acY70YGZC3eHBYEu/8oh4ylOIfDuRA2jsSqlM0YCPj04akzcjNOSWWDl
         0eDdJBGrN+6Loo8DtOxarxIq20MERGwoRcB/I8Id/q0rsyEKht+FoHrzjl8So2kIxay3
         /Xk767t7foseDVBNVulHFPDSrz0xswZBSJkTM=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.1008201643260.4539@u.domain.uli>
References: <20100817070036.GB742@verge.net.au>
	<Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
	<20100818002149.GA18114@verge.net.au>
	<20100817.172602.193696444.davem@davemloft.net>
	<AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
	<20100818055716.GA32429@verge.net.au>
	<AANLkTi=tVieTnz1R=9Jh45LweUwJ=mtszM1U9XAEVrK7@mail.gmail.com>
	<Pine.LNX.4.58.1008201643260.4539@u.domain.uli>
Date: Mon, 23 Aug 2010 10:54:32 +0800
Message-ID: <AANLkTikwd8Tfj2tZrfgFi+OGhJGOSMAFhPqSVtSrAX-f@mail.gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
From: xiaoyu Du <tingsrain@gmail.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kaber@trash.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I had added it and test it, it works.

2010/8/20 Julian Anastasov <ja@ssi.bg>:
>
>        Hello,
>
> On Fri, 20 Aug 2010, xiaoyu Du wrote:
>
>> I just replied to thank for his idea then, as he gived me some ideas
>> on how to manipulate
>> checksum. I tested the code today, but it doesn't seem to work. (I just wrote a
>> netfilter module and hooked the code on local_out , then ping6 the
>> address on another PC,
>> It failed.). I'll find out why.
>
>        May be because I copied csum_ipv6_magic() code from
> your patch. Please, try with one '~' before csum_ipv6_magic.
>
>> >> >>>      icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
>> >> >>>              &iph->daddr,
>> >> >>>              skb->len - icmp_offset, IPPROTO_ICMPV6,
>> >> >>>              0);
>> >> >>>      skb->csum_start = skb_network_header(skb) - skb->head +
>> >> >>>                        icmp_offset;
>> >> >>>      skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
>> >> >>>      skb->ip_summed = CHECKSUM_PARTIAL;
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
