Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1DAIPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:15:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48534 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1DAIPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:15:30 -0400
Date: Fri, 1 Apr 2011 13:45:22 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
Message-ID: <20110401081522.GA22339@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
 <20110325180156.GC19214@dirshya.in.ibm.com>
 <alpine.LFD.2.02.1103302203490.1920@x980>
 <1301577536.4859.249.camel@twins>
 <alpine.LFD.2.02.1104010006210.2797@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104010006210.2797@x980>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:09:25AM -0400, Len Brown wrote:
> > > Moorestown is already an example of an asymmetric system,
> > > since its deepest c-state is available on cpu0, but not on cpu1.
> > > So it needs different tables for each cpu. 
> > 
> > wtf are these hardware guys smoking and how the heck are we supposed to
> > schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?
> 
> they are smoking micro-amps:-)
> 
> S0i3 on cpu0 can be entered only after cpu1 is already off-line,
> among other system hardware dependencies...
> 
> So it makes no sense to export S0i3 as a c-state on cpu1.
> 
> When cpu1 is online, the scheduler treats it as a normal SMP.

Isn't S0i3 a "system" state, as opposed to cpu state ? Perhaps
we can treat it as such and still keep the c-states symmetric.
The cpu can transition to S0i3 from any cpu as long as others are
offlined, no ? In that sense, really all the cpus would
be in S0i3, which would make it symmetric. If this isn't how
mrst cpuidle works, then cpuidle accounting may be broken
in principle because of this.

Thanks
Dipankar
