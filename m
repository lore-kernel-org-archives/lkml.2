Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1CaUfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:35:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab1CaUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk> <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
 <alpine.LFD.2.00.1103311429590.28032@xanadu.home> <AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 13:28:45 -0700
Message-ID: <AANLkTikmtXVqAoDmW-fL2emGg9Oh6PMmhZa6em6=WZKc@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 1:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Umm. The whole "number of lines of code" thing has become a total red herring.
>
> THAT IS NOT WHY I STARTED TO COMPLAIN!
>
> The reason I point out the number of lines of code is because it's one
> of the more obvious _symptoms_ of the problem.
>
> But trust me, if you start doing a better job at platform code, I
> won't be complaining when I get lots of deleted code, or when I start
> getting devicetree descriptions instead of new drivers.

So if you don't like lines of code, how about just "number of files touched".

This is Thomas this merge window. Remember: he's traditionally doing
timers and interrupts and stuff.  Do:

 git log --author=tglx v2.6.38.. --oneline --numstat |
    cut -f3- | grep -v ' ' | cut -d/ -f1-2 |
    sort | uniq -c | sort -n | tail

and see another example of arm standing out (ok, so "kernel/irq" also
stands out in this case, but you'd kind of _expect_ that, when the
whole series is about irq controllers, wouldn't you?)

And no, mips doesn't look so hot either.

Anyway, the point is, there are many ways to show the whole "arm is a
maintenance problem" issue. Don't get too hung up about number of
lines changed. It's just the simplest kind of thing where the tools
give answers very quickly without the above kinds of games.

Btw, the reason why the subject line on this rant is what it is, is
that during this merge window, arm was also one of the more annoying
to merge. And NO, that does NOT mean that I want you guys to merge
things behind my back just to hide the problem. I'm just saying that
it's another facet of this whole issue. Not that I can't do merges,
but that ARM simply ends up having these issues that others don't.

                          Linus
