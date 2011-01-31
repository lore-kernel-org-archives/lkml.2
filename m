Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1AaKPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:15:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:60840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1AaKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:15:51 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	 <1295946736.28776.479.camel@laptop>
	 <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	 <1296210619.15234.263.camel@laptop>
	 <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
	 <1296405366.2274.60.camel@twins>
	 <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 11:16:46 +0100
Message-ID: <1296469006.15234.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 22:26 -0500, Luming Yu wrote:

> > Guessing is totally the wrong thing when you're sending stuff upstream,
> > esp ugly patches such as this. .32 is more than a year old, anything
> > could have happened.
> 
> Ok. the default upstream kernel seems to have NMI watchdog disabled?

Then enable it already, its a whole CONFIG option away..

> It's not working because of NMI watchdog. If you ignore NMI watchdog,
> then I guess it works but just slow..

Don't guess, test it dammit. And then figure out why it triggers, I
haven't seen _anything_ that would cause it to trigger, nor a sane
explanation for your patch.

> > Ok, so one IPI costs 50-100 us, even with 64 cpu, that's at most 6.4ms
> > nowhere near enough to trigger the NMI watchdog. So what does go wrong?
> 
> Good question!
> But we also can't forget there were large latency from C3.

Not 60+ seconds large I hope, I know NHM-EX has some suckage, but surely
not that bad?

> And I guess some reschedule ticks get lost to kick some CPUs out of
> idle due to the side effects of the CPU PM feature. if use nohz=off,
> everything seems to just work.
> Yes, I agree we need to dig it out either.
> But it's kind of combination problem between the special stop_machine
> context and CPU power management...

Yeah, so? Also, incidentally, stop-machine got a rewrite around .35 and
again significant changes in .37, so please do test mainline and not
your dinosaur.

> > Yeah, what are you smoking? Why do you wreck perfectly fine code for one
> > backward ass piece of hardware.
> 
> Just make things less complex...

But its wrong, it very clearly works around a real problem, don't ever
do that, fix the problem!

