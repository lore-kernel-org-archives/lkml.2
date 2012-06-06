Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2FFOoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:44:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56467 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2FFOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:44:40 -0400
Date: Wed, 6 Jun 2012 07:44:17 -0700
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
Message-ID: <20120606144417.GH19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
 <1338913190.2749.10.camel@twins>
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
 <alpine.LFD.2.02.1206052153200.3086@ionos>
 <1338931856.2749.57.camel@twins>
 <20120605221240.GW2388@linux.vnet.ibm.com>
 <1338972175.2749.78.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338972175.2749.78.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060614-7408-0000-0000-000005A084AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:42:55AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 15:12 -0700, Paul E. McKenney wrote:
> > > RCU has similar nasties.
> > 
> > I am working to rid RCU of this sort of thing.  I have rcu_barrier() so
> > that it avoids messing with CPUs that don't have callbacks, which will
> > be almost all of the idle CPUs, especially for CONFIG_RCU_FAST_NO_HZ=y.
> > I believe that I have also removed all of RCU's dependencies on CPU
> > hotplug's using kstopmachine, though Murphy would say otherwise.
> > 
> > I still need to fix up synchronize_sched_expedited(), but that is on
> > the list.  I considered getting rid of this one, but I am probably going
> > to have to make synchronize_sched() map to it during boot time to keep
> > the boot-speed demons satisfied. 
> 
> Not the point really. Its perfectly fine for applications in an
> 'isolated' set to use system calls, hence they get to participate in RCU
> state.
> 
> I don't think the isolation means userspace while(1) applications is
> interesting. Sure, some people do this, and we should dtrt for them, but
> the far more interesting case is 'regular' applications that do use
> system calls.

OK, I will bite.  What are the semantics/properties for your isolated set?

							Thanx, Paul

