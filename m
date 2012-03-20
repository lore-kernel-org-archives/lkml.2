Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2CTX60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:58:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40162 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2CTX6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:58:18 -0400
Date: Tue, 20 Mar 2012 19:53:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        gregkh@linuxfoundation.org, rjw@sisk.pl
Subject: Regression in v3.4-rc0 " BUG: soft lockup - CPU#0 stuck for 29s!
 [migration/0:6]..[<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf"
Message-ID: <20120320235322.GA5416@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F691974.0009,ss=1,re=-15.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing this in v3.4-rc0 tree and didn't see that with v3.3:

I hadn't done any git bisection, so I am just emailing at blind
hoping somebody will say: "AHA! I recognize this code!"

ACPI: PCI Interrupt Link [LNK[   38.219759] BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]
Modules linked in:
CPU ] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: ffff8800cea8fe20 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff81876500
RBP: ffff8800ceaabde0 R08: ffff8800ceaaa000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cea80220
R13: 0000000000000001 R14: ffff8800cea8fe44 R15: ffffffff810d3b01
FS:  0000000000000000(0000) GS:ffff8800cfe59000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001805000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 6, threadinfo ffff8800ceaaa000, task ffff8800cea867e0)
Stack:
 ffff8800ceaaa000 ffff8800cea8fd90 ffff8800ceaaa000 ffff8800cea867e0
 ffff8800cfe67a80 ffffffff810d3b10 ffff8800ceaabee0 ffffffff810d3841
 00000000ceaabe40 ffff8800ceaabfd8 ffff8800cea867e0 ffff8800cfe67a88
Call Trace:
 [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
 [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
 [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
 [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
 [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
 [<ffffffff8108dc76>] kthread+0x96/0xa0
 [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
 [<ffffffff815b27e0>] ? gs_change+0x13/0x13
Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 ff 14 25 10 4e 81 
Call Trace:
 [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
 [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
 [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
 [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
 [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
 [<ffffffff8108dc76>] kthread+0x96/0xa0
 [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
 [<ffffffff815b27e0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#0 stuck for 36s! [migration/0:6]
Modules linked in:
CPU 0 
Modules linked in:

Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: ffff8800cea8fe20 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff81876500
RBP: ffff8800ceaabde0 R08: ffff8800ceaaa000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cea80220
R13: 0000000000000001 R14: ffff8800cea8fe44 R15: ffffffff810d3b01
FS:  0000000000000000(0000) GS:ffff8800cfe59000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001805000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 6, threadinfo ffff8800ceaaa000, task ffff8800cea867e0)
Stack:
 ffff8800ceaaa000 ffff8800cea8fd90 ffff8800ceaaa000 ffff8800cea867e0
 ffff8800cfe67a80 ffffffff810d3b10 ffff8800ceaabee0 ffffffff810d3841
 00000000ceaabe40 ffff8800ceaabfd8 ffff8800cea867e0 ffff8800cfe67a88
Call Trace:
 [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
 [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
 [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
 [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
 [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
 [<ffffffff8108dc76>] kthread+0x96/0xa0
 [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
 [<ffffffff815b27e0>] ? gs_change+0x13/0x13
Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 ff 14 25 10 4e 81 
Call Trace:
 [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
 [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
 [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
 [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
 [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
 [<ffffffff8108dc76>] kthread+0x96/0xa0
 [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
 [<ffffffff815b27e0>] ? gs_change+0x13/0x13
INFO: rcu_sched self-detected stall on CPU { 0}  (t=60000 jiffies)
sending NMI to all CPUs:


----- Forwarded message from konrad.wilk@oracle.com -----

Date: Tue, 20 Mar 2012 19:35:13 -0400
From: konrad.wilk@oracle.com
To: konrad.wilk@oracle.com
Subject: FAILURE 3.3.0upstream-01180-ged378a5(x86_64) 3.3.0upstream-01180-ged378a5(i386): 2012-03-20 (tst001)

--------------------------
FAILED:  tst001(XEN-x86_64) tst001(XEN-i386):
--------------------------
tst001 (XEN-x86_64): FAILED to bootup
tst001 (XEN-i386): FAILED to bootup
tst001 (BAREMETAL-x86_64): 3.3.0upstream-01180-ged378a5 ON
tst001 (BAREMETAL-i386): 3.3.0upstream-01180-ged378a5 ON
--------------------------
(tst001-XEN) SERIAL
--------------------------
ÿûÿýÿûÿýPXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/xen.gz... ok
Loading latest/vmlinuz... ok
Loading latest/initramfs.cpio.gz... ok
 __  __            _  _    _    _ ____   ___  _ ____  _  _   
 \ \/ /___ _ __   | || |  / |  / |___ \ / _ \/ |___ \| || |  
  \  // _ \ '_ \  | || |_ | |__| | __) | | | | | __) | || |_ 
  /  \  __/ | | | |__   _|| |__| |/ __/| |_| | |/ __/|__   _|
 /_/\_\___|_| |_|    |_|(_)_|  |_|_____|\___/|_|_____|  |_|  
                                                             
(XEN) Xen version 4.1-120320 (konrad@dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) Tue Mar 20 18:10:22 EDT 2012
(XEN) Latest ChangeSet: Wed Mar 14 12:02:02 2012 +0000 23267:14416d8215d4
(XEN) Bootloader: unknown
(XEN) Command line: com1=115200,8n1 console=com1,vga guest_loglvl=all cpufreq=verbose loglvl=all apic=debug
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: none; EDID transfer time: 2 seconds
(XEN)  EDID info not retrieved because no DDC retrieval method detected
(XEN) Disc information:
(XEN)  Found 0 MBR signatures
(XEN)  Found 0 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009d800 (usable)
(XEN)  000000000009d800 - 00000000000a0000 (reserved)
(XEN)  00000000000cc000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 000000007fff0000 (usable)
(XEN)  000000007fff0000 - 0000000080000000 (reserved)
(XEN)  0000000080000000 - 00000000cfef0000 (usable)
(XEN)  00000000cfef0000 - 00000000cfef5000 (ACPI data)
(XEN)  00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
(XEN)  00000000cff80000 - 00000000d0000000 (reserved)
(XEN)  00000000e0000000 - 00000000f0000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec10000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000fff80000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 0000000130000000 (usable)
(XEN) ACPI: RSDP 000F79B0, 0024 (r2 PTLTD )
(XEN) ACPI: XSDT CFEF0753, 009C (r1 DELL   PE_SC3    6040000 DELL        0)
(XEN) ACPI: FACP CFEF3C5F, 00F4 (r3 DELL   PE_SC3    6040000 DELL    F4240)
(XEN) ACPI: DSDT CFEF07EF, 33FC (r1 DELL   PE_SC3    6040000 MSFT  100000E)
(XEN) ACPI: FACS CFEF5FC0, 0040
(XEN) ACPI: TCPA CFEF3D53, 0032 (r1 Phoeni  x        6040000  TL         0)
(XEN) ACPI: SLIC CFEF3D85, 0024 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: SPCR CFEF3DA9, 0050 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: EINJ CFEF3DF9, 01B0 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: HEST CFEF3FA9, 00A8 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: BERT CFEF4051, 0030 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SSDT CFEF4081, 00E1 (r1 wheaos  wheaosc  6040000 INTL 20050624)
(XEN) ACPI: ERST CFEF4162, 0270 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SRAT CFEF43D2, 00E8 (r1 AMD    HAMMER    6040000 AMD         1)
(XEN) ACPI: SSDT CFEF44BA, 0A30 (r1 AMD    POWERNOW  6040000 AMD         1)
(XEN) ACPI: MCFG CFEF4EEA, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
(XEN) ACPI: HPET CFEF4F26, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
(XEN) ACPI: APIC CFEF4F5E, 007A (r1 PTLTD  	 APIC    6040000  LTP        0)
(XEN) ACPI: BOOT CFEF4FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
(XEN) System RAM: 4094MB (4192756kB)
(XEN) SRAT: PXM 0 -> APIC 0 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 1 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 2 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 3 -> Node 0
(XEN) SRAT: Node 0 PXM 0 0-a0000
(XEN) SRAT: Node 0 PXM 0 100000-d0000000
(XEN) SRAT: Node 0 PXM 0 100000000-130000000
(XEN) NUMA: Allocated memnodemap from 12151b000 - 12151d000
(XEN) NUMA: Using 8 for the hash shift.
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000f7a70
(XEN) DMI present.
(XEN) Using APIC driver default
(XEN) 0,0]
(XEN) ACPI:                  wakeup_vec[cfef5fcc], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
(XEN) Processor #0 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
(XEN) Processor #1 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
(XEN) Processor #3 0:2 APIC version 16
(XEN) ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x10de8201 base: 0xfed00000
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
(XEN) PCI: MCFG area at e0000000 reserved in E820
(XEN) ERST table is invalid
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) IRQ limits: 24 GSI, 760 MSI/MSI-X
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2109.728 MHz processor.
(XEN) Initing memory sharing.
(XEN) AMD Fam10h machine check reporting enabled
(XEN) AIOMMU not found!
(XEN) I/O virtualisation disabled
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
(XEN) Platform timer is 25.000MHz HPET
(XEN) Allocated console ring of 32 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Supported advanced features:
(XEN)  - Nested Page Tables (NPT)
(XEN)  - Last Branch Record (LBR) Virtualisation
(XEN) HVM: SVM enabled
(XEN) HVM: Hardware Assisted Paging (HAP) detected
(XEN) HVM: HAP page sizes: 4kB, 2MB, 1GB
(XEN) Brought up 4 CPUs
(XEN) HPET: 3 timers in total, 0 timers will be used for broadcast
(XEN) ACPI sleep modes: S3
(XEN) MCA: Use hw thresh(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x1e3c000
(XEN) PHYSICAL ME00000012ffffe00
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff81e3c000
(XEN)  Init. ramdisk: ffffffff81e3c000->ffffffff8f7f5e00
(XEN)  Phys-Mach map: ffffffff8f7f6000->ffffffff8ff9baa0
(XEN)  Start info:    ffffffff8ff9c000->ffffffff8ff9c4b4
(XEN)  Page tables:   ffffffff8ff9d000->ffffffff90022000
(XEN)  Boot stack:    ffffffff90022000->ffffffff90023000
(XEN)  TOTAL:         ffffffff80000000->ffffffff90400000
(XEN)  ENTRY ADDRESS: ffffffff81896200
(XEN) Dom0 has maximum 4 VCPUs
(XEN) Scrubbing Free RAM: .done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) Xen is relinquishing VGA coXEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input to Xen)
(XEN) Freed 220kB init memory.
mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0upstream-01180-ged378a5 (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Mar 20 18:10:08 EDT 2012
[    0.000000] Command line: earlyprintk=xen debug nofb console=tty console=hvc0 xen-pciback.hide=(05:00.0)(05:00.1) loglevel=10
[    0.000000] Freeing  9d-100 pfn range: 99 pages freed
[    0.000000] Freeing  7fff0-80000 pfn range: 16 pages freed
[    0.000000] Freeing  cfef0-f4b54 pfn range: 150628 pages freed
[    0.000000] Released 150743 pages of unused memory
[    0.000000] Set 196995 page(s) to 1-1 mapping
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  Xen: 000000000009d800 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  Xen: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  Xen: 0000000080000000 - 00000000cfef0000 (usable)
[    0.000000]  Xen: 00000000cfef0000 - 00000000cfef5000 (ACPI data)
[    0.000000]  Xen: 00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
[    0.000000]  Xen: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  Xen: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  Xen: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  Xen: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  Xen: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f7a70] f7a70
[    0.000000] initial memory mapped : 0 - 0f7f6000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfef0000
[    0.000000]  0000000000 - 00cfef0000 page 4k
[    0.000000] kernel direct mapping tables up to cfef0000 @ 97b000-1000000
[    0.000000] xen: setting RW the range f78000 - 1000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000k
[    0.000000] kernel direct mapping tables up to 130000000 @ cf56a000-cfef0000
[    0.000000] xen: setting RW the range cf6eb000 - cfef0000
[    0.000000] RAMDISK: 01e3c000 - 0f7f6000
[    0.000000] ACPI: RSDP 00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [00000000cfeeb000 - 00000000cfeeffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1538 pages reserved
[    0.000000]   DMA zone: 2387 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] BIOS bug: APIC version is 0 for CPU 0/0x0, fixing up to 0x10
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfef5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-120320 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff8800cfe59000 s78400 r8192 d24000 u110592
[    0.000000] pcpu-alloc: s78400 r8192 d24000 u110592 alloc=27*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    1.636381] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029611
[    1.636387] Policy zone: Normal
[    1.636391] Kernel command line: earlyprintk=xen debug nofb console=tty console=hvc0 xen-pciback.hide=(05:00.0)(05:00.1) loglevel=10
[    1.636553] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    1.702536] Placing 64MB software IO TLB between ffff8800c7000000 - ffff8800cb000000
[    1.702545] software IO TLB at phys 0xc7000000 - 0xcb000000
[    1.724895] Memory: 3032736k/4980736k available (5846k kernel code, 788044k absent, 1159956k reserved, 2857k data, 688k init)
[    1.725031] Hierarchical RCU implementation.
[    1.725049] NR_IRQS:33024 nr_irqs:1024 16
[    1.725145] xen: sci override: global_irq=9 trigger=0 polarity=1
[    1.725151] xen: registering gsi 9 triggering 0 polarity 1
[    1.725164] xen: --> pirq=9 -> irq=9 (gsi=9)
[    1.725172] xen: acpi sci 9
[    1.725177] xen: --> pirq=1 -> irq=1 (gsi=1)
[    1.725183] xen: --> pirq=2 -> irq=2 (gsi=2)
[    1.725189] xen: --> pirq=3 -> irq=3 (gsi=3)
[    1.725194] xen: --> pirq=4 -> irq=4 (gsi=4)
[    1.725201] xen: --> pirq=5 -> irq=5 (gsi=5)
[    1.725207] xen: --> pirq=6 -> irq=6 (gsi=6)
[    1.725212] xen: --> pirq=7 -> irq=7 (gsi=7)
[    1.725217] xen: --> pirq=8 -> irq=8 (gsi=8)
[    1.725222] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    1.725226] xen: --> pirq=9 -> irq=9 (gsi=9)
[    1.725231] xen: --> pirq=10 -> irq=10 (gsi=10)
[    1.725236] xen: --> pirq=11 -> irq=11 (gsi=11)
[    1.725242] xen: --> pirq=12 -> irq=12 (gsi=12)
[    1.725247] xen: --> pirq=13 -> irq=13 (gsi=13)
[    1.725253] xen: --> pirq=14 -> irq=14 (gsi=14)
[    1.725258] xen: --> pirq=15 -> irq=15 (gsi=15)
[    1.727262] Console: colour VGA+ 80x25
[    1.737100] console [tty0] enabled
[    1.737161] console [hvc0] enabled, bootconsole disabled
[    1.737161] console [hvc0] enabled, bootconsole disabled
[    1.737261] Xen: using vcpuop timer interface
[    1.737326] installing Xen timer for CPU 0
[    1.737412] Detected 2109.728 MHz processor.
[    1.737477] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.45 BogoMIPS (lpj=2109728)
[    1.737600] pid_max: default: 32768 minimum: 301
[    1.737729] Security Framework initialized
[    1.737789] SELinux:  Initializing.
[    1.737859] SELinux:  Starting in permissive mode
[    1.739429] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.743118] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.744065] Mount-cache hash table entries: 256
[    1.744348] Initializing cgroup subsys cpuacct
[    1.744412] Initializing cgroup subsys freezer
[    1.744532] tseg: 00cff80000
[    1.744594] CPU: Physical Processor ID: 0
[    1.744654] CPU: Processor Core ID: 0
[    1.747609] ACPI: Core revision 20120111
[    1.754810] cpu 0 spinlock event irq 273
[    1.754947] Performance Events: (XEN) traps.c:2458:d0 Domain attempted WRMSR 00000000c0010004 from 0x00000852a205b8c2 to 0x000000000000abcd.
Broken PMU hardware detected, using software events only.
[    1.755247] MCE: In-kernel MCE decoding enabled.
[    1.755313] NMI watchdog disabled (cpu0): hardware events not enabled
[    1.755598] installing Xen timer for CPU 1
[    1.755672] cpu 1 spinlock event irq 279
[    1.755903] NMI watchdog disabled (cpu1): hardware events not enabled
[    1.756213] installing Xen timer for CPU 2
[    1.756286] cpu 2 spinlock event irq 285
[    1.756494] NMI watchdog disabled (cpu2): hardware events not enabled
[    1.756774] installing Xen timer for CPU 3
[    1.756846] cpu 3 spinlock event irq 291
[    1.757053] NMI watchdog disabled (cpu3): hardware events not enabled
[    1.757155] Brought up 4 CPUs
[    1.757954] PM: Registering ACPI NVS region at cfef5000 (565248 bytes)
[    1.758291] kworker/u:0 used greatest stack depth: 5944 bytes left
[    1.758394] Grant tables using version 2 layout.
[    1.758470] Grant table initialized
[    1.758554] RTC time: 23:06:04, date: 03/20/12
[    1.758715] NET: Registered protocol family 16
[    1.759612] kworker/u:0 used greatest stack depth: 5480 bytes left
[    1.759707] node 0 link 0: io port [1000, 4fff]
[    1.759770] node 0 link 0: io port [5000, fffff]
[    1.759834] TOM: 00000000d0000000 aka 3328M
[    1.759896] node 0 link 0: mmio [d0000000, d05fffff]
[    1.759999] node 0 link 0: mmio [fed00000, fed0ffff]
[    1.760102] node 0 link 0: mmio [d8000000, dfffffff]
[    1.760241] node 0 link 0: mmio [fec00000, fec0ffff]
[    1.760344] node 0 link 0: mmio [e0000000, efffffff]
[    1.760447] node 0 link 0: mmio [a0000, bffff]
[    1.760549] node 0 link 0: mmio [f0000000, fe0bffff]
[    1.760652] TOM2: 0000000130000000 aka 4864M
[    1.760713] bus: [00, ff] on node 0 link 0
[    1.760774] bus: 00 index 0 [io  0x0000-0xffff]
[    1.760837] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    1.760900] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    1.760963] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    1.761025] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    1.761088] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    1.761151] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    1.761268] ACPI: bus type pci registered
[    1.761581] dca service started, version 1.12.1
[    1.761721] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    1.761809] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    1.763816] PCI: Using configuration type 1 for base access
[    1.777222] bio: create slab <bio-0> at 0
[    1.777566] ACPI: Added _OSI(Module Device)
[    1.777629] ACPI: Added _OSI(Processor Device)
[    1.777690] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.777752] ACPI: Added _OSI(Processor Aggregator Device)
[    1.780637] ACPI: EC: Look up EC in DSDT
[    1.781559] \_SB_:_OSC evaluation returned wrong type
[    1.781622] _OSC request data:1 7 
[    1.789910] ACPI: Interpreter enabled
[    1.789972] ACPI: (supports S0 S4 S5)
[    1.790180] ACPI: Using IOAPIC for interrupt routing
[    1.804307] ACPI: No dock devices found.
[    1.804373] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.804693] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.804927] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    1.804993] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    1.805058] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.805140] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    1.805221] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    1.805302] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed8ffff]
[    1.805565] PCI host bridge to bus 0000:00
[    1.805627] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.805692] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.805756] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.805823] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    1.805915] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    1.805981] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    1.806070] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    1.806303] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    1.806380] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    1.806528] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    1.806611] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    1.806709] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    1.806781] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    1.806880] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.806983] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    1.807066] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    1.807220] pci 0000:00:02.0: supports D1 D2
[    1.807304] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.807396] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    1.807483] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    1.807652] pci 0000:00:02.1: supports D1 D2
[    1.807713] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.807826] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    1.807914] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.807987] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.808058] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.808130] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.808202] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.808274] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.808509] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    1.808597] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.808697] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.808770] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.808843] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.808917] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.808991] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.809141] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    1.809270] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    1.809435] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.809578] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    1.809744] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.809849] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    1.810037] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.810142] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    1.810305] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.810416] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    1.810559] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    1.810682] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    1.810806] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    1.810948] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    1.811128] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    1.811218] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    1.811297] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    1.811444] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.811611] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    1.811698] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.811775] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    1.811849] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.811957] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.812058] pci 0000:01:08.0: supports D1 D2
[    1.812163] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    1.812228] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.812296] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.812365] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.812553] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    1.812645] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.812905] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.814638] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    1.814710] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.814845] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.814985] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    1.815148] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    1.815229] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    1.815311] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    1.815389] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    1.815506] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.815669] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.815829] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    1.815912] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    1.815991] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    1.816068] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    1.816184] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.816317] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.816414] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.816516] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    1.816585] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    1.816652] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    1.816756] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.816973] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.817141] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.817265] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.817383] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.817503] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.817614]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.817679]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.817763] ACPI _OSC control for PCIe not granted, disabling ASPM
(XEN) PCI add device 00:00.0
(XEN) PCI add device 00:01.0
(XEN) PCI add device 00:01.1
(XEN) PCI add device 00:02.0
(XEN) PCI add device 00:02.1
(XEN) PCI add device 00:07.0
(XEN) PCI add device 00:08.0
(XEN) PCI add device 00:09.0
(XEN) PCI add device 00:0b.0
(XEN) PCI add device 00:0c.0
(XEN) PCI add device 00:0d.0
(XEN) PCI add device 00:0e.0
(XEN) PCI add device 00:18.0
(XEN) PCI add device 00:18.1
(XEN) PCI add device 00:18.2
(XEN) PCI add device 00:18.3
(XEN) PCI add device 00:18.4
(XEN) PCI add device 01:07.0
(XEN) PCI add device 01:08.0
(XEN) PCI add device 02:00.0
(XEN) PCI add device 05:00.0
(XEN) PCI add device 05:00.1
[    1.850598] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.851105] ACPI: PCI Interrupt Link [LNK[   38.219759] BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]
[   38.219829] Modules linked in:
[   38.219946] CPU ] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
[   38.220378] RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
[   38.220508] RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
[   38.220571] RAX: 0000000000000001 RBX: ffff8800cea8fe20 RCX: 0000000000000000
[   38.220638] RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff81876500
[   38.220704] RBP: ffff8800ceaabde0 R08: ffff8800ceaaa000 R09: 0000000000000000
[   38.220771] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cea80220
[   38.220836] R13: 0000000000000001 R14: ffff8800cea8fe44 R15: ffffffff810d3b01
[   38.220906] FS:  0000000000000000(0000) GS:ffff8800cfe59000(0000) knlGS:0000000000000000
[   38.220991] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   38.221055] CR2: 0000000000000000 CR3: 0000000001805000 CR4: 0000000000000660
[   38.221122] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   38.221212] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   38.221279] Process migration/0 (pid: 6, threadinfo ffff8800ceaaa000, task ffff8800cea867e0)
[   38.221363] Stack:
[   38.221418]  ffff8800ceaaa000 ffff8800cea8fd90 ffff8800ceaaa000 ffff8800cea867e0
[   38.221643]  ffff8800cfe67a80 ffffffff810d3b10 ffff8800ceaabee0 ffffffff810d3841
[   38.221866]  00000000ceaabe40 ffff8800ceaabfd8 ffff8800cea867e0 ffff8800cfe67a88
[   38.222090] Call Trace:
[   38.222150]  [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
[   38.222216]  [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
[   38.222284]  [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
[   38.222348]  [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
[   38.222416]  [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
[   38.222484]  [<ffffffff8108dc76>] kthread+0x96/0xa0
[   38.222548]  [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
[   38.222637]  [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
[   38.222702]  [<ffffffff815b27e0>] ? gs_change+0x13/0x13
[   38.222764] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 ff 14 25 10 4e 81 
[   38.225190] Call Trace:
[   38.225249]  [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
[   38.225315]  [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
[   38.225404]  [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
[   38.225468]  [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
[   38.225535]  [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
[   38.225601]  [<ffffffff8108dc76>] kthread+0x96/0xa0
[   38.225664]  [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
[   38.225729]  [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
[   38.225795]  [<ffffffff815b27e0>] ? gs_change+0x13/0x13
[   91.277630] BUG: soft lockup - CPU#0 stuck for 36s! [migration/0:6]
[   91.277697] Modules linked in:
[   91.277813] CPU 0 
[   91.277853] Modules linked in:
[   91.277995] 
[   91.278049] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
[   91.278243] RIP: e030:[<ffffffff810d3b8b>]  [<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf0
[   91.278369] RSP: e02b:ffff8800ceaabdb0  EFLAGS: 00000293
[   91.278432] RAX: 0000000000000001 RBX: ffff8800cea8fe20 RCX: 0000000000000000
[   91.278498] RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff81876500
[   91.278564] RBP: ffff8800ceaabde0 R08: ffff8800ceaaa000 R09: 0000000000000000
[   91.278630] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cea80220
[   91.278696] R13: 0000000000000001 R14: ffff8800cea8fe44 R15: ffffffff810d3b01
[   91.278765] FS:  0000000000000000(0000) GS:ffff8800cfe59000(0000) knlGS:0000000000000000
[   91.278848] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   91.278911] CR2: 0000000000000000 CR3: 0000000001805000 CR4: 0000000000000660
[   91.278978] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   91.279068] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   91.279134] Process migration/0 (pid: 6, threadinfo ffff8800ceaaa000, task ffff8800cea867e0)
[   91.279218] Stack:
[   91.279273]  ffff8800ceaaa000 ffff8800cea8fd90 ffff8800ceaaa000 ffff8800cea867e0
[   91.279498]  ffff8800cfe67a80 ffffffff810d3b10 ffff8800ceaabee0 ffffffff810d3841
[   91.279720]  00000000ceaabe40 ffff8800ceaabfd8 ffff8800cea867e0 ffff8800cfe67a88
[   91.279945] Call Trace:
[   91.280004]  [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
[   91.280070]  [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
[   91.280140]  [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
[   91.280205]  [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
[   91.280272]  [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
[   91.280339]  [<ffffffff8108dc76>] kthread+0x96/0xa0
[   91.280402]  [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
[   91.280490]  [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
[   91.280556]  [<ffffffff815b27e0>] ? gs_change+0x13/0x13
[   91.280618] Code: 41 83 fd 03 74 42 f0 41 ff 0e 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fd 04 74 3a 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c6 ff 14 25 10 4e 81 
[   91.283044] Call Trace:
[   91.283102]  [<ffffffff810d3b10>] ? stop_one_cpu_nowait+0x50/0x50
[   91.283167]  [<ffffffff810d3841>] cpu_stopper_thread+0xf1/0x1c0
[   91.283259]  [<ffffffff815a9776>] ? __schedule+0x3c6/0x760
[   91.283323]  [<ffffffff815aa749>] ? _raw_spin_unlock_irqrestore+0x19/0x30
[   91.283390]  [<ffffffff810d3750>] ? res_counter_charge+0x150/0x150
[   91.283457]  [<ffffffff8108dc76>] kthread+0x96/0xa0
[   91.283523]  [<ffffffff815b27e4>] kernel_thread_helper+0x4/0x10
[   91.283589]  [<ffffffff815aacbc>] ? retint_restore_args+0x5/0x6
[   91.283658]  [<ffffffff815b27e0>] ? gs_change+0x13/0x13
[  341.339249] INFO: rcu_sched self-detected stall on CPU { 0}  (t=60000 jiffies)
[  341.339503] sending NMI to all CPUs:

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/xen.gz... ok
Loading latest/vmlinuz... ok
Loading latest/initramfs.cpio.gz... ok
 __  __            _  _    _    _ ____   ___  _ ____  _  _   
 \ \/ /___ _ __   | || |  / |  / |___ \ / _ \/ |___ \| || |  
  \  // _ \ '_ \  | || |_ | |__| | __) | | | | | __) | || |_ 
  /  \  __/ | | | |__   _|| |__| |/ __/| |_| | |/ __/|__   _|
 /_/\_\___|_| |_|    |_|(_)_|  |_|_____|\___/|_|_____|  |_|  
                                                             
(XEN) Xen version 4.1-120320 (konrad@dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) Tue Mar 20 18:10:22 EDT 2012
(XEN) Latest ChangeSet: Wed Mar 14 12:02:02 2012 +0000 23267:14416d8215d4
(XEN) Bootloader: unknown
(XEN) Command line: com1=115200,8n1 console=com1,vga guest_loglvl=all cpufreq=verbose loglvl=all apic=debug
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: none; EDID transfer time: 2 seconds
(XEN)  EDID info not retrieved because no DDC retrieval method detected
(XEN) Disc information:
(XEN)  Found 0 MBR signatures
(XEN)  Found 0 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009d800 (usable)
(XEN)  000000000009d800 - 00000000000a0000 (reserved)
(XEN)  00000000000cc000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 000000007fff0000 (usable)
(XEN)  000000007fff0000 - 0000000080000000 (reserved)
(XEN)  0000000080000000 - 00000000cfef0000 (usable)
(XEN)  00000000cfef0000 - 00000000cfef5000 (ACPI data)
(XEN)  00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
(XEN)  00000000cff80000 - 00000000d0000000 (reserved)
(XEN)  00000000e0000000 - 00000000f0000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec10000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000fff80000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 0000000130000000 (usable)
(XEN) ACPI: RSDP 000F79B0, 0024 (r2 PTLTD )
(XEN) ACPI: XSDT CFEF0753, 009C (r1 DELL   PE_SC3    6040000 DELL        0)
(XEN) A CFEF3D53, 0032 (r1 Phoeni  x        6040000  TL         0)
(XEN) ACPI: SLIC CFEF3D85, 0024 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: SPCR CFEF3DA9, 0050 (r1 DELL   PE_SC3    6040000 PTL         1)
(XEN) ACPI: EINJ CFEF3DF9, 01B0 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: HEST CFEF3FA9, 00A8 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: BERT CFEF4051, 0030 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SSDT CFEF4081, 00E1 (r1 wheaos  wheaosc  6040000 INTL 20050624)
(XEN) ACPI: ERST CFEF4162, 0270 (r1 PTL    WHEAPTL   6040000 PTL         1)
(XEN) ACPI: SRAT CFEF43D2, 00E8 (r1 AMD    HAMMER    6040000 AMD         1)
(XEN) ACPI: SSDT CFEF44BA, 0A30 (r1 AMD    POWERNOW  6040000 AMD         1)
(XEN) ACPI: MCFG CFEF4EEA, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
(XEN) ACPI: HPET CFEF4F26, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
(XEN) ACPI: APIC CFEF4F5E, 007A (r1 PTLTD  	 APIC    6040000  LTP        0)
(XEN) ACPI: BOOT CFEF4FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
(XEN) System RAM: 4094MB (4192756kB)
(XEN) SRAT: PXM 0 -> APIC 0 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 1 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 2 -> Node 0
(XEN) SRAT:
(XEN) NUMA: Using 8 for the hash shift.
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000f7a70
(XEN) DMI present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x8008
(XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[8004,0], pm1x_evt[8000,0]
(XEN) ACPI:                  wakeup_vec[cfef5fcc], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
(XEN) Processor #0 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
(XEN) Processor #1 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 0:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
(XEN) Processor #3 0:2 APIC version 16
(XEN) ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x10de8201 base: 0xfed00000
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
(XEN) PCI: MCFG area at e0000000 reserved in E820
(XEN) ERST table is invalid
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) IRQ limits: 24 GSI, 760 MSI/MSI-X
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2109.757 MHz processor.
(XEN) Initing memory sharing.
(XEN) AMD Fam10h machine check reporting enabled
(XEN) A
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
(XEN) Platform timer is 25.000MHz HPET
(XEN) Allocated console ring of 32 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Supported advanced features:
(XEN)  - Nested Page Tables (NPT)
(XEN)  - Last Branch Record (LBR) Virtualisation
(XEN) HVM: SVM enabled
(XEN) HVM: Hardware Assisted Paging (HAP) detected
(XEN) HVM: HAP page sizes: 4kB, 2MB, 1GB
(XEN) Brought up 4 CPUs
(XEN) HPET: 3 timers in total, 0 timers will be used for broadcast
(XEN) ACPI sleep modes: S3
(XEN) MCA: Use hw thresh(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 32-bit, PAE, lsb, paddr 0x1000000 -> 0x19f9000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   000000011e000000->0000000120000000 (951929 pages to be allocated)
(XEN)  Init. ramdisk: 0000000125b2a000->000000012ffff600
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: 00000000c1000000->00000000c19f9000
(XEN)  Init. ramdisk: 00000000c19f9000->00000000cbece600
(XEN)  Phys-Mach map: 00000000cbecf000->00000000cc2a1d3c
(XEN)  Start info:    00000000cc2a2000->00000000cc2a24b4
(XEN)  Page tables:   00000000cc2a3000->00000000cc30b000
(XEN)  Boot stack:    00000000cc30b000->00000000cc30c000
(XEN)  TOTAL:         00000000c0000000->00000000cc400000
(XEN)  ENTRY ADDRESS: 00000000c1695000
(XEN) Dom0 has maximum 4 VCPUs
(XEN) Scrubbing Free RAM: .done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) Xen is relinquishing VGA cot memory.
mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
[    0.000000] Reserving virtual address space above 0xff800000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0upstream-01180-ged378a5 (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Mar 20 18:34:04 EDT 2012
[    0.000000] Freeing  9d-100 pfn range: 99 pages freed
[    0.000000] Freeing  7fff0-80000 pfn range: 16 pages freed
[    0.000000] Freeing  cfef0-f4b4f pfn range: 150623 pages freed
[    0.000000] Released 150738 pages of unused memory
[    0.000000] Set 196995 page(s) to 1-1 mapping
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  Xen: 000000000009d800 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  Xen: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  Xen: 0000000080000000 - 00000000cfef0000 (usable)
[    0.000000]  Xen: 00000000cfef0000 - 00000000cfef5000 (ACPI data)
[    0.000000]  Xen: 00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
[    0.000000]  Xen: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  Xen: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  Xen: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  Xen: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  Xen: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x1000000
[    0.000000] found SMP MP-table at [c00f7a70] f7a70
[    0.000000] initial memory mapped : 0 - 0cbff000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ ca42000-cbff000
(XEN) mm.c:907:d0 Error getting mfn 1e09d (pfn deae3) from L1 entry 000000001e09d023 for l1e_owner=0, pg_owner=0
(XEN) mm.c:4962:d0 ptwr_emulate: fixing up invalid PAE PTE 000000001e09d023
(XEN) mm.c:907:d0 Error getting mfn 1e09e (pfn deae4) from L1 entry 000000001e09e023 for l1e_owner=0, pg_owner=0
(XEN) mm.c:4962:d0 ptwr_emulate: fixing up invalid PAE PTE 000000001e09e023
(XEN) mm.c:907:d0 Error getting mfn 1e09f (pfn deae5) from L1 entry 000000001e09f023 for l1e_owner=0, pg_owner=0
(XEN) mm.c:4962:d0 ptwr_emulate: fixing up invalid PAE PTE 000000001e09f023
[    0.000000] xen: setting RW the range cb96000 - cbff000
[    0.000000] RAMDISK: 019f9000 - 0becf000
[    0.000000] ACPI: RSDP 000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS cfef5fc0 00040
[    0.000000] ACPI: TCPA cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3980MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000] free_area_init_node: node 0, pgdat c168abc0, node_mem_map f4dfd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7961 pages used for memmap
[    0.000000]   HighMem zone: 814025 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] BIOS bug: APIC version is 0 for CPU 0/0x0, fixing up to 0x10
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 272
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-120320 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f4db7000 s29568 r0 d23680 u53248
[    0.000000] pcpu-alloc: s29568 r0 d23680 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    2.178026] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038444
[    2.178034] Kernel command line: earlyprintk=xen debug nofb console=tty console=hvc0 xen-pciback.hide=(05:00.0)(05:00.1) loglevel=10
[    2.178219] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    2.178426] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    2.178719] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    2.179092] Initializing CPU#0
[    2.246477] Placing 64MB software IO TLB between f0cf3000 - f4cf3000
[    2.246487] software IO TLB at phys 0x30cf3000 - 0x34cf3000
[    2.246495] Initializing HighMem for node 0 (000373fe:00130000)
[    2.567542] Memory: 3117944k/4980736k available (5108k kernel code, 288316k reserved, 1630k data, 492k init, 2501512k highmem)
[    2.567555] virtual kernel memory layout:
[    2.567556]     fixmap  : 0xff715000 - 0xff7ff000   ( 936 kB)
[    2.567557]     pkmap   : 0xff400000 - 0xff600000   (2048 kB)
[    2.567559]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    2.567560]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    2.567562]       .init : 0xc1695000 - 0xc1710000   ( 492 kB)
[    2.567563]       .data : 0xc14fd186 - 0xc1694d00   (1630 kB)
[    2.567564]       .text : 0xc1000000 - 0xc14fd186   (5108 kB)
[    2.567692] Hierarchical RCU implementation.
[    2.567706] NR_IRQS:2304 nr_irqs:1024 16
[    2.567761] CPU 0 irqstacks, hard=f0808000 soft=f080a000
[    2.567767] xen: sci override: global_irq=9 trigger=0 polarity=1
[    2.567773] xen: registering gsi 9 triggering 0 polarity 1
[    2.567785] xen: --> pirq=9 -> irq=9 (gsi=9)
[    2.567793] xen: acpi sci 9
[    2.567799] xen: --> pirq=1 -> irq=1 (gsi=1)
[    2.567806] xen: --> pirq=2 -> irq=2 (gsi=2)
[    2.567812] xen: --> pirq=3 -> irq=3 (gsi=3)
[    2.567818] xen: --> pirq=4 -> irq=4 (gsi=4)
[    2.567824] xen: --> pirq=5 -> irq=5 (gsi=5)
[    2.567830] xen: --> pirq=6 -> irq=6 (gsi=6)
[    2.567836] xen: --> pirq=7 -> irq=7 (gsi=7)
[    2.567843] xen: --> pirq=8 -> irq=8 (gsi=8)
[    2.567847] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    2.567851] xen: --> pirq=9 -> irq=9 (gsi=9)
[    2.567858] xen: --> pirq=10 -> irq=10 (gsi=10)
[    2.567864] xen: --> pirq=11 -> irq=11 (gsi=11)
[    2.567870] xen: --> pirq=12 -> irq=12 (gsi=12)
[    2.567876] xen: --> pirq=13 -> irq=13 (gsi=13)
[    2.567905] xen: --> pirq=14 -> irq=14 (gsi=14)
[    2.567912] xen: --> pirq=15 -> irq=15 (gsi=15)
[    2.570025] Console: colour VGA+ 80x25
[    2.579438] console [tty0] enabled
[    2.579499] console [hvc0] enabled, bootconsole disabled
[    2.579499] console [hvc0] enabled, bootconsole disabled
[    2.579583] Xen: using vcpuop timer interface
[    2.579648] installing Xen timer for CPU 0
[    2.579733] Detected 2109.756 MHz processor.
[    2.579800] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.51 BogoMIPS (lpj=2109756)
[    2.579927] pid_max: default: 32768 minimum: 301
[    2.580055] Security Framework initialized
[    2.580118] SELinux:  Initializing.
[    2.580188] SELinux:  Starting in permissive mode
[    2.580274] Mount-cache hash table entries: 512
[    2.580563] Initializing cgroup subsys cpuacct
[    2.580626] Initializing cgroup subsys freezer
[    2.580745] CPU: Physical Processor ID: 0
[    2.580807] CPU: Processor Core ID: 0
[    2.584362] ACPI: Core revision 20120111
[    2.592290] cpu 0 spinlock event irq 273
[    2.592411] Performance Events: (XEN) traps.c:2458:d0 Domain attempted WRMSR 00000000c0010004 from 0x00000852a245b8c0 to 0x000000000000abcd.
Broken PMU hardware detected, using software events only.
[    2.592716] MCE: In-kernel MCE decoding enabled.
[    2.594278] NMI watchdog disabled (cpu0): hardware events not enabled
[    2.594571] CPU 1 irqstacks, hard=f0894000 soft=f0896000
[    2.594637] installing Xen timer for CPU 1
[    2.594711] cpu 1 spinlock event irq 279
[    2.594841] Initializing CPU#1
[    2.594937] NMI watchdog disabled (cpu1): hardware events not enabled
[    2.595278] CPU 2 irqstacks, hard=f08a2000 soft=f08a4000
[    2.595343] installing Xen timer for CPU 2
[    2.595424] cpu 2 spinlock event irq 285
[    2.595543] Initializing CPU#2
[    2.595631] NMI watchdog disabled (cpu2): hardware events not enabled
[    2.595973] CPU 3 irqstacks, hard=f08ce000 soft=f08d0000
[    2.596038] installing Xen timer for CPU 3
[    2.596111] cpu 3 spinlock event irq 291
[    2.596228] Initializing CPU#3
[    2.596319] NMI watchdog disabled (cpu3): hardware events not enabled
[    2.596488] Brought up 4 CPUs
[    2.597321] PM: Registering ACPI NVS region at cfef5000 (565248 bytes)
[    2.597653] kworker/u:0 used greatest stack depth: 7180 bytes left
[    2.597757] Grant tables using version 2 layout.
[    2.597836] Grant table initialized
[    2.597925] RTC time: 23:21:53, date: 03/20/12
[    2.598081] NET: Registered protocol family 16
[    2.598947] node 0 link 0: io port [1000, 4fff]
[    2.599013] node 0 link 0: io port [5000, fffff]
[    2.599079] TOM: 00000000d0000000 aka 3328M
[    2.599143] node 0 link 0: mmio [d0000000, d05fffff]
[    2.599246] node 0 link 0: mmio [fed00000, fed0ffff]
[    2.599351] node 0 link 0: mmio [d8000000, dfffffff]
[    2.599457] node 0 link 0: mmio [fec00000, fec0ffff]
[    2.599558] node 0 link 0: mmio [e0000000, efffffff]
[    2.599677] node 0 link 0: mmio [a0000, bffff]
[    2.599803] node 0 link 0: mmio [f0000000, fe0bffff]
[    2.599907] TOM2: 0000000130000000 aka 4864M
[    2.599970] bus: [00, ff] on node 0 link 0
[    2.600032] bus: 00 index 0 [io  0x0000-0xffff]
[    2.600094] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    2.600158] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    2.600223] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    2.600287] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    2.600351] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    2.600414] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    2.600557] ACPI: bus type pci registered
[    2.600872] dca service started, version 1.12.1
[    2.601018] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    2.601108] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    2.601198] PCI: Using MMCONFIG for extended config space
[    2.601262] PCI: Using configuration type 1 for base access
[    2.601485] kworker/u:0 used greatest stack depth: 7060 bytes left
[    2.615542] bio: create slab <bio-0> at 0
[    2.615886] ACPI: Added _OSI(Module Device)
[    2.615950] ACPI: Added _OSI(Processor Device)
[    2.616013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.616077] ACPI: Added _OSI(Processor Aggregator Device)
[    2.618506] ACPI: EC: Look up EC in DSDT
[    2.619292] \_SB_:_OSC evaluation returned wrong type
[    2.619356] _OSC request data:1 7 
[    2.626893] ACPI: Interpreter enabled
[    2.626960] ACPI: (supports S0 S4 S5)
[    2.627170] ACPI: Using IOAPIC for interrupt routing
[    2.642449] ACPI: No dock devices found.
[    2.642516] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.642759] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.643012] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.643081] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.643149] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.643233] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    2.643317] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    2.643401] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed8ffff]
[    2.643576] PCI host bridge to bus 0000:00
[    2.643639] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.643706] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.643772] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.643841] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    2.643908] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    2.643976] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    2.644088] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    2.644405] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    2.644486] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    2.644642] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    2.644728] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    2.644835] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    2.644910] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    2.645020] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    2.645120] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    2.645205] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    2.645370] pci 0000:00:02.0: supports D1 D2
[    2.645454] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.645544] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    2.645629] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    2.645794] pci 0000:00:02.1: supports D1 D2
[    2.645856] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    2.646008] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    2.646100] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    2.646175] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    2.646250] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    2.646324] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    2.646399] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    2.646475] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    2.646639] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    2.646731] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    2.646829] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    2.646903] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    2.646978] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    2.647052] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    2.647125] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    2.647276] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    2.647414] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    2.647600] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.647713] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    2.647895] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.648006] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    2.648185] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.648321] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    2.648484] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.648593] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    2.648746] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    2.648878] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    2.649014] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    2.649169] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    2.649362] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    2.649457] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    2.649535] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    2.649695] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.649861] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    2.649949] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    2.650028] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    2.650103] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    2.650215] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.650318] pci 0000:01:08.0: supports D1 D2
[    2.650425] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    2.650491] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    2.650560] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    2.650630] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    2.650831] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    2.650929] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    2.651204] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    2.652905] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    2.652979] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    2.653122] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.653270] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    2.653440] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    2.653525] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    2.653606] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    2.653686] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    2.653830] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.654007] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    2.654128] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    2.654213] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    2.654293] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    2.654373] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    2.654493] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.654633] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    2.654732] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.654836] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    2.654906] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    2.654975] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    2.655075] pci_bus 0000:00: on NUMA node 0
[    2.655162] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.655300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    2.655415] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    2.655516] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    2.655610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    2.655704] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    2.655794]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.655860]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    2.655946] ACPI _OSC control for PCIe not granted, disabling ASPM
(XEN) PCI add device 00:00.0
(XEN) PCI add device 00:01.0
(XEN) PCI add device 00:01.1
(XEN) PCI add device 00:02.0
(XEN) PCI add device 00:02.1
(XEN) PCI add device 00:07.0
(XEN) PCI add device 00:08.0
(XEN) PCI add device 00:09.0
(XEN) PCI add device 00:0b.0
(XEN) PCI add device 00:0c.0
(XEN) PCI add device 00:0d.0
(XEN) PCI add device 00:0e.0
(XEN) PCI add device 00:18.0
(XEN) PCI add device 00:18.1
(XEN) PCI add device 00:18.2
(XEN) PCI add device 00:18.3
(XEN) PCI add device 00:18.4
(XEN) PCI add device 01:07.0
(XEN) PCI add device 01:08.0
(XEN) PCI add device 02:00.0
(XEN) PCI add device 05:00.0
(XEN) PCI add device 05:00.1
[    2.691256] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    2.691769] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    2.692191] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    2.692630] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    2.694643] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    2.695174] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    2.695610] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    2.696026] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    2.696481] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    2.696945] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    2.697405] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    2.697854] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    2.698340] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    2.698769] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    2.699298] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    2.699879] xen/balloon: Initialising balloon driver.
[    2.703668] xen-balloon: Initialising balloon driver.
[    2.703902] xen/balloon: Xen selfballooning driver disabled for domain0.
[    2.704146] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    2.704237] vgaarb: loaded
[    2.704294] vgaarb: bridge control possible 0000:01:08.0
[    2.704822] usbcore: registered new interface driver usbfs
[    2.704961] usbcore: registered new interface driver hub
[    2.705151] usbcore: registered new device driver usb
[    2.705597] PCI: Using ACPI for IRQ routing
[    2.705663] PCI: pci_cache_line_size set to 64 bytes
[    2.705857] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    2.705914] reserve RAM buffer: 000000007fff0000 - 000000007fffffff 
[    2.706019] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff 
[    2.706507] NetLabel: Initializing
[    2.706620] NetLabel:  domain hash size = 128
[    2.706681] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.706851] NetLabel:  unlabeled traffic allowed by default
[    2.707137] Switching to clocksource xen
[   39.063266] BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]
[   39.063335] Modules linked in:
[   39.063453] Modules linked in:
[   39.063548] 
[   39.063605] Pid: 6, comm: migration/0 Not tainted 3.3.0upstream-01180-ged378a5 #1 Dell Inc. PowerEdge T105 /0RR825
[   39.063806] EIP: 0061:[<c10bb16a>] EFLAGS: 00000293 CPU: 0
[   39.063875] EIP is at stop_machine_cpu_stop+0x6a/0xc0
[   39.063939] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000008
[   39.064005] ESI: f0859f34 EDI: f0859f48 EBP: f0869efc ESP: f0869ee8
[   39.064071]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
[   39.064135] Process migration/0 (pid: 6, ti=f0868000 task=f08530b0 task.ti=f0868000)
[   39.064219] Stack:
[   39.064275]  01000000 f0850234 f0859ef0 f08530b0 f4dbaa70 f0869fb8 c10bae81 00000000
[   39.064647]  f0869f20 c1087c03 00000002 00000000 f08530b0 f4dbaa74 c10bb100 f0859f34
[   39.065040]  c170b974 f0869f4c c102f534 f08530b0 c170ec00 c170ec00 f08489f0 00000000
[   39.065412] Call Trace:
[   39.065474]  [<c10bae81>] cpu_stopper_thread+0xc1/0x190
[   39.065542]  [<c1087c03>] ? finish_task_switch+0x43/0xd0
[   39.065609]  [<c10bb100>] ? stop_one_cpu_nowait+0x40/0x40
[   39.065676]  [<c102f534>] ? check_events+0x8/0xc
[   39.065740]  [<c102ebba>] ? xen_force_evtchn_callback+0x1a/0x30
[   39.065807]  [<c102f534>] ? check_events+0x8/0xc
[   39.065876]  [<c102f52b>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   39.065946]  [<c14f6544>] ? _raw_spin_unlock_irqrestore+0x14/0x30
[   39.066014]  [<c10866c9>] ? complete+0x49/0x60
[   39.066101]  [<c10badc0>] ? res_counter_charge+0x120/0x120
[   39.066168]  [<c107dc74>] kthread+0x74/0x80
[   39.066232]  [<c107dc00>] ? kthread_freezable_should_stop+0x60/0x60
[   39.066302]  [<c14fc3b6>] kernel_thread_helper+0x6/0x10
[   39.066364] Code: 00 83 fb 03 74 3b f0 ff 0f 0f 94 c0 84 c0 74 0f 8b 46 10 8b 56 08 83 c0 01 89 56 14 89 46 10 83 fb 04 74 2d 89 d8 f3 90 8b 5e 10 <39> c3 74 f0 83 fb 02 75 cd ff 15 28 0b 66 c1 eb ca 90 8d 74 26 
[   39.068866] Call Trace:
[   39.068926]  [<c10bae81>] cpu_stopper_thread+0xc1/0x190
[   39.068992]  [<c1087c03>] ? finish_task_switch+0x43/0xd0
[   39.069058]  [<c10bb100>] ? stop_one_cpu_nowait+0x40/0x40
[   39.069127]  [<c102f534>] ? check_events+0x8/0xc
[   39.069192]  [<c102ebba>] ? xen_force_evtchn_callback+0x1a/0x30
[   39.069262]  [<c102f534>] ? check_events+0x8/0xc
[   39.069327]  [<c102f52b>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   39.069394]  [<c14f6544>] ? _raw_spin_unlock_irqrestore+0x14/0x30
[   39.069465]  [<c10866c9>] ? complete+0x49/0x60
[   39.069529]  [<c10badc0>] ? res_counter_charge+0x120/0x120
[   39.069599]  [<c107dc74>] kthread+0x74/0x80
[   39.069666]  [<c107dc00>] ? kthread_freezable_should_stop+0x60/0x60
[   39.069737]  [<c14fc3b6>] kernel_thread_helper+0x6/0x10
[   92.123442] BUG: soft lockup - CPU#0 stuck for 35s! [migration/0:6]
[   92.123511] Modules linked in:
[   92.123627] Modu /0RR825
[   92.123975] EIP: 0061:[<c10bb16a>] EFLAGS: 00000293 CPU: 0
[   92.124039] EIP is at stop_machine_cpu_stop+0x6a/0xc0
[   92.124103] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000008
[   92.124169] ESI: f0859f34 EDI: f0859f48 EBP: f0869efc ESP: f0869ee8
[   92.124235]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
[   92.124299] Process migration/0 (pid: 6, ti=f0868000 task=f08530b0 task.ti=f0868000)
[   92.124382] Stack:
[   92.124438]  01000000 f0850234 f0859ef0 f08530b0 f4dbaa70 f0869fb8 c10bae81 00000000
[   92.124810]  f0869f20 c1087c03 00000002 00000000 f08530b0 f4dbaa74 c10bb100 f0859f34
[   92.125201]  c170b974 f0869f4c c102f534 f08530b0 c170ec00 c170ec00 f08489f0 00000000
[   92.125571] Call Trace:
[   92.125631]  [<c10bae81>] cpu_stopper_thread+0xc1/0x190
[   92.125697]  [<c1087c03>] ? finish_task_switch+0x43/0xd0
[   92.125767]  [<c10bb100>] ? stop_one_cpu_nowait+0x40/0x40
[   92.125836]  [<c102f534>] ? check_events+0x8/0xc
[   92.125901]  [<c102ebba>] ? xen_force_evtchn_callback+0x1a/0x30
[   92.125972]  [<c102f534>] ? check_events+0x8/0xc
[   92.126036]  [<c102f52b>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   92.126108]  [<c14f6544>] ? _raw_spin_unlock_irqrestore+0x14/0x30
[   92.126179]  [<c10866c9>] ? complete+0x49/0x60
[   92.126266]  [<c10badc0>] ? res_counter_charge+0x120/0x120
[   92.126336]  [<c107dc74>] kthread+0x74/0x80
[   92.126399]  [<c107dc00>] ? kthread_freezable_should_stop+0x60/0x60
[   92.126472]  [<c14fc3b6>] kernel_thread_helper+0x6/0x10
[   92.126538] Code: 00 83 fb 03 74 3b f0 ff 0f 0f 94 c0 84 c0 74 0f 8b 46 10 8b 56 08 83 c0 01 89 56 14 89 46 10 83 fb 04 74 2d 89 d8 f3 90 8b 5e 10 <39> c3 74 f0 83 fb 02 75 cd ff 15 28 0b 66 c1 eb ca 90 8d 74 26 
[   92.129034] Call Trace:
[   92.129094]  [<c10bae81>] cpu_stopper_thread+0xc1/0x190
[   92.129160]  [<c1087c03>] ? finish_task_switch+0x43/0xd0
[   92.129229]  [<c10bb100>] ? stop_one_cpu_nowait+0x40/0x40
[   92.129299]  [<c102f534>] ? check_events+0x8/0xc
[   92.129367]  [<c102ebba>] ? xen_force_evtchn_callback+0x1a/0x30
[   92.129438]  [<c102f534>] ? check_events+0x8/0xc
[   92.129503]  [<c102f52b>] ? xen_restore_fl_direct_reloc+0x4/0x4
[   92.129574]  [<c14f6544>] ? _raw_spin_unlock_irqrestore+0x14/0x30
[   92.129645]  [<c10866c9>] ? complete+0x49/0x60
[   92.129713]  [<c10badc0>] ? res_counter_charge+0x120/0x120
[   92.129783]  [<c107dc74>] kthread+0x74/0x80
[   92.129846]  [<c107dc00>] ? kthread_freezable_should_stop+0x60/0x60
[   92.129918]  [<c14fc3b6>] kernel_thread_helper+0x6/0x10
[  342.208031] INFO: rcu_sched self-detected stall on CPU { 0}  (t=60000 jiffies)
[  342.208287] sending NMI to all CPUs:
--------------------------
(tst001-BAREMETAL) SERIAL
--------------------------
ÿûÿýÿûÿýPXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz................................................................
Loading latest/initramfs.cpio.gz..............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
 ..........................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.t/vmlinuz 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 0000000080000000 - 00000000cfef0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cfef5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f7a70] f7a70
[    0.000000]   mpc: 9e171-9e2b5
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfef0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfef0000 page 4k
[    0.000000] kernel direct mapping tables up to cfef0000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ cfeee000-cfef0000
[    0.000000] RAMDISK: 7c279000 - 7ffcf000
[    0.000000] ACPI: RSDP 00000000000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP 00000000cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT 00000000cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cfef5fc0 00040
[    0.000000] ACPI: TCPA 00000000cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC 00000000cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR 00000000cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ 00000000cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST 00000000cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT 00000000cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST 00000000cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT 00000000cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG 00000000cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC 00000000cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-d0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-130000000
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,d0000000) -> [0,d0000000)
[    0.000000] NUMA: Node 0 [0,d0000000) + [100000000,130000000) -> [0,130000000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000012fffb000 - 000000012fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012b600000-ffff88012effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007fff0000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 00000000cfef5000
[    0.000000] PM: Registered nosave memory: 00000000cfef5000 - 00000000cff7f000
[    0.000000] PM: Registered nosave memory: 00000000cff7f000 - 00000000cff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s78400 r8192 d24000 u524288
[    0.000000] pcpu-alloc: s78400 r8192 d24000 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031144
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 81c0000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3927976k/4980736k available (5846k kernel code, 788044k absent, 264716k reserved, 2857k data, 688k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2109.867 MHz processor.
[    0.000003] Calibrating delay4288 (order: 10, 4194304 bytes)
[    0.032617] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.040470] Mount-cache hash table entries: 256
[    0.045128] Initializing cgroup subsys cpuacct
[    0.049559] Initializing cgroup subsys freezer
[    0.054018] tseg: 00cff80000
[    0.056893] CPU: Physical Processor ID: 0
[    0.060890] CPU: Processor Core ID: 0
[    0.064542] mce: CPU supports 6 MCE banks
[    0.068547] using AMD E400 aware idle routine
[    0.074757] ACPI: Core revision 20120111
[    0.082103] Getting VERSION: 80050010
[    0.085756] Getting VERSION: 80050010
[    0.089408] Getting ID: 0
[    0.092021] Getting ID: ff000000
[    0.095241] Getting LVT0: 10000
[    0.098374] Getting LVT1: 10000
[    0.101512] masked ExtINT on CPU#0
[    0.105050] ENABLING IO-APIC IRQs
[    0.108356] init IO_APIC IRQs
[    0.111317]  apic 4 pin 0 not connected
[    0.115147] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.123040] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.130932] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.138821] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.146713] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.154605] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.162495] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.170387] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.178279] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.186170] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.194236] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.202300] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.210365] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.218429] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.226492] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.234554]  apic 4 pin 16 not connected
[    0.238462]  apic 4 pin 17 not connected
[    0.242364]  apic 4 pin 18 not connected
[    0.246273]  apic 4 pin 19 not connected
[    0.250175]  apic 4 pin 20 not connected
[    0.254091]  apic 4 pin 21 not connected
[    0.257993]  apic 4 pin 22 not connected
[    0.261895]  apic 4 pin 23 not connected
[    0.265947] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.281941] CPU0: Quad-Core AMD Opteron(tm) Processor 1352 stepping 03
[    0.288479] Using local APIC timer interrupts.
[ [    0.397981] ... lapic delta = 1255731
[    0.401627] ... PM-Timer delta = 357939
[    0.405447] ... PM-Timer result ok
[    0.408834] ..... delta 1255731
[    0.411961] ..... mult: 53941434
[    0.415174] ..... calibration result: 200916
[    0.419427] ..... CPU clock speed is 2109.0627 MHz.
[    0.424278] ..... host bus clock speed is 200.0916 MHz.
[    0.429493] Performance Events: AMD PMU driver.
[    0.434026] ... version:                0
[    0.438019] ... bit width:              48
[    0.442097] ... generic registers:      4
[    0.446085] ... value mask:             0000ffffffffffff
[    0.451387] ... max period:             00007fffffffffff
[    0.456671] ... fixed-purpose events:   0
[    0.460672] ... event mask:             000000000000000f
[    0.466068] MCE: In-kernel MCE decoding enabled.
[    0.470682] NMI watchdog enabled, takes one hw-pmu counter.
[    0.476392] Booting Node   0, Processors  #1
[    0.480486] smpboot cpu 1: start_ip = 98000
[    0.495845] masked ExtINT on CPU#1
[    0.501385] NMI watchdog enabled, takes one hw-pmu counter.
[    0.507043]  #2
[    0.508617] smpboot cpu 2: start_ip = 98000
[    0.523972] masked ExtINT on CPU#2
[    0.529502] NMI watchdog enabled, takes one hw-pmu counter.
[    0.535158]  #3 Ok.
[[    0.552427] masked ExtINT on CPU#3
[    0.557952] NMI watchdog enabled, takes one hw-pmu counter.
[    0.563524] Brought up486] Total of 4 processors activated (16878.93 BogoMIPS).
[    0.575208] PM: Registering ACPI NVS region at cfef5000 (565248 bytes)
[    0.581969] kworker/u:0 used greatest stack depth: 6016 bytes left
[    0.581995] RTC time: 23:37:25, date: 03/20/12
[    0.592599] NET: Registered protocol family 16
[    0.597205] kworker/u:0 used greatest stack depth: 5520 bytes left
[    0.597578] node 0 link 0: io port [1000, 4fff]
[    0.597581] node 0 link 0: io port [5000, fffff]
[    0.597583] TOM: 00000000d0000000 aka 3328M
[    0.597586] node 0 link 0: mmio [d0000000, d05fffff]
[    0.597588] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.597591] node 0 link 0: mmio [d8000000, dfffffff]
[    0.597593] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.597595] node 0 link 0: mmio [e0000000, efffffff]
[    0.597597] node 0 link 0: mmio [a0000, bffff]
[    0.597600] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.597602] TOM2: 0000000130000000 aka 4864M
[    0.597604] bus: [00, ff] on node 0 link 0
[    0.597607] bus: 00 index 0 [io  0x0000-0xffff]
[    0.597609] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    0.597611] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    0.597612] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    0.597614] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    0.597616] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    0.597618] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    0.694936] ACPI: bus type pci registered
[    0.699077] dca service started, version 1.12.1
[    0.703653] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    0.712927] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.720275] PCI: Using configuration type 1 for base access
[    0.733049] bio: create slab <bio-0> at 0
[    0.737222] ACPI: Added _OSI(Module Device)
[    0.741392] ACPI: Added _OSI(Pr: Added _OSI(3.0 _SCP Extensions)
[    0.750506] ACPI: Added _OSI(Processor Aggregator Device)
[    0.756741] ACPI: EC: Look up EC in DSDT
[    0.760971] \_SB_:_OSC evaluation returned wrong type
[    0.766007] _OSC request data:1 7 
[    0.772847] ACPI: Interpreter enabled
[    0.776498] ACPI: (supports S0 S4 S5)
[    0.780203] ACPI: Using IOAPIC for interrupt routing
[    0.792709] ACPI: No dock devices found.
[    0.796621] PCI: Using host bridge windows from ACPI; if necessary, use "pci=noc PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.832528] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.839809] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    0.847089] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed8ffff]
[    0.854374] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000cc000-0x000fffff])
[    0.867165] PCI host bridge to bus 0000:00
[    0.871248] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.877406] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.883562] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.890410] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    0.897259] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    0.904117] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.910087] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    0.915987] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.921390] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.927293] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.932681] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.938061] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.943451] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.949273] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.955170] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.961264] pci 0000:00:02.0: supports D1 D2
[    0.965519] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.972118] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.978021] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.984120] pci 0000:00:02.1: supports D1 D2
[    0.988375] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.994982] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    1.000885] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.006267] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.011648] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.017029] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.022409] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.027789] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.033887] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    1.039790] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.045171] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.050551] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.055933] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.061314] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.066694] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.072787] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    1.078702] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    1.084623] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.091225] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    1.097147] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.103747] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    1.109668] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.116268] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    1.122190] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.128795] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    1.134710] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    1.140622] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    1.146534] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    1.152448] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    1.158385] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    1.164294] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    1.169676] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    1.175770] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.182315] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    1.188222] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.194730] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    1.200114] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.206202] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.212721] pci 0000:01:08.0: supports D1 D2
[    1.216998] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    1.222205] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.228275] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.235037] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.242266] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    1.248177] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.254848] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.262790] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    1.267998] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.274781] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.280007] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    1.285244] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    1.291150] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    1.297225] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    1.303301] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    1.308700] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.315234] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.321326] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    1.327230] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    1.333306] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    1.339382] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    1.344782] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.351315] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.357399] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.367369] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    1.372574] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    1.378645] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    1.385417] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.391404] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.397790] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.404162] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.410520] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.416878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.423239]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.428880]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.437371] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.460236] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.466507] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.472751] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.479009] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    1.485253] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.492468] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    1.498708] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.504963] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    1.512167] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.519371] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.526588] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.533787] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.541001] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.547248] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    1.553493] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.560862] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    1.568927] vgaarb: loaded
[    1.571624] vgaarb: bridge control possible 0000:01:08.0
[    1.577153] usbcore: registered new interface driver usbfs
[    1.582665] usbcore: registered new interface driver hub
[    1.588024] usbcore: registered new device driver usb
[    1.593269] PCI: Using ACPI for IRQ routing
[    1.597440] PCI: pci_cache_line_size set to 64 bytes
[    1.602438] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.608596] reserve RAM buffer: 000000007fff0000 - 000000007fffffff 
[    1.614934] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff 
[    1.621494] NetLabel: Initializing
[    1.625063] NetLabel:  domain hash size = 128
[    1.629403] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.634360] NetLabel:  unlabeled traffic allowed by default
[    1.639995] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.647020] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.652008] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.662172] Switching to clocksource hpet
[    1.666308] pnp: PnP ACPI init
[    1.669372] ACPI: bus type pnp registered
[    1.673505] pnp 00:00: [mem 0xffc00000-0xffffffff]
[    1.678285] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    1.683061] pnp 00:00: [mem 0xfee00000-0xfeefffff]
[    1.687835] pnp 00:00: [mem 0xfed00000-0xfed00fff]
[    1.692707] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    1.699646] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.706584] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.713522] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.720115] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.726962] pnp 00:01: [bus 00-ff]
[    1.730357] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.734441] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.739129] pnp 00:01: [io  0x0d00-0xffff window]
[    1.743820] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.749200] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    1.754580] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    1.759961] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    1.764828] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.771356] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.776218] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.782810] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.789901] pnp 00:03: [io  0x8000-0x807f]
[    1.793985] pnp 00:03: [io  0x8080-0x80ff]
[    1.798067] pnp 00:03: [io  0x8400-0x847f]
[    1.802152] pnp 00:03: [io  0x8480-0x84ff]
[    1.806234] pnp 00:03: [io  0x8800-0x887f]
[    1.810319] pnp 00:03: [io  0x8880-0x88ff]
[    1.814402] pnp 00:03: [io  0x2040-0x207f]
[    1.818487] pnp 00:03: [io  0x2000-0x203f]
[    1.822569] pnp 00:03: [io  0x0060]
[    1.826047] pnp 00:03: [io  0x0064]
[    1.829620] system 00:03: [io  0x8000-0x807f] has been reserved
[    1.835520] system 00:03: [io  0x8080-0x80ff] has been reserved
[    1.841420] system 00:03: [io  0x8400-0x847f] has been reserved
[    1.847321] system 00:03: [io  0x8480-0x84ff] has been reserved
[    1.853221] system 00:03: [io  0x8800-0x887f] has been reserved
[    1.859121] system 00:03: [io  0x8880-0x88ff] has been reserved
[    1.865022] system 00:03: [io  0x2040-0x207f] has been reserved
[    1.870921] system 00:03: [io  0x2000-0x203f] has been reserved
[    1.876822] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.883659] pnp 00:04: [irq 0 disabled]
[    1.887494] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.895473] pnp 00:04: [irq 8]
[    1.898518] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    1.903356] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.909872] pnp 00:05: [io  0x0010-0x001f]
[    1.913955] pnp 00:05: [io  0x0022-0x003f]
[    1.918038] pnp 00:05: [io  0x0044-0x005f]
[    1.922122] pnp 00:05: [io  0x0062-0x0063]
[    1.926206] pnp 00:05: [io  0x0065-0x006f]
[    1.930290] pnp 00:05: [io  0x0072-0x0073]
[    1.934373] pnp 00:05: [io  0x0074-0x007f]
[    1.938455] pnp 00:05: [io  0x0091-0x0093]
[    1.942539] pnp 00:05: [io  0x0097-0x009f]
[    1.946622] pnp 00:05: [io  0x00a2-0x00bf]
[    1.950705] pnp 00:05: [io  0x00e0-0x00ef]
[    1.954789] pnp 00:05: [io  0x04d0-0x04d1]
[    1.958970] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.964871] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.971652] pnp 00:06: [io  0x0000-0x0008]
[    1.975736] pnp 00:06: [io  0x000a-0x000f]
[    1.979819] pnp 00:06: [io  0x0081-0x0083]
[    1.983903] pnp 00:06: [io  0x0087]
[    1.987378] pnp 00:06: [io  0x0089-0x008b]
[    1.991462] pnp 00:06: [io  0x008f]
[    1.994940] pnp 00:06: [io  0x00c0-0x00d1]
[    1.999021] pnp 00:06: [io  0x00d4-0x00df]
[    2.003107] pnp 00:06: [dma 4]
[    2.006214] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.012729] pnp 00:07: [io  0x0061]
[    2.016270] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.022808] pnp 00:08: [io  0x0070-0x0071]
[    2.026956] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.033469] pnp 00:09: [io  0x00f0-0x00f1]
[    2.037555] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    2.045704] pnp 00:09: [irq 13]
[    2.048897] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.055416] pnp 00:0a: [io  0x0c00-0x0c7f]
[    2.059589] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    2.065491] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.072469] pnp 00:0b: [io  0x03f8-0x03ff]
[    2.076556] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    2.084532] pnp 00:0b: [irq 4]
[    2.087683] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.094611] pnp: PnP ACPI: found 12 devices
[    2.098783] ACPI: ACPI bus type pnp unregistered
[    2.108002] PCI: max bus depth: 1 pci_try_num: 2
[    2.112629] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04ffff145594] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    2.152359] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    2.159558] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    2.164768] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    2.171534] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.176745] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    2.181965] pci 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd041ffff pref]
[    2.189162] pci 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd043ffff pref]
[    2.196361] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    2.201569] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    2.207643] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    2.214409] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fffff pref]
[    2.221613] pci 0000:00:09.0: setting latency timer to 64
[    2.227002] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.232557] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.238112] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.244359] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfebfffff]
[    2.250606] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed8ffff]
[    2.256853] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    2.262406] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    2.268653] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    2.275331] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    2.281578] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    2.287132] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    2.293378] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pref]
[    2.300132] NET: Registered protocol family 2
[    2.304676] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.313593] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.324516] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.331621] TCP: Hash tables configured (established 524288 bind 65536)
[    2.338214] TCP reno registered
[    2.341355] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.347380] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.353942] NET: Registered protocol family 1
[    2.358431] RPC: Registered named UNIX socket transport module.
[    2.364331] RPC: Registered udp transport module.
[    2.369020] RPC: Registered tcp transport module.
[    2.373708] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.380438] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    2.386192] IOAPIC[0]: Set routing entry (4-23 -> 0x29 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.444993] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    2.450729] IOAPIC[0]: Set routing entry (4-22 -> 0x41 -> Ii00:00:00.0: Found enabled HT MSI Mapping
[    2.469926] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.475399] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.480952] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.486468] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.491943] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.497497] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.503017] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.508495] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.514048] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.519571] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.525047] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.530601] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.536100] pci 0000:01:08.0: Boot video device
[    2.540627] PCI: CLS 64 bytes, default 64
[    2.544738] Trying to unpack rootfs image as initramfs...
[    4.133632] Freeing initrd memory: 62808k freed
[    4.164342] PCI-DMA: Disabling AGP.
[    4.167945] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    4.173498] PCI-DMA: using GART IOMMU.
[    4.177236] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    4.187905] Simple Boot Flag at 0x62 set to 0x1
[    4.192995] Machine check injector initialized
[    4.197441] Failed to A=0x0000000000000100)
[    4.226558] Failed to setup IBS, -22
[    4.230649] microcode: CPU0: patch_level=0x01000065
[    4.235514] microcode: CPU1: patch_level=0x01000065
[    4.240379] microcode: CPU2: patch_level=0x01000065
[    4.245245] microcode: CPU3: patch_level=0x01000065
[    4.250151] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.259227] audit: initializing netlink socket (disabled)
[    4.264626] type=2000 audit(1332286646.802:1): initialized
[    4.285207] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.291762] VFS: Disk quotas dquot_6.5.2
[    4.295er 2.1.30 [Flags: R/W].
[    4.306726] msgmni has been set to 7923
[    4.310933] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.318306] io scheduler noop registered
[    4.322217] io scheduler deadline registered
[    4.326494] io scheduler cfq registered (default)
[    4.331384] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.336745] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.342070] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.347396] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.352751] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.358541] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.366695] ACPI: Power Button [PWRB]
[    4.370440] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.377811] ACPI: Power Button [PWRF]
[    4.381619] ACPI: acpi_idle registered with cpuidle
[    4.388842] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.416797] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.443521] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.470465] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.476480] Non-volatile memory driver v1.3
[    4.480652] Lrsal TUN/TAP device driver, 1.6
[    4.507425] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.513677] tg3.c:v3.122 (December 7, 2011)
[    4.518026] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    4.523763] IOAPIC[0]: Set routing entry (4-19 -> 0x69 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    4.539700] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95722) rev a200] (PCI Express) MAC address 00:1d:09:17:b5:46
[    4.550015] tg3 0000:02:00.0: eth0: attached PHY is 5722/5756 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    4.560246] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.568137] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.574941] work_for_cpu used greatest stack depth: 5016 bytes left
[    4.575000] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.2.0-k
[    4.575002] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    4.575308] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.575311] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    4.609031] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    4.614847] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    4.620075] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file 'devices'
[    4.627965] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    4.635569] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.642948] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[    4.651274] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    4.657869] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    4.665951] ehci_hcd 0000:00:02.1: park 0
[    4.669950] ehci_hcd 0000:00:02.1: debug port 1
[    4.674468] ehci_hcd 0000:00:02.1: reset command 0080b32  park=3 ithresh=8 Async Periodic period=1024 Reset HALT
[    4.684607] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[    4.692325] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    4.699088] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    4.704829] ehci_hcd 0000:00:02.1: irq 22, io mem 0xd0001000
[    4.710470] ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    4.724373] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    4.730122] usb usb1: default language 0x0409
[    4.73446idProduct=0002
[    4.745919] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.753118] usb usb1: Product: EHCI Host Controller
[    4.757978] usb usb1: Manufacturer: Linux 3.3.0upstream-01180-ged378a5 ehci_hcd
[    4.765260] usb usb1: SerialNumber: 0000:00:02.1
[    4.769942] usb usb1: usb_probe_device
[    4.773682] usb usb1: configuration #1 chosen from 1 choice
[    4.779239] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.785017] hub 1-0:1.0: usb_probe_interface
[    4.789273] hub 1-0:1.0: usb_probe_interface - got id
[    4.794308] hub 1-0:1.0: USB hub found
[    4.798048] hub 1-0:1.0: 10 ports detected
[    4.802130] hub 1-0:1.0: standalone hub
[    4.805952] hub 1-0:1.0: no power switching (usb 1.0)
[    4.810986] hub 1-0:1.0: individual port over-current protection
[    4.816971] hub 1-0:1.0: power on to power good time: 20ms
[    4.822439] hub 1-0:1.0: local power source is good
[    4.827301] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.834182] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    4.841821] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.847986] ohci_hcd: block sizes: ed 80 td 96
[    4.852466] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    4.858281] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    4.863491] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '002'
[    4.871087] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    4.878467] ohci_hcd 0000:00:02.0: created debug files
[    4.883586] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    4.889321] ohci_hcd 0000:00:02.0: irq 23, io mem 0xd0000000
[    4.934233] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    4.948197] ohci_hcd 0000:00:02.0: OHCI controller state
[    4.953490] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support r:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[    4.969096] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[    4.974562] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    4.980116] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    4.986795] ohci_hcd 0000:00:02.0: hcca frame #0029
[    4.991657] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    4.998766] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.005358] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.011258] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.017938] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.024615] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.031294] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.037973] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.044651] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.051328] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.058007] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.064685] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.071363] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.078046] usb usb2: default language 0x0409
[    5.082391] usb usb2: udev 1, busnum 2, minor = 128
[    5.087251] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.094015] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.101210] usb usb2: Product: OHCI Host Controller
[    5.106069] usb usb2: Manufacturer: Linux 3.3.0upstream-01180-ged378a5 ohci_hcd
[    5.113351] usb usb2: SerialNumber: 0000:00:02.0
[    5.118046] usb usb2: usb_probe_device
[    5.121783] usb usb2: configuration #1 chosen from 1 choice
[    5.127338] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.133113] hub 2-0:1.0: usb_probe_interface
[    5.137368] hub 2-0:1.0: usb_probe_interface - got id
[    5.142401] hub 2-0:1.0: USB hub found
[    5.146139] hub 2-0:1.0: 10 ports detected
[    5.150221] hub 2-0:1.0: standalone hub
[    5.154039] hub 2-0:1.0: no power switching (usb 1.0)
[    5.159073] hub 2-0:1.0: global over-current protection
[    5.164281] hub 2-0:1.0: power on to power good time: 2ms
[    5.169662] hub 2-0:1.0: local power source is good
[    5.174523] hub 2-0:1.0: no over-current condition exists
[    5.179901] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.186769] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    5.193669] Refined TSC clocksource calibration: 2109.729 MHz.
[    5.193675] Switching to clocksource tsc
[    5.204026] ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
[    5.210137] uhci_hcd: USB Universal Host Controller Interface driver
[    5.216606] usbcore: registered new interface driver usblp
[    5.222124] usbcore: registered new interface driver libusual
[    5.228029] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.286937] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.485808] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.490868] mousedev: PS/2 mouse device common for all mice
[    5.:08: rtc core: registered rtc_cmos as rtc0
[    5.507550] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    5.514335] cpuidle: using governor ladder
[    5.518438] cpuidle: using governor menu
[    5.522348] EFI Variables Facility v0.08 2004-May-17
[    5.527341] zram: num_devices not specified. Using default: 1
[    5.533067] zram: Creating 1 devices ...
[    5.537387] Netfilter messages via NETLINK v0.30.
[    5.542088] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.548304] ctnetlink v0.93: registering with nfnetlink.
[    5.554279] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.559642] TCP cubic registered
[    5.562865] Initializing XFRM netlink socket
[    5.567180] NET: Registered protocol family 10
[    5.572423] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.578075] IPv6 over IPv4 tunneling driver
[    5.582908] NET: Registered protocol family 17
[    5.587386] Registering the dns_resolver key type
[    5.592098] 
[    5.592099] printing PIC contents
[    5.596880] ... PIC  IMR: ffff
[    5.599927] ... PIC  IRR: 1801
[    5.602975] ... PIC  ISR: 0000
[    5.606019] ... PIC ELCR: 1c00
[    5.609062] printing local APIC contents on CPU#0/0:
[    5.614006] ... APIC ID:      00000000 (0)
[    5.618085] ... APIC VERSION: 80050010
[    5.621817] ... APIC TASKPRI: 00000000 (00)
[    5.625982] ... APIC ARBPRI: 000000e0 (e0)
[    5.630062] ... APIC PROCPRI: 00000000
[    5.633795] ... APIC LDR: 01000000
[    5.637175] ... APIC DFR: ffffffff
[    5.640561] ... APIC SPIV: 000001ff
[    5.644029] ... APIC ISR field:
[    5.647163] 0000000000000000000000000000000000000000000000000000000000000000
[    5.654241] ... APIC TMR field:
[    5.657375] 0000000000000000000000000000000000000000000000000000000000000000
[    5.664460] ... APIC IRR field:
[    5.667581] 0000000000000000000000000000000000000000000000000000000000008000
[    5.674661] ... APIC ESR: 00000000
[    5.678048] ... APIC ICR: 000008fc
[    5.681435] ... APIC ICR2: 0e000000
[    5.684903] ... APIC LVTT: 000100ef
[    5.688377] ... APIC LVTPC: 00000400
[    5.691930] ... APIC LVT0: 00010700
[    5.695409] ... APIC LVT1: 00000400
[    5.698876] ... APIC LVTERR: 000000fe
[    5.702528] ... APIC TMICT: 00000000
[    5.706082] ... APIC TMCCT: 00000000
[    5.709636] ... APIC TDCR: 00000003
[    5.713107] ... APIC EFEAT: 00040007
[    5.716664] ... APIC ECTRL: 00000000
[    5.720219] ... APIC EILVT0: 000000f9
[    5.723864] ... APIC EILVT1: 00010000
[    5.727509] ... APIC EILVT2: 00010000
[    5.731150] ... APIC EILVT3: 00010000
[    5.734802] 
[    5.736291] number of MP IRQ sources: 15.
[    5.740285] number of IO-APIC #4 registers: 24.
[    5.744797] testing the IO APIC.......................
[    5.749917] 
[    5.751404] IO APIC #4......
[    5.754273] .... register #00: 04000000
[    5.758093] .......    : physical APIC id: 04
[    5.762432] .......    : Delivery Type: 0
[    5.766425] .......    : LTS          : 0
[    5.770420] .... register #01: 00170011
[    5.774243] .......     : max redirection entries: 17
[    5.779275] .......     : PRQ implemented: 0
[    5.783530] .......     : IO APIC version: 11
[    5.787870] .... register #02: 04000000
[    5.791692] .......     : arbitration: 04
[    5.795687] .... IRQ redirection table:
[    5.799507]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.804972]  00 00  1    0    0   0   0    0    0    00
[    5.810198]  01 0F  0    0    0   0   0    1    1    31
[    5.815413]  02 0F  0    0    0   0   0    1    1    30
[    5.820634]  03 0F  0    0    0   0   0    1    1    33
[    5.825856]  04 0F  0    0    0   0   0    1    1    34
[    5.831079]  05 0F  0    0    0   0   0    1    1    35
[    5.836302]  06 0F  0    0    0   0   0    1    1    36
[    5.841518]  07 0F  1    0    0   0   0    1    1    37
[    5.846739]  08 0F  0    0    0   0   0    1    1    38
[    5.851960]  09 0F  0    1    0   1   0    1    1    39
[    5.857181]  0a 0F  0    0    0   0   0    1    1    3A
[    5.862401]  0b 0F  1    0    0   0   0    1    1    3B
[    5.867624]  0c 0F  1    0    0   0   0    1    1    3C
[    5.872846]  0d 0F  0    0    0   0   0    1    1    3D
[    5.878068]  0e 0F  0    0    0   0   0    1    1    3E
[    5.883291]  0f 0F  0    0    0   0   0    1    1    3F
[    5.888514]  10 00  1    0    0   0   0    0    0    00
[    5.893735]  11 00  1    0    0   0   0    0    0    00
[    5.898956]  12 00  1    0    0   0   0    0    0    00
[    5.904176]  13 0F  1    1    0   1   0    1    1    69
[    5.909401]  14 00  1    0    0   0   0    0    0    00
[    5.914616]  15 00  1    0    0   0   0    0    0    00
[    5.919837]  16 0F  0    1    0   1   0    1    1    41
[    5.925058]  17 0F  0    1    0   1   0    1    1    29
[    5.930278] IRQ to pin mappings:
[    5.933495] IRQ0 -> 0:2
[    5.935952] IRQ1 -> 0:1
[    5.938417] IRQ3 -> 0:3
[    5.940877] IRQ4 -> 0:4
[    5.943334] IRQ5 -> 0:5
[    5.945799] IRQ6 -> 0:6
[    5.948258] IRQ7 -> 0:7
[    5.950723] IRQ8 -> 0:8
[    5.953180] IRQ9 -> 0:9
[    5.955644] IRQ10 -> 0:10
[    5.958276] IRQ11 -> 0:11
[    5.960909] IRQ12 -> 0:12
[    5.963544] IRQ13 -> 0:13
[    5.966174] IRQ14 -> 0:14
[    5.968811] IRQ15 -> 0:15
[    5.971443] IRQ19 -> 0:19
[    5.974071] IRQ22 -> 0:22
[    5.976707] IRQ23 -> 0:23
[    5.979344] .................................... done.
[    5.984601] PM: Hibernation image not present or could not be loaded.
[    5.991030] registered taskstats version 1
[    5.995422]   Magic number: 4:506:656
[    5.999247] processor LNXCPU:09: hash matches
[    6.005037] Freeing unused kernel memory: 688k freed
[    6.010195] Write protecting the kernel read-only data: 8192k
[    6.016986] Freeing unused kernel memory: 276k freed
[    6.023317] Freeing unused kernel memory: 380k freed
init started: BusyBox v1.14.3 (2012-03-20 18:14:36 EDT)
Mounting directories  [  OK  ]
mount: mount point /proc/xen does not exist
mount: mount point /sys/kernel/config does not exist
cat: /sys/hypervisor/type: No[    6.224102] udevd (1277): /proc/1277/oom_adj is deprecated, please use /proc/1277/oom_score_adj instead.
 such file or directory
/usr/bin/load_xen_modules: line 3: [: ==: unary operator expected
[    6.256303] SCSI subsystem initialized
[    6.265448] libata version 3.00 loaded.
[    6.271377] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    6.277217] e1_nv 0000:00:07.0: setting latency timer to 64
^G^G^G^G[    6.307147] e1000e 0000:05:00.0: Disabling ASPM  L1
^G[    6.312745] [drm] radeon defaulting to kernel modesetting.
[    6.312901] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 18
^G^G^G^G^G^G^G^G[    6.312910] IOAPIC[0]: Set routing entry (4-18 -> 0x79 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    6.313023] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
^G^G^G^G^G^G^G^G[    6.314914] scsi0 : sata_nv
^G[    6.342771] [drm] radeon kernel modesetting enabled.
[    6.343795] scsi1 : sata_nv
[    6.347300] ata1: SATA max UDMA/133 cmd 0x20f0 ctl 0x20e0 bmdma 0x20b0 irq 21
[    6.347305] ata2: SATA max UDMA/133 cmd 0x20d0 ctl 0x20c0 bmdma 0x20b8 irq 21
[    6.347718] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    6.347736] IOAPIC[0]: Set routing entry (4-20 -> 0x89 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.347790] sata_nv 0000:00:08.0: setting latency timer to 64
[    6.368372] scsi2 : sata_nv
[    6.368548] scsi3 : sata_nv
[    6.368867] ata3: SATA max UDMA/133 cmd 0x2440 ctl 0x2430 bmdma 0x2400 irq 20
[    6.368870] ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2410 bmdma 0x2408 irq 20
udevd-work[1499][    6.404484] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 17
: error opening [    6.411362] IOAPIC[0]: Set routing entry (4-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    6.411369] powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 1352 (4 cpu cores) (version 2.20.00)
ATTR{/sys/device[    6.430402] powernow-k8:    0 : pstate 0 (2100 MHz)
[    6.431535] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x1028:0x0225).
s/system/cpu/cpu[    6.431565] [drm] register mmio base: 0xD0100000
[    6.431567] [drm] register mmio size: 65536
[    6.431681] radeon 0000:01:08.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (32M used)
0/online} for wr[    6.431686] radeon 0000:01:08.0: GTT: 512M 0x00000000B8000000 - 0x00000000D7FFFFFF
[    6.431695] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.431697] [drm] Driver supports precise vblank timestamp query.
[    6.431719] [drm] radeon: irq initialized.
iting: No such f[    6.488834] powernow-k8:    1 : pstate 1 (1800 MHz)
ile or directory[    6.495057] powernow-k8:    2 : pstate 2 (1600 MHz)


[    6.501286] powernow-k8:    3 : pstate 3 (1300 MHz)
[    6.506554] powernow-k8:    4 : pstate 4 (1050 MHz)
[    6.516125] [drm] Detected VRAM RAM=128M, BAR=128M
[    6.520919] [drm] RAM width 16bits DDR
[    6.528084] [TTM] Zone  kerl allocator.
[    6.543950] [drm] radeon: 32M of VRAM memory ready
[    6.548720] [drm] radeon: 512M of GTT memory ready.
[    6.553600] [drm] GART: num cpu pages 131072, num gpu pages 131072
^G^G^G^G^G^G^G^G^G^G[    6.561132] [drm] radeon: ib pool ready.
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.586378] [drm] PCIE GART of 512M enabled (table at 0x00000000CF880000).
[    6.593268] radeon 0000:01:08.0: WB disabled
0e 0000:05:00.0: eth1: MAC: 0, PHY: 4, PBA No: D50868-003
Waiting for devi[    6.601484] [drm] Loading R100 Microcode
[    6.601824] e1000e 0000:05:00.1: Disabling ASPM  L1
ces [    6.602033] ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 16
[    6.602046] IOAPIC[0]: Set routing entry (4-16 -> 0x99 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    6.602484] ip used greatest stack depth: 4056 bytes left
[[    6.606411] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
^G  OK  [    6.663445] [drm] radeon: ring at 0x00000000B8001000
^G^G]^G^G^G^G^G^[    6.668594] [drm] ring test succeeded in 1 usecs
G^G^G^G^G^G^G^G^[    6.674669] [drm] ib test succeeded in 0 usecs
G^G^G^G^G^G^G^G[    6.680763] [drm] Radeon Display Connectors
^G^G^G^G^G^G^G^G[    6.685932] [drm] Connector 0:
^G^G^G^G^G^G
[    6.690370] [drm]   VGA
[    6.694007] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    6.700037] [drm]   Encoders:
[    6.703043] [drm]     CRT1: INTERNAL_DAC1
[    6.744456] [drm] fb mappable at 0xD8040000
[    6.748640] [drm] vram apper at 0xD8000000
[    6.752727] [drm] size 786432^G^G[    6.762317] fbcon: radeondrmfb (fb0) is primary device
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.808459] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.813457] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.817541] ata3.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, max UDMA/100
[    6.824539] ata3.00: configured for UDMA/100
[    6.827810] ata1.00: ATA-7: WDC WD800AAJS-18TDA1, 01.00A04, max UDMA/133
[    6.827814] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    6.831660] ata1.00: configured for UDMA/133
[    6.831832] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01.0 PQ: 0 ANSI: 5
[    6.926917] Console: switching to colour frame buffer device 128x48
[    6.989315] fb0: radeondrmfb frame buffer device
[    6.993918] drm: registered panic notifier
[    6.998006] [drm] Initialized radeon 2.13.0 20080528 for 0000:01:08.0 on minor 0
[    7.010236] e1000e 0000:05:00.1: eth2: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a3
[    7.018217] e1000e 0000:05:00.1: R) PRO/1000 Network Connection
^G^G^G[    7.025241] e1000e 0000:05:00.1: eth2: MAC: 0, PHY: 4, PBA No: D50868-003
[    7.134193] ata2: SATA link down (SStatus 0 SControl 300)
[    7.141137] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH20N  0D04 PQ: 0 ANSI: 5
[    7.451951] ata4: SATA link down (SStatus 0 SControl 300)
[    7.464019] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    7.471723] sd 0:0:0:0: [sda] Write Protect is off
[    7.471728] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.13-k.
[    7.472150] qla2xxx [0000:01:07.0]-001d: : Found an ISP6312 irq 16 iobase 0xffffc9000065c000.
[    7.472311] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    7.472315] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.474468] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    7.509089] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.514188] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.531893]  sda: sda1 sda2
[    7.535082] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.542154] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.547553] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   37.616831] qla2xxx [0000:01:07.0]-101c:4: Mailbox cmd timeout occured. Scheduling ISP abort eeh_busy=0x0.
[   37.626455] ql- Adapter flags 2.
^G^G^G^G^G^G^G[   37.641257] ttyS0: 4 input overrun(s)
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GWaiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [   37.836120] tg3 0000:02:00.0: irq 46 for MSI/MSI-X
[   37.885326] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.890773] ip used greatest stack depth: 3840 bytes left
[   3^G
Determining IP information for eth1...[   38.079979] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
[   38.135595] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
[   38.141436] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   40.624440] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   40.631117] tg3 0000:02:00.0: eth0: Flow control for RX
[   40.638704] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
^G^G^G^G^G failed; no link present.  Check cable?
[FAILED]
Bringing up interface eth2:  
Determining IP information for eth2...[   43.853568] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
[   43.909143] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
[   43.914970] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   45.997425] e1000e: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   46.005580] ADDRCONF(NETDEV_CHANGE): eG^G^G[   51.394399] eth0: no IPv6 routers present
 done.
[  OK  ]
Bringing up interface switch:  
Determining IP information for s[   52.164094] switch: port 1(eth0) entered forwarding state
witch...[   52.170236] switch: p^G done.
[  OK  ]
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [3060]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [3060] ignoring start request
[   53.642426] Loading iSCSI transport class v2.0-870.
[   53.649847] iscsi: registered transport (tcp)
iscsistart: transport sid version 2.0-872
Could not get list of targets from firmware.
Mar 20 23:38:18 tst001 syslogd 1.5.0: restart.
^G^G^G^G^G^G^GYou might have to do kill -1 1 if you see 'can't open /dev/hvc0'
[0:0:0:0]    disk    ATA      WDC WD800AAJS-18 01.0  /dev/sda 
[2:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM GDRH20N  0D04  /dev/sr0 
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA f1)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:07.0 Fibre Channel: QLogic Corp. SP202-based 2Gb Fibre Channel to PCI-X HBA (rev 03)
01:08.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5722 Gigabit Ethernet PCI Express
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
05:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
           CPU0       CPU1       CPU2       CPU3       
  0:        181         18        157      49133   IO-APIC-edge      timer
  1:          1          0          2          0   IO-APIC-edge      i8042
  4:          0          0          4        209   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge    
  8:          0          1          5         28   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          1          0          0          0   IO-APIC-edge    
 17:          0          0          7        296   IO-APIC-fasteoi   radeon
 20:          0          0          2        103   IO-APIC-fasteoi   sata_nv
 21:          0          0          0          4   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 44:          0          0          0          9   PCI-MSI-edge      eth1
 45:          0          0          2         41   PCI-MSI-edge      eth2
 46:          0          0          1         62   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      51760       3327       7669       3944   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       2551       2712       4105       2122   Rescheduling interrupts
CAL:        273        251        257        230   Function call interrupts
TLB:        163        156        181        158   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0
00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff :[   54.087999] mount.nfs used greatest stack depth: 3544 bytes left
 reserved
000a0000-000bffff : ^G^G^GPCI Bus 0000:00
000c0000-000c8fff : Video ROM
000c9000-000cadff : Adapter ROM
000cc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  01000000-015b5a17 : Kernel code
  015b5a18-018800ff : Kernel data
  01935000-01a1dfff : Kernel bss
7fff0000-7fffffff : reserved
80000000-cfeeffff : System RAM
  c4000000-c7ffffff : GART
cfef0000-cfef4fff : ACPI Tables
cfef5000-cff7efff : ACPI Non-volatile Storage
cff7f000-cff7ffff : RAM buffer
cff80000-cfffffff : reserved
d0000000-febfffff : PCI Bus 0000:00
  d0000000-d0000fff : 0000:00:02.0
    d0000000-d0000fff : ohci_hcd
  d0001000-d00010ff : 0000:00:02.1
    d0001000-d00010ff : ehci_hcd
  d0002000-d0002fff : 0000:00:07.0
    d0002000-d0002fff : sata_nv
  d0003000-d0003fff : 0000:00:08.0
    d0003000-d0003fff : sata_nv
  d0100000-d01fffff : PCI Bus 0000:01
    d0100000-d010ffff : 0000:01:08.0
    d0110000-d0110fff : 0000:01:07.0
    d0120000-d013ffff : 0000:01:07.0
    d0140000-d015ffff : 0000:01:08.0
  d0200000-d02fffff : PCI Bus 0000:02
    d0200000-d020ffff : 0000:02:00.0
      d0200000-d020ffff : tg3
  d0300000-d03fffff : PCI Bus 0000:05
    d0300000-d031ffff : 0000:05:00.0
      d0300000-d031ffff : e1000e
    d0320000-d033ffff : 0000:05:00.0
      d0320000-d033ffff : e1000e
    d0340000-d035ffff : 0000:05:00.1
      d0340000-d035ffff : e1000e
    d0360000-d037ffff : 0000:05:00.1
      d0360000-d037ffff : e1000e
  d0400000-d04fffff : PCI Bus 0000:05
    d0400000-d041ffff : 0000:05:00.0
    d0420000-d043ffff : 0000:05:00.1
  d8000000-dfffffff : PCI Bus 0000:01
    d8000000-dfffffff : 0000:01:08.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:02
      e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:00
  fed00000-fed003ff : HPET 0
fed40000-fed8ffff : PCI Bus 0000:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-12fffffff : System RAM
MemTotal:        4058080 kB
MemFree:         3764264 kB
Buffers:               0 kB
Cached:           235972 kB
SwapCached:            0 kB
Active:            30648 kB
Inactive:         206332 kB
Active(anon):      23336 kB
Inactive(anon):   105416 kB
Active(file):       7312 kB
Inactive(file):   100916 kB
Unevictable:        4900 kB
Mlocked:            4884 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          5564 kB
Mapped:             5144 kB
Shmem:            124244 kB
Slab:              23856 kB
SReclaimable:      10432 kB
SUnreclaim:        13424 kB
KernelStack:         560 kB
PageTables:          716 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2029040 kB
Committed_AS:     134744 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       25332 kB
VmallocChunk:   34359711995 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       31680 kB
DirectMap2M:     2064384 kB
DirectMap1G:     2097152 kB
Waiting for init.late [  OK  ]
PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.296/0.296/0.296/0.000 ms
NFS done
Mar 20 23:38:19 tst001 iscsid: transport class version 2.0-870. iscsid version 2.0-872
Mar 20 23:38:19 tst001 iscsid: iSCSI daemon with pid=3137 started!

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz...............................................................
Loading latest/initramfs.cpio.gz..................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Mar 20 18:34:04 EDT 2012
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 0000000080000000 - 00000000cfef0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cfef5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef5000 - 00000000cff7f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Dell Inc. PowerEdge T105 /0RR825, BIOS 1.3.2 08/20/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f7a70] f7a70
[    0.000000]   mpc: 9e171-9e2b5
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 7c4d3000 - 7ffcf000
[    0.000000] Allocated new RAMDISK: 34102000 - 37bfd8a1
[    0.000000] Move RAMDISK from 000000007c4d3000 - 000000007ffce8a0 to 34102000 - 37bfd8a0
[    0.000000] ACPI: RSDP 000f79b0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT cfef0753 0009C (v01 DELL   PE_SC3   06040000 DELL 00000000)
[    0.000000] ACPI: FACP cfef3c5f 000F4 (v03 DELL   PE_SC3   06040000 DELL 000F4240)
[    0.000000] ACPI: DSDT cfef07ef 033FC (v01 DELL   PE_SC3   06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS cfef5fc0 00040
[    0.000000] ACPI: TCPA cfef3d53 00032 (v01 Phoeni  x       06040000  TL  00000000)
[    0.000000] ACPI: SLIC cfef3d85 00024 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: SPCR cfef3da9 00050 (v01 DELL   PE_SC3   06040000 PTL  00000001)
[    0.000000] ACPI: EINJ cfef3df9 001B0 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: HEST cfef3fa9 000A8 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: BERT cfef4051 00030 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SSDT cfef4081 000E1 (v01 wheaos  wheaosc 06040000 INTL 20050624)
[    0.000000] ACPI: ERST cfef4162 00270 (v01 PTL    WHEAPTL  06040000 PTL  00000001)
[    0.000000] ACPI: SRAT cfef43d2 000E8 (v01 AMD    HAMMER   06040000 AMD  00000001)
[    0.000000] ACPI: SSDT cfef44ba 00A30 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: MCFG cfef4eea 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET cfef4f26 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: APIC cfef4f5e 0007A (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT cfef4fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 3972MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000]     0: 0x00080000 -> 0x000cfef0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048173
[    0.000000] free_area_init_node: node 0, pgdat c168abc0, node_mem_map f1b01200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7945 pages used for memmap
[    0.000000]   HighMem zone: 811993 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f1800000 s29568 r0 d23680 u524288
[    0.000000] pcpu-alloc: s29568 r0 d23680 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038444
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00130000)
[    0.000000] Memory: 4084432k/4980736k available (5108k kernel code, 108260k reserved, 1630k data, 492k init, 3279752k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc1695000 - 0xc1710000   ( 492 kB)
[    0.000000]       .data : 0xc14fd186 - 0xc1694d00   (1630 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14fd186   (5108 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f1406000 soft=f1408000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2109.877 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4219.75 BogoMIPS (lpj=2109877)
[    0.010593] pid_max: default: 32768 minimum: 301
[    0.015231] Security Framework initialized
[    0.019317] SELinux:  Disabled at boot.
[    0.023156] Mount-cache hash table entries: 512
[    0.027784] Initializing cgroup subsys cpuacct
[    0.032216] Initializing cgroup subsys freezer
[    0.036667] CPU: Physical Processor ID: 0
[    0.040665] CPU: Processor Core ID: 0
[    0.044318] mce: CPU supports 6 MCE banks
[    0.048322] using AMD E400 aware idle routine
[    0.054536] ACPI: Core revision 20120111
[    0.061334] Getting VERSION: 80050010
[    0.064987] Getting VERSION: 80050010
[    0.068640] Getting ID: 0
[    0.071248]ting ID: f000000
[    0.074386] Getting LVT0: 10000
[    0.077514] Getting LVT1: 10000
[    0.080651] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.086035] masked ExtINT on CPU#0
[    0.089572] ENABLING IO-APIC IRQs
[    0.092877] init IO_APIC IRQs
[    0.095836]  apic 4 pin 0 not connected
[    0.099664] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.107556] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.115441] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.123336] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.131226] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.139108] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.146996] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.154885] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.162773] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.170661] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.178723] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.186785] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.194846] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.202907] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.210969] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.219029]  apic 4 pin 16 not connected
[    0.222946]  apic 4 pin 17 not connected
[    0.226857]  apic 4 pin 18 not connected
[    0.230767]  apic 4 pin 19 not connected
[    0.234677]  apic 4 pin 20 not connected
[    0.238589]  apic 4 pin 21 not connected
[    0.242501]  apic 4 pin 22 not connected
[    0.246413]  apic 4 pin 23 not connected
[    0.250454] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.266442] CPU0: Quad-Core AMD Opteron(tm) Processor 1352 stepping 03
[    0.272986] Using local APIC timer interrupts.
[    0.272987] calibrating APIC timer ...
[    0.382996] ... lapic delta = 1255739
[    0.386642] ... PM-Timer delta = 357941
[    0.390462] ... PM-Timer result ok
[    0.393848] ..... delta 1255739
[    0.396976] ..... mult: 53941778
[    0.400184] ..... calibration result: 200918
[    0.404440] ..... CPU clock speed is 2109.0642 MHz.
[    0.409292] ..... host bus clock speed is 200.0918 MHz.
[    0.414505] Performance Events: AMD PMU driver.
[    0.419034] ... version:                0
[    0.423028] ... bit width:              48
[    0.427102] ... generic registers:      4
[    0.431098] ... value mask:             0000ffffffffffff
[    0.436391] ... max period:             00007fffffffffff
[    0.441683] ... fixed-purpose events:   0
[    0.445679] ... event mask:             000000000000000f
[    0.451064] MCE: In-kernel MCE decoding enabled.
[    0.455675] NMI watchdog enabled, takes one hw-pmu counter.
[    0.461343] CPU 1 irqstacks, hard=f1490000 soft=f1492000
[    0.466636] Booting Node   0, Processors  #1
[    0.470731] smpboot cpu 1: start_ip = 99000
[    0.485334] Initializing CPU#1
[    0.488381] masked ExtINT on CPU#1
[    0.493843] NMI watchdog enabled, takes one hw-pmu [    0.520958] Initializing CPU#2
[    0.524007] masked ExtINT on CPU#2
[    0.529453] NMI watchdog enabled, takes one hw-pmu counter.
[    0.535099] CPU 3 irqstacks, hard=f14b0000 soft=f14b2000
[    0.540391]  #3 Ok.
[    0.542482] smpboot cpu 3: start_ip = 99000
[    0.556902] Initializing CPU#3
[    0.559950] masked ExtINT on CPU#3
[    0.565383] NMI watchdog enabled, takes one hw-pmu esstack depth: 7240 bytes left
[    0.589426] RTC time: 23:39:23, date: 03/20/12
[    0.600020] NET: Registered protocol family 16
[    0.604810] node 0 link 0: io port [1000, 4fff]
[    0.609327] node 0 link 0: io port [5000, fffff]
[    0.613929] TOM: 00000000d0000000 aka 3328M
[    0.618098] node 0 link 0: mmio [d0000000, d05fffff]
[    0.623058] node 0 link 0: mmio [fed00000, fed0ffff]
[    0.628013] node 0 link 0: mmio [d8000000, dfffffff]
[    0.632975] node 0 link 0: mmio [fec00000, fec0ffff]
[    0.637933] node 0 link 0: mmio [e0000000, efffffff]
[    0.642895] node 0 link 0: mmio [a0000, bffff]
[    0.647346] node 0 link 0: mmio [f0000000, fe0bffff]
[    0.652305] TOM2: 0000000130000000 aka 4864M
[    0.656559] bus: [00, ff] on node 0 link 0
[    0.660641] bus: 00 index 0 [io  0x0000-0xffff]
[    0.665156] bus: 00 index 1 [mem 0xd0000000-0xd7ffffff]
[    0.670362] bus: 00 index 2 [mem 0xfec10000-0xffffffff]
[    0.675568] bus: 00 index 3 [mem 0xd8000000-0xfebfffff]
[    0.680775] bus: 00 index 4 [mem 0xfec00000-0xfec0ffff]
[    0.685979] bus: 00 index 5 [mem 0x000a0000-0x000bffff]
[    0.691185] bus: 00 index 6 [mem 0x130000000-0xfcffffffff]
[    0.696679] ACPI: bus type pci registered
[    0.700806] dca service started, version 1.12.1
[    0.705364] PCI: MMCONFIG for domain 0000 [bus 00-04] at [mem 0xe0000000-0xe04fffff] (base 0xe0000000)
[    0.714636] PCI: MMCONFIG at [mem 0xe0000000-0xe04fffff] reserved in E820
[    0.721399] PCI: Using MMCONFIG for extended config space
[    0.726776] PCI: Using configuration type 1 for base access
[    0.732784] kworker/u:0 used greatest stack depth: 7052 bytes left
[    0.744473] bio: create slab <bio-0> at 0
[    0.748721] ACPI: Added _OSI(Module Device)
[    0.752895] ACPI: Added _OSI(Processor Device)
[    0.757324] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.762012] ACPI: Added _OSI(Processor Aggregator Device)
[    0.768193] ACPI: EC: Look up EC in DSDT
[    0.772374] \_SB_:_OSC evaluation returned wrong type
[    0.777407] _OSC request data:1 7 
[    0.783493] ACPI: Interpreter enabled
[    0.787148] ACPI: (supports S0 S4 S5)
[    0.790854] ACPI: Using IOAPIC for interrupt routing
[    0.802178] ACPI: No dock devices found.
[    0.806090] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocdow [io  0x0d00-0xffff]
[    0.834693] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.841974] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.849255] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    0.856536] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed8ffff]
[    0.863821] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000cc000-0x000fffff])
[    0.876606] PCI host bridge to bus 0000:00
[    0.880689] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.886845] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.893001] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.899850] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    0.906699] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed8ffff]
[    0.913552] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    0.919516] pci 0000:00:01.0: [10de:0051] type 0 class 0x000601
[    0.925419] pci 0000:00:01.0: reg 10: [io  0x8c00-0x8fff]
[    0.930820] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    0.936723] pci 0000:00:01.1: reg 10: [io  0x2080-0x209f]
[    0.942110] pci 0000:00:01.1: reg 20: [io  0x2040-0x207f]
[    0.947486] pci 0000:00:01.1: reg 24: [io  0x2000-0x203f]
[    0.952875] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.958699] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    0.964602] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.970695] pci 0000:00:02.0: supports D1 D2
[    0.974949] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.981548] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    0.987456] pci 0000:00:02.1: reg 10: [mem 0xd0001000-0xd00010ff]
[    0.993555] pci 0000:00:02.1: supports D1 D2
[    0.997808] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.004414] pci 0000:00:07.0: [10de:0054] type 0 class 0x000101
[    1.010318] pci 0000:00:07.0: reg 10: [io  0x20f0-0x20f7]
[    1.015698] pci 0000:00:07.0: reg 14: [io  0x20e0-0x20e3]
[    1.021073] pci 0000:00:07.0: reg 18: [io  0x20d0-0x20d7]
[    1.026453] pci 0000:00:07.0: reg 1c: [io  0x20c0-0x20c3]
[    1.031833] pci 0000:00:07.0: reg 20: [io  0x20b0-0x20bf]
[    1.037213] pci 0000:00:07.0: reg 24: [mem 0xd0002000-0xd0002fff]
[    1.043310] pci 0000:00:08.0: [10de:0055] type 0 class 0x000101
[    1.049213] pci 0000:00:08.0: reg 10: [io  0x2440-0x2447]
[    1.054593] pci 0000:00:08.0: reg 14: [io  0x2430-0x2433]
[    1.059974] pci 0000:00:08.0: reg 18: [io  0x2420-0x2427]
[    1.065355] pci 0000:00:08.0: reg 1c: [io  0x2410-0x2413]
[    1.070737] pci 0000:00:08.0: reg 20: [io  0x2400-0x240f]
[    1.076119] pci 0000:00:08.0: reg 24: [mem 0xd0003000-0xd0003fff]
[    1.082215] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    1.088130] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    1.094053] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.100655] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    1.106577] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.113177] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    1.119100] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.125700] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    1.131621] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.138224] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    1.144140] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    1.150052] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    1.155967] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    1.161882] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    1.167816] pci 0000:01:07.0: [1077:6312] type 0 class 0x000c04
[    1.173725] pci 0000:01:07.0: reg 10: [io  0x3000-0x30ff]
[    1.179108] pci 0000:01:07.0: reg 14: [mem 0xd0110000-0xd0110fff]
[    1.185203] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.191746] pci 0000:01:08.0: [1002:515e] type 0 class 0x000300
[    1.197653] pci 0000:01:08.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    1.204160] pci 0000:01:08.0: reg 14: [io  0x3400-0x34ff]
[    1.209542] pci 0000:01:08.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    1.215630] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.222148] pci 0000:01:08.0: supports D1 D2
[    1.226423] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    1.231630] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    1.237702] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    1.244465] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    1.251695] pci 0000:02:00.0: [14e4:165a] type 0 class 0x000200
[    1.257605] pci 0000:02:00.0: reg 10: [mem 0xd0200000-0xd020ffff 64bit]
[    1.264275] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.271836] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    1.277044] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    1.283827] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.289053] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    1.294283] pci 0000:05:00.0: [8086:105e] type 0 class 0x000200
[    1.300189] pci 0000:05:00.0: reg 10: [mem 0xd0320000-0xd033ffff]
[    1.306266] pci 0000:05:00.0: reg 14: [mem 0xd0300000-0xd031ffff]
[    1.312341] pci 0000:05:00.0: reg 18: [io  0x4000-0x401f]
[    1.317743] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.324275] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.330366] pci 0000:05:00.1: [8086:105e] type 0 class 0x000200
[    1.336271] pci 0000:05:00.1: reg 10: [mem 0xd0360000-0xd037ffff]
[    1.342347] pci 0000:05:00.1: reg 14: [mem 0xd0340000-0xd035ffff]
[    1.348422] pci 0000:05:00.1: reg 18: [io  0x4020-0x403f]
[    1.353825] pci 0000:05:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.360358] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.366441] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.376410] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    1.381616] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    1.387685] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    1.394456] pci_bus 0000:00: on NUMA node 0
[    1.398625] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.404602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    1.410981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    1.417336] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
[    1.423691] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    1.430046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR3._PRT]
[    1.436398]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.442038]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.450530] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.469891] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.476144] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.482390] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.488627] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
[    1.494863] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.502063] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0
[    1.508292] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.514516] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0, disabled.
[    1.521698] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.528894] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.536092] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.543292] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.550491] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.556730] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
[    1.562973] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.570325] vgaarb: device added: PCI:0000:01:08.0,decodes=io+mem,owns=io+mem,locks=none
[    1.578386] vgaarb: loaded
[    1.581084] vgaarb: bridge control possible 0000:01:08.0
[    1.586591] usbcore: registered new interface driver usbfs
[    1.592099] usbcore: registered new interface driver hub
[    1.597446] usbcore: registered new device driver usb
[    1.602682] PCI: Using ACPI for IRQ routing
[    1.606853] PCI: pci_cache_line_size set to 64 bytes
[    1.611846] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.617999] reserve RAM buffer: 000000007fff0000 - 000000007fffffff 
[    1.624336] reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff 
[    1.630869] NetLabel: Initializing
[    1.634445] NetLabel:  domain hash size = 128
[    1.638784] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.643740] NetLabel:  unlabeled traffic allowed by default
[    1.649366] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.656393] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.661391] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.671579] Switching to clocksource hpet
[    1.675670] pnp: PnP ACPI init
[    1.678727] ACPI: bus type pnp registered
[    1.682816] pnp 00:00: [mem 0xffc00000-0xffffffff]
[    1.687592] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    1.692370] pnp 00:00: [mem 0xfee00000-0xfeefffff]
[    1.697145] pnp 00:00: [mem 0xfed00000-0xfed00fff]
[    1.702006] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    1.708951] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.715890] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.722829] system 00:00: [mem 0xfed00000-0xfed00fff] has been reserved
[    1.729421] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.736254] pnp 00:01: [bus 00-ff]
[    1.739647] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.743724] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.748415] pnp 00:01: [io  0x0d00-0xffff window]
[    1.753105] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.758486] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    1.763868] pnp 00:01: [mem 0xd0000000-0xfebfffff window]
[    1.769248] pnp 00:01: [mem 0xfed40000-0xfed8ffff]
[    1.774105] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.780629] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.785486] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.792080] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.799104] pnp 00:03: [io  0x8000-0x807f]
[    1.803190] pnp 00:03: [io  0x8080-0x80ff]
[    1.807273] pnp 00:03: [io  0x8400-0x847f]
[    1.811358] pnp 00:03: [io  0x8480-0x84ff]
[    1.815442] pnp 00:03: [io  0x8800-0x887f]
[    1.819526] pnp 00:03: [io  0x8880-0x88ff]
[    1.823610] pnp 00:03: [io  0x2040-0x207f]
[    1.827694] pnp 00:03: [io  0x2000-0x203f]
[    1.831777] pnp 00:03: [io  0x0060]
[    1.835256] pnp 00:03: [io  0x0064]
[    1.838824] system 00:03: [io  0x8000-0x807f] has been reserved
[    1.844726] system 00:03: [io  0x8080-0x80ff] has been reserved
[    1.850627] system 00:03: [io  0x8400-0x847f] has been reserved
[    1.856527] system 00:03: [io  0x8480-0x84ff] has been reserved
[    1.862427] system 00:03: [io  0x8800-0x887f] has been reserved
[    1.868328] system 00:03: [io  0x8880-0x88ff] has been reserved
[    1.874229] system 00:03: [io  0x2040-0x207f] has been reserved
[    1.880130] system 00:03: [io  0x2000-0x203f] has been reserved
[    1.886032] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.892859] pnp 00:04: [irq 0 disabled]
[    1.896690] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.904670] pnp 00:04: [irq 8]
[    1.907715] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    1.912555] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.919072] pnp 00:05: [io  0x0010-0x001f]
[    1.923155] pnp 00:05: [io  0x0022-0x003f]
[    1.927239] pnp 00:05: [io  0x0044-0x005f]
[    1.931323] pnp 00:05: [io  0x0062-0x0063]
[    1.935407] pnp 00:05: [io  0x0065-0x006f]
[    1.939490] pnp 00:05: [io  0x0072-0x0073]
[    1.943574] pnp 00:05: [io  0x0074-0x007f]
[    1.947661] pnp 00:05: [io  0x0091-0x0093]
[    1.951744] pnp 00:05: [io  0x0097-0x009f]
[    1.955827] pnp 00:05: [io  0x00a2-0x00bf]
[    1.959910] pnp 00:05: [io  0x00e0-0x00ef]
[    1.963993] pnp 00:05: [io  0x04d0-0x04d1]
[    1.968166] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.974068] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.980847] pnp 00:06: [io  0x0000-0x0008]
[    1.984930] pnp 00:06: [io  0x000a-0x000f]
[    1.989014] pnp 00:06: [io  0x0081-0x0083]
[    1.993099] pnp 00:06: [io  0x0087]
[    1.996576] pnp 00:06: [io  0x0089-0x008b]
[    2.000661] pnp 00:06: [io  0x008f]
[    2.004140] pnp 00:06: [io  0x00c0-0x00d1]
[    2.008223] pnp 00:06: [io  0x00d4-0x00df]
[    2.012307] pnp 00:06: [dma 4]
[    2.015416] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.021929] pnp 00:07: [io  0x0061]
[    2.025469] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.032009] pnp 00:08: [io  0x0070-0x0071]
[    2.036152] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.042665] pnp 00:09: [io  0x00f0-0x00f1]
[    2.046750] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    2.054900] pnp 00:09: [irq 13]
[    2.058096] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.064611] pnp 00:0a: [io  0x0c00-0x0c7f]
[    2.068783] system 00:0a: [io  0x0c00-0x0c7f] has been reserved
[    2.074684] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.081642] pnp 00:0b: [io  0x03f8-0x03ff]
[    2.085727] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    2.093705] pnp 00:0b: [irq 4]
[    2.096854] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.103709] pnp: PnP ACPI: found 12 devices
[    2.107879] ACPI: ACPI bus type pnp unregistered
[    2.116077] PCI: max bus depth: 1 pci_try_num: 2
[    2.120701] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd0400000-0xd04fffff pref]
[    2.127985] pci 0000:01:07.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    2.135181] pci 0000:01:08.0: BAR 6: assigned [mem 0xd0140000-0xd015ffff pref]
[    2.142377] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    2.147584] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    2.153658] pci 0000:00:09.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    2.160424] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdfffffff pref]
[    2.167624] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    2.172832] pci 0000:00:0b.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    2.179598] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.184808] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    2.190020] pci 0000:05:00.0: BAR 6: assigned [mem 0xd0400000-0xd041ffff pref]
[    2.197217] pci 0000:05:00.1: BAR 6: assigned [mem 0xd0420000-0xd043ffff pref]
[    2.204415] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    2.209624] pci 0000:00:0e.0:   bridge window [io  0x4000-0x4fff]
[    2.215697] pci 0000:00:0e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    2.222462] pci 0000:00:0e.0:   bridge window [mem 0xd0400000-0xd04fffff pref]
[    2.229664] pci 0000:00:09.0: setting latency timer to 64
[    2.235052] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.240606] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.246161] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.252407] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfebfffff]
[    2.258654] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed8ffff]
[    2.264900] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    2.270455] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    2.276701] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    2.283382] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    2.289628] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    2.295183] pci_bus 0000:05: resource 1 [mem 0xd0300000-0xd03fffff]
[    2.301429] pci_bus 0000:05: resource 2 [mem 0xd0400000-0xd04fffff pref]
[    2.308169] NET: Registered protocol family 2
[    2.312575] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.319941] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.327868] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    2.334736] TCP: Hash tables configured (established 131072 bind 65536)
[    2.341329] TCP reno registered
[    2.344464] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.350373] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.356789] NET: Registered protocol family 1
[    2.361266] RPC: Registered named UNIX socket transport module.
[    2.367167] RPC: Registered udp transport module.
[    2.371856] RPC: Registered tcp transport module.
[    2.376546] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.383209] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    2.388985] IOAPIC[0]: Set routing entry (4-23 -> 0x29 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.447339] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    2.453074] IOAPIC[0]: Set routing entry (4-22 -> 0x41 -> I Mapping
[    2.472250] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.477721] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.483281] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.488784] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.494254] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.499814] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.505317] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.510787] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.516346] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.521853] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.527324] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.532884] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.538364] pci 0000:01:08.0: Boot video device
[    2.542887] PCI: CLS 64 bytes, default 64
[    2.546983] Trying to unpack rootfs image as initramfs...
[    4.276251] Freeing initrd memory: 60400k freed
[    4.305119] Simple Boot Flag at 0x62 set to 0x1
[    4.310176] Machine check injector initialized
[    4.314617] Failed to setup IBS LVT offset, IBSCTL = 0xffffffff
[    4.320520] [Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
[    4.334290] [Firmware Bug]: cpu 2, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
[    4.343737] Failed to setup IBS, -22
[    4.347858] microcode: CPU0: patch_level=0x01000065
[    4.352718] microcode: CPU1: patch_level=0x01000065
[    4.357578] microcode: CPU2: patch_level=0x01000065
[    4.362445] microcode: CPU3: patch_level=0x01000065
[    4.367346] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.376439] audit: initializing netlink socket (disabled)
[    4.381834] type=2000 audit(1332286765.840:1): initialized
[    4.402502] highmem bounce pool size: 64 pages
[    4.406936] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   ni has been set to 1689
[    4.432595] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.439968] io scheduler noop registered
[    4.443879] io scheduler deadline registered
[    4.448151] io scheduler cfq registered (default)
[    4.452972] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    4.458266] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    4.463550] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    4.468833] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    4.474181] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.479978] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.488132] ACPI: Power Button [PWRB]
[    4.491871] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.499242] ACPI: Power Button [PWRF]
[    4.503054] ACPI: acpi_idle registered with cpuidle
[    4.509894] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.536329] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.563032] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.589908] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.595982] Non-volatile memory driver v1.3
[    4.600221] Linux agpgart interface v0.103
[    4.604923] [drm] Initialized drm 1.1.0 20060810
[    4.611423] brd: module loaded
[    4.615481] loop: module loaded
[    4.618718] Fixed MDIO Bus: probed
[    4.622109] tun-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.633367] tg3.c:v3.122 (December 7, 2011)
[    4.637709] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    4.643444] IOAPIC[0]: Set routing entry (4-19 -> 0x69 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    4.659113] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95722) rev a200] (PCI Express) MAC address 00:1d:09:17:b5:46
[    4.669426] tg3 0000:02:00.0: eth0: attached PHY is 5722/5756 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    4.679650] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.687538] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    4.694380] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.2.0-k
[    4.703652] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    4.709961] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.716466] ehci_hcd: block sizes: qh 68 qtd 96 itd 160 sitd 96
[    4.722384] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    4.728198] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    4.733424] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file 'devices'
[    4.741313] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    4.748914] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    4.756290] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[    4.764617] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    4.771215] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    4.779286] ehci_hcd 0000:00:02.1: park 0
[    4.783284] ehci_hcd 0000:00:02.1: debug port 1
[    4.787802] ehci_hcd 0000:00:02.1: reset command 0080b32  park=3 ithresh=8 Async Periodic period=1024 Reset HALT
[    4.797939] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[    4.805656] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    4.812421] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    4.818162] ehci_hcd 0000:00:02.1: irq 22, io mem 0xd0001000
[    4.823806] ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    4.837806] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    4.843555] usb usb1: default language 0x0409
[    4.84790 EHCI Host Controller
[    4.871414] usb usb1: Manufacturer: Linux 3.3.0upstream-01180-ged378a5 ehci_hcd
[    4.878697] usb usb1: SerialNumber: 0000:00:02.1
[    4.883398] usb usb1: usb_probe_device
[    4.887136] usb usb1: configuration #1 chosen from 1 choice
[    4.892694] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.898474] hub 1-0:1.0: usb_probe_interface
[    4.902729] hub 1-0:1.0: usb_probe_interface - got id
[    4.907764] hub 1-0:1.0: USB hub found
[    4.911503] hub 1-0:1.0: 10 ports detected
[    4.915587] hub 1-0:1.0: standalone hub
[    4.919410] hub 1-0:1.0: no power switching (usb 1.0)
[    4.924444] hub 1-0:1.0: individual port over-current protection
[    4.930429] hub 1-0:1.0: power on to power good time: 20ms
[    4.935899] hub 1-0:1.0: local power source is good
[    4.940760] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.947641] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    4.955273] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.961432] ohci_hcd: block sizes: ed 64 td 64
[    4.965877] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    4.971693] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    4.976903] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '002'
[    4.984504] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    4.991884] ohci_hcd 0000:00:02.0: created debug files
[    4.997005] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    5.002741] ohci_hcd 0000:00:02.0: irq 23, io mem 0xd0000000
[    5.047715] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.061637] ohci_hcd 0000:00:02.0: OHCI controller state
[  0:00:02.0: OHCI 1.0, NO legacy support registers, rh state running
[    5.075170] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[    5.082540] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[    5.088008] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    5.093562] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    5.100242] ohci_hcd 0000:00:02.0: hcca frame #0029
[    5.105103] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    5.112215] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.118806] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.124707] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.131386] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.138063] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.144739] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.151418] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.158098] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.164774] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.171454] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.178133] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.184811] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.191493] usb usb2: default language 0x0409
[    5.195840] usb usb2: udev 1, busnum 2, minor = 128
[    5.200701] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.207466] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.214660] usb usb2: Product: OHCI Host Controller
[    5.219518] usb usb2: Manufacturer: Linux 3.3.0upstream-01180-ged378a5 ohci_hcd
[    5.226799] usb usb2: SerialNumber: 0000:00:02.0
[    5.231527] usb usb2: usb_probe_device
[    5.235263] usb usb2: configuration #1 chosen from 1 choice
[    5.240820] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.246600] hub 2-0:1.0: usb_probe_interface
[    5.250857] hub 2-0:1.0: usb_probe_interface - got id
[    5.255891] hub 2-0:1.0: USB hub found
[    5.259629] hub 2-0:1.0: 10 ports detected
[    5.263712] hub 2-0:1.0: standalone hub
[    5.267534] hub 2-0:1.0: no power switching (usb 1.0)
[    5.272567] hub 2-0:1.0: global over-current protection
[    5.277774] hub 2-0:1.0: power on to power good time: 2ms
[    5.283156] hub 2-0:1.0: local power source is good
[    5.288016] hub 2-0:1.0: no over-current condition exists
[    5.293396] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.300260] /home/konrad/linux-linus/drivers/usb/core/inode.c: creating file '001'
[    5.307821] ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
[    5.311033] Refined TSC clocksource calibration: 2109.729 MHz.
[    5.311039] Switching to clocksource tsc
[    5.323556] uhci_hcd: USB Universal Host Controller Interface driver
[    5.330003] usbcore: registered new interface driver usblp
[    5.335522] usbcore: registered new interface driver libusual
[    5.341412] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.400395] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.599520] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.604609] mousedev: PS/2 mouse device common for all mice
[    5.60] cpuidle: using governor ladder
[    5.632175] cpuidle: using governor menu
[    5.636086] EFI Variables Facility v0.08 2004-May-17
[    5.641087] zram: num_devices not specified. Using default: 1
[    5.646815] zram: Creating 1 devices ...
[    5.651115] Netfilter messages via NETLINK v0.30.
[    5.655822] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.662013] ctnetlink v0.93: registering with nfnetlink.
[    5.668032] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.673397] TCP cubic registered
[    5.676614] Initializing XFRM netlink socket
[    5.680919] NET: Registered protocol family 10
[    5.686130] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.691771] IPv6 over IPv4 tunneling driver
[    5.696573] NET: Registered protocol family 17
[    5.701024] Registering the dns_resolver key type
[    5.705729] 
[    5.705730] printing PIC contents
[    5.710518] ... PIC  IMR: ffff
[    5.713565] ... PIC  IRR: 1801
[    5.716613] ... PIC  ISR: 0000
[    5.719657] ... PIC ELCR: 1c00
[    5.722702] printing local APIC contents on CPU#0/0:
[    5.727646] ... APIC ID:      00000000 (0)
[    5.731725] ... APIC VERSION: 80050010
[    5.735458] ... APIC TASKPRI: 00000000 (00)
[    5.739623] ... APIC ARBPRI: 000000e0 (e0)
[    5.743701] ... APIC PROCPRI: 00000000
[    5.747434] ... APIC LDR: 01000000
[    5.750816] ... APIC DFR: ffffffff
[    5.754201] ... APIC SPIV: 000001ff
[    5.757679] ... APIC ISR field:
[    5.760806] 0000000000000000000000000000000000000000000000000000000000000000
[    5.767923] ... APIC TMR field:
[    5.771045] 0000000000000000000000000000000000000000000000000000000000000000
[    5.778148] ... APIC IRR field:
[    5.781281] 0000000000000000000000000000000000000000000000000000000000008000
[    5.788392] ... APIC ESR: 00000000
[    5.791782] ... APIC ICR: 000008fc
[    5.795162] ... APIC ICR2: 08000000
[    5.798646] ... APIC LVTT: 000100ef
[    5.802113] ... APIC LVTPC: 00000400
[    5.805679] ... APIC LVT0: 00010700
[    5.809146] ... APIC LVT1: 00000400
[    5.812624] ... APIC LVTERR: 000000fe
[    5.816265] ... APIC TMICT: 00000000
[    5.819825] ... APIC TMCCT: 00000000
[    5.823384] ... APIC TDCR: 00000003
[    5.826857] ... APIC EFEAT: 00040007
[    5.830419] ... APIC ECTRL: 00000000
[    5.833979] ... APIC EILVT0: 000000f9
[    5.837624] ... APIC EILVT1: 00010000
[    5.841274] ... APIC EILVT2: 00010000
[    5.844920] ... APIC EILVT3: 00010000
[    5.848566] 
[    5.850061] number of MP IRQ sources: 15.
[    5.854057] number of IO-APIC #4 registers: 24.
[    5.858565] testing the IO APIC.......................
[    5.863685] 
[    5.865170] IO APIC #4......
[    5.868039] .... register #00: 04000000
[    5.871860] .......    : physical APIC id: 04
[    5.876199] .......    : Delivery Type: 0
[    5.880193] .......    : LTS          : 0
[    5.884187] .... register #01: 00170011
[    5.888005] .......     : max redirection entries: 17
[    5.893036] .......     : PRQ implemented: 0
[    5.897290] .......     : IO APIC version: 11
[    5.901631] .... register #02: 04000000
[    5.905452] .......     : arbitration: 04
[    5.909445] .... IRQ redirection table:
[    5.913268]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.918734]  00 00  1    0    0   0   0    0    0    00
[    5.923956]  01 0F  0    0    0   0   0    1    1    31
[    5.929178]  02 0F  0    0    0   0   0    1    1    30
[    5.934403]  03 0F  0    0    0   0   0    1    1    33
[    5.939624]  04 0F  0    0    0   0   0    1    1    34
[    5.944846]  05 0F  0    0    0   0   0    1    1    35
[    5.950069]  06 0F  0    0    0   0   0    1    1    36
[    5.955292]  07 0F  1    0    0   0   0    1    1    37
[    5.960515]  08 0F  0    0    0   0   0    1    1    38
[    5.965737]  09 0F  0    1    0   1   0    1    1    39
[    5.970966]  0a 0F  0    0    0   0   0    1    1    3A
[    5.976190]  0b 0F  1    0    0   0   0    1    1    3B
[    5.981412]  0c 0F  1    0    0   0   0    1    1    3C
[    5.986635]  0d 0F  0    0    0   0   0    1    1    3D
[    5.991859]  0e 0F  0    0    0   0   0    1    1    3E
[    5.997080]  0f 0F  0    0    0   0   0    1    1    3F
[    6.002304]  10 00  1    0    0   0   0    0    0    00
[    6.007526]  11 00  1    0    0   0   0    0    0    00
[    6.012748]  12 00  1    0    0   0   0    0    0    00
[    6.017970]  13 0F  1    1    0   1   0    1    1    69
[    6.023193]  14 00  1    0    0   0   0    0    0    00
[    6.028414]  15 00  1    0    0   0   0    0    0    00
[    6.033636]  16 0F  0    1    0   1   0    1    1    41
[    6.038858]  17 0F  0    1    0   1   0    1    1    29
[    6.044078] IRQ to pin mappings:
[    6.047294] IRQ0 -> 0:2
[    6.049757] IRQ1 -> 0:1
[    6.052220] IRQ3 -> 0:3
[    6.054683] IRQ4 -> 0:4
[    6.057147] IRQ5 -> 0:5
[    6.059616] IRQ6 -> 0:6
[    6.062082] IRQ7 -> 0:7
[    6.064539] IRQ8 -> 0:8
[    6.066997] IRQ9 -> 0:9
[    6.069460] IRQ10 -> 0:10
[    6.072099] IRQ11 -> 0:11
[    6.074728] IRQ12 -> 0:12
[    6.077364] IRQ13 -> 0:13
[    6.080004] IRQ14 -> 0:14
[    6.082639] IRQ15 -> 0:15
[    6.085269] IRQ19 -> 0:19
[    6.087908] IRQ22 -> 0:22
[    6.090541] IRQ23 -> 0:23
[    6.093182] .................................... done.
[    6.098302] Using IPI No-Shortcut mode
[    6.102201] PM: Hibernation image not present or could not be loaded.
[    6.108626] registered taskstats version 1
[    6.112968]   Magic number: 4:59:707
[    6.117000] Freeing unused kernel memory: 492k freed
[    6.122190] Write protecting the kernel text: 5112k
[    6.127100] Write protecting the kernel read-only data: 1368k
[    6.132821] NX-protecting the kernel data: 3080k
init started: BusyBox v1.14.3 ([    6.140724] consoletype used greatest stack depth: 6904 bytes left
2012-03-20 18:38:04 EDT)
Mounting directories  [  OK  ]
[    6.269169] mv used greatest stack depth: 6684 bytes left
mount: mount point /proc/xen does not exist
mount: mount point /sys/kernel/config does not exist
cat: /sys/hypervisor/type: No[    6.295384] udevd (1233): /proc/1233/oom_adj is deprecated, please use /proc/1233/oom_score_adj instead.
 such file or directory
/usr/bin/load_xen_modules: line 3: [: ==: unary operator expected
[    6.325763] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    6.330357] SCSI subsystem initialized
[    6.335314] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    6.341238] e1000e 0000:05:00.0: Disabling ASPM  L1
[    6.344224] udevd used greatest stack depth: 6520 bytes left
[    6.352011] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 18
[    6.352686] udevd used greatest stack depth: 6240 bytes left
[    6.363408] IOAPIC[0]: Set routing entry (4-18 -> 0x71 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    6.363523] libata version 3.00 loaded.
[    6.375505] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
udevd-work[1652][    6.382629] sata_nv 0000:00:07.0: version 3.5
: error opening ATTR{/sys/devices/system/cpu/cpu[    6.391419] powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 1352 (4 cpu cores) (version 2.20.00)
[    6.399765] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    6.399782] IOAPIC[0]: Set routing entry (4-21 -> 0x81 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    6.399837] sata_nv 0000:00:07.0: setting latency timer to 64
0/online} for wr[    6.421480] powernow-k8:    0 : pstate 0 (2100 MHz)
iting: No such f[    6.427659] powernow-k8:    1 : pstate 1 (1800 MHz)
ile or directory[    6.433909] powernow-k8:    2 : pstate 2 (1600 MHz)


[    6.440125] powernow-k8:    3 : pstate 3 (1300 MHz)
[    6.445411] powernow-k8:    4 : pstate 4 (1050 MHz)
[    6.451075] [drm] radeon defaulting to kernel modesetting.
[    6.456551] [drm] radeon kernel modesetting enabled.
[    6.461884] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 17
[    6.467650] IOAPIC[0]: Set routing entry (4-17 -> 0x89 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    6.467698] scsi0 : sata_nv
[    6.478648] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.13-k.
[    6.478900] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x1028:0x0225).
[    6.478927] [drm] register mmio base: 0xD0100000
[    6.478928] [drm] register mmio size: 65536
[    6.479063] radeon 0000:01:08.0: VRAM: 128M 0x00000000D8000000 - 0x00000000DFFFFFFF (32M used)
[    6.479067] radeon 0000:01:08.0: GTT: 512M 0x00000000B8000000 - 0x00000000D7FFFFFF
[    6.479074] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.479076] [drm] Driver supports precise vblank timestamp query.
[    6.479095] [drm] radeon: irq initialized.
[    6.538466] scsi1 : sata_nv
[    6.538485] [drm] Detected VRAM RAM=128M, BAR=128M
[    6.538489] [drm] RAM width 16bits DDR
[    6.538538] [TTM] Zone  kernel: Available graphics memory: 432786 kiB.
[    6.538540] [TTM] Zone highmem: Available graphics memory: 2072662 kiB.
[    6.538542] [TTM] Initializing pool allocator.
[    6.538548] [TTM] Initializing DMA pool allocator.
[    6.538576] [drm] radeon: 32M of VRAM memory ready
[    6.538578] [drm] radeon: 512M of GTT memory ready.
[    6.538600] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.539501] [drm] radeon: ib pool ready.
[    6.540780] ip used greatest stack depth: 5872 bytes left
[    6.560643] [drm] PCIE GART of 512M enabled (table at 0x0000000037200000).
[    6.560664] radeon 0000:01:08.0: WB disabled
[    6.560668] [drm] fence driver on ring 0 use gpu addr 0xb8000000 and cpu addr 0xf776e000
[    6.560807] [drm] Loading R100 Microcode
[    6.568143] [drm] radeon: ring at 0x00000000B8001000
Waiting for devi[    6.568167] [drm] ring test succeeded in 1 usecs
[    6.568293] [drm] ib test succeeded in 0 usecs
[    6.571794] [drm] Radeon Display Connectors
[    6.571797] [drm] Connector 0:
[    6.571802] [drm]   VGA
[    6.571805] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    6.571806] [drm]   Encoders:
ces [  OK  [    6.571807] [drm]     CRT1: INTERNAL_DAC1
[    6.627426] [drm] fb mappable at 0xD8040000
[    6.627429] [drm] vram apper at 0xD8000000
[    6.627430] [drm] size 786432
[    6.627432] [drm] fb depth is 8
[    6.627433] [drm]    pitch is 1024
][    6.628095] fbcon: radeondrmfb (fb0) is primary device

[    6.683590] ata1: SATA max UDMA/133 cmd 0x20f0 ctl 0x20e0 bmdma 0x20b0 irq 21
[    6.683593] ata2: SATA max UDMA/133 cmd 0x2Q 20
[    6.683849] IOAPIC[0]: Set routing entry (4-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.683897] sata_nv 0000:00:08.0: setting latency timer to 64
[    6.684981] scsi2 : sata_nv
[    6.685161] scsi3 : sata_nv
[    6.685395] ata3: SATA max UDMA/133 cmd 0x2440 ctl 0x2430 bmdma 0x2400 irq 20
[    6.685399] ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2410 bmdma 0x2408 irq 20
[    6.687647] e1000e 0000:05:00.0: eth1: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a2
[    6.687650] e1000e 0000:05:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    6.687728] e1000e 0000:05:00.0: eth1: MAC: 0, PHY: 4, PBA No: D50868-003
[    6.687740] e1000e 0000:05:00.1: Disabling ASPM  L1
^G[    6.687903] ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 16
[    6.687912] IOAPIC[0]: Set routing entry (4-16 -> 0x99 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    6.688029] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
[    6.841225] Console: switching to colour frame buffer device 128x48
^G^[    6.861439] e1000e 0000:05:00.1: eth2: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a3
[    6.861442] e1000e 0000:05:00.1: eth2: Intel(R) PRO/1000 Network Connection
G^[    6.861519] e1000e 0000:05:00.1: eth2: MAC: 0, PHY: 4, PBA No: D50868-003
G[    6.976134] fb0: radeondrmfb frame buffer device
[    6.976136] drm: registered panic notifier
^G^G^G^G^G^G^G^G[    6.976143] [drm] Initialized radeon 2.13.0 20080528 for 0000:01:08.0 on minor 0
^G^G^G^G[    6.976212] qla2xxx [0000:01:07.0]-001d: : Found an ISP6312 irq 16 iobase 0xf845c000.
[    7.142614] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.148799] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.151742] ata3.00: ATAPI: HL-DT-STDVD-ROM GDRH20N, 0D04, max UDMA/100
[    7.158094] ata3.00: configured for UDMA/100
[    7.181898] ata1.00: ATA-7: WDC WD800AAJS-18TDA1, 01.00A04, max UDMA/133
[    7.188580] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    7.198307] ata1.00: configured for UDMA/133
[    7.202706] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01.0 PQ: 0 ANSI: 5
[    7.306852] scsi4 : qla2xxx
[    7.309975] qla2xxx [0000:01:07.0]-00fb:4: QLogic QLA200 - 133MHz PCI-X to 2Gb FC Optical.
[    7.318213] qla2xxx [0000:01:07.0]-00fc:4: ISP6312: PCI (33 MHz) @ 0000:01:07.0 hdma+ host#=4 fw=3.03.28 IPX.
[    7.513648] ata2: SATA link down (SStatus 0 SControl 300)
[    7.519092] scsi: waiting for bus probes to complete ...
[   12.312281] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH20N  0D04 PQ: 0 ANSI: 5
[   12.622405] ata4: SATA link down (SStatus 0 SControl 300)
[   12.628090] modprobe used greatest stack depth: 5812 bytes left
[   12.633992] modprobe used greatest stack depth: 5160 bytes left
[   12.641042] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   12.648809] sd 0:0:0:0: [sda] Write Protect is off
[   12.653590] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.658680] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.675351]  sda: sda1 sda2
[   12.678498] sd 0:0:0:0: [sda] Attached SCSI disk
[   12.684989] sd 0:0:0:0: Attached scsi ge0: Attached scsi CD-ROM sr0
[   12.706332] ttyS0: 2 input overrun(s)
[   12.706373] sr 2:0:0:0: Attached scsi generic sg1 type 5
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GWaiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [   13.003312] tg3 0000:02:00.0: irq 46 for MSI/MSI-X
[   13.052318] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.058406] device eth0 entered promiscuous mode
[  OK  ]
Bringing up interface eth1:  
Determining IP information for eth1...[   13.245339] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
[   13.300935] e1000e 0000:05:00.0: irq 44 for MSI/MSI-X
[   13.306369] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   15.799134] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   15.805813] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for RX
[   15.813002] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
 failed; no link present.  Check cable?
[FAILED]
Bringing up interface eth2:  
Determining IP information for eth2...[   19.013940] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
[   19.069522] e1000e 0000:05:00.1: irq 45 for MSI/MSI-X
[   19.074952] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   21.085874] e1000e: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   21.093655] ADDRCONF(NETDEV_CHANGE): e link becomes ready
^G[   26.292945] eth0: no IPv6 routers present
 done.
[  OK  ]
Bringing up interface switch:  
Determining IP information for s[   26.426575] switch: port 1(eth0) entered forwarding state
witch...[   26.432669] switch: p^G done.
[  OK  ]
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [3060]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [3060] ignoring start request
[   27.680872] Loading iSCSI transport class v2.0-870.
[   27.688044] iscsi: registered transport (tcp)
Could not read fw values.
Mar 20 23:39:50 tst001 syslogd 1.5.0: restart.
You might have to do kill -1 1 if you see 'can't ope
[0:0:0:0]    disk    ATA      WDC WD800AAJS-18 01.0  /dev/sda 
[2:0:0:0]    cd/dvd  HL-DT-ST DVD-ROM GDRH20N  0D04  /dev/sr0 
^G^G^G00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:07.0 Fibre Channel: QLogic Corp. SP202-based 2Gb Fibre Channel to PCI-X HBA (rev 03)
01:08.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5722 Gigabit Ethernet PCI Express
05:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
05:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
           CPU0       CPU1       CPU2       CPU3       
  0:        176          8        354      22787   IO-APIC-edge      timer
  1:          1          0          1          1   IO-APIC-edge      i8042
  4:          1          0         20        144   IO-APIC-edge      serial
  7:          1          0          0          0   IO-APIC-edge    
  8:          1          1         15         14   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          1          0          0          0   IO-APIC-edge    
 16:          0          0          1         35   IO-APIC-fasteoi   qla2xxx
 17:          0          2         13        288   IO-APIC-fasteoi   radeon
 20:          0          1         19         85   IO-APIC-fasteoi   sata_nv
 21:          0          0          0          4   IO-APIC-fasteoi   sata_nv
 22:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 44:          0          0          0          9   PCI-MSI-edge      eth1
 45:          0          0          1         35   PCI-MSI-edge      eth2
 46:          0          0          2         59   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      23076       6292       4109       3345   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       3183       2699       3769       2159   Rescheduling interrupts
CAL:        289        289        254        224   Function call interrupts
TLB:        152        185        184        143   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0
00000000-0000ffff : reserved
0001^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G0000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c8fff : Video ROM
000c9000-000cadff : Adapter ROM
000cc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  01000000-014fd185 : Kernel code
  014fd186-01694cff : Kernel data
  01716000-0179efff : Kernel bss
7fff0000-7fffffff : reserved
80000000-cfeeffff : System RAM
cfef0000-cfef4fff : ACPI Tables
cfef5000-cff7efff : ACPI Non-volatile Storage
cff7f000-cff7ffff : RAM buffer
cff80000-cfffffff : reserved
d0000000-febfffff : PCI Bus 0000:00
  d0000000-d0000fff : 0000:00:02.0
    d0000000-d0000fff : ohci_hcd
  d0001000-d00010ff : 0000:00:02.1
    d0001000-d00010ff : ehci_hcd
  d0002000-d0002fff : 0000:00:07.0
    d0002000-d0002fff : sata_nv
  d0003000-d0003fff : 0000:00:08.0
    d0003000-d0003fff : sata_nv
  d0100000-d01fffff : PCI Bus 0000:01
    d0100000-d010ffff : 0000:01:08.0
    d0110000-d0110fff : 0000:01:07.0
      d0110000-d0110fff : qla2xxx
    d0120000-d013ffff : 0000:01:07.0
    d0140000-d015ffff : 0000:01:08.0
  d0200000-d02fffff : PCI B[   28.253813] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
us 0000:02
    [   28.264365] device-mapper: multipath: version 1.3.0 loaded
d0200000-d020ffff : 0000:02:00.0
      d0200000-d020ffff : tg3
  d0300000-d03fffff : PCI Bus 0000:05
    d0300000-d031ffff : 0000:05:00.0
      d0300000-d031ffff : e1000e
    d0320000-d033ffff : 0000:05:00.0
      d0320000-d033ffff : e1000e
    d0340000-d035ffff : 0000:05:00.1
      d0340000-d035ffff : e1000e
    d0360000-d037ffff : 0000:05:00.1
      d0360000-d037ffff : e1000e
  d0400000-d04fffff : PCI Bus 0000:05
    d0400000-d041ffff : 0000:05:00.0
    d0420000-d043ffff : 0000:05:00.1
  d8000000-dfffffff : PCI Bus 0000:01
    d8000000-dfffffff : 0000:01:08.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:02
      e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:00
  fed00000-fed003ff : HPET 0
fed40000-fed8ffff : PCI Bus 0000:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
fff80000-ffffffff : reserved
100000000-12fffffff : System RAM
MemTotal:        4145324 kB
MemFree:         3930376 kB
Buffers:               0 kB
Cached:           181744 kB
SwapCached:            0 kB
Active:            22076 kB
Inactive:         161000 kB
Active(anon):      14532 kB
Inactive(anon):    62036 kB
Active(file):       7544 kB
Inactive(file):    98964 kB
Unevictable:        2664 kB
Mlocked:            2640 kB
HighTotal:       3279752 kB
HighFree:        3089784 kB
LowTotal:         865572 kB
LowFree:          840592 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          3460 kB
Mapped:             3416 kB
Shmem:             73608 kB
Slab:              17068 kB
SReclaimable:       6512 kB
SUnreclaim:        10556 kB
KernelStack:         576 kB
PageTables:          232 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2072660 kB
Committed_AS:      80436 kB
VmallocTotal:     122880 kB
VmallocUsed:        6216 kB
VmallocChunk:     115444 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8184 kB
DirectMap2M:      905216 kB
Waiting for init.late [  OK  ]
PING build.dumpdata.com (192.168.101.3) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.347/0.347/0.347/0.000 ms
NFS done
libxl: error: libxl.c:56:libxl_ctx_init Is xenstore daemon running?
failed to stat /var/run/xenstored.pid: No such file or directory
cannot init xl context
192.168.101.2:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]
[   28.528561] scsi5 : iSCSI Initiator over TCP/IP
Mar 20 23:39:51 tst001 iscsid: transport class version 2.0-870. iscsid version 2.0-870
Mar 20 23:39:51 tst001 iscsid: iSCSI da35 started!
^G^G^G^G[   28.784926] scsi 5:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   28.793430] sd 5:0:0:0: Attached4019] sd 5:0:0:0: [sdb] Mode Sense: 2f 00 00 00
[   28.794263] sd 5:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   28.814772]  sdb: unknown partition table
[   28.829137] ttyS0: 2 input overrun(s)
[   28.829696] scsi 5:0:0:1: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   28.830467] sd 5:0:0:1: [sdc] 167772160 512-byte logical blocks: (85.8 GB/80.0 GiB)
[   28.830719] sd 5:0:0:1: Attached scsi generic sg3 type 0
[   28.831138] scsi 5:0:0:2: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   28.831500] sd 5:0:0:0: [sdb] Attached SCSI disk
[   28.831580] sd 5:0:0:1: [sdc] Write Protect is off
[   28.831584] sd 5:0:0:1: [sdc] Mode Sense: 2f 00 00 00
[   28.831888] sd 5:0:0:1: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   28.831892] sd 5:0:0:2: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   28.832728] sd 5:0:0:2: [sdd] Write Protect is off
[   28.832731] sd 5:0:0:2: [sdd] Mode Sense: 2f 00 00 00
[   28.832977] sd 5:0:0:2: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   28.833177] sd 5:0:0:2: Attached scsi generic sg4 type 0
[   28.843308]  sdd: unknown partition table
[   28.864998]  sdc: sdc1 sdc2 < sdc5 >
^GLogin to [iface: default, targ[   28.926442] sd 5:0:0:2: [sdd] Attached SCSI disk
et: iqn.2003-01.[   28.932150] sd 5:0:0:1: [sdc] Attached SCSI disk
org.linux-iscsi.target:sn.726f464255f7b1dc47c8131b3471abeb, portal: 192.168.101.2,3260]: successful
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   29.340657] qla2xxx [0000:01:07.0]-8038:4: Cable is unplugged...
Mar 20 23:39:52 tst001 iscsid: connection1:0 is operational now

----- End forwarded message -----
