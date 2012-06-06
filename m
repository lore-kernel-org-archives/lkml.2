Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2FFOlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:41:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41030 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2FFOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:41:47 -0400
Date: Wed, 6 Jun 2012 07:41:28 -0700
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
Message-ID: <20120606144127.GF19601@linux.vnet.ibm.com>
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
 <1338972223.2749.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338972223.2749.79.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060614-1780-0000-0000-00000634DA54
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00145705; UDB=6.00033380; UTC=2012-06-06
 14:41:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:43:43AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 15:12 -0700, Paul E. McKenney wrote:
> > > What I can't see is the isolated functional, aside from the above
> > > mentioned things, that's not strictly a per-cpu property, we can have a
> > > group that's isolated from the rest but not from each other.
> > 
> > I suspect that Thomas is thinking that the CPU is so idle that it no
> > longer has to participate in TLB invalidation or RCU.  (Thomas will
> > correct me if I am confused.)  But Peter, is that the level of idle
> > you are thinking of? 
> 
> No, we're talking about isolated, so its very much running something.

>From what I can see, if the CPU is running something, this is Thomas's
"Isolated functional" state rather than his "Isolated idle" state.
The isolated-idle state should not need to participate in TLB invalidation
or RCU, so that the CPU never ever needs to wake up while in the
isolated-idle state.

							Thanx, Paul

