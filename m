Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1CYRU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:20:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49325 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1CYRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:20:28 -0400
Date: Fri, 25 Mar 2011 22:45:33 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 0/2] cpuidle: global registration of idle states
 with per-cpu statistics
Message-ID: <20110325171533.GA19214@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103250326160.32565@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103250326160.32565@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2011-03-25 03:28:59]:

> On Tue, 22 Mar 2011, Trinabh Gupta wrote:
> 
> > This patch series is an early RFC to discuss the feasibility of
> > avoiding registering of idle states from each cpu.
> > 
> > The core change is to split the cpuidle_device structure into parts
> > that can be global and parts that has to remain per-cpu.  The per-cpu
> > pieces are mostly generic statistics that can be independent of
> > current running driver.
> > 
> > Motivation:
> > * Simplify the cpuidle subsystem framework and have
> >   registration/unregistration done by single cpu.
> > 
> > * Minimise the data structure that needs to be maintained for multiple
> >   cpuidle drivers
> > 
> > * Reference: https://lkml.org/lkml/2011/2/10/37
> > 
> > Advantages:
> > * Make the cpuidle framework simple for most use cases where C-States
> >   are symmetric.  In case there are asymmetric C-States detected,
> >   fallback mechanism should be incorporated to maintain the system
> >   functional
> >   https://lkml.org/lkml/2011/2/10/257
> >   https://lkml.org/lkml/2011/2/10/37
> > 
> > * Non x86 archs that does not have asymmetric C-States like POWER, may
> >   not need the fallback mechanism and hence the framework will be
> >   simple for most use cases.
> > 
> > Disadvantages:
> > * Asymmetric C-States are part of x86 ACPI specification.  Incorrect
> >   handling may functionally affect the system
> 
> I think this is a non-issue.

Hi Len,

Thanks for the confirmation.  This gives us the right direction to
proceed with the cleanup.

> > * Incorporating per-cpu masks for each state to allow/dis-allow global
> >   states on subset of CPUs may result in an implementation that is
> >   not better than current solution of having per-cpu states.
> 
> I don't think this is needed.
> 
> > This patch series applies on top of the pm_idle cleanup patch
> > https://lkml.org/lkml/2011/3/22/150 (cpuidle: Cleanup pm_idle and 
> > include driver/cpuidle.c in-kernel)
> > 
> > This patch series is tested on x86 Nehalem system with multiple ACPI
> > C-States.
> > 
> > This patch series has limitations of not handling multiple driver
> > registration and switching between drivers on all CPUs mainly due to
> > incomplete handling of per-cpu enable/disable and driver_data.
> 
> I think this series is more important than the feature of multiple
> driver/system support, and thus should come first.

Removing pm_idle() gets us to the situation where we have to support
multiple registration to allow default_idle driver to register and do
mwait.  Your cleanup patch to x86 idle will make the transition much
simple.  Lets us have removal of pm_idle() and removal of per-cpu
registration in the same patch series as the next step.

--Vaidy

