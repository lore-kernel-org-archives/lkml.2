Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1GTT0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:26:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1GTT0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:26:42 -0400
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
In-Reply-To: <20110720190141.GJ2313@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
	 <201107192130.02080.edt@aei.ca> <201107192207.33813.edt@aei.ca>
	 <20110720044435.GB2400@linux.vnet.ibm.com>
	 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
	 <20110720133443.GG2400@linux.vnet.ibm.com>
	 <4E270A0E.6090902@candelatech.com>
	 <20110720171532.GB2313@linux.vnet.ibm.com> <20110720184413.GD17977@elte.hu>
	 <1311187978.29152.58.camel@twins>
	 <20110720190141.GJ2313@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 21:25:46 +0200
Message-ID: <1311189946.29152.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 12:01 -0700, Paul E. McKenney wrote:
>   This can interact badly with the recently
> added RCU read-side critical sections in the scheduler that have
> either the runqueue or the priority-inheritance locks held, especially
> when interrupts occur towards the end of __rcu_read_unlock(). 

Right, so while I recently added a lot more, there have been rcu usage
sites under rq->lock for a long while, see commits

a18b83b7ef ("cpuacct: make cpuacct hierarchy walk in cpuacct_charge()
safe when rcupreempt is used -v2") -- March 2009.

f3b577dec1 ("rcu: apply RCU protection to wake_affine()") -- Jun 2010

b0a0f667 ("sched: suppress RCU lockdep splat in task_fork_fair") -- Oct
2010

So I'm not quite seeing how the problems we're hitting now are new.
