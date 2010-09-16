Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0IPXhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:37:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40930 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752542Ab0IPXhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:37:33 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+IBidvlteIHsI8iTwlFJcmNXNoO+cxYVpMatvcdm
	kAtcsuvttTrVBO
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: Patch "percpu: fix a memory leak in pcpu_extend_area_map()" has been added to the 2.6.35-stable tree
Date: Fri, 17 Sep 2010 01:37:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-4.slh.12-aptosid-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, shijie8@gmail.com, tj@kernel.org,
        stable@kernel.org
References: <12845915543097@site> <201009162339.05158.s.L-H@gmx.de> <20100916224721.GA14256@suse.de>
In-Reply-To: <20100916224721.GA14256@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009170137.29317.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 17 September 2010, Greg KH wrote:
> On Thu, Sep 16, 2010 at 11:39:02PM +0200, Stefan Lippers-Hollmann wrote:
[...]
> > On Thursday 16 September 2010, gregkh@suse.de wrote:
> > > This is a note to let you know that I've just added the patch titled
> > >     percpu: fix a memory leak in pcpu_extend_area_map()
> > > to the 2.6.35-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > [...]
> > > From a002d148426f40bc2b7dc066982eb177cdebeaaa Mon Sep 17 00:00:00 2001
> > > From: Huang Shijie <shijie8@gmail.com>
> > > Date: Sun, 8 Aug 2010 14:39:07 +0200
> > > Subject: percpu: fix a memory leak in pcpu_extend_area_map()
> > > 
> > > From: Huang Shijie <shijie8@gmail.com>
> > > 
> > > commit a002d148426f40bc2b7dc066982eb177cdebeaaa upstream.
> > > 
> > > The original code did not free the old map.  This patch fixes it.
> > > 
> > > tj: use @old as memcpy source instead of @chunk->map, and indentation
> > >     and description update
> > 
> > This patch, as part of the current -stable queue-2.6.35, breaks booting for
> > me on nforce4/ AMD64 X2. Unfortunately it fails even before the serial 
> > console is initialized and the only messages shown on screen are:
> > 
> > Decompressing Linux... Parsing ELF... done.
> > Booting kernel.
[...]
> > > --- a/mm/percpu.c
> > > +++ b/mm/percpu.c
> > > @@ -390,7 +390,9 @@ static int pcpu_extend_area_map(struct p
> > >  		goto out_unlock;
> > >  
> > >  	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
> > > -	memcpy(new, chunk->map, old_size);
> > > +	old = chunk->map;
> > > +
> > > +	memcpy(new, old, old_size);
> > >  
> > >  	/*
> > >  	 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
> > 
> > Reverting just this patch from the current queue-2.6.35 fixes the issue for
> > me; gzipped kernel config (amd64) attached.
> 
> Does Linus's tree also cause the same problems for you?

Current linux-2.6 HEAD (v2.6.36-rc4-134-g03a7ab0) boots and works fine with
a config very closely derived from the previous one.

Regards
	Stefan Lippers-Hollmann
