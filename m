Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0ESPYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:24:24 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:34078 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0ESPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:24:23 -0400
Date: Wed, 19 May 2010 10:19:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Paul Mundt <lethal@linux-sh.org>
cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, herbert@gondor.hengli.com.au, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [BUG] SLOB breaks Crypto
In-Reply-To: <20100518223739.GC5933@linux-sh.org>
Message-ID: <alpine.DEB.2.00.1005191017290.4592@router.home>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <20100518223507.GB5933@linux-sh.org>
 <20100518223739.GC5933@linux-sh.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Paul Mundt wrote:

> > > So one of two things should happen:
> > >
> > > 1) SLOB conforms to SLAB/SLUB in it's test
> > >
> > > 2) SLAB/SLUB conforms to SLOB in it's test
> > >
> > > And yes this is an either-or, you can't say they are both valid.
> >
> > I don't see any reason to punish SLOB for the assumptions that SLAB/SLUB
> > arbitrarily took up, presumably on an architecture that should have
> > specified its own alignment requirements and simply couldn't be bothered.
> > Making SLAB redzoning work with arbitrary alignment is another matter
> > entirely, and something that should probably be revisited.
> >
> > Anything that assumes more than BYTES_PER_WORD is simply broken and
> > should be reverted.

The assumptions are not arbitrary. It is reasonable to assume that
structures managed by the slab allocators may contain long long variables
and that therefore a unsigned long long alignment is required by the
allocator. It is the *compiler* who tells us that long long needs to be
aligned at double word boundaries. If an arch does not require long long
alignment on double word boundaries then the *compiler* should tell us
that and then the allocators will align on word boundaries.



