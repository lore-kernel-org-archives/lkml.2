Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0ESOLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:11:53 -0400
Received: from waste.org ([173.11.57.241]:50954 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0ESOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:11:51 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       ken@codelabs.ch, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <AANLkTikZyfxBjXdvNzuVT2N9XIyJmY6JDiKRMRtAykeC@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274253269.6930.9325.camel@macbook.infradead.org>
	 <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	 <1274269236.6930.9930.camel@macbook.infradead.org>
	 <AANLkTikZyfxBjXdvNzuVT2N9XIyJmY6JDiKRMRtAykeC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 09:11:47 -0500
Message-ID: <1274278307.11603.1264.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 13:50 +0200, Geert Uytterhoeven wrote:
> On Wed, May 19, 2010 at 13:40, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> >> Instead of having (different) defaults in sl[aou]b, perhaps we should
> >> just remove the defaults completely, to ensure all architectures set
> >> ARCH_SLAB_MINALIGN to the correct value?
> >
> > What is 'correct'? The architecture sets it to the minimum value that it
> > can cope with, according to its own alignment constraints (and DMA/cache
> > constraints, in the case of ARCH_KMALLOC_MINALIGN).
> >
> > Some architectures don't _have_ any minimum required alignment, so they
> > have no need to set it. If the architecture _does_ specify a minimum,
> > the allocators must honour it. Otherwise, they're free to do their own
> > thing. And slob chooses to use a smaller alignment than slab and slub
> > do, in accordance with its design and its raison d'être.
> 
> Currently 7 out of 20+ architectures set it.
> Any bets on how many are missing, but should set it?

I still think we should add it to all of them as positive documentation
that this issue has been considered. And then make the kernel not
compile without it so new arch implementors can't miss it.

-- 
Mathematics is the supreme nostalgia of our time.


