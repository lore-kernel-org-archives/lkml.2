Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0DAQgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:36:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab0DAQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:36:17 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100401161551.GE2472@linux.vnet.ibm.com>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com> <4BB480CC.2060503@redhat.com>
	 <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop>
	 <20100401154249.GQ5825@random.random> <4BB4C0F5.3070204@redhat.com>
	 <1270137406.1598.78.camel@laptop> <4BB4C48C.5000005@redhat.com>
	 <20100401161551.GE2472@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 18:36:14 +0200
Message-ID: <1270139774.1598.130.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 09:15 -0700, Paul E. McKenney wrote:
> > I don't understand.  I thought the problem was that the locks were
> > taken inside an rcu critical section; switching to srcu would fix
> > that.  But how is call_rcu_preempt() related?  Grepping a bit, what
> > is call_rcu_preempt()?  my tree doesn't have it.
> 
> I believe that Peter is referring to the RCU implementation you get
> with CONFIG_TREE_PREEMPT_RCU, which currently depends on CONFIG_PREEMPT.
> The other implementation is CONFIG_TREE_RCU, which is usually called
> "classic RCU". 

Right, so I've been nudging Paul a while to make it so that we always
have preemptible rcu available and that only the default interface
switches between sched/classic and preempt.

Currently we already have:

call_rcu_sched()
call_rcu_bh()
call_rcu()	(depends on CONFIG_PREEMPT_RCU)

I'm saying it would be nice to also have:

call_rcu_preempt()



