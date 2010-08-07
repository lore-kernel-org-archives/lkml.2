Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0HGVPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:15:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720Ab0HGVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <4C5D0C79.5010103@fusionio.com>
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com> 
	<AANLkTi=WyWdERdyM+X5VOTX02_O_5GqV9hBQ145RmMWg@mail.gmail.com> 
	<4C5D0C79.5010103@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Aug 2010 14:15:15 -0700
Message-ID: <AANLkTincMAv0OLYHSqHNwrhfKBC-yQHhgWdqKYHoJNOf@mail.gmail.com>
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 12:34 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> OK, so a question on this. Say a bug surfaces in the middle of the
> release and we push in a change to fix that at 2.6.36-rc3 time. This
> same patch will not apply directly to the branch holding 2.6.37 patches
> due to code reshuffling or whatnot. How do you want that handled? I
> can't pull in your branch and resolve it. The merge conflict may not be
> visible to you until 2.6.36 is released and I want to offload the
> patches to you, but it will be visible in linux-next pretty much
> immediately.

So I think there's a few possible answers to that.

One is the one I outlined in my previous email: merge the next -rc
tag, and explain why you merged it in the commit message. That not
only makes the merge commit message be way more informative ("Merge
commit v2.6.3x-rcy" rather than "Merge branch 'master'"), but it also
automatically acts as a "rate limiter" for the merges.

Now, that may cause problems for linux-next for a few days too, since
I think linux-next always starts from some random tree-of-the-day of
mine. That itself may be more indicative of a linux-next problem,
though. It might well make sense to base linux-next itself on the
latest tagged release rather than on some random daily thing (and if
the things that get merged _into_ linux-next then are based on a
random daily thing and bring linux-next forward, then that's a problem
with the trees getting merged - they shouldn't be doing that either).

The other possibility is for you to do throw-away merges just for
linux-next. That way _you_ do the merge (not Stephen or one of the
linux-next helpers), but the merge is going only into for-next, not
into your for-2.6.36 branch. "git rerere" will help you re-do the same
merge for future for-next trees - the same way linux-next already
generally only needs to do the merge resolution once.

Then, when you actually want to send it to me, at that point (if it's
a really complicated merge and you know it's too complex for me), you
can do one final merge into 'for-linus' before you send me the pull
request. Again, git rerere will help you re-use your previous merge
resolutions.

Or don't merge at all when you send it to me, and only do the merge if
I then reply with "ok, that's too complicated for me".

I will _never_ complain about you sending me something I can't merge.
I may throw it back at you, but I won't complain about you trying to
give me merge work.  I really do like knowing about the conflicts.

Of course, if I do the merge conflict resolution I may then see
something odd and complain about it. Something I might not have even
noticed if it hadn't been pointed out to me by the conflict ;)

                       Linus
