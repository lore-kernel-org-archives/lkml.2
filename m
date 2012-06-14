Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2FNPHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:07:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:58346 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2FNPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:07:33 -0400
Date: Thu, 14 Jun 2012 17:07:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <1339685789.2559.37.camel@twins>
Message-ID: <alpine.LFD.2.02.1206141702300.3086@ionos>
References: <20120613102823.373180763@linutronix.de>  <20120613105815.206105518@linutronix.de>  <20120613185748.GF2427@linux.vnet.ibm.com>  <alpine.LFD.2.02.1206132101440.3086@ionos>  <20120613191745.GG2427@linux.vnet.ibm.com>  <20120613204725.GA9858@linux.vnet.ibm.com>
  <20120614045125.GA30257@linux.vnet.ibm.com>  <alpine.LFD.2.02.1206141234400.3086@ionos>  <20120614125939.GC2443@linux.vnet.ibm.com> <1339678887.2559.30.camel@twins>  <20120614144734.GA2458@linux.vnet.ibm.com> <1339685789.2559.37.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Peter Zijlstra wrote:

> On Thu, 2012-06-14 at 07:47 -0700, Paul E. McKenney wrote:
> > RCU callback processing consumes the entire CPU in RCU_BOOST case where
> > processing runs at real-time priority.  This is analogous to RT throttling
> > in the scheduler. 
> 
> But previously we can in non-preemptible softirq context, why would if
> behave differently when done from a RT task?

softirqs are different. They loop ten times and then wake ksoftirqd
which runs with sched_other.

Though that's wonky, because if an interrupt arrives before ksoftirqd
can take over we loop another 10 times in irq_exit(). Rinse and
repeat.....

And the main difference is that the scheduler does not yell on the
softirq context, but it yells when an rt task monopolizes the cpu.

Thanks,

	tglx
