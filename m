Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2DMFe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 01:34:57 -0400
Received: from 1wt.eu ([62.212.114.60]:65096 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2DMFez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 01:34:55 -0400
Date: Fri, 13 Apr 2012 07:34:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        gregkh@linuxfoundation.org, lists@uece.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com,
        ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120413053416.GC12807@1wt.eu>
References: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com> <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com> <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com> <20120412.181256.1267592727086214582.davem@davemloft.net> <CAMP44s26eJ6mFHt=C+_AJCkGiDAcMq1O1HsCXPZd5-FRYkZoXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s26eJ6mFHt=C+_AJCkGiDAcMq1O1HsCXPZd5-FRYkZoXQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:58:10AM +0300, Felipe Contreras wrote:
> On Fri, Apr 13, 2012 at 1:12 AM, David Miller <davem@davemloft.net> wrote:
> > From: Felipe Contreras <felipe.contreras@gmail.com>
> > Date: Fri, 13 Apr 2012 01:04:42 +0300
> >
> >> Wrong is wrong, before or after the 3.3.1 tag, this patch is not
> >> 'stable' material, and removing it does not affect upstream at all.
> >
> > What you don't understand is that bug fixes will get lost if you only
> > fix them in -stable, it doesn't matter HOW THEY GOT into -stable.
> 
> Let's suppose that c1afdaf was never back-ported from v3.4-rc1, how
> would you have fond out there was an issue with it? There's 10000
> patches in v3.4-rc2, how do you expect to find issues in them?
> 
> People found out this issue on v3.4-rc1, so the fix would not have
> been lost, but lets assume it would, v3.3.1 had the issue, the patch
> as reverted in v3.3.2, and v3.4 still had the issue. So what? There's
> already 10000 patches that would never make it to 3.3.x, and many will
> have issues, which is why there would be v3.4.x.
> 
> > In fact IT HAS FUCKING HAPPENED that we didn't fix something upstream
> > that got fixed in -stable a time long ago when we didn't have the
> > policy we're using now which you're going so unreasonably ape-shit
> > about.
> 
> I see how a *fix* on stable could get lost, but this is not a fix.

Felipe, you don't seem to get it : there are many bugs in each new release.
Given the number of fixes Greg merges into a longterm branch, I'd say that
there are around 1500 bugs waiting to be discovered and fixed in a new
release. Does this mean we need to fix them all at once ? No, because we
don't know about them yet.

The process you're criticizing consists in ensuring that once a bug is known,
it gets fixed in mainline so that it never appears there again. The way the
bug is discovered doesn't matter, even if it's discovered that a fix caused
the bug and that it must be reverted. The fact is mainline is buggy and we
know this because stable is too. So mainline must be fixed first. This
process works because stable users are pressuring developers to push their
fixes to Linus in order to get them. What happened with this bug prooved
the process is working fine.

Another point is that you don't want stable to merge, revert, merge again,
revert again etc... This happened a little bit during 2.6.32 because some
fixes were not really obvious. It's common for some fixes to have to be
adapted for stable branches, and to have side effects, hence the review
cycle. We need to limit these random issues as much as possible if we
don't want users to lose trust in the stable branches. This is extremely
important. So picking random fixes that have not been qualified by all
interested parties in stable is inappropriate. Reverting without evaluating
impacts is one form of picking a random fix.

What you should have done would have been to reply to Greg saying "wait a
minute, we still have an issue with patch XX, I'm trying to get it reverted
in upstream and will send you the commit ID, it would be nice to have it in
3.3.2". It wastes less time for everyone and achieves the same result.

Once again, if you think that the stable branch you're using is not stable
enough for you, pick another one. Greg maintains multiple branches so that
everyone is satisfied. The risk of bugs over time probably looks like
(cos(t)+1)/t. Find an older branch with a much smaller risk of regressions
and be done with it.

Last point, you should note that you're the only one here who doesn't
understand the process. That doesn't make you a fool, but it should tell you
that you probably need to think a bit further before telling people how they
should work, especially when all other ones agree on the benefits of the
process, including Arnd explaining that FreeBSD had been facing the exact
same trouble and now applies the same process. It is not just a small band
of nerds doing this for fun right here, but seems to be more generalized.

Regards
Willy

