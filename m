Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2FFOnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:43:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41857 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2FFOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:43:21 -0400
Date: Wed, 6 Jun 2012 07:43:12 -0700
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
Message-ID: <20120606144312.GG19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
 <1338913190.2749.10.camel@twins>
 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338918625.2749.29.camel@twins>
 <alpine.LFD.2.02.1206052106440.3086@ionos>
 <1338925756.2749.36.camel@twins>
 <20120605212947.GA8686@linux.vnet.ibm.com>
 <1338932241.2749.62.camel@twins>
 <20120605220059.GV2388@linux.vnet.ibm.com>
 <1338985041.2749.107.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338985041.2749.107.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060614-1780-0000-0000-00000634DE60
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00145705; UDB=6.00033380; UTC=2012-06-06
 14:43:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 02:17:21PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 15:00 -0700, Paul E. McKenney wrote:
> > On Tue, Jun 05, 2012 at 11:37:21PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 14:29 -0700, Paul E. McKenney wrote:
> > > > OK, I'll bite...  Why not just use CPU hotplug to expel the timers?
> > > 
> > > Currently? Can you say: 'kstopmachine'?
> > 
> > So if CPU hotplug (or whatever you want to call it) stops using
> > kstopmachine, you are OK with it?
> 
> It would be much better, still not ideal though.

OK, fair enough.  Then again, there is not much in this world that is ideal.

> > > But its also a question of interface and naming. Do you want to have to
> > > iterate all cpus in your isolated set, do you want to bring them down
> > > far enough to physically unplug. Ideally no to both.
> > 
> > For many use cases, it is indeed not necessary to get to a point where
> > the CPUs could be physically removed from the system.  But CPU-failure
> > use cases would need the CPU to be fully deactivated.  And many of the
> > hardware guys tell me that the CPU-failure case will be getting more
> > common, though I sure hope that they are wrong.
> 
> Uhm, yeah, that doesn't sound right.

The people arguing for this believe that failures will increase with
decreasing feature size.  Of course, no one will really know until
the real hardware appears.

							Thanx, Paul

