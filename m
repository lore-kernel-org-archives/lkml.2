Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0KSUZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:25:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61935 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0KSUZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i2vf72w5Ap1lChgJHd7EezhAH/RNWZGZAc8571CtHyLUq9ku0CsRbcjGnDYP9xnJLL
         tU3rgxemup3wIhsIaD8mmaDnu3ayBw8FZNeecxMNOsmDw/lSsc8ZYLJqbgEPVvb/jtMf
         IbnXxSvVagUdaDKW9lQaA8CnV/+G3lLI6VnfM=
MIME-Version: 1.0
In-Reply-To: <AANLkTikiZRHKRrosXgY5TEYODN_D_JLJ0XXWSb9g1zPQ@mail.gmail.com>
References: <alpine.DEB.2.00.1011190118480.8681@skynet.skynet.ie>
	<5b55a1$in84he@fmsmga002.fm.intel.com>
	<AANLkTikiZRHKRrosXgY5TEYODN_D_JLJ0XXWSb9g1zPQ@mail.gmail.com>
Date: Sat, 20 Nov 2010 06:24:59 +1000
Message-ID: <AANLkTinTt3uodt83VV89wi9RkATF1WTqFdauYaBz7exE@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 5:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 19, 2010 at 2:02 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>
>> Note it also contains a couple of fluff fallout patches from the recent
>> drm-fixes rebase. (I thought it would be wise to include any core drm
>> changes in our testing before sending the request...)
>
> F*%^ me, why does drm always have to be so messy?

please just reject Chris's pull, I've asked he don't send you pulls
directly, and he seems to have missed the memo in this case, if he'd
sent this to me I'd have pushed back.

the reason the tree got rebased is that i did a pull from Ben and I
screwed up, I didn't check his history and he'd based his tree on a
branch for -next not for you, and some commits
in there were also strangely renumbered, so I pushed back when I
noticed (which was after I pushed out drm-fixes). I should have
noticed before I pushed it out but I didn't mea-culpa.

I'll talk to Chris about where he bases his trees, generally I ask
they based their trees on your tree or the last thing I sent you,
unless we have some conflicting reasons which after -rc1 should never
be the case.

> And yeah, it's ugly. And if that patch introduces a regression (which
> is entirely possible, it's not like it's small and trivial and
> obviously correct) it will just make bisection harder, and add
> confusion.  And it's totally pointless. It only adds pain. And it
> makes the history harder to read.
>
> Why did the Intel drm tree merge a patch that had _nothing_
> what-so-ever to do with Intel DRM? WHY?
>
> And why did the drm tree rebase a tree that had obviously been public
> and pulled from? WHY? Why did you make it public before it was ready?
> And/or why was it so ugly that it needed to rebase it? Why do these
> things keep happening?

I can't remember the last time we had a crazy rebase situation in the drm,
so its been a relatively while. I would have thought pushing a tree
with reverts would have made for uglier history than you just refusing
Chris's tree,
and letting me deal with it in time.

>
> What's wrong with the whole drm crowd? Even if it isn't rebasing, why
> is drivers/gpu/drm always so very visible in the later -rc trees?
>
> I'm asking "why", but what I really want you guys to do is to ask
> _yourself_ why. And ask "Why is that? What am I doing wrong that this
> keeps happening?"
>
> Really. Spend some time pondering. What the hell just happened, and
> why did it happen, and how can you guys stop doing it?
>
> Chris: stop pulling in random crap in your tree. Do _your_ development
> in your tree. Nothing else.
>
> And Dave, I have no idea why those two commits were rebased. They seem
> identical in the tree that Chris had pulled. They have the same base
> commit. What was the point?

Yeah I screwed up there, after I screwed up Ben's pull I nuked everything and
rebuilt, I should have just gone back before Ben's commit and left
those two commits intact.

As for why drm ends up with a lot of churn after rc1?

radeon 90,000 LOC (417 devices in pci table - not to mention variants
in set of encoder/connectors BIOS tables per card)
nouveau 45,148 LOC (can't tell how many devices).
intel 41,651 LOC (32 pciids, but also variants in connectors is massive)

these are just the drivers, I don't think a 1000 line modified set of
changes across 200,000 lines of code
is major, especially as its not in the core DRM, I'm guessing that
wireless is probably the only other driver
base in the same region of LOC per driver.

Like maybe we need more testing for code pre -rc1 but I think we just
end up with the same problem as when people tell you to merge less, it
just gets stacked up for the next window. People test stuff on the
hardware they have, its not really until it hits your tree or even
distros that we find it doesn't work on some other variant of the
hardware. We've had bugs in laptops with identical names and chipsets,
but slightly different panels, also people plug a wide range of
monitors into graphics cards, you'd think again these would be
standard but a small change in the EDID parser may break some monitor
or HDMI tv that has a 5c rom in it with 90% garbage. Generally merging
stuff in -rc1 means we have to fix it after that point, testing the
fixes don't regress anything is just as much pain as testing the code
in the first place.

Though I've been asking myself the same question lately why we have so
much change, it was one of the reasons I asked Chris to starting
sending things via me so I could get more visibility into what is
changing after rc1, for radeon I've been asking Alex about each fix as
it goes past and I'm generally happy they fix problems people are
actually seeing, and Chris seems to be showing a lot more constraint
than Eric used to. nouveau I'm not as pushed to constrain but I do
generally pushed back on Ben to rework stuff where it a big change
doesn't make sense.

I also wonder if its partly psychological on your part, if I sent a
number of smaller pull requests rather than queuing up things would
you notice the line count less? If Chris sends things direct to you
instead of me merging them and sending do you see a combined drm line
count or do you just notice on a pull by pull basis etc.

Like I know the goal here is to create the perfect kernel for hardware
Linus owns, but I'd like to be able to fix bugs urgently on hardware
users have that aren't so privileged, think of it as some sort of
outreach program.

Dave.
