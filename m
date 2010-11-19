Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0KSTLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:11:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab0KSTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <5b55a1$in84he@fmsmga002.fm.intel.com>
References: <alpine.DEB.2.00.1011190118480.8681@skynet.skynet.ie> <5b55a1$in84he@fmsmga002.fm.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 11:04:37 -0800
Message-ID: <AANLkTikiZRHKRrosXgY5TEYODN_D_JLJ0XXWSb9g1zPQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 2:02 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Note it also contains a couple of fluff fallout patches from the recent
> drm-fixes rebase. (I thought it would be wise to include any core drm
> changes in our testing before sending the request...)

F*%^ me, why does drm always have to be so messy?

You guys pull each others trees, and then rebase them. Yes, git is
smart enough that it will merge it all fine, but dammit, now that
multi-hundred-line Radeon commit exists twice in the tree. Do this:

   git show --stat 16790569eddf fba4312e223f
   git show --stat 21e2eae4daae a41c73e04673

and cry.

And yeah, it's ugly. And if that patch introduces a regression (which
is entirely possible, it's not like it's small and trivial and
obviously correct) it will just make bisection harder, and add
confusion.  And it's totally pointless. It only adds pain. And it
makes the history harder to read.

Why did the Intel drm tree merge a patch that had _nothing_
what-so-ever to do with Intel DRM? WHY?

And why did the drm tree rebase a tree that had obviously been public
and pulled from? WHY? Why did you make it public before it was ready?
And/or why was it so ugly that it needed to rebase it? Why do these
things keep happening?

What's wrong with the whole drm crowd? Even if it isn't rebasing, why
is drivers/gpu/drm always so very visible in the later -rc trees?

I'm asking "why", but what I really want you guys to do is to ask
_yourself_ why. And ask "Why is that? What am I doing wrong that this
keeps happening?"

Really. Spend some time pondering. What the hell just happened, and
why did it happen, and how can you guys stop doing it?

Chris: stop pulling in random crap in your tree. Do _your_ development
in your tree. Nothing else.

And Dave, I have no idea why those two commits were rebased. They seem
identical in the tree that Chris had pulled. They have the same base
commit. What was the point?

                     Linus
