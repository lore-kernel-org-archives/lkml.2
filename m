Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2CALak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:30:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:50109 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab2CALah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:30:37 -0500
Message-ID: <1330601400.11728.48.camel@pasglop>
Subject: Re: [PATCH 0/2] More i387 state save/restore work
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        anton@samba.org
Date: Thu, 01 Mar 2012 22:30:00 +1100
In-Reply-To: <CA+55aFwc6u6Mr9iCMKM+MexfKso4tN7D2VdWpJpuT2saj0Pgfw@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
	 <12996.1329699216@neuling.org>
	 <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
	 <CA+55aFxqK1A0g6qHvZHxzGOTGT0YFAoRJtOeYWLxVchM=e=qww@mail.gmail.com>
	 <CA+55aFwc6u6Mr9iCMKM+MexfKso4tN7D2VdWpJpuT2saj0Pgfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 17:11 -0800, Linus Torvalds wrote:
> Oh, and final comment - looking at the thing you pointed at, it looks
> much more adventurous than my x86 FP state thing.

Right, that's the main reason why I haven't merged it (yet...). I though
the added complexity and risk wasn't worth the added complexity and
risk.

But going half way there as you are doing definitely looks like a good
idea. I'll have a look when I'm done whacking the shit out of our
exception entry path :)

> I always save things unconditionally, so that I don't have to do the
> IPI or just in general care about the "oops, now I want things in
> memory, not in some random CPU FP state". So mine is just a "writeback
> cache", and only optimizes the reading things back: there is never any
> dirty state in the CPU except when the process is actively using it.
> 
> That obviously does mean that I only optimize away the restore side,
> not the save side. But it's *way* simpler, and considering that I just
> spent almost a week trying to figure out FP state save bugs, simple is
> good.

On the other hand, you seem to support FP use from random kernel
contexts such as softirq, interrupts etc... while we don't (well not
with the "normal" APIs, obviously you can always turn all IRQs off and
manually enable & save restore but that's too nasty for words).

Cheers,
Ben.


