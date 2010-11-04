Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0KDP5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:57:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46259 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0KDP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:56:58 -0400
Message-ID: <4CD2D7A3.9000509@oracle.com>
Date: Thu, 04 Nov 2010 08:56:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>, Thomas Graf <tgraf@suug.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: Linux 2.6.37-rc1 (net/sched: cls_cgroup)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103142156.73c2d3c9.randy.dunlap@oracle.com> <1288821677.2718.27.camel@edumazet-laptop> <20101103233105.GA26124@gondor.apana.org.au>
In-Reply-To: <20101103233105.GA26124@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/10 16:31, Herbert Xu wrote:
> On Wed, Nov 03, 2010 at 11:01:17PM +0100, Eric Dumazet wrote:
>>
>> commits 8e039d84b323c450 
>> (cgroups: net_cls as module)
>>
>> followed by commit f845172531f
>> (cls_cgroup: Store classid in struct sock)
> 
> Indeed, it looks like the tree I worked on didn't have the first
> patch applied for some reason.
> 
> Anyway, this patch should fix the problem.  Thanks Eric!
> 
> cls_cgroup: Fix crash on module unload
> 
> Somewhere along the lines net_cls_subsys_id became a macro when
> cls_cgroup is built as a module.  Not only did it make cls_cgroup
> completely useless, it also causes it to crash on module unload.
> 
> This patch fixes this by removing that macro.
> 
> Thanks to Eric Dumazet for diagnosing this problem.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> 
> diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
> index 37dff78..d49c40f 100644
> --- a/net/sched/cls_cgroup.c
> +++ b/net/sched/cls_cgroup.c
> @@ -34,8 +34,6 @@ struct cgroup_subsys net_cls_subsys = {
>  	.populate	= cgrp_populate,
>  #ifdef CONFIG_NET_CLS_CGROUP
>  	.subsys_id	= net_cls_subsys_id,
> -#else
> -#define net_cls_subsys_id net_cls_subsys.subsys_id
>  #endif
>  	.module		= THIS_MODULE,
>  };
> 
> Cheers,


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
