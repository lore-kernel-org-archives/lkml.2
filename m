Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0EXHoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:44:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:38667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0EXHoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:44:05 -0400
Date: Mon, 24 May 2010 17:43:36 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ipc: increase IPCMNI_MAX
Message-ID: <20100524074335.GX2516@laptop>
References: <20100520065911.GG2516@laptop>
 <20100520070741.GI2516@laptop>
 <20100521133136.d0e282df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521133136.d0e282df.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 01:31:36PM -0700, Andrew Morton wrote:
> On Thu, 20 May 2010 17:07:41 +1000
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > Just wondering whether there is a good reason to have a full 16 bits of
> > sequence in ipc ids? 32K indexes is pretty easy to overflow, if only in
> > stress tests for now. I was doing some big aim7 stress testing, which
> > required this patch, but it's not exactly a realistic workload :) 
> > 
> > But the sequence seems like it just helps slightly with buggy apps, and
> > if the app is buggy then it can by definition mess up its own ids
> > anyway? So I don't see that such amount of seq is required.
> > 
> > Index: linux-2.6/ipc/util.h
> > ===================================================================
> > --- linux-2.6.orig/ipc/util.h
> > +++ linux-2.6/ipc/util.h
> > @@ -14,7 +14,16 @@
> >  #include <linux/err.h>
> >  
> >  /* IPCMNI_MAX should be <= MAX_INT, absolute limit for ipc arrays */
> > -#define IPCMNI_MAX_SHIFT	15
> > +/*
> > + * IPC ids consist of an index into the idr, which allocates from the bottom
> > + * up, and a sequence number which is continually incremented. Valid indexes
> > + * are from 0..IPCMNI_MAX (or further constrained by sysctls or other limits).
> > + * The sequence number prevents ids from being reused quickly. The sequence
> > + * number resides in the top part of the 'int' after IPCMNI_MAX.
> > + *
> > + * Increasing IPCMNI_MAX reduces the sequence wrap interval.
> > + */
> > +#define IPCMNI_MAX_SHIFT	20
> >  #define IPCMNI_MAX		(1 << IPCMNI_MAX_SHIFT)
> >  
> >  #define SEQ_SHIFT		IPCMNI_MAX_SHIFT
> 
> Some anaylsis of the worst-case memory consumption would be mollifying.

OK.
 
> I took the absence of Signed-off-by:'s to mean "rfc" and wandered away.

Yes. They should probably go through Manfred to you anyway.

