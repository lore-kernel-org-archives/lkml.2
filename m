Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2KZJML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:12:11 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45704 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169Ab2KZJMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:12:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQJAGgxs1B5LFFR/2dsb2JhbABEDoUxtF6GBRdzgh4BAQQBOhwYEAsIAxUDLhQlAyEBEhSHcwW+ZRSMI4RBA5YAkEWCMlE
Date: Mon, 26 Nov 2012 20:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121126091202.GO32450@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126002814.GM32450@dastard>
 <20121126025520.GC22858@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126025520.GC22858@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 09:55:20PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 26, 2012 at 11:28:14AM +1100, Dave Chinner wrote:
> > fs: revert commit bbdd6808 to fallocate UAPI
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit bbdd6808 ("fs: reserve fallocate flag codepoint") changes the
> > fallocate(2) syscall interface. The flag that is reserved by this
> > commit is for functionality that has previously been NAKed on the
> > -fsdevel mailing list, and so exists out-of-tree.
> 
> Hi Linus,
> 
> It doesn't change the interface or break anything; it just reserves a
> bit so that out-of-tree patches don't collide with future allocations.
> There are significant usages of this bit within Google and Tao Bao.
> It is true that there has been significant pushback about adding this
> functionality on linux-fsdevel;

It's not the fact that you want to reserve a bit that is at issue
here - it's the way it's been pushed into the tree that is the
front-and-center issue.

> I find it personally frustrating that
> in effect, if enough people scream, they can veto an optional feature
> that might only be implemented by a single file system.

Having a significant portion of the wider fs development community
disagree with your patches is no reason for subverting the review
process.  Besides, that's irrelevant to the issue being discussed,
unless you are describing your motives in an effort to justify your
actions.

In fact, it's even more disturbing if this was your real motive.
That is, is sounds somewhat like you've just admitted that you
pushed this change silently through the ext4 tree to avoid review
and discussion and that you are blaming the rest of the FS community
for forcing you to take such actions.

> It's not like there is any shortage of flag bits, so what's the harm
> of reserving the bit?

The harm has already been done - to the trust we've placed in you as
a maintainer.  To argue that the code does no harm is to completely
miss the crux of the issue at hand: principles, process and trust
are far more important in our community than a single line of
code.

Ted, it comes down to trust. If we can't trust you not to push your
own changes to syscall APIs into the mainline tree via backdoor
channels, then how can we trust you not to push the entire
out-of-tree patch into the kernel the same way?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
