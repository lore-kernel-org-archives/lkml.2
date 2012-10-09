Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2JIWOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:14:36 -0400
Received: from adoakley.name ([46.4.104.242]:44936 "EHLO ado.is-a-geek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2JIWOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:14:33 -0400
X-Greylist: delayed 1771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 18:14:33 EDT
Date: Tue, 9 Oct 2012 22:45:32 +0100
From: Andrew Oakley <andrew@ado.is-a-geek.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
In-Reply-To: <20121005152312.GA4649@8bytes.org>
References: <20121005152312.GA4649@8bytes.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012 17:23:12 +0200
Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org> wrote:
> IOMMU Updates for Linux v3.7-rc1
> 
> This time the IOMMU updates contain a bunch of fixes and cleanups to
> various IOMMU drivers and the DMA debug code. New features are the
> code for IRQ remapping support with the AMD IOMMU (preperation for
> that was already merged in the last release) and a debugfs interface
> to export some statistics in the NVidia Tegra IOMMU driver.

I'm getting a kernel panic here when I try to boot from master
(9aadf84) in in your IOMMU tree.  I'll try booting the tagged commit in
case it's the merge that caused the problem but I'm not particularly
hopeful.

I have got interrupt remapping support enabled and the IOMMU enabled,
the chipset is an RD890 (890FX).

I think the relevant bit of the kernel output is here:

ACPI: Core revision 20120711
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
Pid: 1, comm: swapper/0 Not tainted 3.6.0+ #2
Call Trace:
 [<ffffffff8163f617>] ? panic+0xc5/0x1d0
 [<ffffffff8163f76e>] ? printk+0x4c/0x51
 [<ffffffff81c96b52>] ? setup_IO_APIC+0x325/0x710
 [<ffffffff81c947b5>] ? native_smp_prepare_cpus+0x2b9/0x334
 [<ffffffff81c87b53>] ? kernel_init+0x59/0x190
 [<ffffffff81643b84>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81c87afa>] ? start_kernel+0x2c7/0x2c7
 [<ffffffff81643b80>] ? gs_change+0x13/0x13

There is a patch to fix a similar problem (32ab31e) for the Intel IRQ
remapping code but I don't know if this is likely to be the same issue
or not.

I've posted the full kernel log, kernel config and lspci output in case
they are useful:
http://adoakley.name/amd-iommu/dmesg.txt
http://adoakley.name/amd-iommu/kernel_config.txt
http://adoakley.name/amd-iommu/lspci.txt

Thanks

-- 
Andrew Oakley
