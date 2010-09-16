Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0IPWtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:49:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:60909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab0IPWta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:49:30 -0400
Date: Thu, 16 Sep 2010 15:47:21 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, shijie8@gmail.com, tj@kernel.org,
        stable@kernel.org
Subject: Re: Patch "percpu: fix a memory leak in pcpu_extend_area_map()"
 has been added to the 2.6.35-stable tree
Message-ID: <20100916224721.GA14256@suse.de>
References: <12845915543097@site>
 <201009162339.05158.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009162339.05158.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:39:02PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 16 September 2010, gregkh@suse.de wrote:
> > This is a note to let you know that I've just added the patch titled
> >     percpu: fix a memory leak in pcpu_extend_area_map()
> > to the 2.6.35-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> [...]
> > From a002d148426f40bc2b7dc066982eb177cdebeaaa Mon Sep 17 00:00:00 2001
> > From: Huang Shijie <shijie8@gmail.com>
> > Date: Sun, 8 Aug 2010 14:39:07 +0200
> > Subject: percpu: fix a memory leak in pcpu_extend_area_map()
> > 
> > From: Huang Shijie <shijie8@gmail.com>
> > 
> > commit a002d148426f40bc2b7dc066982eb177cdebeaaa upstream.
> > 
> > The original code did not free the old map.  This patch fixes it.
> > 
> > tj: use @old as memcpy source instead of @chunk->map, and indentation
> >     and description update
> 
> This patch, as part of the current -stable queue-2.6.35, breaks booting for
> me on nforce4/ AMD64 X2. Unfortunately it fails even before the serial 
> console is initialized and the only messages shown on screen are:
> 
> Decompressing Linux... Parsing ELF... done.
> Booting kernel.
> 
> [...]
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -390,7 +390,9 @@ static int pcpu_extend_area_map(struct p
> >  		goto out_unlock;
> >  
> >  	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
> > -	memcpy(new, chunk->map, old_size);
> > +	old = chunk->map;
> > +
> > +	memcpy(new, old, old_size);
> >  
> >  	/*
> >  	 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
> 
> Reverting just this patch from the current queue-2.6.35 fixes the issue for
> me; gzipped kernel config (amd64) attached.

Does Linus's tree also cause the same problems for you?

thanks,

greg k-h
