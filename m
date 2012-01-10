Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2AJW1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:27:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37438 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab2AJW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:27:14 -0500
Date: Tue, 10 Jan 2012 22:27:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: Regulator updates for 3.3
Message-ID: <20120110222711.GK7164@opensource.wolfsonmicro.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com> <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com> <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:18:44AM -0800, Linus Torvalds wrote:
> On Tue, Jan 10, 2012 at 10:45 AM, Mark Brown

> > Hrm, OK.  These merges are all merges up of bug fixes for -rc from my
> > own tree into the development code which I tend to do constantly to make
> > it easier to work directly on the development branch.  What's the best
> > practice here - push things to you a bit more aggressively and wait
> > until you've tagged a -rc and then merge that back up into the
> > development branch?

> No. Just don't do the merges. If your development tree isn't stable on
> its own, then there is something seriously wrong in what you do.

Just to be clear I'm not disagreeing that most if not all of these
merges aren't needed, I'm just trying to figure out in general how to
get the bug fixes into the development code when it is useful to do
that.  The merges are happening because I've been in the habit of
merging fixes up as a matter of routine rather than due to an actual
immediate need to get the fixes.

The major reason why the merges might be needed is that often enough to
be interesting the stuff getting pushed into -rc is the result of
fixing bugs that get discovered in the course of doing the new work and
interfere with that new work.  Either the testing needed to verify that
work makes some existing issue (that might also be triggered in some
other way) obvious or the bug got discovered by code inspection as
someone was looking at a feature and so the two changes end up colliding
with each other.

Especially in the cases where the lack of the bug fix breaks the new
code it sems sensible enough to want to do the merges so that the
history includes things that actually work.  This was a lot easier back
when there was no question of most embedded boards booting with vanilla
mainline and you couldn't actually directly develop or test usefully
with upstream code and working history wasn't an issue :/

> Just do this:
> 
>     gitk d52739c62e00..269d430131b6
>
> to see what I actually got, and then look at what you did on Nov 27,
> for example. You did *two* of the merges within hours of each other!
> And then you had two more the very next day, without even having any
> actual development in between! That's just crazy. The fact that you

Yes, it's excessive.  I also made the above graph much more confusing by
discarding my for-linus branch every time you merged it and making new
ones based off new -rcs which means that gitk can't just show a
for-linus branch that gets repeatedly merged into the development branch
but instead shows a bunch of random isolated commits which get merged
in.  I'm not saying that this would solve the problem you see, just that
it's an issue.

Clearly even if I did nothing beyond defer the merges until there was
some need for them that'd help though it wouldn't fully address your
issue.
