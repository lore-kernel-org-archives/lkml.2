Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1CXQcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:32:32 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44716 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1CXQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:32:30 -0400
Date: Thu, 24 Mar 2011 22:02:20 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, arjan@linux.intel.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 3/5] cpuidle: default idle driver for x86
Message-ID: <20110324163220.GB16408@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123244.28725.32435.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222304300.10549@x980>
 <4D89BDE2.9040606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D89BDE2.9040606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trinabh Gupta <trinabh@linux.vnet.ibm.com> [2011-03-23 15:01:14]:

> 
> On 03/23/2011 08:43 AM, Len Brown wrote:
> >Why is this patch a step forward?
> 
> Hi Len,
> 
> I have basically moved the code for arch default and mwait
> idle from arch/x86/kernel/process.c to a driver. This was
> suggested by Venki (https://lkml.org/lkml/2010/10/19/460)
> as part of pm_idle cleanup and direct call of
> cpuidle_idle_call(). There is not much new code here.
> 
> >
> >>+obj-$(CONFIG_X86)                              += default_driver.o
> >
> >BTW, that's a pretty generic name for an x86 specific idle driver...
> >
> >I think that on builds that support intel_idle and acpi_idle,
> >everything in this file will be unused, unless somebody uses some
> >debugging cmdline params that should have been deleted ages ago.
> 
> Yes, I agree that the name has to be x86 specific. I think the
> routines would be used for pre-nehalem architectures that use
> arch default or mwait.

Mainly selection between default_idle (safe_halt), mwait_idle and
c1e_idle needs to be placed in a default driver.  This is the code
that was 'outside' of cpuidle framework and directly used pm_idle().
This is mostly unused and overridden by intel_idle or acpi_idle, but
still cannot be discarded.

Maybe keep this as a module and probe/load only if both intel_idle and
acpi_idle failed to load or excluded by command line or otherwise.

--Vaidy

