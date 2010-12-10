Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0LJJBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:01:35 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:56476 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755419Ab0LJJBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:01:33 -0500
Date: Fri, 10 Dec 2010 20:01:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101210090126.GH8259@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
 <20101209081756.GE8259@dastard>
 <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
 <20101209234258.GB9925@dastard>
 <20101210023520.GC3331@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210023520.GC3331@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 01:35:20PM +1100, Nick Piggin wrote:
> On Fri, Dec 10, 2010 at 10:42:58AM +1100, Dave Chinner wrote:
> > On Thu, Dec 09, 2010 at 11:53:27PM +1100, Nick Piggin wrote:
> > > Necessary changes to prevent bad ugliness resulting, or preventing
> > > repeated steps for the particular changes, etc. of course. Killing un
> > > related functions no.
> > 
> > Ok, I get the picture. You don't want a code review, you want a
> > rubber stamp. Find someone else to get it from.
> 
> Of course I want code review. I am not going to just do everything
> you say that I don't agree with, but I will explain why every time
> (as I have done to all your points).

Which generally comes down to "I disagree with you". That's hard to
argue against because you aren't willing to compromise.

So, to address your next comment, I'll restate what I was proposing.
That is, to ensure all the d_flags accesses protected by d_lock as
an initial patch rather than cleaning it up in an ad-hoc fashion
later on, such as this later patch in your series:

[PATCH 14/46] fs: dcache scale d_unhashed

which has the description:

	Protect d_unhashed(dentry) condition with d_lock.

which illustrates my point that not all accesses to d_flags are
currently protected by d_lock as you are asserting. Hence:

> I would prefer more in-depth review than from someone who doesn't know
> d_lock protects d_flags,

Your implication about my competence is incorrect and entirely
inappropriate.  Ad hominen attacks don't improve your argument or
encourage other people to review your code.

> but any and all help is welcome. Even minor
> nitpicking or cleanups are welcome if they are relevant to the patches.

If _you_ decide they are relevant.

Nick, in the past couple of months you've burnt everyone who has
tried to review your changes in any meaningful way. Nobody wants to
engage with you because you've aggressively disagreed with every
significant change that has been requested. You have shown no desire
to compromise, instead you argue that you are right until you've had
the last word, and you have frequently resorted to condesending and
disrespectful attacks on reviewers. You would do well to keep that
in mind next time you wonder why nobody is stepping up to review
your code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
