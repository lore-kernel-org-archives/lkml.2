Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424068Ab2LGDT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:19:57 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56536 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab2LGDTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:19:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8NAGlfwVB5LHa//2dsb2JhbABEuDmFehdzgh4BAQQBOhwjBQsIAw4KLhQlAyETiAoFwnoUjCWEQwOWApBIgwc
Date: Fri, 7 Dec 2012 14:19:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207031951.GG27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207011628.GB16373@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:16:28AM +0100, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > No, the problem is that the thing is not just a) wrong, but b) 
> > only made it in through sneaky ways.
> 
> People disagree with a), and b) only really matters if a) is 
> true.

Wow.

Let me paraphrase that logic:

If (maintainer thinks their patch is right) {
	patch doesn't need review
} else {
	/* maintainer thinks the patch is wrong. */
	/* XXX: why would you think your own patch is wrong? */
	patch needs review
}

Ok, if you were to disagree with the maintainer of a *different
subsystem* about whether the patch is right or not, how would you
know that the maintainer has made the change in the first place? It
hasn't been posted anywhere public like everyone who is not a
maintainer does....

Indeed, it is Ted's application of your logic that is the *exact
problem* that started this thread. Restating it as justification
for what has happened is a circular argument.

> You never gave a technical reason for why protecting against 
> future ABI clashes is 'wrong'. It looks like a marginally 
> useful, practical patch to me.

The concept isn't wrong - but the implementation is definitely
sub-optimal. We document syscall API changes, write tests for them,
and explain when and where filesystems need to implement
functionality, etc, and none of this has been done. I'd call that a
good technical argument for reverting the change, especially as
review would have picked this up and it would have been corrected
before proceeding with the change.

Simply put:

(concept == good) != (implementation == good)

And that's why we have review - to make sure the implementation is
as good as it can possibly be.

When you bypass review with the justification of "the concept is
good", then you are basically saying code review is irrelevant to the
implementation quality. Nothing could be further from the truth, and
that's why b) matters more than a). And in this case, we haven't
even got past the question of whether the concept is good or not
because it hasn't even been asked....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
