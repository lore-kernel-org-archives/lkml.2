Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2GSR5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2GSR5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:57:07 -0400
Date: Thu, 19 Jul 2012 13:56:50 -0400
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
Message-ID: <20120719175649.GF8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
 <20120719152618.GD16873@home.goodmis.org>
 <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com>
 <20120719171918.GD8469@zod.bos.redhat.com>
 <1342719222.12353.58.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342719222.12353.58.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 01:33:42PM -0400, Steven Rostedt wrote:
> On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:
> 
> > > What about older kernels? Say you installed Fedora 18 with an older
> > > kernel that doesn't know what to select? Having the distro tell the
> > > kernel what it needs seems to me the easiest for the 99% case.
> > 
> > How is the above not telling the kernel what it needs?  I'm confused how
> > the location of such a file makes it's functionality and usefulness
> > differ...  Quite possible I missed what you meant originally, but it
> > sounds like we're talking about the same thing?
> 
> The point is, the user wont have to think "What distro am I running? and
> what version am I running?". I don't even know what version of the disto
> I'm currently running (Debian testing).
>
> The point is, the current running distro supplies what is needed from
> the kernel in order to work properly. The user does not need to 'select'
> it. They would only have to select a 'add my distro min configs'.

Distros aren't stationary things.  I mean, some of them certainly aim
for that goal, but userspace and kernels get upgraded all the time.  So
if this distro-Kconfig file is provided by some package _other_ than the
kernel the distros are going to have a bit of a hassle keeping track of
it.

> A developer working with a user could just say, "select disto config"
> without needing to know what distro the user has.
> 
> What happens if someone does a yum update, and the kernel requirement
> changes slightly. The yum update should update
> this /usr/share/Linux/Kconfig. But it's still set at Fedora X. The
> kernel can not be updated for these slight changes.

I'm not quite following what you mean in the yum update case, sorry.

> > Also, I'm not very convinced the 99% are going to be wanting to install
> > shiny new versions of a distro with a kernel older than what the distro
> > ships with.  I could be very wrong, but it seems like in-general the
> > whole premise of this RFC was geared towards using new kernels on
> > distros.
> 
> There are times when the update breaks something. A user may backport to
> an older kernel where their Gizmo worked. I've done this to get webcams
> working. I know I'm not the 99%, but the rational for my operation was a
> 99% thing to do: Crap, I upgraded my kernel and now my webcam doesn't
> work. Oh well, download an older version and boot that one.

Upgraded the kernel within the confines of that distro, right?  So you
go back to what was already installed and working.  You don't go back
arbitrarily far just to see what happens.  I would think a reasonably
crafted distro config would work in those scenarios.

josh
