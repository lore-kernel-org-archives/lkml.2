Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab1CRIfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:35:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55161 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab1CRIfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:35:38 -0400
Date: Fri, 18 Mar 2011 09:35:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Ben Dooks'" <ben-linux@fluff.org>,
        kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/watchdog/s3c2410_wdt.c: Convert release_resource
 to release_region/release_mem_region
In-Reply-To: <20110318081140.GS1751@infomag.iguana.be>
Message-ID: <Pine.LNX.4.64.1103180933590.2698@ask.diku.dk>
References: <1298738079-28893-1-git-send-email-julia@diku.dk>
 <002e01cbd72f$448ac150$cda043f0$%kim@samsung.com>
 <Pine.LNX.4.64.1102281110090.14560@pc-004.diku.dk> <20110318081140.GS1751@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, Wim Van Sebroeck wrote:

> Hi Julia, Kukjin Kim,
> 
> > > Hmm...I think, 'res' is better for platform_get_resource().
> > > Do we _really_ need to change the name?...
> > 
> > wdt_mem is a global variable.  Is res a good name for a global variable?  
> > One could say wdt_mem = res, if that seems better.
> 
> If you look at the code then you have:
> static struct resource  *wdt_mem;
> static struct resource  *wdt_irq;
> 
> and in the probe function you have:
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	...
> 	wdt_mem = request_mem_region(res->start, size, pdev->name);
> 	...
> 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> 
> So doing Julia's:
> 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	...
> 	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
> 	...
> 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)
> 
> seems the best solution to me (since you then have both resources being polulated via platform_get_resource(pdev,... ).

Actually, I later realized that one can also use the result of 
request_mem_region in place of res.  Even though it is not the same 
structure, it has the same start and end field information, which is the 
only information that is used.  But I haven't had a chance to send a patch 
that follows that strategy.  So if it is preferred to keep res, then that 
can be done.

julia
