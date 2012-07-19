Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2GSPpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2GSPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:45:48 -0400
Date: Thu, 19 Jul 2012 11:45:21 -0400
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
Message-ID: <20120719154521.GC8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719152618.GD16873@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:26:18AM -0400, Steven Rostedt wrote:
> On Fri, Jul 13, 2012 at 02:17:30PM -0700, Linus Torvalds wrote:
> > 
> > The *two* requirements (and they're really the same theme) I
> > personally think we should have for this are
> > 
> >  -  I think every single "select" for these things should come with a
> > comment about what it is about and why the distro needs it (to show
> > there was some thought involved and not just a blind "took it from the
> > distro config")
> 
> What about expanding on Alan's idea. I'm guessing that 99% of the users
> build the kernel for the box that they are running. If this is the case,
> perhaps we can get the distros to add a:
> 
>   /usr/share/Linux/Kconfig
> 
> And this Kconfig would have something like:
> 
> bool "Distro X config"
>  select A
>  select B
>  select C
>  [...]
> 
> Perhaps with a comment for each select. Or have the comments in the help
> section.
> 
> Then have the kernel kbuild system check if this file exists and include
> it.
> 
> Of course the kbuild system would need to verify that the selects exist,
> and perhaps warn if they do not. But the nice thing about this is that
> you would get the minconfig for the system you are running. When the
> system is updated to a new version, the minconfig would be updated too.
> The list of selects would not have to live in the kernel, nor would the
> kernel need to maintain the list for N+1 different distributions.

Is there a reason you don't want distro maintainers to maintain these
files in the upstream git tree?  (You said "the kernel need to
maintain", but I would expect the distro maintainers to be doing that
work.)

I think it would actually be beneficial to maintain them upstream
instead of in distro kernel packaging.  You'd be able to track the
history of changes with git.  You would see for a given kernel
version what options are set for each distro (e.g. F17 can support
NEW_FOO_THING but F16 userspace can't so it doesn't select that).
Perhaps most importantly, it provides a consolidated view of what
options various distros are setting and allows the distro maintainers to
easily do comparisons.

josh
