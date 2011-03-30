Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab1C3UrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:47:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1C3UrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:47:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
Date: Wed, 30 Mar 2011 22:47:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
References: <201103292143.12777.rjw@sisk.pl> <AANLkTi=nfzR=EQNaiPL_g=V_hfMY_61D7oKoPKAK=ETO@mail.gmail.com>
In-Reply-To: <AANLkTi=nfzR=EQNaiPL_g=V_hfMY_61D7oKoPKAK=ETO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302247.16339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 30, 2011, Linus Torvalds wrote:
> On Tue, Mar 29, 2011 at 12:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Please pull a power management Kconfig modification for 2.6.39 from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus
> 
> I absolutely detest this.
> 
> The way you changed the Kconfig file makes no sense what-so-ever, and
> now the Kconfig options are exactly the wrong way around.
> 
> We should NOT ask users "do you want the hibernation interface?".
> That's just a totally idiotic question to ask, doubly so when it's not
> what we ask for the STR "interfaces" either.
> 
> From a user standpoint, the fact that Xen may want to use the
> low-level code for hibernation should NOT mean that the user should be
> asked about some interface. That's not what they care about, and it's
> not what they _should_ care about.
> 
> They want hibernation support. You shouldn't ask whether they want the
> "interface". That's just crazy.
> 
> Now, I realize that you did it the way you did to make the diff
> smaller, but I really don't think that's a good reason to make the
> config options be the wrong way around, and ask questions (and show a
> config option name) of users that are illogical and doesn't match the
> other related config options they see. That's the wrong choice to make
> just to keep a patch smaller.

Well, otherwise I'd have to change CONFIG_HIBERNATION to something else
throughout the tree and then add CONFIG_HIBERNATION as a user-visible option.
Perhaps that would be better from the user's viewpoint, but the confusion would
be still there.

> I could imagine using just "CONFIG_HIBERNATE" instead of your
> suggested "CONFIG_HIBERNATION_INTERFACE", as that would at least match
> the current CONFIG_SUSPEND that we ask users about - ie at least the
> config option would not be visibly strange to the user. Still, I think
> that would be prone to confusion at a code level ("What's the
> difference between CONFIG_HIBERNATE and CONFIG_HIBERNATION?"), so I
> think that's a bad idea too.

Exactly.

> So I'd suggest just making the patch bigger, and make the new
> (non-asked) config option be called CONFIG_HIBERNATION_SUPPORT or
> something like that. Make Xen select that option instead.
> 
> (I also think that your patch was actually wrong. Why does the x86
> code to actually save/restore registers depend on that "INTERFACE"
> thing, but not on any other architecture? In general, I just think the
> thing is confusing. Maybe it's confusing exactly because the config
> option name doesn't actually describe _what_ part of the hibernation
> code it is all about?)

It is confusing, because Xen wanted to use hibernate callbacks without
supporting hibernation itself and then realized it should rathern not tell
user space that hibernation was supported.  Kind of the other way around.

Now, I agree, to the users it would be _less_ confusing to rename
CONFIG_HIBERNATION everywhere to eg. CONFIG_HIBERNATE_CALLBACKS and then
change every instance of CONFIG_HIBERNATE_CALLBACKS that's not about callbacks
to CONFIG_HIBERNATE (or CONFIG_HIBERNATION again), but that's going to
be confusing to every maintainer of the affected code (which is the majority
of architectures in the tree).  I simply wasn't quite sure which one to
choose, so I took an easier path.  If you want the more complicated one, then
so be it.

Thanks,
Rafael
