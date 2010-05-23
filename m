Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0EWVs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 17:48:59 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:36290 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0EWVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 17:48:57 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request
Date: Sun, 23 May 2010 23:48:54 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-gentoo-r1-ck1; KDE/4.4.3; x86_64; ; )
References: <201005231829.32106.M4rkusXXL@web.de> <201005232244.41977.M4rkusXXL@web.de> <20100523211717.GD1408@liondog.tnic>
In-Reply-To: <20100523211717.GD1408@liondog.tnic>
Cc: Borislav Petkov <bp@alien8.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GLa+LgYnCcDhR79"
Message-Id: <201005232348.54887.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+W9K2auELb3xF2zeIhilr4kbJPoK5uGkbiEkrv
	ooAMugoPe0/RLEHFLlpPzgcCeNqBew/S6Z754084RpY7XakyYw
	yNI5AMxg8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GLa+LgYnCcDhR79
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi!

Yes, this is a gentoo kernel[1]. Its vanilla kernel plus only 
fbcondecor-patch, but I will have to reboot for netconsole, so I will 
build the vanilla one.

I can resend the logs and the oops, when it happens again with vanilla.

Thanks,
Markus

[1] http://dev.gentoo.org/~mpagano/genpatches/trunk/2.6.34/

> From: Markus <M4rkusXXL@web.de>
> Date: Sun, May 23, 2010 at 10:44:41PM +0200
> 
> > It is 0000000001912178.
> > http://img256.imageshack.us/img256/4370/shotn.gif
> 
> True story, the fact that this value is not what it is expected to be
> judging from the code it happens might actually be a clue:
> 
> [64112.502507] Code: 8b bf b0 00 00 00 31 ed 48 8d 50 f0 48 85 c0 48
> 0f 45 ea 48 85 ff 74 10 48 89 ee e8 8d d3 ff ff 85 c0 0f 8e c5 00 00
> 00 48 89 eb <49> 8b bd b8 00 00 00 48 85 ff 74 10 48 89 ee e8 6e d3
> ff ff 85 All code
> ========
>    0:   8b bf b0 00 00 00       mov    0xb0(%rdi),%edi
>    6:   31 ed                   xor    %ebp,%ebp
>    8:   48 8d 50 f0             lea    -0x10(%rax),%rdx
>    c:   48 85 c0                test   %rax,%rax
>    f:   48 0f 45 ea             cmovne %rdx,%rbp
>   13:   48 85 ff                test   %rdi,%rdi
>   16:   74 10                   je     0x28
>   18:   48 89 ee                mov    %rbp,%rsi
>   1b:   e8 8d d3 ff ff          callq  0xffffffffffffd3ad
>   20:   85 c0                   test   %eax,%eax
>   22:   0f 8e c5 00 00 00       jle    0xed
>   28:   48 89 eb                mov    %rbp,%rbx
>   2b:*  49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi     <--
> trapping instruction 32:   48 85 ff                test   %rdi,%rdi
>   35:   74 10                   je     0x47
>   37:   48 89 ee                mov    %rbp,%rsi
>   3a:   e8 6e d3 ff ff          callq  0xffffffffffffd3ad
>   3f:   85                      .byte 0x85
> 
> Code starting with the faulting instruction
> ===========================================
>    0:   49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi
>    7:   48 85 ff                test   %rdi,%rdi
>    a:   74 10                   je     0x1c
>    c:   48 89 ee                mov    %rbp,%rsi
>    f:   e8 6e d3 ff ff          callq  0xffffffffffffd382
>   14:   85                      .byte 0x85
> 
> 
> and %r13 contains 00000000019129c0 in the register snapshot. Hmm...
> 
> > Serial console is no option, but this "netconsole"-thing looks
> > promising. I'll set that up and try to catch the next one with
> > this.
> 
> That'll help. Also let me make sure: Is this a vanilla kernel or are
> there any distribution patches on top of it? I see it says
> 2.6.34-gentoo but just in case. If it is not a vanilla kernel please
> try a vanilla one from kernel.org.
> 
> Also, please send the whole dmesg of the system, there might be
> something suspicious there and also the output of 'cat /proc/cpuinfo'
> and 'dmidecode', the last one run as root.
> 
> Thanks.


--Boundary-00=_GLa+LgYnCcDhR79
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.log"

[    0.000000] Linux version 2.6.34-gentoo (root@XXX) (gcc version 4.3.4 (Gentoo 4.3.4 p1.1, pie-10.1.5) ) #1 SMP Sat May 22 14:56:22 CEST 2010
[    0.000000] Command line: root=/dev/md2 vga=0x346 video=vesafb:ywarp,1680x1050-32@60
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e7000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfeb0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfeb0000 - 00000000dfec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfec0000 - 00000000dfef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000220000000 aka 8704M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfeb0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfeb0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfeb0000 page 4k
[    0.000000] kernel direct mapping tables up to dfeb0000 @ 12000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0220000000 page 2M
[    0.000000] kernel direct mapping tables up to 220000000 @ 14000-16000
[    0.000000] ACPI: RSDP 00000000000fad70 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000dfeb0000 00040 (v01 033110 RSDT2200 20100331 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dfeb0200 00084 (v01 A_M_I  OEMFACP  12000601 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20100121/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000dfeb0450 08FCB (v01  AS204 AS20417F 0000017F INTL 20051117)
[    0.000000] ACPI: FACS 00000000dfec0000 00040
[    0.000000] ACPI: APIC 00000000dfeb0390 0007C (v01 033110 APIC2200 20100331 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dfeb0410 0003C (v01 033110 OEMMCFG  20100331 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dfec0040 00072 (v01 033110 OEMB2200 20100331 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000dfeba450 00027 (v01 033110 OEMAAFT  20100331 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000dfeba480 00038 (v01 033110 OEMHPET  20100331 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000dfeba4c0 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880002000000-ffff8800091fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfeb0
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898792 pages, LIFO batch:31
[    0.000000]   Normal zone: 16128 pages used for memmap
[    0.000000]   Normal zone: 1163520 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] 6 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [15000 - 157ff]
[    0.000000] Allocating PCI resources starting at dff00000 (gap: dff00000:20000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880001800000 s76456 r8192 d21848 u524288
[    0.000000] pcpu-alloc: s76456 r8192 d21848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2066239
[    0.000000] Kernel command line: root=/dev/md2 vga=0x346 video=vesafb:ywarp,1680x1050-32@60
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] Subtract (53 early reservations)
[    0.000000]   #1 [0001000000 - 00017473e4]   TEXT DATA BSS
[    0.000000]   #2 [0001748000 - 0001748133]             BRK
[    0.000000]   #3 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #5 [000009f800 - 00000fca80]   BIOS reserved
[    0.000000]   #6 [00000fcc14 - 00000ff780]   BIOS reserved
[    0.000000]   #7 [00000fca80 - 00000fcc14]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000014000]         PGTABLE
[    0.000000]   #10 [0000014000 - 0000015000]         PGTABLE
[    0.000000]   #11 [0001748140 - 0001749140]         BOOTMEM
[    0.000000]   #12 [0001747400 - 0001747800]         BOOTMEM
[    0.000000]   #13 [0001f4a000 - 0001f4b000]         BOOTMEM
[    0.000000]   #14 [0001f4b000 - 0001f4c000]         BOOTMEM
[    0.000000]   #15 [0002000000 - 0009200000]        MEMMAP 0
[    0.000000]   #16 [0001747800 - 0001747980]         BOOTMEM
[    0.000000]   #17 [0001749140 - 0001761140]         BOOTMEM
[    0.000000]   #18 [0001761140 - 0001779140]         BOOTMEM
[    0.000000]   #19 [000177a000 - 000177b000]         BOOTMEM
[    0.000000]   #20 [0001747980 - 00017479c1]         BOOTMEM
[    0.000000]   #21 [0001747a00 - 0001747a43]         BOOTMEM
[    0.000000]   #22 [0001747a80 - 0001747cb0]         BOOTMEM
[    0.000000]   #23 [0001747cc0 - 0001747d28]         BOOTMEM
[    0.000000]   #24 [0001747d40 - 0001747da8]         BOOTMEM
[    0.000000]   #25 [0001747dc0 - 0001747e28]         BOOTMEM
[    0.000000]   #26 [0001747e40 - 0001747ea8]         BOOTMEM
[    0.000000]   #27 [0001747ec0 - 0001747f28]         BOOTMEM
[    0.000000]   #28 [0001747f40 - 0001747fa8]         BOOTMEM
[    0.000000]   #29 [0001779140 - 00017791a8]         BOOTMEM
[    0.000000]   #30 [00017791c0 - 0001779228]         BOOTMEM
[    0.000000]   #31 [0001779240 - 00017792a8]         BOOTMEM
[    0.000000]   #32 [0001747fc0 - 0001747ffb]         BOOTMEM
[    0.000000]   #33 [00017792c0 - 00017792fb]         BOOTMEM
[    0.000000]   #34 [0001800000 - 000181a000]         BOOTMEM
[    0.000000]   #35 [0001880000 - 000189a000]         BOOTMEM
[    0.000000]   #36 [0001900000 - 000191a000]         BOOTMEM
[    0.000000]   #37 [0001980000 - 000199a000]         BOOTMEM
[    0.000000]   #38 [0001779300 - 0001779308]         BOOTMEM
[    0.000000]   #39 [0001779340 - 0001779348]         BOOTMEM
[    0.000000]   #40 [0001779380 - 0001779390]         BOOTMEM
[    0.000000]   #41 [00017793c0 - 00017793e0]         BOOTMEM
[    0.000000]   #42 [0001779400 - 0001779530]         BOOTMEM
[    0.000000]   #43 [0001779540 - 0001779590]         BOOTMEM
[    0.000000]   #44 [00017795c0 - 0001779610]         BOOTMEM
[    0.000000]   #45 [000177b000 - 0001783000]         BOOTMEM
[    0.000000]   #46 [0009200000 - 0009a00000]         BOOTMEM
[    0.000000]   #47 [000199a000 - 0001d9a000]         BOOTMEM
[    0.000000]   #48 [0020000000 - 0024000000]         BOOTMEM
[    0.000000]   #49 [0009a00000 - 000da00000]         BOOTMEM
[    0.000000]   #50 [0001783000 - 00017a3000]         BOOTMEM
[    0.000000]   #51 [00017a3000 - 00017e3000]         BOOTMEM
[    0.000000]   #52 [0000015800 - 000001d800]         BOOTMEM
[    0.000000] Memory: 8118160k/8912896k available (3273k kernel code, 526084k absent, 268652k reserved, 3215k data, 460k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3200.299 MHz processor.
[    0.020004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.59 BogoMIPS (lpj=32002950)
[    0.020018] Security Framework initialized
[    0.020026] Mount-cache hash table entries: 256
[    0.020104] tseg: 0000000000
[    0.020109] CPU: Physical Processor ID: 0
[    0.020111] CPU: Processor Core ID: 0
[    0.020113] mce: CPU supports 6 MCE banks
[    0.020120] Performance Events: AMD PMU driver.
[    0.020124] ... version:                0
[    0.020125] ... bit width:              48
[    0.020126] ... generic registers:      4
[    0.020128] ... value mask:             0000ffffffffffff
[    0.020130] ... max period:             00007fffffffffff
[    0.020131] ... fixed-purpose events:   0
[    0.020133] ... event mask:             000000000000000f
[    0.020152] Freeing SMP alternatives: 28k freed
[    0.020161] ACPI: Core revision 20100121
[    0.038105] Setting APIC routing to flat
[    0.038399] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.138423] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.140000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.640003] Brought up 4 CPUs
[    0.640006] Total of 4 processors activated (25600.67 BogoMIPS).
[    0.641831] xor: automatically using best checksumming function: generic_sse
[    0.690001]    generic_sse: 12560.000 MB/sec
[    0.690003] xor: using function: generic_sse (12560.000 MB/sec)
[    0.690022] NET: Registered protocol family 16
[    0.690252] node 0 link 0: io port [1000, ffffff]
[    0.690255] TOM: 00000000e0000000 aka 3584M
[    0.690257] Fam 10h mmconf [e0000000, efffffff]
[    0.690258] node 0 link 0: mmio [a0000, bffff]
[    0.690260] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.690262] node 0 link 0: mmio [f0000000, fe6fffff]
[    0.690263] node 0 link 0: mmio [fe700000, fe8fffff]
[    0.690265] node 0 link 0: mmio [fe900000, ffefffff]
[    0.690266] TOM2: 0000000220000000 aka 8704M
[    0.690268] bus: [00, 07] on node 0 link 0
[    0.690270] bus: 00 index 0 [io  0x0000-0xffff]
[    0.690272] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.690273] bus: 00 index 2 [mem 0xf0000000-0xffffffff]
[    0.690274] bus: 00 index 3 [mem 0x220000000-0xfcffffffff]
[    0.690281] ACPI: bus type pci registered
[    0.690332] PCI: Using configuration type 1 for base access
[    0.690334] PCI: Using configuration type 1 for extended access
[    0.691853] bio: create slab <bio-0> at 0
[    0.692409] ACPI: EC: Look up EC in DSDT
[    0.693236] ACPI: Executed 4 blocks of module-level executable AML code
[    0.698617] ACPI: Interpreter enabled
[    0.698619] ACPI: (supports S0 S5)
[    0.698627] ACPI: Using IOAPIC for interrupt routing
[    0.703482] ACPI Warning: Incorrect checksum in table [OEMB] - 03, should be 02 (20100121/tbutils-314)
[    0.703560] ACPI: No dock devices found.
[    0.703563] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.703802] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.704018] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.704021] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.704023] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.704026] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.704029] pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xdfffffff]
[    0.704031] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.704112] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.704114] pci 0000:00:09.0: PME# disabled
[    0.704139] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.704141] pci 0000:00:0a.0: PME# disabled
[    0.704180] pci 0000:00:11.0: reg 10: [io  0xa000-0xa007]
[    0.704186] pci 0000:00:11.0: reg 14: [io  0x9000-0x9003]
[    0.704191] pci 0000:00:11.0: reg 18: [io  0x8000-0x8007]
[    0.704196] pci 0000:00:11.0: reg 1c: [io  0x7000-0x7003]
[    0.704202] pci 0000:00:11.0: reg 20: [io  0x6000-0x600f]
[    0.704207] pci 0000:00:11.0: reg 24: [mem 0xfe6ffc00-0xfe6fffff]
[    0.704258] pci 0000:00:12.0: reg 10: [mem 0xfe6fe000-0xfe6fefff]
[    0.704304] pci 0000:00:12.1: reg 10: [mem 0xfe6fd000-0xfe6fdfff]
[    0.704360] pci 0000:00:12.2: reg 10: [mem 0xfe6ff800-0xfe6ff8ff]
[    0.704406] pci 0000:00:12.2: supports D1 D2
[    0.704407] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.704411] pci 0000:00:12.2: PME# disabled
[    0.704436] pci 0000:00:13.0: reg 10: [mem 0xfe6fc000-0xfe6fcfff]
[    0.704483] pci 0000:00:13.1: reg 10: [mem 0xfe6f7000-0xfe6f7fff]
[    0.704539] pci 0000:00:13.2: reg 10: [mem 0xfe6ff400-0xfe6ff4ff]
[    0.704585] pci 0000:00:13.2: supports D1 D2
[    0.704586] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.704590] pci 0000:00:13.2: PME# disabled
[    0.704683] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.704688] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.704693] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.704699] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.704704] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.704757] pci 0000:00:14.2: reg 10: [mem 0xfe6f0000-0xfe6f3fff 64bit]
[    0.704794] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.704798] pci 0000:00:14.2: PME# disabled
[    0.704885] pci 0000:00:14.5: reg 10: [mem 0xfe6f6000-0xfe6f6fff]
[    0.704992] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.704995] pci 0000:01:05.0: reg 14: [io  0xb000-0xb0ff]
[    0.704997] pci 0000:01:05.0: reg 18: [mem 0xfe8f0000-0xfe8fffff]
[    0.705002] pci 0000:01:05.0: reg 24: [mem 0xfe700000-0xfe7fffff]
[    0.705011] pci 0000:01:05.0: supports D1 D2
[    0.705044] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.705048] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.705050] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    0.705053] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.705093] pci 0000:02:00.0: reg 10: [io  0xc800-0xc8ff]
[    0.705108] pci 0000:02:00.0: reg 18: [mem 0xfe9ff000-0xfe9fffff 64bit]
[    0.705123] pci 0000:02:00.0: reg 30: [mem 0xfe9c0000-0xfe9dffff pref]
[    0.705154] pci 0000:02:00.0: supports D1 D2
[    0.705155] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.705159] pci 0000:02:00.0: PME# disabled
[    0.705171] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    0.705174] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.705176] pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.705179] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.705214] pci 0000:03:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.705227] pci 0000:03:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.705236] pci 0000:03:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.705242] pci 0000:03:00.0: reg 30: [mem 0xfeae0000-0xfeafffff pref]
[    0.705267] pci 0000:03:00.0: supports D1 D2
[    0.705268] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.705271] pci 0000:03:00.0: PME# disabled
[    0.705286] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.705289] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.705291] pci 0000:00:0a.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.705294] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.705341] pci 0000:04:07.0: reg 10: [mem 0xfebff800-0xfebfffff]
[    0.705348] pci 0000:04:07.0: reg 14: [io  0xe800-0xe87f]
[    0.705401] pci 0000:04:07.0: supports D2
[    0.705402] pci 0000:04:07.0: PME# supported from D2 D3hot D3cold
[    0.705406] pci 0000:04:07.0: PME# disabled
[    0.705448] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.705452] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    0.705455] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.705459] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.705461] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.705462] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.705464] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.705465] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.705467] pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
[    0.705468] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.705479] pci_bus 0000:00: on NUMA node 0
[    0.705481] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.705605] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.705652] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.705684] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.705725] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.709263] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.709331] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.709398] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.709464] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    0.709530] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.709597] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.709665] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 *10 11 12 14 15)
[    0.709731] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.709857] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.709861] vgaarb: loaded
[    0.709942] SCSI subsystem initialized
[    0.710036] libata version 3.00 loaded.
[    0.710082] usbcore: registered new interface driver usbfs
[    0.710107] usbcore: registered new interface driver hub
[    0.710141] usbcore: registered new device driver usb
[    0.880003] raid6: int64x1   2648 MB/s
[    1.050004] raid6: int64x2   3939 MB/s
[    1.220005] raid6: int64x4   3537 MB/s
[    1.390022] raid6: int64x8   2733 MB/s
[    1.560002] raid6: sse2x1    4596 MB/s
[    1.730005] raid6: sse2x2    7781 MB/s
[    1.900009] raid6: sse2x4    8995 MB/s
[    1.900011] raid6: using algorithm sse2x4 (8995 MB/s)
[    1.900015] PCI: Using ACPI for IRQ routing
[    1.900017] PCI: pci_cache_line_size set to 64 bytes
[    1.900080] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    1.900082] reserve RAM buffer: 00000000dfeb0000 - 00000000dfffffff 
[    1.900195] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.900199] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.902216] Switching to clocksource tsc
[    1.902552] pnp: PnP ACPI init
[    1.902556] ACPI: bus type pnp registered
[    1.904911] pnp: PnP ACPI: found 13 devices
[    1.904913] ACPI: ACPI bus type pnp unregistered
[    1.904921] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.904924] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.904928] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.904930] system 00:08: [io  0x040b] has been reserved
[    1.904933] system 00:08: [io  0x04d6] has been reserved
[    1.904935] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    1.904937] system 00:08: [io  0x0c14] has been reserved
[    1.904939] system 00:08: [io  0x0c50-0x0c51] has been reserved
[    1.904941] system 00:08: [io  0x0c52] has been reserved
[    1.904944] system 00:08: [io  0x0c6c] has been reserved
[    1.904946] system 00:08: [io  0x0c6f] has been reserved
[    1.904948] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    1.904950] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    1.904953] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    1.904955] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    1.904957] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    1.904960] system 00:08: [io  0x0800-0x089f] has been reserved
[    1.904962] system 00:08: [io  0x0b00-0x0b0f] has been reserved
[    1.904964] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    1.904967] system 00:08: [io  0x0900-0x090f] has been reserved
[    1.904969] system 00:08: [io  0x0910-0x091f] has been reserved
[    1.904972] system 00:08: [io  0xfe00-0xfefe] has been reserved
[    1.904974] system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
[    1.904977] system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
[    1.904980] system 00:0a: [io  0x0280-0x028f] has been reserved
[    1.904983] system 00:0a: [io  0x0290-0x029f] has been reserved
[    1.904986] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    1.904990] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.904992] system 00:0c: [mem 0x000c0000-0x000cffff] has been reserved
[    1.904996] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.904998] system 00:0c: [mem 0x00100000-0xdfefffff] could not be reserved
[    1.905001] system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
[    1.909573] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.909576] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    1.909579] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    1.909582] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    1.909585] pci 0000:00:09.0: PCI bridge to [bus 02-02]
[    1.909588] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.909591] pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    1.909593] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    1.909596] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    1.909598] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    1.909601] pci 0000:00:0a.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    1.909604] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    1.909608] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    1.909611] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    1.909616] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    1.909620] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    1.909633] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.909636] pci 0000:00:09.0: setting latency timer to 64
[    1.909640] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.909643] pci 0000:00:0a.0: setting latency timer to 64
[    1.909648] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.909650] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.909651] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.909652] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.909654] pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
[    1.909655] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    1.909656] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    1.909657] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]
[    1.909659] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    1.909660] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    1.909662] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    1.909663] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.909664] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    1.909666] pci_bus 0000:03: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    1.909667] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    1.909668] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]
[    1.909670] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    1.909671] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    1.909672] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    1.909673] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000dffff]
[    1.909675] pci_bus 0000:04: resource 8 [mem 0xdff00000-0xdfffffff]
[    1.909676] pci_bus 0000:04: resource 9 [mem 0xf0000000-0xfebfffff]
[    1.909685] NET: Registered protocol family 2
[    1.909708] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.909708] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.909708] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.909708] TCP: Hash tables configured (established 262144 bind 65536)
[    1.909708] TCP reno registered
[    1.909708] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.909708] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.080026] pci 0000:01:05.0: Boot video device
[    2.080035] PCI: CLS 64 bytes, default 64
[    2.080232] PCI-DMA: Disabling AGP.
[    2.080328] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    2.080331] PCI-DMA: using GART IOMMU.
[    2.080333] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    2.085520] VFS: Disk quotas dquot_6.5.2
[    2.085557] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.085788] msgmni has been set to 15984
[    2.086038] alg: No test for stdrng (krng)
[    2.086045] io scheduler noop registered
[    2.086048] io scheduler deadline registered (default)
[    2.086115] pcieport 0000:00:09.0: setting latency timer to 64
[    2.086133] pcieport 0000:00:09.0: irq 24 for MSI/MSI-X
[    2.086194] pcieport 0000:00:0a.0: setting latency timer to 64
[    2.086209] pcieport 0000:00:0a.0: irq 25 for MSI/MSI-X
[    2.088025] Linux agpgart interface v0.103
[    2.088963] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90000080000, using 11550k, total 16384k
[    2.088966] vesafb: mode is 1400x1050x32, linelength=5632, pages=1
[    2.088968] vesafb: scrolling: redraw
[    2.088970] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    2.104386] Console: switching to colour frame buffer device 175x65
[    2.119687] fb0: VESA VGA frame buffer device
[    2.119856] vga16fb: initializing
[    2.119856] vga16fb: mapped to 0xffff8800000a0000
[    2.119955] fb1: VGA16 VGA frame buffer device
[    2.120139] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.120270] ACPI: Power Button [PWRB]
[    2.120362] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.120479] ACPI: Power Button [PWRF]
[    2.121644] brd: module loaded
[    2.122121] loop: module loaded
[    2.122168] Uniform Multi-Platform E-IDE driver
[    2.122287] ide-gd driver 1.18
[    2.122402] ahci 0000:00:11.0: version 3.0
[    2.122415] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.122553] ahci 0000:00:11.0: irq 26 for MSI/MSI-X
[    2.122640] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.122765] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    2.123154] scsi0 : ahci
[    2.123291] scsi1 : ahci
[    2.123389] scsi2 : ahci
[    2.123488] scsi3 : ahci
[    2.123584] scsi4 : ahci
[    2.123678] scsi5 : ahci
[    2.123770] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 26
[    2.123885] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 26
[    2.124000] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 26
[    2.124118] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 26
[    2.124235] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff00 irq 26
[    2.124352] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff80 irq 26
[    2.124606] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.124717] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.124838] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.124929] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.125069] ehci_hcd 0000:00:12.2: debug port 1
[    2.125152] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe6ff800
[    2.140016] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.140128] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.140236] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.140347] usb usb1: Product: EHCI Host Controller
[    2.140422] usb usb1: Manufacturer: Linux 2.6.34-gentoo ehci_hcd
[    2.140513] usb usb1: SerialNumber: 0000:00:12.2
[    2.140690] hub 1-0:1.0: USB hub found
[    2.140750] hub 1-0:1.0: 6 ports detected
[    2.143100] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.145554] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.147996] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.150613] ehci_hcd 0000:00:13.2: debug port 1
[    2.153204] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe6ff400
[    2.170015] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.172695] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.175455] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.178256] usb usb2: Product: EHCI Host Controller
[    2.181145] usb usb2: Manufacturer: Linux 2.6.34-gentoo ehci_hcd
[    2.184092] usb usb2: SerialNumber: 0000:00:13.2
[    2.187153] hub 2-0:1.0: USB hub found
[    2.190172] hub 2-0:1.0: 6 ports detected
[    2.193286] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.196411] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.199672] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.202985] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    2.206385] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe6fe000
[    2.264029] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.267518] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.271106] usb usb3: Product: OHCI Host Controller
[    2.274694] usb usb3: Manufacturer: Linux 2.6.34-gentoo ohci_hcd
[    2.278368] usb usb3: SerialNumber: 0000:00:12.0
[    2.282186] hub 3-0:1.0: USB hub found
[    2.285856] hub 3-0:1.0: 3 ports detected
[    2.289511] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.293284] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.296972] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    2.300664] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe6fd000
[    2.364025] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.367617] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.371221] usb usb4: Product: OHCI Host Controller
[    2.374792] usb usb4: Manufacturer: Linux 2.6.34-gentoo ohci_hcd
[    2.378395] usb usb4: SerialNumber: 0000:00:12.1
[    2.382119] hub 4-0:1.0: USB hub found
[    2.385762] hub 4-0:1.0: 3 ports detected
[    2.389351] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.393014] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.396545] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.400140] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe6fc000
[    2.464026] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.467728] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.471483] usb usb5: Product: OHCI Host Controller
[    2.475277] usb usb5: Manufacturer: Linux 2.6.34-gentoo ohci_hcd
[    2.479125] usb usb5: SerialNumber: 0000:00:13.0
[    2.483037] hub 5-0:1.0: USB hub found
[    2.486859] hub 5-0:1.0: 3 ports detected
[    2.490758] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.494760] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.498764] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    2.502904] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe6f7000
[    2.564024] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.568063] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.572164] usb usb6: Product: OHCI Host Controller
[    2.576195] usb usb6: Manufacturer: Linux 2.6.34-gentoo ohci_hcd
[    2.580258] usb usb6: SerialNumber: 0000:00:13.1
[    2.584415] hub 6-0:1.0: USB hub found
[    2.588482] hub 6-0:1.0: 3 ports detected
[    2.592550] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.596606] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.600646] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    2.604703] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe6f6000
[    2.651279] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.652534] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.652556] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.652576] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.652595] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.653775] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.653914] ata4.00: ATA-8: ST31500341AS, SD1B, max UDMA/133
[    2.653916] ata4.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.653950] ata3.00: ATA-8: ST31500341AS, SD1B, max UDMA/133
[    2.653951] ata3.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.655134] ata6.00: ATA-8: ST31500341AS, SD1B, max UDMA/133
[    2.655136] ata6.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.655622] ata4.00: configured for UDMA/133
[    2.655660] ata3.00: configured for UDMA/133
[    2.656845] ata6.00: configured for UDMA/133
[    2.664026] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.664027] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.664029] usb usb7: Product: OHCI Host Controller
[    2.664029] usb usb7: Manufacturer: Linux 2.6.34-gentoo ohci_hcd
[    2.664030] usb usb7: SerialNumber: 0000:00:14.5
[    2.664123] hub 7-0:1.0: USB hub found
[    2.664125] hub 7-0:1.0: 2 ports detected
[    2.664174] uhci_hcd: USB Universal Host Controller Interface driver
[    2.664308] PNP: No PS/2 controller found. Probing ports directly.
[    2.667034] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.667037] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.667118] mice: PS/2 mouse device common for all mice
[    2.667157] md: raid0 personality registered for level 0
[    2.667158] md: raid1 personality registered for level 1
[    2.667160] md: raid6 personality registered for level 6
[    2.667161] md: raid5 personality registered for level 5
[    2.667161] md: raid4 personality registered for level 4
[    2.667376] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    2.667410] cpuidle: using governor ladder
[    2.667442] TCP cubic registered
[    2.667522] registered taskstats version 1
[    2.681026] ata5.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    2.681028] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.681200] ata2.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    2.681201] ata2.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.722701] ata5.00: configured for UDMA/133
[    2.723198] ata2.00: configured for UDMA/133
[    2.810179] ata1.00: ATA-8: ST31500341AS, SD1B, max UDMA/133
[    2.813699] ata1.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.818940] ata1.00: configured for UDMA/133
[    2.841296] scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     SD1B PQ: 0 ANSI: 5
[    2.845116] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.845156] scsi 1:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    2.845286] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.845307] sd 1:0:0:0: [sdb] Write Protect is off
[    2.845308] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.845321] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.845353] scsi 2:0:0:0: Direct-Access     ATA      ST31500341AS     SD1B PQ: 0 ANSI: 5
[    2.845381]  sdb:
[    2.845471] sd 2:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.845514] scsi 3:0:0:0: Direct-Access     ATA      ST31500341AS     SD1B PQ: 0 ANSI: 5
[    2.845532] sd 2:0:0:0: [sdc] Write Protect is off
[    2.845533] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.845557] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.845639] sd 3:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.845656]  sdc:
[    2.845666] sd 3:0:0:0: [sdd] Write Protect is off
[    2.845667] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.845694] scsi 4:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    2.845728] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.845801]  sdd:
[    2.845860] sd 4:0:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.845879] sd 4:0:0:0: [sde] Write Protect is off
[    2.845881] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.845892] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.845916] scsi 5:0:0:0: Direct-Access     ATA      ST31500341AS     SD1B PQ: 0 ANSI: 5
[    2.845940]  sde:
[    2.846009] sd 5:0:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.846026] sd 5:0:0:0: [sdf] Write Protect is off
[    2.846027] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    2.846035] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.846081]  sdf: sdb1 sdb2 < sdb5 sdb6 sde1 sde2 < sdd1 sdd2 < sdc1 sdc2 < sdf1 sdf2 < sdb7 sdd5 sde5 sdf5 sdb8 >
[    2.948552] usb 4-1: new full speed USB device using ohci_hcd and address 2
[    2.948540]  sde6 sdf6 sdc5 sdd6
[    2.948736] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.952215]  sdf7 sdd7 sde7 sdf8 >
[    2.966536]  sde8
[    2.966573] sd 0:0:0:0: [sda] Write Protect is off
[    2.966574] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.966583] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.966721] sd 5:0:0:0: [sdf] Attached SCSI disk
[    2.984605]  >
[    2.989141]  sdd8 >
[    2.992669] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.998158]  sdc6
[    2.998214]  sda:
[    2.998407] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.011508]  sdc7 sdc8 >
[    3.019755]  sda1 sda2 <
[    3.020061] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.028735]  sda5 sda6 sda7 sda8 >
[    3.065090] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.069495] md: Waiting for all devices to be available before autodetect
[    3.073972] md: If you don't use raid, use raid=noautodetect
[    3.078564] md: Autodetecting RAID arrays.
[    3.339357] md: Scanned 24 and added 24 devices.
[    3.343944] md: autorun ...
[    3.348423] md: considering sda8 ...
[    3.352916] md:  adding sda8 ...
[    3.357335] md: sda7 has different UUID to sda8
[    3.361748] md: sda6 has different UUID to sda8
[    3.366165] md: sda5 has different UUID to sda8
[    3.370514] md:  adding sdc8 ...
[    3.374844] md: sdc7 has different UUID to sda8
[    3.379165] md: sdc6 has different UUID to sda8
[    3.383409] md: sdc5 has different UUID to sda8
[    3.387571] md:  adding sdd8 ...
[    3.391654] md: sdd7 has different UUID to sda8
[    3.395739] md: sdd6 has different UUID to sda8
[    3.399727] md: sdd5 has different UUID to sda8
[    3.403651] md:  adding sde8 ...
[    3.407467] md: sde7 has different UUID to sda8
[    3.411312] md: sde6 has different UUID to sda8
[    3.415064] md: sde5 has different UUID to sda8
[    3.418741] md:  adding sdf8 ...
[    3.422360] md: sdf7 has different UUID to sda8
[    3.425997] md: sdf6 has different UUID to sda8
[    3.429505] md: sdf5 has different UUID to sda8
[    3.432940] md:  adding sdb8 ...
[    3.436334] md: sdb7 has different UUID to sda8
[    3.439733] md: sdb6 has different UUID to sda8
[    3.443051] md: sdb5 has different UUID to sda8
[    3.446334] md: created md4
[    3.449438] md: bind<sdb8>
[    3.452524] md: bind<sdf8>
[    3.455536] md: bind<sde8>
[    3.458446] md: bind<sdd8>
[    3.461286] md: bind<sdc8>
[    3.464054] md: bind<sda8>
[    3.466723] md: running: <sda8><sdc8><sdd8><sde8><sdf8><sdb8>
[    3.469538] raid5: device sda8 operational as raid disk 2
[    3.472196] raid5: device sdc8 operational as raid disk 1
[    3.474794] raid5: device sdd8 operational as raid disk 3
[    3.477296] raid5: device sde8 operational as raid disk 5
[    3.479735] raid5: device sdf8 operational as raid disk 0
[    3.482362] raid5: allocated 6372kB for md4
[    3.484844] 2: w=1 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
[    3.487239] 1: w=2 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
[    3.489600] 3: w=3 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
[    3.491872] 5: w=4 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
[    3.494147] 0: w=5 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
[    3.496405] raid5: raid level 6 set md4 active with 5 out of 6 devices, algorithm 2
[    3.498715] RAID5 conf printout:
[    3.500986]  --- rd:6 wd:5
[    3.505723]  disk 0, o:1, dev:sdf8
[    3.508108]  disk 1, o:1, dev:sdc8
[    3.510466]  disk 2, o:1, dev:sda8
[    3.512829]  disk 3, o:1, dev:sdd8
[    3.515095]  disk 5, o:1, dev:sde8
[    3.520675] md4: bitmap initialized from disk: read 11/11 pages, set 2299 bits
[    3.523011] created bitmap (173 pages) for device md4
[    3.535962] md4: detected capacity change from 0 to 5918647648256
[    3.538313] md: considering sda7 ...
[    3.538315] RAID5 conf printout:
[    3.538317]  --- rd:6 wd:5
[    3.538318]  disk 0, o:1, dev:sdf8
[    3.538319]  disk 1, o:1, dev:sdc8
[    3.538320]  disk 2, o:1, dev:sda8
[    3.538321]  disk 3, o:1, dev:sdd8
[    3.538321]  disk 4, o:1, dev:sdb8
[    3.538322]  disk 5, o:1, dev:sde8
[    3.538388] md: recovery of RAID array md4
[    3.538389] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[    3.538390] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[    3.538392] md: using 128k window, over a total of 1444982336 blocks.
[    3.566184] md:  adding sda7 ...
[    3.568434] md: sda6 has different UUID to sda7
[    3.570698] md: sda5 has different UUID to sda7
[    3.573007] md:  adding sdc7 ...
[    3.575300] md: sdc6 has different UUID to sda7
[    3.577624] md: sdc5 has different UUID to sda7
[    3.579898] md:  adding sdd7 ...
[    3.582190] md: sdd6 has different UUID to sda7
[    3.584557] md: sdd5 has different UUID to sda7
[    3.586863] md:  adding sde7 ...
[    3.589164] md: sde6 has different UUID to sda7
[    3.591500] md: sde5 has different UUID to sda7
[    3.593856] md:  adding sdf7 ...
[    3.596161] md: sdf6 has different UUID to sda7
[    3.598491] md: sdf5 has different UUID to sda7
[    3.600820] md:  adding sdb7 ...
[    3.603198] md: sdb6 has different UUID to sda7
[    3.605570] md: sdb5 has different UUID to sda7
[    3.607979] md: created md3
[    3.610323] md: bind<sdb7>
[    3.612700] md: bind<sdf7>
[    3.615021] md: bind<sde7>
[    3.617345] md: bind<sdd7>
[    3.619667] md: bind<sdc7>
[    3.621972] md: bind<sda7>
[    3.624312] md: running: <sda7><sdc7><sdd7><sde7><sdf7><sdb7>
[    3.637004] raid5: device sda7 operational as raid disk 2
[    3.639564] raid5: device sdc7 operational as raid disk 1
[    3.642128] raid5: device sdd7 operational as raid disk 3
[    3.644729] raid5: device sde7 operational as raid disk 4
[    3.647232] raid5: device sdf7 operational as raid disk 0
[    3.649906] raid5: allocated 5322kB for md3
[    3.652444] 2: w=1 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    3.655011] 1: w=2 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    3.657568] 3: w=3 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    3.660134] 4: w=4 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    3.662634] 0: w=5 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    3.665028] raid5: raid level 6 set md3 active with 5 out of 5 devices, algorithm 2
[    3.667509] RAID5 conf printout:
[    3.669981]  --- rd:5 wd:5
[    3.672373]  disk 0, o:1, dev:sdf7
[    3.674858]  disk 1, o:1, dev:sdc7
[    3.677298]  disk 2, o:1, dev:sda7
[    3.679713]  disk 3, o:1, dev:sdd7
[    3.682107]  disk 4, o:1, dev:sde7
[    3.701428] md3: bitmap initialized from disk: read 9/9 pages, set 0 bits
[    3.703864] created bitmap (129 pages) for device md3
[    3.711011] usb 4-1.4: new full speed USB device using ohci_hcd and address 4
[    3.731986] md3: detected capacity change from 0 to 12905152512
[    3.734529] md: considering sda6 ...
[    3.737002] md:  adding sda6 ...
[    3.739456] md: sda5 has different UUID to sda6
[    3.741994] md:  adding sdc6 ...
[    3.744595] md: sdc5 has different UUID to sda6
[    3.747160] md:  adding sdd6 ...
[    3.749732] md: sdd5 has different UUID to sda6
[    3.752396] md:  adding sde6 ...
[    3.755068] md: sde5 has different UUID to sda6
[    3.757697] md:  adding sdf6 ...
[    3.760255] md: sdf5 has different UUID to sda6
[    3.762786] md:  adding sdb6 ...
[    3.765233] md: sdb5 has different UUID to sda6
[    3.767879] md: created md2
[    3.770383] md: bind<sdb6>
[    3.772911] md: bind<sdf6>
[    3.775354] md: bind<sde6>
[    3.777812] md: bind<sdd6>
[    3.780236] md: bind<sdc6>
[    3.782648] md: bind<sda6>
[    3.785011] md: running: <sda6><sdc6><sdd6><sde6><sdf6><sdb6>
[    3.787596] raid5: device sda6 operational as raid disk 2
[    3.790086] raid5: device sdc6 operational as raid disk 1
[    3.792616] raid5: device sdd6 operational as raid disk 3
[    3.795052] raid5: device sdf6 operational as raid disk 0
[    3.797658] raid5: allocated 4272kB for md2
[    3.800124] 2: w=1 pa=0 pr=4 m=2 a=2 r=4 op1=0 op2=0
[    3.802636] 1: w=2 pa=0 pr=4 m=2 a=2 r=4 op1=0 op2=0
[    3.805058] 3: w=3 pa=0 pr=4 m=2 a=2 r=4 op1=0 op2=0
[    3.807492] 0: w=4 pa=0 pr=4 m=2 a=2 r=4 op1=0 op2=0
[    3.809894] raid5: raid level 6 set md2 active with 4 out of 4 devices, algorithm 2
[    3.812439] RAID5 conf printout:
[    3.814957]  --- rd:4 wd:4
[    3.817501]  disk 0, o:1, dev:sdf6
[    3.820057]  disk 1, o:1, dev:sdc6
[    3.822802]  disk 2, o:1, dev:sda6
[    3.825411]  disk 3, o:1, dev:sdd6
[    3.849537] md2: bitmap initialized from disk: read 15/15 pages, set 50 bits
[    3.852120] created bitmap (225 pages) for device md2
[    3.882850] md2: detected capacity change from 0 to 15052046336
[    3.885571] md: considering sda5 ...
[    3.888289] md:  adding sda5 ...
[    3.891049] md:  adding sdc5 ...
[    3.893781] md:  adding sdd5 ...
[    3.896509] md:  adding sde5 ...
[    3.899169] md:  adding sdf5 ...
[    3.901814] md:  adding sdb5 ...
[    3.904576] md: created md1
[    3.907217] md: bind<sdb5>
[    3.909782] md: bind<sdf5>
[    3.912303] md: bind<sde5>
[    3.914805] md: bind<sdd5>
[    3.917254] md: bind<sdc5>
[    3.919702] md: bind<sda5>
[    3.922154] md: running: <sda5><sdc5><sdd5><sde5><sdf5><sdb5>
[    3.924864] raid1: raid set md1 active with 4 out of 4 mirrors
[    3.931471] md1: bitmap initialized from disk: read 9/9 pages, set 2048 bits
[    3.934127] created bitmap (129 pages) for device md1
[    3.950546] md1: detected capacity change from 0 to 8595308544
[    3.953203] md: ... autorun DONE.
[    3.955795]  md2: unknown partition table
[    3.959431] EXT3-fs (md2): recovery required on readonly filesystem
[    3.962038] EXT3-fs (md2): write access will be enabled during recovery
[    4.490169] kjournald starting.  Commit interval 5 seconds
[    4.490171] EXT3-fs (md2): orphan cleanup on readonly fs
[    4.490176] ext3_orphan_cleanup: deleting unreferenced inode 732969
[    4.490191] ext3_orphan_cleanup: deleting unreferenced inode 732968
[    4.490194] ext3_orphan_cleanup: deleting unreferenced inode 732967
[    4.490197] ext3_orphan_cleanup: deleting unreferenced inode 732966
[    4.490200] ext3_orphan_cleanup: deleting unreferenced inode 732965
[    4.490202] EXT3-fs (md2): 5 orphan inodes deleted
[    4.490203] EXT3-fs (md2): recovery complete
[    4.537017] EXT3-fs (md2): mounted filesystem with ordered data mode
[    4.539745] VFS: Mounted root (ext3 filesystem) readonly on device 9:2.
[    4.542556] Freeing unused kernel memory: 460k freed
[    4.545407] Write protecting the kernel read-only data: 6144k
[    4.548272] Freeing unused kernel memory: 804k freed
[    4.551319] Freeing unused kernel memory: 556k freed
[    5.212512] NET: Registered protocol family 1
[    6.216151] udev: starting version 149
[    6.285392] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.285417] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    6.285430] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.285443] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    6.285456] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    6.285469] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    6.287396] EDAC MC: Ver: 2.1.0 May 22 2010
[    6.313219]  md3:
[    6.313251]  md4:
[    6.313300]  md1:
[    6.318183] rtc_cmos 00:03: RTC can wake from S4
[    6.318216] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.318240] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.321685]  unknown partition table
[    6.332833] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.332848] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.332897] r8169 0000:02:00.0: setting latency timer to 64
[    6.332945] r8169 0000:02:00.0: irq 27 for MSI/MSI-X
[    6.333003] r8169 0000:02:00.0: eth0: RTL8168b/8111b at 0xffffc90000ce4000, 00:08:54:56:4f:3e, XID 18000000 IRQ 27
[    6.333071]  unknown partition table
[    6.334387] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.334395] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.334413] r8169 0000:03:00.0: setting latency timer to 64
[    6.334416] r8169 0000:03:00.0: (unregistered net_device): unknown MAC, using family default
[    6.334446] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    6.334486] r8169 0000:03:00.0: eth1: RTL8168b/8111b at 0xffffc90000068000, 00:08:54:56:4f:3e, XID 083000c0 IRQ 28
[    6.338106] EDAC amd64_edac:  Ver: 3.3.0 May 22 2010
[    6.338124] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[    6.338128] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    6.338129]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    6.338130]  (Note that use of the override may cause unknown side effects.)
[    6.338133] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    6.338847]  unknown partition table
[    6.453643] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.453747] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.490230] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.022888] EXT3-fs (md2): using internal journal
[    7.276268] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
[    7.276299] powernow-k8:    0 : pstate 0 (3200 MHz)
[    7.276300] powernow-k8:    1 : pstate 1 (2500 MHz)
[    7.276301] powernow-k8:    2 : pstate 2 (2100 MHz)
[    7.276302] powernow-k8:    3 : pstate 3 (800 MHz)
[    7.328159] fuse init (API version 7.13)
[    7.402559] md: md0 stopped.
[    7.415095] md: bind<sdc1>
[    7.416345] md: bind<sda1>
[    7.416576] md: bind<sdd1>
[    7.416762] md: bind<sde1>
[    7.417374] md: bind<sdb1>
[    7.418025] md: bind<sdf1>
[    7.418669] raid1: raid set md0 active with 6 out of 6 mirrors
[    7.419812] md0: bitmap initialized from disk: read 2/2 pages, set 0 bits
[    7.419813] created bitmap (26 pages) for device md0
[    7.438655] md0: detected capacity change from 0 to 213712896
[    7.439222]  md0: unknown partition table
[   11.729436] kjournald starting.  Commit interval 5 seconds
[   11.752886] EXT3-fs (md3): using internal journal
[   11.752886] EXT3-fs (md3): mounted filesystem with ordered data mode
[   11.838492] kjournald starting.  Commit interval 5 seconds
[   11.839501] EXT3-fs (md4): using internal journal
[   11.839504] EXT3-fs (md4): mounted filesystem with ordered data mode
[   11.897785] Adding 8393852k swap on /dev/md1.  Priority:-1 extents:1 across:8393852k 
[   16.120764] r8169 0000:02:00.0: eth0: link up
[   16.120752] r8169 0000:02:00.0: eth0: link up
[   16.423539] r8169 0000:03:00.0: eth1: link up
[   16.423525] r8169 0000:03:00.0: eth1: link up
[   17.726153] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.736524] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   17.736628] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   17.736629] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   17.736631] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   25.121441] w83627ehf: Found W83627EHG chip at 0x290
[   25.224217] w83627ehf w83627ehf.656: fan3 low limit and alarm disabled
[   25.609571] bonding: Ethernet Channel Bonding Driver: v3.6.0 (September 26, 2009)
[   25.609574] bonding: MII link monitoring set to 100 ms
[   25.742788] r8169 0000:02:00.0: eth0: link up
[   25.744028] bonding: bond0: enslaving eth0 as an active interface with an up link.
[   25.842782] r8169 0000:03:00.0: eth1: link up
[   25.844011] bonding: bond0: enslaving eth1 as an active interface with an up link.
[   26.914539] NET: Registered protocol family 17
[   45.898234] TCP highspeed registered

--Boundary-00=_GLa+LgYnCcDhR79
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmidecode.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmidecode.log"

# dmidecode 2.10
SMBIOS 2.5 present.
30 structures occupying 1428 bytes.
Table at 0x000FC480.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: P1.80
	Release Date: 03/31/2010
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 8.15

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: To Be Filled By O.E.M.
	Product Name: To Be Filled By O.E.M.
	Version: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	UUID: 00020003-0004-0005-0006-000700080009
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASRock
	Product Name: M3A790GXH/128M
	Version:                       
	Serial Number:                       
	Asset Tag:                       
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis:                       
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: To Be Filled By O.E.M.
	Type: Desktop
	Lock: Not Present
	Version: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPUSocket
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: AMD              
	ID: 42 0F 10 00 FF FB 8B 17
	Version: AMD Phenom(tm) II X4 955 Processor                  
	Voltage: 1.5 V
	External Clock: 200 MHz
	Max Speed: 3200 MHz
	Current Speed: 3200 MHz
	Status: Populated, Enabled
	Upgrade: Socket 940
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 4
	Core Enabled: 4
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 512 kB
	Maximum Size: 512 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 2048 kB
	Maximum Size: 2048 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 5, 24 bytes
Memory Controller Information
	Error Detecting Method: 64-bit ECC
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 2048 MB
	Maximum Total Memory Size: 8192 MB
	Supported Speeds:
		70 ns
		60 ns
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 3.3 V
	Associated Memory Slots: 4
		0x0008
		0x0009
		0x000A
		0x000B
	Enabled Error Correcting Capabilities:
		None

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM0
	Bank Connections: 0 7
	Current Speed: 161 ns
	Type: ECC DIMM
	Installed Size: 4096 MB (Double-bank Connection)
	Enabled Size: 4096 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM1
	Bank Connections: 0 7
	Current Speed: 163 ns
	Type: ECC DIMM
	Installed Size: 4096 MB (Double-bank Connection)
	Enabled Size: 4096 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM2
	Bank Connections: 0
	Current Speed: Unknown
	Type: Other
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000B, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM3
	Bank Connections: 0
	Current Speed: Unknown
	Type: Other
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000C, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000E, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE1
	Type: x1 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 17
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000F, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE2
	Type: x16 PCI Express
	Current Usage: Available
	Length: Short
	ID: 18
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0010, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE3
	Type: x8 PCI Express
	Current Usage: Available
	Length: Short
	ID: 19
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0011, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE4
	Type: x4 PCI Express
	Current Usage: Available
	Length: Short
	ID: 20
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0012, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0013, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0021FFFFFFF
	Range Size: 8704 MB
	Physical Array Handle: 0x0012
	Partition Width: 0

Handle 0x0014, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: Not Provided
	Total Width: 84 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK0
	Type: Other
	Type Detail: Synchronous
	Speed: 667 MHz
	Manufacturer: Manufacturer0
	Serial Number: SerNum0
	Asset Tag: AssetTagNum0
	Part Number: PartNum0

Handle 0x0015, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0014
	Memory Array Mapped Address Handle: 0x0013
	Partition Row Position: 1

Handle 0x0016, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: Not Provided
	Total Width: 189 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: Other
	Type Detail: Synchronous
	Speed: 667 MHz
	Manufacturer: Manufacturer1
	Serial Number: SerNum1
	Asset Tag: AssetTagNum1
	Part Number: PartNum1

Handle 0x0017, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0016
	Memory Array Mapped Address Handle: 0x0013
	Partition Row Position: 1

Handle 0x0018, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: Other
	Set: None
	Locator: DIMM2
	Bank Locator: BANK2
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: Manufacturer2
	Serial Number: SerNum2
	Asset Tag: AssetTagNum2
	Part Number: PartNum2

Handle 0x0019, DMI type 126, 19 bytes
Inactive

Handle 0x001A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0012
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: Other
	Set: None
	Locator: DIMM3
	Bank Locator: BANK3
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: Manufacturer3
	Serial Number: SerNum3
	Asset Tag: AssetTagNum3
	Part Number: PartNum3

Handle 0x001B, DMI type 126, 19 bytes
Inactive

Handle 0x001C, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x001D, DMI type 127, 4 bytes
End Of Table


--Boundary-00=_GLa+LgYnCcDhR79--
