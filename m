Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0ESOpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:45:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:47490 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0ESOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:44:59 -0400
Date: Wed, 19 May 2010 23:38:34 +0900
To: npiggin@suse.de
Cc: jw@emlix.com, dwmw2@infradead.org, marc@tensilica.com,
       vapier.adi@gmail.com, dmitry.torokhov@gmail.com, cl@linux.com,
       penberg@cs.helsinki.fi, mpm@selenic.com, akpm@linux-foundation.org,
       os@emlix.com, Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com,
       rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100519135226.GZ2516@laptop>
References: <20100519133656.GY2516@laptop>
	<20100519134429.GH26131@emlix.com>
	<20100519135226.GZ2516@laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519234049C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 23:38:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 23:52:26 +1000
Nick Piggin <npiggin@suse.de> wrote:

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

IIRC, such was proposed several times:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12633.html

I guess that we agreed that it's better to tell driver writers to just
use kmalloc.
