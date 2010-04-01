Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0DALEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:04:50 -0400
Received: from www.tglx.de ([62.245.132.106]:55245 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab0DALEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:04:43 -0400
Date: Thu, 1 Apr 2010 13:04:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
In-Reply-To: <1270117906.1653.139.camel@laptop>
Message-ID: <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
References: <1270117906.1653.139.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Peter Zijlstra wrote:

> I'm sure you dropped Ingo and Thomas by accident.
> 
> On Thu, 2010-04-01 at 12:40 +0300, Avi Kivity wrote:
> > mmu_take_all_locks() takes a spinlock for each vma, which means we increase
> > the preempt count by the number of vmas in an address space.  Since the user
> > controls the number of vmas, they can cause preempt_count to overflow.
> > 
> > Fix by making mmu_take_all_locks() only disable preemption once by making
> > the spinlocks preempt-neutral.
> 
> Right, so while this will get rid of the warning it doesn't make the
> code any nicer, its still a massive !preempt latency spot.

I'm not sure whether this is a real well done April 1st joke or if there
is someone trying to secure the "bad taste patch of the month" price.

Anyway, I don't see a reason why we can't convert those locks to
mutexes and get rid of the whole preempt disabled region.

Thanks,

	tglx
