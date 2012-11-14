Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2KNRTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:19:39 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38876 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2KNRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:19:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121113225635.a848fd6c.akpm@linux-foundation.org>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
 <20121113213742.292f3ace.akpm@linux-foundation.org> <20121114064726.GA2537@gmail.com>
 <20121113225635.a848fd6c.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Nov 2012 09:19:16 -0800
X-Google-Sender-Auth: FFFiXBeF9ZKnhRK4ka8wnY_zlnA
Message-ID: <CA+55aFzY0+epP2Dxj=ghwVB3=JbM=qXC6a5V2kf9EzD_E-79tA@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 14
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> That solves one problem, but I still need to route around the numa
> stuff when preparing the 3.8-rc1 merge.  Again!

Btw - and this is tangential/unrelated - I really think that your
should strive to *not* base -mm on top of next, but instead put it on
top of the release kernel.

The "on top of next" approach not only causes you continual problems
like the above, it also causes the (related) problem that your email
patch-bombs always tend to be fairly late in the merge window, because
you need to wait for the big parts of linux-next to have hit my tree.

So it's more work for you, and it actually causes merge problems for me too.

I realize that you want to test a "everything" kernel, but at the same
time, that's actually counter-productive. It means that your tree ends
up depending on others, and you have to fight bugs that aren't even
necessarily yours at all.

And in this particular case, it would be easier for the NUMA people,
since your patches would presumably contain Mel's work, so they could
more easily rebase on top of your work, rather than the current
situation which is ass-backwards and has fundamental odering problems:
you want to base your stuff on linux-next, people want to put their
numa stuff into linux-next, and you have a bad circle.

Of course, people who want to base their work on top of Mel's code
often are git users already, so now they'd want a stable git tree
(non-rebased) to work on top, so they'd have problems with -mm anyway.
I don't know if Mel is a git user at all (there are no commits in the
kernel tree that are done by Mel, but maybe Mel has used git
elsewhere), but in this case maybe it would be a possibility that
Mel's NUMA patches could be done as one single stable -git branch, and
come into -mm (and linux-next) that way?

So I really think it would be much nicer if you just did your tree
directly on top of mine, instead of on top of linux-next. It would
make everything easier for everybody.

Of course, if you then want to test the combined thing, that's fine,
but that merging is also something that git is pretty good at. You
could just check the linux-next tree itself, since then Stephen would
have done the merging for you.

                  Linus
