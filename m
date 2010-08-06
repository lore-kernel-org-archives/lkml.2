Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450Ab0HFPpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:45:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab0HFPpQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <4C5BE640.2050801@fusionio.com>
References: <4C5BE640.2050801@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 08:44:31 -0700
Message-ID: <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 3:38 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Not sure what happened on the excessive number of merges listed
> as:
>
>      Merge branch 'for-2.6.36' into for-next

Yeah, I'm not taking this. This has all the signs of the things people
used to do a year or two ago - daily merges into random points of my
tree. Some of them are more than daily.

There is no excuse. None. Your "I thought they were all going to be
fast-forwards" excuse is pointless. You shouldn't have done it in the
first place, and once you did it, you should have noticed, instead of
doing _another_ merge on the same effing day!

I accept a few merges over many weeks. I accept things like merging
tags (preferably the _release_ tags, rather than -rc's). But you have
two merges of my tree ON THE SAME DAY, and you have three merges - of
just totally trivial and uninteresting individual patches - from your
own branch within a couple of days. For no reason I can fathom. Why
didn't you do those commits on the right branch to begin with?

That's just f*cked up. And quite frankly, I have no other way to fix
crap like this than to say "I won't merge it". If I do merge it, not
only do I get the crap, but I just know I'll _continue_ to get crap
because things don't get fixed. Which is why I've spent so much time
talking about clean history over the years.

I thought we were over this.

I would suggest you:

 (a) think about what the hell you do wrong. I can point to at least a
couple of things:

 - you use two branches for the same thing, for no reason. You
apparently have "for-next" and "for-2.6.36", and you seem to have
thought they were different (why?) and then merged between them
sometimes daily.

   If they are separate, you shouldn't be merging them (and you should
_never_ merge daily - if it's under development, it just messes things
up). And if they aren't separate, you shouldn't mess things up and use
two different branches for the same thing, and then just make things
messy that way.

 - You merged from my tree at random points. Why? Until you ask me to
merge from you, there is NO REASON to try to resolve conflicts. And
once you _do_ ask me to merge from you, I still don't want you to do
the merge, because I want to know about what conflicts. That's where
the bugs almost always are.

  And finally: if you do merge from me, don't merge some random
"master" branch. Merge the v2.6.35 release tag.

 (b) Once you are sure the current mess doesn't ever happen again,
rebase the mess on top of 2.6.35. NOT on top of whatever random
unstable tree-of-the-day-during-the-merge-window. Rebasing on top of
something unstable is crazy work, and should absolutely never be done.
And then test the hell out of it, and walk through it all making sure
it's ok. And do that for a couple of _days_.

And note: one of the reasons I want the block tree to be clean is that
the biggest problems we had last release cycle was with the writeback
code. Quite frankly, if you can't get it sorted out and tested well by
the end of the merge window, I will absolutely _happily_ not pull your
tree this release at all. Because last release was annoying and
clearly not tested enough. If the work gets delayed by a release (or
two), I'll be perfectly ok with it.

So if we hadn't had problems last release, I might have let this
slide. But I am of the very strong opinion that the block tree has not
been careful enough. The mess with ugly history is just a symptom of
that, I think.

                    Linus
