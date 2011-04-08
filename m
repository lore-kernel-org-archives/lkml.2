Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1DHEKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:10:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:37247 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1DHEK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:10:29 -0400
Date: Fri, 8 Apr 2011 13:09:29 +0900
To: james@albanarts.com
Cc: fujita.tomonori@lab.ntt.co.jp, dhowells@redhat.com,
        yasutake.koichi@jp.panasonic.com, cmetcalf@tilera.com,
        akpm@linux-foundation.org, james.hogan@imgtec.com,
        konrad.wilk@oracle.com, lethal@linux-sh.org, arnd@arndb.de,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110404195041.GA11966@gandalf>
References: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
	<20110405023507G.fujita.tomonori@lab.ntt.co.jp>
	<20110404195041.GA11966@gandalf>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110408130816Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 08 Apr 2011 13:09:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 20:50:41 +0100
James Hogan <james@albanarts.com> wrote:

> On Tue, Apr 05, 2011 at 02:50:40AM +0900, FUJITA Tomonori wrote:
> > On Mon, 4 Apr 2011 16:21:47 +0100
> > James Hogan <james@albanarts.com> wrote:
> > 
> > > From: James Hogan <james.hogan@imgtec.com>
> > > 
> > > Note: I'm not in a position to compile test this patch, but I don't
> > > foresee any problems.
> > > 
> > > Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
> > > (d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
> > > struct dev pointer, but these appear to be missing from the tile and
> > > mn10300 implementations, so add them.
> > > 
> > > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > > ---
> > >  arch/mn10300/include/asm/dma-mapping.h |    2 +-
> > >  arch/tile/include/asm/dma-mapping.h    |    3 ++-
> > >  arch/tile/kernel/pci-dma.c             |    2 +-
> > >  3 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > Looks fine (I don't even compile it though).
> > 
> > btw, mn10300's dma_cache_sync looks wrong.
> > 
> > DMA-API says:
> > 
> > Do a partial sync of memory that was allocated by
> > dma_alloc_noncoherent(), starting at virtual address vaddr and
> > continuing on for size.  Again, you *must* observe the cache line
> > boundaries when doing this.
> > 
> > looks like mn10300's dma_alloc_noncoherent() returns consistent
> > memory. So dma_cache_sync should be a null function.
> 
> I noticed it explicitly says:
> 442 Note: where the platform can return consistent memory, it will
> 443 guarantee that the sync points become nops.
> 
> I presume dma_cache_sync() is the "sync points" it is referring to.

I think that it's the "sync points" for architectures that return
either consistent or non-consistent memory.


> By the looks of it though the following architectures implement it but
> define the noncoherent functions to the coherent versions so shouldn't
> implement it (as far as I can tell):
>  avr,blackfin,frv,microblaze,powerpc,sh,unicore32,x86,xtensia

Yeah, I knew when I clean up the DMA API. But few uses
dma_cache_sync() so I left them alone.


> and ia64 says it isn't required so just does a full memory barrier
> instead (mb()).

I think that drivers need to care about such.
