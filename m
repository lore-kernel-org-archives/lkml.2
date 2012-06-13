Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2FMTC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:02:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:50783 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2FMTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:02:58 -0400
Date: Wed, 13 Jun 2012 21:02:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120613185748.GF2427@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206132101440.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de> <20120613185748.GF2427@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> >  	/* Now call notifier in preparation. */
> >  	cpu_notify(CPU_ONLINE | mod, hcpu);
> > +	smpboot_unpark_threads(cpu);
> 
> OK, RCU must use the lower-level interfaces, given that one of
> then CPU_ONLINE notifiers might invoke synchronize_rcu().

We can start the threads before the notifiers. There is no
restriction.

Thanks,

	tglx

