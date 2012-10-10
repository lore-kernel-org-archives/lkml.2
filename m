Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2JJI54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 04:57:56 -0400
Received: from adoakley.name ([46.4.104.242]:34695 "EHLO ado.is-a-geek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2JJI5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 04:57:54 -0400
Date: Wed, 10 Oct 2012 09:58:23 +0100
From: Andrew Oakley <andrew@ado.is-a-geek.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
In-Reply-To: <20121010073022.GB16151@8bytes.org>
References: <20121005152312.GA4649@8bytes.org>
	<20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
	<20121010073022.GB16151@8bytes.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 09:30:22 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> Hi Andrew,
> 
> On Tue, Oct 09, 2012 at 10:45:32PM +0100, Andrew Oakley wrote:
> > On Fri, 5 Oct 2012 17:23:12 +0200
> > Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org> wrote:
> 
> > ACPI: Core revision 20120711
> > ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > Kernel panic - not syncing: timer doesn't work through
> > Interrupt-remapped IO-APIC Pid: 1, comm: swapper/0 Not tainted
> > 3.6.0+ #2 Call Trace:
> >  [<ffffffff8163f617>] ? panic+0xc5/0x1d0
> >  [<ffffffff8163f76e>] ? printk+0x4c/0x51
> >  [<ffffffff81c96b52>] ? setup_IO_APIC+0x325/0x710
> >  [<ffffffff81c947b5>] ? native_smp_prepare_cpus+0x2b9/0x334
> >  [<ffffffff81c87b53>] ? kernel_init+0x59/0x190
> >  [<ffffffff81643b84>] ? kernel_thread_helper+0x4/0x10
> >  [<ffffffff81c87afa>] ? start_kernel+0x2c7/0x2c7
> >  [<ffffffff81643b80>] ? gs_change+0x13/0x13
> > 
> > There is a patch to fix a similar problem (32ab31e) for the Intel
> > IRQ remapping code but I don't know if this is likely to be the
> > same issue or not.
> 
> Can you please boot with 'amd_iommu_dump nointremap' on your kernel
> command line and post dmesg? I guess your ACPI table is broken in some
> way.

http://adoakley.name/amd-iommu/dmesg_amd_iommu_dump.txt

AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: 3e info 1300
AMD-Vi:        mmio-addr: 00000000fec30000
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:00.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 00:00.2
AMD-Vi:   DEV_SELECT			 devid: 00:02.0 flags: 00
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 01:00.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 01:00.1
AMD-Vi:   DEV_SELECT			 devid: 00:04.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 02:00.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:05.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:06.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:07.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 05:00.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:09.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 06:00.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:0b.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 07:00.0 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:11.0 flags: 00
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:12.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 00:12.2
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:13.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 00:13.2
AMD-Vi:   DEV_SELECT			 devid: 00:14.0 flags: d7
AMD-Vi:   DEV_SELECT			 devid: 00:14.2 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:14.3 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:14.4 flags: 00
AMD-Vi:   DEV_ALIAS_RANGE		 devid: 08:00.0 flags: 00 devid_to: 00:14.4
AMD-Vi:   DEV_RANGE_END		 devid: 08:1f.7
AMD-Vi:   DEV_SELECT			 devid: 00:14.5 flags: 00
AMD-Vi:   DEV_SELECT			 devid: 00:15.0 flags: 00
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 09:00.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 09:1f.7
AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:16.0 flags: 00
AMD-Vi:   DEV_RANGE_END		 devid: 00:16.2
AMD-Vi:   DEV_SPECIAL(HPET[0])		devid: 00:14.0
AMD-Vi:   DEV_SPECIAL(IOAPIC[2])		devid: 00:00.1


-- 
Andrew Oakley
