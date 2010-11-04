Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab0KDO3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:29:21 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47397 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab0KDO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:29:18 -0400
Date: Thu, 4 Nov 2010 08:28:53 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: divide error in select_task_rq_fair()
Message-ID: <20101104142853.GA11656@helgaas.com>
References: <20101104041236.GA9389@helgaas.com>
 <1288847992.2718.37.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288847992.2718.37.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 06:19:52AM +0100, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 22:12 -0600, Bjorn Helgaas a écrit :
> > Hi,
> > 
> > With current upstream, I see the following crash at boot-time:
> > 
> >     Brought up 64 CPUs
> >     Total of 64 processors activated (289366.52 BogoMIPS).
> >     divide error: 0000 [#1] SMP 
> >     last sysfs file: 
> >     CPU 1 
> >     Modules linked in:
> > 
> >     Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #271 /ProLiant DL980 G7
> >     RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
> > 
> > Complete dmesg below; let me know if you need more info.
> 
> Is the machine runs OK if you build a kernel with NR_CPUS=128 ?

Nope, it fails the same way with NR_CPUS=128.  Dmesg below.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc1-00027-gff8b16d (helgaas@bob) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #280 SMP Thu Nov 4 08:16:47 MDT 2010
[    0.000000] Command line: console=ttyS0,115200n8 ignore_loglevel printk.time=0 root=/dev/cciss/c0d1p1 BOOT_IMAGE=kernel 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000095400 (usable)
[    0.000000]  BIOS-e820: 0000000000095400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f600000 (usable)
[    0.000000]  BIOS-e820: 000000007f600000 - 000000007f62c000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f62c000 - 000000007f62d000 (usable)
[    0.000000]  BIOS-e820: 000000007f62d000 - 000000007f79d000 (reserved)
[    0.000000]  BIOS-e820: 000000007f79d000 - 000000007f7a0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f7a0000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000480000000 (usable)
[    0.000000]  BIOS-e820: 0000002000000000 - 0000002400000000 (usable)
[    0.000000]  BIOS-e820: 0000004000000000 - 0000004400000000 (usable)
[    0.000000]  BIOS-e820: 0000006000000000 - 0000006400000000 (usable)
[    0.000000]  BIOS-e820: 0000008000000000 - 0000008200000000 (usable)
[    0.000000]  BIOS-e820: 000000a000000000 - 000000a200000000 (usable)
[    0.000000]  BIOS-e820: 000000c000000000 - 000000c200000000 (usable)
[    0.000000]  BIOS-e820: 000000e000000000 - 000000e200000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: /ProLiant DL980 G7, BIOS P66 07/07/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xe200000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x7f62d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f62d000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f62d000 page 4k
[    0.000000] kernel direct mapping tables up to 7f62d000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000e200000000
[    0.000000]  0100000000 - e200000000 page 2M
[    0.000000] kernel direct mapping tables up to e200000000 @ 7f276000-7f600000
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000007f6022c0 000C4 (v01 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: FACP 000000007f6023c0 000F4 (v03 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20101013/tbfadt-607)
[    0.000000] ACPI: DSDT 000000007f6024c0 029E0 (v01 HP         DSDT 00000001 INTL 20030228)
[    0.000000] ACPI: FACS 000000007f600140 00040
[    0.000000] ACPI: SPCR 000000007f600180 00050 (v01 HP     SPCRRBSU 00000001   Ò? 0000162E)
[    0.000000] ACPI: MCFG 000000007f600200 0003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 000000007f600240 00038 (v01 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: FFFF 000000007f600280 00064 (v02 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: SPMI 000000007f600300 00040 (v05 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: ERST 000000007f600340 001D0 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: APIC 000000007f600540 00476 (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT 000000007f6009c0 012B0 (v01 HP     Proliant 00000001   Ò? 0000162E)
[    0.000000] ACPI: FFFF 000000007f601c80 00176 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: BERT 000000007f601e00 00030 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: HEST 000000007f601e40 000BC (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: DMAR 000000007f601f00 00224 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: SLIT 000000007f602240 0006C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: SSDT 000000007f604ea0 00CD4 (v01 HP        SSDT1 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f605b80 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 000000007f605cc0 00076 (v03     HP  CRSPCI1 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 000000007f605d40 00D7B (v01     HP      pcc 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f606ac0 00377 (v01     HP     pmab 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f606e40 13824 (v01  INTEL PPM RCM  80000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] ACPI: [SRAT:0x00] ignored 128 entries of 256 found
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
[    0.000000] SRAT: Node 1 PXM 1 2000000000-2400000000
[    0.000000] SRAT: Node 2 PXM 2 4000000000-4400000000
[    0.000000] SRAT: Node 3 PXM 3 6000000000-6400000000
[    0.000000] SRAT: Node 4 PXM 4 8000000000-8200000000
[    0.000000] SRAT: Node 5 PXM 5 a000000000-a200000000
[    0.000000] SRAT: Node 6 PXM 6 c000000000-c200000000
[    0.000000] SRAT: Node 7 PXM 7 e000000000-e200000000
[    0.000000] SRAT: Node 0 [0,80000000) + [100000000,480000000) -> [0,480000000)
[    0.000000] NUMA: Using 37 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000480000000
[    0.000000]   NODE_DATA [000000047fffb000 - 000000047fffffff]
[    0.000000] Initmem setup node 1 0000002000000000-0000002400000000
[    0.000000]   NODE_DATA [00000023ffffb000 - 00000023ffffffff]
[    0.000000] Initmem setup node 2 0000004000000000-0000004400000000
[    0.000000]   NODE_DATA [00000043ffffb000 - 00000043ffffffff]
[    0.000000] Initmem setup node 3 0000006000000000-0000006400000000
[    0.000000]   NODE_DATA [00000063ffffb000 - 00000063ffffffff]
[    0.000000] Initmem setup node 4 0000008000000000-0000008200000000
[    0.000000]   NODE_DATA [00000081ffffb000 - 00000081ffffffff]
[    0.000000] Initmem setup node 5 000000a000000000-000000a200000000
[    0.000000]   NODE_DATA [000000a1ffffb000 - 000000a1ffffffff]
[    0.000000] Initmem setup node 6 000000c000000000-000000c200000000
[    0.000000]   NODE_DATA [000000c1ffffb000 - 000000c1ffffffff]
[    0.000000] Initmem setup node 7 000000e000000000-000000e200000000
[    0.000000]   NODE_DATA [000000e1ffffa000 - 000000e1ffffefff]
[    0.000000]  [ffffea0000000000-ffffea000fbfffff] PMD -> [ffff88046fe00000-ffff88047ddfffff] on node 0
[    0.000000]  [ffffea0070000000-ffffea007dffffff] PMD -> [ffff8823efe00000-ffff8823fddfffff] on node 1
[    0.000000]  [ffffea00e0000000-ffffea00edffffff] PMD -> [ffff8843efe00000-ffff8843fddfffff] on node 2
[    0.000000]  [ffffea0150000000-ffffea015dffffff] PMD -> [ffff8863efe00000-ffff8863fddfffff] on node 3
[    0.000000]  [ffffea01c0000000-ffffea01c6ffffff] PMD -> [ffff8881f7e00000-ffff8881fedfffff] on node 4
[    0.000000]  [ffffea0230000000-ffffea0236ffffff] PMD -> [ffff88a1f7e00000-ffff88a1fedfffff] on node 5
[    0.000000]  [ffffea02a0000000-ffffea02a6ffffff] PMD -> [ffff88c1f7e00000-ffff88c1fedfffff] on node 6
[    0.000000]  [ffffea0310000000-ffffea0316ffffff] PMD -> [ffff88e1f7e00000-ffff88e1fedfffff] on node 7
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0e200000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[11] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000095
[    0.000000]     0: 0x00000100 -> 0x0007f600
[    0.000000]     0: 0x0007f62c -> 0x0007f62d
[    0.000000]     0: 0x00100000 -> 0x00480000
[    0.000000]     1: 0x02000000 -> 0x02400000
[    0.000000]     2: 0x04000000 -> 0x04400000
[    0.000000]     3: 0x06000000 -> 0x06400000
[    0.000000]     4: 0x08000000 -> 0x08200000
[    0.000000]     5: 0x0a000000 -> 0x0a200000
[    0.000000]     6: 0x0c000000 -> 0x0c200000
[    0.000000]     7: 0x0e000000 -> 0x0e200000
[    0.000000] On node 0 totalpages: 4191622
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 503353 pages, LIFO batch:31
[    0.000000]   Normal zone: 50176 pages used for memmap
[    0.000000]   Normal zone: 3619840 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x80] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x82] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x84] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x86] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x90] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x92] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x94] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x96] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0xa0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0xa2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0xa4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0xa6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0xb0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0xb2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0xb4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5e] lapic_id[0xb6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x60] lapic_id[0xc0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x62] lapic_id[0xc2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x64] lapic_id[0xc4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x66] lapic_id[0xc6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x68] lapic_id[0xd0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6a] lapic_id[0xd2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6c] lapic_id[0xd4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6e] lapic_id[0xd6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x70] lapic_id[0xe0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x72] lapic_id[0xe2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x74] lapic_id[0xe4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x76] lapic_id[0xe6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x78] lapic_id[0xf0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7a] lapic_id[0xf2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7c] lapic_id[0xf4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7e] lapic_id[0xf6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x81] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x83] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x85] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x87] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x91] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x93] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x95] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x97] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0xa1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0xa3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0xa5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0xa7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0xb1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0xb3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0xb5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5f] lapic_id[0xb7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x61] lapic_id[0xc1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x63] lapic_id[0xc3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x65] lapic_id[0xc5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x67] lapic_id[0xc7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x69] lapic_id[0xd1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xd3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xd5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xd7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x71] lapic_id[0xe1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x73] lapic_id[0xe3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x75] lapic_id[0xe5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x77] lapic_id[0xe7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x79] lapic_id[0xf1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7b] lapic_id[0xf3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7d] lapic_id[0xf5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7f] lapic_id[0xf7] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec08000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec08000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec10000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec10000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 128 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 0000000000095000 - 0000000000096000
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007f600000 - 000000007f62c000
[    0.000000] PM: Registered nosave memory: 000000007f62d000 - 000000007f79d000
[    0.000000] PM: Registered nosave memory: 000000007f79d000 - 000000007f7a0000
[    0.000000] PM: Registered nosave memory: 000000007f7a0000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000480000000 - 0000002000000000
[    0.000000] PM: Registered nosave memory: 0000002400000000 - 0000004000000000
[    0.000000] PM: Registered nosave memory: 0000004400000000 - 0000006000000000
[    0.000000] PM: Registered nosave memory: 0000006400000000 - 0000008000000000
[    0.000000] PM: Registered nosave memory: 0000008200000000 - 000000a000000000
[    0.000000] PM: Registered nosave memory: 000000a200000000 - 000000c000000000
[    0.000000] PM: Registered nosave memory: 000000c200000000 - 000000e000000000
[    0.000000] Allocating PCI resources starting at 90000000 (gap: 90000000:6ec00000)
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:128 nr_node_ids:8
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007ec00000 s75712 r8192 d22592 u262144
[    0.000000] pcpu-alloc: s75712 r8192 d22592 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 
[    0.000000] pcpu-alloc: [0] 032 040 048 056 064 065 066 067 
[    0.000000] pcpu-alloc: [0] 068 069 070 071 096 104 112 120 
[    0.000000] pcpu-alloc: [1] 008 009 010 011 012 013 014 015 
[    0.000000] pcpu-alloc: [1] 033 041 049 057 072 073 074 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 097 105 113 121 
[    0.000000] pcpu-alloc: [2] 016 017 018 019 020 021 022 023 
[    0.000000] pcpu-alloc: [2] 034 042 050 058 080 081 082 083 
[    0.000000] pcpu-alloc: [2] 084 085 086 087 098 106 114 122 
[    0.000000] pcpu-alloc: [3] 024 025 026 027 028 029 030 031 
[    0.000000] pcpu-alloc: [3] 035 043 051 059 088 089 090 091 
[    0.000000] pcpu-alloc: [3] 092 093 094 095 099 107 115 123 
[    0.000000] pcpu-alloc: [4] 036 044 052 060 100 108 116 124 
[    0.000000] pcpu-alloc: [5] 037 045 053 061 101 109 117 125 
[    0.000000] pcpu-alloc: [6] 038 046 054 062 102 110 118 126 
[    0.000000] pcpu-alloc: [7] 039 047 055 063 103 111 119 127 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 24811904
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=ttyS0,115200n8 ignore_loglevel printk.time=0 root=/dev/cciss/c0d1p1 BOOT_IMAGE=kernel 
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 99180716k/947912704k available (6288k kernel code, 847260136k absent, 1471852k reserved, 6949k data, 628k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=128, Nodes=8
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:8448 nr_irqs:2520 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2260.976 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.95 BogoMIPS (lpj=2260976)
pid_max: default: 131072 minimum: 1024
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys freezer
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 22 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20101013
DMAR: Host address width 40
DMAR: DRHD base: 0x000000ac000000 flags: 0x0
IOMMU 0: reg_base_addr ac000000 ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: DRHD base: 0x000000a8000000 flags: 0x1
IOMMU 1: reg_base_addr a8000000 ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: RMRR base: 0x0000007f7ee000 end: 0x0000007f7effff
DMAR: RMRR base: 0x0000007f7e7000 end: 0x0000007f7ecfff
DMAR: RMRR base: 0x0000007f62e000 end: 0x0000007f62ffff
DMAR: ATSR flags: 0x0
DMAR: ATSR flags: 0x0
Not enabling x2apic, Intr-remapping init failed.
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 06
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
Booting Node   2, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
Booting Node   3, Processors  #24 #25 #26 #27 #28 #29 #30 #31 Ok.
Booting Node   0, Processors  #32 Ok.
Booting Node   1, Processors  #33 Ok.
Booting Node   2, Processors  #34 Ok.
Booting Node   3, Processors  #35 Ok.
Booting Node   4, Processors  #36 Ok.
Booting Node   5, Processors  #37 Ok.
Booting Node   6, Processors  #38 Ok.
Booting Node   7, Processors  #39 Ok.
Booting Node   0, Processors  #40 Ok.
Booting Node   1, Processors  #41 Ok.
Booting Node   2, Processors  #42 Ok.
Booting Node   3, Processors  #43 Ok.
Booting Node   4, Processors  #44 Ok.
Booting Node   5, Processors  #45 Ok.
Booting Node   6, Processors  #46 Ok.
Booting Node   7, Processors  #47 Ok.
Booting Node   0, Processors  #48 Ok.
Booting Node   1, Processors  #49 Ok.
Booting Node   2, Processors  #50 Ok.
Booting Node   3, Processors  #51 Ok.
Booting Node   4, Processors  #52 Ok.
Booting Node   5, Processors  #53 Ok.
Booting Node   6, Processors  #54 Ok.
Booting Node   7, Processors  #55 Ok.
Booting Node   0, Processors  #56 Ok.
Booting Node   1, Processors  #57 Ok.
Booting Node   2, Processors  #58 Ok.
Booting Node   3, Processors  #59 Ok.
Booting Node   4, Processors  #60 Ok.
Booting Node   5, Processors  #61 Ok.
Booting Node   6, Processors  #62 Ok.
Booting Node   7, Processors  #63 Ok.
Booting Node   0, Processors  #64 #65 #66 #67 #68 #69 #70 #71 Ok.
Booting Node   1, Processors  #72 #73 #74 #75 #76 #77 #78 #79 Ok.
Booting Node   2, Processors  #80 #81 #82 #83 #84 #85 #86 #87 Ok.
Booting Node   3, Processors  #88 #89 #90 #91 #92 #93 #94 #95 Ok.
Booting Node   0, Processors  #96 Ok.
Booting Node   1, Processors  #97 Ok.
Booting Node   2, Processors  #98 Ok.
Booting Node   3, Processors  #99 Ok.
Booting Node   4, Processors  #100 Ok.
Booting Node   5, Processors  #101 Ok.
Booting Node   6, Processors  #102 Ok.
Booting Node   7, Processors  #103 Ok.
Booting Node   0, Processors  #104 Ok.
Booting Node   1, Processors  #105 Ok.
Booting Node   2, Processors  #106 Ok.
Booting Node   3, Processors  #107 Ok.
Booting Node   4, Processors  #108 Ok.
Booting Node   5, Processors  #109 Ok.
Booting Node   6, Processors  #110 Ok.
Booting Node   7, Processors  #111 Ok.
Booting Node   0, Processors  #112 Ok.
Booting Node   1, Processors  #113 Ok.
Booting Node   2, Processors  #114 Ok.
Booting Node   3, Processors  #115 Ok.
Booting Node   4, Processors  #116 Ok.
Booting Node   5, Processors  #117 Ok.
Booting Node   6, Processors  #118 Ok.
Booting Node   7, Processors  #119 Ok.
Booting Node   0, Processors  #120 Ok.
Booting Node   1, Processors  #121 Ok.
Booting Node   2, Processors  #122 Ok.
Booting Node   3, Processors  #123 Ok.
Booting Node   4, Processors  #124 Ok.
Booting Node   5, Processors  #125 Ok.
Booting Node   6, Processors  #126 Ok.
Booting Node   7, Processors  #127 Ok.
Brought up 128 CPUs
Total of 128 processors activated (578731.16 BogoMIPS).
divide error: 0000 [#1] SMP 
last sysfs file: 
CPU 64 
Modules linked in:

Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #280 /ProLiant DL980 G7
RIP: 0010:[<ffffffff81034598>]  [<ffffffff81034598>] select_task_rq_fair+0x62d/0x7a6
RSP: 0000:ffff88046f875c30  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000080
RBP: ffff88046f875d30 R08: 0000000000000000 R09: ffff88046f62e5e0
R10: 0000000000000000 R11: 0000000000000080 R12: ffff88046f62e5c0
R13: ffff88007ef0da90 R14: ffff88046f62e5d0 R15: 0000000000011b80
FS:  0000000000000000(0000) GS:ffff88007ef00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kthreadd (pid: 2, threadinfo ffff88046f874000, task ffff8881f6c40750)
Stack:
 ffff88046f875c70 0000000000011b80 0000000000011b80 0000000000011b80
 0000000000011b80 0000000000011b88 0000000000011b88 0000000000800711
 0000000800000000 ffff88046f7d8000 ffff88007ef11b80 0000000081c19b60
Call Trace:
 [<ffffffff810ab773>] ? perf_event_fork+0x10/0x12
 [<ffffffff8103da84>] ? copy_process+0xdf0/0xf9a
 [<ffffffff81037b55>] select_task_rq+0x13/0x49
 [<ffffffff810390da>] wake_up_new_task+0x39/0xdb
 [<ffffffff8103de84>] do_fork+0x256/0x314
 [<ffffffff810332f9>] ? dequeue_entity+0x19/0x19b
 [<ffffffff8103315e>] ? set_next_entity+0x43/0x96
 [<ffffffff81009994>] kernel_thread+0x6b/0x6d
 [<ffffffff81057f42>] ? kthread+0x0/0x89
 [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff810580a1>] kthreadd+0xd6/0x111
 [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
 [<ffffffff81057fcb>] ? kthreadd+0x0/0x111
 [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
Code: 80 00 00 00 4c 89 f7 48 63 d2 e8 2c 95 1b 00 3b 05 fe f0 ca 00 89 c2 0f 8c 7b ff ff ff 41 8b 4c 24 08 48 c1 e3 0a 31 d2 48 89 d8 <48> f7 f1 83 7d 98 00 48 89 c1 75 18 48 3b 45 c8 73 0e 48 89 45 
RIP  [<ffffffff81034598>] select_task_rq_fair+0x62d/0x7a6
 RSP <ffff88046f875c30>
---[ end trace 4eaa2a86a8e2da22 ]---
