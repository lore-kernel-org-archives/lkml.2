Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2CZVFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:05:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:39638 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2CZVF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:05:28 -0400
Message-ID: <1332795910.2882.34.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Tue, 27 Mar 2012 08:05:10 +1100
In-Reply-To: <4F703F5E.8030700@redhat.com>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
	 <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
	 <4F6EEEC1.4030608@redhat.com> <1332708684.2882.24.camel@pasglop>
	 <4F703F5E.8030700@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 12:05 +0200, Avi Kivity wrote:

> Say a fix comes in which needs to be mainlined during -rc.  So I put it
> in some other branch, to be sent off to Linus in a few days after
> maturing a little.  Meanwhile developers see an incomplete tree, since
> that patch is not in it.
> 
> Once Linus pulls, I can merge it back (or even before, if I'm reasonably
> certain it's not going to change), but it leaves a history of unneeded
> merges.  Or we can do throwaway merges like tip.git.

So to give an example, take powerpc. There's two branches, next and
merge. After the merge window, at rc1, they are basically empty.

Developers are encouraged to work on top of Linus upstream. If they
depend on each other they are free to pull each other stuff in, as long
as they avoid rebasing or deal with each other when that is done.

At later rc's (it should be as soon as rc1/rc2 but I trend to be a bit
late there) I open powerpc-next where I start putting stuff that's
intended for the next merge window. This is virtually upstream, this
branch doesn't get rebased.

So developers can fork of it if they wish to, or merge it into their
branch if they need some of the new work, there's really no big deal
with a few spurrious merges if there's a good reason for that, git is
good at it and it's pretty harmless.

Every now and then, I have fixes that I want to send Linus during -rc,
in which case I put them in a "powerpc-merge" branch. This is very short
lived, the fixes have generally been on the list/patchwork already, and
except maybe around rc1, have to be simple enough to be fairly low risk,
so they don't need that much "maturation" (besides it's not like anybody
tests "merge" anyways). So I put things in there, run it through my
automated build tests, do a few runtime tests and send them to Linus,
sometimes even the same day, though the patches themselves will usually
have been on the list & patchwork for a few days.

Now those patches don't absolutely need to be in "next". If they fix
something nasty enough or potentially conflicting with work in progress,
then I can just pull Linus back into next after he merges or even pull
"merge" into "next" if I don't want to wait for Linus.

Another option, is to actually cherry pick some of those patches and
apply them to both next and merge. This is perfectly fine, git will
resolve things 99% of the time and at worst it's going to be a bit of
context fixup in the final merge which is easy to deal with.

Basically that means that I have -0- history fight after a merge window.
My trees essentially all fast-forward to Linus as soon as he has pulled.

My throw-away test branch is seldomly used, mostly if there's stuff that
I want beaten up a bit more than usual, in which case I ask folks around
to give it a go and put it up there.

Cheers,
Ben.


