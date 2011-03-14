Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1CNLCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:02:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42906 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1CNLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=ukEP+ThmHyOJwBQ2gtCLinvUmDofhqYhhILOSEEt7/cRo15qEk/BU3M8CogC+CvAUz
         tcHMJJprSj131y3TRA1HKFUx03n/+xhZT2/hOE2MIQ3YyjJXa5/4N4FHFefsZ5ZIF5VC
         xJyAnMK7HeaKV/EW8SD9W8NofyUFmBZa+mVLM=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 14 Mar 2011 12:02:48 +0100
Message-ID: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Alan Modra <amodra@bigpond.net.au>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[QUOTE]
(H.J. Lu, did you drop me from the Cc: line?)

* Jan Beulich <JBeulich@novell.com> wrote:

> >> Please make it so that it'll be a warning by default, and an error
> >> upon programmer request. Otherwise, for the very purpose of
> >
> > I disagree. It should be error by default since the input is bogus,
> > Otherwise, those assembly bugs, benign or not, may not get
> > fixed.
> >
> >> bisection, it won't help much as you would have to override
> >> compiler/assembler flags during that process.
> >>
> >
> > They can use a wrapper to pass --size-check=warning to
> > assembler.  I think it is a small price to pay for those mistakes.
>
> "Small" being relative here - it could be dozens if not hundreds of
> people having to learn that this is necessary, many of them
> possibly rather unfamiliar with gas and its command line options.
>
> Also, using a wrapper gets further complicated by the fact that
> you may have to pass an extra -B to the compiler (not everyone
> has full control over the file system of all the machines used to
> do development), making sure this doesn't have any other
> unwanted side effects.

Correct. In reality if the kernel does not build or boot then most
people just wont
continue with the bisection. So this change actively degrades
debuggability, for no
good reason.

The thing is, it is absolutely, breath-takingy incompetent for the new binutils
version to break the Linux kernel build for 4 years of Linux kernel history
retroactively (130,000 commits), just to 'warn' about a size bug in a few debug
symbols that has no functional effects whatsoever and which few people
care about.

The correct solution is to turn it into a warning as me and others
have suggested.

No argument was offered *why* the build must be aborted. A warning serves the
purpose of informing the developer just as much - and does not
inconvenience the
tester.

Thanks,

	Ingo
[/QUOTE]

Nice to see there is an offer for a fix from binutils-side.

The followers of this "issue" like me have read the arguments from
kernel-developers.
Unfortunately, the Open Source world is not the linux-kernel alone.
I have built in the meantime a lot of Xorg stuff from GIT, etc. with a
binutils 2.21-snapshot (plus additional backported patches from
upstream).

If the goal is to catch real BUGs in the kernel, the current behaviour
of binutils/as is IMHO correct.
That's why I am on linux-next to squash bugs, not to ignore "warnings"

BTW "warnings", did someone tried gcc-4.6?
I used a snapshot from mid February (from Debian/experimental):
My linux-next build-log and the amount of warnings doubled or even
more (unfortunately, I have thrown away that logs and binaries).
Are all of these warnings ignoreable?
Which of them are really severe?

So, H.J. was pro-active in the meantime by offering this patch.
>From kernel-side it's getting IMHO more and more some sort of "burning
of witches".

Thus some questions to the kernel folks:

[1] Jan, what do you mean by "side-effects". Can you explain that a
bit more precisely?

[2] Where can someone set a "global behaviour" (hardcoded options) for
his/her assembler in the kernel's build-system (speaking of
"--size-check=[error|warning]")?

[3] Can the kernel-buildsystem check for system's binutils/as version
and/or its features/options? If yes, where would that be and can you
offer a snippet for a solution?

Answering and/or offering solutions for my askings can help to handle
things from kernel-side.

My 0,02EUR.

- Sedat -
