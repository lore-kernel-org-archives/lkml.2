Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0HZGYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:24:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:55133 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0HZGYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:24:39 -0400
Date: Thu, 26 Aug 2010 15:24:19 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008260904.19973.mitov@issp.bas.bg>
References: <201008201450.12585.mitov@issp.bas.bg>
	<20100826144000C.fujita.tomonori@lab.ntt.co.jp>
	<201008260904.19973.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100826152333K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 26 Aug 2010 15:24:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 09:04:14 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> On Thursday, August 26, 2010 08:40:47 am FUJITA Tomonori wrote:
> > On Fri, 20 Aug 2010 14:50:12 +0300
> > Marin Mitov <mitov@issp.bas.bg> wrote:
> > 
> > > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > 
> > > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > > 
> > > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > > Helps for videobuf-dma-contig framework.
> > > > > > 
> > > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > > coherent memory for latter usage,
> > > > > 
> > > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > > We use coherent memory because it turns out to be contiguous.
> > > > 
> > > > Hmm, you don't care about coherency? You just need contiguous memory?
> > > 
> > > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > > transfer finishes user land is able to see the new data. Could be done by something like
> > > dma_{,un}map_single()
> > 
> > Then, we should avoid using coherent memory as I exaplained before. In
> > addition, dma_alloc_coherent can't provide large enough contigous
> > memory for some drivers so this patch doesn't help much.
> 
> Please, look at drivers/media/video/videobuf-dma-contig.c. Using coherent memory
> is inavoidable for now, there is no alternative for it for now. The two new functions,
> which I propose are just helpers for those of us who already use coherent memory
> (via videobuf-dma-contig API). May be adding these two functions to 
> drivers/media/video/videobuf-dma-contig.c will be better solution?

If you add something to the videobuf-dma-contig API, that's fine by me
because drivers/media/video/videobuf-dma-contig.c uses the own
structure and plays with dma_alloc_coherent. As long as a driver
doesn't touch device->dma_mem directly, it's fine, I think (that is,
dt3155v4l driver is broken). There are already some workarounds for
contigous memory in several drivers anyway.

We will have the proper API for contiguous memory. I don't think that
adding such workaround to the DMA API is a good idea.
