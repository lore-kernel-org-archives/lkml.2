Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2GSRTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2GSRTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:19:38 -0400
Date: Thu, 19 Jul 2012 13:19:18 -0400
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
Message-ID: <20120719171918.GD8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
 <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342714088.12353.33.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 12:08:08PM -0400, Steven Rostedt wrote:
> On Thu, 2012-07-19 at 11:45 -0400, Josh Boyer wrote:
> > Of course the kbuild system would need to verify that the selects exist,
> > > and perhaps warn if they do not. But the nice thing about this is that
> > > you would get the minconfig for the system you are running. When the
> > > system is updated to a new version, the minconfig would be updated too.
> > > The list of selects would not have to live in the kernel, nor would the
> > > kernel need to maintain the list for N+1 different distributions.
> > 
> > Is there a reason you don't want distro maintainers to maintain these
> > files in the upstream git tree?  (You said "the kernel need to
> > maintain", but I would expect the distro maintainers to be doing that
> > work.)
> > 
> > I think it would actually be beneficial to maintain them upstream
> > instead of in distro kernel packaging.  You'd be able to track the
> > history of changes with git.  You would see for a given kernel
> > version what options are set for each distro (e.g. F17 can support
> > NEW_FOO_THING but F16 userspace can't so it doesn't select that).
> > Perhaps most importantly, it provides a consolidated view of what
> > options various distros are setting and allows the distro maintainers to
> > easily do comparisons.
> 
> Then we'll have a list of options in each kernel:
> 
>  Fedora 16
>  Fedora 17
>  Fedora 18
>  [...]
>  Debian x
>  Debian x+1
>  Debian x+2
>  [...]
>  Ubuntu y
>  Ubuntu y+1
>  [...]

Well, yes.  I was thinking it would be more like:

distro/Kconfig.fedora
	menuconfig FEDORA
	if FEDORA
	config FEDORA_16
	   select WHATEVER
	config FEDORA_17
	...

distro/Kconfig.debian
	menuconfig DEBIAN
	if DEBIAN
	config DEBIAN_X
	...

etc.

Not one giant distro file with a bunch of varying distros doing a bunch
of selects.  But in general, yes there would be options for each
supported distro release.

> What about older kernels? Say you installed Fedora 18 with an older
> kernel that doesn't know what to select? Having the distro tell the
> kernel what it needs seems to me the easiest for the 99% case.

How is the above not telling the kernel what it needs?  I'm confused how
the location of such a file makes it's functionality and usefulness
differ...  Quite possible I missed what you meant originally, but it
sounds like we're talking about the same thing?

Also, I'm not very convinced the 99% are going to be wanting to install
shiny new versions of a distro with a kernel older than what the distro
ships with.  I could be very wrong, but it seems like in-general the
whole premise of this RFC was geared towards using new kernels on
distros.

> Also, if something isn't supported by the older kernel, it would warn
> the user about it. That way the user can be told that their older kernel
> won't work with this version of the distro. And there wont be as many
> surprises. If the user is told "your init wont work with this kernel"
> before they compile it, then they shouldn't complain if they decide to
> install this older kernel and their box doesn't boot.

kconfig already spits out warnings for symbols being selected that
don't exist.

josh
