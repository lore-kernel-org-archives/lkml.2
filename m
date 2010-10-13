Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0JMQne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:43:34 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:54217 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0JMQnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:43:33 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Wed, 13 Oct 2010 19:42:56 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc7; KDE/4.4.3; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        g.liakhovetski@gmx.de
References: <201008201113.46036.mitov@issp.bas.bg> <20101010230323B.fujita.tomonori@lab.ntt.co.jp> <20101013170457.c5c5d2e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101013170457.c5c5d2e1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131942.57639.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 13, 2010 11:04:57 am KAMEZAWA Hiroyuki wrote:
> On Sun, 10 Oct 2010 23:08:22 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
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
> > Anyone is working on this?
> > 
> > KAMEZAWA posted a patch to improve the generic page allocator to
> > allocate physically contiguous memory. He said that he can push it
> > into mainline.
> > 
> I said I do make an effort ;)
> New one here.
> 
> http://lkml.org/lkml/2010/10/12/421

I like the patch. The possibility to allocate a contiguous chunk of memory
(or few of them) is what I need. The next step will be to get a dma handle 
(for dma transfers to/from) and then mmap them to user space.

Thanks.

Marin Mitov

> 
> Thanks,
> -Kame
> 
