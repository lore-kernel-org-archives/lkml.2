Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2DMWiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:38:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64120 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2DMWiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120413154216.476a02ac@stein>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
Date: Sat, 14 Apr 2012 01:38:15 +0300
Message-ID: <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 4:42 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Apr 13 Felipe Contreras wrote:
>> On Fri, Apr 13, 2012 at 11:57 AM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>> > On Apr 12 Felipe Contreras wrote:
>> >> But this is exactly the opposite; the patch that broke things is in
>> >> the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
>> >> also on a later upstream, which is also broken.
>> >            ^^^^^
>> > No, upstream /earlier/ than 3.3.1 contains the defect.
>>
>> Time is not relevant for the point being made, but fine:
>
> Time of occurrence of a regression in mainline and stable is indeed
> irrelevant, as there can only be two kinds of regressions in stable:

No. First of all, all regressions will happen first on mainline, and
then on stable. Maybe it's possible that a 3.3.x stable release
happens before a 3.4-rcx release that contains the patch, but which is
tagged first is irrelevant.

My point was that the patch is in 3.3.1, and 3.4-rc1, but not on 3.3.
The timing of these releases is irrelevant.

>  A) First the regression was introduced into mainline, and accidentally it
>     was carried over from there into stable.
>
>  B) The regression only happened in stable because a backport from
>     mainline to stable went wrong, e.g. a prerequisite to the backport
>     was forgotten to be backported beforehand.
>
> AFAIU we are talking about a regression of type A.
>
> It seems you are arguing that stable candidate patches which fix
> regressions of type A should be treated differently from other stable
> candidate patches.

No, I'm not arguing that.

I am arguing that *any* patch in stable should be droppable, even
after it has been tagged.

>> But this is exactly the opposite; the patch that broke things is in
>> the 'release branch' (3.3.1); it's not in the upstream release from
>> where stable began (3.3). Sure, it's also on upstream, which is also
>> broken.
>
> (To what is this the opposite?)
>
> So the defect is present in two kernel branches:  Linus'es and Greg's.
> The fix needs eventually go into both branches.  For reasons which have
> been enumerated many times in this thread already, Greg takes the fix from
> Linus, not the other way around.

You can enumerate the reasons as many times as you want, that doesn't
make them any more valid.

I explain below how you are providing reasons for a different situation.

> If you do not like to wait for Linus and Greg, you simply have to derive
> an own kernel which additionally contains your preferred fixes.

Yes, because clearly everybody thinks the process is perfect, and
criticizing it is heresy.

> The reasons for the Linus->Greg order of maintaining the stable series 100%
> apply to fixes for type A regressions as well.

Why? Because it does. IOW; dogma.

>> So you are saying that:
>>
>> a) v3.3.1 (bad), v3.3.2 (bad), v3.4 (good)
>> b) v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)
>> c) v3.3.1 (bad), v3.3.2 (good), v3.4 (good)
> [...]
>
> Not exactly.
>
> I and others are saying that procedures must ensure that if e.g. v3.3.3
> was "good", then v3.4 and hence v3.4.y must be "good" too.  ("Good" here
> meaning "contains fix xyzabc".)

That's exactly what I said: if you are saying v3.4 *must* be good, you
are saying that b) *must* be avoided at all costs. Even if we end up
in a).

> Furthermore I was saying that due to the time-based instead of
> feature-based release schedule, the procedure which gives above guarantee
> is a time-based procedure:  Greg takes fixes *if* they were published by
> Linus == *after* they were published by Linus.
>
> I add:  The second reason for this procedure is that v3.x.y is a successor
> of v3.x but not of v3.x-1.y.  Forward-porting from v3.x-1.y to v3.x.y is
> not in scope of the stable series.  The reasons why there is no
> forward-porting done in stable series, again, have been mentioned several
> times in this thread.

Again, you can repeat the same thing as much as you want, it still
doesn't answer what I have asked.

>> a) v3.3.1 (bad), v3.3.2 (bad), v3.4 (good)
>> b) v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)
>> c) v3.3.1 (bad), v3.3.2 (good), v3.4 (good)

Why is b) so much worst than c)?
Where is the evidence of that happening ever?

The truth is that b) is very unlikely to happen anyway, but you still
prefer a) to c), just to make sure that b) never *ever* happens, no
matter how unlikely.

The "reasons" explained are for an entirely different situation:

a') v3.3 (bad), v3.3.1 (bad), v3.3.2 (bad), v3.4 (good)
b') v3.3 (bad), v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)
c') v3.3 (bad), v3.3.1 (bad), v3.3.2 (good), v3.4 (good)

You are providing the obvious answer, but to a question nobody asked.
I'm not talking about a', b', c', I'm talking about a, b, c, they are
*very* different.

I already exemplified how they are very different, but here it goes
again. The patch "drm/i915: Add lock on drm_helper_resume_force_mode"
was just tagged in 3.3.2, if I had said yesterday "this patch breaks
things on my machine", then that patch would have been dropped for
3.3.2 even though it's still on mainline--why? Because we know it's
broken, and broken patches are not supposed to land to stable. But
today, one day later, we have to wait until it's fixed in master
first. Why?

What makes a patch droppable yesterday, but dependent on mainline today?

This of course, has *not* been explained.

-- 
Felipe Contreras
