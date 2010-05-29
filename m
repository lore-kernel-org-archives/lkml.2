Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0E2LT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:19:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45150 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab0E2LTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:19:55 -0400
X-Greylist: delayed 145978 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 May 2010 07:19:54 EDT
Date: Sat, 29 May 2010 13:19:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100529111951.GB31550@merkur.ravnborg.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100527154916.GA5585@infradead.org> <20100527184653.GA11830@merkur.ravnborg.org> <AANLkTikkZGdf8-WnHQu4dY6WiXH7d0Raak0j-82hrvAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikkZGdf8-WnHQu4dY6WiXH7d0Raak0j-82hrvAA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 03:37:00AM +0530, Jaswinder Singh Rajput wrote:
> Hello Sam,
> 
> On Fri, May 28, 2010 at 12:16 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Thu, May 27, 2010 at 11:49:16AM -0400, Christoph Hellwig wrote:
> >> On Thu, May 27, 2010 at 05:37:36AM +0530, Jaswinder Singh Rajput wrote:
> >> > Hello,
> >> >
> >> > I am trying to build 32 bit kernel image on 64-bit machine but after
> >> > 'make menuconfig' it automatically switches 32-bit to 64-bit.
> >> >
> >> > Is this a BUG or did intentionally.
> >>
> >> I think it's intentional, but I'm really annoyed by this behaviour.
> >
> > The request when we did the merge of 32 and 64 bit was that we
> > should continue to build 64bit kernels on 64 bit machines.
> > And likewise for 32bit.
> > Because this was what the users where used to.
> >
> > We could simplify metters by defining new rules.
> > As you suggest that uname on an intel box always resulted in ARCH=x86.
> > But then people would complain why a 32 bit kernel is default when
> > the box is 64 bit.
> >
> > Something like this:
> > [The escape chars align nicely in the patched Makefile]
> >
> >        Sam
> >
> > diff --git a/Makefile b/Makefile
> > index ebc8225..e7f97a5 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -161,10 +161,11 @@ export srctree objtree VPATH
> >  # then ARCH is assigned, getting whatever value it gets normally, and
> >  # SUBARCH is subsequently ignored.
> >
> > -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> > -                                 -e s/arm.*/arm/ -e s/sa110/arm/ \
> > +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/        \
> > +                                 -e s/sun4u/sparc64/                    \
> > +                                 -e s/arm.*/arm/ -e s/sa110/arm/        \
> >                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
> > -                                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> > +                                 -e s/ppc.*/powerpc/ -e s/mips.*/mips/  \
> >                                  -e s/sh[234].*/sh/ )
> >
> >  # Cross compiling and selecting different set of gcc/bin-utils
> >
> >
> 
> Thanks, this patch fixes the issue. Now 'make menuconfig' is following .config.

If you think this is the right way to do things you can take it up
with the x86 maintainers.

Although the patch touches only a generic file this is x86 specific.

	Sam
