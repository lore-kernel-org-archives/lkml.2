Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2GSVOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:14:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52283 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab2GSVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:14:12 -0400
Date: Thu, 19 Jul 2012 22:13:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Josh Boyer <jwboyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Message-ID: <20120719211357.GZ1894@decadent.org.uk>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
 <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com>
 <20120719171918.GD8469@zod.bos.redhat.com>
 <20120719183047.69de3e19@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719183047.69de3e19@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 06:30:47PM +0100, Alan Cox wrote:
> 
> > Well, yes.  I was thinking it would be more like:
> > 
> > distro/Kconfig.fedora
> > 	menuconfig FEDORA
> > 	if FEDORA
> > 	config FEDORA_16
> > 	   select WHATEVER
> > 	config FEDORA_17
> 
> Nope you need
> 
> distro/everyarchtheyship/everykernelvarianttkeyship(smp,largemem,arm
> boards)/Kconfig
> 
> which for some distros is over 20 per release and the end user wouldn't
> have a cat in hells chance of knowing which to pick.

20?  Debian's kernel package currently lists 17 architectures (11
source architectures) and 44 variants (excluding PREEMPT_RT and s390
install tape).  (But 'only' 31 will be in the next release, as even
Debian is capable of letting go of an architecture.)

But, assuming a native build (a whole weekend's worth of fun on m68k!)
we already know the target architecture and most of the other
variations can be chosen automatically similarly to localmodconfig.
We already do something like that (choosing between the pre-built
variants) at distribution install time, after all.

> For the end user case you need the distro to plonk the right file in the
> right place and be done with it, once they do that the rest is
> bikeshedding a ten line Makefile rule.
 
This might work well for future releases; is there not a need to
make this work for past releases too?

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
