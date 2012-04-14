Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2DNP37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:29:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58181 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2DNP35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120414094137.54a7f213@stein>
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
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120414094137.54a7f213@stein>
Date: Sat, 14 Apr 2012 18:29:54 +0300
Message-ID: <CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
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

On Sat, Apr 14, 2012 at 10:41 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Apr 14 Felipe Contreras wrote:
>> I already exemplified how they are very different, but here it goes
>> again. The patch "drm/i915: Add lock on drm_helper_resume_force_mode"
>> was just tagged in 3.3.2, if I had said yesterday "this patch breaks
>> things on my machine", then that patch would have been dropped for
>> 3.3.2 even though it's still on mainline--why? Because we know it's
>> broken, and broken patches are not supposed to land to stable. But
>> today, one day later, we have to wait until it's fixed in master
>> first. Why?
>>
>> What makes a patch droppable yesterday, but dependent on mainline today?
>
> Huh?
>
> Because "yesterday" was a review before stable release:
>  - A buggy mainline release exists.
>  - No buggy stable release exists.
> whereas "today" is after stable release:
>  - A buggy mainline release exists.
>  - A buggy stable release exists.

IOW; a tag makes undroppable.

But *why*? You say you *really* need to problem to fixed in mainline,
that's why it cannot be dropped, but that applies also to patches in
the queue *before* the tag is made, doesn't it? If you find a patch in
the stable review queue causes problems, why don't you leave it there?
You *really* need to problem fixed in mainline, don't you?

So yesterday the priority is stability > 'upstream first', but today
it's 'upstream first' > stability. Nobody has put forward an argument
for this shift in priorities--"a tag was made" is not argument.

> (The WLAN breakage wich is being talked about was reported after
> release, not during review, right?)

Yeah, this is a hypothetical thought experiment to demonstrate the
shift in priorities.

> [quote re-ordered]
>> Again, you can repeat the same thing as much as you want, it still
>> doesn't answer what I have asked.
>
> Yeah, sorry for that.  All the time I thought you asked why a *revert*
> which is applicable to mainline and stable first happens in stable.
>
> But your question was actually what the difference between
>  - dropping a patch from a queue of candidate patches versus
>  - adding a reverting patch to repair a defect from a previous release
> is.

Yes, that is one of my arguments.

> The former is still part of the decision whether a changeset which
> exists in mainline should be backported into stable.  Somebody initially
> thought it should be, but others should have a look too and amend that
> decision if need be.  Somebody reports that the change would introduce a
> regression.  Usually, this disqualifies a patch from being applied to
> stable right away, without further work having to be done in stable.
>
> "Drop a stable candidate before release" is a form of "decline a
> submission to stable", happening late in the preparations of a stable
> release.
>
> The latter is when damage was done; it is now about bug fixing.  This
> involves debugging of the regression, finding a right approach to
> fix it (e.g. revert), write + review + test + commit the fix, port the fix
> to all relevant other kernel branches, review + test + commit those ports
> too.

Really? So if the patch doesn't make it to stable you don't need to do
any of that? IOW; if the patch doesn't make it to stable, it's OK to
leave it broken for v3.4? There's 10000 patches in v3.4-rc* that are
all about bug fixing, they don't need to go into stable to be fixed,
do they? If a non-stable patch needs to be reverted in mainline, it
gets reverted in mainline, regardless of weather or not it made it to
stable or not.

So, the hypothetical patch that was dropped in the stable review queue
yesterday has to be fixed in mainline too, just like the hypothetical
patch that made it to stable and was found problematic today has to be
fixed in mainline.

Again, what makes a released patch undroppable? It's not the bug
fixing; weather or not it gets into stable, it still has to be fixed
in mainline.

> "Add a reverting fix" is a form of "add a fix".
>
> You are indeed pointing to a procedural flaw here.  In "add a fix" cases,
> stable release procedures ensure that if 3.3.3 included the revert, 3.4
> will include it to, by the Linus->Greg order of commiting patches. But in
> the "drop a candidate before release" case, Greg and the stable reviewers
> do not have a similarly fool-proof procedure to ensure that the next branch
> point will be free of the regression.  Now they need to watch closely that
> a fix gets into mainline ideally before the next branch point is going to
> be released.

I don't see the procedural flaw here. There's 10000 patches that never
go through the stable review process, and they don't need to. Somehow
v3.4 will be relatively OK. So the dropped patches from the stable
review queue will just receive the same treatment as any other patch.

Just by going through the stable review process the patch already
received more eyes to make the bugs more shallow. There might be a lot
of trees out there where people pick patches from mainline, and they
don't *need* to follow the "upstream first" rule, by reviewing the
patch, and maybe even testing it, and then reporting the problem, they
are helping getting it fixed for v3.4.

You don't *need* to keep the patch in the stable review queue, you
don't *need* to make a stable release with it in order to ensure that
it will fixed in mainline, the information about the patch problems is
not lost.

Seems to me you are abusing the 'stable' branch as a bug tracking
system for certain patches for the next release.

> So there is indeed a difficulty involved with dropping patches from the
> candidate queue.  Fortunately, it is not necessary to subject post-release
> reverts to the same difficulty.

It's the other way around.

-- 
Felipe Contreras
