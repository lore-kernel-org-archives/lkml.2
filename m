Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab1DAEJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:09:39 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:53486 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1DAEJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:09:38 -0400
Date: Fri, 01 Apr 2011 00:09:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
In-reply-to: <1301577536.4859.249.camel@twins>
Message-id: <alpine.LFD.2.02.1104010006210.2797@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
 <20110325180156.GC19214@dirshya.in.ibm.com>
 <alpine.LFD.2.02.1103302203490.1920@x980> <1301577536.4859.249.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Moorestown is already an example of an asymmetric system,
> > since its deepest c-state is available on cpu0, but not on cpu1.
> > So it needs different tables for each cpu. 
> 
> wtf are these hardware guys smoking and how the heck are we supposed to
> schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?

they are smoking micro-amps:-)

S0i3 on cpu0 can be entered only after cpu1 is already off-line,
among other system hardware dependencies...

So it makes no sense to export S0i3 as a c-state on cpu1.

When cpu1 is online, the scheduler treats it as a normal SMP.

cheers,
-Len Brown, Intel Open Source Technology Center


