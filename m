Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab0HGHbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:31:55 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:42159 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab0HGHbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:31:52 -0400
X-ASG-Debug-ID: 1281166310-3a5500010000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5D0BE2.3050209@fusionio.com>
Date: Sat, 7 Aug 2010 09:31:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
In-Reply-To: <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281166310
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 05:44 PM, Linus Torvalds wrote:
> On Fri, Aug 6, 2010 at 3:38 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Not sure what happened on the excessive number of merges listed
>> as:
>>
>>      Merge branch 'for-2.6.36' into for-next
> 
> Yeah, I'm not taking this. This has all the signs of the things people
> used to do a year or two ago - daily merges into random points of my
> tree. Some of them are more than daily.
> 
> There is no excuse. None. Your "I thought they were all going to be
> fast-forwards" excuse is pointless. You shouldn't have done it in the
> first place, and once you did it, you should have noticed, instead of
> doing _another_ merge on the same effing day!

Yep I should have noticed, but to be honest this is how I've done
for-next updates for quite a while and I didn't expect issues. In most
cases, for-next is the same as for-2.6.36. Sometimes other things are
pulled in there as well. I just don't see why the merges are listed in
the for-2.6.36 'main' branch, for-next is just a throwaway that can and
is rebased if need be while for-2.6.36 should remain stable on the same
base.

> I accept a few merges over many weeks. I accept things like merging
> tags (preferably the _release_ tags, rather than -rc's). But you have
> two merges of my tree ON THE SAME DAY, and you have three merges - of
> just totally trivial and uninteresting individual patches - from your
> own branch within a couple of days. For no reason I can fathom. Why
> didn't you do those commits on the right branch to begin with?

Sometimes urgent patches will sit in for-linus and then I will merge
those in to for-2.6.36 to save Stephen the hassle of carrying conflict
update patches.

> That's just f*cked up. And quite frankly, I have no other way to fix
> crap like this than to say "I won't merge it". If I do merge it, not
> only do I get the crap, but I just know I'll _continue_ to get crap
> because things don't get fixed. Which is why I've spent so much time
> talking about clean history over the years.
> 
> I thought we were over this.
> 
> I would suggest you:
> 
>  (a) think about what the hell you do wrong. I can point to at least a
> couple of things:
> 
>  - you use two branches for the same thing, for no reason. You
> apparently have "for-next" and "for-2.6.36", and you seem to have
> thought they were different (why?) and then merged between them
> sometimes daily.

As mentioned above, for-next is just a throw away for linux-next where
things are merged together. See below.

>    If they are separate, you shouldn't be merging them (and you should
> _never_ merge daily - if it's under development, it just messes things
> up). And if they aren't separate, you shouldn't mess things up and use
> two different branches for the same thing, and then just make things
> messy that way.
> 
>  - You merged from my tree at random points. Why? Until you ask me to
> merge from you, there is NO REASON to try to resolve conflicts. And
> once you _do_ ask me to merge from you, I still don't want you to do
> the merge, because I want to know about what conflicts. That's where
> the bugs almost always are.

I tend to merge in your tree when I _know_ there's a conflict there,
since it's much easier to fix things up when they happen and the change
is fresh, than wait potentially 2-3 months and then have to resolve
everything in one go. The latter carries a much higher risk of screw ups
when merging - and as you note, this is usually where the bugs creap in.
It also helps linux-next since then the tree will merge cleanly with
your -git variant at least and Stephen doesn't have to fiddle around
with doing patches for lots of trees to fix things up.

But if you don't like that way of doing things, I will stop and just
keep for-2.6.X+1 patches in a branch that is based off 2.6.X and never
updated. I will try that for the next release and see how that goes.

>   And finally: if you do merge from me, don't merge some random
> "master" branch. Merge the v2.6.35 release tag.
> 
>  (b) Once you are sure the current mess doesn't ever happen again,
> rebase the mess on top of 2.6.35. NOT on top of whatever random
> unstable tree-of-the-day-during-the-merge-window. Rebasing on top of
> something unstable is crazy work, and should absolutely never be done.
> And then test the hell out of it, and walk through it all making sure
> it's ok. And do that for a couple of _days_.

Agree, that is stupid and I should not be doing that...

> And note: one of the reasons I want the block tree to be clean is that
> the biggest problems we had last release cycle was with the writeback
> code. Quite frankly, if you can't get it sorted out and tested well by
> the end of the merge window, I will absolutely _happily_ not pull your
> tree this release at all. Because last release was annoying and
> clearly not tested enough. If the work gets delayed by a release (or
> two), I'll be perfectly ok with it.

Completely agree, and I understand why you are cautious around things
that have the potentially to screw up users data. The writeback and
block IO changes are both such candidates.

> So if we hadn't had problems last release, I might have let this
> slide. But I am of the very strong opinion that the block tree has not
> been careful enough. The mess with ugly history is just a symptom of
> that, I think.

OK, not a problem, that's why I asked! I'm travelling to Boston right
now and will do the rebase and reshuffle in the air. That should leave
me time to do some testing before asking you to pull it again.

I'm not very proud of how this series ended up looking, that's a given.
Another mistake is carrying too many things in one branch, I will switch
to topic branches for the next release and ensure that the process is a
lot saner history wise.


-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
