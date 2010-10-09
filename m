Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab0JIS67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:58:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33279 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756806Ab0JIS66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:58:58 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/RXl1zWjHRrvUeCxcebS6eSKZoOt2/acyJPFUl1c
	bCa2wLKO83PwiY
Date: Sat, 9 Oct 2010 20:59:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Arnd Hannemann <arnd@arndnet.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
In-Reply-To: <201010091643.25065.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1010092049030.648@axis700.grange>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <201010091311.26335.arnd@arndb.de> <AANLkTimDd10oj=rruYcB=qTaWWMAJvSCQAJNi+nQqzp7@mail.gmail.com>
 <201010091643.25065.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010, Arnd Bergmann wrote:

> On Saturday 09 October 2010 13:59:45 Felipe Contreras wrote:
> > I know of tidspbridge, in my original mail I listed some links, one
> > which mentions: sh_mobile_ceu_camera, maybe i.MX31 users of the
> > mx3_camera driver: pcm037 and mx31moboard.
> >
> > http://article.gmane.org/gmane.linux.ports.sh.devel/8560
> 
> sh_mobile_ceu_camera looks fine on mainline. It only remaps
> the mmio registers, so no problem there. No arm platform even
> declares the device, so the report must be with an external tree.
> 
> The mx3_camera driver also looks fine, there is only one ioremap
> in there, which is completely sane.

Arnd, the drivers are fine, they just use the videobuf-dma-contig.c 
driver, which calls dma_alloc_coherent(). But the platforms, that use 
those drivers reserve that memory from system RAM dma_alloc_coherent(NULL, 
...) and dma_declare_coherent_memory(), and this is what breaks currently. 
As Felipe and Uwe in another mail in this thread mention, there are 
currently two platforms in the mainline, that do this. mx1, mx2, omap1 and 
mach-shmobile platforms are potentially affected too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
