Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab1FPWYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:24:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:46813 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab1FPWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:23:57 -0400
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20110616202550.GA16214@elte.hu>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308134200.15315.32.camel@twins> <1308135495.15315.38.camel@twins>
	 <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com>
	 <20110615201216.GA4762@elte.hu>
	 <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
	 <20110616070335.GA7661@elte.hu> <20110616171644.GK2582@linux.vnet.ibm.com>
	 <20110616202550.GA16214@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 08:21:23 +1000
Message-ID: <1308262883.2516.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 22:25 +0200, Ingo Molnar wrote:

> > Whatever does the boosting will need to have process context and 
> > can be subject to delays, so that pretty much needs to be a 
> > kthread. But it will context-switch quite rarely, so should not be 
> > a problem.
> 
> So user-return notifiers ought to be the ideal platform for that, 
> right? We don't even have to touch the scheduler: anything that 
> schedules will eventually return to user-space, at which point the 
> RCU GC magic can run.
> 
> And user-return-notifiers can be triggered from IRQs as well.
> 
> That allows us to get rid of softirqs altogether and maybe even speed 
> the whole thing up and allow it to be isolated better.

I'm a little worried of relying on things returning to userspace.

One could imagine something like a router appliance where userspace is
essentially asleep forever and everything happens in the kernel
(networking via softirq, maybe NFS kernel server, ...)

Cheers,
Ben.


