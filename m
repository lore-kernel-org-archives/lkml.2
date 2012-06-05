Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2FEV36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:29:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32839 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2FEV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:29:56 -0400
Date: Tue, 5 Jun 2012 14:29:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or nmi
Message-ID: <20120605212947.GA8686@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87zk8iioam.fsf@rustcorp.com.au>
 <1338881971.28282.150.camel@twins>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
 <1338912565.2749.9.camel@twins>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
 <1338913190.2749.10.camel@twins>
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338925756.2749.36.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060521-5112-0000-0000-000008B4D7FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 09:49:16PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 21:43 +0200, Thomas Gleixner wrote:
> > Vs. the interrupt/timer/other crap madness:
> > 
> >  - We really don't want to have an interrupt balancer in the kernel
> >    again, but we need a mechanism to prevent the user space balancer
> >    trainwreck from ruining the power saving party.
> 
> What's wrong with having an interrupt balancer tied to the scheduler
> which optimistically tries to avoid interrupting nohz/isolated/idle
> cpus?

Such an interrupt balancer would be a good thing, but I don't believe
that it will be sufficient.

> >  - The timer issue is mostly solved by the existing nohz stuff
> >    (plus/minus the few bugs in there).
> 
> Its not.. if you create an isolated domain there's no way to expel
> existing timers from there.

OK, I'll bite...  Why not just use CPU hotplug to expel the timers?

(Sorry, but you just can't expect me to pass that one up!)

> >  - The other details (silly IPIs) and cross CPU timer arming) are way
> >    easier to solve by a proper prohibitive state than by chasing that
> >    nonsense all over the tree forever. 
> 
> But we need to solve all that without a prohibitibe state anyway for the
> isolation stuff to be useful.

I bet that we will end up having to do both.

							Thanx, Paul

