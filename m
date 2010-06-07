Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0FGSvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:51:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab0FGSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:51:37 -0400
Date: Mon, 7 Jun 2010 11:45:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pjones@redhat.com, mchristie@redhat.com
Subject: Re: Linux 2.6.35-rc2
In-Reply-To: <20100607181455.GB16928@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.00.1006071121450.3515@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org> <20100607163746.GB13468@phenom.dumpdata.com> <alpine.LFD.2.00.1006070939210.3515@i5.linux-foundation.org> <20100607181455.GB16928@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Konrad Rzeszutek Wilk wrote:
> 
> Ah, <sigh> I seem to have a knack for continously missing the merge
> windows. Is it fair to state that:
> 
>  1). Once you send an email saying that Linux 2.6.35 is released, the
>      merge window has opened.
>  2). Then the the maintainers have two weeks to send you git pull
>      request for new features.
>  3). After the two weeks, it is rc1, and only bug-fixes are accepted?

That's the rough outline yes. I say "rough", because:

 - You should have had the stuff ready _before_ I even opened the merge 
   window. So the "two weeks" is literally the time for you to send the 
   email, not the time for you to do the development work.

   (That sounds crazy, and reality is a bit more complicated: there are 
   people who know they have conflicts from sitting in -next, so strictly 
   speaking, the two weeks is so that we can sort things like that out, 
   and also so that I can stagger out the pulls a bit so that we have 
   nightly snapshots with testing etc that doesn't contain _everything_ in 
   one big lump etc etc).

 - You can (and some people do) anticipate the merge window, and even send 
   the pull request to me before it opens. HOWEVER, I would suggest you do 
   this only if you know you're going to be on vacation during the merge 
   window or something like that, and perhaps ask somebody else to remind 
   me once the merge window opened, because I get too much email, so while 
   I try to make sure to process pull requests that happened before, I'm 
   also not organized enough to at all guarantee it.

 - I tend to be lenient. In fact, I tend to be _too_ lenient and end up 
   pulling, even if I may curse at developers when they send me pull 
   requests (I really am not very polite even at the best of times). This 
   release around I'm a bit more hard-nosed about the rules than I usually 
   am, so now I still curse, but then I actually say "no, I won't pull, 
   because I'm holding you to the rules".

   Normally, I do not believe in black-and-white rules, and many things 
   are meant to be "those are the rules, but we'll all use our own brains 
   and judgement". And that's still true, but my judgement this release 
   around is a lot stricter, just because I'll be off on vacation in the 
   middle of the release window and thus needed to be stricter.

So the process I generally encourage sub-maintainers to have is roughly

 - if you are a git maintainer, use two brances: one called "stable", one 
   called "devel" (and no, I don't care about the names. Think of them as 
   just illustrations)

 - never _ever_ ask me to pull from the "devel" branch.

 - when you see my release announcements (or you just predict it, because 
   they are pretty predictable: I tend to start saying at around -rc6/7 
   whether I think that's the last -rc or not etc), you make sure I've 
   pulled your old "stable" branch (ie that all the bug-fixes from it are 
   in the mainline tree), and then you delete it and rename your "devel" 
   tree (if you think it's ready to be merged) to be "stable".

 - You are now ready to ask me to pull your new "stable" branch. 
   Obviously, it should be in a good enough shape that you really think 
   the name "stable" is ok. If that's not the case, you shouldn't have 
   done the renaming, and you shouldn't plan on getting it merged.

   (Yes, the post-merge-window -rc phase is for "fix up problems", but it 
   should be to fix up problems that _other_ people notice, not problems 
   that you already knew about when you asked me to pull. See? If you know 
   about problems, you're not ready for that merge window)

 - Once you've renamed your "devel" tree as "stable", you can start a 
   _new_ "devel" branch. So you can still continue to develop during the 
   merge window, but you do it in the branch that you know you won't ask 
   me to pull (until the next merge window, when the next big renaming 
   comes along)

 - fixes obviously go into the "stable" branch, and you can ask me to pull 
   those at any time (although I generally frown on daily pull requests).

Now, the above is just a suggestion. Use it as a template for whatever 
workflow works for you. Non-git users can also use it as a template for 
how they should work, even if the details of exactly how they handle the 
stable/devel branches would be different.

And git users may well have different flows. Some people (and I really 
appreciate it, btw) have _way_ more than one "devel" branch. They name it 
by the actual _feature_ they are developing, and then when they ask me to 
pull they will have merged all their feature branches together (or, if 
they are big features and you're not sure about them all, you can 
certainly ask me to pull them one by one too!).

So really, take all of the above as a "this is a guideline". It's not set 
in stone, it's not how you _must_ work, it's not a requirement. But it is 
an example of how things can be done, and it's an example of how you can 
do development all the time (so you don't have to think of the "merge 
window" as some big break in development at all!).

So you absolutely can make whatever changes to the flow that suit the way 
you work, or that just make more sense for your subsystem. Part of the 
Linux kernel development process is very much a certain amount of 
flexibility - with a pretty rough framework to make it possible at all to 
make sane releases.

				Linus
