Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2AFXgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:36:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2AFXgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:36:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Status of arm-soc.git for 3.2
Date: Fri, 6 Jan 2012 23:36:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>
References: <201201032243.06440.arnd@arndb.de> <20120104100016.GK2914@n2100.arm.linux.org.uk>
In-Reply-To: <20120104100016.GK2914@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201062336.31181.arnd@arndb.de>
X-Provags-ID: V02:K0:5+QYP/i8iWXdqmi45hykN2Yvv+reM4d6XizheTenFKk
 wjthTuPT/ZxiHtc/J50ZirKBSCzdnxEVkVdENhMK67OKYNWAut
 EFvvL0+EaCUcHpeT9C8okdlnT0SGpbfoMMZ9XEwYYh3fqGGhlZ
 x2bRYf8g1tKR+PHISPp682aSNBe+k2uFSg0DRfeZDEhd1d79iL
 WcJtCPAUcKRGZ+q2fGlOGBiaxGRqXZzDhqpCxxY/RSsdKWTU2k
 7+jlLNC+Kdzd+A2OFXqTeOxvvnHvcY1dyk4fpGpvEiWKc6nICJ
 VSQvcVqx3wVxpL8wQy7LAmY3ZZowCcPN84mo0sVCvuoam6M9zu
 r1VSNVF+508rNEMp0L5o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 January 2012, Russell King - ARM Linux wrote:
> On Tue, Jan 03, 2012 at 10:43:06PM +0000, Arnd Bergmann wrote:
> > The merge window is almost there, so it's time to look at what we've queued
> > up in the arm-soc tree. There is a total of 55 branches with 386 non-merge
> > changesets on top of mainline and the dependencies (linux-arm, v4l and
> > dmaengine). The total diffstat is:
> > 
> >  676 files changed, 19694 insertions(+), 12633 deletions(-)
> 
> Well, my tree looks like this:
>   937 files changed, 8150 insertions(+), 10774 deletions(-)
>
> > I would like to stop adding non-bugfix patches into the branches above now
> > for 3.2, and instead merge everything that I receive from now on into
> > late/* branches, so we don't destabilize the patches that are already there
> > and so I can feel more comfortable about sending everything in the next/*
> > branches upstream ASAP.
> 
> I think that's a must - for both our trees.  We have quite a number of
> conflicts in linux-next between our trees and other trees - some of them
> due to duplicated commits being applied.

Hmm, I'll have to check that, I was hoping that we manged to weed out
the duplicated commits. Do you have a list, or some (semi-)automated
way to find those, or are those just random commits you stumbled
over.

> I'm feeling less than confident about my tree for this upcoming merge
> window than I've ever felt before - I think we're in for quite a bit
> of stick, possibly from Linus, over the about of silly conflicts and
> duplicates which we have with other trees.

Yes, the silly conflicts last time were a bit too much. Linus always
says that he wants to see the conflicts when they happen, but we
really shouldn't let him see conflicts between your tree and arm-soc.
I think we can eliminate those at least by pulling in your branches
where the conflicts happen.

Olof has updated the arm-soc tree to the latest version of your
devel-stable branch, which means that all conflicts between that
and the branches in arm-soc should be dealt with already. I've
added one merge from devel-stable into our next/drivers2 branch
to prevent a modify/rename conflict and resolved silly conflicts
between branches within arm-soc.

> It's proven to be _impossible_ to sanely do an architecture wide change
> to the way the restart stuff is handled - because SoC maintainers have
> taken to adding their own individual patches for it to their git trees.
> What I had hoped was to get that all sorted by the end of November, and
> publish the whole thing as a stable branch, but that was utterly thwarted
> by non-responsive maintainers - for example, some of this stuff only
> getting finally fixed _yesterday_.

I've not resolved the conflicts between stuff in arm-soc and your restart
branch yet, because I don't know in what order we should do the merges.

We can certainly submit 'arm-soc/fixes-non-critical', 'arm-soc/cleanups'
and 'rmk/devel-stable' right away because there are no conflicts between
those. That alone would get us a great deal forward.

The rest of the arm-soc branches more or less depend on your 'devel-stable'
and conflict with your 'restart' branch. If you want to go first, you
can submit your that branch now, and Olof or I will resolve the conflicts
with it before pushing the arm-soc branches. Alternatively, we
submit everything except 'next/move' and 'next/drivers2' (those should
come last) once your 'devel-stable' is in and let you work out the
conflicts. I'm fine with it either way, but as you say it's certainly
not a easy ride to get them all resolved.

> To some extent, it still is being thwarted by non-responsive maintainers:
> the "Temporary #error" commit is still there.  I'm in two minds about
> whether to push that up to Linus or not - they've had sufficient warning
> both on this mailing list, by personal email, and a #error being in
> linux-next making their platform(s) unbuildable for about a month.
> 
> Therefore, I have no issues what so ever breaking the three platforms
> (gemini, shmobile, vt8500) which remain unconverted at the next merge
> window, and I don't care what they say about that happening.  (If they
> cared, they should respond to email.)

Yep, agreed.

> However, one thing that really concerns me is that we're going to have
> to go through all this again over the next three months, because of the
> arch_idle changes which Nicolas has.  I am not looking forward to that.

If you prefer, I can try to handle those in arm-soc, but I'm not sure
if that helps. We can try.

	Arnd
