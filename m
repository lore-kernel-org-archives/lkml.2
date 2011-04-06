Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1DFMIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:08:54 -0400
Received: from brother.balabit.com ([195.70.62.219]:52615 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1DFMIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:08:53 -0400
Message-ID: <4D9C57D2.20303@balabit.hu>
Date: Wed, 06 Apr 2011 14:08:50 +0200
From: KOVACS Krisztian <hidden@balabit.hu>
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix build failure when ipv6 but xt_tproxy
 is built in
References: <1301451199.14261.327.camel@gandalf.stny.rr.com>	 <20110329.223536.245392030.davem@davemloft.net>	 <4D99CDA0.3030305@trash.net> <1302014626.67568.1.camel@nienna.balabit> <4D9B2BF2.2010606@trash.net>
In-Reply-To: <4D9B2BF2.2010606@trash.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/05/2011 04:49 PM, Patrick McHardy wrote:
>> What about something like this?
>>
>> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
>> index dcfd57e..1ef0e56 100644
>> --- a/net/netfilter/xt_TPROXY.c
>> +++ b/net/netfilter/xt_TPROXY.c
>> @@ -283,10 +283,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>>         const struct in6_addr *laddr;
>>         __be16 lport;
>>         int thoff;
>> -       int tproto;
>> +       u8 tproto = iph->nexthdr;
>>  
>> -       tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);
>> -       if (tproto < 0) {
>> +       thoff = ipv6_skip_exthdr(skb, sizeof(*iph), &tproto);
>> +       if (thoff < 0) {
>>                 pr_debug("unable to find transport header in IPv6 packet, dropping\n");
>>                 return NF_DROP;
>>         }
> 
> Looks good to me. Please formally submit this including a Signed-off-by:
> line and I'll push it upstream.

Will do, as soon as I have a chance to run the test suite. Thanks Patrick.

-- 
KOVACS Krisztian
