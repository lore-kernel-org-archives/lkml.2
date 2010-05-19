Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0ESPBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:01:14 -0400
Received: from mx1.emlix.com ([193.175.82.87]:50148 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0ESPBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:01:11 -0400
Date: Wed, 19 May 2010 17:00:03 +0200
From: Johannes Weiner <jw@emlix.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Marc Gauthier <marc@tensilica.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Chris Zankel <chris@zankel.net>,
       Piet Delaney <Piet.Delaney@tensilica.com>
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Message-ID: <20100519150003.GK26131@emlix.com>
References: <20100511215359.GF7396@core.coreip.homeip.net>
 <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
 <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
 <20100512030350.GJ15903@laptop>
 <1274273325.6930.10022.camel@macbook.infradead.org>
 <20100519130710.GX2516@laptop>
 <1274275067.6930.10073.camel@macbook.infradead.org>
 <20100519133656.GY2516@laptop>
 <20100519134429.GH26131@emlix.com>
 <20100519135226.GZ2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519135226.GZ2516@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:52:26PM +1000, Nick Piggin wrote:
> On Wed, May 19, 2010 at 03:44:30PM +0200, Johannes Weiner wrote:
> > On Wed, May 19, 2010 at 11:36:56PM +1000, Nick Piggin wrote:
> > > On Wed, May 19, 2010 at 02:17:47PM +0100, David Woodhouse wrote:
> > > >
> > > > The 'cacheline aligned' misconception did manage to get into the ad7877
> > > > driver in commit 3843384a though -- it now uses ____cacheline_aligned
> > > > instead of __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN))) as it
> > > > should.
> > > 
> > > OK so long as there is not a "must be cacheline aligned" requirement.
> > > Your proposal for a __dma_aligned attribute in an arch header looks
> > > like a good idea there.
> > 
> > Would you happen to know of other potential users?  At this point I'd
> > much rather just allocate the buffers dynamically and hide the issue
> > nicely behind kmalloc().
> 
> I don't think we need to hide the fact that some platforms have
> specific alignment restrictions for DMA. So if any drivers make use
> of the alignment, I see no problem with __dma_aligned.

In this case, the slave driver does not know whether the master driver
is even using DMA.  That's the reason we do not use dma_alloc_* for
the buffers in the first place.  And that's why I'd prefer to leave
the slave agnostic about it.  Use kmalloc(), don't worry about the
details.

Of course, there may still be more appropriate users for the macro,
that's why I asked.
