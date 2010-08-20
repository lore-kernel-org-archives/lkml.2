Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0HTIPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:15:25 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:60424 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0HTIPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:15:04 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Fri, 20 Aug 2010 11:13:45 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc1; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <201008191818.36068.mitov@issp.bas.bg> <20100820161631A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100820161631A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201113.46036.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 20, 2010 10:17:48 am FUJITA Tomonori wrote:
> On Thu, 19 Aug 2010 18:18:35 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > struct device contains a member: struct dma_coherent_mem *dma_mem;
> > to hold information for a piece of memory declared dma-coherent.
> > Alternatively the same member could also be used to hold preallocated
> > dma-coherent memory for latter per-device use.
> 
> I think that drivers/base/dma-coherent.c is for architectures to
> implement dma_alloc_coherent(). So using it for drivers doesn't look
> correct.

It depends. Imagine your frame grabber has built-in RAM buffer on board
just as the frame buffer RAM on graphics cards, defined in BAR. You can use
dma_declare_coherent_memory()/dma_release_declared_memory() in
your driver and then use dma_alloc_coherent()/dma_free_coherent()
to allocate dma buffers from it and falling back transparently to system RAM
when this local resource is exhausted.

> 
> 
> > This tric is already used in drivers/staging/dt3155v4l.c
> > dt3155_alloc_coherent()/dt3155_free_coherent()
> > 
> > Here proposed for general use by popular demand from video4linux folks.
> > Helps for videobuf-dma-contig framework.
> 
> What you guys exactly want to do? If you just want to pre-allocate
> coherent memory for latter usage,

Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
We use coherent memory because it turns out to be contiguous.

> why dma_pool API (mm/dmapool.c) doesn't work?

I do not know why dma_pool API doesn't work for frame grabber buffers.
May be they are too big ~400KB. I have tried dma_pool APIs without success 
some time ago, so I had to find some other way to solve my problem leading to 
the proposed dma_reserve_coherent_memory()/dma_free_reserved_memory().

Thanks.

Marin Mitov


