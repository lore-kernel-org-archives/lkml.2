Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1CXQwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:52:12 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49314 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1CXQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:52:09 -0400
Date: Thu, 24 Mar 2011 22:22:00 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, arjan@linux.intel.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver
 registration and selection
Message-ID: <20110324165200.GC16408@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222254420.10549@x980>
 <4D89BBDD.5090505@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231633030.12911@x980>
 <4D8B5197.2060306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D8B5197.2060306@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trinabh Gupta <trinabh@linux.vnet.ibm.com> [2011-03-24 19:43:43]:


[snip]

> >>But we also have to replace the functionality provided by pm_idle,
> >>i.e. call default_idle for platforms where no better idle routine
> >>exists, call mwait for pre-nehalem platforms, use intel_idle or
> >>acpi_idle for nehalem architectures etc. To manage all this
> >>we need a registration mechanism which is conveniently provided
> >>by cpuidle.
> >
> >It isn't immediately clear to me that all of these options
> >need to be preserved.
> 
> So what do you suggest can be removed?

Can we use safe_halt() until intel_idle/acpi_idle take over? But what
if they do not take over?  If safe_halt() is not very bad compared to
the variants like mwait_idle and c1e_idle, then we can remove the old
code and no need to move them to default driver.

> >Are we suggesting that x86 must always build with cpuidle?
> >I'm sure that somebody someplace will object to that.
> 
> Arjan argued that since almost everyone today runs cpuidle
> it may be best to include it in the kernel
> (https://lkml.org/lkml/2010/10/20/243). But yes, we agreed
> that we would have to make cpuidle lighter incrementally.
> Making ladder governor optional could be one way for example.
> >
> >OTOH, if cpuidle is included, I'd like to see the
> >non-cpuidle code excluded, since nobody will run it...

The non-cpuidle code will be the select_idle_routine() and related
function that cam move to default_driver that register to cpuidle.
We can load on-demand as module if better routines fail to register.
Maybe we don't need this at all as discussed in the above point?

--Vaidy

[snip]

