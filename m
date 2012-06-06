Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2FFXVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:21:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58925 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:21:01 -0400
Date: Wed, 6 Jun 2012 16:20:55 -0700
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
Message-ID: <20120606232055.GO19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
 <alpine.LFD.2.02.1206052153200.3086@ionos>
 <1338931856.2749.57.camel@twins>
 <20120605221240.GW2388@linux.vnet.ibm.com>
 <1338972175.2749.78.camel@twins>
 <20120606144417.GH19601@linux.vnet.ibm.com>
 <1338997600.2749.146.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338997600.2749.146.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060623-7606-0000-0000-000000EBEA5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:46:40PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:44 -0700, Paul E. McKenney wrote:
> 
> > > I don't think the isolation means userspace while(1) applications is
> > > interesting. Sure, some people do this, and we should dtrt for them, but
> > > the far more interesting case is 'regular' applications that do use
> > > system calls.
> > 
> > OK, I will bite.  What are the semantics/properties for your isolated set?
> 
> The scheduler will not place tasks from outside the set in the set and
> vice versa. Applications outside the set should not affect those in the
> set, except there where there are shared resources across the set
> boundary.
> 
> So the example of 1 process with multiple threads, some inside some
> outside have the obvious shared resource of the address space, hence TLB
> invalidates etc. will come through.

So, for example, a way of nicely partitioning the system to allow multiple
real-time applications to run without needing to do cross-partition
global priority queuing of the real-time tasks.  Cool!

> Now the kernel as a whole is also a shared resource, and this is where
> it all gets tricky, since if something inside the set ends up doing a
> memory allocation, it will have to participate in mm/ locks etc.

Yep.

> Same with RCU, if you cannot stay in an extended grace period for some
> reason or other, you have to participate in the global RCU state
> machinery.

Yep.

> But it should be so that if you don't do any of these things, you should
> also not be affected by them.
> 
> Now I realize this is a 'weak' model, but the 'strong' model proposed by
> tglx would make it impossible to run anything but the while(1) stuff,
> and that's of limited utility.

Thomas's strong model also supports a strong form of idle, as well as the
while(1) stuff, both of which have their uses.

							Thanx, Paul

