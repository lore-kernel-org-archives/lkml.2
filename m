Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab2IOPSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:18:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32883 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2IOPSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:18:32 -0400
Date: Sat, 15 Sep 2012 17:18:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120915151827.GA17439@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <1347682262.4340.160.camel@marge.simpson.net>
 <20120915104451.GC12364@liondog.tnic>
 <1347720459.7256.11.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347720459.7256.11.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 04:47:39PM +0200, Mike Galbraith wrote:
> Increasing /proc/sys/kernel/sched_min_granularity_ns to roughly half
> of sched_latency_ns should also help. That will allow LAST_BUDDY to do
> it's job, try to hand the CPU back to a preempted task if possible.

Just for my n00b scheduler understanding: this way you're practically
extending the timeslice of the task so that it gets done without being
preempted and the lock-holding period of the preempted task gets smaller
and thus you get more completed transactions in postgres during the
benchmark run?

> The change that increased sched_nr_latency to 8 should have injured
> postgress as well. ATM, it's disabled unless you're massively loaded.
>
> I _think_ it's about preemption, but it doesn't matter, patch is
> toast.

In any case, if you wanna retry the buddy thing for 3.7, ping me and I
can run it on the assortment of machines I have here.

Thanks.

-- 
Regards/Gruss,
    Boris.
