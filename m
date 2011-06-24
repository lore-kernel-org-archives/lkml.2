Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab1FXPjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:39:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20228 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694Ab1FXPjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:39:09 -0400
Message-ID: <4E04AF8C.6050007@oracle.com>
Date: Fri, 24 Jun 2011 08:38:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for June 23 (net)
References: <20110623155431.6bfe3b40.sfr@canb.auug.org.au>	<20110623091429.2d51b0f0.randy.dunlap@oracle.com> <20110623.212120.2043173528294538748.davem@davemloft.net>
In-Reply-To: <20110623.212120.2043173528294538748.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E04AF97.002D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/11 21:21, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Thu, 23 Jun 2011 09:14:29 -0700
> 
>> On Thu, 23 Jun 2011 15:54:31 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20110622:
>>>
>>> The powerpc allyesconfig (and probably others) is still broken because we
>>> now build the staging drivers and because of a commit in the net tree.
>>> The breakage in Linus' tree is fixed by one of Andrew's patches above.
>>>
>>> The net tree gained 2 build failures that I have left (see above).
>>
>>
>> When CONFIG_INET is not enabled:
>>
>> net/core/dev.c:2535: error: implicit declaration of function 'ip_is_fragment'
> 
> I'll fix this like so:

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> diff --git a/include/net/ip.h b/include/net/ip.h
> index d603cd3..9fa9416 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -236,6 +236,11 @@ extern void ipfrag_init(void);
>  
>  extern void ip_static_sysctl_init(void);
>  
> +static inline bool ip_is_fragment(const struct iphdr *iph)
> +{
> +	return (iph->frag_off & htons(IP_MF | IP_OFFSET)) != 0;
> +}
> +
>  #ifdef CONFIG_INET
>  #include <net/dst.h>
>  
> @@ -250,11 +255,6 @@ int ip_decrease_ttl(struct iphdr *iph)
>  	return --iph->ttl;
>  }
>  
> -static inline bool ip_is_fragment(const struct iphdr *iph)
> -{
> -	return (iph->frag_off & htons(IP_MF | IP_OFFSET)) != 0;
> -}
> -
>  static inline
>  int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
>  {


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
