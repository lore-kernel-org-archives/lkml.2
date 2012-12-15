Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2LOQ0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:26:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41266 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2LOQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121208074429.GC4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
	<1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
	<20121205171609.GW4939@ZenIV.linux.org.uk>
	<50C07ECE.9070602@imgtec.com>
	<20121206220955.GZ4939@ZenIV.linux.org.uk>
	<20121208074429.GC4939@ZenIV.linux.org.uk>
Date: Sat, 15 Dec 2012 17:26:30 +0100
Message-ID: <CACM3HyGHQRkqyqV=X8HKGhh-x3izA9Utr2F_C9nJjPvrxd85+A@mail.gmail.com>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Hogan <james.hogan@imgtec.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2012 08:44, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 06, 2012 at 10:09:55PM +0000, Al Viro wrote:
>>       What we need to guarantee is
>> * restarts do not happen on signals caught in interrupts or exceptions
>> * restarts do not happen on signals caught in sigreturn()
>> * restart should happen only once, even if we get through do_signal() many
>> times.
>
> FWIW, here's the current situation:
>

> openrisc: broken.  regs->orig_gpr11 can be easily used to fix - it fits the
> usual model, but isn't set by sigreturn/restarts.  BTW, the comment around
> the call of do_notify_resume() in the asm glue is deeply confused - we *do*
> want the userspace pt_regs; fortunately, there can't be any on top of those
> at that point.
>

Right, I've known about this for a while and have even had a patch for
this lying about in a side-branch.  I got side-tracked while fixing
this into trying to make the restart logic more generic, and the
openrisc fix never got merged upstream.  I'll need to revisit this.

That said, let me point again to the series I posted for review a year
ago that attempts to make the restart logic more generic:

https://lkml.org/lkml/2011/10/23/80

The entires patch series, which doesn't necessarily even apply to
Linux master anymore due to other changes along the way, can be found
at:

git://openrisc.net/~jonas/linux  ('signal-arch' branch)

Commit 4aa1797d978fe2d45ececceee535257e19374df8 is the interesting one there.

Al, what do you think?

/Jonas
