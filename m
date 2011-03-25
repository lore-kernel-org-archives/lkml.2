Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1CYSCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:02:12 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55342 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1CYSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:02:11 -0400
Date: Fri, 25 Mar 2011 23:31:57 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
Message-ID: <20110325180156.GC19214@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103250321480.32565@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2011-03-25 03:24:24]:

> 
> > Maybe there is some other way to handle asymmetry ??
> 
> When somebody invents a system that needs asymmetry on purpose,
> that is the time to get fancy.  Until that day, simply print a
> FW_BUG WARNING and fall back to default_idle().

We may print a warning but not switch to default_idle().  There could
be laptops that gets an extra C-State when run on battery.  So when
the ACPI _PPC event happens for the C-State change, we need to handle
the situation such that the states are refreshed for all CPUs in one step.

Basically while we are updating the new C-State, the framework should
not detect this as asymmetric and switch to default_idle().  Please
fell free to suggest a more elegant solution to handle the runtime
C-State change event, though symmetric across all CPUs.

--Vaidy

