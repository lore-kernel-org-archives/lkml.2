Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2GSRi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2GSRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:38:27 -0400
Date: Thu, 19 Jul 2012 13:38:00 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120719173800.GE8469@zod.bos.redhat.com>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
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

I wasn't include arch-specific options in the "minimal distro config"
stuff.  That doesn't seem minimal to me.  I was thinking more along the
lines of "distro X needs CGROUPS, SELINUX, HOTPLUG, DEVTMPFS, namespace
stuff".  Stuff that they need that is basically architecture
independent that the distro userspace needs.

Having the distro provide files that select architecture specific
options and variations of that really doesn't seem any better than what
most of them do already, which is just ship the whole damn config file
in /boot (or some other location).

> For the end user case you need the distro to plonk the right file in the
> right place and be done with it, once they do that the rest is
> bikeshedding a ten line Makefile rule.

If people want the distros to plonk some architecture+distro specific
minimal config file down as part of the packaging, I guess that's a
thing that could be done.  I'd honestly wonder if maintaining X number
of those in the packaging is something the distro maintainers would
really like to do, but one can always hope.

josh
