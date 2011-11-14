Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1KNXdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:33:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62899 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:33:40 -0500
Date: Tue, 15 Nov 2011 00:33:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: linux-next: build failure after merge of the pm tree (and warning)
In-Reply-To: <201111150014.50898.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1111150032170.32143@axis700.grange>
References: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au>
 <201111150014.50898.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:2+x/CCe5TUr/l1+NE/sCJVtReVyEAF2KV2YnT/D8QdN
 loDvpVmX0LXEStrPwZUYCSAafke8Qde/KlaRPxgGBcU1YB+6G6
 H217JrfEg0qRGEaXg+Gg/GnaDjwKx4DYDOFSp8Lz+wzdgaIpKD
 nlQu4OvuMwAvPZU9zGOOB2zlJ4c8djQRaLubJexGR8OsUL+5z2
 r27PmPyU4wOKWD8sD/Aei0qwP0lofEVBVJk/dcJVuYVEwfI7RK
 ekIN/OxosuF8E72K1mR7XxYugrpN66xq4c7yKvRc0VAzc0LkuZ
 /YvjBHqnhLMYh3FEAGdu5OwvG3T3x/JCzK4/ZJi5eWtesQrxyt
 5ZmT1xS/13HnshtmxjeT0kpMrVKywq/TpSSU0HlHl4YDEMn1Mv
 sRa8CKTPud7Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Tue, 15 Nov 2011, Rafael J. Wysocki wrote:

> On Monday, November 14, 2011, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/dma/dmatest.c: In function 'dmatest_func':
> > drivers/dma/dmatest.c:255:2: error: implicit declaration of function 'set_freezable_with_signal' [-Werror=implicit-function-declaration]
> > 
> > Caused by commit cd3bc8fbc2d5 ("freezer: kill unused
> > set_freezable_with_signal()") interacting with commit 981ed70d8e4f
> > ("dmatest: make dmatest threads freezable") from Linus' tree (merged into
> > v3.2-rc1).
> > 
> > I reverted the pm tree commit for today.
> 
> Thanks, I've added the following patch to linux-pm/linux-next, which should
> fix this problem (Tejun, if that's not the right thing to do, please let me
> know).
> 
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Freezer: Make dmatest_func() use set_freezable()
> 
> According to the commit cd3bc8fbc2d55ae0918184fb34992054dc4eb710
> (freezer: kill unused set_freezable_with_signal()) changelog,
> it should be sufficient to use set_freezable() instead of
> set_freezable_with_signal(), which has been removed, in
> dmatest_func(), so do that and fix a build issue.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/dma/dmatest.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/dma/dmatest.c
> ===================================================================
> --- linux.orig/drivers/dma/dmatest.c
> +++ linux/drivers/dma/dmatest.c
> @@ -252,7 +252,7 @@ static int dmatest_func(void *data)
>  	int			i;
>  
>  	thread_name = current->comm;
> -	set_freezable_with_signal();
> +	set_freezable();

No, this isn't a correct fix.

Thanks
Guennadi

>  
>  	ret = -ENOMEM;
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
