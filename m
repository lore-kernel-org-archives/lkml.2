Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1D1Ved (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:34:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1D1Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:34:32 -0400
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
From: James Bottomley <James.Bottomley@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
	 <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 16:34:24 -0500
Message-ID: <1304026464.2598.36.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 14:25 -0700, David Rientjes wrote:
> On Thu, 28 Apr 2011, Geert Uytterhoeven wrote:
> 
> > 	Hi Linus,
> > 
> > This is the SLUB fix for m68k, which also applies to stable.
> > 
> > The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:
> >   Linus Torvalds (1):
> >         Linux 2.6.39-rc5
> > 
> > are available in the git repository at:
> > 
> >   master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-2.6.39
> > 
> > Michael Schmitz (1):
> >       m68k/mm: Set all online nodes in N_NORMAL_MEMORY
> > 
> >  arch/m68k/mm/motorola.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> 
> Thanks for pushing this, Geert.
> 
> Since 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) from 
> 2.6.39-rc4, you can't actually select slub on m68k without CONFIG_ADVANCED 
> and CONFIG_SINGLE_MEMORY_CHUNK because it otherwises defaults to 
> discontigmem.
> 
> James tested hppa64 with my N_NORMAL_MEMORY fix and found that it turned 
> an SMP box into UP.  If you've tested slub on m68k without regressions, 
> then perhaps you'd like to add a "|| M68K" to CONFIG_SLUB?

To be honest, I really don't see that fixing it.  As soon as you
allocate memory beyond range zero, you move onto a non-zero node as far
as slub is concerned, and that will oops.

I think what the N_NORMAL_MEMORY patch did is just make it take a whiile
before you start allocating from that range.  Try executing a memory
balloon on the platform; that was how we first demonstrated the problem
on parisc.

James


