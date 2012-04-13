Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691Ab2DMKE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:04:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53913 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2DMKE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120413053416.GC12807@1wt.eu>
References: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
	<20120412.181256.1267592727086214582.davem@davemloft.net>
	<CAMP44s26eJ6mFHt=C+_AJCkGiDAcMq1O1HsCXPZd5-FRYkZoXQ@mail.gmail.com>
	<20120413053416.GC12807@1wt.eu>
Date: Fri, 13 Apr 2012 13:04:24 +0300
Message-ID: <CAMP44s36PFbo6R1Wa5ZULByOS2qQFad-e6Mavgjv9B3v-oGFoA@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        gregkh@linuxfoundation.org, lists@uece.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com,
        ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 8:34 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Fri, Apr 13, 2012 at 01:58:10AM +0300, Felipe Contreras wrote:
>> On Fri, Apr 13, 2012 at 1:12 AM, David Miller <davem@davemloft.net> wrote:
>> > From: Felipe Contreras <felipe.contreras@gmail.com>
>> > Date: Fri, 13 Apr 2012 01:04:42 +0300
>> >
>> >> Wrong is wrong, before or after the 3.3.1 tag, this patch is not
>> >> 'stable' material, and removing it does not affect upstream at all.
>> >
>> > What you don't understand is that bug fixes will get lost if you only
>> > fix them in -stable, it doesn't matter HOW THEY GOT into -stable.
>>
>> Let's suppose that c1afdaf was never back-ported from v3.4-rc1, how
>> would you have fond out there was an issue with it? There's 10000
>> patches in v3.4-rc2, how do you expect to find issues in them?
>>
>> People found out this issue on v3.4-rc1, so the fix would not have
>> been lost, but lets assume it would, v3.3.1 had the issue, the patch
>> as reverted in v3.3.2, and v3.4 still had the issue. So what? There's
>> already 10000 patches that would never make it to 3.3.x, and many will
>> have issues, which is why there would be v3.4.x.
>>
>> > In fact IT HAS FUCKING HAPPENED that we didn't fix something upstream
>> > that got fixed in -stable a time long ago when we didn't have the
>> > policy we're using now which you're going so unreasonably ape-shit
>> > about.
>>
>> I see how a *fix* on stable could get lost, but this is not a fix.
>
> Felipe, you don't seem to get it : there are many bugs in each new release.
> Given the number of fixes Greg merges into a longterm branch, I'd say that
> there are around 1500 bugs waiting to be discovered and fixed in a new
> release. Does this mean we need to fix them all at once ? No, because we
> don't know about them yet.
>
> The process you're criticizing consists in ensuring that once a bug is known,
> it gets fixed in mainline so that it never appears there again. The way the
> bug is discovered doesn't matter, even if it's discovered that a fix caused
> the bug and that it must be reverted. The fact is mainline is buggy and we
> know this because stable is too. So mainline must be fixed first. This
> process works because stable users are pressuring developers to push their
> fixes to Linus in order to get them. What happened with this bug prooved
> the process is working fine.

Let's list the scenarios:

a) normal patch

v3.3 (good), v3.4 (+) (good)

b) normal stable patch

v3.3 (good), v3.3.1 (+) (good), v3.4 (+) (good)

c) regression patch

v3.3 (good), v3.4 (+) (bad)

d) regression patch, fixed

v3.3 (good), v3.4 (good)

e) stable regression patch

v3.3 (good), v3.3.1 (+) (bad), v3.4 (+) (bad)

e.1) stable regression patch, normal fix

v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (good), v3.4 (good)

e.2) stable regression patch, lost fix

v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (good), v3.4 (+) (bad)

As you can see, even in the worst-case scenarios, there's no
difference between (c) and (e.2). But what you are saying is that it
doesn't matter at which point the issue with the patch is found, (e.2)
has to be avoided *at all costs*, but you don't explain _why_. What is
so different between (c) and (e.2)?

And this is the worst-case scenario, I keep hearing people that this
has happened in the past, but I don' think so, I think what has
happened is:

f) stable patch fix, lost

v3.3 (bad), v3.3.1 (+) (good), v3.4 (bad)

That I can see happening, and the current rules ensure that would not
happen, but (e.2)? I yet have to see any evidence of this happening in
the past.

But lets be realistic; most likely the issue would be and fixed in
upstream (d), so it doesn't matter what happens in stable, the end
result would be the same (e.1). In fact in this particular patch
people found problems in v3.4-rc1, so all evidence points out that we
would have ended up in (e.1), not (e.2).

So, if we expand the possibilities in the current situation, we have:

0) v3.3 (good), v3.3.1 (good), v3.3.2 (good), v3.3.3 (good), v3.4 (+)
(bad), v3.4.1 (good)
1) v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (good), v3.3.3 (good), v3.4
(good), v3.4.1 (good)
2) v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (+) (bad), v3.3.3 (good),
v3.4 (good), v3.4.1 (good)
3) v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (good), v3.3.3 (good), v3.4
(+) (bad), v3.4.1 (good) #unlikely
4) v3.3 (good), v3.3.1 (+) (bad), v3.3.2 (+) (bad), v3.3.3 (+) (bad),
v3.4 (+) (bad), v3.4.1 (good) #unlikely

It looks like the patch is going both to upstream and stable (1),
which is ideal, but when faced with the option between (2) and (3),
you say (3) must absolutely be avoided even though it's basically the
same as (0), which is the norm for thousands of patches that don't get
back-ported to stable (and it's also unlikely to happen).

Why?

Plus, (1) (2) (3) (4) are already bad situations, and should be
avoided at all costs; patches to stable are not supposed to be
potentially dangerous, they are not meant be breaking things.

> Another point is that you don't want stable to merge, revert, merge again,
> revert again etc... This happened a little bit during 2.6.32 because some
> fixes were not really obvious. It's common for some fixes to have to be
> adapted for stable branches, and to have side effects, hence the review
> cycle. We need to limit these random issues as much as possible if we
> don't want users to lose trust in the stable branches. This is extremely
> important. So picking random fixes that have not been qualified by all
> interested parties in stable is inappropriate. Reverting without evaluating
> impacts is one form of picking a random fix.

Yeah, but that is not the case here, the options are clear; (a) go
back to a previous state where power management doesn't work
correctly, (b) stay in the current state where the system goes to a
completely unusable state.

> What you should have done would have been to reply to Greg saying "wait a
> minute, we still have an issue with patch XX, I'm trying to get it reverted
> in upstream and will send you the commit ID, it would be nice to have it in
> 3.3.2". It wastes less time for everyone and achieves the same result.

There's a lot of people affected by this issue, and a lot of noise.
Personally I didn't receive the revert patch, so I could not comment
on it. I think this patch should have been sent to LKML, but one
cannot expect everyone to do the perfect thing all the time.

> Once again, if you think that the stable branch you're using is not stable
> enough for you, pick another one. Greg maintains multiple branches so that
> everyone is satisfied. The risk of bugs over time probably looks like
> (cos(t)+1)/t. Find an older branch with a much smaller risk of regressions
> and be done with it.

I'm not sure I would want to use 'stable' anymore, because clearly,
the main goal doesn't seem to be *stability* as I thought. Apparently
it's supposed to be a testing ground for patches queued for the next
release.

> Last point, you should note that you're the only one here who doesn't
> understand the process. That doesn't make you a fool, but it should tell you
> that you probably need to think a bit further before telling people how they
> should work, especially when all other ones agree on the benefits of the
> process, including Arnd explaining that FreeBSD had been facing the exact
> same trouble and now applies the same process. It is not just a small band
> of nerds doing this for fun right here, but seems to be more generalized.

Ad populum.

The fact that I'm questioning the process doesn't mean I don't
understand it. But if you are not open to criticism, fine.

Cheers.

-- 
Felipe Contreras
