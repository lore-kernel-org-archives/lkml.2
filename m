Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1C3Afa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:35:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab1C3Af3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:35:29 -0400
MIME-Version: 1.0
In-Reply-To: <201103292143.12777.rjw@sisk.pl>
References: <201103292143.12777.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Mar 2011 17:34:42 -0700
Message-ID: <AANLkTi=nfzR=EQNaiPL_g=V_hfMY_61D7oKoPKAK=ETO@mail.gmail.com>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Please pull a power management Kconfig modification for 2.6.39 from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

I absolutely detest this.

The way you changed the Kconfig file makes no sense what-so-ever, and
now the Kconfig options are exactly the wrong way around.

We should NOT ask users "do you want the hibernation interface?".
That's just a totally idiotic question to ask, doubly so when it's not
what we ask for the STR "interfaces" either.

>From a user standpoint, the fact that Xen may want to use the
low-level code for hibernation should NOT mean that the user should be
asked about some interface. That's not what they care about, and it's
not what they _should_ care about.

They want hibernation support. You shouldn't ask whether they want the
"interface". That's just crazy.

Now, I realize that you did it the way you did to make the diff
smaller, but I really don't think that's a good reason to make the
config options be the wrong way around, and ask questions (and show a
config option name) of users that are illogical and doesn't match the
other related config options they see. That's the wrong choice to make
just to keep a patch smaller.

I could imagine using just "CONFIG_HIBERNATE" instead of your
suggested "CONFIG_HIBERNATION_INTERFACE", as that would at least match
the current CONFIG_SUSPEND that we ask users about - ie at least the
config option would not be visibly strange to the user. Still, I think
that would be prone to confusion at a code level ("What's the
difference between CONFIG_HIBERNATE and CONFIG_HIBERNATION?"), so I
think that's a bad idea too.

So I'd suggest just making the patch bigger, and make the new
(non-asked) config option be called CONFIG_HIBERNATION_SUPPORT or
something like that. Make Xen select that option instead.

(I also think that your patch was actually wrong. Why does the x86
code to actually save/restore registers depend on that "INTERFACE"
thing, but not on any other architecture? In general, I just think the
thing is confusing. Maybe it's confusing exactly because the config
option name doesn't actually describe _what_ part of the hibernation
code it is all about?)

                     Linus
