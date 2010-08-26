Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0HZJGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:06:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54837 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753396Ab0HZJGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:06:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+y1vRMfj6ytkvP6jxWUJ9bsiIWus0EYu4x41WOK3
	lLAOhInxTjtkWh
Date: Thu, 26 Aug 2010 11:06:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: mitov@issp.bas.bg, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        =?ISO-8859-15?Q?Philippe_R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory()
 API
In-Reply-To: <20100826152333K.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.1008261100150.14167@axis700.grange>
References: <201008201450.12585.mitov@issp.bas.bg> <20100826144000C.fujita.tomonori@lab.ntt.co.jp>
 <201008260904.19973.mitov@issp.bas.bg> <20100826152333K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, FUJITA Tomonori wrote:

> On Thu, 26 Aug 2010 09:04:14 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Thursday, August 26, 2010 08:40:47 am FUJITA Tomonori wrote:
> > > On Fri, 20 Aug 2010 14:50:12 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > > 
> > > > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > > > 
> > > > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > > > Helps for videobuf-dma-contig framework.
> > > > > > > 
> > > > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > > > coherent memory for latter usage,
> > > > > > 
> > > > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > > > We use coherent memory because it turns out to be contiguous.
> > > > > 
> > > > > Hmm, you don't care about coherency? You just need contiguous memory?
> > > > 
> > > > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > > > transfer finishes user land is able to see the new data. Could be done by something like
> > > > dma_{,un}map_single()
> > > 
> > > Then, we should avoid using coherent memory as I exaplained before. In
> > > addition, dma_alloc_coherent can't provide large enough contigous
> > > memory for some drivers so this patch doesn't help much.
> > 
> > Please, look at drivers/media/video/videobuf-dma-contig.c. Using coherent memory
> > is inavoidable for now, there is no alternative for it for now. The two new functions,
> > which I propose are just helpers for those of us who already use coherent memory
> > (via videobuf-dma-contig API). May be adding these two functions to 
> > drivers/media/video/videobuf-dma-contig.c will be better solution?
> 
> If you add something to the videobuf-dma-contig API, that's fine by me
> because drivers/media/video/videobuf-dma-contig.c uses the own
> structure and plays with dma_alloc_coherent. As long as a driver
> doesn't touch device->dma_mem directly, it's fine, I think (that is,
> dt3155v4l driver is broken). There are already some workarounds for
> contigous memory in several drivers anyway.

No, this will not work - this API has to be used from board code and 
videobuf can be built modular.

> We will have the proper API for contiguous memory. I don't think that
> adding such workaround to the DMA API is a good idea.

We have currently a number of boards broken in the mainline. They must be 
fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
as I suggested earlier, we need either this or my patch series

http://thread.gmane.org/gmane.linux.ports.sh.devel/8595

for 2.6.36.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
