Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1ENT54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:57:56 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:51340 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123Ab1ENT5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:57:54 -0400
Date: Sat, 14 May 2011 15:57:42 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: 2.6.38.6 -stable regression: kernel insta-death on boot.
Message-ID: <20110514195741.GA10757@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38.6 panics almost immediately on boot.  2.6.38.3 works fine.  Full
kernel log and bisection results follow.  Reverting the implicated
commit corrects the issue.

This system has a really old (circa 2004) Athlon64 CPU, and has worked fine
until today.

  Linux version 2.6.38.6 (nick@artemis) (gcc version 4.5.2 (Gentoo 4.5.2 p1.0, pie-0.4.5) ) #1 PREEMPT Sat May 14 12:08:56 EDT 2011
  Command line: root=md:name=newroot console=ttyS0,115200n8
  BIOS-provided physical RAM map:
   BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
   BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
   BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
   BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
   BIOS-e820: 000000003ffc0000 - 000000003ffd0000 (ACPI data)
   BIOS-e820: 000000003ffd0000 - 0000000040000000 (ACPI NVS)
   BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
   BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
   BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
  NX (Execute Disable) protection: active
  DMI 2.3 present.
  AGP bridge at 00:00:00
  Aperture from AGP @ f8000000 old size 32 MB
  Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
  Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
  last_pfn = 0x3ffc0 max_arch_pfn = 0x400000000
  x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
  found SMP MP-table at [ffff8800000ff780] ff780
  init_memory_mapping: 0000000000000000-000000003ffc0000
  RAMDISK: 37cb1000 - 37ff0000
  ACPI: RSDP 00000000000f9cb0 00021 (v02 ACPIAM)
  ACPI: XSDT 000000003ffc0100 0003C (v01 A M I  OEMXSDT  01000618 MSFT 00000097)
  ACPI: FACP 000000003ffc0290 000F4 (v03 A M I  OEMFACP  01000618 MSFT 00000097)
  ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20110112/tbfadt-526)
  ACPI Warning: Optional field Gpe1Block has zero address or length: 0x00000000000044A0/0x0 (20110112/tbfadt-557)
  ACPI: DSDT 000000003ffc0400 04524 (v01  A0055 A0055003 00000003 INTL 02002026)
  ACPI: FACS 000000003ffd0000 00040
  ACPI: APIC 000000003ffc0390 00068 (v01 A M I  OEMAPIC  01000618 MSFT 00000097)
  ACPI: OEMB 000000003ffd0040 00041 (v01 A M I  OEMBIOS  01000618 MSFT 00000097)
  Zone PFN ranges:
    DMA      0x00000010 -> 0x00001000
    DMA32    0x00001000 -> 0x00100000
    Normal   empty
  Movable zone start PFN for each node
  early_node_map[2] active PFN ranges
      0: 0x00000010 -> 0x0000009f
      0: 0x00000100 -> 0x0003ffc0
  Nvidia board detected. Ignoring ACPI timer override.
  If you got timer trouble try acpi_use_timer_override
  ACPI: PM-Timer IO Port: 0x4008
  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
  ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
  IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
  ACPI: BIOS IRQ0 pin2 override ignored.
  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
  ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
  Using ACPI (MADT) for SMP configuration information
  Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
  Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258381
  Kernel command line: root=md:name=newroot console=ttyS0,115200n8
  PID hash table entries: 4096 (order: 3, 32768 bytes)
  Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
  Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
  Checking aperture...
  AGP bridge at 00:00:00
  Aperture from AGP @ f8000000 old size 32 MB
  Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
  Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
  Node 0: aperture @ f8000000 size 64 MB
  Memory: 1023544k/1048320k available (2932k kernel code, 452k absent, 24324k reserved, 1403k data, 348k init)
  NR_IRQS:288
  Extended CMOS year: 2000
  Console: colour VGA+ 80x25
  console [ttyS0] enabled
  Fast TSC calibration using PIT
  Detected 2009.796 MHz processor.
  Calibrating delay loop (skipped), value calculated using timer frequency.. 4019.59 BogoMIPS (lpj=2009796)
  pid_max: default: 32768 minimum: 301
  Mount-cache hash table entries: 256
  mce: CPU supports 5 MCE banks
  using C1E aware idle routine
  CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 08
  ACPI: Core revision 20110112
  Performance Events: AMD PMU driver.
  ... version:                0
  ... bit width:              48
  ... generic registers:      4
  ... value mask:             0000ffffffffffff
  ... max period:             00007fffffffffff
  ... fixed-purpose events:   0
  ... event mask:             000000000000000f
  MCE: In-kernel MCE decoding enabled.
  Setting APIC routing to flat
  ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
  NET: Registered protocol family 16
  TOM: 0000000040000000 aka 1024M
  ACPI: bus type pci registered
  PCI: Using configuration type 1 for base access
  bio: create slab <bio-0> at 0
  ACPI: Executed 1 blocks of module-level executable AML code
  ACPI: Actual Package length (234) is larger than NumElements field (3), truncated

  ACPI: Interpreter enabled
  ACPI: (supports S0 S5)
  ACPI: Using IOAPIC for interrupt routing
  ACPI: Power Resource [ISAV] (on)
  ACPI: No dock devices found.
  PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
  ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
  pci 0000:00:0b.0: PCI bridge to [bus 01-01]
  pci 0000:00:0e.0: PCI bridge to [bus 02-02]
  ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *7
  ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
  ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *3
  ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
  ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
  ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *9
  ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *10
  ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *11
  ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *5
  ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
  ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
  ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
  ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0
  ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
  ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
  vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
  vgaarb: loaded
  SCSI subsystem initialized
  usbcore: registered new interface driver usbfs
  usbcore: registered new interface driver hub
  usbcore: registered new device driver usb
  PCI: Using ACPI for IRQ routing
  pci 0000:00:00.0: address space collision: [mem 0xf8000000-0xfbffffff pref] conflicts with GART [mem 0xf8000000-0xfbffffff]
  pnp: PnP ACPI init
  ACPI: bus type pnp registered
  system 00:06: [io  0x0190-0x0193] has been reserved
  system 00:06: [io  0x04d0-0x04d1] has been reserved
  system 00:06: [io  0x4000-0x40ff window] has been reserved
  system 00:06: [io  0x4400-0x44ff window] has been reserved
  system 00:06: [io  0x4800-0x48ff window] has been reserved
  system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
  system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
  system 00:07: [mem 0xff780000-0xff7bffff] has been reserved
  system 00:08: [io  0x0480-0x0487] has been reserved
  system 00:08: [io  0x0d00-0x0d07] has been reserved
  pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
  pnp 00:0a: disabling [mem 0x000c0000-0x000dffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
  pnp 00:0a: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
  pnp 00:0a: disabling [mem 0x00100000-0x3fffffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
  system 00:0a: [mem 0xff7c0000-0xffffffff] has been reserved
  pnp: PnP ACPI: found 11 devices
  ACPI: ACPI bus type pnp unregistered
  Switching to clocksource acpi_pm
  pci 0000:00:0b.0: PCI bridge to [bus 01-01]
  Switched to NOHz mode on CPU #0
  pci 0000:00:0b.0:   bridge window [io  disabled]
  pci 0000:00:0b.0:   bridge window [mem 0xfc800000-0xfe8fffff]
  pci 0000:00:0b.0:   bridge window [mem 0xd4700000-0xf46fffff pref]
  pci 0000:00:0e.0: PCI bridge to [bus 02-02]
  pci 0000:00:0e.0:   bridge window [io  0xb000-0xcfff]
  pci 0000:00:0e.0:   bridge window [mem 0xfe900000-0xfeafffff]
  pci 0000:00:0e.0:   bridge window [mem pref disabled]
  NET: Registered protocol family 2
  IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
  TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
  TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
  TCP: Hash tables configured (established 131072 bind 65536)
  TCP reno registered
  UDP hash table entries: 512 (order: 2, 16384 bytes)
  UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
  NET: Registered protocol family 1
  general protection fault: 0000 [#1] PREEMPT
  last sysfs file:
  CPU 0
  Modules linked in:

  Pid: 0, comm: swapper Not tainted 2.6.38.6 #1 ASUSTek Computer Inc. K8N-E-Deluxe/'K8N-E-Deluxe'
  RIP: 0010:[<ffffffff81008f76>]  [<ffffffff81008f76>] c1e_idle+0x2e/0xde
  RSP: 0018:ffffffff813e1ef8  EFLAGS: 00010046
  RAX: 0000000400000000 RBX: ffffffff813e0000 RCX: 00000000c0010055
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff814970e8
  RBP: ffffffff813e1f18 R08: 0000000000000000 R09: ffffffff810f39b8
  R10: ffff88003e05dc40 R11: ffff88003e077868 R12: 6db6db6db6db6db7
  R13: ffff88003ffba740 R14: ffffffffffffffff R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffffffff813fa000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000000000 CR3: 00000000013ea000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process swapper (pid: 0, threadinfo ffffffff813e0000, task ffffffff813f2040)
  Stack:
   ffffffff813e1f08 ffffffff81041a6b ffffffff813e1f18 ffffffff813e0000
   ffffffff813e1f38 ffffffff81001155 ffffffffffffffff ffffffff813e0000
   ffffffff813e1f58 ffffffff812d1bf4 ffffffff813e1f58 0000000000000000
  Call Trace:
   [<ffffffff81041a6b>] ? atomic_notifier_call_chain+0xf/0x11
   [<ffffffff81001155>] cpu_idle+0x37/0x56
   [<ffffffff812d1bf4>] rest_init+0x88/0x8c
   [<ffffffff8143dab1>] start_kernel+0x31c/0x327
   [<ffffffff8143d2a6>] x86_64_start_reservations+0xb6/0xba
   [<ffffffff8143d3a1>] x86_64_start_kernel+0xf7/0xfe
  Code: 04 25 48 90 3f 81 48 89 e5 53 48 83 ec 18 48 8b 80 38 e0 ff ff a8 08 0f 85 b7 00 00 00 80 3d b1 f7 48 00 00 75 3e b9 55 00 01 c0 <0f> 32 a9 00 00 00 18 74 30 48 8b 05 56 02 43 00 c6 05 93 f7 48
  RIP  [<ffffffff81008f76>] c1e_idle+0x2e/0xde
   RSP <ffffffff813e1ef8>
  ---[ end trace 6d450e935ee1897c ]---
  Kernel panic - not syncing: Attempted to kill the idle task!
  Pid: 0, comm: swapper Tainted: G      D     2.6.38.6 #1
  Call Trace:
   [<ffffffff812d83fd>] ? panic+0x9a/0x195
   [<ffffffff8102ab81>] ? do_exit+0x6c/0x660
   [<ffffffff81029480>] ? kmsg_dump+0xe9/0xf9
   [<ffffffff81005bd7>] ? oops_end+0x9d/0xa5
   [<ffffffff81005d0d>] ? die+0x55/0x5e
   [<ffffffff81003bb4>] ? do_general_protection+0x129/0x131
   [<ffffffff812da7df>] ? general_protection+0x1f/0x30
   [<ffffffff810f39b8>] ? rb_insert_color+0xb8/0xe1
   [<ffffffff81008f76>] ? c1e_idle+0x2e/0xde
   [<ffffffff81041a6b>] ? atomic_notifier_call_chain+0xf/0x11
   [<ffffffff81001155>] ? cpu_idle+0x37/0x56
   [<ffffffff812d1bf4>] ? rest_init+0x88/0x8c
   [<ffffffff8143dab1>] ? start_kernel+0x31c/0x327
   [<ffffffff8143d2a6>] ? x86_64_start_reservations+0xb6/0xba
   [<ffffffff8143d3a1>] ? x86_64_start_kernel+0xf7/0xfe

  15f0758f185241ad9c358a5bf60ff0a21eccc218 is the first bad commit
  commit 15f0758f185241ad9c358a5bf60ff0a21eccc218
  Author: Boris Ostrovsky <ostr@amd64.org>
  Date:   Fri Apr 29 17:47:43 2011 -0400
  
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
  
      commit e20a2d205c05cef6b5783df339a7d54adeb50962 upstream.
  
      Older AMD K8 processors (Revisions A-E) are affected by erratum
      400 (APIC timer interrupts don't occur in C states greater than
      C1). This, for example, means that X86_FEATURE_ARAT flag should
      not be set for these parts.
  
      This addresses regression introduced by commit
      b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT
      feature on AMD processors") where the system may become
      unresponsive until external interrupt (such as keyboard input)
      occurs. This results, for example, in time not being reported
      correctly, lack of progress on the system and other lockups.
  
      Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
      Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
      Acked-by: Borislav Petkov <borislav.petkov@amd.com>
      Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
      Link: http://lkml.kernel.org/r/1304113663-6586-1-git-send-email-ostr@amd64.org
      Signed-off-by: Ingo Molnar <mingo@elte.hu>
      Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
  
  :040000 040000 8279b5b325e6e43b83524aeacd0107839540e571 9ad975ca6fcb94829855f22dc6ddfa52341028bf M      arch

  git bisect start
  # bad: [678562e527fd9979f1765ffa1eb34738fc174425] Linux 2.6.38.6
  git bisect bad 678562e527fd9979f1765ffa1eb34738fc174425
  # good: [1be99f6c95e6c887756f789a60d15771235acd0c] Linux 2.6.38.3
  git bisect good 1be99f6c95e6c887756f789a60d15771235acd0c
  # good: [6a6a3e00ccd23f5b9d146a4b0591c8b61b4d0bb2] intel-iommu: Fix use after release during device attach
  git bisect good 6a6a3e00ccd23f5b9d146a4b0591c8b61b4d0bb2
  # good: [80ac2fd6758b75a1f1db112821635e3411185073] Input: xen-kbdfront - fix mouse getting stuck after save/restore
  git bisect good 80ac2fd6758b75a1f1db112821635e3411185073
  # good: [a41ee1d9242adc1cd4eaad4fcae727f778c394a9] USB: fix regression in usbip by setting has_tt flag
  git bisect good a41ee1d9242adc1cd4eaad4fcae727f778c394a9
  # bad: [36f96751ce09f4ab400e93408cc602d2e080a799] ARM: 6891/1: prevent heap corruption in OABI semtimedop
  git bisect bad 36f96751ce09f4ab400e93408cc602d2e080a799
  # good: [c4ac4195df7fcb85ade58dd0497e273dd10600e7] flex_array: flex_array_prealloc takes a number of elements, not an end
  git bisect good c4ac4195df7fcb85ade58dd0497e273dd10600e7
  # bad: [bf4b1d070aeb3669d4b4e95c59c404d0e055c41c] ath9k: fix the return value of ath_stoprecv
  git bisect bad bf4b1d070aeb3669d4b4e95c59c404d0e055c41c
  # bad: [15f0758f185241ad9c358a5bf60ff0a21eccc218] x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
  git bisect bad 15f0758f185241ad9c358a5bf60ff0a21eccc218
  # good: [18ab890cdc1e014d2ced35a5b8e606871ed5e6fc] flex_arrays: allow zero length flex arrays
  git bisect good 18ab890cdc1e014d2ced35a5b8e606871ed5e6fc
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
