Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1DAOD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:03:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1DAODZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:03:25 -0400
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
In-Reply-To: <alpine.LFD.2.02.1104010006210.2797@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
	 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
	 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
	 <4D89CA7D.8080108@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103231623450.12911@x980>
	 <4D8B550D.5000409@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103250321480.32565@x980>
	 <20110325180156.GC19214@dirshya.in.ibm.com>
	 <alpine.LFD.2.02.1103302203490.1920@x980> <1301577536.4859.249.camel@twins>
	 <alpine.LFD.2.02.1104010006210.2797@x980>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 16:02:36 +0200
Message-ID: <1301666556.4859.695.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 00:09 -0400, Len Brown wrote:
> > > Moorestown is already an example of an asymmetric system,
> > > since its deepest c-state is available on cpu0, but not on cpu1.
> > > So it needs different tables for each cpu. 
> > 
> > wtf are these hardware guys smoking and how the heck are we supposed to
> > schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?
> 
> they are smoking micro-amps:-)

Has anybody told them that pushing lots of logic into software generally
burns more amps because it keeps the thing running longer?

> S0i3 on cpu0 can be entered only after cpu1 is already off-line,
> among other system hardware dependencies...
> 
> So it makes no sense to export S0i3 as a c-state on cpu1.
> 
> When cpu1 is online, the scheduler treats it as a normal SMP.

Dipankar's reply seems to address this issue well.
