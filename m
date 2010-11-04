Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0KDFUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:20:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34365 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0KDFUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fduv8PED9pMLEy3tEr5Kruue7G4okPauVdYkMrtbLApfzG8u5gXFmOAF7TkXadfCrE
         NSig/jG3r+vqEj+r6mC9uKRzCJnvatKz0FFa9C7u9DXEh3hbtqwfKA4LMAxMOVXWe4bN
         xP/y7PCLtytjupAYiilwRFp5pMdzs2qYvZC8s=
Subject: Re: divide error in select_task_rq_fair()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101104041236.GA9389@helgaas.com>
References: <20101104041236.GA9389@helgaas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 06:19:52 +0100
Message-ID: <1288847992.2718.37.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 22:12 -0600, Bjorn Helgaas a écrit :
> Hi,
> 
> With current upstream, I see the following crash at boot-time:
> 
>     Brought up 64 CPUs
>     Total of 64 processors activated (289366.52 BogoMIPS).
>     divide error: 0000 [#1] SMP 
>     last sysfs file: 
>     CPU 1 
>     Modules linked in:
> 
>     Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #271 /ProLiant DL980 G7
>     RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
> 
> Complete dmesg below; let me know if you need more info.

Is the machine runs OK if you build a kernel with NR_CPUS=128 ?


> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 64/0x1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 65/0x3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 66/0x5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 67/0x7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 68/0x11 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 69/0x13 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 70/0x15 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 71/0x17 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 72/0x21 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 73/0x23 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 74/0x25 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 75/0x27 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 76/0x31 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 77/0x33 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 78/0x35 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 79/0x37 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 80/0x41 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 81/0x43 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 82/0x45 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 83/0x47 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 84/0x51 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 85/0x53 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 86/0x55 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 87/0x57 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 88/0x61 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 89/0x63 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 90/0x65 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 91/0x67 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 92/0x71 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 93/0x73 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 94/0x75 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 95/0x77 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x81] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 96/0x81 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x83] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 97/0x83 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x85] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 98/0x85 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x87] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 99/0x87 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x91] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 100/0x91 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x93] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 101/0x93 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x95] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 102/0x95 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x97] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 103/0x97 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0xa1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 104/0xa1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0xa3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 105/0xa3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0xa5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 106/0xa5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0xa7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 107/0xa7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0xb1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 108/0xb1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0xb3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 109/0xb3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0xb5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 110/0xb5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x5f] lapic_id[0xb7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 111/0xb7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x61] lapic_id[0xc1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 112/0xc1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x63] lapic_id[0xc3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 113/0xc3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x65] lapic_id[0xc5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 114/0xc5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x67] lapic_id[0xc7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 115/0xc7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x69] lapic_id[0xd1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 116/0xd1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xd3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 117/0xd3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xd5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 118/0xd5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xd7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 119/0xd7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x71] lapic_id[0xe1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 120/0xe1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x73] lapic_id[0xe3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 121/0xe3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x75] lapic_id[0xe5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 122/0xe5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x77] lapic_id[0xe7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 123/0xe7 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x79] lapic_id[0xf1] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 124/0xf1 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x7b] lapic_id[0xf3] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 125/0xf3 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x7d] lapic_id[0xf5] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 126/0xf5 ignored.
> [    0.000000] ACPI: LAPIC (acpi_id[0x7f] lapic_id[0xf7] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 127/0xf7 ignored.
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:8
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007ee00000 s75520 r8192 d22784 u262144
> [    0.000000] pcpu-alloc: s75520 r8192 d22784 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 16 24 32 40 48 56 -- -- 
> [    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 [1] 17 25 33 41 49 57 -- -- 
> [    0.000000] pcpu-alloc: [2] 18 26 34 42 50 58 -- -- [3] 19 27 35 43 51 59 -- -- 
> [    0.000000] pcpu-alloc: [4] 20 28 36 44 52 60 -- -- [5] 21 29 37 45 53 61 -- -- 
> [    0.000000] pcpu-alloc: [6] 22 30 38 46 54 62 -- -- [7] 23 31 39 47 55 63 -- -- 
> [    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 24811904
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: console=ttyS0,115200n8 ignore_loglevel printk.time=0 root=/dev/cciss/c0d1p1 BOOT_IMAGE=kernel 
> PID hash table entries: 4096 (order: 3, 32768 bytes)
> Checking aperture...
> No AGP bridge found
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> Memory: 99187376k/947912704k available (6286k kernel code, 847260136k absent, 1465192k reserved, 6950k data, 628k init)
> SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=8
> Hierarchical RCU implementation.
> 	RCU-based detection of stalled CPUs is disabled.
> NR_IRQS:4352 nr_irqs:2008 16
> Extended CMOS year: 2000
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> hpet clockevent registered
> Fast TSC calibration using PIT
> Detected 2261.072 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4522.14 BogoMIPS (lpj=2261072)
> pid_max: default: 65536 minimum: 512
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
> Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys freezer
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> mce: CPU supports 22 MCE banks
> CPU0: Thermal monitoring enabled (TM1)
> using mwait in idle threads.
> Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
> ... version:                3
> ... bit width:              48
> ... generic registers:      4
> ... value mask:             0000ffffffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   3
> ... event mask:             000000070000000f
> ACPI: Core revision 20101013
> DMAR: Host address width 40
> DMAR: DRHD base: 0x000000ac000000 flags: 0x0
> IOMMU 0: reg_base_addr ac000000 ver 1:0 cap c90780106f0462 ecap f0207e
> DMAR: DRHD base: 0x000000a8000000 flags: 0x1
> IOMMU 1: reg_base_addr a8000000 ver 1:0 cap c90780106f0462 ecap f0207e
> DMAR: RMRR base: 0x0000007f7ee000 end: 0x0000007f7effff
> DMAR: RMRR base: 0x0000007f7e7000 end: 0x0000007f7ecfff
> DMAR: RMRR base: 0x0000007f62e000 end: 0x0000007f62ffff
> DMAR: ATSR flags: 0x0
> DMAR: ATSR flags: 0x0
> Not enabling x2apic, Intr-remapping init failed.
> Setting APIC routing to physical flat
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 06
> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
> Booting Node   0, Processors  #16 Ok.
> Booting Node   1, Processors  #17 Ok.
> Booting Node   2, Processors  #18 Ok.
> Booting Node   3, Processors  #19 Ok.
> Booting Node   4, Processors  #20 Ok.
> Booting Node   5, Processors  #21 Ok.
> Booting Node   6, Processors  #22 Ok.
> Booting Node   7, Processors  #23 Ok.
> Booting Node   0, Processors  #24 Ok.
> Booting Node   1, Processors  #25 Ok.
> Booting Node   2, Processors  #26 Ok.
> Booting Node   3, Processors  #27 Ok.
> Booting Node   4, Processors  #28 Ok.
> Booting Node   5, Processors  #29 Ok.
> Booting Node   6, Processors  #30 Ok.

All this seems wrong...

> Booting Node   7, Processors  #31 Ok.
> Booting Node   0, Processors  #32 Ok.
> Booting Node   1, Processors  #33 Ok.
> Booting Node   2, Processors  #34 Ok.
> Booting Node   3, Processors  #35 Ok.
> Booting Node   4, Processors  #36 Ok.
> Booting Node   5, Processors  #37 Ok.
> Booting Node   6, Processors  #38 Ok.
> Booting Node   7, Processors  #39 Ok.
> Booting Node   0, Processors  #40 Ok.
> Booting Node   1, Processors  #41 Ok.
> Booting Node   2, Processors  #42 Ok.
> Booting Node   3, Processors  #43 Ok.
> Booting Node   4, Processors  #44 Ok.
> Booting Node   5, Processors  #45 Ok.
> Booting Node   6, Processors  #46 Ok.
> Booting Node   7, Processors  #47 Ok.
> Booting Node   0, Processors  #48 Ok.
> Booting Node   1, Processors  #49 Ok.
> Booting Node   2, Processors  #50 Ok.
> Booting Node   3, Processors  #51 Ok.
> Booting Node   4, Processors  #52 Ok.
> Booting Node   5, Processors  #53 Ok.
> Booting Node   6, Processors  #54 Ok.
> Booting Node   7, Processors  #55 Ok.
> Booting Node   0, Processors  #56 Ok.
> Booting Node   1, Processors  #57 Ok.
> Booting Node   2, Processors  #58 Ok.
> Booting Node   3, Processors  #59 Ok.
> Booting Node   4, Processors  #60 Ok.
> Booting Node   5, Processors  #61 Ok.
> Booting Node   6, Processors  #62 Ok.
> Booting Node   7, Processors  #63 Ok.
> Brought up 64 CPUs
> Total of 64 processors activated (289366.52 BogoMIPS).
> divide error: 0000 [#1] SMP 
> last sysfs file: 
> CPU 1 
> Modules linked in:
> 
> Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #271 /ProLiant DL980 G7
> RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
> RSP: 0000:ffff88046f869c30  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000040
> RBP: ffff88046f869d30 R08: 0000000000000000 R09: ffff88046fa62598
> R10: 0000000000000000 R11: 0000000000000080 R12: ffff88046fa62580
> R13: ffff88007ee4da50 R14: 0000000000011ac0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88007ee40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kthreadd (pid: 2, threadinfo ffff88046f868000, task ffff88e1f6c40750)
> Stack:
>  ffff880400000000 0000000000011ac0 0000000000011ac0 0000000000011ac0
>  0000000000011ac0 0000000000011ac8 0000000000011ac8 0000000000800711
>  0000000800000000 ffff88046f418000 ffff88007ee51ac0 0000000081c19b60
> Call Trace:
>  [<ffffffff810ab0a6>] ? perf_event_fork+0x10/0x12
>  [<ffffffff8103d735>] ? copy_process+0xdf0/0xf9a
>  [<ffffffff8103787b>] select_task_rq+0x13/0x4a
>  [<ffffffff81038dae>] wake_up_new_task+0x39/0xdb
>  [<ffffffff8103db35>] do_fork+0x256/0x314
>  [<ffffffff810333ae>] ? dequeue_entity+0x19/0x19b
>  [<ffffffff81033213>] ? set_next_entity+0x43/0x96
>  [<ffffffff81009978>] kernel_thread+0x6b/0x6d
>  [<ffffffff81057b76>] ? kthread+0x0/0x89
>  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
>  [<ffffffff81057cd5>] kthreadd+0xd6/0x111
>  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81057bff>] ? kthreadd+0x0/0x111
>  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
> Code: ff ff ff e8 ea 8c 1b 00 3b 05 58 ec ca 00 89 c2 44 8b 85 00 ff ff ff 0f 8c 74 ff ff ff 41 8b 4c 24 08 48 c1 e3 0a 31 d2 48 89 d8 <48> f7 f1 83 7d 90 00 48 89 c1 75 16 4c 39 f8 73 0d 49 89 c7 48 
> RIP  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
>  RSP <ffff88046f869c30>
> ---[ end trace 4eaa2a86a8e2da22 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


