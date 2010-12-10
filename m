Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0LJCf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:35:27 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5004 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab0LJCf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:35:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMMeAU15LdBk/2dsb2JhbACjfnnADIVKBA
Date: Fri, 10 Dec 2010 13:35:20 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101210023520.GC3331@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
 <20101209081756.GE8259@dastard>
 <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
 <20101209234258.GB9925@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209234258.GB9925@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:42:58AM +1100, Dave Chinner wrote:
> On Thu, Dec 09, 2010 at 11:53:27PM +1100, Nick Piggin wrote:
> > >> Like I said, there are infinite cleanups or improvements you can make.
> > >> It does not particularly matter that they happen before or after the
> > >> scaling work, except if there are classes of APIs that the new locking
> > >> model can no longer support.
> > >
> > > We do plenty of cleanups when changing code when the result gives us
> > > simpler and easier to understand code. It's a trivial change that,
> > > IMO, makes the code more consistent and easier to follow.
> > 
> > Unrelated "cleanups" in the same patch as non trivial locking change
> > is stupid.
> 
> So put it in another prepartory patch. It makes the locking changes
> easier to understand...

I didn't change that, though, the ordering of locking unrelated
dentries and the code is already in rename code and is not touched
during this patch set.


> > Necessary changes to prevent bad ugliness resulting, or preventing
> > repeated steps for the particular changes, etc. of course. Killing un
> > related functions no.
> 
> Ok, I get the picture. You don't want a code review, you want a
> rubber stamp. Find someone else to get it from.

Of course I want code review. I am not going to just do everything
you say that I don't agree with, but I will explain why every time
(as I have done to all your points).

I would prefer more in-depth review than from someone who doesn't know
d_lock protects d_flags, but any and all help is welcome. Even minor
nitpicking or cleanups are welcome if they are relevant to the patches.

Thanks,
Nick

PS. don't accuse me of not wanting a code review, because you're just
projecting. To paraphrase you:

 I don't have to justify myself to you, nick, only the maintainers, so
 I'm not answering.

In response to my questions.

