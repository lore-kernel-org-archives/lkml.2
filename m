Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab1CYHTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:19:48 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:60636 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab1CYHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:19:46 -0400
Date: Fri, 25 Mar 2011 03:19:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
In-reply-to: <20110324120522.GB29294@dumpdata.com>
Message-id: <alpine.LFD.2.02.1103250315180.32565@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231659210.12911@x980>
 <20110324120522.GB29294@dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 24, 2011 at 03:18:14AM -0400, Len Brown wrote:
> > Is a CONFIG_XEN kernel supposed to use just HLT in idle?
> 
> For right now..
> > 
> > xen_arch_setup() does this:
> > 
> >         pm_idle = default_idle;
> >         boot_option_idle_override = IDLE_HALT;
> > 
> > which has that effect.  I guess this makes sense b/c the
> > CONFIG_XEN kernel is Dom0 and the real C-sates are done
> > by the hypervisor?
> 
> Correct. There are some patches that make the C-states 
> be visible in the Linux kernel, but that hasn't been ported
> over yet.

The Xen Dom0 kernel will trap into the hypervisor
whenever it does a HLT or an MWAIT, yes?

What is the benefit of having Dom0 decided between
C-states that it can't actually enter?

What is the mechanism by which those C-states are
made visible to Dom0, and how are those states
related to the states that are supported on
the bare iron?

> > Would the same CONFIG_XEN kernel binary ever not
> > run xen_arch_setup(), run on raw hardware, and want
> > to use idle states other than HLT?

> ever not? I am not sure of the question, so let me state:
> The Linux kernel if compiled with CONFIG_XEN, and if run on
> native hardware, would _never_ run 'xen_arch_setup()'*. It would
> run the normal, native type setup.

Thanks, that clarifies.
-Len Brown, Intel Open Source Technolgy Center

