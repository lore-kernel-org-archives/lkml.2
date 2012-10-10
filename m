Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2JJHae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:30:34 -0400
Received: from 8bytes.org ([85.214.48.195]:33273 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab2JJHaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:30:25 -0400
Date: Wed, 10 Oct 2012 09:30:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Oakley <andrew@ado.is-a-geek.net>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121010073022.GB16151@8bytes.org>
References: <20121005152312.GA4649@8bytes.org>
 <20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Oct 10 09:30:22 2012
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5075240e22971458319372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Oct 09, 2012 at 10:45:32PM +0100, Andrew Oakley wrote:
> On Fri, 5 Oct 2012 17:23:12 +0200
> Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org> wrote:

> ACPI: Core revision 20120711
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
> Pid: 1, comm: swapper/0 Not tainted 3.6.0+ #2
> Call Trace:
>  [<ffffffff8163f617>] ? panic+0xc5/0x1d0
>  [<ffffffff8163f76e>] ? printk+0x4c/0x51
>  [<ffffffff81c96b52>] ? setup_IO_APIC+0x325/0x710
>  [<ffffffff81c947b5>] ? native_smp_prepare_cpus+0x2b9/0x334
>  [<ffffffff81c87b53>] ? kernel_init+0x59/0x190
>  [<ffffffff81643b84>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff81c87afa>] ? start_kernel+0x2c7/0x2c7
>  [<ffffffff81643b80>] ? gs_change+0x13/0x13
> 
> There is a patch to fix a similar problem (32ab31e) for the Intel IRQ
> remapping code but I don't know if this is likely to be the same issue
> or not.

Can you please boot with 'amd_iommu_dump nointremap' on your kernel
command line and post dmesg? I guess your ACPI table is broken in some
way.

The problem seen on VT-d exists on AMD too, but I have a workaround for
that in the code already. This must be something else...

Thanks,

	Joerg


