Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1AOVcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 16:32:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:33449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1AOVcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 16:32:20 -0500
Subject: Re: ia64 broken by transparent huge pages - other arches too?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
In-Reply-To: <20110115172320.GU9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
	 <1295076096.4875.60.camel@pasglop> <20110115155925.GT9506@random.random>
	 <1295110048.5973.36.camel@mulgrave.site>
	 <20110115172320.GU9506@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 08:31:23 +1100
Message-ID: <1295127083.4875.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-15 at 18:23 +0100, Andrea Arcangeli wrote:
> 
> 
> By all means next times I'll try to get through linux-next too if this
> is preferred, but the brainer part has been heavily tested and that's
> the important thing as far as I can see.

Linux-next is the integration testing essentially. That's where we find
such build regression and to a lesser extent maybe, runtime regressions.

I think you under estimate the pain caused by build breakage. The main
problem is that it makes bisection difficult, and that's a pretty big
deal in a merge window. If everybody stops caring about build breakage,
bisection would essentially become unusable accross merge windows.

> I'm also not sure if having it in linux-next instead of -mm, would
> have been better in terms of handling of the patchstream. I think
> having it managed in -mm reviewed by all other -mm developers using
> raw patches floating in the linux-mm and mm-commit lists, was ideal
> and potentially more valuable for an increased amount of review, than
> what a blind pull from linux-next could provide. For the brainer part,
> maximizing the reviewing was certainly more valuable than checking if
> it builds and boots on some arch not affected in any functional way.

It's not a matter of -mm vs. -next. You should not have a patch set that
is still a work in progress in -next. The later is for things that are
essentially ready to merge, to simmer there for a few days to find out
typically bad patch collisions (more than simple fixups), such build
breakages, major runtime breakages, etc... Ideally, things in -next
don't need a respin before going upstream but at least there's a last
chance to do so. 

The question becomes should -mm itself go into -next, and that I'm less
certain of. It depends on what criterias Andrew applies to things that
go into -mm I suppose, but if they qualify as "mature stuff ready to go
upstream" then by all means.

> I think the sparc/arm build issues because of cleanup code refactoring
> are not worth worrying too much about, or at least they shouldn't be
> the argument for lack of testing. Said that, I apologize for the
> annoyance and I appreciate your help in the arm case. ia64 I fixed it
> with a one liner already.

But that's the whole point... all those "little issues" have actually
broken build on 3 architectures so far, and this is -bad-. Yes, none of
them is major, all of them are easily fixed ... and all of them have
been a pain in the neck for some people somewhere and have broken
bisection accross a portion of the merge window.

Having a bit of time in -next allows to easily avoid most of this.

> Overall I think the end result is great, perfection was the goal and
> if these build issues are the only error I think we got as close as
> humanly possible to it. And it's definitely thanks to an huge amount
> of help and feedback from the whole Linux community (both developers,
> maintainers and testers) if we could achieve this result, I could
> never achieve this alone.

Cheers,
Ben.


