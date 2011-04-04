Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1DDRwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:52:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:37116 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1DDRwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:52:13 -0400
Date: Tue, 5 Apr 2011 02:50:40 +0900
To: james@albanarts.com
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, cmetcalf@tilera.com,
        akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        james.hogan@imgtec.com, konrad.wilk@oracle.com, lethal@linux-sh.org,
        arnd@arndb.de, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
References: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110405023507G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 05 Apr 2011 02:50:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 16:21:47 +0100
James Hogan <james@albanarts.com> wrote:

> From: James Hogan <james.hogan@imgtec.com>
> 
> Note: I'm not in a position to compile test this patch, but I don't
> foresee any problems.
> 
> Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
> (d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
> struct dev pointer, but these appear to be missing from the tile and
> mn10300 implementations, so add them.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  arch/mn10300/include/asm/dma-mapping.h |    2 +-
>  arch/tile/include/asm/dma-mapping.h    |    3 ++-
>  arch/tile/kernel/pci-dma.c             |    2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)

Looks fine (I don't even compile it though).

btw, mn10300's dma_cache_sync looks wrong.

DMA-API says:

Do a partial sync of memory that was allocated by
dma_alloc_noncoherent(), starting at virtual address vaddr and
continuing on for size.  Again, you *must* observe the cache line
boundaries when doing this.

looks like mn10300's dma_alloc_noncoherent() returns consistent
memory. So dma_cache_sync should be a null function.
