Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1CRILq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:11:46 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:13867 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab1CRILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:11:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIKvgk1R8sEi/2dsb2JhbAClZniITbl+DYVWBJJc
Date: Fri, 18 Mar 2011 09:11:40 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Julia Lawall <julia@diku.dk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Ben Dooks'" <ben-linux@fluff.org>,
        kernel-janitors@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/watchdog/s3c2410_wdt.c: Convert
	release_resource to release_region/release_mem_region
Message-ID: <20110318081140.GS1751@infomag.iguana.be>
References: <1298738079-28893-1-git-send-email-julia@diku.dk> <002e01cbd72f$448ac150$cda043f0$%kim@samsung.com> <Pine.LNX.4.64.1102281110090.14560@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102281110090.14560@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia, Kukjin Kim,

> > Hmm...I think, 'res' is better for platform_get_resource().
> > Do we _really_ need to change the name?...
> 
> wdt_mem is a global variable.  Is res a good name for a global variable?  
> One could say wdt_mem = res, if that seems better.

If you look at the code then you have:
static struct resource  *wdt_mem;
static struct resource  *wdt_irq;

and in the probe function you have:
        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	...
	wdt_mem = request_mem_region(res->start, size, pdev->name);
	...
	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

So doing Julia's:
	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	...
	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
	...
	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)

seems the best solution to me (since you then have both resources being polulated via platform_get_resource(pdev,... ).

Kind regards,
Wim.

