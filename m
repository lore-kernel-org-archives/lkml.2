Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab1CYHFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:05:52 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:52723 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1CYHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:05:51 -0400
Date: Fri, 25 Mar 2011 03:05:36 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
In-reply-to: <4D8B5197.2060306@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103250245570.32565@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222254420.10549@x980>
 <4D89BBDD.5090505@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231633030.12911@x980>
 <4D8B5197.2060306@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think there are other problems too, related to saving and restoring
> of pm_idle pointer. For example, cpuidle itself saves current value
> of pm_idle, flips it and then restores the saved value. There is
> no guarantee that the saved function still exists. APM does exact
> same thing (though it may not be used these days).
> 
> The problem also is that a number of architectures have copied the
> same design based on pm_idle; so its spreading.

pm_idle is a primitive design yes, but I think the issue
with pm_idle is a theoretical one, at least on x86;
as there isn't any other code scribbling on pm_idle
in practice.  So this is clean-up, rather than bug-fix work...

> > It isn't immediately clear to me that all of these options
> > need to be preserved.
> 
> So what do you suggest can be removed?

I sent a series of small patches yesterday to get the ball rolling...
https://lkml.org/lkml/2011/3/24/54

I think the xen thing can go away.

I proposed that APM be removed entirely,
but that will take a few releases to conclude....

> > Are we suggesting that x86 must always build with cpuidle?
> > I'm sure that somebody someplace will object to that.
> 
> Arjan argued that since almost everyone today runs cpuidle
> it may be best to include it in the kernel
> (https://lkml.org/lkml/2010/10/20/243). But yes, we agreed
> that we would have to make cpuidle lighter incrementally.
> Making ladder governor optional could be one way for example.

ladder is already optional.

cheers,
-Len Brown, Intel Open Source Technology Center
