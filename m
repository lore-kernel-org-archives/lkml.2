Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2FEWBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:01:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47467 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FEWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:01:33 -0400
Date: Tue, 5 Jun 2012 15:00:59 -0700
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
Message-ID: <20120605220059.GV2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
 <1338912565.2749.9.camel@twins>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
 <1338913190.2749.10.camel@twins>
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
 <20120605212947.GA8686@linux.vnet.ibm.com>
 <1338932241.2749.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338932241.2749.62.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060522-5518-0000-0000-000004F18E2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:37:21PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 14:29 -0700, Paul E. McKenney wrote:
> > OK, I'll bite...  Why not just use CPU hotplug to expel the timers?
> 
> Currently? Can you say: 'kstopmachine'?

So if CPU hotplug (or whatever you want to call it) stops using
kstopmachine, you are OK with it?

> But its also a question of interface and naming. Do you want to have to
> iterate all cpus in your isolated set, do you want to bring them down
> far enough to physically unplug. Ideally no to both.

For many use cases, it is indeed not necessary to get to a point where
the CPUs could be physically removed from the system.  But CPU-failure
use cases would need the CPU to be fully deactivated.  And many of the
hardware guys tell me that the CPU-failure case will be getting more
common, though I sure hope that they are wrong.

> If you don't bring them down far enough to unplug, should you still be
> calling it hotplug?

I am not too worried about what it is called.  Though "banish to monastery"
would probably be going too far in the other direction.

> Ideally I think there'd be a file in your cpuset which if opened and
> written to will flush all pending bits (timers, workqueues, the lot) and
> return when this is done (and maybe provide O_ASYNC writes to not wait
> for completion).

The mobile guys probably are not too worried about bulk operations yet
because they don't have that many CPUs, but it might be useful elsewhere.

							Thanx, Paul

