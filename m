Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2FNO4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:56:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:55232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2FNO4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:56:36 -0400
Message-ID: <1339685789.2559.37.camel@twins>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jun 2012 16:56:29 +0200
In-Reply-To: <20120614144734.GA2458@linux.vnet.ibm.com>
References: <20120613102823.373180763@linutronix.de>
	 <20120613105815.206105518@linutronix.de>
	 <20120613185748.GF2427@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206132101440.3086@ionos>
	 <20120613191745.GG2427@linux.vnet.ibm.com>
	 <20120613204725.GA9858@linux.vnet.ibm.com>
	 <20120614045125.GA30257@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206141234400.3086@ionos>
	 <20120614125939.GC2443@linux.vnet.ibm.com> <1339678887.2559.30.camel@twins>
	 <20120614144734.GA2458@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 07:47 -0700, Paul E. McKenney wrote:
> RCU callback processing consumes the entire CPU in RCU_BOOST case where
> processing runs at real-time priority.  This is analogous to RT throttling
> in the scheduler. 

But previously we can in non-preemptible softirq context, why would if
behave differently when done from a RT task?

Also, no its not quite like the throttling, that really idles the cpu
even if there's no SCHED_OTHER tasks to run.
