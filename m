Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0HTIf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:35:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:56606 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0HTIfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:35:23 -0400
Date: Fri, 20 Aug 2010 17:35:06 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008201113.46036.mitov@issp.bas.bg>
References: <201008191818.36068.mitov@issp.bas.bg>
	<20100820161631A.fujita.tomonori@lab.ntt.co.jp>
	<201008201113.46036.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820173349E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 17:35:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 11:13:45 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> > > This tric is already used in drivers/staging/dt3155v4l.c
> > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > 
> > > Here proposed for general use by popular demand from video4linux folks.
> > > Helps for videobuf-dma-contig framework.
> > 
> > What you guys exactly want to do? If you just want to pre-allocate
> > coherent memory for latter usage,
> 
> Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> We use coherent memory because it turns out to be contiguous.

Hmm, you don't care about coherency? You just need contiguous memory?

Then, I prefer to invent the API to allocate contiguous
memory. Coherent memory is precious on some arches.


> > why dma_pool API (mm/dmapool.c) doesn't work?
> 
> I do not know why dma_pool API doesn't work for frame grabber buffers.
> May be they are too big ~400KB. I have tried dma_pool APIs without success 
> some time ago, so I had to find some other way to solve my problem leading to 
> the proposed dma_reserve_coherent_memory()/dma_free_reserved_memory().

I think that dma_pool API is for small coherent memory (smaller than
PAGE_SIZE) so it might not work for you. However, the purpose of
dma_pool API is exactly for what you want to do, creating a pool for
coherent memory per device for drivers.

I don't see any reason why we can't extend the dma_pool API for your
case. And it looks better to me rather than inventing the new API.
