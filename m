Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1CaCDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:03:32 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:40548 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1CaCDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:03:31 -0400
Date: Wed, 30 Mar 2011 22:02:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com, Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
In-reply-to: <4D8CA902.7090907@goop.org>
Message-id: <alpine.LFD.2.02.1103302159010.1920@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231659210.12911@x980>
 <20110324120522.GB29294@dumpdata.com> <4D8CA902.7090907@goop.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Is a CONFIG_XEN kernel supposed to use just HLT in idle?
> > For right now..
> 
> For always, I should think.

Yay!

> >> xen_arch_setup() does this:
> >>
> >>         pm_idle = default_idle;
> >>         boot_option_idle_override = IDLE_HALT;
> >>
> >> which has that effect.  I guess this makes sense b/c the
> >> CONFIG_XEN kernel is Dom0 and the real C-sates are done
> >> by the hypervisor?
> > Correct. There are some patches that make the C-states 
> > be visible in the Linux kernel, but that hasn't been ported
> > over yet.
> 
> All we need is for the idle CPU to block in the hypervisor; a plain
> "hlt" is always going to be sufficient (which is overridden as a pvop
> into a sched_idle hypercall).
> 
> Xen will choose an appropriate power state for the physical cpus
> depending on the overall busyness of the system (which any individual
> virtual machine can't determine).

Okay, knowing that the Dom0 kernel

1. can boot in non-xen mode on bare hardware and run cpuidle
2. needs just HLT when booted in xen mode

will help us keep things simple.

thanks,
Len Brown, Intel Open Source Technology Center
