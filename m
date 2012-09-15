Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2IOTpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 15:45:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2IOTo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 15:44:58 -0400
Date: Sat, 15 Sep 2012 21:44:54 +0200
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
Message-ID: <20120915194453.GA30632@liondog.tnic>
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
 <20120915151827.GA17439@liondog.tnic>
 <1347725625.7029.25.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347725625.7029.25.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 06:13:45PM +0200, Mike Galbraith wrote:
> > Just for my n00b scheduler understanding: this way you're practically
> > extending the timeslice of the task so that it gets done without being
> > preempted and the lock-holding period of the preempted task gets smaller
> > and thus you get more completed transactions in postgres during the
> > benchmark run?
> 
> Not really, preemption will happen, but when the preempting task goes to
> sleep (or uses it's fair share), instead of selecting the leftmost task
> (lowest vruntime), the preempted task gets the CPU back if we can do
> that without violating fairness.  If the preempted task happens to be a
> userland spinlock holder, it then release the lock sooner, others don't
> spin as long, do more work, less playing space heater while lock holder
> waits for spinners to eat enough CPU to become less deserving that it.

Ok, I definitely grok this. Thanks for explaining.

-- 
Regards/Gruss,
    Boris.
