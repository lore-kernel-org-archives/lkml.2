Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab0KRScQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:32:16 -0500
Received: from stinky.trash.net ([213.144.137.162]:39526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0KRScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:32:14 -0500
Message-ID: <4CE5712B.2080909@trash.net>
Date: Thu, 18 Nov 2010 19:32:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netfilter-devel@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, KOVACS Krisztian <hidden@balabit.hu>,
        Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: linux-next: Tree for November 18 (netfilter)
References: <20101118134256.fe132215.sfr@canb.auug.org.au> <20101118092520.6ad964c7.randy.dunlap@oracle.com>
In-Reply-To: <20101118092520.6ad964c7.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2010 18:25, schrieb Randy Dunlap:
> On Thu, 18 Nov 2010 13:42:56 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20101117:
> 
> 
> include/net/netfilter/nf_conntrack.h:94: error: field 'ct_general' has incomplete type
> include/net/netfilter/nf_conntrack.h:174: error: 'const struct sk_buff' has no member named 'nfct'
> include/net/netfilter/nf_conntrack.h:181: error: implicit declaration of function 'nf_conntrack_put'
> include/net/netfilter/nf_conntrack_ecache.h:35: error: 'struct net' has no member named 'ct'
> include/net/netfilter/nf_conntrack_core.h:60: error: 'struct sk_buff' has no member named 'nfct'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:36: error: 'struct sk_buff' has no member named 'nfct'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: implicit declaration of function 'nf_ct_zone'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: 'struct sk_buff' has no member named 'nfct'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
> net/ipv6/netfilter/nf_conntrack_reasm.c:598: error: implicit declaration of function 'nf_conntrack_put_reasm'
> net/ipv6/netfilter/nf_conntrack_reasm.c:598: error: 'struct sk_buff' has no member named 'nfct_reasm'
> net/ipv6/netfilter/nf_conntrack_reasm.c:599: error: implicit declaration of function 'nf_conntrack_get_reasm'
> net/ipv6/netfilter/nf_conntrack_reasm.c:600: error: 'struct sk_buff' has no member named 'nfct_reasm'
> 
> 
> randconfig file is attached.

Krisztian, Balazs, could you please have a look at this? If the
intention is to use NF_DEFRAG_IPV6 without conntrack, we probably
need a couple of ifdefs.
