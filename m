Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab1CWUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:32:18 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:56939 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab1CWUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:32:17 -0400
Date: Wed, 23 Mar 2011 16:32:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
In-reply-to: <4D89CA7D.8080108@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103231623450.12911@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also wondering why you would ever have a different idle routine on
> > different cpus?
> 
> Yes, this is an ongoing debate. Apparently it is a possibility
> because of ACPI bugs. CPU's can have asymmetric C-states
> and overall different idle routines on different cpus. Please
> refer to http://lkml.org/lkml/2009/9/24/132 and
> https://lkml.org/lkml/2011/2/10/37 for a discussion around this.

Althought the ACPI specification allows the BIOS to tell the OS
about different C-states per-processor, I know of zero system
in the field and zero systems in development that require that
capability.  That isn't a guarantee that capability will never
be used, but I'm not holding my breath.

If there are systems with broken tables that make them
appear asymetric, then we should have a workaround that handles
that case, rather than complicating the normal code for
the broken case.

So I recommend deleting the extra per-cpu registration stuff
unless there is some other architecture that requires it
and can't hadle the asymmetry in another way.

> I have posted a patch series that does global registration
> i.e same idle routines for each cpu. Please check
> http://lkml.org/lkml/2011/3/22/161 . That series applies on
> top of this series. Global registration significantly
> simplifies the design, but still we are not sure about the
> direction to take.

I'll review that.

thanks,
Len Brown, Intel Open Source Technology Center

