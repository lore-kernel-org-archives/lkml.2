Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1DEPBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1DEPBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:01:45 -0400
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
From: Peter Zijlstra <peterz@infradead.org>
To: dipankar@in.ibm.com
Cc: Len Brown <lenb@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
In-Reply-To: <20110404143259.GA11525@in.ibm.com>
References: <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
	 <4D89CA7D.8080108@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103231623450.12911@x980>
	 <4D8B550D.5000409@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103250321480.32565@x980>
	 <20110325180156.GC19214@dirshya.in.ibm.com>
	 <alpine.LFD.2.02.1103302203490.1920@x980> <1301577536.4859.249.camel@twins>
	 <alpine.LFD.2.02.1104010006210.2797@x980> <1301666556.4859.695.camel@twins>
	 <20110404143259.GA11525@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 17:01:32 +0200
Message-ID: <1302015692.2225.1347.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 20:02 +0530, Dipankar Sarma wrote:
> On Fri, Apr 01, 2011 at 04:02:36PM +0200, Peter Zijlstra wrote:
> > 
> > > S0i3 on cpu0 can be entered only after cpu1 is already off-line,
> > > among other system hardware dependencies...
> > > 
> > > So it makes no sense to export S0i3 as a c-state on cpu1.
> > > 
> > > When cpu1 is online, the scheduler treats it as a normal SMP.
> > 
> > Dipankar's reply seems to address this issue well.
> 
> I can't find any Moorestown documentation at the Intel site, but
> thinking about Len's inputs a bit more, it seems there may
> be still a problem asymetry from the scheduler perspective.
> 
> If cpu0 or cpu1 either of them can be offlined, there is no
> asymetry. If only cpu1 can be offlined, it would mean that
> one cpu may be more efficient depending on how we do
> cpu offlining for power savings. It gets a bit messy.
> 
> Len, what exacty is the significance of offlining here ?
> Apart from going to C6, what else is needed in cpu1 for
> the chip to go to S0i3 ? Why is idle C6 not enough ?

I don't think offlining is relevant, anybody using that for power
management is doing it wrong, _very_ wrong.
