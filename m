Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0ESQiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:38:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0ESQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mHXLKmZTGXDsqc19DWedIbZnoAmuzKiYwUsfDJbvrqxlONdxvDpFh/TStDoEXT2FbB
         nJR1darl2SWcbrpjOiiwUOlwmvO/tYEm4SQwBLeiJF4nbP5xilJkWu8U6/pdxrEAeKMX
         k27EmJ7Tf7BK3cex3UKNH67rF95LUcYi4URZ4=
Date: Wed, 19 May 2010 09:37:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: npiggin@suse.de, jw@emlix.com, dwmw2@infradead.org, marc@tensilica.com,
       vapier.adi@gmail.com, cl@linux.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, akpm@linux-foundation.org, os@emlix.com,
       Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com,
       rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Message-ID: <20100519163745.GA27475@core.coreip.homeip.net>
References: <20100519133656.GY2516@laptop>
 <20100519134429.GH26131@emlix.com>
 <20100519135226.GZ2516@laptop>
 <20100519234049C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519234049C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:38:34PM +0900, FUJITA Tomonori wrote:
> On Wed, 19 May 2010 23:52:26 +1000
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Wed, May 19, 2010 at 03:44:30PM +0200, Johannes Weiner wrote:
> > > On Wed, May 19, 2010 at 11:36:56PM +1000, Nick Piggin wrote:
> > > > On Wed, May 19, 2010 at 02:17:47PM +0100, David Woodhouse wrote:
> > > > >
> > > > > The 'cacheline aligned' misconception did manage to get into the ad7877
> > > > > driver in commit 3843384a though -- it now uses ____cacheline_aligned
> > > > > instead of __attribute__((__aligned__(ARCH_KMALLOC_MINALIGN))) as it
> > > > > should.
> > > > 
> > > > OK so long as there is not a "must be cacheline aligned" requirement.
> > > > Your proposal for a __dma_aligned attribute in an arch header looks
> > > > like a good idea there.
> > > 
> > > Would you happen to know of other potential users?  At this point I'd
> > > much rather just allocate the buffers dynamically and hide the issue
> > > nicely behind kmalloc().
> > 
> > I don't think we need to hide the fact that some platforms have
> > specific alignment restrictions for DMA. So if any drivers make use
> > of the alignment, I see no problem with __dma_aligned.
> 
> IIRC, such was proposed several times:
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12633.html
> 
> I guess that we agreed that it's better to tell driver writers to just
> use kmalloc.

It really dpeends on the size of the buffer. When I need a single byte I
really do not want to mess with separate kmalloced buffer.

If somebody coudl pick David's patch that would be great.

-- 
Dmitry
