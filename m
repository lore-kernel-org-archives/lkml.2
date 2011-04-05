Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1DEPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:48:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53404 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1DEPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:48:30 -0400
Date: Tue, 5 Apr 2011 21:18:20 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
Message-ID: <20110405154820.GB5492@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
 <20110325180156.GC19214@dirshya.in.ibm.com>
 <alpine.LFD.2.02.1103302203490.1920@x980>
 <1301577536.4859.249.camel@twins>
 <alpine.LFD.2.02.1104010006210.2797@x980>
 <1301666556.4859.695.camel@twins>
 <20110404143259.GA11525@in.ibm.com>
 <1302015692.2225.1347.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302015692.2225.1347.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 05:01:32PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-04-04 at 20:02 +0530, Dipankar Sarma wrote:
> > On Fri, Apr 01, 2011 at 04:02:36PM +0200, Peter Zijlstra wrote:
> > I can't find any Moorestown documentation at the Intel site, but
> > thinking about Len's inputs a bit more, it seems there may
> > be still a problem asymetry from the scheduler perspective.
> > 
> > If cpu0 or cpu1 either of them can be offlined, there is no
> > asymetry. If only cpu1 can be offlined, it would mean that
> > one cpu may be more efficient depending on how we do
> > cpu offlining for power savings. It gets a bit messy.
> > 
> > Len, what exacty is the significance of offlining here ?
> > Apart from going to C6, what else is needed in cpu1 for
> > the chip to go to S0i3 ? Why is idle C6 not enough ?
> 
> I don't think offlining is relevant, anybody using that for power
> management is doing it wrong, _very_ wrong.

I am suggesting that it depends on the offlining logic. If cpu1
is being used as an added co-processor for some specific apps
and mostly offline otherwise, it may not be an issue. If
offlining is being used as a meta-scheduler over the kernel
scheduler (like power savings or whatever logic) than it
will cause asymmetry problems dependent on the ooffline logic - e.g.
it may be more advantageous for the kernel scheduler to schedule
on cpu0 keeping cpu1 free leading to S0i3 more often. Not advocating
it when we are trying to run away from it on powerpc :)

For now, it seems we are OK in handling S0i3 through cpuidle, just that 
it would be nice to understand the overall offline logic and why it is 
needed. Similar questions have come up in my discussions with ARM guys 
in the recent times as well.

Thanks
Dipankar

