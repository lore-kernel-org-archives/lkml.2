Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2DHAxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 20:53:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2DHAxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 20:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120407211512.GC11295@thunk.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
 <20120407024941.GB11295@thunk.org> <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
 <20120407211512.GC11295@thunk.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Sat, 7 Apr 2012 17:52:53 -0700
X-Google-Sender-Auth: gwyghylkF22D6Ri2egZkNx3E-Ak
Message-ID: <CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: "Ted Ts'o" <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 2:15 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 06, 2012 at 08:01:36PM -0700, Luis R. Rodriguez wrote:
>> > I also really don't see how this helps License compliance folks.  If
>> > the BSD folks trying to figure out whether or not they can use some
>> > piece of code, "GPL-Compatible" is no more useful than as "Dual
>> > BSD/GPL".  In fact, Dual BSD/GPL might actually be more useful since
>> > at least to me it says it can be used under the BSD or GPL license,
>> > which is precisely what the BSD folks need.
>>
>> If we are OK with this thread serving as documentation for this then
>> so be it, but I still prefer for this to be clarified more. *I* am
>> comfortable with this but I know other vendors who did try to achieve
>> the same sharing had quite a bit of time trying to validate the
>> approach.
>
> I would rather think the obvious clarification would be reading the
> d*mn copyright headers.

I'm with you on this but experience proves some people still don't
understand how this is possible.

> That's going to have much more weight in a
> legal dispute in any case.  If the answer is that the Linux Foundation
> needs to have a bit more basic training about what a Dual License
> means in its license compliance services, maybe that's the right thing
> --- although if a lawyer doesn't understand how dual licenses work,
> I'd suggest that the company find a better lawyer....

>From the work with SFLC on ath5k a while ago we learned that dual
licensing BSD/GPL is legally equivalent to licensing under the BSD
license, dual licensing should be used when licensing a project / file
under incompatible licenses. Dual licensing BSD/GPL can also confuse
some folks, this was all clarified on SFLC's white paper on
maintaining permissive licensed files in a GPL project, which I linked
to in my patch:

http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html

So as a matter of fact the current scheme and practice of Dual BSD/GPL
just makes no sense. If this can be addressed as an item on the legal
tracks by the Linux Foundation -- then great, but I still think
clarifying this a bit more for general developers and companies even
when they are not involved with the Linux Foundation would help.

>> I rather speed help clarify this is a reasonable approach
>> and also avoid flamewars like the ones we faced when developers eons
>> ago though that we *had* to GPL the OpenBSD ar5k HAL when we ported it
>> to Linux for use in ath5k.
>
> So this is a different issue.  I assume you are referring to the fact
> that include/linux/license.h's license_is_gpl_compatible() doesn't
> have a pure BSD option?

Well, I am arguing that "Dual BSD/GPL" is a stupid practice that has
plagued the community and only has brought confusion. Its not needed
and if one wants to share with the BSD community one should simply use
the BSD license.

> If that's the issue, then lobby for adding
> the line:
>
> +       || strcmp(license, "BSD") == 0

I don't really want this, we have other of GPL-Compatible files,
recently for example I saw Android added
drivers/staging/android/ashmem.h under a "Dual GPL / Apache 2.0"
license. This is just for a file though.. but are we to keep extending
this list for every new module license that is GPL-Compatible? That
seems rather cumbersome.

> If you are really worried about people being upset that currently, you
> have to explicitly add a GPL license to BSD-licensed driver code
> before it gets imported into the kernel, and you are trying to
> sidestep the issue by adding a "GPL-Compatible" license (on the
> grounds that a BSD-only license qualifies as GPl-Compatible), let's
> have that debate openly, instead of trying to side-step it by adding
> "GPL-compatible" to include/linux/license.h and allowing BSD-only
> modules to use GPL-only symbols via a back door.

I think you are implying that I want BSD licensed modules to use
GPL-only symbols. That is not the case. There are two things to
consider here and I think its best to separate them -- runtime and
stand alone file licenses.

Stand alone files have their own copyright license in the Linux kernel
and we respect that license for contributions through the
Signed-off-by tag.

As for run time... I *personally* actually believe all Linux kernel
modules are GPL at runtime :D I'm not the one who argues that
proprietary modules can exist ;) I also in no way shape or form want
Linux kernel modules that are upstream to be modified and produce a
respective proprietary module or even BSD licensed module without
redistribution of the software.

I do believe though that files that are BSD licensed can and should be
used by the BSD family and even other proprietary OSes. Now this may
seem like I am side tracking quite a bit but I am going to mention a
few things given that I believe I should clarify my intent since it
seems you are questioning it. I *personally* have clarified I in fact
even want to kill all proprietary drivers for good [0], I even want
open firmware have released open firmware before [1]. Additionally
within the backport work I do I also ensure *all* symbols are
EXPORT_SYMBOL_GPL() which means no proprietary driver could ever take
advantage of that work. So no, *hell no*, I do not want proprietary
crap, nor abuse of GPL-only symbols by external drivers. All I want is
to help promote sharing of device drivers with the BSD family, and
this is in fact part of the strategy on killing proprietary drivers,
for good.

All this said though I think I see the main issue, from what I am
reading MODULE_LICENSE("Dual BSD/GPL") seems to address the module run
time license, in that case then all those declarations should just
simply be MODULE_LICENSE("GPL"), and a clarification of usage of the
files would be good. the "Dual BSD/GPL" practice is one that picked up
that assumed on needed to dual license files under GPL/BSD but in fact
if one wants to share the BSD license should simply be picked.

[0] https://events.linuxfoundation.org/events/collaboration-summit/rodriguez-chadd
[1] http://wireless.kernel.org/en/users/Drivers/ar9170.fw

  Luis
