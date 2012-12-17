Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2LQUrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:47:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27082 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2LQUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:47:14 -0500
Date: Mon, 17 Dec 2012 15:46:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>, fenghua.yu@intel.com
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com
Subject: Re: 3.8.0-rc0 on xen-unstable: RCU Stall during boot as dom0 kernel
 after IOAPIC
Message-ID: <20121217204634.GA13181@konrad-lan.dumpdata.com>
References: <1995613404.20121214165557@eikelenboom.it>
 <20121216173824.GA4518@phenom.dumpdata.com>
 <1782021524.20121217213217@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1782021524.20121217213217@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 09:32:17PM +0100, Sander Eikelenboom wrote:
> 
> Sunday, December 16, 2012, 6:38:24 PM, you wrote:
> 
> > On Fri, Dec 14, 2012 at 04:55:57PM +0100, Sander Eikelenboom wrote:
> >> Hi Konrad,
> >> 
> >> I just tried to boot a 3.8.0-rc0 kernel (last commit: 7313264b899bbf3988841296265a6e0e8a7b6521) as dom0 on my machine with current xen-unstable.
> 
> > Yeah, saw it over the Dec 11->Dec 12 merges and was out on
> > vacation during that time (just got back).
> 
> > Did you by any chance try to do a git bisect to narrow down
> > which merge it was?
> 
> Hi Konrad,

Hey Sander,

Thank you for doing the bisection.

Fenghua - any ideas what might be amiss in the Xen subsystem?
I hadn't looked at the patchset of the CPU0 offlining/onlining
so I am not completly up to speed on the particulars of the patches.

> 
> With some more effort it leads to:
> 
> git bisect start
> # bad: [fa4c95bfdb85d568ae327d57aa33a4f55bab79c4] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> git bisect bad fa4c95bfdb85d568ae327d57aa33a4f55bab79c4
> # good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
> git bisect good 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
> # bad: [98870901cce098bbe94d90d2c41d8d1fa8d94392] mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()
> git bisect bad 98870901cce098bbe94d90d2c41d8d1fa8d94392
> # good: [8966961b31c251b854169e9886394c2a20f2cea7] Merge tag 'staging-3.8-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
> git bisect good 8966961b31c251b854169e9886394c2a20f2cea7
> # bad: [22a40fd9a60388aec8106b0baffc8f59f83bb1b4] Merge tag 'dlm-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
> git bisect bad 22a40fd9a60388aec8106b0baffc8f59f83bb1b4
> # good: [aefb058b0c27dafb15072406fbfd92d2ac2c8790] Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good aefb058b0c27dafb15072406fbfd92d2ac2c8790
> # good: [b64c5fda3868cb29d5dae0909561aa7d93fb7330] Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good b64c5fda3868cb29d5dae0909561aa7d93fb7330
> # bad: [139353ffbe42ac7abda42f3259c1c374cbf4b779] Merge tag 'please-pull-einj-fix-for-acpi5' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras
> git bisect bad 139353ffbe42ac7abda42f3259c1c374cbf4b779
> # bad: [d07e43d70eef15a44a2c328a913d8d633a90e088] Merge branch 'omap-serial' of git://git.linaro.org/people/rmk/linux-arm
> git bisect bad d07e43d70eef15a44a2c328a913d8d633a90e088
> # bad: [a05a4e24dcd73c2de4ef3f8d520b8bbb44570c60] Merge branch 'x86-cpu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad a05a4e24dcd73c2de4ef3f8d520b8bbb44570c60
> # bad: [a71c8bc5dfefbbf80ef90739791554ef7ea4401b] x86, topology: Debug CPU0 hotplug
> git bisect bad a71c8bc5dfefbbf80ef90739791554ef7ea4401b
> # bad: [42e78e9719aa0c76711e2731b19c90fe5ae05278] x86-64, hotplug: Add start_cpu0() entry point to head_64.S
> git bisect bad 42e78e9719aa0c76711e2731b19c90fe5ae05278
> # good: [4d25031a81d3cd32edc00de6596db76cc4010685] x86, topology: Don't offline CPU0 if any PIC irq can not be migrated out of it
> git bisect good 4d25031a81d3cd32edc00de6596db76cc4010685
> # bad: [209efae12981f3d2d694499b761def10895c078c] x86, hotplug, suspend: Online CPU0 for suspend or hibernate
> git bisect bad 209efae12981f3d2d694499b761def10895c078c
> # bad: [30106c174311b8cfaaa3186c7f6f9c36c62d17da] x86, hotplug: Support functions for CPU0 online/offline
> git bisect bad 30106c174311b8cfaaa3186c7f6f9c36c62d17da
> 
> 
> 
> 30106c174311b8cfaaa3186c7f6f9c36c62d17da is the first bad commit
> commit 30106c174311b8cfaaa3186c7f6f9c36c62d17da
> Author: Fenghua Yu <fenghua.yu@intel.com>
> Date:   Tue Nov 13 11:32:41 2012 -0800
> 
>     x86, hotplug: Support functions for CPU0 online/offline
> 
>     Add smp_store_boot_cpu_info() to store cpu info for BSP during boot time.
> 
>     Now smp_store_cpu_info() stores cpu info for bringing up BSP or AP after
>     it's offline.
> 
>     Continue to online CPU0 in native_cpu_up().
> 
>     Continue to offline CPU0 in native_cpu_disable().
> 
>     Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>     Link: http://lkml.kernel.org/r/1352835171-3958-5-git-send-email-fenghua.yu@intel.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> :040000 040000 729e56e8eddaaf5d0f55257b82f28006dffb9aab d5c98e50cd92814351ee6c741b7e4c9afa29487c M      arch
> 
> 
> Which seems to be merged in http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=74b84233458e9db7c160cec67638efdbec748ca9
> 
> --
> 
> Sander
> 
> 
> > Thanks!
> >> The boot stalls:
> >> 
> >> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> >> [    0.000000] ACPI: Local APIC address 0xfee00000
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
> >> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
> >> [    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
> >> [    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
> >> [    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-
> >> [   64.598628] INFO: rcu_preempt detected stalls on CPUs/tasks:
> >> [   64.598676]  0: (1 GPs behind) idle=aed/140000000000000/0 drain=5 . timer not pending
> >> [   64.598683]  (detected by 1, t=18004 jiffies, g=18446744073709551414, c=18446744073709551413, q=162)
> >> [   64.598692] sending NMI to all CPUs:
> >> [   64.598716] xen: vector 0x2 is not implemented
> >> 
> >> 
> >> Perhaps an interesting line is the incomplete (no end of range, and it stalls there some time before the kernel reports the stall itself:
> >> [    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-
> >> 
> >> 
> >> The exact seem config with 3.7.0 as kernel works fine.
> >> Complete serial log is attached.
> >> 
> >> --
> >> 
> >> Sander
> >> 
> >> 
> 
> 
> 
> 
