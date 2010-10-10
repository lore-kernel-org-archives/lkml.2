Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0JJSxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 14:53:10 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:38950 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0JJSxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 14:53:08 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Sun, 10 Oct 2010 21:48:36 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc7; KDE/4.4.3; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201008201113.46036.mitov@issp.bas.bg> <201010101736.54199.mitov@issp.bas.bg> <Pine.LNX.4.64.1010102018270.10713@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010102018270.10713@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010102148.42097.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 10, 2010 09:21:50 pm Guennadi Liakhovetski wrote:
> On Sun, 10 Oct 2010, Marin Mitov wrote:
> 
> > On Sunday, October 10, 2010 05:08:22 pm FUJITA Tomonori wrote:
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
> > > Anyone is working on this?
> > 
> > I am not, sorry.
> > 
> > > 
> > > KAMEZAWA posted a patch to improve the generic page allocator to
> > > allocate physically contiguous memory. He said that he can push it
> > > into mainline.
> > 
> > I am waiting for the new videobuf2 framework to become part of the kernel.
> > Then KAMEZAWA's improvements can help.
> 
> You probably have seen this related thread: 
> http://marc.info/?t=128644473600004&r=1&w=2

Thanks.

Marin Mitov

> 
> Thanks
> Guennadi
> 
> > Marin Mitov
> > 
> > > 
> > > The approach enables us to solve this issue without adding any new
> > > API.
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
