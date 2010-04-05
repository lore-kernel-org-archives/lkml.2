Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0DEJVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:21:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40989 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145Ab0DEJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:21:36 -0400
Date: Mon, 5 Apr 2010 11:21:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
Message-ID: <20100405092126.GA1419@ucw.cz>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com> <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Russell had this thread: 
> > http://permalink.gmane.org/gmane.linux.ports.arm.kernel/75717
> 
> Russell is wrong.
> 
> Yes, originally it was about P4's overheating. But let me repeat: the fact 
> is, this _is_ valid kernel code:
> 
> 	kernel/sched.c-		while (task_is_waking(p))
> 	kernel/sched.c:			cpu_relax();


And this is valid (but ugly and not optimal) kernel code:

 	kernel/sched.c-		while (task_is_waking(p))
 	kernel/sched.c:			asm volatile("" :: "memory");


> (where that "task_is_waking()" is simply doing two regular reads, and 
> expects another CPU to be changing them).
> 
> This has _nothing_ to do with memory barriers, or with overheating. 
...
> All that matters is that the above kind of while loop must work. The 
> architecture needs to do whatever it needs to do to make it work. End of 
> discussion. If on ARM6 that means "smp_mb()", then that's an ARM6 
> implementation issue.

...so I don't think inserting smp_mb() into cpu_relax() and udelay()
and similar can ever fix the problem fully.

Run smp_mb() from periodic interrupt?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
