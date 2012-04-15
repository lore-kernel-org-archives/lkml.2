Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2DOGvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:51:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57281 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2DOGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:51:31 -0400
Date: Sun, 15 Apr 2012 08:51:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120415065124.GC29563@gmail.com>
References: <20120412144626.GA14868@kroah.com>
 <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
 <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
 <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
 <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
 <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
 <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
 <20120414104733.GA4871@gmail.com>
 <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Sat, Apr 14, 2012 at 1:47 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >> On Fri, Apr 13, 2012 at 1:07 AM, Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >> > On Thu, Apr 12, 2012 at 3:04 PM, Felipe Contreras
> >> > <felipe.contreras@gmail.com> wrote:
> >> >>
> >> >> Sure, but removing that patch from the stable tree is not
> >> >> going the change that information; we already know the
> >> >> patch is wrong.
> >> >
> >> > .. and we wait until it has been fixed in mainline so that
> >> > we *know* that information doesn't get lost.
> >>
> >> So why don't we pick potentially dangerous patches that might
> >> benefit from some testing, put them in 'stable', and if there
> >> are problems, make sure they get fixed in upstream first?
> >>
> >> Or for that matter totally broken patches we want to make sure
> >> they get fixed in upstream.
> >>
> >> Because the priority of the 'stable' tree is *stability*. Is
> >> it not?
> >>
> >> But what you are saying is: *before* the final review, even a
> >> hint that the patch might cause problems is reason enough to
> >> drop it from stable, but *after* the review, if we know the
> >> patch is totally broken, then it's the opposite; we really
> >> want it in.
> >
> > What you don't seem to understand is that there are good reasons
> > why we first fix bugs upstream, then in -stable. Greg explained
> > it to you, Linus explained it to you and so did many others.
> >
> > Having an order of patches *necessarily* means that the
> > development tree will get fixes sooner than the stable tree. In
> > other words, this *necessarily* means that the stable tree - and
> > its users - will have to wait a little bit more to have the fix.
> > In the worst-case this 'have to wait a little bit longer' might
> > span the time between two minor stable kernel releases.
> >
> > You seem to equate this 'have to wait a little bit longer to get
> > the fix' property of the maintenance model with 'we don't care
> > about stable tree users' - that claim is obviously idiotic and
> > most of your arguments in this thread are idiotic as well.
> 
> This is a straw man again. Again; we are not talking about 
> fixes in 'stable' that don't exist in mainline, we are talking 
> about reverting patches from 'stable' that are not part of the 
> upstream release from where the 'stable' branch was forked.

You are misunderstanding the Linux kernel development process 
again:

> You are avoiding the argument you replying to; yesterday a 
> patch was droppable from the stable review queue, but today, 
> after the release, now we *need* it to stay there until it's 
> fixed in the mainline. What changed?

What changed: the stable kernel was released and a new cycle 
started. If something is broken in -stable it needs to be 
reverted upstream. Full stop.

There is a minor engineering process that if a -stable commit 
does not even apply or does not even boot on Greg's box or on 
the handful of boxes that test stable release candidates then it 
obviously cannot become part of the -stable queue. That kind of 
very short term, memory-less integration testing should not be 
confused with the much broader, state-ful, Git commit backed 
testing that the upstream kernel gets.

There's a new stable cycle every 7 days on average, there's a 
new upstream kernel every 7 days on average, and there's very 
good reasons for the stable queue to be memory-less and to not 
do your 'drop a patch from the previous stable version but don't 
bother dropping it from upstream first' kind of messy operation 
on it.

> What makes a patch droppable yesterday, but dependent on 
> mainline today?

Time and version release engineering: once a stable kernel is 
released any temporary integration testing results are flushed - 
the upstream kernel is where we maintain the information of 
which patch is broken and which not.

This memory-less process, amongst other things, helps the *next* 
major stable kernel become more robust, as it removes the 
possibility for version skew between stable and upstream.

If you want a revert you either need to report your problem fast 
enough to be caught in -stable integration testing, or you need 
to work with upstream to push the fix through properly.

People explained this to you, again and again, you refused to 
listen, repeatedly, again and again. There does not appear to be 
any rational set of arguments that will make you admit that you 
were wrong about this.

Anyway, in this discussion you have demonstrated it again why 
you are one of the very few commenters I had to permanently 
block on G+ ...

Thanks,

	Ingo
