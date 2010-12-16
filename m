Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0LPQ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:56:30 -0500
Received: from www.tglx.de ([62.245.132.106]:33646 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab0LPQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:56:26 -0500
Date: Thu, 16 Dec 2010 17:56:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com
Subject: Re: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#3
In-Reply-To: <4D0A3EB1.7060207@kernel.org>
Message-ID: <alpine.LFD.2.00.1012161755010.12146@localhost6.localdomain6>
References: <1292074247-20891-1-git-send-email-tj@kernel.org> <4D0A3EB1.7060207@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Tejun Heo wrote:
> (cc'ing Shaohui)
> Hello, Thoams.
> 
> On 12/11/2010 02:30 PM, Tejun Heo wrote:
> > This is the third take of unify-x86_32-and-64-NUMA-init-paths
> > patchset.  Most changes from the last take[L] are to reflect comments
> > from tglx.
> > 
> > * Rebased on top of tip/x86/apic-cleanup.
> > 
> > * "x86: apic: Cleanup and simplify setup_local_APIC()" is already
> >   merged into x86/apic-cleanup and dropped from this series.
> > 
> > * Instead of repurposing apic->cpu_to_logical_apicid(), replace it
> >   with a new 32bit specific callback
> >   apic->x86_32_early_logical_apicid().
> > 
> > * For consistency, in 0012, apic->apicid_to_node() is renamed to
> >   x86_32_numa_cpu_node() and put inside CONFIG_X86_32.
> > 
> > * NULL assignments for unimplemented apic ops dropped.
> > 
> > * 0013 now explicitly describes why amd srat_detect_node() accesses
> >   __apicid_to_node[] directly.  Also, add a comment in the function
> >   noting the ugliness.
> > 
> > * Patch description updated in 0014.
> > 
> > * Other misc updates.
> 
> Do the above changes agreeable to you?  Shaohui is wondering what to
> do with the conflicts between the NUMA hotplug simulator and this
> series, so...

I was looking with hpa into it, review still in progress.
