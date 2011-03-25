Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1CYH3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:29:10 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:55073 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1CYH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:29:08 -0400
Date: Fri, 25 Mar 2011 03:28:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 0/2] cpuidle: global registration of idle states
 with per-cpu statistics
In-reply-to: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103250326160.32565@x980>
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Trinabh Gupta wrote:

> This patch series is an early RFC to discuss the feasibility of
> avoiding registering of idle states from each cpu.
> 
> The core change is to split the cpuidle_device structure into parts
> that can be global and parts that has to remain per-cpu.  The per-cpu
> pieces are mostly generic statistics that can be independent of
> current running driver.
> 
> Motivation:
> * Simplify the cpuidle subsystem framework and have
>   registration/unregistration done by single cpu.
> 
> * Minimise the data structure that needs to be maintained for multiple
>   cpuidle drivers
> 
> * Reference: https://lkml.org/lkml/2011/2/10/37
> 
> Advantages:
> * Make the cpuidle framework simple for most use cases where C-States
>   are symmetric.  In case there are asymmetric C-States detected,
>   fallback mechanism should be incorporated to maintain the system
>   functional
>   https://lkml.org/lkml/2011/2/10/257
>   https://lkml.org/lkml/2011/2/10/37
> 
> * Non x86 archs that does not have asymmetric C-States like POWER, may
>   not need the fallback mechanism and hence the framework will be
>   simple for most use cases.
> 
> Disadvantages:
> * Asymmetric C-States are part of x86 ACPI specification.  Incorrect
>   handling may functionally affect the system

I think this is a non-issue.

> * Incorporating per-cpu masks for each state to allow/dis-allow global
>   states on subset of CPUs may result in an implementation that is
>   not better than current solution of having per-cpu states.

I don't think this is needed.

> This patch series applies on top of the pm_idle cleanup patch
> https://lkml.org/lkml/2011/3/22/150 (cpuidle: Cleanup pm_idle and 
> include driver/cpuidle.c in-kernel)
> 
> This patch series is tested on x86 Nehalem system with multiple ACPI
> C-States.
> 
> This patch series has limitations of not handling multiple driver
> registration and switching between drivers on all CPUs mainly due to
> incomplete handling of per-cpu enable/disable and driver_data.

I think this series is more important than the feature of multiple
driver/system support, and thus should come first.

thanks,
Len Brown, Intel Open Source Technology Center

