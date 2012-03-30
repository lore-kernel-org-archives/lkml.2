Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325Ab2C3TRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:17:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56105 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760529Ab2C3TRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:17:18 -0400
MIME-Version: 1.0
In-Reply-To: <4F759B4A.5010807@kernel.org>
References: <4F759B4A.5010807@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 12:16:55 -0700
X-Google-Sender-Auth: 5AGBBwuaWH7NIY0mmQIwLH_WOKM
Message-ID: <CA+55aFxHpGhs72T6BNSaHJiZVRSKg8LTtWm7728RzP=+mrGTmQ@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI & Power Management patches for Linux-3.4-merge
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Lee <rob.lee@linaro.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 4:38 AM, Len Brown <lenb@kernel.org> wrote:
>
> The top commit is a merge with your latest tree
> to address some cpuidle/ARM conflicts.

Len, *please* don't do this.

I really hate it when submaintainers do merges to resolve things to
make things "easier" for me, and they do them wrong.

And I *guarantee* that your merge resolution is wrong. It has
references to the sdram_selfrefresh_[en|dis]able() functions that
simply no longer exist. There's no way that can compile.

Besides, even if you had done the merge right, I simply want to know
about conflicts between different maintainers. As a top-level
maintainer, that's the kind of information I need to know.

Finally, people - your merge messages suck. Leaving the list of
conflicting files without talking about what the conflict actually was
is *not* a good merge message. Len, you're not the only one that does
this, but it is yet another reason why I absolutely detest some of the
merges I see: they are just very uninformative, and don't add anything
useful to the tree - quite the reverse. They hide a problem, without
actually talking about what the problem was.

Now, I'm not guaranteeing that I will always do any of the above three
things better. I can screw up my merges too. And sometimes I miss
non-context merge conflicts that the maintainer may have known about.
And yes, sometimes my merge messages suck too (although I've tried
very hard to become better at them).

But there's been at least three merges that submaintainers did for me
this merge window where I looked at their merge and said "No, that's
wrong, and I would have done it better". Two of those were the nice
kind of "I left it unmerged, but here's my example merge if you want
to take it", so the wrong merges didn't ever show up in the tree. But
yours is now no longer even the top commit in your pile of fixes, so
now I apparently have to take that *known*incorrect* merge and fix it
up with an evil merge of my own.

So once more: please NEVER EVER make my life "easier" by pre-merging
stuff. EVER.

Feel free to do your regular octopus-merges of your *own* branches
where you just tie your own work together and bundle it up in a nice
package. Those merges are beautiful, and makes me go "Ahh, Len did a
really nice job keeping all his bugzilla fixes in separate nice
branches, and then he packaged it nicely for me too". That's a *good*
merge.

But don't go "oops, my changes conflict with somebody elses changes,
so let's hide the conflicts under a rug, and send Linus the pre-merged
tree so that he can just do a 'git pull' without having to even know
about things". That really doesn't make it easier for me.

If you want to make my life easier, the way to do that is:

 - have a nice readable history.

   This is much easier for me for two reasons:

    (a) it makes it much easier for me when I pull, and then look at
the end result, and I go "that all looks nice, this is a maintainer
that clearly has it all together". I feel all warm and fuzzy, and I do
not get the feeling that I pulled some crap tree. Trust me, that makes
me much more comfy about the pull.

    (b) when I do end up having to fix up some conflict, good history
without crazy backmerges etc make things *soo* much easier to see what
went on in the two conflicting branches. There is a real reason I hate
back-merges and ugly history: it really does make things much less
obvious.

 - You can have a *separate* branch that has your "suggested merge"
for me. Say "here's my 'release' branch with all my work, and this
'merged-for-linus' branch has my suggested merge".

   If you do that, I actually tend to do the merge *twice*: first I do
it normally by hand, and then after I'm all done, I will actually
re-do it in a local 'test' branch with your suggested merge, and see
what the differences are. This is how I noticed that two of the
suggested merges in this merge window were incorrect.

  This sounds like "more work" for me, but it really isn't. Sure, I'll
do two merges, but the second merge will presumably not have any
conflicts, and now I have something I can double-check with. So it's a
bit more typing, but it saves me a lot of worries, and I can verify my
merge (or I can look at the parts we differed on and think harder
about just those, and just assume that the things we agreed on were
likely all correct)

So to re-iterate: please don't merge other sub-maintainers' code.
That's my job, I'm actually pretty good at it, and even if I were to
be no better at it than you are, I'd still want to know about the
conflict.

Please.

                     Linus
