Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0GLRg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:36:29 -0400
Received: from 1wt.eu ([62.212.114.60]:39208 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab0GLRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:36:27 -0400
Date: Mon, 12 Jul 2010 19:36:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100712173625.GE6953@1wt.eu>
References: <201007110918.42120.Martin@lichtvoll.de> <201007111651.42963.Martin@lichtvoll.de> <20100711172252.GA3379@1wt.eu> <201007121744.05844.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007121744.05844.Martin@lichtvoll.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Mon, Jul 12, 2010 at 05:43:56PM +0200, Martin Steigerwald wrote:
> > Among the things he explained, I remember that one of primary concern
> > was the inability to slow down development. I mean, if he waits 2 more
> > weeks for things to stabilize, then there will be two more weeks of
> > crap^H^H^H^Hdevelopment merged in next merge window, so in fact this
> > will just shift dates and not quality.
> 
> Would it make that much of a difference? Linus could still say no to 
> obvious crap, couldn't he?

It's not "obvious" crap, it's that the developers will simply have
advanced two more weeks ahead of their schedule, so their merge will
be larger as it will contain some parts that ought to be in next release
should the kernel be release earlier. And it will not be possible to
delay merging because among them there's always the killer feature
everybody wants. This is the reason for the strict merge window.

> > There are also some regressions that get merged with every pre-release.
> > Thus, assuming he would wait for one more pre-release to merge the
> > fixes you spotted, 2 or 3 more would appear, so there's a point where
> > it must be decided when to release.
> 
> Some sort of classifying bugs could help here I think. Something that 
> helps Linus to decide whether it is worth to do another release candidate 
> round or not.

Maybe sometimes that could indeed help, but that must not be done too
often, otherwise releases slip and patches get even bigger.

(...)
> I do 
> think that the Radeon KMS does not work after resume bug (#15969) does 
> qualify since it causes loss of data handled by the current X session(s) - 
> sure I normally save my stuff before hibernating, but... And it actually 
> had a patch that has been tested!

Then the problem should be checked on this side : why this patch didn't get
merged in time ? Maybe the maintainer needed more time to recheck it, maybe
he was on holiday, maybe he was ill on the wrong day, maybe he had already
merged tons of fixes and preferred to get this one for next time, ... But
even if there are fixes pending, this should not be a reason to *delay*
releases, otherwise we go back to the problem above, with also the problem
of new regressions reported with tested fixes available...

(...)
> Maybe an approach would be to dynamically generate the list from all bug 
> reports marked for 2.6.34 versions and have it posted to kernel mailing 
> list after every rc. This way bug #15969 would at least have been in the 
> list of known regressions.

In fact, Rafael regularly emits this list, and the respective maintainers
are informed. That means to me that there's little hope that you'll get the
maintainers to merge and send a fix they did not manage to do. What *could*
be improved though would be if Linus publically states the deadline for last
fixes, as Greg does with the stable branch. That can give hopes to some of
them to finish a little merge work in time instead of considering it's too
late.

> Bugzilla severity and priority fields or something similar could be used to 
> set the importance of a bug report and the regression list could be sorted 
> by importance. One important criterion also would be whether someone could 
> confirm it, reproduce it. Even when I reported those desktop freezes, 
> unless someone confirmed them it might just happen for me. Well a "confirm" 
> or vote button might be good, so that the amount of confirmations could be 
> counted. 

Maybe that could help, but it will not necessarily be the best solution. Keep
in mind that some issues may be more important but still reported only by one
user. If one reports FS corruption, you certainly don't want to wait for a few
other ones to confirm the bug for instance. Security issues don't need counting
either.

(...)
> > It's not really advisable to call dot-0 releases "unstable" because
> > it will only result in shifting the adoption point between the user
> > classes above. We need to have enthousiasts who proudly say "hey
> > look, dot-0 and it's already rock solid". We've all seen some of them
> > and they're the ones who help reporting issues that get fixed in the
> > next stable release.
> 
> I do think the claim should be honest. "stable" IMHO is not, at least from 
> a user's point of view. "unstable" isn't either, cause a dot-0 kernel is 
> not guarenteed to be unstable ;). So I agree with the major release kernel 
> approach from Rafael.

But it's also the starting point of the stable branch. And what about the
-stable branch itself. Sometimes an awful bug will prevent the kernel from
even booting for most users, and a single patch will be present in the
stable branch to fix this early. Same if a major security issue gets
discovered at the time of release, it's possible that the stable branch
only contains one patch. That does not qualify it for more stable than
the main branch either, eventhough it's called "stable". Maybe we should
indicate on www.kernel.org that a new release has generally received
little testing but should be good enough for experienced users to test
it, and that stable releases before .3-.4 are not recommended for general
use.

> But beyond that, I do think its worth thinking about ways to improve the 
> process of ensuring as much stability as sensibly possible. A dot-0 kernel 
> won't be error-free - but I find just claiming the current process as "the 
> best we can have" not actually satisfying. And I do think it can be 
> improved upon. I do not do kernel development, but I am willing to help 
> with collecting information about the current state of the kernel, help 
> with bug triaging as good as I can and manage to take time. I do have some 
> experience with quality management as I coordinated the betatest of some 
> AmigaOS versions,  but then this has been in a closed group. Here its a 
> different scale and I believe it needs somewhat different approaches.

In fact, I think we're at a point where the development process scales
linearly with every brain and every pair of eyeballs. There are two
orthogonal axes to scale, one on the quality and one on the quantity.
Both are required, but the time spent on one is not spent on the other
one. Customers want quantity (features) and expect implicit quality.
It is possible for some people to bring a lot of added value, a lot
more than they would through their share of brain time on code. This is
the case for Rafael and Greg who noticeably enhance quality, but it's
not limited to them too. Code reviews, bug reviews, -next branch, etc...
are all geared towards quality. But one thing is sure, there are far
less people working on quality than there are working on features, so I
think that if you want to help, there is possibly a way to noticeably
improve quality with one more guy there, though you have to find how
to efficiently spend that time !

Regards,
Willy

