Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2DPU1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:27:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62262 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2DPU07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:26:59 -0400
Date: Mon, 16 Apr 2012 22:26:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, apw@canonical.com
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests for
 braces, comments and casts
Message-ID: <20120416202654.GA4678@gmail.com>
References: <20120416091719.GA4113@gmail.com>
 <20120416.142728.864894452301706752.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416.142728.864894452301706752.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Mon, 16 Apr 2012 11:17:20 +0200
> 
> > 
> > This recent checkpatch commit, added in v3.4-rc1:
> > 
> >   aad4f6149831 checkpatch: add --strict tests for braces, comments and casts
> > 
> > made the default checkpatch run complain about the following 
> > perfectly fine multi-line comment block:
> > 
> > +               rdp->qlen_lazy = 0;
> > +               rdp->qlen = 0;
> > +
> > +               /*
> > +                * Adopt all callbacks.  The outgoing CPU was in no shape
> > +                * to advance them, so make them all go through a full
> > +                * grace period.
> > +                */
> > +               *receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
> > 
> 
> I would like to formally propose that we change CodingStyle so that
> our comments are of the form:
> 
> 	/* XXX
> 	 * YYY
> 	 */
> 
> So that we can save one line of vertical space.
> 
> We've adopted this all across the networking, and the code 
> looks a lot nicer as well as allowing more actual code onto a 
> single window of text.

Sigh, this is sad for two reasons:

 1) It's butt ugly and it violates every basic principle of
    typography. Saving a line is often counter-productive, a 
    well placed whitespace (vertical or horizontal) will often 
    increase readability. Key is good balance.

    If you don't "see" it as ugly it's simply because your brain
    is not wired up to see 3D/2D geometry as a significant
    source of information. A significant portion (I'd 
    guesstimate a narrow majority) of kernel hackers *does* see
    2D/3D layout details in code and finds inconsistencies in 
    them counterproductive.

    ( It's roughly the same distinction that makes some people
      love the typographic layout of the iPhone/iPad while 
      others consider it unnecessary bling. )

 2) Even if it was proper typography (which it isnt), we have
    Documentation/CodingStyle for damn good reasons: so that
    people see a uniform style of code across the kernel. The 
    taste set out there is sometimes arbitrary in its details, 
    but one thing is certainly worse than arbitrary style rules:
    *random*, inconsistent rules, because that only adds noise.

Thanks,

	Ingo
