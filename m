Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0FCWpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:45:42 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19750 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0FCWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:45:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 03 Jun 2010 18:45:39 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-reply-to: <20100603213337.GB6499@atomide.com>
Message-id: <alpine.LFD.2.00.1006031833360.24526@xanadu.home>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603164623.GM30622@atomide.com>
 <20100603181303.GB25779@flint.arm.linux.org.uk>
 <20100603213337.GB6499@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Tony Lindgren wrote:

> * Russell King <rmk@arm.linux.org.uk> [100603 21:07]:
> > On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
> > > Compiling in multiple ARM platforms is trickier, we would have to get
> > > rid of the duplicate defines like NR_IRQS, then have some common clock
> > > framework etc. Then figure out some way to get rid of Makefile.boot.
> > > Russell probably has some other things in mind that would have to be
> > > changed to make this happen.
> > 
> > - Find someway to handle the wide variety of interrupt controllers.

Eric Miao posted  a patch series for that already.

> > - Be able to handle any multitude of V:P translations, including non-linear
> >   alongside linear transations.

Some effort is being deployed at my $job to do that.  Initially only the 
linear translation will be supported, which should cover the vast 
majority of the cases already.  The odd targets will simply require a 
build of their own like it is done today.

> > - Different PAGE_OFFSETs

Again, a majority of targets may simply share the default one.

> > - Different kernel VM layouts allowing for a variety of different ioremap
> >   region sizes

VMALLOC_END should only need to become a per machine class variable 
initialized at run time.

> Some of these could be handled by allowing building a seprate instance
> for each platform compiled in. Maybe we could set them up with symlinks.

We already have runtime selectable machine instances.  Building multiple 
machine class could extend on that.

> How about a minimal generic relocatable ARM kernel and then we load the
> platform support as a module from ramdisk? :)

Pity...  Nah.

> > and so the list goes on...
> 
> Yeah..

Like I said, there is an effort to gradually overcome those issues one 
by one.


Nicolas
