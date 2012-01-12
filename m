Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2ALGc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:32:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57835 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab2ALGcz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:32:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxDdCUd_h2Xk3H3giO4GsAE05Y8-uN1tqRNOJiKV-mhGg@mail.gmail.com>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
	<CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
	<7vty438575.fsf@alter.siamese.dyndns.org>
	<201201111812.46431.arnd@arndb.de>
	<CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
	<CA+55aFxDdCUd_h2Xk3H3giO4GsAE05Y8-uN1tqRNOJiKV-mhGg@mail.gmail.com>
Date: Thu, 12 Jan 2012 07:32:54 +0100
X-Google-Sender-Auth: jNoAMhwNzSlOYQ6rO9-4hFazlTs
Message-ID: <CAMuHMdWnoKowa0atP0k5X4vukJTnQSNSh9gibxd1Y2e60qK3RQ@mail.gmail.com>
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Junio C Hamano <gitster@pobox.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 00:21, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 11, 2012 at 12:29 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>> And all of this would look nice if you would have done a rebase on top of the
>> latest tagged version of Linus' tree that contains all prerequisites, right?
>
> Rebasing means that nobody else can depend on or work with that tree,
> so it's a no-no.
>
> Sure, it works if you are the only person touching it, but then you
> had better not export it at all, so what's the point?

That's why you need two branches:
  1. a non-rebasing one for development,
  2. a rebasing one containing cherry-picked (possibly folded) commits for
     preparing for upstream delivery.

Both branches contain an identical source tree at all times, but they contain
different commits. If you make a merge error in the first, or a rebase
error in the
second, you will notice as they will differ.

The non-rebasing branch should be used by your (sub)lieutenants to
base their work
on.
The rebasing branch is used for deliveries upstream. `for-next` and
`for-linus` are subsets of it. Patches emailed out for review
can/should come from this branch
(appying patches is also a form of rebasing).

> We have had independent problems in another branch exactly because it
> was rebased and people merged it, so bringing up rebasing as a
> "solution" is wrong-headed. It just causes *more* problems of other
> kinds, even if it may make git request-pull trivial.

Other people are supposed to merge the non-rebasing branch only. Just like
you (as in "everyone except Linus") only merge in your non-rebasing branch.

What I like (the most?) about git is that it tracks automatically what commits
in my rebasing branch have been applied upstream.

If you pull from your sub-lieutenants instead of applying patches, or if you
have multiple upstreams, it becomes more complicated, but I think git rebase
can still handle it.

Examples:
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/master
(non-rebasing)
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-queue
(rebasing)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
