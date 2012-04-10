Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2DJH5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 03:57:25 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59181 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab2DJH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 03:57:23 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty\@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo\@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
In-Reply-To: <20120409164628.GA2430@linux.vnet.ibm.com>
References: <4F674649.2000300@linux.vnet.ibm.com> <4F67474A.20707@linux.vnet.ibm.com> <20120405173918.GC8194@linux.vnet.ibm.com> <20120405175549.GA9127@linux.vnet.ibm.com> <20120405230654.GB19607@linux.vnet.ibm.com> <4F7F4EF0.70305@linux.vnet.ibm.com> <20120409164628.GA2430@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 10 Apr 2012 13:26:55 +0530
Message-ID: <87d37gxbnc.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12041007-5816-0000-0000-000002146D34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012 09:46:28 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > 2.	Read and understand the architecture-specific code, looking
> > > 	for opportunities to consolidate additional function into
> > > 	core code.
> > > 
> > > 	a.	Carry out any indicated consolidation.
> > > 
> > > 	b.	Convert all architectures to make use of the
> > > 		consolidated implementation.
> > > 
> > > 	Not started.  Low priority from a big.LITTLE perspective.
> > 
> > 
> > Recently this unexpectedly assumed high priority due to some scheduler
> > changes and things got fixed up temporarily. And in that context,
> > Peter Zijlstra gave some more technical pointers on what is wrong and needs
> > to be done right. Link: https://lkml.org/lkml/2012/3/22/149
> > 
> > Nikunj (in CC) has offered to work with me on this consolidation.
> 
> Very cool!  I have added the following:
> 
> ------------------------------------------------------------------------
> 
> CONSOLIDATE ARCHITECTURE-SPECIFIC CPU-HOTPLUG CODE
> 
> 1.	Ensure that all CPU_STARTING notifiers complete before the
> 	incoming CPU is marked online (the blackfin architecture
> 	fails to do this).
> 
> 2.	Ensure that interrupts are disabled throughout the CPU_STARTING
> 	notifiers.  Currently, blackfin, cris, m32r, mips, sh, sparc64,
> 	um, and x86 fail to do this properly.
> 
> 3.	Ensure that all architectures that use CONFIG_USE_GENERIC_SMP_HELPERS
> 	hold ipi_call_lock() over the entire CPU-online process.  Currently,
> 	alpha, arm, m32r, mips, sh, and sparc32 seem to fail to do this
> 	properly.
> 
> 4.	Additional memory barriers are likely to be needed, for example,
> 	an smp_wmb() after setting cpu_active and an smp_rmb() in
> 	select_fallback_rq() before reading cpu_active.
> 
> Srivatsa Bhat (srivatsa.bhat@linux.vnet.ibm.com) and Nikunj A Dadhania
> (nikunj@linux.vnet.ibm.com) are taking on this work.
> 
Sounds good :-)

Regards
Nikunj

