Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2GSShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2GSShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:37:04 -0400
Date: Thu, 19 Jul 2012 14:36:46 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120719183645.GH8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
 <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com>
 <20120719171918.GD8469@zod.bos.redhat.com>
 <1342719222.12353.58.camel@gandalf.stny.rr.com>
 <20120719175649.GF8469@zod.bos.redhat.com>
 <1342721620.12353.75.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342721620.12353.75.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 02:13:40PM -0400, Steven Rostedt wrote:
> On Thu, 2012-07-19 at 13:56 -0400, Josh Boyer wrote:
> 
> > Distros aren't stationary things.
> 
> Exactly my point.
> 
> >   I mean, some of them certainly aim
> > for that goal, but userspace and kernels get upgraded all the time.  So
> > if this distro-Kconfig file is provided by some package _other_ than the
> > kernel the distros are going to have a bit of a hassle keeping track of
> > it.
> 
> How about a directory called /usr/share/Linux/Kconfig.d/
> 
> Then have anything installed that needs to work correctly put in its
> minimum (must have) requirement configs of the kernel.
> 
> Say you are running Debian, and decide to try out systemd. If you set up
> your system to run that it would add a file called:
> 
> /usr/share/Linux/Kconfig.d/systemd.conf
> 
> or something, and this would select things like CGROUPS and the like. We
> could make the kernel build select all, or individual files in this
> directory. All for the 'make my distro work' or individual for a 'I want
> part of my distro to work' option.

That sounds like a pretty good idea, aside from the fact that now your
config is determined by 1) what is currently installed on your system
and 2) people that don't maintain the kernel.

1 is obviously a great thing once you have a stable working set of
packages you use daily, but wouldn't it kind of suck to have to rebuild
the kernel just to install some new package?  I mean... say you wanted
to now use an NFS mount, but you didn't have nfs-utils previously
installed.  So you install it, and it plops the kconfig file in
/usr/share but oops, you have to rebuild the kernel and reboot because
that module isn't built.  Of course I'm extrapolating possibly the worst
usage case here, but it will still happen.

2... yeah.  I don't really know if that is going to pan out, but I am
ever hopeful.  I'd be mostly concerned with people that are coding
userspace applications using every whiz-bang kernel feature.  Or not
paying attention at all to the kernel after the initial file creation
and the options going stale (don't follow renames, etc).


> > Upgraded the kernel within the confines of that distro, right?  So you
> > go back to what was already installed and working.  You don't go back
> > arbitrarily far just to see what happens.  I would think a reasonably
> > crafted distro config would work in those scenarios.
> 
> A reasonable one, but still not the minimum.

The definition of minimum seems to be what we're disagreeing on.  I'm
approaching it from "minimum for a default install of the distro
release".  OK, that and maybe a few common case usages (like NFS, CIFS,
etc).  You seem to be approaching it from literally bare minimum.

> One issue with Linus's proposal is that he's asking us to focus on the
> 99%. But the 99% of who? Because 99% of Linux users do not compile their
> own kernels, so he must be asking about the 99% of Linux users that
> compile their own kernels. This 99% does not just simply compile their
> kernels, but only want to compile the absolutely necessary stuff. That
> is, they want their kernels not to include anything they are not using.
> 
> A reasonable config would probably need to include a lot that's not
> used.

Perhaps.  I thought getting it reasonable would benefit more people,
even at the cost of some smaller bloat than bare minimum.  I don't think
either of us are really wrong, it's more a matter of who is really going
to use this and why I guess.

josh
