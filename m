Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1DDTvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:51:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59818 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1DDTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:51:23 -0400
Date: Mon, 4 Apr 2011 20:50:41 +0100
From: James Hogan <james@albanarts.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, cmetcalf@tilera.com,
        akpm@linux-foundation.org, james.hogan@imgtec.com,
        konrad.wilk@oracle.com, lethal@linux-sh.org, arnd@arndb.de,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
Message-ID: <20110404195041.GA11966@gandalf>
References: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
 <20110405023507G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405023507G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 02:50:40AM +0900, FUJITA Tomonori wrote:
> On Mon, 4 Apr 2011 16:21:47 +0100
> James Hogan <james@albanarts.com> wrote:
> 
> > From: James Hogan <james.hogan@imgtec.com>
> > 
> > Note: I'm not in a position to compile test this patch, but I don't
> > foresee any problems.
> > 
> > Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
> > (d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
> > struct dev pointer, but these appear to be missing from the tile and
> > mn10300 implementations, so add them.
> > 
> > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > ---
> >  arch/mn10300/include/asm/dma-mapping.h |    2 +-
> >  arch/tile/include/asm/dma-mapping.h    |    3 ++-
> >  arch/tile/kernel/pci-dma.c             |    2 +-
> >  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> Looks fine (I don't even compile it though).
> 
> btw, mn10300's dma_cache_sync looks wrong.
> 
> DMA-API says:
> 
> Do a partial sync of memory that was allocated by
> dma_alloc_noncoherent(), starting at virtual address vaddr and
> continuing on for size.  Again, you *must* observe the cache line
> boundaries when doing this.
> 
> looks like mn10300's dma_alloc_noncoherent() returns consistent
> memory. So dma_cache_sync should be a null function.

I noticed it explicitly says:
442 Note: where the platform can return consistent memory, it will
443 guarantee that the sync points become nops.

I presume dma_cache_sync() is the "sync points" it is referring to.

By the looks of it though the following architectures implement it but
define the noncoherent functions to the coherent versions so shouldn't
implement it (as far as I can tell):
 avr,blackfin,frv,microblaze,powerpc,sh,unicore32,x86,xtensia

and ia64 says it isn't required so just does a full memory barrier
instead (mb()).

Cheers
James
