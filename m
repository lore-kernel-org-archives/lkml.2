Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0DBTrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:47:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700Ab0DBTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:47:26 -0400
Date: Fri, 2 Apr 2010 12:43:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
cc: Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <4BB64762.6040806@windriver.com>
Message-ID: <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Jason Wessel wrote:
> 
> Russell had this thread: 
> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/75717

Russell is wrong.

Yes, originally it was about P4's overheating. But let me repeat: the fact 
is, this _is_ valid kernel code:

	kernel/sched.c-		while (task_is_waking(p))
	kernel/sched.c:			cpu_relax();

(where that "task_is_waking()" is simply doing two regular reads, and 
expects another CPU to be changing them).

This has _nothing_ to do with memory barriers, or with overheating. 

The fact that maybe some ARM6 cache coherency implementation is pure and 
utter sh*t and never sees the changes without the same instruction that 
happens to be a memory barrier on that architecture does not make that 
cpu_relax() any more about memory barriers.

Similarly, the fact that P4's wanted cpu_relax() in order to not overheat 
and cause slowdowns has _nothing_ to do with anything. 

All that matters is that the above kind of while loop must work. The 
architecture needs to do whatever it needs to do to make it work. End of 
discussion. If on ARM6 that means "smp_mb()", then that's an ARM6 
implementation issue.

		Linus
