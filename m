Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1CYHNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:13:37 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52689 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CYHNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:13:36 -0400
Date: Fri, 25 Mar 2011 03:13:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
In-reply-to: <20110324165200.GC16408@dirshya.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103250307330.32565@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222254420.10549@x980>
 <4D89BBDD.5090505@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231633030.12911@x980>
 <4D8B5197.2060306@linux.vnet.ibm.com>
 <20110324165200.GC16408@dirshya.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So what do you suggest can be removed?
> 
> Can we use safe_halt() until intel_idle/acpi_idle take over? But what
> if they do not take over?  If safe_halt() is not very bad compared to
> the variants like mwait_idle and c1e_idle, then we can remove the old
> code and no need to move them to default driver.

One reason I'd like a default cpuidle driver is that today
there is a race.  cpuidle registers, but until its driver
registers it will use polling.  go ahead and look:

grep . /sys/devices/system/cpu/cpu*/cpuidle/state0/usage

that should be 0, but it isn't...

> > >Are we suggesting that x86 must always build with cpuidle?
> > >I'm sure that somebody someplace will object to that.
> > 
> > Arjan argued that since almost everyone today runs cpuidle
> > it may be best to include it in the kernel
> > (https://lkml.org/lkml/2010/10/20/243). But yes, we agreed
> > that we would have to make cpuidle lighter incrementally.
> > Making ladder governor optional could be one way for example.
> > >
> > >OTOH, if cpuidle is included, I'd like to see the
> > >non-cpuidle code excluded, since nobody will run it...
> 
> The non-cpuidle code will be the select_idle_routine() and related
> function that cam move to default_driver that register to cpuidle.
> We can load on-demand as module if better routines fail to register.
> Maybe we don't need this at all as discussed in the above point?

Right, though I don't share your fascination with modules.

cheers,
Len Brown, Intel Open Source Technology Center


