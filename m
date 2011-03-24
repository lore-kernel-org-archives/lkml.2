Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1CXMGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:06:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17184 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1CXMGM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 24 Mar 2011 08:06:12 -0400
Date: Thu, 24 Mar 2011 08:05:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
Message-ID: <20110324120522.GB29294@dumpdata.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com>
 <4D89C40B.4020809@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231659210.12911@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103231659210.12911@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D8B3384.0105,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 03:18:14AM -0400, Len Brown wrote:
> Is a CONFIG_XEN kernel supposed to use just HLT in idle?

For right now..
> 
> xen_arch_setup() does this:
> 
>         pm_idle = default_idle;
>         boot_option_idle_override = IDLE_HALT;
> 
> which has that effect.  I guess this makes sense b/c the
> CONFIG_XEN kernel is Dom0 and the real C-sates are done
> by the hypervisor?

Correct. There are some patches that make the C-states 
be visible in the Linux kernel, but that hasn't been ported
over yet.

> 
> Would the same CONFIG_XEN kernel binary ever not
> run xen_arch_setup(), run on raw hardware, and want

ever not? I am not sure of the question, so let me state:
The Linux kernel if compiled with CONFIG_XEN, and if run on
native hardware, would _never_ run 'xen_arch_setup()'*. It would
run the normal, native type setup.

> to use idle states other than HLT?
> 

*: It could if you really really wanted. You would need to change
the GRUB2 to inject some extra data in the 'sub_hardware' flag to be
the Xen specific.
