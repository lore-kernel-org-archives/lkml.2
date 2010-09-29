Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0I2V3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:29:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42611 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0I2V3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HWjkn6mcDF25tjT4ssPHoN8hAK+0KbGA7rzVtT9pzBBEWkfIJJ1T4/YLa1ss4T1H06
         jmK+hOA1oE+W+Q8n/hFIyLT+bK6Cmkt0UErMldU6Hjx6stc7oASb7mhZ3cILvwFdqzyN
         JZjWpyzYwiMneTKPwf0EOqIRSRcXSLYwsrHeA=
Date: Thu, 30 Sep 2010 00:29:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jglisse@redhat.com, airlied@redhat.com
Subject: 2.6.36-rc6: WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235
 radeon_fence_wait+0x35a/0x3c0
Message-ID: <20100929212923.GA5578@core2.telecom.by>
References: <AANLkTik85bCi5S=w7sk3EZ-oNK4CLME=+G0fEkSN0+c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik85bCi5S=w7sk3EZ-oNK4CLME=+G0fEkSN0+c0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caught GPU lockup.
Minor graphic glitches/freeze, switched to console, then back,
and everything is fine.

[ 2899.600041] radeon 0000:01:00.0: GPU lockup CP stall for more than 102158msec
[ 2899.600047] ------------[ cut here ]------------
[ 2899.600055] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x35a/0x3c0()
[ 2899.600059] Hardware name: P5E
[ 2899.600062] GPU lockup (waiting for 0x00032018 last fence id 0x0003200C)
[ 2899.600067] Pid: 4391, comm: X Not tainted 2.6.36-rc6 #21
[ 2899.600070] Call Trace:
[ 2899.600078]  [<ffffffff8103bf85>] warn_slowpath_common+0x75/0xb0
[ 2899.600083]  [<ffffffff8103c061>] warn_slowpath_fmt+0x41/0x50
[ 2899.600088]  [<ffffffff81250d7a>] radeon_fence_wait+0x35a/0x3c0
[ 2899.600094]  [<ffffffff810587e0>] ? autoremove_wake_function+0x0/0x40
[ 2899.600099]  [<ffffffff812515ac>] radeon_sync_obj_wait+0xc/0x10
[ 2899.600105]  [<ffffffff8121afef>] ttm_bo_wait+0xff/0x1c0
[ 2899.600110]  [<ffffffff81266b92>] radeon_gem_wait_idle_ioctl+0x92/0x110
[ 2899.600116]  [<ffffffff812076fb>] drm_ioctl+0x42b/0x4e0
[ 2899.600121]  [<ffffffff81266b00>] ? radeon_gem_wait_idle_ioctl+0x0/0x110
[ 2899.600126]  [<ffffffff810bfa22>] ? do_sync_read+0xd2/0x110
[ 2899.600132]  [<ffffffff810cf531>] do_vfs_ioctl+0xa1/0x5a0
[ 2899.600137]  [<ffffffff8100235c>] ? sysret_check+0x27/0x62
[ 2899.600142]  [<ffffffff810cfa7a>] sys_ioctl+0x4a/0x80
[ 2899.600147]  [<ffffffff8100232b>] system_call_fastpath+0x16/0x1b
[ 2899.600151] ---[ end trace 767cb5c7224449ce ]---
[ 2899.768826] Failed to wait GUI idle while programming pipes. Bad things might happen.
[ 2899.769959] radeon 0000:01:00.0: (r300_asic_reset:415) RBBM_STATUS=0x84110140
[ 2900.274454] radeon 0000:01:00.0: (r300_asic_reset:434) RBBM_STATUS=0x80010140
[ 2900.775569] radeon 0000:01:00.0: (r300_asic_reset:446) RBBM_STATUS=0x00000140
[ 2900.775610] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100403, writing 0x100407)
[ 2900.775646] radeon 0000:01:00.0: GPU reset succeed
[ 2900.775650] radeon 0000:01:00.0: GPU reset succeed
[ 2900.775656] radeon 0000:01:00.0: ffff8800bf96e6c0 unpin not necessary
[ 2900.880873] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[ 2900.882065] [drm] PCIE GART of 512M enabled (table at 0xF0040000).
[ 2900.882089] [drm] radeon: ring at 0x00000000D0000000
[ 2900.882111] [drm] ring test succeeded in 0 usecs
[ 2900.882181] [drm] ib test succeeded in 1 usecs

01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] [1002:5b60] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Extreme AX300SE-X [1043:002a]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 40
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at b000 [size=256]
	Region 2: Memory at fe8e0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at fe8c0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <128ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4151
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: radeon

01:00.1 Display controller [0380]: ATI Technologies Inc RV370 [Radeon X300SE] [1002:5b70]
	Subsystem: ASUSTeK Computer Inc. Device [1043:002b]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Region 0: Memory at fe8f0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <128ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

[    0.000000] Linux version 2.6.36-rc6 (ad@core2) (gcc version 4.4.3 (Gentoo 4.4.3-r2 p1.2) ) #21 SMP PREEMPT Wed Sep 29 22:50:35 EEST 2010
[    0.000000] Command line: root=/dev/sdb1 ignore_loglevel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff80000 (usable)
[    0.000000]  BIOS-e820: 00000000bff80000 - 00000000bff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bff8e000 - 00000000bffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bffe0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xbff80 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff80000
[    0.000000]  0000000000 - 00bff80000 page 4k
[    0.000000] kernel direct mapping tables up to bff80000 @ 100000-704000
[    0.000000] ACPI: RSDP 00000000000fbe10 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bff80100 00054 (v01 A_M_I_ OEMXSDT  04000807 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bff80290 000F4 (v03 A_M_I_ OEMFACP  04000807 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bff80440 0A05A (v01  A0905 A0905002 00000002 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bff8e000 00040
[    0.000000] ACPI: APIC 00000000bff80390 0006C (v01 A_M_I_ OEMAPIC  04000807 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bff80400 0003C (v01 A_M_I_ OEMMCFG  04000807 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bff8e040 00081 (v01 A_M_I_ AMI_OEM  04000807 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bff8a4a0 00038 (v01 A_M_I_ OEMHPET  04000807 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bff8a4e0 000B0 (v01 A_M_I_ OEMOSFR  04000807 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00029fffff] PMD -> [ffff880002c00000-ffff8800055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bff80
[    0.000000] On node 0 totalpages: 786205
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10695 pages used for memmap
[    0.000000]   DMA32 zone: 771513 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] early_res array is doubled to 64 at [3000 - 37ff]
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880002400000 s79168 r0 d23232 u1048576
[    0.000000] pcpu-alloc: s79168 r0 d23232 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 775454
[    0.000000] Kernel command line: root=/dev/sdb1 ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (40 early reservations)
[    0.000000]   #1 [0001000000 - 000227e020]   TEXT DATA BSS
[    0.000000]   #2 [000009ec00 - 0000100000]   BIOS reserved
[    0.000000]   #3 [000227f000 - 000227f278]             BRK
[    0.000000]   #4 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #5 [0000100000 - 0000702000]         PGTABLE
[    0.000000]   #6 [000227f280 - 0002280280]         BOOTMEM
[    0.000000]   #7 [000227e040 - 000227e1c0]         BOOTMEM
[    0.000000]   #8 [0002a81000 - 0002a82000]         BOOTMEM
[    0.000000]   #9 [0002a82000 - 0002a83000]         BOOTMEM
[    0.000000]   #10 [0002c00000 - 0005600000]        MEMMAP 0
[    0.000000]   #11 [000227e1c0 - 000227e5c0]         BOOTMEM
[    0.000000]   #12 [0002280280 - 00022c0280]         BOOTMEM
[    0.000000]   #13 [00022c1000 - 00022c2000]         BOOTMEM
[    0.000000]   #14 [000227e5c0 - 000227e601]         BOOTMEM
[    0.000000]   #15 [000227e640 - 000227e683]         BOOTMEM
[    0.000000]   #16 [000227e6c0 - 000227e928]         BOOTMEM
[    0.000000]   #17 [000227e940 - 000227e9a8]         BOOTMEM
[    0.000000]   #18 [000227e9c0 - 000227ea28]         BOOTMEM
[    0.000000]   #19 [000227ea40 - 000227eaa8]         BOOTMEM
[    0.000000]   #20 [000227eac0 - 000227eb28]         BOOTMEM
[    0.000000]   #21 [000227eb40 - 000227eba8]         BOOTMEM
[    0.000000]   #22 [000227ebc0 - 000227ec28]         BOOTMEM
[    0.000000]   #23 [000227ec40 - 000227eca8]         BOOTMEM
[    0.000000]   #24 [000227ecc0 - 000227ed28]         BOOTMEM
[    0.000000]   #25 [000227ed40 - 000227eda8]         BOOTMEM
[    0.000000]   #26 [000227edc0 - 000227ee28]         BOOTMEM
[    0.000000]   #27 [000227ee40 - 000227ee5f]         BOOTMEM
[    0.000000]   #28 [000227ee80 - 000227ee9f]         BOOTMEM
[    0.000000]   #29 [0002400000 - 0002419000]         BOOTMEM
[    0.000000]   #30 [0002500000 - 0002519000]         BOOTMEM
[    0.000000]   #31 [000227eec0 - 000227eec8]         BOOTMEM
[    0.000000]   #32 [000227ef00 - 000227ef08]         BOOTMEM
[    0.000000]   #33 [000227ef40 - 000227ef48]         BOOTMEM
[    0.000000]   #34 [000227ef80 - 000227ef90]         BOOTMEM
[    0.000000]   #35 [00022c0280 - 00022c03c0]         BOOTMEM
[    0.000000]   #36 [00022c03c0 - 00022c0420]         BOOTMEM
[    0.000000]   #37 [00022c2000 - 00022ca000]         BOOTMEM
[    0.000000]   #38 [0002519000 - 0002919000]         BOOTMEM
[    0.000000]   #39 [0005600000 - 0005800000]         BOOTMEM
[    0.000000] Memory: 3070060k/3145216k available (4504k kernel code, 396k absent, 74760k reserved, 4460k data, 464k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2137.993 MHz processor.
[    0.001015] Calibrating delay loop (skipped), value calculated using timer frequency.. 4275.98 BogoMIPS (lpj=2137993)
[    0.001088] pid_max: default: 32768 minimum: 301
[    0.001214] Mount-cache hash table entries: 256
[    0.002250] CPU: Physical Processor ID: 0
[    0.002286] CPU: Processor Core ID: 0
[    0.002321] mce: CPU supports 6 MCE banks
[    0.002362] CPU0: Thermal monitoring enabled (TM2)
[    0.002401] using mwait in idle threads.
[    0.002435] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
[    0.002553] PEBS disabled due to CPU errata.
[    0.002593] ... version:                2
[    0.002627] ... bit width:              40
[    0.002661] ... generic registers:      2
[    0.002696] ... value mask:             000000ffffffffff
[    0.003004] ... max period:             000000007fffffff
[    0.003040] ... fixed-purpose events:   3
[    0.003074] ... event mask:             0000000700000003
[    0.003140] debug: unmapping init memory ffffffff81937000..ffffffff8193b000
[    0.003199] ACPI: Core revision 20100702
[    0.033183] Setting APIC routing to flat
[    0.033575] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043680] CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
[    0.045367] NMI watchdog enabled, takes one hw-pmu counter.
[    0.047026] lockdep: fixing up alternatives.
[    0.048145] Booting Node   0, Processors  #1 Ok.
[    0.120101] NMI watchdog enabled, takes one hw-pmu counter.
[    0.121017] Brought up 2 CPUs
[    0.121056] Total of 2 processors activated (8552.26 BogoMIPS).
[    0.123356] NET: Registered protocol family 16
[    0.124156] ACPI: bus type pci registered
[    0.125116] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.125162] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.187922] PCI: Using configuration type 1 for base access
[    0.211125] bio: create slab <bio-0> at 0
[    0.218512] ACPI: EC: Look up EC in DSDT
[    0.225131] ACPI: Executed 1 blocks of module-level executable AML code
[    0.265405] ACPI: SSDT 00000000bff8e0d0 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.267094] ACPI: Dynamic OEM Table Load:
[    0.267182] ACPI: SSDT (null) 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.268607] ACPI: SSDT 00000000bff8e2b0 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.270257] ACPI: Dynamic OEM Table Load:
[    0.270345] ACPI: SSDT (null) 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.270651] ACPI: Interpreter enabled
[    0.270686] ACPI: (supports S0 S5)
[    0.270811] ACPI: Using IOAPIC for interrupt routing
[    0.319214] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.320090] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.321208] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.321257] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.321296] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.321340] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.321383] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    0.321601] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.321641] pci 0000:00:01.0: PME# disabled
[    0.321798] pci 0000:00:1a.0: reg 20: [io  0xa800-0xa81f]
[    0.321957] pci 0000:00:1a.1: reg 20: [io  0xa880-0xa89f]
[    0.322124] pci 0000:00:1a.2: reg 20: [io  0xac00-0xac1f]
[    0.322264] pci 0000:00:1a.7: reg 10: [mem 0xfe7ffc00-0xfe7fffff]
[    0.322401] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.322441] pci 0000:00:1a.7: PME# disabled
[    0.322529] pci 0000:00:1b.0: reg 10: [mem 0xfe7f8000-0xfe7fbfff 64bit]
[    0.322646] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.322686] pci 0000:00:1b.0: PME# disabled
[    0.322826] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.322866] pci 0000:00:1c.0: PME# disabled
[    0.323159] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.323199] pci 0000:00:1c.2: PME# disabled
[    0.323345] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.323385] pci 0000:00:1c.4: PME# disabled
[    0.323514] pci 0000:00:1d.0: reg 20: [io  0xa080-0xa09f]
[    0.323682] pci 0000:00:1d.1: reg 20: [io  0xa400-0xa41f]
[    0.323842] pci 0000:00:1d.2: reg 20: [io  0xa480-0xa49f]
[    0.324007] pci 0000:00:1d.7: reg 10: [mem 0xfe7ff800-0xfe7ffbff]
[    0.324145] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.324185] pci 0000:00:1d.7: PME# disabled
[    0.324432] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.324477] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.324518] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.324643] pci 0000:00:1f.2: reg 10: [io  0x9c00-0x9c07]
[    0.324689] pci 0000:00:1f.2: reg 14: [io  0x9880-0x9883]
[    0.324734] pci 0000:00:1f.2: reg 18: [io  0x9800-0x9807]
[    0.324779] pci 0000:00:1f.2: reg 1c: [io  0x9480-0x9483]
[    0.324825] pci 0000:00:1f.2: reg 20: [io  0x9400-0x941f]
[    0.324870] pci 0000:00:1f.2: reg 24: [mem 0xfe7fe800-0xfe7fefff]
[    0.324954] pci 0000:00:1f.2: PME# supported from D3hot
[    0.324993] pci 0000:00:1f.2: PME# disabled
[    0.325062] pci 0000:00:1f.3: reg 10: [mem 0xfe7ff400-0xfe7ff4ff 64bit]
[    0.325128] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.325278] pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.325324] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    0.325369] pci 0000:01:00.0: reg 18: [mem 0xfe8e0000-0xfe8effff]
[    0.325442] pci 0000:01:00.0: reg 30: [mem 0xfe8c0000-0xfe8dffff pref]
[    0.325505] pci 0000:01:00.0: supports D1 D2
[    0.325580] pci 0000:01:00.1: reg 10: [mem 0xfe8f0000-0xfe8fffff]
[    0.325693] pci 0000:01:00.1: supports D1 D2
[    0.325746] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.325844] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.325883] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.325923] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.325964] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.326065] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.326104] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.326145] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.326193] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.326350] pci 0000:03:00.0: reg 10: [mem 0xfeafc000-0xfeafffff 64bit]
[    0.326401] pci 0000:03:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.326491] pci 0000:03:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
[    0.326579] pci 0000:03:00.0: supports D1 D2
[    0.326614] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.326655] pci 0000:03:00.0: PME# disabled
[    0.328045] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.328089] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.328133] pci 0000:00:1c.2:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.328189] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.328350] pci 0000:02:00.0: reg 10: [io  0xcc00-0xcc07]
[    0.328401] pci 0000:02:00.0: reg 14: [io  0xc880-0xc883]
[    0.328452] pci 0000:02:00.0: reg 18: [io  0xc800-0xc807]
[    0.328504] pci 0000:02:00.0: reg 1c: [io  0xc480-0xc483]
[    0.328555] pci 0000:02:00.0: reg 20: [io  0xc400-0xc40f]
[    0.328622] pci 0000:02:00.0: reg 30: [mem 0xfe9f0000-0xfe9fffff pref]
[    0.328717] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.328775] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.328814] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.328853] pci 0000:00:1c.4:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.328897] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.329025] pci 0000:05:01.0: reg 10: [io  0xe800-0xe8ff]
[    0.329074] pci 0000:05:01.0: reg 14: [mem 0xfebffc00-0xfebffcff]
[    0.329167] pci 0000:05:01.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.329228] pci 0000:05:01.0: supports D1 D2
[    0.329263] pci 0000:05:01.0: PME# supported from D1 D2 D3hot D3cold
[    0.329303] pci 0000:05:01.0: PME# disabled
[    0.329387] pci 0000:05:03.0: reg 10: [mem 0xfebff000-0xfebff7ff]
[    0.329435] pci 0000:05:03.0: reg 14: [io  0xec00-0xec7f]
[    0.329552] pci 0000:05:03.0: supports D2
[    0.329587] pci 0000:05:03.0: PME# supported from D2 D3hot D3cold
[    0.329627] pci 0000:05:03.0: PME# disabled
[    0.329721] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.329761] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.329801] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.329844] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.329888] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.329931] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.329974] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.330005] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.330049] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.330120] pci_bus 0000:00: on NUMA node 0
[    0.330161] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.331718] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.332080] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.332928] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.333284] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.333627] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.410309] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.411657] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.412300] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.412906] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.413747] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.414402] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.415038] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.415642] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.416211] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.416221] vgaarb: loaded
[    0.417246] SCSI subsystem initialized
[    0.417246] libata version 3.00 loaded.
[    0.418061] usbcore: registered new interface driver usbfs
[    0.418161] usbcore: registered new interface driver hub
[    0.418161] usbcore: registered new device driver usb
[    0.419117] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.419511] PCI: Using ACPI for IRQ routing
[    0.419547] PCI: pci_cache_line_size set to 64 bytes
[    0.420198] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.420239] reserve RAM buffer: 00000000bff80000 - 00000000bfffffff 
[    0.421232] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.421305] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.421472] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.425147] Switching to clocksource tsc
[    0.425359] pnp: PnP ACPI init
[    0.425416] ACPI: bus type pnp registered
[    0.435957] pnp: PnP ACPI: found 15 devices
[    0.435994] ACPI: ACPI bus type pnp unregistered
[    0.436056] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.436108] system 00:06: [io  0x0290-0x0297] has been reserved
[    0.436157] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.436196] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.436235] system 00:07: [io  0x0480-0x04bf] has been reserved
[    0.436274] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.436313] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.436353] system 00:07: [mem 0xfed50000-0xfed8ffff] has been reserved
[    0.436392] system 00:07: [mem 0xffa00000-0xffafffff] has been reserved
[    0.436432] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.436471] system 00:07: [mem 0xffe00000-0xffefffff] has been reserved
[    0.436511] system 00:07: [mem 0xfff00000-0xfffffffe] has been reserved
[    0.436560] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    0.436613] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.436654] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.436711] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.436774] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.436814] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    0.436857] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.436900] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.455052] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc03fffff]
[    0.455095] pci 0000:00:1c.2: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.455142] pci 0000:00:1c.4: BAR 9: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.455187] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.455227] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.455264] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
[    0.455304] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.455344] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.455390] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.455428] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.455469] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
[    0.455509] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.455556] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.455594] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.455634] pci 0000:00:1c.2:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.455674] pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.455722] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.455760] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.455801] pci 0000:00:1c.4:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.455848] pci 0000:00:1c.4:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.455897] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.455934] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.455975] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.456014] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.456074] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.456114] pci 0000:00:01.0: setting latency timer to 64
[    0.456159] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.456201] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.456242] pci 0000:00:1c.0: setting latency timer to 64
[    0.456290] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.456330] pci 0000:00:1c.2: setting latency timer to 64
[    0.456376] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.456416] pci 0000:00:1c.4: setting latency timer to 64
[    0.456459] pci 0000:00:1e.0: setting latency timer to 64
[    0.456498] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.456534] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.456571] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.456608] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.456645] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xffffffff]
[    0.456682] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.456719] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.456756] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.456798] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.456841] pci_bus 0000:04: resource 1 [mem 0xc0000000-0xc03fffff]
[    0.456878] pci_bus 0000:04: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.456920] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.456956] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.456993] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.457035] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.457071] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.457108] pci_bus 0000:02: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.457150] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    0.457186] pci_bus 0000:05: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.457223] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.457259] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.457295] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.457332] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.457369] pci_bus 0000:05: resource 8 [mem 0xc0000000-0xffffffff]
[    0.457505] NET: Registered protocol family 2
[    0.457735] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.458701] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.461250] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.466318] TCP: Hash tables configured (established 262144 bind 65536)
[    0.466402] TCP reno registered
[    0.466451] UDP hash table entries: 2048 (order: 6, 262144 bytes)
[    0.466830] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
[    0.467414] NET: Registered protocol family 1
[    0.467735] pci 0000:01:00.0: Boot video device
[    0.467815] PCI: CLS 32 bytes, default 64
[    0.470762] microcode: CPU0 sig=0x6f2, pf=0x1, revision=0x5a
[    0.470815] microcode: CPU1 sig=0x6f2, pf=0x1, revision=0x5a
[    0.471000] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.491376] msgmni has been set to 5996
[    0.491507] io scheduler noop registered
[    0.491905] io scheduler cfq registered (default)
[    0.493216] intel_idle: MWAIT substates: 0x20
[    0.493252] intel_idle: does not run on family 6 model 15
[    0.493538] ACPI: acpi_idle registered with cpuidle
[    0.495570] Real Time Clock Driver v1.12b
[    0.496291] [drm] Initialized drm 1.1.0 20060810
[    0.496474] [drm] radeon defaulting to kernel modesetting.
[    0.496511] [drm] radeon kernel modesetting enabled.
[    0.496619] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.496661] radeon 0000:01:00.0: setting latency timer to 64
[    0.500836] [drm] initializing kernel modesetting (RV380 0x1002:0x5B60).
[    0.501008] [drm] register mmio base: 0xFE8E0000
[    0.501045] [drm] register mmio size: 65536
[    0.501283] [drm] Generation 2 PCI interface, using max accessible memory
[    0.501324] radeon 0000:01:00.0: VRAM: 128M 0xF0000000 - 0xF7FFFFFF (128M used)
[    0.501367] radeon 0000:01:00.0: GTT: 512M 0xD0000000 - 0xEFFFFFFF
[    0.501483] radeon 0000:01:00.0: irq 40 for MSI/MSI-X
[    0.501525] radeon 0000:01:00.0: radeon: using MSI.
[    0.501674] [drm] radeon: irq initialized.
[    0.502320] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.502363] [drm] RAM width 64bits DDR
[    0.502603] [TTM] Zone  kernel: Available graphics memory: 1535030 kiB.
[    0.502641] [TTM] Initializing pool allocator.
[    0.502873] [drm] radeon: 128M of VRAM memory ready
[    0.502910] [drm] radeon: 512M of GTT memory ready.
[    0.502948] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.503642] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[    0.504677] [drm] PCIE GART of 512M enabled (table at 0xF0040000).
[    0.504971] [drm] Loading R300 Microcode
[    0.505762] [drm] radeon: ring at 0x00000000D0000000
[    0.505850] [drm] ring test succeeded in 1 usecs
[    0.506345] [drm] radeon: ib pool ready.
[    0.506455] [drm] ib test succeeded in 0 usecs
[    0.507364] [drm] DFP table revision: 4
[    0.507702] [drm] Default TV standard: NTSC
[    0.507737] [drm] 27.000000000 MHz TV ref clk
[    0.507778] [drm] Default TV standard: NTSC
[    0.507858] [drm] 27.000000000 MHz TV ref clk
[    0.508159] [drm] Radeon Display Connectors
[    0.508194] [drm] Connector 0:
[    0.508227] [drm]   DVI-I
[    0.508260] [drm]   HPD1
[    0.508294] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    0.508330] [drm]   Encoders:
[    0.508363] [drm]     CRT1: INTERNAL_DAC1
[    0.508397] [drm]     DFP1: INTERNAL_TMDS1
[    0.508431] [drm] Connector 1:
[    0.508465] [drm]   S-video
[    0.508497] [drm]   Encoders:
[    0.508530] [drm]     TV1: INTERNAL_DAC2
[    0.634876] [drm] fb mappable at 0xF00C0000
[    0.634912] [drm] vram apper at 0xF0000000
[    0.634946] [drm] size 5242880
[    0.634980] [drm] fb depth is 24
[    0.635013] [drm]    pitch is 5120
[    0.696496] Console: switching to colour frame buffer device 160x64
[    0.701527] fb0: radeondrmfb frame buffer device
[    0.701560] drm: registered panic notifier
[    0.701614] [drm] Initialized radeon 2.6.0 20080528 for 0000:01:00.0 on minor 0
[    0.702489] ahci 0000:00:1f.2: version 3.0
[    0.702563] ahci 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    0.702665] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.702804] ahci: SSS flag set, parallel bus scan disabled
[    0.702879] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.702934] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
[    0.702997] ahci 0000:00:1f.2: setting latency timer to 64
[    0.713206] scsi0 : ahci
[    0.714176] scsi1 : ahci
[    0.714609] scsi2 : ahci
[    0.715022] scsi3 : ahci
[    0.715424] scsi4 : ahci
[    0.715833] scsi5 : ahci
[    0.716250] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 41
[    0.716303] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 41
[    0.716357] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 41
[    0.716414] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 41
[    0.716467] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 41
[    0.716517] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 41
[    0.717131] sky2: driver version 1.28
[    0.717210] sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.717269] sky2 0000:03:00.0: setting latency timer to 64
[    0.717347] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 3
[    0.717507] sky2 0000:03:00.0: irq 42 for MSI/MSI-X
[    0.718694] sky2 0000:03:00.0: eth0: addr 00:22:15:87:07:fc
[    0.718862] PPP generic driver version 2.4.2
[    0.719304] PPP Deflate Compression module registered
[    0.719345] PPP BSD Compression module registered
[    0.719411] 8139too: 8139too Fast Ethernet driver 0.9.28
[    0.719472] 8139too 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.720612] 8139too 0000:05:01.0: eth1: RealTek RTL8139 at 0xffffc9000006cc00, 00:80:48:2e:06:2e, IRQ 17
[    0.720805] console [netcon0] enabled
[    0.720833] netconsole: network logging started
[    0.720917] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.721054] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.721122] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.722496] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.723950] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.725402] ehci_hcd 0000:00:1a.7: debug port 1
[    0.730662] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.732116] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
[    0.743075] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.744656] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.746065] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.747492] usb usb1: Product: EHCI Host Controller
[    0.748918] usb usb1: Manufacturer: Linux 2.6.36-rc6 ehci_hcd
[    0.750363] usb usb1: SerialNumber: 0000:00:1a.7
[    0.752469] hub 1-0:1.0: USB hub found
[    0.753928] hub 1-0:1.0: 6 ports detected
[    0.755626] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.757155] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.758638] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.760138] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.761706] ehci_hcd 0000:00:1d.7: debug port 1
[    0.767106] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.768696] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
[    0.780187] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.781830] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.783379] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.784944] usb usb2: Product: EHCI Host Controller
[    0.786505] usb usb2: Manufacturer: Linux 2.6.36-rc6 ehci_hcd
[    0.788049] usb usb2: SerialNumber: 0000:00:1d.7
[    0.790014] hub 2-0:1.0: USB hub found
[    0.791575] hub 2-0:1.0: 6 ports detected
[    0.793386] uhci_hcd: USB Universal Host Controller Interface driver
[    0.795202] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.796772] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.798349] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.799873] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.801461] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    0.803108] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.804597] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.806145] usb usb3: Product: UHCI Host Controller
[    0.807695] usb usb3: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.809256] usb usb3: SerialNumber: 0000:00:1a.0
[    0.811260] hub 3-0:1.0: USB hub found
[    0.812881] hub 3-0:1.0: 2 ports detected
[    0.814623] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.816216] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.817816] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.819447] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.821124] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    0.822879] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.824516] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.826134] usb usb4: Product: UHCI Host Controller
[    0.827754] usb usb4: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.829379] usb usb4: SerialNumber: 0000:00:1a.1
[    0.831482] hub 4-0:1.0: USB hub found
[    0.833132] hub 4-0:1.0: 2 ports detected
[    0.834925] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.836578] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.838197] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.839834] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.841493] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
[    0.843255] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.844857] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.846470] usb usb5: Product: UHCI Host Controller
[    0.848059] usb usb5: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.849645] usb usb5: SerialNumber: 0000:00:1a.2
[    0.851652] hub 5-0:1.0: USB hub found
[    0.853257] hub 5-0:1.0: 2 ports detected
[    0.854992] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.856598] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.858204] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.859803] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.861445] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
[    0.863206] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.864809] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.866398] usb usb6: Product: UHCI Host Controller
[    0.867989] usb usb6: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.869589] usb usb6: SerialNumber: 0000:00:1d.0
[    0.871578] hub 6-0:1.0: USB hub found
[    0.873199] hub 6-0:1.0: 2 ports detected
[    0.874980] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.876596] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.878200] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.879813] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.881482] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    0.883214] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.884843] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.886470] usb usb7: Product: UHCI Host Controller
[    0.888059] usb usb7: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.889677] usb usb7: SerialNumber: 0000:00:1d.1
[    0.891700] hub 7-0:1.0: USB hub found
[    0.893336] hub 7-0:1.0: 2 ports detected
[    0.895070] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.896878] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.898513] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.900138] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.901787] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
[    0.903514] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.905146] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.906770] usb usb8: Product: UHCI Host Controller
[    0.908396] usb usb8: Manufacturer: Linux 2.6.36-rc6 uhci_hcd
[    0.910007] usb usb8: SerialNumber: 0000:00:1d.2
[    0.912028] hub 8-0:1.0: USB hub found
[    0.913637] hub 8-0:1.0: 2 ports detected
[    0.915608] usbcore: registered new interface driver usblp
[    0.917233] Initializing USB Mass Storage driver...
[    0.919022] usbcore: registered new interface driver usb-storage
[    0.920636] USB Mass Storage support registered.
[    0.922380] usbcore: registered new interface driver ums-alauda
[    0.924136] usbcore: registered new interface driver ums-cypress
[    0.925884] usbcore: registered new interface driver ums-datafab
[    0.927635] usbcore: registered new interface driver ums-freecom
[    0.929352] usbcore: registered new interface driver ums-isd200
[    0.931063] usbcore: registered new interface driver ums-jumpshot
[    0.932768] usbcore: registered new interface driver ums-karma
[    0.934447] usbcore: registered new interface driver ums-onetouch
[    0.936074] usbcore: registered new interface driver ums-sddr09
[    0.937699] usbcore: registered new interface driver ums-sddr55
[    0.939306] usbcore: registered new interface driver ums-usbat
[    0.941099] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.942607] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.945062] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.947079] mice: PS/2 mouse device common for all mice
[    0.948793] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.950386] ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f] conflicts with ACPI region SMRG [io  0x0400-0x040f pref window disabled]
[    0.951974] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.954092] coretemp coretemp.0: TjMax is assumed as 100 C!
[    0.956138] coretemp coretemp.1: TjMax is assumed as 100 C!
[    0.958254] EDAC MC: Ver: 2.1.0 Sep 29 2010
[    0.961591] EDAC MC0: Giving out device to 'x38_edac' 'x38': DEV 0000:00:00.0
[    0.963480] cpuidle: using governor ladder
[    0.965102] cpuidle: using governor menu
[    0.971250] usbcore: registered new interface driver hiddev
[    0.972999] usbcore: registered new interface driver usbhid
[    0.974600] usbhid: USB HID core driver
[    0.976631] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.978333] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    0.980015] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.077071] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.125716] ata1.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
[    1.127336] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.184032] ata1.00: configured for UDMA/133
[    1.196785] scsi 0:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
[    1.199461] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.201444] sd 0:0:0:0: [sda] Write Protect is off
[    1.203112] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.204868] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.223837]  sda: sda1 sda2
[    1.226863] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.335592] usb 8-1: new low speed USB device using uhci_hcd and address 2
[    1.353515] ALSA device list:
[    1.355173]   #0: HDA Intel at 0xfe7f8000 irq 43
[    1.356879] Netfilter messages via NETLINK v0.30.
[    1.358609] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.361092] ctnetlink v0.93: registering with nfnetlink.
[    1.364282] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.366113] TCP cubic registered
[    1.367803] NET: Registered protocol family 17
[    1.654527] usb 8-1: New USB device found, idVendor=046d, idProduct=c30e
[    1.656355] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.658168] usb 8-1: Product: HID compliant keyboard
[    1.659962] usb 8-1: Manufacturer: Logitech
[    1.735397] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input0
[    1.738334] generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1d.2-1/input0
[    1.861886] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input1
[    1.864328] generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1d.2-1/input1
[    1.924043] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.969232] ata2.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
[    1.971254] ata2.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.027542] ata2.00: configured for UDMA/133
[    2.040296] scsi 1:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
[    2.043205] sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.045536] sd 1:0:0:0: [sdb] Write Protect is off
[    2.047578] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.049737] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.073065] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    2.101657]  sdb: sdb1 sdb2
[    2.105062] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.234580] usb 8-2: New USB device found, idVendor=093a, idProduct=2510
[    2.236792] usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.239012] usb 8-2: Product: USB OPTICAL MOUSE
[    2.241227] usb 8-2: Manufacturer: PIXART
[    2.270318] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input2
[    2.273343] generic-usb 0003:093A:2510.0003: input,hidraw2: USB HID v1.11 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.2-2/input0
[    2.766041] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.814111] ata3.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
[    2.816429] ata3.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.872430] ata3.00: configured for UDMA/133
[    2.885311] scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
[    2.888433] sd 2:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.890938] sd 2:0:0:0: [sdc] Write Protect is off
[    2.893189] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.895533] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.920844]  sdc: unknown partition table
[    2.923978] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.611038] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.004697] ata4.00: ATA-8: TOSHIBA MK1646GSX, LB113M, max UDMA/100
[    4.007015] ata4.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.010254] ata4.00: configured for UDMA/100
[    4.023259] scsi 3:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
[    4.026450] sd 3:0:0:0: [sdd] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.029087] sd 3:0:0:0: [sdd] Write Protect is off
[    4.031401] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    4.033808] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.116102]  sdd: sdd1 sdd2 < sdd5 >
[    4.119692] sd 3:0:0:0: [sdd] Attached SCSI disk
[    4.331029] ata5: SATA link down (SStatus 0 SControl 300)
[    4.649031] ata6: SATA link down (SStatus 0 SControl 300)
[    4.702515] EXT3-fs: barriers not enabled
[    4.720811] kjournald starting.  Commit interval 5 seconds
[    4.721059] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[    4.721169] VFS: Mounted root (ext3 filesystem) readonly on device 8:17.
[    4.721223] debug: unmapping init memory ffffffff818c3000..ffffffff81937000
[    4.730040] Write protecting the kernel read-only data: 8192k
[    4.732383] debug: unmapping init memory ffff88000146b000..ffff880001600000
[    4.734657] debug: unmapping init memory ffff88000177d000..ffff880001800000
[    6.941686] udev: starting version 151
[    6.943969] udevd (879): /proc/879/oom_adj is deprecated, please use /proc/879/oom_score_adj instead.
[    8.482925] EXT3-fs (sdb1): using internal journal
[    8.849581] EXT3-fs: barriers not enabled
[    8.866919] kjournald starting.  Commit interval 5 seconds
[    8.867035] EXT3-fs (sdd1): mounted filesystem with ordered data mode
[    8.921603] Adding 8388604k swap on /dev/sdb2.  Priority:-1 extents:1 across:8388604k 
[   19.348932] sky2 0000:03:00.0: eth0: enabling interface
[   21.069175] sky2 0000:03:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
[   23.437283] eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
[   67.460544] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   68.162694] ata1.00: configured for UDMA/133
[   68.162703] ata1: EH complete
[   68.588662] ata2.00: configured for UDMA/133
[   68.588670] ata2: EH complete
[   69.058583] ata3.00: configured for UDMA/133
[   69.058591] ata3: EH complete
[   69.088693] ata4.00: configured for UDMA/100
[   69.088700] ata4: EH complete
[ 2899.600041] radeon 0000:01:00.0: GPU lockup CP stall for more than 102158msec
[ 2899.600047] ------------[ cut here ]------------
[ 2899.600055] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x35a/0x3c0()
[ 2899.600059] Hardware name: P5E
[ 2899.600062] GPU lockup (waiting for 0x00032018 last fence id 0x0003200C)
[ 2899.600067] Pid: 4391, comm: X Not tainted 2.6.36-rc6 #21
[ 2899.600070] Call Trace:
[ 2899.600078]  [<ffffffff8103bf85>] warn_slowpath_common+0x75/0xb0
[ 2899.600083]  [<ffffffff8103c061>] warn_slowpath_fmt+0x41/0x50
[ 2899.600088]  [<ffffffff81250d7a>] radeon_fence_wait+0x35a/0x3c0
[ 2899.600094]  [<ffffffff810587e0>] ? autoremove_wake_function+0x0/0x40
[ 2899.600099]  [<ffffffff812515ac>] radeon_sync_obj_wait+0xc/0x10
[ 2899.600105]  [<ffffffff8121afef>] ttm_bo_wait+0xff/0x1c0
[ 2899.600110]  [<ffffffff81266b92>] radeon_gem_wait_idle_ioctl+0x92/0x110
[ 2899.600116]  [<ffffffff812076fb>] drm_ioctl+0x42b/0x4e0
[ 2899.600121]  [<ffffffff81266b00>] ? radeon_gem_wait_idle_ioctl+0x0/0x110
[ 2899.600126]  [<ffffffff810bfa22>] ? do_sync_read+0xd2/0x110
[ 2899.600132]  [<ffffffff810cf531>] do_vfs_ioctl+0xa1/0x5a0
[ 2899.600137]  [<ffffffff8100235c>] ? sysret_check+0x27/0x62
[ 2899.600142]  [<ffffffff810cfa7a>] sys_ioctl+0x4a/0x80
[ 2899.600147]  [<ffffffff8100232b>] system_call_fastpath+0x16/0x1b
[ 2899.600151] ---[ end trace 767cb5c7224449ce ]---
[ 2899.768826] Failed to wait GUI idle while programming pipes. Bad things might happen.
[ 2899.769959] radeon 0000:01:00.0: (r300_asic_reset:415) RBBM_STATUS=0x84110140
[ 2900.274454] radeon 0000:01:00.0: (r300_asic_reset:434) RBBM_STATUS=0x80010140
[ 2900.775569] radeon 0000:01:00.0: (r300_asic_reset:446) RBBM_STATUS=0x00000140
[ 2900.775610] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100403, writing 0x100407)
[ 2900.775646] radeon 0000:01:00.0: GPU reset succeed
[ 2900.775650] radeon 0000:01:00.0: GPU reset succeed
[ 2900.775656] radeon 0000:01:00.0: ffff8800bf96e6c0 unpin not necessary
[ 2900.880873] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[ 2900.882065] [drm] PCIE GART of 512M enabled (table at 0xF0040000).
[ 2900.882089] [drm] radeon: ring at 0x00000000D0000000
[ 2900.882111] [drm] ring test succeeded in 0 usecs
[ 2900.882181] [drm] ib test succeeded in 1 usecs
