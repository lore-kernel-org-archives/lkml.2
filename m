Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab0HDCzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:55:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60457 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758198Ab0HDCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:55:50 -0400
Date: Tue, 3 Aug 2010 19:55:39 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100804025539.GD4138@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802122421.GA12130@infradead.org>
 <20100802165936.GV3948@outflux.net>
 <15424.1280775073@localhost>
 <20100803165010.GG3948@outflux.net>
 <78690.1280871500@localhost>
 <20100803223451.GB4138@outflux.net>
 <7184.1280887675@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7184.1280887675@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:07:55PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 Aug 2010 15:34:51 PDT, Kees Cook said:
> > On Tue, Aug 03, 2010 at 05:38:20PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > The fact that a patch for one case has been used for years doesn't mean
> > > that it's a well thought out fix for the general case.
> > 
> > Well, we clearly disagree on this point. :)
> 
> Actually, we do, because you yourself have stated that:
> 
> a) It's a patch for one case.
> b) It's been around for 15 years.
> c) It doesn't even try to address the general case.
> 
> So Yama is a special case that after years still doesn't cover the genera case
> :)

Well, Yama is just an LSM. The symlink/hardlink thing has been around
forever and does sufficiently solve the general symlink race flaw. But,
whatever, we disagree about this.

> > This is the basis of our disagreement. Fixing it does do people a favor. At
> > the very least, it does me a favor because now I don't have to publish
> > security updates for an entire class of vulnerability.
> 
> Umm.. Tell you what.  I'll give you a chance to pretend you didn't
> send that from a vendor e-mail address... :)
> 
> Do you *really* want to go on record as saying "We didn't ship a fix for
> Frobozz 3.2 because The Kernel Would Stop The Obvious Exploit", when it's
> usually quite possible that somebody can come up with a different exploit
> scenario?  That's also going to go over *really* well with customers who end up
> turning off Yama because it breaks some third-party app that's doing some
> batshit crazy thing it shouldn't be doing in the first place.

Well, it drastically reduces the urgency of such a vulnerability. Besides,
if this makes a million systems safer and 1 less safe, that's still a
net win.

> > I think this is irrelevant; the symlink/hardlink combo fixes a
> > vulnerability with DAC. It's a break in the DAC security model.
> 
> Actually, if you trace it through, in almost every single case of an exploit
> abusing a symlink, at no time does the DAC model actually get violated. Every
> single access *is* in fact done according to the DAC in effect. The problem is
> that some of the accesses are not the ones the programmer intended the software
> to make.

I'm not convinced. I see what you're trying to say, but I just don't agree.
The symlink/hardlink thing is a tiny corner case of the operational
conditions under which DAC operates, and this is fixing a mistake in the
design that leads programmers into a (well known but seemingly unavoidable)
trap.

> that implement its decisions".  (Here is where you insert the clip from Indiana
> Jones and the Last Crusade: "He chose... poorly").

Yeah, my next trick will be helping people confine their web applications.
Hahaha ugh. That's an area of endless poor choices.

> > While waiting for smarter people than me make it impossible to exploit
> > security vulnerabilities in the future, I want to make it harder for
> > attackers to exploit security vulnerabilities now.
> 
> The sad part is that there are already known ways developed by smarter people.
> You just refuse to consider them as solutions and keep trying to deploy stuff
> that a sufficiently clever kid sister can bypass.

We'll agree to disagree. And at the same time I'll point out that if
SELinux is off (or app is running without policy), symlink races are just
as bad.

> > Heh, well, I have a PTRACE model. :) "Only CAP_SYSADMIN can PTRACE_ATTACH."
> 
> That's not actually a full model. ;)

alt.ptrace.die.die.die

> > Unfortunately, I'm stuck with these damned crash handlers which are really
> > just hacks to avoid writing a core to disk. Oddly, this is a solved problem
> > (via core dump patterns and distro-wide crash handlers) , but some
> > applications want to opt out of it instead of providing proper system hooks
> > to do crash analysis. Of course, with PTRACE still allowed, there's no
> > carrot (or stick) to encourage application writers to use distro-provided
> > crash handlers.
> 
> So do the obvious - ship with SELinux configured to not allow the arbitrary ptrace,
> document it, and tell them "it doesn't work, use the proper system interface instead".
> 
> :)

Perhaps later. For the moment, I'm happy with my racey anti-PTRACE
solution.

-Kees

-- 
Kees Cook
Ubuntu Security Team
