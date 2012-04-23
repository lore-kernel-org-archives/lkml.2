Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2DWWiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:38:17 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42184 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753549Ab2DWWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:38:15 -0400
Message-ID: <4F95D9F5.3040407@xenotime.net>
Date: Mon, 23 Apr 2012 15:38:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] net sysctl: Add place holder functions for when sysctl
 support is compiled out of the kernel.
References: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>	<4F958598.6080305@xenotime.net> <m1lilmt7v5.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1lilmt7v5.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 03:13 PM, Eric W. Biederman wrote:

> 
> Randy Dunlap <rdunlap@xenotime.net> reported:
>> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120420:
>>
>>
>>
>> ERROR: "unregister_net_sysctl_table" [net/phonet/phonet.ko] undefined!
>> ERROR: "register_net_sysctl" [net/phonet/phonet.ko] undefined!
>>
>> when CONFIG_SYSCTL is not enabled.
> 
> Add static inline stub functions to gracefully handle the case when sysctl
> support is not present.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>


Yep, that works.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  include/net/net_namespace.h |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 3ee4a3d..ac9195e 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -284,11 +284,20 @@ struct ctl_table_header;
>  
>  #ifdef CONFIG_SYSCTL
>  extern int net_sysctl_init(void);
> -#else
> -static inline int net_sysctl_init(void) { return 0; }
> -#endif
>  extern struct ctl_table_header *register_net_sysctl(struct net *net,
>  	const char *path, struct ctl_table *table);
>  extern void unregister_net_sysctl_table(struct ctl_table_header *header);
> +#else
> +static inline int net_sysctl_init(void) { return 0; }
> +static inline struct ctl_table_header *register_net_sysctl(struct net *net,
> +	const char *path, struct ctl_table *table)
> +{
> +	return NULL;
> +}
> +static inline void unregister_net_sysctl_table(struct ctl_table_header *header)
> +{
> +}
> +#endif
> +
>  
>  #endif /* __NET_NET_NAMESPACE_H */



-- 
~Randy
