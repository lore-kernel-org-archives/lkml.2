Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2IJFvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:51:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37644 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IJFuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:50:52 -0400
Date: Mon, 10 Sep 2012 07:50:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v8 0/12] x86: Arbitrary CPU hot(un)plug support
Message-ID: <20120910055041.GA13446@gmail.com>
References: <1345916488-8355-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345916488-8355-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> CPU0 or BSP (Bootstrap Processor) has been the last processor 
> that can not be hot removed on x86. This patchset implements 
> CPU0 or BSP online and offline and removes this obstacle to 
> CPU hotplug.

I have started testing the tip:x86/bsp-hotplug topic tree and 
with one particular config it triggers a boot lockup in 
debug_hotplug_cpu().

Booting the same kernel again produced the debug_hotplug_cpu() 
lockup again. Excluding tip:x86/bsp-hotplug from tip:master 
produces a working kernel.

See the full serial log capture below. Config attached.

Build environment:

  gcc-4.7.0-5.fc17.x86_64
  binutils-2.22.52.0.1-10.fc17.x86_64

Thanks,

	Ingo

--------------------------->
Linux version 3.6.0-rc5-01600-g1501693-dirty (mingo@earth5) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #196867 SMP Sun Sep 9 22:46:20 CEST 2012
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000003ffeffff] usable
BIOS-e820: [mem 0x000000003fff0000-0x000000003fff2fff] ACPI NVS
BIOS-e820: [mem 0x000000003fff3000-0x000000003fffffff] ACPI data
BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
console [earlyser0] enabled
debug: ignoring loglevel setting.
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.3 present.
DMI: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x3fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Scan for SMP in [mem 0x00000000-0x000003ff]
Scan for SMP in [mem 0x0009fc00-0x0009ffff]
Scan for SMP in [mem 0x000f0000-0x000fffff]
found SMP MP-table at [mem 0x000f5680-0x000f568f] mapped at [c00f5680]
  mpc: f1400-f1524
initial memory mapped: [mem 0x00000000-0x01ffffff]
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: [mem 0x00000000-0x377fdfff]
 [mem 0x00000000-0x003fffff] page 4k
 [mem 0x00400000-0x373fffff] page 2M
 [mem 0x37400000-0x377fdfff] page 4k
kernel direct mapping tables up to 0x377fdfff @ [mem 0x01ffa000-0x01ffffff]
cma: dma_contiguous_reserve(limit 00000000)
cma: dma_contiguous_reserve: reserving 16 MiB for global area
cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
cma: CMA: reserved 16 MiB at 36400000
ACPI: RSDP 000f76f0 00014 (v00 Nvidia)
ACPI: RSDT 3fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 3fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 3fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 3fff0000 00040
ACPI: SRAT 3fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: MCFG 3fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 3fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
mapped APIC to         ffffa000 (        fee00000)
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  Normal   [mem 0x01000000-0x377fdfff]
  HighMem  [mem 0x377fe000-0x3ffeffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009efff]
  node   0: [mem 0x00100000-0x3ffeffff]
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c15e44e0, node_mem_map f5c00200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
mapped APIC to         ffffa000 (        fee00000)
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
Int: type 0, pol 1, trig 1, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Int: type 0, pol 1, trig 1, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 00, IRQ 02, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
ACPI: IRQ9 used by override.
Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
mapped IOAPIC to ffff9000 (fec00000)
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
e820: [mem 0x40000000-0xdfffffff] available for PCI devices
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f77d6000 s27200 r0 d21952 u49152
pcpu-alloc: s27200 r0 d21952 u49152 alloc=12*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: root=/dev/sda1 earlyprintk=ttyS0,115200,keep console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
sysrq: sysrq always enabled.
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
__ex_table already sorted, skipping sort
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0003fff0)
Memory: 1009160k/1048512k available (4228k kernel code, 38900k reserved, 1860k data, 396k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc15f3000 - 0xc1656000   ( 396 kB)
      .data : 0xc1421380 - 0xc15f26a0   (1860 kB)
      .text : 0xc1000000 - 0xc1421380   (4228 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
	RCU debugfs-based tracing is enabled.
	RCU lockdep checking is enabled.
	Additional per-CPU info printed with stalls.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=f5810000 soft=f5812000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3567 kB
 memory used by lock dependency info: 3567 kB
 per task-struct memory footprint: 1152 bytes
 per task-struct memory footprint: 1152 bytes
------------------------
------------------------
| Locking API testsuite:
| Locking API testsuite:
----------------------------------------------------------------------------
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
  --------------------------------------------------------------------------
                     A-A deadlock:                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

                 A-B-B-A deadlock:                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

             A-B-B-C-C-A deadlock:             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

             A-B-C-A-B-C deadlock:             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         A-B-B-C-C-D-D-A deadlock:         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         A-B-C-D-B-D-D-A deadlock:         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         A-B-C-D-B-C-D-A deadlock:         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

                    double unlock:                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

                  initialize held:                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

                 bad unlock order:                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

  --------------------------------------------------------------------------
  --------------------------------------------------------------------------
              recursive read-lock:              recursive read-lock:             |             |  ok  |  ok  |             |             |  ok  |  ok  |

           recursive read-lock #2:           recursive read-lock #2:             |             |  ok  |  ok  |             |             |  ok  |  ok  |

            mixed read-write-lock:            mixed read-write-lock:             |             |  ok  |  ok  |             |             |  ok  |  ok  |

            mixed write-read-lock:            mixed write-read-lock:             |             |  ok  |  ok  |             |             |  ok  |  ok  |

  --------------------------------------------------------------------------
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

     soft-irqs-on + irq-safe-A/12:     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

     hard-irqs-on + irq-safe-A/21:     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

     soft-irqs-on + irq-safe-A/21:     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

       sirq-safe-A => hirqs-on/12:       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

       sirq-safe-A => hirqs-on/21:       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         hard-safe-A + irqs-on/12:         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         soft-safe-A + irqs-on/12:         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         hard-safe-A + irqs-on/21:         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

         soft-safe-A + irqs-on/21:         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/123:    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/123:    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/132:    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/132:    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/213:    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/213:    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/231:    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/231:    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/312:    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/312:    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #1/321:    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #1/321:    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/123:    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/123:    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/132:    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/132:    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/213:    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/213:    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/231:    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/231:    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/312:    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/312:    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    hard-safe-A + unsafe-B #2/321:    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

    soft-safe-A + unsafe-B #2/321:    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/123:      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/123:      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/132:      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/132:      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/213:      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/213:      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/231:      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/231:      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/312:      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/312:      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq lock-inversion/321:      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      soft-irq lock-inversion/321:      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

      hard-irq read-recursion/123:      hard-irq read-recursion/123:  ok  |  ok  |

      soft-irq read-recursion/123:      soft-irq read-recursion/123:  ok  |  ok  |

      hard-irq read-recursion/132:      hard-irq read-recursion/132:  ok  |  ok  |

      soft-irq read-recursion/132:      soft-irq read-recursion/132:  ok  |  ok  |

      hard-irq read-recursion/213:      hard-irq read-recursion/213:  ok  |  ok  |

      soft-irq read-recursion/213:      soft-irq read-recursion/213:  ok  |  ok  |

      hard-irq read-recursion/231:      hard-irq read-recursion/231:  ok  |  ok  |

      soft-irq read-recursion/231:      soft-irq read-recursion/231:  ok  |  ok  |

      hard-irq read-recursion/312:      hard-irq read-recursion/312:  ok  |  ok  |

      soft-irq read-recursion/312:      soft-irq read-recursion/312:  ok  |  ok  |

      hard-irq read-recursion/321:      hard-irq read-recursion/321:  ok  |  ok  |

      soft-irq read-recursion/321:      soft-irq read-recursion/321:  ok  |  ok  |

-------------------------------------------------------
-------------------------------------------------------
Good, all 218 testcases passed! |
Good, all 218 testcases passed! |
---------------------------------
---------------------------------
ODEBUG: 10 of 10 active objects replaced
ODEBUG: 10 of 10 active objects replaced
ODEBUG: selftest passed
ODEBUG: selftest passed
tsc: Fast TSC calibration using PIT
tsc: Fast TSC calibration using PIT
tsc: Detected 2010.260 MHz processor
tsc: Detected 2010.260 MHz processor
tsc: Marking TSC unstable due to TSCs unsynchronized
tsc: Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer frequency.. Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.52 BogoMIPS (lpj=8041040)
4020.52 BogoMIPS (lpj=8041040)
pid_max: default: 32768 minimum: 301
pid_max: default: 32768 minimum: 301
Security Framework initialized
Security Framework initialized
TOMOYO Linux initialized
TOMOYO Linux initialized
Mount-cache hash table entries: 512
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
Initializing cgroup subsys cpuacct
Initializing cgroup subsys blkio
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
mce: CPU supports 5 MCE banks
Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
tlb_flushall_shift: 4
Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
tlb_flushall_shift: 4
Freeing SMP alternatives: 16k freed
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20120711
ACPI: Core revision 20120711
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Enabling APIC mode:  Flat.  Using 1 I/O APICs
enabled ExtINT on CPU#0
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
ENABLING IO-APIC IRQs
init IO_APIC IRQs
init IO_APIC IRQs
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
 apic 2 pin 16 not connected
 apic 2 pin 16 not connected
 apic 2 pin 17 not connected
 apic 2 pin 17 not connected
 apic 2 pin 18 not connected
 apic 2 pin 18 not connected
 apic 2 pin 19 not connected
 apic 2 pin 19 not connected
 apic 2 pin 20 not connected
 apic 2 pin 20 not connected
 apic 2 pin 21 not connected
 apic 2 pin 21 not connected
 apic 2 pin 22 not connected
 apic 2 pin 22 not connected
 apic 2 pin 23 not connected
 apic 2 pin 23 not connected
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
smpboot: CPU0: smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
 stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256509
... lapic delta = 1256509
... PM-Timer delta = 357974
... PM-Timer delta = 357974
... PM-Timer result ok
... PM-Timer result ok
..... delta 1256509
..... delta 1256509
..... mult: 53963277
..... mult: 53963277
..... calibration result: 804165
..... calibration result: 804165
..... CPU clock speed is 2010.1658 MHz.
..... CPU clock speed is 2010.1658 MHz.
..... host bus clock speed is 201.0165 MHz.
..... host bus clock speed is 201.0165 MHz.
calling  init_hw_perf_events+0x0/0x3ba @ 1
calling  init_hw_perf_events+0x0/0x3ba @ 1
Performance Events: Performance Events: AMD PMU driver.
AMD PMU driver.
... version:                0
... version:                0
... bit width:              48
... bit width:              48
... generic registers:      4
... generic registers:      4
... value mask:             0000ffffffffffff
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... fixed-purpose events:   0
... event mask:             000000000000000f
... event mask:             000000000000000f
initcall init_hw_perf_events+0x0/0x3ba returned 0 after 35158 usecs
initcall init_hw_perf_events+0x0/0x3ba returned 0 after 35158 usecs
calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
initcall register_trigger_all_cpu_backtrace+0x0/0x13 returned 0 after 0 usecs
initcall register_trigger_all_cpu_backtrace+0x0/0x13 returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x21 @ 1
calling  spawn_ksoftirqd+0x0/0x21 @ 1
initcall spawn_ksoftirqd+0x0/0x21 returned 0 after 0 usecs
initcall spawn_ksoftirqd+0x0/0x21 returned 0 after 0 usecs
calling  init_workqueues+0x0/0x36c @ 1
calling  init_workqueues+0x0/0x36c @ 1
initcall init_workqueues+0x0/0x36c returned 0 after 3906 usecs
initcall init_workqueues+0x0/0x36c returned 0 after 3906 usecs
calling  migration_init+0x0/0x59 @ 1
calling  migration_init+0x0/0x59 @ 1
initcall migration_init+0x0/0x59 returned 0 after 0 usecs
initcall migration_init+0x0/0x59 returned 0 after 0 usecs
calling  cpu_stop_init+0x0/0x9b @ 1
calling  cpu_stop_init+0x0/0x9b @ 1
initcall cpu_stop_init+0x0/0x9b returned 0 after 0 usecs
initcall cpu_stop_init+0x0/0x9b returned 0 after 0 usecs
calling  rcu_scheduler_really_started+0x0/0x11 @ 1
calling  rcu_scheduler_really_started+0x0/0x11 @ 1
initcall rcu_scheduler_really_started+0x0/0x11 returned 0 after 0 usecs
initcall rcu_scheduler_really_started+0x0/0x11 returned 0 after 0 usecs
calling  relay_init+0x0/0x11 @ 1
calling  relay_init+0x0/0x11 @ 1
initcall relay_init+0x0/0x11 returned 0 after 0 usecs
initcall relay_init+0x0/0x11 returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x21b @ 1
calling  dynamic_debug_init+0x0/0x21b @ 1
initcall dynamic_debug_init+0x0/0x21b returned 0 after 0 usecs
initcall dynamic_debug_init+0x0/0x21b returned 0 after 0 usecs
SMP alternatives: lockdep: fixing up alternatives
SMP alternatives: lockdep: fixing up alternatives
CPU 1 irqstacks, hard=f594c000 soft=f594e000
CPU 1 irqstacks, hard=f594c000 soft=f594e000
smpboot: Booting Node   0, Processors smpboot: Booting Node   0, Processors  #1 OK
 #1 OK
Initializing CPU#1
masked ExtINT on CPU#1
Brought up 2 CPUs
Brought up 2 CPUs
----------------
----------------
| NMI testsuite:
| NMI testsuite:
--------------------
--------------------
  remote IPI:  remote IPI:  ok  |  ok  |

   local IPI:   local IPI:  ok  |  ok  |

--------------------
--------------------
Good, all   2 testcases passed! |
Good, all   2 testcases passed! |
---------------------------------
---------------------------------
smpboot: Total of 2 processors activated (8041.38 BogoMIPS)
smpboot: Total of 2 processors activated (8041.38 BogoMIPS)
device: 'platform': device_add
device: 'platform': device_add
PM: Adding info for No Bus:platform
PM: Adding info for No Bus:platform
bus: 'platform': registered
bus: 'platform': registered
bus: 'cpu': registered
bus: 'cpu': registered
device: 'cpu': device_add
device: 'cpu': device_add
PM: Adding info for No Bus:cpu
PM: Adding info for No Bus:cpu
calling  ipc_ns_init+0x0/0x11 @ 1
calling  ipc_ns_init+0x0/0x11 @ 1
initcall ipc_ns_init+0x0/0x11 returned 0 after 0 usecs
initcall ipc_ns_init+0x0/0x11 returned 0 after 0 usecs
calling  init_mmap_min_addr+0x0/0x11 @ 1
calling  init_mmap_min_addr+0x0/0x11 @ 1
initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
calling  evm_display_config+0x0/0x2c @ 1
calling  evm_display_config+0x0/0x2c @ 1
EVM: security.capability
EVM: security.capability
initcall evm_display_config+0x0/0x2c returned 0 after 3906 usecs
initcall evm_display_config+0x0/0x2c returned 0 after 3906 usecs
calling  net_ns_init+0x0/0x129 @ 1
calling  net_ns_init+0x0/0x129 @ 1
initcall net_ns_init+0x0/0x129 returned 0 after 0 usecs
initcall net_ns_init+0x0/0x129 returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x42 @ 1
calling  e820_mark_nvs_memory+0x0/0x42 @ 1
PM: Registering ACPI NVS region [mem 0x3fff0000-0x3fff2fff] (12288 bytes)
PM: Registering ACPI NVS region [mem 0x3fff0000-0x3fff2fff] (12288 bytes)
initcall e820_mark_nvs_memory+0x0/0x42 returned 0 after 3906 usecs
initcall e820_mark_nvs_memory+0x0/0x42 returned 0 after 3906 usecs
calling  reboot_init+0x0/0x1d @ 1
calling  reboot_init+0x0/0x1d @ 1
initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
initcall reboot_init+0x0/0x1d returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x1e @ 1
calling  init_lapic_sysfs+0x0/0x1e @ 1
initcall init_lapic_sysfs+0x0/0x1e returned 0 after 0 usecs
initcall init_lapic_sysfs+0x0/0x1e returned 0 after 0 usecs
calling  cpu_hotplug_pm_sync_init+0x0/0x11 @ 1
calling  cpu_hotplug_pm_sync_init+0x0/0x11 @ 1
initcall cpu_hotplug_pm_sync_init+0x0/0x11 returned 0 after 0 usecs
initcall cpu_hotplug_pm_sync_init+0x0/0x11 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0x7 @ 1
calling  alloc_frozen_cpus+0x0/0x7 @ 1
initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs
initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x7a @ 1
calling  ksysfs_init+0x0/0x7a @ 1
initcall ksysfs_init+0x0/0x7a returned 0 after 0 usecs
initcall ksysfs_init+0x0/0x7a returned 0 after 0 usecs
calling  pm_init+0x0/0x84 @ 1
calling  pm_init+0x0/0x84 @ 1
initcall pm_init+0x0/0x84 returned 0 after 0 usecs
initcall pm_init+0x0/0x84 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x14 @ 1
calling  pm_disk_init+0x0/0x14 @ 1
initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x30 @ 1
calling  swsusp_header_init+0x0/0x30 @ 1
initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0xf @ 1
calling  init_jiffies_clocksource+0x0/0xf @ 1
initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x14 @ 1
calling  init_zero_pfn+0x0/0x14 @ 1
initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
calling  memory_failure_init+0x0/0xbd @ 1
calling  memory_failure_init+0x0/0xbd @ 1
initcall memory_failure_init+0x0/0xbd returned 0 after 0 usecs
initcall memory_failure_init+0x0/0xbd returned 0 after 0 usecs
calling  fsnotify_init+0x0/0x2c @ 1
calling  fsnotify_init+0x0/0x2c @ 1
initcall fsnotify_init+0x0/0x2c returned 0 after 0 usecs
initcall fsnotify_init+0x0/0x2c returned 0 after 0 usecs
calling  filelock_init+0x0/0x2f @ 1
calling  filelock_init+0x0/0x2f @ 1
initcall filelock_init+0x0/0x2f returned 0 after 0 usecs
initcall filelock_init+0x0/0x2f returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x13 @ 1
calling  init_script_binfmt+0x0/0x13 @ 1
initcall init_script_binfmt+0x0/0x13 returned 0 after 0 usecs
initcall init_script_binfmt+0x0/0x13 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x13 @ 1
calling  init_elf_binfmt+0x0/0x13 @ 1
initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x4c @ 1
calling  debugfs_init+0x0/0x4c @ 1
initcall debugfs_init+0x0/0x4c returned 0 after 0 usecs
initcall debugfs_init+0x0/0x4c returned 0 after 0 usecs
calling  securityfs_init+0x0/0x43 @ 1
calling  securityfs_init+0x0/0x43 @ 1
initcall securityfs_init+0x0/0x43 returned 0 after 0 usecs
initcall securityfs_init+0x0/0x43 returned 0 after 0 usecs
calling  random32_init+0x0/0xa8 @ 1
calling  random32_init+0x0/0xa8 @ 1
initcall random32_init+0x0/0xa8 returned 0 after 0 usecs
initcall random32_init+0x0/0xa8 returned 0 after 0 usecs
calling  sfi_sysfs_init+0x0/0xbd @ 1
calling  sfi_sysfs_init+0x0/0xbd @ 1
initcall sfi_sysfs_init+0x0/0xbd returned 0 after 0 usecs
initcall sfi_sysfs_init+0x0/0xbd returned 0 after 0 usecs
calling  regulator_init+0x0/0x69 @ 1
calling  regulator_init+0x0/0x69 @ 1
device class 'regulator': registering
device class 'regulator': registering
Registering platform device 'reg-dummy'. Parent at platform
Registering platform device 'reg-dummy'. Parent at platform
device: 'reg-dummy': device_add
device: 'reg-dummy': device_add
bus: 'platform': add device reg-dummy
bus: 'platform': add device reg-dummy
PM: Adding info for platform:reg-dummy
PM: Adding info for platform:reg-dummy
bus: 'platform': add driver reg-dummy
bus: 'platform': add driver reg-dummy
bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
device: 'regulator.0': device_add
device: 'regulator.0': device_add
PM: Adding info for No Bus:regulator.0
PM: Adding info for No Bus:regulator.0
dummy: 
dummy: 
driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
initcall regulator_init+0x0/0x69 returned 0 after 50784 usecs
initcall regulator_init+0x0/0x69 returned 0 after 50784 usecs
calling  cma_init_reserved_areas+0x0/0x25c @ 1
calling  cma_init_reserved_areas+0x0/0x25c @ 1
cma: cma_init_reserved_areas()
cma: cma_init_reserved_areas()
cma: cma_create_area(base 00036400, count 1000)
cma: cma_create_area(base 00036400, count 1000)
cma: cma_create_area: returned f59376c0
cma: cma_create_area: returned f59376c0
initcall cma_init_reserved_areas+0x0/0x25c returned 0 after 11719 usecs
initcall cma_init_reserved_areas+0x0/0x25c returned 0 after 11719 usecs
calling  early_resume_init+0x0/0x1a0 @ 1
calling  early_resume_init+0x0/0x1a0 @ 1
RTC time:  2:34:06, date: 08/31/12
RTC time:  2:34:06, date: 08/31/12
initcall early_resume_init+0x0/0x1a0 returned 0 after 3906 usecs
initcall early_resume_init+0x0/0x1a0 returned 0 after 3906 usecs
calling  bsp_pm_check_init+0x0/0x11 @ 1
calling  bsp_pm_check_init+0x0/0x11 @ 1
initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 usecs
initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 usecs
calling  sock_init+0x0/0x83 @ 1
calling  sock_init+0x0/0x83 @ 1
initcall sock_init+0x0/0x83 returned 0 after 0 usecs
initcall sock_init+0x0/0x83 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x39 @ 1
calling  netpoll_init+0x0/0x39 @ 1
initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x16b @ 1
calling  netlink_proto_init+0x0/0x16b @ 1
NET: Registered protocol family 16
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x16b returned 0 after 3906 usecs
initcall netlink_proto_init+0x0/0x16b returned 0 after 3906 usecs
calling  bdi_class_init+0x0/0x3c @ 1
calling  bdi_class_init+0x0/0x3c @ 1
device class 'bdi': registering
device class 'bdi': registering
initcall bdi_class_init+0x0/0x3c returned 0 after 3906 usecs
initcall bdi_class_init+0x0/0x3c returned 0 after 3906 usecs
calling  kobject_uevent_init+0x0/0x1e @ 1
calling  kobject_uevent_init+0x0/0x1e @ 1
initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x14 @ 1
calling  pcibus_class_init+0x0/0x14 @ 1
device class 'pci_bus': registering
device class 'pci_bus': registering
initcall pcibus_class_init+0x0/0x14 returned 0 after 3906 usecs
initcall pcibus_class_init+0x0/0x14 returned 0 after 3906 usecs
calling  pci_driver_init+0x0/0x14 @ 1
calling  pci_driver_init+0x0/0x14 @ 1
bus: 'pci': registered
bus: 'pci': registered
initcall pci_driver_init+0x0/0x14 returned 0 after 3906 usecs
initcall pci_driver_init+0x0/0x14 returned 0 after 3906 usecs
calling  rio_bus_init+0x0/0x2f @ 1
calling  rio_bus_init+0x0/0x2f @ 1
device: 'rapidio': device_add
device: 'rapidio': device_add
PM: Adding info for No Bus:rapidio
PM: Adding info for No Bus:rapidio
bus: 'rapidio': registered
bus: 'rapidio': registered
initcall rio_bus_init+0x0/0x2f returned 0 after 11719 usecs
initcall rio_bus_init+0x0/0x2f returned 0 after 11719 usecs
calling  tty_class_init+0x0/0x2b @ 1
calling  tty_class_init+0x0/0x2b @ 1
device class 'tty': registering
device class 'tty': registering
initcall tty_class_init+0x0/0x2b returned 0 after 3906 usecs
initcall tty_class_init+0x0/0x2b returned 0 after 3906 usecs
calling  vtconsole_class_init+0x0/0xc9 @ 1
calling  vtconsole_class_init+0x0/0xc9 @ 1
device class 'vtconsole': registering
device class 'vtconsole': registering
device: 'vtcon0': device_add
device: 'vtcon0': device_add
PM: Adding info for No Bus:vtcon0
PM: Adding info for No Bus:vtcon0
initcall vtconsole_class_init+0x0/0xc9 returned 0 after 11719 usecs
initcall vtconsole_class_init+0x0/0xc9 returned 0 after 11719 usecs
calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
calling  regmap_initcall+0x0/0xc @ 1
calling  regmap_initcall+0x0/0xc @ 1
initcall regmap_initcall+0x0/0xc returned 0 after 0 usecs
initcall regmap_initcall+0x0/0xc returned 0 after 0 usecs
calling  spi_init+0x0/0x7f @ 1
calling  spi_init+0x0/0x7f @ 1
bus: 'spi': registered
bus: 'spi': registered
device class 'spi_master': registering
device class 'spi_master': registering
initcall spi_init+0x0/0x7f returned 0 after 7812 usecs
initcall spi_init+0x0/0x7f returned 0 after 7812 usecs
calling  i2c_init+0x0/0x5e @ 1
calling  i2c_init+0x0/0x5e @ 1
bus: 'i2c': registered
bus: 'i2c': registered
bus: 'i2c': add driver dummy
bus: 'i2c': add driver dummy
i2c-core: driver [dummy] registered
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x5e returned 0 after 11719 usecs
initcall i2c_init+0x0/0x5e returned 0 after 11719 usecs
calling  amd_postcore_init+0x0/0x123 @ 1
calling  amd_postcore_init+0x0/0x123 @ 1
node 0 link 0: io port [1000, fffff]
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]node 0 link 0: mmio [e0000000, efffffff]

node 0 link 0: mmio [feb00000, fec0ffff]node 0 link 0: mmio [feb00000, fec0ffff]

node 0 link 0: mmio [a0000, bffff]node 0 link 0: mmio [a0000, bffff]

node 0 link 0: mmio [40000000, fed3ffff]node 0 link 0: mmio [40000000, fed3ffff]

bus: [bus 00-ff] on node 0 link 0
bus: [bus 00-ff] on node 0 link 0
bus: 00 [io  0x0000-0xffff]
bus: 00 [io  0x0000-0xffff]
bus: 00 [mem 0x40000000-0xffffffff]
bus: 00 [mem 0x40000000-0xffffffff]
bus: 00 [mem 0xfeb00000-0xfec0ffff]
bus: 00 [mem 0xfeb00000-0xfec0ffff]
bus: 00 [mem 0x000a0000-0x000bffff]
bus: 00 [mem 0x000a0000-0x000bffff]
initcall amd_postcore_init+0x0/0x123 returned 0 after 46877 usecs
initcall amd_postcore_init+0x0/0x123 returned 0 after 46877 usecs
calling  set_real_mode_permissions+0x0/0x65 @ 1
calling  set_real_mode_permissions+0x0/0x65 @ 1
initcall set_real_mode_permissions+0x0/0x65 returned 0 after 0 usecs
initcall set_real_mode_permissions+0x0/0x65 returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x1e @ 1
calling  arch_kdebugfs_init+0x0/0x1e @ 1
initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
calling  init_pit_clocksource+0x0/0x3b @ 1
calling  init_pit_clocksource+0x0/0x3b @ 1
initcall init_pit_clocksource+0x0/0x3b returned 0 after 0 usecs
initcall init_pit_clocksource+0x0/0x3b returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x56 @ 1
calling  mtrr_if_init+0x0/0x56 @ 1
initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
calling  mrst_platform_init+0x0/0x32 @ 1
calling  mrst_platform_init+0x0/0x32 @ 1
initcall mrst_platform_init+0x0/0x32 returned 0 after 0 usecs
initcall mrst_platform_init+0x0/0x32 returned 0 after 0 usecs
calling  msic_init+0x0/0x22 @ 1
calling  msic_init+0x0/0x22 @ 1
initcall msic_init+0x0/0x22 returned 0 after 0 usecs
initcall msic_init+0x0/0x22 returned 0 after 0 usecs
calling  acpi_pci_init+0x0/0x4f @ 1
calling  acpi_pci_init+0x0/0x4f @ 1
ACPI: bus type pci registered
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x4f returned 0 after 3906 usecs
initcall acpi_pci_init+0x0/0x4f returned 0 after 3906 usecs
calling  dma_bus_init+0x0/0x14 @ 1
calling  dma_bus_init+0x0/0x14 @ 1
device class 'dma': registering
device class 'dma': registering
initcall dma_bus_init+0x0/0x14 returned 0 after 3906 usecs
initcall dma_bus_init+0x0/0x14 returned 0 after 3906 usecs
calling  dma_channel_table_init+0x0/0xe8 @ 1
calling  dma_channel_table_init+0x0/0xe8 @ 1
initcall dma_channel_table_init+0x0/0xe8 returned 0 after 0 usecs
initcall dma_channel_table_init+0x0/0xe8 returned 0 after 0 usecs
calling  dmi_id_init+0x0/0x28d @ 1
calling  dmi_id_init+0x0/0x28d @ 1
device class 'dmi': registering
device class 'dmi': registering
device: 'id': device_add
device: 'id': device_add
PM: Adding info for No Bus:id
PM: Adding info for No Bus:id
initcall dmi_id_init+0x0/0x28d returned 0 after 11719 usecs
initcall dmi_id_init+0x0/0x28d returned 0 after 11719 usecs
calling  pci_arch_init+0x0/0x68 @ 1
calling  pci_arch_init+0x0/0x68 @ 1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x68 returned 0 after 15625 usecs
initcall pci_arch_init+0x0/0x68 returned 0 after 15625 usecs
calling  topology_init+0x0/0x36 @ 1
calling  topology_init+0x0/0x36 @ 1
device: 'cpu0': device_add
device: 'cpu0': device_add
bus: 'cpu': add device cpu0
bus: 'cpu': add device cpu0
PM: Adding info for cpu:cpu0
PM: Adding info for cpu:cpu0
device: 'cpu1': device_add
device: 'cpu1': device_add
bus: 'cpu': add device cpu1
bus: 'cpu': add device cpu1
PM: Adding info for cpu:cpu1
PM: Adding info for cpu:cpu1
initcall topology_init+0x0/0x36 returned 0 after 23438 usecs
initcall topology_init+0x0/0x36 returned 0 after 23438 usecs
calling  mtrr_init_finialize+0x0/0x30 @ 1
calling  mtrr_init_finialize+0x0/0x30 @ 1
initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x142 @ 1
calling  param_sysfs_init+0x0/0x142 @ 1
initcall param_sysfs_init+0x0/0x142 returned 0 after 11719 usecs
initcall param_sysfs_init+0x0/0x142 returned 0 after 11719 usecs
calling  pm_sysrq_init+0x0/0x20 @ 1
calling  pm_sysrq_init+0x0/0x20 @ 1
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0x3c @ 1
calling  default_bdi_init+0x0/0x3c @ 1
device: 'default': device_add
device: 'default': device_add
PM: Adding info for No Bus:default
PM: Adding info for No Bus:default
initcall default_bdi_init+0x0/0x3c returned 0 after 7812 usecs
initcall default_bdi_init+0x0/0x3c returned 0 after 7812 usecs
calling  init_bio+0x0/0xd5 @ 1
calling  init_bio+0x0/0xd5 @ 1
bio: create slab <bio-0> at 0
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xd5 returned 0 after 3906 usecs
initcall init_bio+0x0/0xd5 returned 0 after 3906 usecs
calling  fsnotify_notification_init+0x0/0x9c @ 1
calling  fsnotify_notification_init+0x0/0x9c @ 1
initcall fsnotify_notification_init+0x0/0x9c returned 0 after 0 usecs
initcall fsnotify_notification_init+0x0/0x9c returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0xf @ 1
calling  cryptomgr_init+0x0/0xf @ 1
initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x1d @ 1
calling  blk_settings_init+0x0/0x1d @ 1
initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2f @ 1
calling  blk_ioc_init+0x0/0x2f @ 1
initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x54 @ 1
calling  blk_softirq_init+0x0/0x54 @ 1
initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x54 @ 1
calling  blk_iopoll_setup+0x0/0x54 @ 1
initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x6a @ 1
calling  genhd_device_init+0x0/0x6a @ 1
device class 'block': registering
device class 'block': registering
initcall genhd_device_init+0x0/0x6a returned 0 after 3906 usecs
initcall genhd_device_init+0x0/0x6a returned 0 after 3906 usecs
calling  gpiolib_debugfs_init+0x0/0x2a @ 1
calling  gpiolib_debugfs_init+0x0/0x2a @ 1
initcall gpiolib_debugfs_init+0x0/0x2a returned 0 after 0 usecs
initcall gpiolib_debugfs_init+0x0/0x2a returned 0 after 0 usecs
calling  platform_msic_gpio_init+0x0/0xf @ 1
calling  platform_msic_gpio_init+0x0/0xf @ 1
bus: 'platform': add driver msic_gpio
bus: 'platform': add driver msic_gpio
initcall platform_msic_gpio_init+0x0/0xf returned 0 after 3906 usecs
initcall platform_msic_gpio_init+0x0/0xf returned 0 after 3906 usecs
calling  sx150x_init+0x0/0x11 @ 1
calling  sx150x_init+0x0/0x11 @ 1
bus: 'i2c': add driver sx150x
bus: 'i2c': add driver sx150x
i2c-core: driver [sx150x] registered
i2c-core: driver [sx150x] registered
initcall sx150x_init+0x0/0x11 returned 0 after 7812 usecs
initcall sx150x_init+0x0/0x11 returned 0 after 7812 usecs
calling  pwm_debugfs_init+0x0/0x2a @ 1
calling  pwm_debugfs_init+0x0/0x2a @ 1
initcall pwm_debugfs_init+0x0/0x2a returned 0 after 0 usecs
initcall pwm_debugfs_init+0x0/0x2a returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x50 @ 1
calling  pci_slot_init+0x0/0x50 @ 1
initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
calling  acpi_init+0x0/0x26d @ 1
calling  acpi_init+0x0/0x26d @ 1
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Interpreter enabled
ACPI: (supports S0ACPI: (supports S0 S4 S4 S5 S5)
)
ACPI: Using IOAPIC for interrupt routing
ACPI: Using IOAPIC for interrupt routing
bus: 'acpi': registered
bus: 'acpi': registered
bus: 'acpi': add driver power
bus: 'acpi': add driver power
device: 'LNXSYSTM:00': device_add
device: 'LNXSYSTM:00': device_add
bus: 'acpi': add device LNXSYSTM:00
bus: 'acpi': add device LNXSYSTM:00
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXSYSTM:00
device: 'LNXCPU:00': device_add
device: 'LNXCPU:00': device_add
bus: 'acpi': add device LNXCPU:00
bus: 'acpi': add device LNXCPU:00
PM: Adding info for acpi:LNXCPU:00
PM: Adding info for acpi:LNXCPU:00
device: 'LNXCPU:01': device_add
device: 'LNXCPU:01': device_add
bus: 'acpi': add device LNXCPU:01
bus: 'acpi': add device LNXCPU:01
PM: Adding info for acpi:LNXCPU:01
PM: Adding info for acpi:LNXCPU:01
device: 'device:00': device_add
device: 'device:00': device_add
bus: 'acpi': add device device:00
bus: 'acpi': add device device:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:device:00
device: 'PNP0C0C:00': device_add
device: 'PNP0C0C:00': device_add
bus: 'acpi': add device PNP0C0C:00
bus: 'acpi': add device PNP0C0C:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0C:00
device: 'PNP0A08:00': device_add
device: 'PNP0A08:00': device_add
bus: 'acpi': add device PNP0A08:00
bus: 'acpi': add device PNP0A08:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0A08:00
device: 'PNP0C02:00': device_add
device: 'PNP0C02:00': device_add
bus: 'acpi': add device PNP0C02:00
bus: 'acpi': add device PNP0C02:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0C02:00
device: 'device:01': device_add
device: 'device:01': device_add
bus: 'acpi': add device device:01
bus: 'acpi': add device device:01
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:01
device: 'device:02': device_add
device: 'device:02': device_add
bus: 'acpi': add device device:02
bus: 'acpi': add device device:02
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:02
device: 'device:03': device_add
device: 'device:03': device_add
bus: 'acpi': add device device:03
bus: 'acpi': add device device:03
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:03
device: 'device:04': device_add
device: 'device:04': device_add
bus: 'acpi': add device device:04
bus: 'acpi': add device device:04
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:04
device: 'device:05': device_add
device: 'device:05': device_add
bus: 'acpi': add device device:05
bus: 'acpi': add device device:05
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:05
device: 'device:06': device_add
device: 'device:06': device_add
bus: 'acpi': add device device:06
bus: 'acpi': add device device:06
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:06
device: 'device:07': device_add
device: 'device:07': device_add
bus: 'acpi': add device device:07
bus: 'acpi': add device device:07
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:07
device: 'device:08': device_add
device: 'device:08': device_add
bus: 'acpi': add device device:08
bus: 'acpi': add device device:08
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:08
device: 'device:09': device_add
device: 'device:09': device_add
bus: 'acpi': add device device:09
bus: 'acpi': add device device:09
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:09
device: 'device:0a': device_add
device: 'device:0a': device_add
bus: 'acpi': add device device:0a
bus: 'acpi': add device device:0a
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0a
device: 'device:0b': device_add
device: 'device:0b': device_add
bus: 'acpi': add device device:0b
bus: 'acpi': add device device:0b
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0b
device: 'device:0c': device_add
device: 'device:0c': device_add
bus: 'acpi': add device device:0c
bus: 'acpi': add device device:0c
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0c
device: 'device:0d': device_add
device: 'device:0d': device_add
bus: 'acpi': add device device:0d
bus: 'acpi': add device device:0d
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0d
device: 'device:0e': device_add
device: 'device:0e': device_add
bus: 'acpi': add device device:0e
bus: 'acpi': add device device:0e
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0e
device: 'device:0f': device_add
device: 'device:0f': device_add
bus: 'acpi': add device device:0f
bus: 'acpi': add device device:0f
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:0f
device: 'device:10': device_add
device: 'device:10': device_add
bus: 'acpi': add device device:10
bus: 'acpi': add device device:10
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:10
device: 'device:11': device_add
device: 'device:11': device_add
bus: 'acpi': add device device:11
bus: 'acpi': add device device:11
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:11
device: 'device:12': device_add
device: 'device:12': device_add
bus: 'acpi': add device device:12
bus: 'acpi': add device device:12
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:12
device: 'device:13': device_add
device: 'device:13': device_add
bus: 'acpi': add device device:13
bus: 'acpi': add device device:13
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:13
device: 'device:14': device_add
device: 'device:14': device_add
bus: 'acpi': add device device:14
bus: 'acpi': add device device:14
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:14
device: 'device:15': device_add
device: 'device:15': device_add
bus: 'acpi': add device device:15
bus: 'acpi': add device device:15
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:15
device: 'device:16': device_add
device: 'device:16': device_add
bus: 'acpi': add device device:16
bus: 'acpi': add device device:16
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:16
device: 'device:17': device_add
device: 'device:17': device_add
bus: 'acpi': add device device:17
bus: 'acpi': add device device:17
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:17
device: 'device:18': device_add
device: 'device:18': device_add
bus: 'acpi': add device device:18
bus: 'acpi': add device device:18
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:18
device: 'device:19': device_add
device: 'device:19': device_add
bus: 'acpi': add device device:19
bus: 'acpi': add device device:19
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:19
device: 'device:1a': device_add
device: 'device:1a': device_add
bus: 'acpi': add device device:1a
bus: 'acpi': add device device:1a
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1a
device: 'device:1b': device_add
device: 'device:1b': device_add
bus: 'acpi': add device device:1b
bus: 'acpi': add device device:1b
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1b
device: 'device:1c': device_add
device: 'device:1c': device_add
bus: 'acpi': add device device:1c
bus: 'acpi': add device device:1c
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1c
device: 'device:1d': device_add
device: 'device:1d': device_add
bus: 'acpi': add device device:1d
bus: 'acpi': add device device:1d
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1d
device: 'ATK0110:00': device_add
device: 'ATK0110:00': device_add
bus: 'acpi': add device ATK0110:00
bus: 'acpi': add device ATK0110:00
PM: Adding info for acpi:ATK0110:00
PM: Adding info for acpi:ATK0110:00
device: 'PNP0C0F:00': device_add
device: 'PNP0C0F:00': device_add
bus: 'acpi': add device PNP0C0F:00
bus: 'acpi': add device PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:00
device: 'PNP0C0F:01': device_add
device: 'PNP0C0F:01': device_add
bus: 'acpi': add device PNP0C0F:01
bus: 'acpi': add device PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:01
device: 'PNP0C0F:02': device_add
device: 'PNP0C0F:02': device_add
bus: 'acpi': add device PNP0C0F:02
bus: 'acpi': add device PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:02
device: 'PNP0C0F:03': device_add
device: 'PNP0C0F:03': device_add
bus: 'acpi': add device PNP0C0F:03
bus: 'acpi': add device PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:03
device: 'PNP0C0F:04': device_add
device: 'PNP0C0F:04': device_add
bus: 'acpi': add device PNP0C0F:04
bus: 'acpi': add device PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:04
device: 'PNP0C0F:05': device_add
device: 'PNP0C0F:05': device_add
bus: 'acpi': add device PNP0C0F:05
bus: 'acpi': add device PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:05
device: 'PNP0C0F:06': device_add
device: 'PNP0C0F:06': device_add
bus: 'acpi': add device PNP0C0F:06
bus: 'acpi': add device PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:06
device: 'PNP0C0F:07': device_add
device: 'PNP0C0F:07': device_add
bus: 'acpi': add device PNP0C0F:07
bus: 'acpi': add device PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:07
device: 'PNP0C0F:08': device_add
device: 'PNP0C0F:08': device_add
bus: 'acpi': add device PNP0C0F:08
bus: 'acpi': add device PNP0C0F:08
PM: Adding info for acpi:PNP0C0F:08
PM: Adding info for acpi:PNP0C0F:08
device: 'PNP0C0F:09': device_add
device: 'PNP0C0F:09': device_add
bus: 'acpi': add device PNP0C0F:09
bus: 'acpi': add device PNP0C0F:09
PM: Adding info for acpi:PNP0C0F:09
PM: Adding info for acpi:PNP0C0F:09
device: 'PNP0C0F:0a': device_add
device: 'PNP0C0F:0a': device_add
bus: 'acpi': add device PNP0C0F:0a
bus: 'acpi': add device PNP0C0F:0a
PM: Adding info for acpi:PNP0C0F:0a
PM: Adding info for acpi:PNP0C0F:0a
device: 'PNP0C0F:0b': device_add
device: 'PNP0C0F:0b': device_add
bus: 'acpi': add device PNP0C0F:0b
bus: 'acpi': add device PNP0C0F:0b
PM: Adding info for acpi:PNP0C0F:0b
PM: Adding info for acpi:PNP0C0F:0b
device: 'PNP0C0F:0c': device_add
device: 'PNP0C0F:0c': device_add
bus: 'acpi': add device PNP0C0F:0c
bus: 'acpi': add device PNP0C0F:0c
PM: Adding info for acpi:PNP0C0F:0c
PM: Adding info for acpi:PNP0C0F:0c
device: 'PNP0C0F:0d': device_add
device: 'PNP0C0F:0d': device_add
bus: 'acpi': add device PNP0C0F:0d
bus: 'acpi': add device PNP0C0F:0d
PM: Adding info for acpi:PNP0C0F:0d
PM: Adding info for acpi:PNP0C0F:0d
device: 'PNP0C0F:0e': device_add
device: 'PNP0C0F:0e': device_add
bus: 'acpi': add device PNP0C0F:0e
bus: 'acpi': add device PNP0C0F:0e
PM: Adding info for acpi:PNP0C0F:0e
PM: Adding info for acpi:PNP0C0F:0e
device: 'PNP0C0F:0f': device_add
device: 'PNP0C0F:0f': device_add
bus: 'acpi': add device PNP0C0F:0f
bus: 'acpi': add device PNP0C0F:0f
PM: Adding info for acpi:PNP0C0F:0f
PM: Adding info for acpi:PNP0C0F:0f
device: 'PNP0C0F:10': device_add
device: 'PNP0C0F:10': device_add
bus: 'acpi': add device PNP0C0F:10
bus: 'acpi': add device PNP0C0F:10
PM: Adding info for acpi:PNP0C0F:10
PM: Adding info for acpi:PNP0C0F:10
device: 'PNP0C0F:11': device_add
device: 'PNP0C0F:11': device_add
bus: 'acpi': add device PNP0C0F:11
bus: 'acpi': add device PNP0C0F:11
PM: Adding info for acpi:PNP0C0F:11
PM: Adding info for acpi:PNP0C0F:11
device: 'PNP0C0F:12': device_add
device: 'PNP0C0F:12': device_add
bus: 'acpi': add device PNP0C0F:12
bus: 'acpi': add device PNP0C0F:12
PM: Adding info for acpi:PNP0C0F:12
PM: Adding info for acpi:PNP0C0F:12
device: 'PNP0C0F:13': device_add
device: 'PNP0C0F:13': device_add
bus: 'acpi': add device PNP0C0F:13
bus: 'acpi': add device PNP0C0F:13
PM: Adding info for acpi:PNP0C0F:13
PM: Adding info for acpi:PNP0C0F:13
device: 'PNP0C0F:14': device_add
device: 'PNP0C0F:14': device_add
bus: 'acpi': add device PNP0C0F:14
bus: 'acpi': add device PNP0C0F:14
PM: Adding info for acpi:PNP0C0F:14
PM: Adding info for acpi:PNP0C0F:14
device: 'PNP0C0F:15': device_add
device: 'PNP0C0F:15': device_add
bus: 'acpi': add device PNP0C0F:15
bus: 'acpi': add device PNP0C0F:15
PM: Adding info for acpi:PNP0C0F:15
PM: Adding info for acpi:PNP0C0F:15
device: 'PNP0C0F:16': device_add
device: 'PNP0C0F:16': device_add
bus: 'acpi': add device PNP0C0F:16
bus: 'acpi': add device PNP0C0F:16
PM: Adding info for acpi:PNP0C0F:16
PM: Adding info for acpi:PNP0C0F:16
device: 'PNP0C0F:17': device_add
device: 'PNP0C0F:17': device_add
bus: 'acpi': add device PNP0C0F:17
bus: 'acpi': add device PNP0C0F:17
PM: Adding info for acpi:PNP0C0F:17
PM: Adding info for acpi:PNP0C0F:17
device: 'PNP0C0F:18': device_add
device: 'PNP0C0F:18': device_add
bus: 'acpi': add device PNP0C0F:18
bus: 'acpi': add device PNP0C0F:18
PM: Adding info for acpi:PNP0C0F:18
PM: Adding info for acpi:PNP0C0F:18
device: 'PNP0C0F:19': device_add
device: 'PNP0C0F:19': device_add
bus: 'acpi': add device PNP0C0F:19
bus: 'acpi': add device PNP0C0F:19
PM: Adding info for acpi:PNP0C0F:19
PM: Adding info for acpi:PNP0C0F:19
device: 'PNP0C0F:1a': device_add
device: 'PNP0C0F:1a': device_add
bus: 'acpi': add device PNP0C0F:1a
bus: 'acpi': add device PNP0C0F:1a
PM: Adding info for acpi:PNP0C0F:1a
PM: Adding info for acpi:PNP0C0F:1a
device: 'PNP0C0F:1b': device_add
device: 'PNP0C0F:1b': device_add
bus: 'acpi': add device PNP0C0F:1b
bus: 'acpi': add device PNP0C0F:1b
PM: Adding info for acpi:PNP0C0F:1b
PM: Adding info for acpi:PNP0C0F:1b
device: 'PNP0C0F:1c': device_add
device: 'PNP0C0F:1c': device_add
bus: 'acpi': add device PNP0C0F:1c
bus: 'acpi': add device PNP0C0F:1c
PM: Adding info for acpi:PNP0C0F:1c
PM: Adding info for acpi:PNP0C0F:1c
device: 'PNP0C0F:1d': device_add
device: 'PNP0C0F:1d': device_add
bus: 'acpi': add device PNP0C0F:1d
bus: 'acpi': add device PNP0C0F:1d
PM: Adding info for acpi:PNP0C0F:1d
PM: Adding info for acpi:PNP0C0F:1d
device: 'PNP0C0F:1e': device_add
device: 'PNP0C0F:1e': device_add
bus: 'acpi': add device PNP0C0F:1e
bus: 'acpi': add device PNP0C0F:1e
PM: Adding info for acpi:PNP0C0F:1e
PM: Adding info for acpi:PNP0C0F:1e
device: 'PNP0C0F:1f': device_add
device: 'PNP0C0F:1f': device_add
bus: 'acpi': add device PNP0C0F:1f
bus: 'acpi': add device PNP0C0F:1f
PM: Adding info for acpi:PNP0C0F:1f
PM: Adding info for acpi:PNP0C0F:1f
device: 'PNP0C02:01': device_add
device: 'PNP0C02:01': device_add
bus: 'acpi': add device PNP0C02:01
bus: 'acpi': add device PNP0C02:01
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0C02:01
device: 'PNP0000:00': device_add
device: 'PNP0000:00': device_add
bus: 'acpi': add device PNP0000:00
bus: 'acpi': add device PNP0000:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0000:00
device: 'PNP0200:00': device_add
device: 'PNP0200:00': device_add
bus: 'acpi': add device PNP0200:00
bus: 'acpi': add device PNP0200:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0200:00
device: 'PNP0100:00': device_add
device: 'PNP0100:00': device_add
bus: 'acpi': add device PNP0100:00
bus: 'acpi': add device PNP0100:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0100:00
device: 'PNP0B00:00': device_add
device: 'PNP0B00:00': device_add
bus: 'acpi': add device PNP0B00:00
bus: 'acpi': add device PNP0B00:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0B00:00
device: 'PNP0800:00': device_add
device: 'PNP0800:00': device_add
bus: 'acpi': add device PNP0800:00
bus: 'acpi': add device PNP0800:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0800:00
device: 'PNP0C04:00': device_add
device: 'PNP0C04:00': device_add
bus: 'acpi': add device PNP0C04:00
bus: 'acpi': add device PNP0C04:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C04:00
device: 'PNP0700:00': device_add
device: 'PNP0700:00': device_add
bus: 'acpi': add device PNP0700:00
bus: 'acpi': add device PNP0700:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0700:00
device: 'PNP0501:00': device_add
device: 'PNP0501:00': device_add
bus: 'acpi': add device PNP0501:00
bus: 'acpi': add device PNP0501:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0501:00
device: 'PNP0401:00': device_add
device: 'PNP0401:00': device_add
bus: 'acpi': add device PNP0401:00
bus: 'acpi': add device PNP0401:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0401:00
device: 'PNP0F13:00': device_add
device: 'PNP0F13:00': device_add
bus: 'acpi': add device PNP0F13:00
bus: 'acpi': add device PNP0F13:00
PM: Adding info for acpi:PNP0F13:00
PM: Adding info for acpi:PNP0F13:00
device: 'PNP0303:00': device_add
device: 'PNP0303:00': device_add
bus: 'acpi': add device PNP0303:00
bus: 'acpi': add device PNP0303:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0303:00
device: 'PNPB006:00': device_add
device: 'PNPB006:00': device_add
bus: 'acpi': add device PNPB006:00
bus: 'acpi': add device PNPB006:00
PM: Adding info for acpi:PNPB006:00
PM: Adding info for acpi:PNPB006:00
device: 'PNPB02F:00': device_add
device: 'PNPB02F:00': device_add
bus: 'acpi': add device PNPB02F:00
bus: 'acpi': add device PNPB02F:00
PM: Adding info for acpi:PNPB02F:00
PM: Adding info for acpi:PNPB02F:00
device: 'PNP0C02:02': device_add
device: 'PNP0C02:02': device_add
bus: 'acpi': add device PNP0C02:02
bus: 'acpi': add device PNP0C02:02
PM: Adding info for acpi:PNP0C02:02
PM: Adding info for acpi:PNP0C02:02
device: 'PNP0C01:00': device_add
device: 'PNP0C01:00': device_add
bus: 'acpi': add device PNP0C01:00
bus: 'acpi': add device PNP0C01:00
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C01:00
device: 'device:1e': device_add
device: 'device:1e': device_add
bus: 'acpi': add device device:1e
bus: 'acpi': add device device:1e
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1e
device: 'PNP0C0B:00': device_add
device: 'PNP0C0B:00': device_add
bus: 'acpi': add device PNP0C0B:00
bus: 'acpi': add device PNP0C0B:00
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:PNP0C0B:00
device: 'LNXTHERM:00': device_add
device: 'LNXTHERM:00': device_add
bus: 'acpi': add device LNXTHERM:00
bus: 'acpi': add device LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:00
device: 'LNXPWRBN:00': device_add
device: 'LNXPWRBN:00': device_add
bus: 'acpi': add device LNXPWRBN:00
bus: 'acpi': add device LNXPWRBN:00
PM: Adding info for acpi:LNXPWRBN:00
PM: Adding info for acpi:LNXPWRBN:00
bus: 'acpi': add driver ec
bus: 'acpi': add driver ec
initcall acpi_init+0x0/0x26d returned 0 after 1519626 usecs
initcall acpi_init+0x0/0x26d returned 0 after 1519626 usecs
calling  acpi_pci_root_init+0x0/0x2a @ 1
calling  acpi_pci_root_init+0x0/0x2a @ 1
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
bus: 'acpi': add driver pci_root
bus: 'acpi': add driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
PCI: root bus 00: hardware-probed resources
PCI: root bus 00: hardware-probed resources
device: 'pci0000:00': device_add
device: 'pci0000:00': device_add
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:pci0000:00
device: '0000:00': device_add
device: '0000:00': device_add
PM: Adding info for No Bus:0000:00
PM: Adding info for No Bus:0000:00
PCI host bridge to bus 0000:00
PCI host bridge to bus 0000:00
pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x40000000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0x40000000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: root bus resource [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: scanning bus
pci_bus 0000:00: scanning bus
pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
pci 0000:00:01.0: [10de:0050] type 00 class 0x060100
pci 0000:00:01.0: [10de:0050] type 00 class 0x060100
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xb0
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xb0
calling  nvidia_force_enable_hpet+0x0/0xb0 @ 1 for 0000:00:01.0
calling  nvidia_force_enable_hpet+0x0/0xb0 @ 1 for 0000:00:01.0
HPET not enabled in BIOS. You might try hpet=force boot option
HPET not enabled in BIOS. You might try hpet=force boot option
pci fixup nvidia_force_enable_hpet+0x0/0xb0 returned after 3906 usecs for 0000:00:01.0
pci fixup nvidia_force_enable_hpet+0x0/0xb0 returned after 3906 usecs for 0000:00:01.0
pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
pci 0000:00:02.0: reg 10: [mem 0xda002000-0xda002fff]
pci 0000:00:02.0: reg 10: [mem 0xda002000-0xda002fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: [10de:0059] type 00 class 0x040100
pci 0000:00:04.0: [10de:0059] type 00 class 0x040100
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 18: [mem 0xda001000-0xda001fff]
pci 0000:00:04.0: reg 18: [mem 0xda001000-0xda001fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
pci 0000:00:0a.0: reg 10: [mem 0xda000000-0xda000fff]
pci 0000:00:0a.0: reg 10: [mem 0xda000000-0xda000fff]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x9
pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x9
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.0
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.0
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.0
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.0
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x9
pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x9
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.1
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.1
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.1
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.1
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x9
pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x9
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.2
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.2
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.2
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.2
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x9
pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x9
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.3
calling  quirk_mmio_always_on+0x0/0x9 @ 1 for 0000:00:18.3
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.3
pci fixup quirk_mmio_always_on+0x0/0x9 returned after 0 usecs for 0000:00:18.3
pci_bus 0000:00: fixups for bus
pci_bus 0000:00: fixups for bus
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 0
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 0
pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 00-ff]
pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 00-ff]
pci_bus 0000:05: scanning bus
pci_bus 0000:05: scanning bus
pci_bus 0000:05: fixups for bus
pci_bus 0000:05: fixups for bus
pci 0000:00:09.0: PCI bridge to [bus 05] (subtractive decode)
pci 0000:00:09.0: PCI bridge to [bus 05] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci_bus 0000:05: bus scan returning with max=05
pci_bus 0000:05: bus scan returning with max=05
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 0
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 0
pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-ff]
pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-ff]
pci_bus 0000:04: scanning bus
pci_bus 0000:04: scanning bus
pci_bus 0000:04: fixups for bus
pci_bus 0000:04: fixups for bus
pci 0000:00:0b.0: PCI bridge to [bus 04]
pci 0000:00:0b.0: PCI bridge to [bus 04]
pci_bus 0000:04: bus scan returning with max=04
pci_bus 0000:04: bus scan returning with max=04
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
pci_bus 0000:03: scanning bus
pci_bus 0000:03: scanning bus
pci_bus 0000:03: fixups for bus
pci_bus 0000:03: fixups for bus
pci 0000:00:0c.0: PCI bridge to [bus 03]
pci 0000:00:0c.0: PCI bridge to [bus 03]
pci_bus 0000:03: bus scan returning with max=03
pci_bus 0000:03: bus scan returning with max=03
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 0
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 0
pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
pci_bus 0000:02: scanning bus
pci_bus 0000:02: scanning bus
pci_bus 0000:02: fixups for bus
pci_bus 0000:02: fixups for bus
pci 0000:00:0d.0: PCI bridge to [bus 02]
pci 0000:00:0d.0: PCI bridge to [bus 02]
pci_bus 0000:02: bus scan returning with max=02
pci_bus 0000:02: bus scan returning with max=02
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 0
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 0
pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
pci_bus 0000:01: scanning bus
pci_bus 0000:01: scanning bus
pci 0000:01:00.0: [1002:5b60] type 00 class 0x030000
pci 0000:01:00.0: [1002:5b60] type 00 class 0x030000
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 14: [io  0xc000-0xc0ff]
pci 0000:01:00.0: reg 14: [io  0xc000-0xc0ff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:5b70] type 00 class 0x038000
pci 0000:01:00.1: [1002:5b70] type 00 class 0x038000
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.1: supports D1 D2
pci_bus 0000:01: fixups for bus
pci_bus 0000:01: fixups for bus
pci 0000:00:0e.0: PCI bridge to [bus 01]
pci 0000:00:0e.0: PCI bridge to [bus 01]
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci_bus 0000:01: bus scan returning with max=01
pci_bus 0000:01: bus scan returning with max=01
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 1
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 1
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 1
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 1
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 1
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 1
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 1
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 1
pci_bus 0000:00: bus scan returning with max=05
pci_bus 0000:00: bus scan returning with max=05
pci_bus 0000:00: on NUMA node 0
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
 pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
 pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
device: '0000:00:00.0': device_add
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
bus: 'pci': add device 0000:00:00.0
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:00.0
device: '0000:00:01.0': device_add
device: '0000:00:01.0': device_add
bus: 'pci': add device 0000:00:01.0
bus: 'pci': add device 0000:00:01.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:01.0
device: '0000:00:01.1': device_add
device: '0000:00:01.1': device_add
bus: 'pci': add device 0000:00:01.1
bus: 'pci': add device 0000:00:01.1
PM: Adding info for pci:0000:00:01.1
PM: Adding info for pci:0000:00:01.1
device: '0000:00:02.0': device_add
device: '0000:00:02.0': device_add
bus: 'pci': add device 0000:00:02.0
bus: 'pci': add device 0000:00:02.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.0
device: '0000:00:02.1': device_add
device: '0000:00:02.1': device_add
bus: 'pci': add device 0000:00:02.1
bus: 'pci': add device 0000:00:02.1
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:02.1
device: '0000:00:04.0': device_add
device: '0000:00:04.0': device_add
bus: 'pci': add device 0000:00:04.0
bus: 'pci': add device 0000:00:04.0
PM: Adding info for pci:0000:00:04.0
PM: Adding info for pci:0000:00:04.0
device: '0000:00:06.0': device_add
device: '0000:00:06.0': device_add
bus: 'pci': add device 0000:00:06.0
bus: 'pci': add device 0000:00:06.0
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:06.0
device: '0000:00:09.0': device_add
device: '0000:00:09.0': device_add
bus: 'pci': add device 0000:00:09.0
bus: 'pci': add device 0000:00:09.0
PM: Adding info for pci:0000:00:09.0
PM: Adding info for pci:0000:00:09.0
device: '0000:00:0a.0': device_add
device: '0000:00:0a.0': device_add
bus: 'pci': add device 0000:00:0a.0
bus: 'pci': add device 0000:00:0a.0
PM: Adding info for pci:0000:00:0a.0
PM: Adding info for pci:0000:00:0a.0
device: '0000:00:0b.0': device_add
device: '0000:00:0b.0': device_add
bus: 'pci': add device 0000:00:0b.0
bus: 'pci': add device 0000:00:0b.0
PM: Adding info for pci:0000:00:0b.0
PM: Adding info for pci:0000:00:0b.0
device: '0000:00:0c.0': device_add
device: '0000:00:0c.0': device_add
bus: 'pci': add device 0000:00:0c.0
bus: 'pci': add device 0000:00:0c.0
PM: Adding info for pci:0000:00:0c.0
PM: Adding info for pci:0000:00:0c.0
device: '0000:00:0d.0': device_add
device: '0000:00:0d.0': device_add
bus: 'pci': add device 0000:00:0d.0
bus: 'pci': add device 0000:00:0d.0
PM: Adding info for pci:0000:00:0d.0
PM: Adding info for pci:0000:00:0d.0
device: '0000:00:0e.0': device_add
device: '0000:00:0e.0': device_add
bus: 'pci': add device 0000:00:0e.0
bus: 'pci': add device 0000:00:0e.0
PM: Adding info for pci:0000:00:0e.0
PM: Adding info for pci:0000:00:0e.0
device: '0000:00:18.0': device_add
device: '0000:00:18.0': device_add
bus: 'pci': add device 0000:00:18.0
bus: 'pci': add device 0000:00:18.0
PM: Adding info for pci:0000:00:18.0
PM: Adding info for pci:0000:00:18.0
device: '0000:00:18.1': device_add
device: '0000:00:18.1': device_add
bus: 'pci': add device 0000:00:18.1
bus: 'pci': add device 0000:00:18.1
PM: Adding info for pci:0000:00:18.1
PM: Adding info for pci:0000:00:18.1
device: '0000:00:18.2': device_add
device: '0000:00:18.2': device_add
bus: 'pci': add device 0000:00:18.2
bus: 'pci': add device 0000:00:18.2
PM: Adding info for pci:0000:00:18.2
PM: Adding info for pci:0000:00:18.2
device: '0000:00:18.3': device_add
device: '0000:00:18.3': device_add
bus: 'pci': add device 0000:00:18.3
bus: 'pci': add device 0000:00:18.3
PM: Adding info for pci:0000:00:18.3
PM: Adding info for pci:0000:00:18.3
device: '0000:05': device_add
device: '0000:05': device_add
PM: Adding info for No Bus:0000:05
PM: Adding info for No Bus:0000:05
device: '0000:04': device_add
device: '0000:04': device_add
PM: Adding info for No Bus:0000:04
PM: Adding info for No Bus:0000:04
device: '0000:03': device_add
device: '0000:03': device_add
PM: Adding info for No Bus:0000:03
PM: Adding info for No Bus:0000:03
device: '0000:02': device_add
device: '0000:02': device_add
PM: Adding info for No Bus:0000:02
PM: Adding info for No Bus:0000:02
device: '0000:01:00.0': device_add
device: '0000:01:00.0': device_add
bus: 'pci': add device 0000:01:00.0
bus: 'pci': add device 0000:01:00.0
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.0
device: '0000:01:00.1': device_add
device: '0000:01:00.1': device_add
bus: 'pci': add device 0000:01:00.1
bus: 'pci': add device 0000:01:00.1
PM: Adding info for pci:0000:01:00.1
PM: Adding info for pci:0000:01:00.1
device: '0000:01': device_add
device: '0000:01': device_add
PM: Adding info for No Bus:0000:01
PM: Adding info for No Bus:0000:01
driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
initcall acpi_pci_root_init+0x0/0x2a returned 0 after 2640790 usecs
initcall acpi_pci_root_init+0x0/0x2a returned 0 after 2640790 usecs
calling  acpi_pci_link_init+0x0/0x3a @ 1
calling  acpi_pci_link_init+0x0/0x3a @ 1
bus: 'acpi': add driver pci_link
bus: 'acpi': add driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
ACPI: PCI Interrupt Link [LNK1] (IRQsACPI: PCI Interrupt Link [LNK1] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
ACPI: PCI Interrupt Link [LNK2] (IRQsACPI: PCI Interrupt Link [LNK2] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
ACPI: PCI Interrupt Link [LNK3] (IRQsACPI: PCI Interrupt Link [LNK3] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 *11 *11 12 12 14 14 15 15))

driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
ACPI: PCI Interrupt Link [LNK4] (IRQsACPI: PCI Interrupt Link [LNK4] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
ACPI: PCI Interrupt Link [LNK5] (IRQsACPI: PCI Interrupt Link [LNK5] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
ACPI: PCI Interrupt Link [LUBA] (IRQsACPI: PCI Interrupt Link [LUBA] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
ACPI: PCI Interrupt Link [LUBB] (IRQsACPI: PCI Interrupt Link [LUBB] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
ACPI: PCI Interrupt Link [LMAC] (IRQsACPI: PCI Interrupt Link [LMAC] (IRQs *3 *3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15))

driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:08 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:08 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:08
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:08
ACPI: PCI Interrupt Link [LACI] (IRQsACPI: PCI Interrupt Link [LACI] (IRQs 3 3 4 4 *5 *5 7 7 9 9 10 10 11 11 12 12 14 14 15 15))

driver: 'PNP0C0F:08': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:08': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:08 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:08 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:09 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:09 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:09
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:09
ACPI: PCI Interrupt Link [LMCI] (IRQsACPI: PCI Interrupt Link [LMCI] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:09': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:09': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:09 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:09 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0a with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0a with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0a
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0a
ACPI: PCI Interrupt Link [LSMB] (IRQsACPI: PCI Interrupt Link [LSMB] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0a': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0a': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0a to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0a to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0b with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0b with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0b
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0b
ACPI: PCI Interrupt Link [LUB2] (IRQsACPI: PCI Interrupt Link [LUB2] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0b': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0b': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0b to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0b to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0c with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0c with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0c
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0c
ACPI: PCI Interrupt Link [LIDE] (IRQsACPI: PCI Interrupt Link [LIDE] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0c': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0c': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0c to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0c to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0d with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0d with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0d
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0d
ACPI: PCI Interrupt Link [LSID] (IRQsACPI: PCI Interrupt Link [LSID] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0d': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0d': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0d to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0d to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0e with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0e with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0e
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0e
ACPI: PCI Interrupt Link [LFID] (IRQsACPI: PCI Interrupt Link [LFID] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0e': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0e': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0e to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0e to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0f with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:0f with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0f
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:0f
ACPI: PCI Interrupt Link [LPCA] (IRQsACPI: PCI Interrupt Link [LPCA] (IRQs 3 3 4 4 5 5 7 7 9 9 10 10 11 11 12 12 14 14 15 15)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:0f': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:0f': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:0f to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:0f to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:10 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:10 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:10
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:10
ACPI: PCI Interrupt Link [APC1] (IRQsACPI: PCI Interrupt Link [APC1] (IRQs 16 16)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:10': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:10': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:10 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:10 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:11 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:11 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:11
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:11
ACPI: PCI Interrupt Link [APC2] (IRQsACPI: PCI Interrupt Link [APC2] (IRQs 17 17)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:11': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:11': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:11 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:11 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:12 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:12 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:12
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:12
ACPI: PCI Interrupt Link [APC3] (IRQsACPI: PCI Interrupt Link [APC3] (IRQs 18 18)) *0 *0

driver: 'PNP0C0F:12': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:12': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:12 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:12 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:13 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:13 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:13
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:13
ACPI: PCI Interrupt Link [APC4] (IRQsACPI: PCI Interrupt Link [APC4] (IRQs 19 19)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:13': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:13': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:13 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:13 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:14 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:14 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:14
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:14
ACPI: PCI Interrupt Link [APC5] (IRQsACPI: PCI Interrupt Link [APC5] (IRQs *16 *16)), disabled., disabled.

driver: 'PNP0C0F:14': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:14': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:14 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:14 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:15 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:15 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:15
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:15
ACPI: PCI Interrupt Link [APCF] (IRQsACPI: PCI Interrupt Link [APCF] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:15': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:15': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:15 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:15 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:16 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:16 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:16
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:16
ACPI: PCI Interrupt Link [APCG] (IRQsACPI: PCI Interrupt Link [APCG] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:16': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:16': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:16 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:16 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:17 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:17 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:17
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:17
ACPI: PCI Interrupt Link [APCH] (IRQsACPI: PCI Interrupt Link [APCH] (IRQs 20 20 21 21 22 22 23 23)) *0 *0

driver: 'PNP0C0F:17': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:17': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:17 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:17 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:18 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:18 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:18
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:18
ACPI: PCI Interrupt Link [APCJ] (IRQsACPI: PCI Interrupt Link [APCJ] (IRQs 20 20 21 21 22 22 23 23)) *0 *0

driver: 'PNP0C0F:18': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:18': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:18 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:18 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:19 with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:19 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:19
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:19
ACPI: PCI Interrupt Link [APCK] (IRQsACPI: PCI Interrupt Link [APCK] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:19': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:19': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:19 to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:19 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1a with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1a with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1a
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1a
ACPI: PCI Interrupt Link [APCS] (IRQsACPI: PCI Interrupt Link [APCS] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1a': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1a': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1a to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1a to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1b with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1b with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1b
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1b
ACPI: PCI Interrupt Link [APCL] (IRQsACPI: PCI Interrupt Link [APCL] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1b': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1b': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1b to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1b to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1c with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1c with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1c
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1c
ACPI: PCI Interrupt Link [APCZ] (IRQsACPI: PCI Interrupt Link [APCZ] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1c': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1c': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1c to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1c to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1d with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1d with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1d
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1d
ACPI: PCI Interrupt Link [APSI] (IRQsACPI: PCI Interrupt Link [APSI] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1d': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1d': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1d to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1d to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1e with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1e with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1e
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1e
ACPI: PCI Interrupt Link [APSJ] (IRQsACPI: PCI Interrupt Link [APSJ] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1e': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1e': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1e to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1e to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1f with driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:1f with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1f
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:1f
ACPI: PCI Interrupt Link [APCP] (IRQsACPI: PCI Interrupt Link [APCP] (IRQs 20 20 21 21 22 22 23 23)) *0 *0, disabled., disabled.

driver: 'PNP0C0F:1f': driver_bound: bound to device 'pci_link'
driver: 'PNP0C0F:1f': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:1f to driver pci_link
bus: 'acpi': really_probe: bound device PNP0C0F:1f to driver pci_link
initcall acpi_pci_link_init+0x0/0x3a returned 0 after 851615 usecs
initcall acpi_pci_link_init+0x0/0x3a returned 0 after 851615 usecs
calling  pnp_init+0x0/0x14 @ 1
calling  pnp_init+0x0/0x14 @ 1
bus: 'pnp': registered
bus: 'pnp': registered
initcall pnp_init+0x0/0x14 returned 0 after 3906 usecs
initcall pnp_init+0x0/0x14 returned 0 after 3906 usecs
calling  pm8607_regulator_init+0x0/0xf @ 1
calling  pm8607_regulator_init+0x0/0xf @ 1
bus: 'platform': add driver 88pm860x-regulator
bus: 'platform': add driver 88pm860x-regulator
initcall pm8607_regulator_init+0x0/0xf returned 0 after 3906 usecs
initcall pm8607_regulator_init+0x0/0xf returned 0 after 3906 usecs
calling  misc_init+0x0/0xad @ 1
calling  misc_init+0x0/0xad @ 1
device class 'misc': registering
device class 'misc': registering
initcall misc_init+0x0/0xad returned 0 after 3906 usecs
initcall misc_init+0x0/0xad returned 0 after 3906 usecs
calling  vga_arb_device_init+0x0/0xc6 @ 1
calling  vga_arb_device_init+0x0/0xc6 @ 1
device: 'vga_arbiter': device_add
device: 'vga_arbiter': device_add
PM: Adding info for No Bus:vga_arbiter
PM: Adding info for No Bus:vga_arbiter
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
vgaarb: bridge control possible 0000:01:00.0
initcall vga_arb_device_init+0x0/0xc6 returned 0 after 19532 usecs
initcall vga_arb_device_init+0x0/0xc6 returned 0 after 19532 usecs
calling  pm860x_i2c_init+0x0/0x30 @ 1
calling  pm860x_i2c_init+0x0/0x30 @ 1
bus: 'i2c': add driver 88PM860x
bus: 'i2c': add driver 88PM860x
i2c-core: driver [88PM860x] registered
i2c-core: driver [88PM860x] registered
initcall pm860x_i2c_init+0x0/0x30 returned 0 after 7812 usecs
initcall pm860x_i2c_init+0x0/0x30 returned 0 after 7812 usecs
calling  tps65912_i2c_init+0x0/0x30 @ 1
calling  tps65912_i2c_init+0x0/0x30 @ 1
bus: 'i2c': add driver tps65912
bus: 'i2c': add driver tps65912
i2c-core: driver [tps65912] registered
i2c-core: driver [tps65912] registered
initcall tps65912_i2c_init+0x0/0x30 returned 0 after 7812 usecs
initcall tps65912_i2c_init+0x0/0x30 returned 0 after 7812 usecs
calling  twl_init+0x0/0x11 @ 1
calling  twl_init+0x0/0x11 @ 1
bus: 'i2c': add driver twl
bus: 'i2c': add driver twl
i2c-core: driver [twl] registered
i2c-core: driver [twl] registered
initcall twl_init+0x0/0x11 returned 0 after 7812 usecs
initcall twl_init+0x0/0x11 returned 0 after 7812 usecs
calling  da903x_init+0x0/0x11 @ 1
calling  da903x_init+0x0/0x11 @ 1
bus: 'i2c': add driver da903x
bus: 'i2c': add driver da903x
i2c-core: driver [da903x] registered
i2c-core: driver [da903x] registered
initcall da903x_init+0x0/0x11 returned 0 after 7812 usecs
initcall da903x_init+0x0/0x11 returned 0 after 7812 usecs
calling  max8925_i2c_init+0x0/0x30 @ 1
calling  max8925_i2c_init+0x0/0x30 @ 1
bus: 'i2c': add driver max8925
bus: 'i2c': add driver max8925
i2c-core: driver [max8925] registered
i2c-core: driver [max8925] registered
initcall max8925_i2c_init+0x0/0x30 returned 0 after 7812 usecs
initcall max8925_i2c_init+0x0/0x30 returned 0 after 7812 usecs
calling  max8997_i2c_init+0x0/0x11 @ 1
calling  max8997_i2c_init+0x0/0x11 @ 1
bus: 'i2c': add driver max8997
bus: 'i2c': add driver max8997
i2c-core: driver [max8997] registered
i2c-core: driver [max8997] registered
initcall max8997_i2c_init+0x0/0x11 returned 0 after 7812 usecs
initcall max8997_i2c_init+0x0/0x11 returned 0 after 7812 usecs
calling  max8998_i2c_init+0x0/0x11 @ 1
calling  max8998_i2c_init+0x0/0x11 @ 1
bus: 'i2c': add driver max8998
bus: 'i2c': add driver max8998
i2c-core: driver [max8998] registered
i2c-core: driver [max8998] registered
initcall max8998_i2c_init+0x0/0x11 returned 0 after 7812 usecs
initcall max8998_i2c_init+0x0/0x11 returned 0 after 7812 usecs
calling  tps65090_init+0x0/0x11 @ 1
calling  tps65090_init+0x0/0x11 @ 1
bus: 'i2c': add driver tps65090
bus: 'i2c': add driver tps65090
i2c-core: driver [tps65090] registered
i2c-core: driver [tps65090] registered
initcall tps65090_init+0x0/0x11 returned 0 after 7812 usecs
initcall tps65090_init+0x0/0x11 returned 0 after 7812 usecs
calling  aat2870_init+0x0/0x11 @ 1
calling  aat2870_init+0x0/0x11 @ 1
bus: 'i2c': add driver aat2870
bus: 'i2c': add driver aat2870
i2c-core: driver [aat2870] registered
i2c-core: driver [aat2870] registered
initcall aat2870_init+0x0/0x11 returned 0 after 7812 usecs
initcall aat2870_init+0x0/0x11 returned 0 after 7812 usecs
calling  palmas_i2c_init+0x0/0x11 @ 1
calling  palmas_i2c_init+0x0/0x11 @ 1
bus: 'i2c': add driver palmas
bus: 'i2c': add driver palmas
i2c-core: driver [palmas] registered
i2c-core: driver [palmas] registered
initcall palmas_i2c_init+0x0/0x11 returned 0 after 7812 usecs
initcall palmas_i2c_init+0x0/0x11 returned 0 after 7812 usecs
calling  rc5t583_i2c_init+0x0/0x11 @ 1
calling  rc5t583_i2c_init+0x0/0x11 @ 1
bus: 'i2c': add driver rc5t583
bus: 'i2c': add driver rc5t583
i2c-core: driver [rc5t583] registered
i2c-core: driver [rc5t583] registered
initcall rc5t583_i2c_init+0x0/0x11 returned 0 after 7812 usecs
initcall rc5t583_i2c_init+0x0/0x11 returned 0 after 7812 usecs
calling  sec_pmic_init+0x0/0x11 @ 1
calling  sec_pmic_init+0x0/0x11 @ 1
bus: 'i2c': add driver sec_pmic
bus: 'i2c': add driver sec_pmic
i2c-core: driver [sec_pmic] registered
i2c-core: driver [sec_pmic] registered
initcall sec_pmic_init+0x0/0x11 returned 0 after 7812 usecs
initcall sec_pmic_init+0x0/0x11 returned 0 after 7812 usecs
calling  init_scsi+0x0/0x7b @ 1
calling  init_scsi+0x0/0x7b @ 1
device class 'scsi_host': registering
device class 'scsi_host': registering
bus: 'scsi': registered
bus: 'scsi': registered
device class 'scsi_device': registering
device class 'scsi_device': registering
SCSI subsystem initialized
SCSI subsystem initialized
initcall init_scsi+0x0/0x7b returned 0 after 15625 usecs
initcall init_scsi+0x0/0x7b returned 0 after 15625 usecs
calling  ata_init+0x0/0x29a @ 1
calling  ata_init+0x0/0x29a @ 1
device class 'ata_link': registering
device class 'ata_link': registering
device class 'ata_port': registering
device class 'ata_port': registering
device class 'ata_device': registering
device class 'ata_device': registering
libata version 3.00 loaded.
libata version 3.00 loaded.
initcall ata_init+0x0/0x29a returned 0 after 27345 usecs
initcall ata_init+0x0/0x29a returned 0 after 27345 usecs
calling  phy_init+0x0/0x28 @ 1
calling  phy_init+0x0/0x28 @ 1
device class 'mdio_bus': registering
device class 'mdio_bus': registering
bus: 'mdio_bus': registered
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
bus: 'mdio_bus': add driver Generic PHY
initcall phy_init+0x0/0x28 returned 0 after 19532 usecs
initcall phy_init+0x0/0x28 returned 0 after 19532 usecs
calling  usb_init+0x0/0x155 @ 1
calling  usb_init+0x0/0x155 @ 1
ACPI: bus type usb registered
ACPI: bus type usb registered
bus: 'usb': registered
bus: 'usb': registered
bus: 'usb': add driver usbfs
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver usbfs
bus: 'usb': add driver hub
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
bus: 'usb': add driver usb
usbcore: registered new device driver usb
usbcore: registered new device driver usb
initcall usb_init+0x0/0x155 returned 0 after 42971 usecs
initcall usb_init+0x0/0x155 returned 0 after 42971 usecs
calling  serio_init+0x0/0x33 @ 1
calling  serio_init+0x0/0x33 @ 1
bus: 'serio': registered
bus: 'serio': registered
initcall serio_init+0x0/0x33 returned 0 after 3906 usecs
initcall serio_init+0x0/0x33 returned 0 after 3906 usecs
calling  input_init+0x0/0x105 @ 1
calling  input_init+0x0/0x105 @ 1
device class 'input': registering
device class 'input': registering
initcall input_init+0x0/0x105 returned 0 after 3906 usecs
initcall input_init+0x0/0x105 returned 0 after 3906 usecs
calling  power_supply_class_init+0x0/0x35 @ 1
calling  power_supply_class_init+0x0/0x35 @ 1
device class 'power_supply': registering
device class 'power_supply': registering
initcall power_supply_class_init+0x0/0x35 returned 0 after 3906 usecs
initcall power_supply_class_init+0x0/0x35 returned 0 after 3906 usecs
calling  iommu_init+0x0/0x47 @ 1
calling  iommu_init+0x0/0x47 @ 1
initcall iommu_init+0x0/0x47 returned 0 after 0 usecs
initcall iommu_init+0x0/0x47 returned 0 after 0 usecs
calling  devfreq_init+0x0/0x49 @ 1
calling  devfreq_init+0x0/0x49 @ 1
device class 'devfreq': registering
device class 'devfreq': registering
initcall devfreq_init+0x0/0x49 returned 0 after 3906 usecs
initcall devfreq_init+0x0/0x49 returned 0 after 3906 usecs
calling  pci_subsys_init+0x0/0x46 @ 1
calling  pci_subsys_init+0x0/0x46 @ 1
PCI: Using ACPI for IRQ routing
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:01.1: BAR 0: reserving [io  0xdc00-0xdc1f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 0: reserving [io  0xdc00-0xdc1f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 4: reserving [io  0x4c00-0x4c3f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 4: reserving [io  0x4c00-0x4c3f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 5: reserving [io  0x4c40-0x4c7f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 5: reserving [io  0x4c40-0x4c7f flags 0x40101] (d=0, p=0)
pci 0000:00:02.0: BAR 0: reserving [mem 0xda002000-0xda002fff flags 0x40200] (d=0, p=0)
pci 0000:00:02.0: BAR 0: reserving [mem 0xda002000-0xda002fff flags 0x40200] (d=0, p=0)
pci 0000:00:02.1: BAR 0: reserving [mem 0xfeb00000-0xfeb000ff flags 0x40200] (d=0, p=0)
pci 0000:00:02.1: BAR 0: reserving [mem 0xfeb00000-0xfeb000ff flags 0x40200] (d=0, p=0)
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
pci 0000:00:04.0: BAR 0: reserving [io  0xd400-0xd4ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 0: reserving [io  0xd400-0xd4ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 1: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 1: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 2: reserving [mem 0xda001000-0xda001fff flags 0x40200] (d=0, p=0)
pci 0000:00:04.0: BAR 2: reserving [mem 0xda001000-0xda001fff flags 0x40200] (d=0, p=0)
pci 0000:00:06.0: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
pci 0000:00:06.0: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
pci 0000:00:0a.0: BAR 0: reserving [mem 0xda000000-0xda000fff flags 0x40200] (d=0, p=0)
pci 0000:00:0a.0: BAR 0: reserving [mem 0xda000000-0xda000fff flags 0x40200] (d=0, p=0)
pci 0000:00:0a.0: BAR 1: reserving [io  0xd000-0xd007 flags 0x40101] (d=0, p=0)
pci 0000:00:0a.0: BAR 1: reserving [io  0xd000-0xd007 flags 0x40101] (d=0, p=0)
pci 0000:01:00.0: BAR 0: reserving [mem 0xd0000000-0xd7ffffff flags 0x42208] (d=0, p=0)
pci 0000:01:00.0: BAR 0: reserving [mem 0xd0000000-0xd7ffffff flags 0x42208] (d=0, p=0)
pci 0000:01:00.0: BAR 1: reserving [io  0xc000-0xc0ff flags 0x40101] (d=0, p=0)
pci 0000:01:00.0: BAR 1: reserving [io  0xc000-0xc0ff flags 0x40101] (d=0, p=0)
pci 0000:01:00.0: BAR 2: reserving [mem 0xd9000000-0xd900ffff flags 0x40200] (d=0, p=0)
pci 0000:01:00.0: BAR 2: reserving [mem 0xd9000000-0xd900ffff flags 0x40200] (d=0, p=0)
pci 0000:01:00.1: BAR 0: reserving [mem 0xd9010000-0xd901ffff flags 0x40200] (d=1, p=1)
pci 0000:01:00.1: BAR 0: reserving [mem 0xd9010000-0xd901ffff flags 0x40200] (d=1, p=1)
Expanded resource reserved due to conflict with PCI Bus #00
Expanded resource reserved due to conflict with PCI Bus #00
e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
e820: reserve RAM buffer [mem 0x3fff0000-0x3fffffff]
e820: reserve RAM buffer [mem 0x3fff0000-0x3fffffff]
initcall pci_subsys_init+0x0/0x46 returned 0 after 105475 usecs
initcall pci_subsys_init+0x0/0x46 returned 0 after 105475 usecs
calling  proto_init+0x0/0xf @ 1
calling  proto_init+0x0/0xf @ 1
initcall proto_init+0x0/0xf returned 0 after 0 usecs
initcall proto_init+0x0/0xf returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1e5 @ 1
calling  net_dev_init+0x0/0x1e5 @ 1
device class 'net': registering
device class 'net': registering
device: 'lo': device_add
device: 'lo': device_add
PM: Adding info for No Bus:lo
PM: Adding info for No Bus:lo
initcall net_dev_init+0x0/0x1e5 returned 0 after 11719 usecs
initcall net_dev_init+0x0/0x1e5 returned 0 after 11719 usecs
calling  neigh_init+0x0/0xa4 @ 1
calling  neigh_init+0x0/0xa4 @ 1
initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xbd @ 1
calling  fib_rules_init+0x0/0xbd @ 1
initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
calling  pktsched_init+0x0/0x117 @ 1
calling  pktsched_init+0x0/0x117 @ 1
initcall pktsched_init+0x0/0x117 returned 0 after 0 usecs
initcall pktsched_init+0x0/0x117 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x6a @ 1
calling  tc_filter_init+0x0/0x6a @ 1
initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
calling  genl_init+0x0/0x7b @ 1
calling  genl_init+0x0/0x7b @ 1
initcall genl_init+0x0/0x7b returned 0 after 0 usecs
initcall genl_init+0x0/0x7b returned 0 after 0 usecs
calling  wireless_nlevent_init+0x0/0xf @ 1
calling  wireless_nlevent_init+0x0/0xf @ 1
initcall wireless_nlevent_init+0x0/0xf returned 0 after 0 usecs
initcall wireless_nlevent_init+0x0/0xf returned 0 after 0 usecs
calling  hpet_late_init+0x0/0xd3 @ 1
calling  hpet_late_init+0x0/0xd3 @ 1
initcall hpet_late_init+0x0/0xd3 returned -19 after 0 usecs
initcall hpet_late_init+0x0/0xd3 returned -19 after 0 usecs
calling  apbt_late_init+0x0/0x26 @ 1
calling  apbt_late_init+0x0/0x26 @ 1
initcall apbt_late_init+0x0/0x26 returned 0 after 0 usecs
initcall apbt_late_init+0x0/0x26 returned 0 after 0 usecs
calling  init_amd_nbs+0x0/0xac @ 1
calling  init_amd_nbs+0x0/0xac @ 1
initcall init_amd_nbs+0x0/0xac returned 0 after 0 usecs
initcall init_amd_nbs+0x0/0xac returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x53 @ 1
calling  clocksource_done_booting+0x0/0x53 @ 1
initcall clocksource_done_booting+0x0/0x53 returned 0 after 0 usecs
initcall clocksource_done_booting+0x0/0x53 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x3d @ 1
calling  init_pipe_fs+0x0/0x3d @ 1
initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xf1 @ 1
calling  eventpoll_init+0x0/0xf1 @ 1
initcall eventpoll_init+0x0/0xf1 returned 0 after 3906 usecs
initcall eventpoll_init+0x0/0xf1 returned 0 after 3906 usecs
calling  anon_inode_init+0x0/0x52 @ 1
calling  anon_inode_init+0x0/0x52 @ 1
initcall anon_inode_init+0x0/0x52 returned 0 after 0 usecs
initcall anon_inode_init+0x0/0x52 returned 0 after 0 usecs
calling  tomoyo_initerface_init+0x0/0x17f @ 1
calling  tomoyo_initerface_init+0x0/0x17f @ 1
initcall tomoyo_initerface_init+0x0/0x17f returned 0 after 0 usecs
initcall tomoyo_initerface_init+0x0/0x17f returned 0 after 0 usecs
calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
calling  dynamic_debug_init_debugfs+0x0/0x6a @ 1
calling  dynamic_debug_init_debugfs+0x0/0x6a @ 1
initcall dynamic_debug_init_debugfs+0x0/0x6a returned 0 after 3906 usecs
initcall dynamic_debug_init_debugfs+0x0/0x6a returned 0 after 3906 usecs
calling  acpi_event_init+0x0/0x49 @ 1
calling  acpi_event_init+0x0/0x49 @ 1
initcall acpi_event_init+0x0/0x49 returned 0 after 0 usecs
initcall acpi_event_init+0x0/0x49 returned 0 after 0 usecs
calling  pnp_system_init+0x0/0xf @ 1
calling  pnp_system_init+0x0/0xf @ 1
bus: 'pnp': add driver system
bus: 'pnp': add driver system
initcall pnp_system_init+0x0/0xf returned 0 after 3906 usecs
initcall pnp_system_init+0x0/0xf returned 0 after 3906 usecs
calling  pnpacpi_init+0x0/0x88 @ 1
calling  pnpacpi_init+0x0/0x88 @ 1
pnp: PnP ACPI init
pnp: PnP ACPI init
device: 'pnp0': device_add
device: 'pnp0': device_add
PM: Adding info for No Bus:pnp0
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000dffff window]
pnp 00:00: [mem 0x000c0000-0x000dffff window]
pnp 00:00: [mem 0x40000000-0xfebfffff window]
pnp 00:00: [mem 0x40000000-0xfebfffff window]
device: '00:00': device_add
device: '00:00': device_add
bus: 'pnp': add device 00:00
bus: 'pnp': add device 00:00
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:00
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x4000-0x407f]
pnp 00:01: [io  0x4000-0x407f]
pnp 00:01: [io  0x4080-0x40ff]
pnp 00:01: [io  0x4080-0x40ff]
pnp 00:01: [io  0x4400-0x447f]
pnp 00:01: [io  0x4400-0x447f]
pnp 00:01: [io  0x4480-0x44ff]
pnp 00:01: [io  0x4480-0x44ff]
pnp 00:01: [io  0x4800-0x487f]
pnp 00:01: [io  0x4800-0x487f]
pnp 00:01: [io  0x4880-0x48ff]
pnp 00:01: [io  0x4880-0x48ff]
device: '00:01': device_add
device: '00:01': device_add
bus: 'pnp': add device 00:01
bus: 'pnp': add device 00:01
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:01
bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:01
bus: 'pnp': really_probe: probing driver system with device 00:01
system 00:01: [io  0x4000-0x407f] has been reserved
system 00:01: [io  0x4000-0x407f] has been reserved
system 00:01: [io  0x4080-0x40ff] has been reserved
system 00:01: [io  0x4080-0x40ff] has been reserved
system 00:01: [io  0x4400-0x447f] has been reserved
system 00:01: [io  0x4400-0x447f] has been reserved
system 00:01: [io  0x4480-0x44ff] has been reserved
system 00:01: [io  0x4480-0x44ff] has been reserved
system 00:01: [io  0x4800-0x487f] has been reserved
system 00:01: [io  0x4800-0x487f] has been reserved
system 00:01: [io  0x4880-0x48ff] has been reserved
system 00:01: [io  0x4880-0x48ff] has been reserved
driver: '00:01': driver_bound: bound to device 'system'
driver: '00:01': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:01 to driver system
bus: 'pnp': really_probe: bound device 00:01 to driver system
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0022-0x003f]
pnp 00:02: [io  0x0022-0x003f]
pnp 00:02: [io  0x0044-0x005f]
pnp 00:02: [io  0x0044-0x005f]
pnp 00:02: [io  0x0062-0x0063]
pnp 00:02: [io  0x0062-0x0063]
pnp 00:02: [io  0x0065-0x006f]
pnp 00:02: [io  0x0065-0x006f]
pnp 00:02: [io  0x0074-0x007f]
pnp 00:02: [io  0x0074-0x007f]
pnp 00:02: [io  0x0091-0x0093]
pnp 00:02: [io  0x0091-0x0093]
pnp 00:02: [io  0x00a2-0x00bf]
pnp 00:02: [io  0x00a2-0x00bf]
pnp 00:02: [io  0x00e0-0x00ef]
pnp 00:02: [io  0x00e0-0x00ef]
pnp 00:02: [io  0x04d0-0x04d1]
pnp 00:02: [io  0x04d0-0x04d1]
pnp 00:02: [io  0x0800-0x0805]
pnp 00:02: [io  0x0800-0x0805]
pnp 00:02: [io  0x0290-0x0297]
pnp 00:02: [io  0x0290-0x0297]
device: '00:02': device_add
device: '00:02': device_add
bus: 'pnp': add device 00:02
bus: 'pnp': add device 00:02
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:02
bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:02
bus: 'pnp': really_probe: probing driver system with device 00:02
system 00:02: [io  0x04d0-0x04d1] has been reserved
system 00:02: [io  0x04d0-0x04d1] has been reserved
system 00:02: [io  0x0800-0x0805] has been reserved
system 00:02: [io  0x0800-0x0805] has been reserved
system 00:02: [io  0x0290-0x0297] has been reserved
system 00:02: [io  0x0290-0x0297] has been reserved
driver: '00:02': driver_bound: bound to device 'system'
driver: '00:02': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:02 to driver system
bus: 'pnp': really_probe: bound device 00:02 to driver system
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [dma 4]
pnp 00:03: [dma 4]
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x0090]
pnp 00:03: [io  0x0080-0x0090]
pnp 00:03: [io  0x0094-0x009f]
pnp 00:03: [io  0x0094-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [io  0x00c0-0x00df]
device: '00:03': device_add
device: '00:03': device_add
bus: 'pnp': add device 00:03
bus: 'pnp': add device 00:03
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:03
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0070-0x0073]
pnp 00:04: [io  0x0070-0x0073]
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
pnp 00:04: [irq 8]
pnp 00:04: [irq 8]
device: '00:04': device_add
device: '00:04': device_add
bus: 'pnp': add device 00:04
bus: 'pnp': add device 00:04
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:04
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: [io  0x0061]
device: '00:05': device_add
device: '00:05': device_add
bus: 'pnp': add device 00:05
bus: 'pnp': add device 00:05
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:05
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0-0x00ff]
pnp 00:06: [io  0x00f0-0x00ff]
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:3)
pnp 00:06: [irq 13]
pnp 00:06: [irq 13]
device: '00:06': device_add
device: '00:06': device_add
bus: 'pnp': add device 00:06
bus: 'pnp': add device 00:06
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:06
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x03f0-0x03f5]
pnp 00:07: [io  0x03f0-0x03f5]
pnp 00:07: [io  0x03f7]
pnp 00:07: [io  0x03f7]
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
pnp 00:07: [irq 6]
pnp 00:07: [irq 6]
pnp 00:07: [dma 2]
pnp 00:07: [dma 2]
device: '00:07': device_add
device: '00:07': device_add
bus: 'pnp': add device 00:07
bus: 'pnp': add device 00:07
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:07
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:08: [io  0x03f8-0x03ff]
pnp 00:08: [io  0x03f8-0x03ff]
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
pnp 00:08: [irq 4]
pnp 00:08: [irq 4]
device: '00:08': device_add
device: '00:08': device_add
bus: 'pnp': add device 00:08
bus: 'pnp': add device 00:08
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:08
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x0378-0x037f]
pnp 00:09: [io  0x0378-0x037f]
pnp 00:09: [io  0x0778-0x077b]
pnp 00:09: [io  0x0778-0x077b]
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
pnp 00:09: [irq 7]
pnp 00:09: [irq 7]
pnp 00:09: [dma 3]
pnp 00:09: [dma 3]
device: '00:09': device_add
device: '00:09': device_add
bus: 'pnp': add device 00:09
bus: 'pnp': add device 00:09
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:09
pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
pnp 00:0a: [irq 12]
pnp 00:0a: [irq 12]
device: '00:0a': device_add
device: '00:0a': device_add
bus: 'pnp': add device 00:0a
bus: 'pnp': add device 00:0a
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0a
pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0b: [io  0x0060]
pnp 00:0b: [io  0x0060]
pnp 00:0b: [io  0x0064]
pnp 00:0b: [io  0x0064]
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
pnp 00:0b: [irq 1]
pnp 00:0b: [irq 1]
device: '00:0b': device_add
device: '00:0b': device_add
bus: 'pnp': add device 00:0b
bus: 'pnp': add device 00:0b
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0b
pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:0c: [io  0x0330-0x0331]
pnp 00:0c: [io  0x0330-0x0331]
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:3)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:3)
pnp 00:0c: [irq 10]
pnp 00:0c: [irq 10]
device: '00:0c': device_add
device: '00:0c': device_add
bus: 'pnp': add device 00:0c
bus: 'pnp': add device 00:0c
PM: Adding info for pnp:00:0c
PM: Adding info for pnp:00:0c
pnp 00:0c: Plug and Play ACPI device, IDs PNPb006 (active)
pnp 00:0c: Plug and Play ACPI device, IDs PNPb006 (active)
pnp 00:0d: [io  0x0201]
pnp 00:0d: [io  0x0201]
device: '00:0d': device_add
device: '00:0d': device_add
bus: 'pnp': add device 00:0d
bus: 'pnp': add device 00:0d
PM: Adding info for pnp:00:0d
PM: Adding info for pnp:00:0d
pnp 00:0d: Plug and Play ACPI device, IDs PNPb02f (active)
pnp 00:0d: Plug and Play ACPI device, IDs PNPb02f (active)
pnp 00:0e: [mem 0xe0000000-0xefffffff]
pnp 00:0e: [mem 0xe0000000-0xefffffff]
device: '00:0e': device_add
device: '00:0e': device_add
bus: 'pnp': add device 00:0e
bus: 'pnp': add device 00:0e
PM: Adding info for pnp:00:0e
PM: Adding info for pnp:00:0e
bus: 'pnp': driver_probe_device: matched device 00:0e with driver system
bus: 'pnp': driver_probe_device: matched device 00:0e with driver system
bus: 'pnp': really_probe: probing driver system with device 00:0e
bus: 'pnp': really_probe: probing driver system with device 00:0e
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
driver: '00:0e': driver_bound: bound to device 'system'
driver: '00:0e': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:0e to driver system
bus: 'pnp': really_probe: bound device 00:0e to driver system
system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0f: [mem 0x000f0000-0x000f3fff]
pnp 00:0f: [mem 0x000f0000-0x000f3fff]
pnp 00:0f: [mem 0x000f4000-0x000f7fff]
pnp 00:0f: [mem 0x000f4000-0x000f7fff]
pnp 00:0f: [mem 0x000f8000-0x000fbfff]
pnp 00:0f: [mem 0x000f8000-0x000fbfff]
pnp 00:0f: [mem 0x000fc000-0x000fffff]
pnp 00:0f: [mem 0x000fc000-0x000fffff]
pnp 00:0f: [mem 0x3fff0000-0x3fffffff]
pnp 00:0f: [mem 0x3fff0000-0x3fffffff]
pnp 00:0f: [mem 0xffff0000-0xffffffff]
pnp 00:0f: [mem 0xffff0000-0xffffffff]
pnp 00:0f: [mem 0x00000000-0x0009ffff]
pnp 00:0f: [mem 0x00000000-0x0009ffff]
pnp 00:0f: [mem 0x00100000-0x3ffeffff]
pnp 00:0f: [mem 0x00100000-0x3ffeffff]
pnp 00:0f: [mem 0xfec00000-0xfec00fff]
pnp 00:0f: [mem 0xfec00000-0xfec00fff]
pnp 00:0f: [mem 0xfee00000-0xfeefffff]
pnp 00:0f: [mem 0xfee00000-0xfeefffff]
pnp 00:0f: [mem 0xfefff000-0xfeffffff]
pnp 00:0f: [mem 0xfefff000-0xfeffffff]
pnp 00:0f: [mem 0xfff80000-0xfff80fff]
pnp 00:0f: [mem 0xfff80000-0xfff80fff]
pnp 00:0f: [mem 0xfff90000-0xfffbffff]
pnp 00:0f: [mem 0xfff90000-0xfffbffff]
pnp 00:0f: [mem 0xfffed000-0xfffeffff]
pnp 00:0f: [mem 0xfffed000-0xfffeffff]
device: '00:0f': device_add
device: '00:0f': device_add
bus: 'pnp': add device 00:0f
bus: 'pnp': add device 00:0f
PM: Adding info for pnp:00:0f
PM: Adding info for pnp:00:0f
bus: 'pnp': driver_probe_device: matched device 00:0f with driver system
bus: 'pnp': driver_probe_device: matched device 00:0f with driver system
bus: 'pnp': really_probe: probing driver system with device 00:0f
bus: 'pnp': really_probe: probing driver system with device 00:0f
system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
driver: '00:0f': driver_bound: bound to device 'system'
driver: '00:0f': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:0f to driver system
bus: 'pnp': really_probe: bound device 00:0f to driver system
system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 16 devices
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x88 returned 0 after 796925 usecs
initcall pnpacpi_init+0x0/0x88 returned 0 after 796925 usecs
calling  chr_dev_init+0x0/0xc3 @ 1
calling  chr_dev_init+0x0/0xc3 @ 1
device class 'mem': registering
device class 'mem': registering
device: 'mem': device_add
device: 'mem': device_add
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:mem
device: 'null': device_add
device: 'null': device_add
PM: Adding info for No Bus:null
PM: Adding info for No Bus:null
device: 'port': device_add
device: 'port': device_add
PM: Adding info for No Bus:port
PM: Adding info for No Bus:port
device: 'zero': device_add
device: 'zero': device_add
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:zero
device: 'full': device_add
device: 'full': device_add
PM: Adding info for No Bus:full
PM: Adding info for No Bus:full
device: 'random': device_add
device: 'random': device_add
PM: Adding info for No Bus:random
PM: Adding info for No Bus:random
device: 'urandom': device_add
device: 'urandom': device_add
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:urandom
device: 'kmsg': device_add
device: 'kmsg': device_add
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:kmsg
device: 'tty': device_add
device: 'tty': device_add
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:tty
device: 'console': device_add
device: 'console': device_add
PM: Adding info for No Bus:console
PM: Adding info for No Bus:console
device: 'tty0': device_add
device: 'tty0': device_add
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:tty0
device class 'vc': registering
device class 'vc': registering
device: 'vcs': device_add
device: 'vcs': device_add
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcs
device: 'vcsa': device_add
device: 'vcsa': device_add
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:vcsa
device: 'vcs1': device_add
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcsa1
device: 'tty1': device_add
device: 'tty1': device_add
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty1
device: 'tty2': device_add
device: 'tty2': device_add
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty2
device: 'tty3': device_add
device: 'tty3': device_add
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty3
device: 'tty4': device_add
device: 'tty4': device_add
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty4
device: 'tty5': device_add
device: 'tty5': device_add
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty5
device: 'tty6': device_add
device: 'tty6': device_add
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty6
device: 'tty7': device_add
device: 'tty7': device_add
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty7
device: 'tty8': device_add
device: 'tty8': device_add
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty8
device: 'tty9': device_add
device: 'tty9': device_add
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty9
device: 'tty10': device_add
device: 'tty10': device_add
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty10
device: 'tty11': device_add
device: 'tty11': device_add
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty11
device: 'tty12': device_add
device: 'tty12': device_add
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty12
device: 'tty13': device_add
device: 'tty13': device_add
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty13
device: 'tty14': device_add
device: 'tty14': device_add
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty14
device: 'tty15': device_add
device: 'tty15': device_add
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty15
device: 'tty16': device_add
device: 'tty16': device_add
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty16
device: 'tty17': device_add
device: 'tty17': device_add
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty17
device: 'tty18': device_add
device: 'tty18': device_add
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty18
device: 'tty19': device_add
device: 'tty19': device_add
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty19
device: 'tty20': device_add
device: 'tty20': device_add
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty20
device: 'tty21': device_add
device: 'tty21': device_add
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty21
device: 'tty22': device_add
device: 'tty22': device_add
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty22
device: 'tty23': device_add
device: 'tty23': device_add
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty23
device: 'tty24': device_add
device: 'tty24': device_add
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty24
device: 'tty25': device_add
device: 'tty25': device_add
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty25
device: 'tty26': device_add
device: 'tty26': device_add
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty26
device: 'tty27': device_add
device: 'tty27': device_add
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty27
device: 'tty28': device_add
device: 'tty28': device_add
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty28
device: 'tty29': device_add
device: 'tty29': device_add
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty29
device: 'tty30': device_add
device: 'tty30': device_add
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty30
device: 'tty31': device_add
device: 'tty31': device_add
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty31
device: 'tty32': device_add
device: 'tty32': device_add
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty32
device: 'tty33': device_add
device: 'tty33': device_add
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty33
device: 'tty34': device_add
device: 'tty34': device_add
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty34
device: 'tty35': device_add
device: 'tty35': device_add
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty35
device: 'tty36': device_add
device: 'tty36': device_add
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty36
device: 'tty37': device_add
device: 'tty37': device_add
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty37
device: 'tty38': device_add
device: 'tty38': device_add
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty38
device: 'tty39': device_add
device: 'tty39': device_add
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty39
device: 'tty40': device_add
device: 'tty40': device_add
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty40
device: 'tty41': device_add
device: 'tty41': device_add
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty41
device: 'tty42': device_add
device: 'tty42': device_add
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty42
device: 'tty43': device_add
device: 'tty43': device_add
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty43
device: 'tty44': device_add
device: 'tty44': device_add
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty44
device: 'tty45': device_add
device: 'tty45': device_add
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty45
device: 'tty46': device_add
device: 'tty46': device_add
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty46
device: 'tty47': device_add
device: 'tty47': device_add
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty47
device: 'tty48': device_add
device: 'tty48': device_add
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty48
device: 'tty49': device_add
device: 'tty49': device_add
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty49
device: 'tty50': device_add
device: 'tty50': device_add
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty50
device: 'tty51': device_add
device: 'tty51': device_add
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty51
device: 'tty52': device_add
device: 'tty52': device_add
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty52
device: 'tty53': device_add
device: 'tty53': device_add
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty53
device: 'tty54': device_add
device: 'tty54': device_add
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty54
device: 'tty55': device_add
device: 'tty55': device_add
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty55
device: 'tty56': device_add
device: 'tty56': device_add
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty56
device: 'tty57': device_add
device: 'tty57': device_add
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty57
device: 'tty58': device_add
device: 'tty58': device_add
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty58
device: 'tty59': device_add
device: 'tty59': device_add
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty59
device: 'tty60': device_add
device: 'tty60': device_add
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty60
device: 'tty61': device_add
device: 'tty61': device_add
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty61
device: 'tty62': device_add
device: 'tty62': device_add
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty62
device: 'tty63': device_add
device: 'tty63': device_add
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:tty63
initcall chr_dev_init+0x0/0xc3 returned 0 after 644571 usecs
initcall chr_dev_init+0x0/0xc3 returned 0 after 644571 usecs
calling  firmware_class_init+0x0/0x14 @ 1
calling  firmware_class_init+0x0/0x14 @ 1
device class 'firmware': registering
device class 'firmware': registering
initcall firmware_class_init+0x0/0x14 returned 0 after 3906 usecs
initcall firmware_class_init+0x0/0x14 returned 0 after 3906 usecs
calling  init_acpi_pm_clocksource+0x0/0x197 @ 1
calling  init_acpi_pm_clocksource+0x0/0x197 @ 1
Switching to clocksource acpi_pm
Switching to clocksource acpi_pm
initcall init_acpi_pm_clocksource+0x0/0x197 returned 0 after 35169 usecs
initcall init_acpi_pm_clocksource+0x0/0x197 returned 0 after 35169 usecs
calling  pcibios_assign_resources+0x0/0xc4 @ 1
calling  pcibios_assign_resources+0x0/0xc4 @ 1
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
pci 0000:00:09.0: PCI bridge to [bus 05]
pci 0000:00:09.0: PCI bridge to [bus 05]
pci 0000:00:0b.0: PCI bridge to [bus 04]
pci 0000:00:0b.0: PCI bridge to [bus 04]
pci 0000:00:0c.0: PCI bridge to [bus 03]
pci 0000:00:0c.0: PCI bridge to [bus 03]
pci 0000:00:0d.0: PCI bridge to [bus 02]
pci 0000:00:0d.0: PCI bridge to [bus 02]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 01]
pci 0000:00:0e.0: PCI bridge to [bus 01]
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:00: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:05: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
initcall pcibios_assign_resources+0x0/0xc4 returned 0 after 219456 usecs
initcall pcibios_assign_resources+0x0/0xc4 returned 0 after 219456 usecs
calling  sysctl_core_init+0x0/0x23 @ 1
calling  sysctl_core_init+0x0/0x23 @ 1
initcall sysctl_core_init+0x0/0x23 returned 0 after 55 usecs
initcall sysctl_core_init+0x0/0x23 returned 0 after 55 usecs
calling  inet_init+0x0/0x275 @ 1
calling  inet_init+0x0/0x275 @ 1
NET: Registered protocol family 2
NET: Registered protocol family 2
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP: Hash tables configured (established 131072 bind 65536)
TCP: reno registered
TCP: reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
initcall inet_init+0x0/0x275 returned 0 after 69882 usecs
initcall inet_init+0x0/0x275 returned 0 after 69882 usecs
calling  af_unix_init+0x0/0x4d @ 1
calling  af_unix_init+0x0/0x4d @ 1
NET: Registered protocol family 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x4d returned 0 after 6000 usecs
initcall af_unix_init+0x0/0x4d returned 0 after 6000 usecs
calling  pci_apply_final_quirks+0x0/0x10f @ 1
calling  pci_apply_final_quirks+0x0/0x10f @ 1
pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:00.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:00.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 35 usecs for 0000:00:00.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 35 usecs for 0000:00:00.0
pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:01.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:01.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 3 usecs for 0000:00:01.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 3 usecs for 0000:00:01.0
pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:01.1
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:01.1
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 6 usecs for 0000:00:01.1
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 6 usecs for 0000:00:01.1
pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:02.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:02.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:02.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:02.0
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x653
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x653
calling  quirk_usb_early_handoff+0x0/0x653 @ 1 for 0000:00:02.0
calling  quirk_usb_early_handoff+0x0/0x653 @ 1 for 0000:00:02.0
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
IOAPIC[0]: Set routing entry (2-23 -> 0x51 -> IRQ 23 Mode:1 Active:1 Dest:3)
IOAPIC[0]: Set routing entry (2-23 -> 0x51 -> IRQ 23 Mode:1 Active:1 Dest:3)
pci fixup quirk_usb_early_handoff+0x0/0x653 returned after 104548 usecs for 0000:00:02.0
pci fixup quirk_usb_early_handoff+0x0/0x653 returned after 104548 usecs for 0000:00:02.0
pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:02.1
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:02.1
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 7 usecs for 0000:00:02.1
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 7 usecs for 0000:00:02.1
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x653
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x653
calling  quirk_usb_early_handoff+0x0/0x653 @ 1 for 0000:00:02.1
calling  quirk_usb_early_handoff+0x0/0x653 @ 1 for 0000:00:02.1
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
IOAPIC[0]: Set routing entry (2-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:3)
IOAPIC[0]: Set routing entry (2-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:3)
pci fixup quirk_usb_early_handoff+0x0/0x653 returned after 26713 usecs for 0000:00:02.1
pci fixup quirk_usb_early_handoff+0x0/0x653 returned after 26713 usecs for 0000:00:02.1
pci 0000:00:04.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:04.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:04.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:04.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:04.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:04.0
pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:06.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:06.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:06.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:06.0
pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:09.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:09.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 2 usecs for 0000:00:09.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 2 usecs for 0000:00:09.0
pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0a.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0a.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:0a.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 5 usecs for 0000:00:0a.0
pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0b.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0b.0
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8142 usecs for 0000:00:0b.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8142 usecs for 0000:00:0b.0
pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0b.0
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0b.0
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16452 usecs for 0000:00:0b.0
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16452 usecs for 0000:00:0b.0
pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0b.0
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0b.0
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:0b.0: Linking AER extended capability
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0b.0
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0b.0
pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0c.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0c.0
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8143 usecs for 0000:00:0c.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8143 usecs for 0000:00:0c.0
pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0c.0
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0c.0
pci 0000:00:0c.0: Found disabled HT MSI Mapping
pci 0000:00:0c.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16453 usecs for 0000:00:0c.0
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16453 usecs for 0000:00:0c.0
pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0c.0
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0c.0
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:0c.0: Linking AER extended capability
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0c.0
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0c.0
pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0d.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0d.0
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8140 usecs for 0000:00:0d.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8140 usecs for 0000:00:0d.0
pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0d.0
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0d.0
pci 0000:00:0d.0: Found disabled HT MSI Mapping
pci 0000:00:0d.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16453 usecs for 0000:00:0d.0
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16453 usecs for 0000:00:0d.0
pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0d.0
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0d.0
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:0d.0: Linking AER extended capability
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0d.0
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0d.0
pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x10
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0e.0
calling  nv_msi_ht_cap_quirk_leaf+0x0/0x10 @ 1 for 0000:00:0e.0
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8142 usecs for 0000:00:0e.0
pci fixup nv_msi_ht_cap_quirk_leaf+0x0/0x10 returned after 8142 usecs for 0000:00:0e.0
pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x80
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0e.0
calling  quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 @ 1 for 0000:00:0e.0
pci 0000:00:0e.0: Found disabled HT MSI Mapping
pci 0000:00:0e.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16452 usecs for 0000:00:0e.0
pci fixup quirk_nvidia_ck804_msi_ht_cap+0x0/0x80 returned after 16452 usecs for 0000:00:0e.0
pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0e.0
calling  quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 @ 1 for 0000:00:0e.0
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:00:0e.0: Linking AER extended capability
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0e.0
pci fixup quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x60 returned after 8649 usecs for 0000:00:0e.0
pci 0000:01:00.0: calling pci_fixup_video+0x0/0x9d
pci 0000:01:00.0: calling pci_fixup_video+0x0/0x9d
calling  pci_fixup_video+0x0/0x9d @ 1 for 0000:01:00.0
calling  pci_fixup_video+0x0/0x9d @ 1 for 0000:01:00.0
pci 0000:01:00.0: Boot video device
pci 0000:01:00.0: Boot video device
pci fixup pci_fixup_video+0x0/0x9d returned after 6279 usecs for 0000:01:00.0
pci fixup pci_fixup_video+0x0/0x9d returned after 6279 usecs for 0000:01:00.0
PCI: CLS 32 bytes, default 64
PCI: CLS 32 bytes, default 64
initcall pci_apply_final_quirks+0x0/0x10f returned 0 after 1170905 usecs
initcall pci_apply_final_quirks+0x0/0x10f returned 0 after 1170905 usecs
calling  populate_rootfs+0x0/0x8e @ 1
calling  populate_rootfs+0x0/0x8e @ 1
initcall populate_rootfs+0x0/0x8e returned 0 after 761 usecs
initcall populate_rootfs+0x0/0x8e returned 0 after 761 usecs
calling  pci_iommu_init+0x0/0x48 @ 1
calling  pci_iommu_init+0x0/0x48 @ 1
DMA-API: preallocated 32768 debug entries
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
DMA-API: debugging enabled by kernel config
initcall pci_iommu_init+0x0/0x48 returned 0 after 193137 usecs
initcall pci_iommu_init+0x0/0x48 returned 0 after 193137 usecs
calling  i8259A_init_ops+0x0/0x20 @ 1
calling  i8259A_init_ops+0x0/0x20 @ 1
initcall i8259A_init_ops+0x0/0x20 returned 0 after 3 usecs
initcall i8259A_init_ops+0x0/0x20 returned 0 after 3 usecs
calling  sbf_init+0x0/0xee @ 1
calling  sbf_init+0x0/0xee @ 1
initcall sbf_init+0x0/0xee returned 0 after 2 usecs
initcall sbf_init+0x0/0xee returned 0 after 2 usecs
calling  init_tsc_clocksource+0x0/0x79 @ 1
calling  init_tsc_clocksource+0x0/0x79 @ 1
initcall init_tsc_clocksource+0x0/0x79 returned 0 after 12 usecs
initcall init_tsc_clocksource+0x0/0x79 returned 0 after 12 usecs
calling  add_rtc_cmos+0x0/0x8f @ 1
calling  add_rtc_cmos+0x0/0x8f @ 1
initcall add_rtc_cmos+0x0/0x8f returned 0 after 5 usecs
initcall add_rtc_cmos+0x0/0x8f returned 0 after 5 usecs
calling  i8237A_init_ops+0x0/0x11 @ 1
calling  i8237A_init_ops+0x0/0x11 @ 1
initcall i8237A_init_ops+0x0/0x11 returned 0 after 19 usecs
initcall i8237A_init_ops+0x0/0x11 returned 0 after 19 usecs
calling  cache_sysfs_init+0x0/0x4b @ 1
calling  cache_sysfs_init+0x0/0x4b @ 1
initcall cache_sysfs_init+0x0/0x4b returned 0 after 607 usecs
initcall cache_sysfs_init+0x0/0x4b returned 0 after 607 usecs
calling  intel_uncore_init+0x0/0x2cb @ 1
calling  intel_uncore_init+0x0/0x2cb @ 1
initcall intel_uncore_init+0x0/0x2cb returned -19 after 2 usecs
initcall intel_uncore_init+0x0/0x2cb returned -19 after 2 usecs
calling  thermal_throttle_init_device+0x0/0x77 @ 1
calling  thermal_throttle_init_device+0x0/0x77 @ 1
initcall thermal_throttle_init_device+0x0/0x77 returned 0 after 1 usecs
initcall thermal_throttle_init_device+0x0/0x77 returned 0 after 1 usecs
calling  amd_ibs_init+0x0/0x271 @ 1
calling  amd_ibs_init+0x0/0x271 @ 1
initcall amd_ibs_init+0x0/0x271 returned -19 after 1 usecs
initcall amd_ibs_init+0x0/0x271 returned -19 after 1 usecs
calling  ioapic_init_ops+0x0/0x11 @ 1
calling  ioapic_init_ops+0x0/0x11 @ 1
initcall ioapic_init_ops+0x0/0x11 returned 0 after 2 usecs
initcall ioapic_init_ops+0x0/0x11 returned 0 after 2 usecs
calling  add_pcspkr+0x0/0x5b @ 1
calling  add_pcspkr+0x0/0x5b @ 1
Registering platform device 'pcspkr'. Parent at platform
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
bus: 'platform': add device pcspkr
PM: Adding info for platform:pcspkr
PM: Adding info for platform:pcspkr
initcall add_pcspkr+0x0/0x5b returned 0 after 27371 usecs
initcall add_pcspkr+0x0/0x5b returned 0 after 27371 usecs
calling  start_pageattr_test+0x0/0x50 @ 1
calling  start_pageattr_test+0x0/0x50 @ 1
initcall start_pageattr_test+0x0/0x50 returned 0 after 134 usecs
initcall start_pageattr_test+0x0/0x50 returned 0 after 134 usecs
calling  alix_init+0x0/0xf6 @ 1
calling  alix_init+0x0/0xf6 @ 1
initcall alix_init+0x0/0xf6 returned 0 after 2 usecs
initcall alix_init+0x0/0xf6 returned 0 after 2 usecs
calling  net5501_init+0x0/0x104 @ 1
calling  net5501_init+0x0/0x104 @ 1
initcall net5501_init+0x0/0x104 returned 0 after 2 usecs
initcall net5501_init+0x0/0x104 returned 0 after 2 usecs
calling  mrst_device_create+0x0/0x4c @ 1
calling  mrst_device_create+0x0/0x4c @ 1
initcall mrst_device_create+0x0/0x4c returned -19 after 1 usecs
initcall mrst_device_create+0x0/0x4c returned -19 after 1 usecs
calling  proc_execdomains_init+0x0/0x27 @ 1
calling  proc_execdomains_init+0x0/0x27 @ 1
initcall proc_execdomains_init+0x0/0x27 returned 0 after 27 usecs
initcall proc_execdomains_init+0x0/0x27 returned 0 after 27 usecs
calling  ioresources_init+0x0/0x44 @ 1
calling  ioresources_init+0x0/0x44 @ 1
initcall ioresources_init+0x0/0x44 returned 0 after 42 usecs
initcall ioresources_init+0x0/0x44 returned 0 after 42 usecs
calling  uid_cache_init+0x0/0x81 @ 1
calling  uid_cache_init+0x0/0x81 @ 1
initcall uid_cache_init+0x0/0x81 returned 0 after 66 usecs
initcall uid_cache_init+0x0/0x81 returned 0 after 66 usecs
calling  init_posix_timers+0x0/0x1e0 @ 1
calling  init_posix_timers+0x0/0x1e0 @ 1
initcall init_posix_timers+0x0/0x1e0 returned 0 after 40 usecs
initcall init_posix_timers+0x0/0x1e0 returned 0 after 40 usecs
calling  init_posix_cpu_timers+0x0/0x9b @ 1
calling  init_posix_cpu_timers+0x0/0x9b @ 1
initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 2 usecs
initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 2 usecs
calling  proc_schedstat_init+0x0/0x27 @ 1
calling  proc_schedstat_init+0x0/0x27 @ 1
initcall proc_schedstat_init+0x0/0x27 returned 0 after 22 usecs
initcall proc_schedstat_init+0x0/0x27 returned 0 after 22 usecs
calling  init_sched_debug_procfs+0x0/0x30 @ 1
calling  init_sched_debug_procfs+0x0/0x30 @ 1
initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 22 usecs
initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 22 usecs
calling  snapshot_device_init+0x0/0xf @ 1
calling  snapshot_device_init+0x0/0xf @ 1
device: 'snapshot': device_add
device: 'snapshot': device_add
PM: Adding info for No Bus:snapshot
PM: Adding info for No Bus:snapshot
initcall snapshot_device_init+0x0/0xf returned 0 after 11870 usecs
initcall snapshot_device_init+0x0/0xf returned 0 after 11870 usecs
calling  create_proc_profile+0x0/0x1d0 @ 1
calling  create_proc_profile+0x0/0x1d0 @ 1
initcall create_proc_profile+0x0/0x1d0 returned 0 after 2 usecs
initcall create_proc_profile+0x0/0x1d0 returned 0 after 2 usecs
calling  timekeeping_init_ops+0x0/0x11 @ 1
calling  timekeeping_init_ops+0x0/0x11 @ 1
initcall timekeeping_init_ops+0x0/0x11 returned 0 after 3 usecs
initcall timekeeping_init_ops+0x0/0x11 returned 0 after 3 usecs
calling  init_clocksource_sysfs+0x0/0x45 @ 1
calling  init_clocksource_sysfs+0x0/0x45 @ 1
bus: 'clocksource': registered
bus: 'clocksource': registered
device: 'clocksource': device_add
device: 'clocksource': device_add
PM: Adding info for No Bus:clocksource
PM: Adding info for No Bus:clocksource
device: 'clocksource0': device_add
device: 'clocksource0': device_add
bus: 'clocksource': add device clocksource0
bus: 'clocksource': add device clocksource0
PM: Adding info for clocksource:clocksource0
PM: Adding info for clocksource:clocksource0
initcall init_clocksource_sysfs+0x0/0x45 returned 0 after 39789 usecs
initcall init_clocksource_sysfs+0x0/0x45 returned 0 after 39789 usecs
calling  init_timer_list_procfs+0x0/0x30 @ 1
calling  init_timer_list_procfs+0x0/0x30 @ 1
initcall init_timer_list_procfs+0x0/0x30 returned 0 after 22 usecs
initcall init_timer_list_procfs+0x0/0x30 returned 0 after 22 usecs
calling  alarmtimer_init+0x0/0x14d @ 1
calling  alarmtimer_init+0x0/0x14d @ 1
bus: 'platform': add driver alarmtimer
bus: 'platform': add driver alarmtimer
Registering platform device 'alarmtimer'. Parent at platform
Registering platform device 'alarmtimer'. Parent at platform
device: 'alarmtimer': device_add
device: 'alarmtimer': device_add
bus: 'platform': add device alarmtimer
bus: 'platform': add device alarmtimer
PM: Adding info for platform:alarmtimer
PM: Adding info for platform:alarmtimer
bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
initcall alarmtimer_init+0x0/0x14d returned 0 after 89719 usecs
initcall alarmtimer_init+0x0/0x14d returned 0 after 89719 usecs
calling  init_tstats_procfs+0x0/0x30 @ 1
calling  init_tstats_procfs+0x0/0x30 @ 1
initcall init_tstats_procfs+0x0/0x30 returned 0 after 19 usecs
initcall init_tstats_procfs+0x0/0x30 returned 0 after 19 usecs
calling  lockdep_proc_init+0x0/0x6a @ 1
calling  lockdep_proc_init+0x0/0x6a @ 1
initcall lockdep_proc_init+0x0/0x6a returned 0 after 65 usecs
initcall lockdep_proc_init+0x0/0x6a returned 0 after 65 usecs
calling  futex_init+0x0/0x61 @ 1
calling  futex_init+0x0/0x61 @ 1
initcall futex_init+0x0/0x61 returned 0 after 27 usecs
initcall futex_init+0x0/0x61 returned 0 after 27 usecs
calling  proc_dma_init+0x0/0x27 @ 1
calling  proc_dma_init+0x0/0x27 @ 1
initcall proc_dma_init+0x0/0x27 returned 0 after 22 usecs
initcall proc_dma_init+0x0/0x27 returned 0 after 22 usecs
calling  proc_modules_init+0x0/0x27 @ 1
calling  proc_modules_init+0x0/0x27 @ 1
initcall proc_modules_init+0x0/0x27 returned 0 after 22 usecs
initcall proc_modules_init+0x0/0x27 returned 0 after 22 usecs
calling  kallsyms_init+0x0/0x2a @ 1
calling  kallsyms_init+0x0/0x2a @ 1
initcall kallsyms_init+0x0/0x2a returned 0 after 21 usecs
initcall kallsyms_init+0x0/0x2a returned 0 after 21 usecs
calling  pid_namespaces_init+0x0/0x32 @ 1
calling  pid_namespaces_init+0x0/0x32 @ 1
initcall pid_namespaces_init+0x0/0x32 returned 0 after 32 usecs
initcall pid_namespaces_init+0x0/0x32 returned 0 after 32 usecs
calling  init_kprobes+0x0/0x13a @ 1
calling  init_kprobes+0x0/0x13a @ 1
initcall init_kprobes+0x0/0x13a returned 0 after 27697 usecs
initcall init_kprobes+0x0/0x13a returned 0 after 27697 usecs
calling  irq_pm_init_ops+0x0/0x11 @ 1
calling  irq_pm_init_ops+0x0/0x11 @ 1
initcall irq_pm_init_ops+0x0/0x11 returned 0 after 3 usecs
initcall irq_pm_init_ops+0x0/0x11 returned 0 after 3 usecs
calling  rcutree_trace_init+0x0/0x15b @ 1
calling  rcutree_trace_init+0x0/0x15b @ 1
initcall rcutree_trace_init+0x0/0x15b returned 0 after 175 usecs
initcall rcutree_trace_init+0x0/0x15b returned 0 after 175 usecs
calling  utsname_sysctl_init+0x0/0x11 @ 1
calling  utsname_sysctl_init+0x0/0x11 @ 1
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 38 usecs
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 38 usecs
calling  init_lstats_procfs+0x0/0x2a @ 1
calling  init_lstats_procfs+0x0/0x2a @ 1
initcall init_lstats_procfs+0x0/0x2a returned 0 after 29 usecs
initcall init_lstats_procfs+0x0/0x2a returned 0 after 29 usecs
calling  perf_event_sysfs_init+0x0/0x96 @ 1
calling  perf_event_sysfs_init+0x0/0x96 @ 1
bus: 'event_source': registered
bus: 'event_source': registered
device: 'cpu': device_add
device: 'cpu': device_add
bus: 'event_source': add device cpu
bus: 'event_source': add device cpu
PM: Adding info for event_source:cpu
PM: Adding info for event_source:cpu
device: 'breakpoint': device_add
device: 'breakpoint': device_add
bus: 'event_source': add device breakpoint
bus: 'event_source': add device breakpoint
PM: Adding info for event_source:breakpoint
PM: Adding info for event_source:breakpoint
device: 'software': device_add
device: 'software': device_add
bus: 'event_source': add device software
bus: 'event_source': add device software
PM: Adding info for event_source:software
PM: Adding info for event_source:software
initcall perf_event_sysfs_init+0x0/0x96 returned 0 after 64246 usecs
initcall perf_event_sysfs_init+0x0/0x96 returned 0 after 64246 usecs
calling  init_per_zone_wmark_min+0x0/0x79 @ 1
calling  init_per_zone_wmark_min+0x0/0x79 @ 1
initcall init_per_zone_wmark_min+0x0/0x79 returned 0 after 99 usecs
initcall init_per_zone_wmark_min+0x0/0x79 returned 0 after 99 usecs
calling  kswapd_init+0x0/0x1d @ 1
calling  kswapd_init+0x0/0x1d @ 1
initcall kswapd_init+0x0/0x1d returned 0 after 121 usecs
initcall kswapd_init+0x0/0x1d returned 0 after 121 usecs
calling  extfrag_debug_init+0x0/0x7d @ 1
calling  extfrag_debug_init+0x0/0x7d @ 1
initcall extfrag_debug_init+0x0/0x7d returned 0 after 71 usecs
initcall extfrag_debug_init+0x0/0x7d returned 0 after 71 usecs
calling  setup_vmstat+0x0/0xc0 @ 1
calling  setup_vmstat+0x0/0xc0 @ 1
initcall setup_vmstat+0x0/0xc0 returned 0 after 100 usecs
initcall setup_vmstat+0x0/0xc0 returned 0 after 100 usecs
calling  mm_sysfs_init+0x0/0x22 @ 1
calling  mm_sysfs_init+0x0/0x22 @ 1
initcall mm_sysfs_init+0x0/0x22 returned 0 after 34 usecs
initcall mm_sysfs_init+0x0/0x22 returned 0 after 34 usecs
calling  proc_vmalloc_init+0x0/0x2a @ 1
calling  proc_vmalloc_init+0x0/0x2a @ 1
initcall proc_vmalloc_init+0x0/0x2a returned 0 after 24 usecs
initcall proc_vmalloc_init+0x0/0x2a returned 0 after 24 usecs
calling  init_emergency_pool+0x0/0x54 @ 1
calling  init_emergency_pool+0x0/0x54 @ 1
bounce pool size: 64 pages
bounce pool size: 64 pages
initcall init_emergency_pool+0x0/0x54 returned 0 after 4755 usecs
initcall init_emergency_pool+0x0/0x54 returned 0 after 4755 usecs
calling  procswaps_init+0x0/0x27 @ 1
calling  procswaps_init+0x0/0x27 @ 1
initcall procswaps_init+0x0/0x27 returned 0 after 22 usecs
initcall procswaps_init+0x0/0x27 returned 0 after 22 usecs
calling  init_frontswap+0x0/0x84 @ 1
calling  init_frontswap+0x0/0x84 @ 1
initcall init_frontswap+0x0/0x84 returned 0 after 102 usecs
initcall init_frontswap+0x0/0x84 returned 0 after 102 usecs
calling  ksm_init+0x0/0x15b @ 1
calling  ksm_init+0x0/0x15b @ 1
initcall ksm_init+0x0/0x15b returned 0 after 341 usecs
initcall ksm_init+0x0/0x15b returned 0 after 341 usecs
calling  slab_proc_init+0x0/0x2a @ 1
calling  slab_proc_init+0x0/0x2a @ 1
initcall slab_proc_init+0x0/0x2a returned 0 after 31 usecs
initcall slab_proc_init+0x0/0x2a returned 0 after 31 usecs
calling  slab_sysfs_init+0x0/0xdf @ 1
calling  slab_sysfs_init+0x0/0xdf @ 1
initcall slab_sysfs_init+0x0/0xdf returned 0 after 69937 usecs
initcall slab_sysfs_init+0x0/0xdf returned 0 after 69937 usecs
calling  hugepage_init+0x0/0x162 @ 1
calling  hugepage_init+0x0/0x162 @ 1
initcall hugepage_init+0x0/0x162 returned 0 after 1228 usecs
initcall hugepage_init+0x0/0x162 returned 0 after 1228 usecs
calling  init_cleancache+0x0/0x84 @ 1
calling  init_cleancache+0x0/0x84 @ 1
initcall init_cleancache+0x0/0x84 returned 0 after 118 usecs
initcall init_cleancache+0x0/0x84 returned 0 after 118 usecs
calling  fcntl_init+0x0/0x2f @ 1
calling  fcntl_init+0x0/0x2f @ 1
initcall fcntl_init+0x0/0x2f returned 0 after 813 usecs
initcall fcntl_init+0x0/0x2f returned 0 after 813 usecs
calling  proc_filesystems_init+0x0/0x27 @ 1
calling  proc_filesystems_init+0x0/0x27 @ 1
initcall proc_filesystems_init+0x0/0x27 returned 0 after 29 usecs
initcall proc_filesystems_init+0x0/0x27 returned 0 after 29 usecs
calling  dio_init+0x0/0x32 @ 1
calling  dio_init+0x0/0x32 @ 1
initcall dio_init+0x0/0x32 returned 0 after 686 usecs
initcall dio_init+0x0/0x32 returned 0 after 686 usecs
calling  fsnotify_mark_init+0x0/0x46 @ 1
calling  fsnotify_mark_init+0x0/0x46 @ 1
initcall fsnotify_mark_init+0x0/0x46 returned 0 after 141 usecs
initcall fsnotify_mark_init+0x0/0x46 returned 0 after 141 usecs
calling  dnotify_init+0x0/0x7c @ 1
calling  dnotify_init+0x0/0x7c @ 1
initcall dnotify_init+0x0/0x7c returned 0 after 1524 usecs
initcall dnotify_init+0x0/0x7c returned 0 after 1524 usecs
calling  fanotify_user_setup+0x0/0x5a @ 1
calling  fanotify_user_setup+0x0/0x5a @ 1
initcall fanotify_user_setup+0x0/0x5a returned 0 after 1403 usecs
initcall fanotify_user_setup+0x0/0x5a returned 0 after 1403 usecs
calling  aio_setup+0x0/0xb9 @ 1
calling  aio_setup+0x0/0xb9 @ 1
initcall aio_setup+0x0/0xb9 returned 0 after 1426 usecs
initcall aio_setup+0x0/0xb9 returned 0 after 1426 usecs
calling  proc_locks_init+0x0/0x27 @ 1
calling  proc_locks_init+0x0/0x27 @ 1
initcall proc_locks_init+0x0/0x27 returned 0 after 33 usecs
initcall proc_locks_init+0x0/0x27 returned 0 after 33 usecs
calling  init_mbcache+0x0/0x11 @ 1
calling  init_mbcache+0x0/0x11 @ 1
initcall init_mbcache+0x0/0x11 returned 0 after 3 usecs
initcall init_mbcache+0x0/0x11 returned 0 after 3 usecs
calling  dquot_init+0x0/0x10e @ 1
calling  dquot_init+0x0/0x10e @ 1
VFS: Disk quotas dquot_6.5.2
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x10e returned 0 after 15904 usecs
initcall dquot_init+0x0/0x10e returned 0 after 15904 usecs
calling  quota_init+0x0/0x22 @ 1
calling  quota_init+0x0/0x22 @ 1
initcall quota_init+0x0/0x22 returned 0 after 76 usecs
initcall quota_init+0x0/0x22 returned 0 after 76 usecs
calling  proc_cmdline_init+0x0/0x27 @ 1
calling  proc_cmdline_init+0x0/0x27 @ 1
initcall proc_cmdline_init+0x0/0x27 returned 0 after 26 usecs
initcall proc_cmdline_init+0x0/0x27 returned 0 after 26 usecs
calling  proc_consoles_init+0x0/0x27 @ 1
calling  proc_consoles_init+0x0/0x27 @ 1
initcall proc_consoles_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_consoles_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_cpuinfo_init+0x0/0x27 @ 1
calling  proc_cpuinfo_init+0x0/0x27 @ 1
initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_devices_init+0x0/0x27 @ 1
calling  proc_devices_init+0x0/0x27 @ 1
initcall proc_devices_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_devices_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_interrupts_init+0x0/0x27 @ 1
calling  proc_interrupts_init+0x0/0x27 @ 1
initcall proc_interrupts_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_interrupts_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_loadavg_init+0x0/0x27 @ 1
calling  proc_loadavg_init+0x0/0x27 @ 1
initcall proc_loadavg_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_loadavg_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_meminfo_init+0x0/0x27 @ 1
calling  proc_meminfo_init+0x0/0x27 @ 1
initcall proc_meminfo_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_meminfo_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_stat_init+0x0/0x27 @ 1
calling  proc_stat_init+0x0/0x27 @ 1
initcall proc_stat_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_stat_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_uptime_init+0x0/0x27 @ 1
calling  proc_uptime_init+0x0/0x27 @ 1
initcall proc_uptime_init+0x0/0x27 returned 0 after 23 usecs
initcall proc_uptime_init+0x0/0x27 returned 0 after 23 usecs
calling  proc_version_init+0x0/0x27 @ 1
calling  proc_version_init+0x0/0x27 @ 1
initcall proc_version_init+0x0/0x27 returned 0 after 34 usecs
initcall proc_version_init+0x0/0x27 returned 0 after 34 usecs
calling  proc_softirqs_init+0x0/0x27 @ 1
calling  proc_softirqs_init+0x0/0x27 @ 1
initcall proc_softirqs_init+0x0/0x27 returned 0 after 24 usecs
initcall proc_softirqs_init+0x0/0x27 returned 0 after 24 usecs
calling  proc_kcore_init+0x0/0xae @ 1
calling  proc_kcore_init+0x0/0xae @ 1
initcall proc_kcore_init+0x0/0xae returned 0 after 57 usecs
initcall proc_kcore_init+0x0/0xae returned 0 after 57 usecs
calling  proc_kmsg_init+0x0/0x2a @ 1
calling  proc_kmsg_init+0x0/0x2a @ 1
initcall proc_kmsg_init+0x0/0x2a returned 0 after 24 usecs
initcall proc_kmsg_init+0x0/0x2a returned 0 after 24 usecs
calling  proc_page_init+0x0/0x4a @ 1
calling  proc_page_init+0x0/0x4a @ 1
initcall proc_page_init+0x0/0x4a returned 0 after 49 usecs
initcall proc_page_init+0x0/0x4a returned 0 after 49 usecs
calling  init_devpts_fs+0x0/0x52 @ 1
calling  init_devpts_fs+0x0/0x52 @ 1
initcall init_devpts_fs+0x0/0x52 returned 0 after 285 usecs
initcall init_devpts_fs+0x0/0x52 returned 0 after 285 usecs
calling  init_ext3_fs+0x0/0x6c @ 1
calling  init_ext3_fs+0x0/0x6c @ 1
initcall init_ext3_fs+0x0/0x6c returned 0 after 1460 usecs
initcall init_ext3_fs+0x0/0x6c returned 0 after 1460 usecs
calling  journal_init+0x0/0xeb @ 1
calling  journal_init+0x0/0xeb @ 1
initcall journal_init+0x0/0xeb returned 0 after 3167 usecs
initcall journal_init+0x0/0xeb returned 0 after 3167 usecs
calling  init_ramfs_fs+0x0/0xf @ 1
calling  init_ramfs_fs+0x0/0xf @ 1
initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
calling  init_pstore_fs+0x0/0xf @ 1
calling  init_pstore_fs+0x0/0xf @ 1
initcall init_pstore_fs+0x0/0xf returned 0 after 2 usecs
initcall init_pstore_fs+0x0/0xf returned 0 after 2 usecs
calling  ipc_init+0x0/0x20 @ 1
calling  ipc_init+0x0/0x20 @ 1
msgmni has been set to 1731
msgmni has been set to 1731
initcall ipc_init+0x0/0x20 returned 0 after 4993 usecs
initcall ipc_init+0x0/0x20 returned 0 after 4993 usecs
calling  ipc_sysctl_init+0x0/0x11 @ 1
calling  ipc_sysctl_init+0x0/0x11 @ 1
initcall ipc_sysctl_init+0x0/0x11 returned 0 after 39 usecs
initcall ipc_sysctl_init+0x0/0x11 returned 0 after 39 usecs
calling  key_proc_init+0x0/0x37 @ 1
calling  key_proc_init+0x0/0x37 @ 1
initcall key_proc_init+0x0/0x37 returned 0 after 25 usecs
initcall key_proc_init+0x0/0x37 returned 0 after 25 usecs
calling  crypto_wq_init+0x0/0x41 @ 1
calling  crypto_wq_init+0x0/0x41 @ 1
initcall crypto_wq_init+0x0/0x41 returned 0 after 148 usecs
initcall crypto_wq_init+0x0/0x41 returned 0 after 148 usecs
calling  crypto_algapi_init+0x0/0xc @ 1
calling  crypto_algapi_init+0x0/0xc @ 1
initcall crypto_algapi_init+0x0/0xc returned 0 after 34 usecs
initcall crypto_algapi_init+0x0/0xc returned 0 after 34 usecs
calling  skcipher_module_init+0x0/0x2e @ 1
calling  skcipher_module_init+0x0/0x2e @ 1
initcall skcipher_module_init+0x0/0x2e returned 0 after 1 usecs
initcall skcipher_module_init+0x0/0x2e returned 0 after 1 usecs
calling  chainiv_module_init+0x0/0xf @ 1
calling  chainiv_module_init+0x0/0xf @ 1
initcall chainiv_module_init+0x0/0xf returned 0 after 57 usecs
initcall chainiv_module_init+0x0/0xf returned 0 after 57 usecs
calling  eseqiv_module_init+0x0/0xf @ 1
calling  eseqiv_module_init+0x0/0xf @ 1
initcall eseqiv_module_init+0x0/0xf returned 0 after 3 usecs
initcall eseqiv_module_init+0x0/0xf returned 0 after 3 usecs
calling  hmac_module_init+0x0/0xf @ 1
calling  hmac_module_init+0x0/0xf @ 1
initcall hmac_module_init+0x0/0xf returned 0 after 2 usecs
initcall hmac_module_init+0x0/0xf returned 0 after 2 usecs
calling  md5_mod_init+0x0/0xf @ 1
calling  md5_mod_init+0x0/0xf @ 1
initcall md5_mod_init+0x0/0xf returned 0 after 261 usecs
initcall md5_mod_init+0x0/0xf returned 0 after 261 usecs
calling  sha1_generic_mod_init+0x0/0xf @ 1
calling  sha1_generic_mod_init+0x0/0xf @ 1
initcall sha1_generic_mod_init+0x0/0xf returned 0 after 240 usecs
initcall sha1_generic_mod_init+0x0/0xf returned 0 after 240 usecs
calling  sha256_generic_mod_init+0x0/0x33 @ 1
calling  sha256_generic_mod_init+0x0/0x33 @ 1
initcall sha256_generic_mod_init+0x0/0x33 returned 0 after 290 usecs
initcall sha256_generic_mod_init+0x0/0x33 returned 0 after 290 usecs
calling  crypto_cbc_module_init+0x0/0xf @ 1
calling  crypto_cbc_module_init+0x0/0xf @ 1
initcall crypto_cbc_module_init+0x0/0xf returned 0 after 3 usecs
initcall crypto_cbc_module_init+0x0/0xf returned 0 after 3 usecs
calling  aes_init+0x0/0xf @ 1
calling  aes_init+0x0/0xf @ 1
initcall aes_init+0x0/0xf returned 0 after 132 usecs
initcall aes_init+0x0/0xf returned 0 after 132 usecs
calling  krng_mod_init+0x0/0xf @ 1
calling  krng_mod_init+0x0/0xf @ 1
initcall krng_mod_init+0x0/0xf returned 0 after 123 usecs
initcall krng_mod_init+0x0/0xf returned 0 after 123 usecs
calling  proc_genhd_init+0x0/0x44 @ 1
calling  proc_genhd_init+0x0/0x44 @ 1
initcall proc_genhd_init+0x0/0x44 returned 0 after 48 usecs
initcall proc_genhd_init+0x0/0x44 returned 0 after 48 usecs
calling  bsg_init+0x0/0x154 @ 1
calling  bsg_init+0x0/0x154 @ 1
device class 'bsg': registering
device class 'bsg': registering
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x154 returned 0 after 17988 usecs
initcall bsg_init+0x0/0x154 returned 0 after 17988 usecs
calling  noop_init+0x0/0xf @ 1
calling  noop_init+0x0/0xf @ 1
io scheduler noop registered (default)
io scheduler noop registered (default)
initcall noop_init+0x0/0xf returned 0 after 6787 usecs
initcall noop_init+0x0/0xf returned 0 after 6787 usecs
calling  list_sort_test+0x0/0x1d9 @ 1
calling  list_sort_test+0x0/0x1d9 @ 1
list_sort_test: start testing list_sort()
list_sort_test: start testing list_sort()
initcall list_sort_test+0x0/0x1d9 returned 0 after 13984 usecs
initcall list_sort_test+0x0/0x1d9 returned 0 after 13984 usecs
calling  btree_module_init+0x0/0x2f @ 1
calling  btree_module_init+0x0/0x2f @ 1
initcall btree_module_init+0x0/0x2f returned 0 after 619 usecs
initcall btree_module_init+0x0/0x2f returned 0 after 619 usecs
calling  debug_objects_init_debugfs+0x0/0x67 @ 1
calling  debug_objects_init_debugfs+0x0/0x67 @ 1
initcall debug_objects_init_debugfs+0x0/0x67 returned 0 after 59 usecs
initcall debug_objects_init_debugfs+0x0/0x67 returned 0 after 59 usecs
calling  percpu_counter_startup+0x0/0x16 @ 1
calling  percpu_counter_startup+0x0/0x16 @ 1
initcall percpu_counter_startup+0x0/0x16 returned 0 after 5 usecs
initcall percpu_counter_startup+0x0/0x16 returned 0 after 5 usecs
calling  lnw_gpio_init+0x0/0x3a @ 1
calling  lnw_gpio_init+0x0/0x3a @ 1
bus: 'pci': add driver langwell_gpio
bus: 'pci': add driver langwell_gpio
bus: 'platform': add driver wp_gpio
bus: 'platform': add driver wp_gpio
initcall lnw_gpio_init+0x0/0x3a returned 0 after 12848 usecs
initcall lnw_gpio_init+0x0/0x3a returned 0 after 12848 usecs
calling  ucb1400_gpio_driver_init+0x0/0xf @ 1
calling  ucb1400_gpio_driver_init+0x0/0xf @ 1
bus: 'platform': add driver ucb1400_gpio
bus: 'platform': add driver ucb1400_gpio
initcall ucb1400_gpio_driver_init+0x0/0xf returned 0 after 7215 usecs
initcall ucb1400_gpio_driver_init+0x0/0xf returned 0 after 7215 usecs
calling  pci_proc_init+0x0/0x64 @ 1
calling  pci_proc_init+0x0/0x64 @ 1
initcall pci_proc_init+0x0/0x64 returned 0 after 760 usecs
initcall pci_proc_init+0x0/0x64 returned 0 after 760 usecs
calling  acpi_reserve_resources+0x0/0xc8 @ 1
calling  acpi_reserve_resources+0x0/0xc8 @ 1
initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 43 usecs
initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 43 usecs
calling  irqrouter_init_ops+0x0/0x26 @ 1
calling  irqrouter_init_ops+0x0/0x26 @ 1
initcall irqrouter_init_ops+0x0/0x26 returned 0 after 3 usecs
initcall irqrouter_init_ops+0x0/0x26 returned 0 after 3 usecs
calling  acpi_hed_init+0x0/0x2d @ 1
calling  acpi_hed_init+0x0/0x2d @ 1
bus: 'acpi': add driver hardware_error_device
bus: 'acpi': add driver hardware_error_device
initcall acpi_hed_init+0x0/0x2d returned 0 after 8117 usecs
initcall acpi_hed_init+0x0/0x2d returned 0 after 8117 usecs
calling  erst_init+0x0/0x27a @ 1
calling  erst_init+0x0/0x27a @ 1
initcall erst_init+0x0/0x27a returned 0 after 2 usecs
initcall erst_init+0x0/0x27a returned 0 after 2 usecs
calling  ghes_init+0x0/0x16c @ 1
calling  ghes_init+0x0/0x16c @ 1
GHES: HEST is not enabled!
GHES: HEST is not enabled!
initcall ghes_init+0x0/0x16c returned -22 after 4756 usecs
initcall ghes_init+0x0/0x16c returned -22 after 4756 usecs
initcall ghes_init+0x0/0x16c returned with error code -22 
initcall ghes_init+0x0/0x16c returned with error code -22 
calling  lp872x_driver_init+0x0/0x11 @ 1
calling  lp872x_driver_init+0x0/0x11 @ 1
bus: 'i2c': add driver lp872x
bus: 'i2c': add driver lp872x
i2c-core: driver [lp872x] registered
i2c-core: driver [lp872x] registered
initcall lp872x_driver_init+0x0/0x11 returned 0 after 11716 usecs
initcall lp872x_driver_init+0x0/0x11 returned 0 after 11716 usecs
calling  pty_init+0x0/0x382 @ 1
calling  pty_init+0x0/0x382 @ 1
device: 'ptyp0': device_add
device: 'ptyp0': device_add
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp0
device: 'ptyp1': device_add
device: 'ptyp1': device_add
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp1
device: 'ptyp2': device_add
device: 'ptyp2': device_add
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp2
device: 'ptyp3': device_add
device: 'ptyp3': device_add
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp3
device: 'ptyp4': device_add
device: 'ptyp4': device_add
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp4
device: 'ptyp5': device_add
device: 'ptyp5': device_add
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp5
device: 'ptyp6': device_add
device: 'ptyp6': device_add
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp6
device: 'ptyp7': device_add
device: 'ptyp7': device_add
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp7
device: 'ptyp8': device_add
device: 'ptyp8': device_add
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp8
device: 'ptyp9': device_add
device: 'ptyp9': device_add
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptyp9
device: 'ptypa': device_add
device: 'ptypa': device_add
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypa
device: 'ptypb': device_add
device: 'ptypb': device_add
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypb
device: 'ptypc': device_add
device: 'ptypc': device_add
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypc
device: 'ptypd': device_add
device: 'ptypd': device_add
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptypd
device: 'ptype': device_add
device: 'ptype': device_add
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptype
device: 'ptypf': device_add
device: 'ptypf': device_add
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptypf
device: 'ptyq0': device_add
device: 'ptyq0': device_add
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq0
device: 'ptyq1': device_add
device: 'ptyq1': device_add
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq1
device: 'ptyq2': device_add
device: 'ptyq2': device_add
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq2
device: 'ptyq3': device_add
device: 'ptyq3': device_add
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq3
device: 'ptyq4': device_add
device: 'ptyq4': device_add
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq4
device: 'ptyq5': device_add
device: 'ptyq5': device_add
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq5
device: 'ptyq6': device_add
device: 'ptyq6': device_add
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq6
device: 'ptyq7': device_add
device: 'ptyq7': device_add
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq7
device: 'ptyq8': device_add
device: 'ptyq8': device_add
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq8
device: 'ptyq9': device_add
device: 'ptyq9': device_add
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyq9
device: 'ptyqa': device_add
device: 'ptyqa': device_add
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqa
device: 'ptyqb': device_add
device: 'ptyqb': device_add
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqb
device: 'ptyqc': device_add
device: 'ptyqc': device_add
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqc
device: 'ptyqd': device_add
device: 'ptyqd': device_add
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqd
device: 'ptyqe': device_add
device: 'ptyqe': device_add
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqe
device: 'ptyqf': device_add
device: 'ptyqf': device_add
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyqf
device: 'ptyr0': device_add
device: 'ptyr0': device_add
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr0
device: 'ptyr1': device_add
device: 'ptyr1': device_add
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr1
device: 'ptyr2': device_add
device: 'ptyr2': device_add
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr2
device: 'ptyr3': device_add
device: 'ptyr3': device_add
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr3
device: 'ptyr4': device_add
device: 'ptyr4': device_add
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr4
device: 'ptyr5': device_add
device: 'ptyr5': device_add
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr5
device: 'ptyr6': device_add
device: 'ptyr6': device_add
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr6
device: 'ptyr7': device_add
device: 'ptyr7': device_add
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr7
device: 'ptyr8': device_add
device: 'ptyr8': device_add
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr8
device: 'ptyr9': device_add
device: 'ptyr9': device_add
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyr9
device: 'ptyra': device_add
device: 'ptyra': device_add
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyra
device: 'ptyrb': device_add
device: 'ptyrb': device_add
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrb
device: 'ptyrc': device_add
device: 'ptyrc': device_add
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrc
device: 'ptyrd': device_add
device: 'ptyrd': device_add
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyrd
device: 'ptyre': device_add
device: 'ptyre': device_add
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyre
device: 'ptyrf': device_add
device: 'ptyrf': device_add
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptyrf
device: 'ptys0': device_add
device: 'ptys0': device_add
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys0
device: 'ptys1': device_add
device: 'ptys1': device_add
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys1
device: 'ptys2': device_add
device: 'ptys2': device_add
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys2
device: 'ptys3': device_add
device: 'ptys3': device_add
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys3
device: 'ptys4': device_add
device: 'ptys4': device_add
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys4
device: 'ptys5': device_add
device: 'ptys5': device_add
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys5
device: 'ptys6': device_add
device: 'ptys6': device_add
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys6
device: 'ptys7': device_add
device: 'ptys7': device_add
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys7
device: 'ptys8': device_add
device: 'ptys8': device_add
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys8
device: 'ptys9': device_add
device: 'ptys9': device_add
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptys9
device: 'ptysa': device_add
device: 'ptysa': device_add
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysa
device: 'ptysb': device_add
device: 'ptysb': device_add
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysb
device: 'ptysc': device_add
device: 'ptysc': device_add
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysc
device: 'ptysd': device_add
device: 'ptysd': device_add
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptysd
device: 'ptyse': device_add
device: 'ptyse': device_add
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptyse
device: 'ptysf': device_add
device: 'ptysf': device_add
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptysf
device: 'ptyt0': device_add
device: 'ptyt0': device_add
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt0
device: 'ptyt1': device_add
device: 'ptyt1': device_add
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt1
device: 'ptyt2': device_add
device: 'ptyt2': device_add
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt2
device: 'ptyt3': device_add
device: 'ptyt3': device_add
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt3
device: 'ptyt4': device_add
device: 'ptyt4': device_add
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt4
device: 'ptyt5': device_add
device: 'ptyt5': device_add
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt5
device: 'ptyt6': device_add
device: 'ptyt6': device_add
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt6
device: 'ptyt7': device_add
device: 'ptyt7': device_add
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt7
device: 'ptyt8': device_add
device: 'ptyt8': device_add
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt8
device: 'ptyt9': device_add
device: 'ptyt9': device_add
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyt9
device: 'ptyta': device_add
device: 'ptyta': device_add
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptyta
device: 'ptytb': device_add
device: 'ptytb': device_add
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytb
device: 'ptytc': device_add
device: 'ptytc': device_add
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytc
device: 'ptytd': device_add
device: 'ptytd': device_add
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptytd
device: 'ptyte': device_add
device: 'ptyte': device_add
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptyte
device: 'ptytf': device_add
device: 'ptytf': device_add
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptytf
device: 'ptyu0': device_add
device: 'ptyu0': device_add
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu0
device: 'ptyu1': device_add
device: 'ptyu1': device_add
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu1
device: 'ptyu2': device_add
device: 'ptyu2': device_add
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu2
device: 'ptyu3': device_add
device: 'ptyu3': device_add
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu3
device: 'ptyu4': device_add
device: 'ptyu4': device_add
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu4
device: 'ptyu5': device_add
device: 'ptyu5': device_add
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu5
device: 'ptyu6': device_add
device: 'ptyu6': device_add
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu6
device: 'ptyu7': device_add
device: 'ptyu7': device_add
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu7
device: 'ptyu8': device_add
device: 'ptyu8': device_add
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu8
device: 'ptyu9': device_add
device: 'ptyu9': device_add
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyu9
device: 'ptyua': device_add
device: 'ptyua': device_add
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyua
device: 'ptyub': device_add
device: 'ptyub': device_add
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyub
device: 'ptyuc': device_add
device: 'ptyuc': device_add
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyuc
device: 'ptyud': device_add
device: 'ptyud': device_add
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyud
device: 'ptyue': device_add
device: 'ptyue': device_add
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyue
device: 'ptyuf': device_add
device: 'ptyuf': device_add
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyuf
device: 'ptyv0': device_add
device: 'ptyv0': device_add
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv0
device: 'ptyv1': device_add
device: 'ptyv1': device_add
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv1
device: 'ptyv2': device_add
device: 'ptyv2': device_add
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv2
device: 'ptyv3': device_add
device: 'ptyv3': device_add
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv3
device: 'ptyv4': device_add
device: 'ptyv4': device_add
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv4
device: 'ptyv5': device_add
device: 'ptyv5': device_add
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv5
device: 'ptyv6': device_add
device: 'ptyv6': device_add
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv6
device: 'ptyv7': device_add
device: 'ptyv7': device_add
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv7
device: 'ptyv8': device_add
device: 'ptyv8': device_add
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv8
device: 'ptyv9': device_add
device: 'ptyv9': device_add
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyv9
device: 'ptyva': device_add
device: 'ptyva': device_add
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyva
device: 'ptyvb': device_add
device: 'ptyvb': device_add
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvb
device: 'ptyvc': device_add
device: 'ptyvc': device_add
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvc
device: 'ptyvd': device_add
device: 'ptyvd': device_add
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyvd
device: 'ptyve': device_add
device: 'ptyve': device_add
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyve
device: 'ptyvf': device_add
device: 'ptyvf': device_add
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyvf
device: 'ptyw0': device_add
device: 'ptyw0': device_add
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw0
device: 'ptyw1': device_add
device: 'ptyw1': device_add
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw1
device: 'ptyw2': device_add
device: 'ptyw2': device_add
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw2
device: 'ptyw3': device_add
device: 'ptyw3': device_add
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw3
device: 'ptyw4': device_add
device: 'ptyw4': device_add
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw4
device: 'ptyw5': device_add
device: 'ptyw5': device_add
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw5
device: 'ptyw6': device_add
device: 'ptyw6': device_add
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw6
device: 'ptyw7': device_add
device: 'ptyw7': device_add
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw7
device: 'ptyw8': device_add
device: 'ptyw8': device_add
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw8
device: 'ptyw9': device_add
device: 'ptyw9': device_add
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptyw9
device: 'ptywa': device_add
device: 'ptywa': device_add
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywa
device: 'ptywb': device_add
device: 'ptywb': device_add
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywb
device: 'ptywc': device_add
device: 'ptywc': device_add
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywc
device: 'ptywd': device_add
device: 'ptywd': device_add
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywd
device: 'ptywe': device_add
device: 'ptywe': device_add
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywe
device: 'ptywf': device_add
device: 'ptywf': device_add
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptywf
device: 'ptyx0': device_add
device: 'ptyx0': device_add
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx0
device: 'ptyx1': device_add
device: 'ptyx1': device_add
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx1
device: 'ptyx2': device_add
device: 'ptyx2': device_add
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx2
device: 'ptyx3': device_add
device: 'ptyx3': device_add
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx3
device: 'ptyx4': device_add
device: 'ptyx4': device_add
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx4
device: 'ptyx5': device_add
device: 'ptyx5': device_add
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx5
device: 'ptyx6': device_add
device: 'ptyx6': device_add
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx6
device: 'ptyx7': device_add
device: 'ptyx7': device_add
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx7
device: 'ptyx8': device_add
device: 'ptyx8': device_add
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx8
device: 'ptyx9': device_add
device: 'ptyx9': device_add
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyx9
device: 'ptyxa': device_add
device: 'ptyxa': device_add
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxa
device: 'ptyxb': device_add
device: 'ptyxb': device_add
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxb
device: 'ptyxc': device_add
device: 'ptyxc': device_add
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxc
device: 'ptyxd': device_add
device: 'ptyxd': device_add
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxd
device: 'ptyxe': device_add
device: 'ptyxe': device_add
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxe
device: 'ptyxf': device_add
device: 'ptyxf': device_add
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyxf
device: 'ptyy0': device_add
device: 'ptyy0': device_add
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy0
device: 'ptyy1': device_add
device: 'ptyy1': device_add
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy1
device: 'ptyy2': device_add
device: 'ptyy2': device_add
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy2
device: 'ptyy3': device_add
device: 'ptyy3': device_add
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy3
device: 'ptyy4': device_add
device: 'ptyy4': device_add
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy4
device: 'ptyy5': device_add
device: 'ptyy5': device_add
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy5
device: 'ptyy6': device_add
device: 'ptyy6': device_add
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy6
device: 'ptyy7': device_add
device: 'ptyy7': device_add
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy7
device: 'ptyy8': device_add
device: 'ptyy8': device_add
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy8
device: 'ptyy9': device_add
device: 'ptyy9': device_add
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyy9
device: 'ptyya': device_add
device: 'ptyya': device_add
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyya
device: 'ptyyb': device_add
device: 'ptyyb': device_add
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyb
device: 'ptyyc': device_add
device: 'ptyyc': device_add
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyc
device: 'ptyyd': device_add
device: 'ptyyd': device_add
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyyd
device: 'ptyye': device_add
device: 'ptyye': device_add
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyye
device: 'ptyyf': device_add
device: 'ptyyf': device_add
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyyf
device: 'ptyz0': device_add
device: 'ptyz0': device_add
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz0
device: 'ptyz1': device_add
device: 'ptyz1': device_add
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz1
device: 'ptyz2': device_add
device: 'ptyz2': device_add
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz2
device: 'ptyz3': device_add
device: 'ptyz3': device_add
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz3
device: 'ptyz4': device_add
device: 'ptyz4': device_add
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz4
device: 'ptyz5': device_add
device: 'ptyz5': device_add
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz5
device: 'ptyz6': device_add
device: 'ptyz6': device_add
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz6
device: 'ptyz7': device_add
device: 'ptyz7': device_add
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz7
device: 'ptyz8': device_add
device: 'ptyz8': device_add
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz8
device: 'ptyz9': device_add
device: 'ptyz9': device_add
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyz9
device: 'ptyza': device_add
device: 'ptyza': device_add
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyza
device: 'ptyzb': device_add
device: 'ptyzb': device_add
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzb
device: 'ptyzc': device_add
device: 'ptyzc': device_add
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzc
device: 'ptyzd': device_add
device: 'ptyzd': device_add
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyzd
device: 'ptyze': device_add
device: 'ptyze': device_add
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyze
device: 'ptyzf': device_add
device: 'ptyzf': device_add
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptyzf
device: 'ptya0': device_add
device: 'ptya0': device_add
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya0
device: 'ptya1': device_add
device: 'ptya1': device_add
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya1
device: 'ptya2': device_add
device: 'ptya2': device_add
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya2
device: 'ptya3': device_add
device: 'ptya3': device_add
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya3
device: 'ptya4': device_add
device: 'ptya4': device_add
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya4
device: 'ptya5': device_add
device: 'ptya5': device_add
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya5
device: 'ptya6': device_add
device: 'ptya6': device_add
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya6
device: 'ptya7': device_add
device: 'ptya7': device_add
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya7
device: 'ptya8': device_add
device: 'ptya8': device_add
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya8
device: 'ptya9': device_add
device: 'ptya9': device_add
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptya9
device: 'ptyaa': device_add
device: 'ptyaa': device_add
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyaa
device: 'ptyab': device_add
device: 'ptyab': device_add
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyab
device: 'ptyac': device_add
device: 'ptyac': device_add
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyac
device: 'ptyad': device_add
device: 'ptyad': device_add
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyad
device: 'ptyae': device_add
device: 'ptyae': device_add
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyae
device: 'ptyaf': device_add
device: 'ptyaf': device_add
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyaf
device: 'ptyb0': device_add
device: 'ptyb0': device_add
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb0
device: 'ptyb1': device_add
device: 'ptyb1': device_add
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb1
device: 'ptyb2': device_add
device: 'ptyb2': device_add
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb2
device: 'ptyb3': device_add
device: 'ptyb3': device_add
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb3
device: 'ptyb4': device_add
device: 'ptyb4': device_add
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb4
device: 'ptyb5': device_add
device: 'ptyb5': device_add
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb5
device: 'ptyb6': device_add
device: 'ptyb6': device_add
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb6
device: 'ptyb7': device_add
device: 'ptyb7': device_add
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb7
device: 'ptyb8': device_add
device: 'ptyb8': device_add
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb8
device: 'ptyb9': device_add
device: 'ptyb9': device_add
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyb9
device: 'ptyba': device_add
device: 'ptyba': device_add
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptyba
device: 'ptybb': device_add
device: 'ptybb': device_add
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybb
device: 'ptybc': device_add
device: 'ptybc': device_add
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybc
device: 'ptybd': device_add
device: 'ptybd': device_add
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybd
device: 'ptybe': device_add
device: 'ptybe': device_add
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybe
device: 'ptybf': device_add
device: 'ptybf': device_add
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptybf
device: 'ptyc0': device_add
device: 'ptyc0': device_add
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc0
device: 'ptyc1': device_add
device: 'ptyc1': device_add
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc1
device: 'ptyc2': device_add
device: 'ptyc2': device_add
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc2
device: 'ptyc3': device_add
device: 'ptyc3': device_add
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc3
device: 'ptyc4': device_add
device: 'ptyc4': device_add
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc4
device: 'ptyc5': device_add
device: 'ptyc5': device_add
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc5
device: 'ptyc6': device_add
device: 'ptyc6': device_add
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc6
device: 'ptyc7': device_add
device: 'ptyc7': device_add
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc7
device: 'ptyc8': device_add
device: 'ptyc8': device_add
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc8
device: 'ptyc9': device_add
device: 'ptyc9': device_add
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyc9
device: 'ptyca': device_add
device: 'ptyca': device_add
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptyca
device: 'ptycb': device_add
device: 'ptycb': device_add
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycb
device: 'ptycc': device_add
device: 'ptycc': device_add
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycc
device: 'ptycd': device_add
device: 'ptycd': device_add
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptycd
device: 'ptyce': device_add
device: 'ptyce': device_add
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptyce
device: 'ptycf': device_add
device: 'ptycf': device_add
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptycf
device: 'ptyd0': device_add
device: 'ptyd0': device_add
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd0
device: 'ptyd1': device_add
device: 'ptyd1': device_add
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd1
device: 'ptyd2': device_add
device: 'ptyd2': device_add
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd2
device: 'ptyd3': device_add
device: 'ptyd3': device_add
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd3
device: 'ptyd4': device_add
device: 'ptyd4': device_add
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd4
device: 'ptyd5': device_add
device: 'ptyd5': device_add
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd5
device: 'ptyd6': device_add
device: 'ptyd6': device_add
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd6
device: 'ptyd7': device_add
device: 'ptyd7': device_add
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd7
device: 'ptyd8': device_add
device: 'ptyd8': device_add
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd8
device: 'ptyd9': device_add
device: 'ptyd9': device_add
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyd9
device: 'ptyda': device_add
device: 'ptyda': device_add
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptyda
device: 'ptydb': device_add
device: 'ptydb': device_add
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydb
device: 'ptydc': device_add
device: 'ptydc': device_add
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydc
device: 'ptydd': device_add
device: 'ptydd': device_add
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptydd
device: 'ptyde': device_add
device: 'ptyde': device_add
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptyde
device: 'ptydf': device_add
device: 'ptydf': device_add
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptydf
device: 'ptye0': device_add
device: 'ptye0': device_add
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye0
device: 'ptye1': device_add
device: 'ptye1': device_add
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye1
device: 'ptye2': device_add
device: 'ptye2': device_add
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye2
device: 'ptye3': device_add
device: 'ptye3': device_add
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye3
device: 'ptye4': device_add
device: 'ptye4': device_add
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye4
device: 'ptye5': device_add
device: 'ptye5': device_add
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye5
device: 'ptye6': device_add
device: 'ptye6': device_add
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye6
device: 'ptye7': device_add
device: 'ptye7': device_add
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye7
device: 'ptye8': device_add
device: 'ptye8': device_add
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye8
device: 'ptye9': device_add
device: 'ptye9': device_add
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptye9
device: 'ptyea': device_add
device: 'ptyea': device_add
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyea
device: 'ptyeb': device_add
device: 'ptyeb': device_add
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyeb
device: 'ptyec': device_add
device: 'ptyec': device_add
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyec
device: 'ptyed': device_add
device: 'ptyed': device_add
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyed
device: 'ptyee': device_add
device: 'ptyee': device_add
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyee
device: 'ptyef': device_add
device: 'ptyef': device_add
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ptyef
device: 'ttyp0': device_add
device: 'ttyp0': device_add
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp0
device: 'ttyp1': device_add
device: 'ttyp1': device_add
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp1
device: 'ttyp2': device_add
device: 'ttyp2': device_add
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp2
device: 'ttyp3': device_add
device: 'ttyp3': device_add
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp3
device: 'ttyp4': device_add
device: 'ttyp4': device_add
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp4
device: 'ttyp5': device_add
device: 'ttyp5': device_add
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp5
device: 'ttyp6': device_add
device: 'ttyp6': device_add
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp6
device: 'ttyp7': device_add
device: 'ttyp7': device_add
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp7
device: 'ttyp8': device_add
device: 'ttyp8': device_add
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp8
device: 'ttyp9': device_add
device: 'ttyp9': device_add
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttyp9
device: 'ttypa': device_add
device: 'ttypa': device_add
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypa
device: 'ttypb': device_add
device: 'ttypb': device_add
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypb
device: 'ttypc': device_add
device: 'ttypc': device_add
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypc
device: 'ttypd': device_add
device: 'ttypd': device_add
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttypd
device: 'ttype': device_add
device: 'ttype': device_add
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttype
device: 'ttypf': device_add
device: 'ttypf': device_add
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttypf
device: 'ttyq0': device_add
device: 'ttyq0': device_add
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq0
device: 'ttyq1': device_add
device: 'ttyq1': device_add
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq1
device: 'ttyq2': device_add
device: 'ttyq2': device_add
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq2
device: 'ttyq3': device_add
device: 'ttyq3': device_add
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq3
device: 'ttyq4': device_add
device: 'ttyq4': device_add
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq4
device: 'ttyq5': device_add
device: 'ttyq5': device_add
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq5
device: 'ttyq6': device_add
device: 'ttyq6': device_add
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq6
device: 'ttyq7': device_add
device: 'ttyq7': device_add
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq7
device: 'ttyq8': device_add
device: 'ttyq8': device_add
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq8
device: 'ttyq9': device_add
device: 'ttyq9': device_add
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyq9
device: 'ttyqa': device_add
device: 'ttyqa': device_add
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqa
device: 'ttyqb': device_add
device: 'ttyqb': device_add
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqb
device: 'ttyqc': device_add
device: 'ttyqc': device_add
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqc
device: 'ttyqd': device_add
device: 'ttyqd': device_add
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqd
device: 'ttyqe': device_add
device: 'ttyqe': device_add
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqe
device: 'ttyqf': device_add
device: 'ttyqf': device_add
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyqf
device: 'ttyr0': device_add
device: 'ttyr0': device_add
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr0
device: 'ttyr1': device_add
device: 'ttyr1': device_add
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr1
device: 'ttyr2': device_add
device: 'ttyr2': device_add
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr2
device: 'ttyr3': device_add
device: 'ttyr3': device_add
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr3
device: 'ttyr4': device_add
device: 'ttyr4': device_add
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr4
device: 'ttyr5': device_add
device: 'ttyr5': device_add
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr5
device: 'ttyr6': device_add
device: 'ttyr6': device_add
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr6
device: 'ttyr7': device_add
device: 'ttyr7': device_add
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr7
device: 'ttyr8': device_add
device: 'ttyr8': device_add
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr8
device: 'ttyr9': device_add
device: 'ttyr9': device_add
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyr9
device: 'ttyra': device_add
device: 'ttyra': device_add
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyra
device: 'ttyrb': device_add
device: 'ttyrb': device_add
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrb
device: 'ttyrc': device_add
device: 'ttyrc': device_add
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrc
device: 'ttyrd': device_add
device: 'ttyrd': device_add
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyrd
device: 'ttyre': device_add
device: 'ttyre': device_add
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyre
device: 'ttyrf': device_add
device: 'ttyrf': device_add
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttyrf
device: 'ttys0': device_add
device: 'ttys0': device_add
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys0
device: 'ttys1': device_add
device: 'ttys1': device_add
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys1
device: 'ttys2': device_add
device: 'ttys2': device_add
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys2
device: 'ttys3': device_add
device: 'ttys3': device_add
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys3
device: 'ttys4': device_add
device: 'ttys4': device_add
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys4
device: 'ttys5': device_add
device: 'ttys5': device_add
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys5
device: 'ttys6': device_add
device: 'ttys6': device_add
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys6
device: 'ttys7': device_add
device: 'ttys7': device_add
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys7
device: 'ttys8': device_add
device: 'ttys8': device_add
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys8
device: 'ttys9': device_add
device: 'ttys9': device_add
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttys9
device: 'ttysa': device_add
device: 'ttysa': device_add
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysa
device: 'ttysb': device_add
device: 'ttysb': device_add
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysb
device: 'ttysc': device_add
device: 'ttysc': device_add
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysc
device: 'ttysd': device_add
device: 'ttysd': device_add
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttysd
device: 'ttyse': device_add
device: 'ttyse': device_add
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttyse
device: 'ttysf': device_add
device: 'ttysf': device_add
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttysf
device: 'ttyt0': device_add
device: 'ttyt0': device_add
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt0
device: 'ttyt1': device_add
device: 'ttyt1': device_add
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt1
device: 'ttyt2': device_add
device: 'ttyt2': device_add
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt2
device: 'ttyt3': device_add
device: 'ttyt3': device_add
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt3
device: 'ttyt4': device_add
device: 'ttyt4': device_add
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt4
device: 'ttyt5': device_add
device: 'ttyt5': device_add
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt5
device: 'ttyt6': device_add
device: 'ttyt6': device_add
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt6
device: 'ttyt7': device_add
device: 'ttyt7': device_add
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt7
device: 'ttyt8': device_add
device: 'ttyt8': device_add
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt8
device: 'ttyt9': device_add
device: 'ttyt9': device_add
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyt9
device: 'ttyta': device_add
device: 'ttyta': device_add
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttyta
device: 'ttytb': device_add
device: 'ttytb': device_add
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytb
device: 'ttytc': device_add
device: 'ttytc': device_add
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytc
device: 'ttytd': device_add
device: 'ttytd': device_add
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttytd
device: 'ttyte': device_add
device: 'ttyte': device_add
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttyte
device: 'ttytf': device_add
device: 'ttytf': device_add
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttytf
device: 'ttyu0': device_add
device: 'ttyu0': device_add
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu0
device: 'ttyu1': device_add
device: 'ttyu1': device_add
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu1
device: 'ttyu2': device_add
device: 'ttyu2': device_add
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu2
device: 'ttyu3': device_add
device: 'ttyu3': device_add
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu3
device: 'ttyu4': device_add
device: 'ttyu4': device_add
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu4
device: 'ttyu5': device_add
device: 'ttyu5': device_add
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu5
device: 'ttyu6': device_add
device: 'ttyu6': device_add
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu6
device: 'ttyu7': device_add
device: 'ttyu7': device_add
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu7
device: 'ttyu8': device_add
device: 'ttyu8': device_add
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu8
device: 'ttyu9': device_add
device: 'ttyu9': device_add
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyu9
device: 'ttyua': device_add
device: 'ttyua': device_add
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyua
device: 'ttyub': device_add
device: 'ttyub': device_add
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyub
device: 'ttyuc': device_add
device: 'ttyuc': device_add
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyuc
device: 'ttyud': device_add
device: 'ttyud': device_add
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyud
device: 'ttyue': device_add
device: 'ttyue': device_add
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyue
device: 'ttyuf': device_add
device: 'ttyuf': device_add
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyuf
device: 'ttyv0': device_add
device: 'ttyv0': device_add
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv0
device: 'ttyv1': device_add
device: 'ttyv1': device_add
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv1
device: 'ttyv2': device_add
device: 'ttyv2': device_add
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv2
device: 'ttyv3': device_add
device: 'ttyv3': device_add
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv3
device: 'ttyv4': device_add
device: 'ttyv4': device_add
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv4
device: 'ttyv5': device_add
device: 'ttyv5': device_add
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv5
device: 'ttyv6': device_add
device: 'ttyv6': device_add
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv6
device: 'ttyv7': device_add
device: 'ttyv7': device_add
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv7
device: 'ttyv8': device_add
device: 'ttyv8': device_add
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv8
device: 'ttyv9': device_add
device: 'ttyv9': device_add
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyv9
device: 'ttyva': device_add
device: 'ttyva': device_add
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyva
device: 'ttyvb': device_add
device: 'ttyvb': device_add
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvb
device: 'ttyvc': device_add
device: 'ttyvc': device_add
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvc
device: 'ttyvd': device_add
device: 'ttyvd': device_add
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyvd
device: 'ttyve': device_add
device: 'ttyve': device_add
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyve
device: 'ttyvf': device_add
device: 'ttyvf': device_add
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyvf
device: 'ttyw0': device_add
device: 'ttyw0': device_add
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw0
device: 'ttyw1': device_add
device: 'ttyw1': device_add
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw1
device: 'ttyw2': device_add
device: 'ttyw2': device_add
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw2
device: 'ttyw3': device_add
device: 'ttyw3': device_add
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw3
device: 'ttyw4': device_add
device: 'ttyw4': device_add
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw4
device: 'ttyw5': device_add
device: 'ttyw5': device_add
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw5
device: 'ttyw6': device_add
device: 'ttyw6': device_add
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw6
device: 'ttyw7': device_add
device: 'ttyw7': device_add
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw7
device: 'ttyw8': device_add
device: 'ttyw8': device_add
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw8
device: 'ttyw9': device_add
device: 'ttyw9': device_add
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttyw9
device: 'ttywa': device_add
device: 'ttywa': device_add
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywa
device: 'ttywb': device_add
device: 'ttywb': device_add
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywb
device: 'ttywc': device_add
device: 'ttywc': device_add
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywc
device: 'ttywd': device_add
device: 'ttywd': device_add
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywd
device: 'ttywe': device_add
device: 'ttywe': device_add
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywe
device: 'ttywf': device_add
device: 'ttywf': device_add
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttywf
device: 'ttyx0': device_add
device: 'ttyx0': device_add
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx0
device: 'ttyx1': device_add
device: 'ttyx1': device_add
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx1
device: 'ttyx2': device_add
device: 'ttyx2': device_add
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx2
device: 'ttyx3': device_add
device: 'ttyx3': device_add
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx3
device: 'ttyx4': device_add
device: 'ttyx4': device_add
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx4
device: 'ttyx5': device_add
device: 'ttyx5': device_add
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx5
device: 'ttyx6': device_add
device: 'ttyx6': device_add
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx6
device: 'ttyx7': device_add
device: 'ttyx7': device_add
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx7
device: 'ttyx8': device_add
device: 'ttyx8': device_add
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx8
device: 'ttyx9': device_add
device: 'ttyx9': device_add
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyx9
device: 'ttyxa': device_add
device: 'ttyxa': device_add
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxa
device: 'ttyxb': device_add
device: 'ttyxb': device_add
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxb
device: 'ttyxc': device_add
device: 'ttyxc': device_add
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxc
device: 'ttyxd': device_add
device: 'ttyxd': device_add
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxd
device: 'ttyxe': device_add
device: 'ttyxe': device_add
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxe
device: 'ttyxf': device_add
device: 'ttyxf': device_add
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyxf
device: 'ttyy0': device_add
device: 'ttyy0': device_add
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy0
device: 'ttyy1': device_add
device: 'ttyy1': device_add
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy1
device: 'ttyy2': device_add
device: 'ttyy2': device_add
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy2
device: 'ttyy3': device_add
device: 'ttyy3': device_add
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy3
device: 'ttyy4': device_add
device: 'ttyy4': device_add
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy4
device: 'ttyy5': device_add
device: 'ttyy5': device_add
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy5
device: 'ttyy6': device_add
device: 'ttyy6': device_add
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy6
device: 'ttyy7': device_add
device: 'ttyy7': device_add
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy7
device: 'ttyy8': device_add
device: 'ttyy8': device_add
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy8
device: 'ttyy9': device_add
device: 'ttyy9': device_add
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyy9
device: 'ttyya': device_add
device: 'ttyya': device_add
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyya
device: 'ttyyb': device_add
device: 'ttyyb': device_add
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyb
device: 'ttyyc': device_add
device: 'ttyyc': device_add
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyc
device: 'ttyyd': device_add
device: 'ttyyd': device_add
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyyd
device: 'ttyye': device_add
device: 'ttyye': device_add
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyye
device: 'ttyyf': device_add
device: 'ttyyf': device_add
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyyf
device: 'ttyz0': device_add
device: 'ttyz0': device_add
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz0
device: 'ttyz1': device_add
device: 'ttyz1': device_add
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz1
device: 'ttyz2': device_add
device: 'ttyz2': device_add
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz2
device: 'ttyz3': device_add
device: 'ttyz3': device_add
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz3
device: 'ttyz4': device_add
device: 'ttyz4': device_add
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz4
device: 'ttyz5': device_add
device: 'ttyz5': device_add
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz5
device: 'ttyz6': device_add
device: 'ttyz6': device_add
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz6
device: 'ttyz7': device_add
device: 'ttyz7': device_add
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz7
device: 'ttyz8': device_add
device: 'ttyz8': device_add
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz8
device: 'ttyz9': device_add
device: 'ttyz9': device_add
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyz9
device: 'ttyza': device_add
device: 'ttyza': device_add
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyza
device: 'ttyzb': device_add
device: 'ttyzb': device_add
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzb
device: 'ttyzc': device_add
device: 'ttyzc': device_add
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzc
device: 'ttyzd': device_add
device: 'ttyzd': device_add
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyzd
device: 'ttyze': device_add
device: 'ttyze': device_add
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyze
device: 'ttyzf': device_add
device: 'ttyzf': device_add
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttyzf
device: 'ttya0': device_add
device: 'ttya0': device_add
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya0
device: 'ttya1': device_add
device: 'ttya1': device_add
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya1
device: 'ttya2': device_add
device: 'ttya2': device_add
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya2
device: 'ttya3': device_add
device: 'ttya3': device_add
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya3
device: 'ttya4': device_add
device: 'ttya4': device_add
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya4
device: 'ttya5': device_add
device: 'ttya5': device_add
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya5
device: 'ttya6': device_add
device: 'ttya6': device_add
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya6
device: 'ttya7': device_add
device: 'ttya7': device_add
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya7
device: 'ttya8': device_add
device: 'ttya8': device_add
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya8
device: 'ttya9': device_add
device: 'ttya9': device_add
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttya9
device: 'ttyaa': device_add
device: 'ttyaa': device_add
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyaa
device: 'ttyab': device_add
device: 'ttyab': device_add
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyab
device: 'ttyac': device_add
device: 'ttyac': device_add
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyac
device: 'ttyad': device_add
device: 'ttyad': device_add
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyad
device: 'ttyae': device_add
device: 'ttyae': device_add
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyae
device: 'ttyaf': device_add
device: 'ttyaf': device_add
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyaf
device: 'ttyb0': device_add
device: 'ttyb0': device_add
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb0
device: 'ttyb1': device_add
device: 'ttyb1': device_add
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb1
device: 'ttyb2': device_add
device: 'ttyb2': device_add
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb2
device: 'ttyb3': device_add
device: 'ttyb3': device_add
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb3
device: 'ttyb4': device_add
device: 'ttyb4': device_add
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb4
device: 'ttyb5': device_add
device: 'ttyb5': device_add
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb5
device: 'ttyb6': device_add
device: 'ttyb6': device_add
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb6
device: 'ttyb7': device_add
device: 'ttyb7': device_add
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb7
device: 'ttyb8': device_add
device: 'ttyb8': device_add
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb8
device: 'ttyb9': device_add
device: 'ttyb9': device_add
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyb9
device: 'ttyba': device_add
device: 'ttyba': device_add
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttyba
device: 'ttybb': device_add
device: 'ttybb': device_add
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybb
device: 'ttybc': device_add
device: 'ttybc': device_add
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybc
device: 'ttybd': device_add
device: 'ttybd': device_add
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybd
device: 'ttybe': device_add
device: 'ttybe': device_add
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybe
device: 'ttybf': device_add
device: 'ttybf': device_add
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttybf
device: 'ttyc0': device_add
device: 'ttyc0': device_add
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc0
device: 'ttyc1': device_add
device: 'ttyc1': device_add
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc1
device: 'ttyc2': device_add
device: 'ttyc2': device_add
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc2
device: 'ttyc3': device_add
device: 'ttyc3': device_add
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc3
device: 'ttyc4': device_add
device: 'ttyc4': device_add
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc4
device: 'ttyc5': device_add
device: 'ttyc5': device_add
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc5
device: 'ttyc6': device_add
device: 'ttyc6': device_add
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc6
device: 'ttyc7': device_add
device: 'ttyc7': device_add
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc7
device: 'ttyc8': device_add
device: 'ttyc8': device_add
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc8
device: 'ttyc9': device_add
device: 'ttyc9': device_add
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyc9
device: 'ttyca': device_add
device: 'ttyca': device_add
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttyca
device: 'ttycb': device_add
device: 'ttycb': device_add
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycb
device: 'ttycc': device_add
device: 'ttycc': device_add
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycc
device: 'ttycd': device_add
device: 'ttycd': device_add
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttycd
device: 'ttyce': device_add
device: 'ttyce': device_add
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttyce
device: 'ttycf': device_add
device: 'ttycf': device_add
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttycf
device: 'ttyd0': device_add
device: 'ttyd0': device_add
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd0
device: 'ttyd1': device_add
device: 'ttyd1': device_add
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd1
device: 'ttyd2': device_add
device: 'ttyd2': device_add
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd2
device: 'ttyd3': device_add
device: 'ttyd3': device_add
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd3
device: 'ttyd4': device_add
device: 'ttyd4': device_add
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd4
device: 'ttyd5': device_add
device: 'ttyd5': device_add
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd5
device: 'ttyd6': device_add
device: 'ttyd6': device_add
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd6
device: 'ttyd7': device_add
device: 'ttyd7': device_add
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd7
device: 'ttyd8': device_add
device: 'ttyd8': device_add
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd8
device: 'ttyd9': device_add
device: 'ttyd9': device_add
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyd9
device: 'ttyda': device_add
device: 'ttyda': device_add
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttyda
device: 'ttydb': device_add
device: 'ttydb': device_add
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydb
device: 'ttydc': device_add
device: 'ttydc': device_add
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydc
device: 'ttydd': device_add
device: 'ttydd': device_add
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttydd
device: 'ttyde': device_add
device: 'ttyde': device_add
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttyde
device: 'ttydf': device_add
device: 'ttydf': device_add
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttydf
device: 'ttye0': device_add
device: 'ttye0': device_add
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye0
device: 'ttye1': device_add
device: 'ttye1': device_add
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye1
device: 'ttye2': device_add
device: 'ttye2': device_add
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye2
device: 'ttye3': device_add
device: 'ttye3': device_add
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye3
device: 'ttye4': device_add
device: 'ttye4': device_add
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye4
device: 'ttye5': device_add
device: 'ttye5': device_add
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye5
device: 'ttye6': device_add
device: 'ttye6': device_add
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye6
device: 'ttye7': device_add
device: 'ttye7': device_add
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye7
device: 'ttye8': device_add
device: 'ttye8': device_add
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye8
device: 'ttye9': device_add
device: 'ttye9': device_add
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttye9
device: 'ttyea': device_add
device: 'ttyea': device_add
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyea
device: 'ttyeb': device_add
device: 'ttyeb': device_add
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyeb
device: 'ttyec': device_add
device: 'ttyec': device_add
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyec
device: 'ttyed': device_add
device: 'ttyed': device_add
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyed
device: 'ttyee': device_add
device: 'ttyee': device_add
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyee
device: 'ttyef': device_add
device: 'ttyef': device_add
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:ttyef
device: 'ptmx': device_add
device: 'ptmx': device_add
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:ptmx
initcall pty_init+0x0/0x382 returned 0 after 5527797 usecs
initcall pty_init+0x0/0x382 returned 0 after 5527797 usecs
calling  sysrq_init+0x0/0x7a @ 1
calling  sysrq_init+0x0/0x7a @ 1
initcall sysrq_init+0x0/0x7a returned 0 after 34 usecs
initcall sysrq_init+0x0/0x7a returned 0 after 34 usecs
calling  serial8250_init+0x0/0x158 @ 1
calling  serial8250_init+0x0/0x158 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Registering platform device 'serial8250'. Parent at platform
Registering platform device 'serial8250'. Parent at platform
device: 'serial8250': device_add
device: 'serial8250': device_add
bus: 'platform': add device serial8250
bus: 'platform': add device serial8250
PM: Adding info for platform:serial8250
PM: Adding info for platform:serial8250
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS0
device: 'ttyS1': device_add
device: 'ttyS1': device_add
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS1
device: 'ttyS2': device_add
device: 'ttyS2': device_add
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS2
device: 'ttyS3': device_add
device: 'ttyS3': device_add
PM: Adding info for No Bus:ttyS3
PM: Adding info for No Bus:ttyS3
bus: 'platform': add driver serial8250
bus: 'platform': add driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
driver: 'serial8250': driver_bound: bound to device 'serial8250'
driver: 'serial8250': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
initcall serial8250_init+0x0/0x158 returned 0 after 421386 usecs
initcall serial8250_init+0x0/0x158 returned 0 after 421386 usecs
calling  serial8250_pnp_init+0x0/0xf @ 1
calling  serial8250_pnp_init+0x0/0xf @ 1
bus: 'pnp': add driver serial
bus: 'pnp': add driver serial
bus: 'pnp': driver_probe_device: matched device 00:08 with driver serial
bus: 'pnp': driver_probe_device: matched device 00:08 with driver serial
bus: 'pnp': really_probe: probing driver serial with device 00:08
bus: 'pnp': really_probe: probing driver serial with device 00:08
device: 'ttyS0': device_unregister
device: 'ttyS0': device_unregister
PM: Removing info for No Bus:ttyS0
PM: Removing info for No Bus:ttyS0
device: 'ttyS0': device_create_release
device: 'ttyS0': device_create_release�00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS0
driver: '00:08': driver_bound: bound to device 'serial'
driver: '00:08': driver_bound: bound to device 'serial'
bus: 'pnp': really_probe: bound device 00:08 to driver serial
bus: 'pnp': really_probe: bound device 00:08 to driver serial
initcall serial8250_pnp_init+0x0/0xf returned 0 after 109484 usecs
initcall serial8250_pnp_init+0x0/0xf returned 0 after 109484 usecs
calling  serial8250_pci_init+0x0/0x16 @ 1
calling  serial8250_pci_init+0x0/0x16 @ 1
bus: 'pci': add driver serial
bus: 'pci': add driver serial
initcall serial8250_pci_init+0x0/0x16 returned 0 after 5394 usecs
initcall serial8250_pci_init+0x0/0x16 returned 0 after 5394 usecs
calling  rand_initialize+0x0/0x30 @ 1
calling  rand_initialize+0x0/0x30 @ 1
initcall rand_initialize+0x0/0x30 returned 0 after 47 usecs
initcall rand_initialize+0x0/0x30 returned 0 after 47 usecs
calling  hpet_init+0x0/0x59 @ 1
calling  hpet_init+0x0/0x59 @ 1
device: 'hpet': device_add
device: 'hpet': device_add
PM: Adding info for No Bus:hpet
PM: Adding info for No Bus:hpet
bus: 'acpi': add driver hpet
bus: 'acpi': add driver hpet
initcall hpet_init+0x0/0x59 returned 0 after 15610 usecs
initcall hpet_init+0x0/0x59 returned 0 after 15610 usecs
calling  topology_sysfs_init+0x0/0x4c @ 1
calling  topology_sysfs_init+0x0/0x4c @ 1
initcall topology_sysfs_init+0x0/0x4c returned 0 after 110 usecs
initcall topology_sysfs_init+0x0/0x4c returned 0 after 110 usecs
calling  cpqarray_init+0x0/0x26a @ 1
calling  cpqarray_init+0x0/0x26a @ 1
Compaq SMART2 Driver (v 2.6.0)
Compaq SMART2 Driver (v 2.6.0)
bus: 'pci': add driver cpqarray
bus: 'pci': add driver cpqarray
bus: 'pci': remove driver cpqarray
bus: 'pci': remove driver cpqarray
driver: 'cpqarray': driver_release
driver: 'cpqarray': driver_release
initcall cpqarray_init+0x0/0x26a returned -19 after 23395 usecs
initcall cpqarray_init+0x0/0x26a returned -19 after 23395 usecs
calling  twl4030_audio_driver_init+0x0/0xf @ 1
calling  twl4030_audio_driver_init+0x0/0xf @ 1
bus: 'platform': add driver twl4030-audio
bus: 'platform': add driver twl4030-audio
initcall twl4030_audio_driver_init+0x0/0xf returned 0 after 7379 usecs
initcall twl4030_audio_driver_init+0x0/0xf returned 0 after 7379 usecs
calling  twl6040_driver_init+0x0/0x11 @ 1
calling  twl6040_driver_init+0x0/0x11 @ 1
bus: 'i2c': add driver twl6040
bus: 'i2c': add driver twl6040
i2c-core: driver [twl6040] registered
i2c-core: driver [twl6040] registered
initcall twl6040_driver_init+0x0/0x11 returned 0 after 12054 usecs
initcall twl6040_driver_init+0x0/0x11 returned 0 after 12054 usecs
calling  intel_msic_driver_init+0x0/0xf @ 1
calling  intel_msic_driver_init+0x0/0xf @ 1
bus: 'platform': add driver intel_msic
bus: 'platform': add driver intel_msic
initcall intel_msic_driver_init+0x0/0xf returned 0 after 6864 usecs
initcall intel_msic_driver_init+0x0/0xf returned 0 after 6864 usecs
calling  spi_transport_init+0x0/0x79 @ 1
calling  spi_transport_init+0x0/0x79 @ 1
device class 'spi_transport': registering
device class 'spi_transport': registering
device class 'spi_host': registering
device class 'spi_host': registering
initcall spi_transport_init+0x0/0x79 returned 0 after 13800 usecs
initcall spi_transport_init+0x0/0x79 returned 0 after 13800 usecs
calling  ahc_linux_init+0x0/0x5a @ 1
calling  ahc_linux_init+0x0/0x5a @ 1
bus: 'pci': add driver aic7xxx
bus: 'pci': add driver aic7xxx
initcall ahc_linux_init+0x0/0x5a returned 0 after 5665 usecs
initcall ahc_linux_init+0x0/0x5a returned 0 after 5665 usecs
calling  init_sd+0x0/0xf9 @ 1
calling  init_sd+0x0/0xf9 @ 1
device class 'scsi_disk': registering
device class 'scsi_disk': registering
bus: 'scsi': add driver sd
bus: 'scsi': add driver sd
initcall init_sd+0x0/0xf9 returned 0 after 12142 usecs
initcall init_sd+0x0/0xf9 returned 0 after 12142 usecs
calling  ahci_pci_driver_init+0x0/0x16 @ 1
calling  ahci_pci_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver ahci
bus: 'pci': add driver ahci
initcall ahci_pci_driver_init+0x0/0x16 returned 0 after 5137 usecs
initcall ahci_pci_driver_init+0x0/0x16 returned 0 after 5137 usecs
calling  piix_init+0x0/0x24 @ 1
calling  piix_init+0x0/0x24 @ 1
bus: 'pci': add driver ata_piix
bus: 'pci': add driver ata_piix
initcall piix_init+0x0/0x24 returned 0 after 5807 usecs
initcall piix_init+0x0/0x24 returned 0 after 5807 usecs
calling  nv_pci_driver_init+0x0/0x16 @ 1
calling  nv_pci_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver sata_nv
bus: 'pci': add driver sata_nv
initcall nv_pci_driver_init+0x0/0x16 returned 0 after 5628 usecs
initcall nv_pci_driver_init+0x0/0x16 returned 0 after 5628 usecs
calling  amd_pci_driver_init+0x0/0x16 @ 1
calling  amd_pci_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver pata_amd
bus: 'pci': add driver pata_amd
bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
pata_amd 0000:00:06.0: setting latency timer to 64
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(): returned f62c8000
cma: dma_alloc_from_contiguous(): returned f62c8000
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(): returned f62c8020
cma: dma_alloc_from_contiguous(): returned f62c8020
device: 'ata1': device_add
device: 'ata1': device_add
PM: Adding info for No Bus:ata1
PM: Adding info for No Bus:ata1
device: 'ata1': device_add
device: 'ata1': device_add
PM: Adding info for No Bus:ata1
PM: Adding info for No Bus:ata1
device: 'link1': device_add
device: 'link1': device_add
PM: Adding info for No Bus:link1
PM: Adding info for No Bus:link1
device: 'link1': device_add
device: 'link1': device_add
PM: Adding info for No Bus:link1
PM: Adding info for No Bus:link1
device: 'dev1.0': device_add
device: 'dev1.0': device_add
PM: Adding info for No Bus:dev1.0
PM: Adding info for No Bus:dev1.0
device: 'dev1.0': device_add
device: 'dev1.0': device_add
PM: Adding info for No Bus:dev1.0
PM: Adding info for No Bus:dev1.0
device: 'dev1.1': device_add
device: 'dev1.1': device_add
PM: Adding info for No Bus:dev1.1
PM: Adding info for No Bus:dev1.1
device: 'dev1.1': device_add
device: 'dev1.1': device_add
PM: Adding info for No Bus:dev1.1
PM: Adding info for No Bus:dev1.1
device: 'ata2': device_add
device: 'ata2': device_add
PM: Adding info for No Bus:ata2
PM: Adding info for No Bus:ata2
device: 'ata2': device_add
device: 'ata2': device_add
PM: Adding info for No Bus:ata2
PM: Adding info for No Bus:ata2
device: 'link2': device_add
device: 'link2': device_add
PM: Adding info for No Bus:link2
PM: Adding info for No Bus:link2
device: 'link2': device_add
device: 'link2': device_add
PM: Adding info for No Bus:link2
PM: Adding info for No Bus:link2
device: 'dev2.0': device_add
device: 'dev2.0': device_add
PM: Adding info for No Bus:dev2.0
PM: Adding info for No Bus:dev2.0
device: 'dev2.0': device_add
device: 'dev2.0': device_add
PM: Adding info for No Bus:dev2.0
PM: Adding info for No Bus:dev2.0
device: 'dev2.1': device_add
device: 'dev2.1': device_add
PM: Adding info for No Bus:dev2.1
PM: Adding info for No Bus:dev2.1
device: 'dev2.1': device_add
device: 'dev2.1': device_add
PM: Adding info for No Bus:dev2.1
PM: Adding info for No Bus:dev2.1
scsi0 : pata_amd
scsi0 : pata_amd
device: 'host0': device_add
device: 'host0': device_add
bus: 'scsi': add device host0
bus: 'scsi': add device host0
PM: Adding info for scsi:host0
PM: Adding info for scsi:host0
device: 'host0': device_add
device: 'host0': device_add
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:host0
scsi1 : pata_amd
scsi1 : pata_amd
device: 'host1': device_add
device: 'host1': device_add
bus: 'scsi': add device host1
bus: 'scsi': add device host1
PM: Adding info for scsi:host1
PM: Adding info for scsi:host1
device: 'host1': device_add
device: 'host1': device_add
PM: Adding info for No Bus:host1
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
calling  1_async_port_probe+0x0/0x60 @ 6
calling  1_async_port_probe+0x0/0x60 @ 6
calling  2_async_port_probe+0x0/0x60 @ 37
calling  2_async_port_probe+0x0/0x60 @ 37
async_waiting @ 37
async_waiting @ 37
bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
initcall amd_pci_driver_init+0x0/0x16 returned 0 after 389959 usecs
initcall amd_pci_driver_init+0x0/0x16 returned 0 after 389959 usecs
calling  oldpiix_pci_driver_init+0x0/0x16 @ 1
calling  oldpiix_pci_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver pata_oldpiix
bus: 'pci': add driver pata_oldpiix
initcall oldpiix_pci_driver_init+0x0/0x16 returned 0 after 6454 usecs
initcall oldpiix_pci_driver_init+0x0/0x16 returned 0 after 6454 usecs
calling  via_pci_driver_init+0x0/0x16 @ 1
calling  via_pci_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver pata_via
bus: 'pci': add driver pata_via
initcall via_pci_driver_init+0x0/0x16 returned 0 after 5774 usecs
initcall via_pci_driver_init+0x0/0x16 returned 0 after 5774 usecs
calling  ce4100_spi_driver_init+0x0/0x16 @ 1
calling  ce4100_spi_driver_init+0x0/0x16 @ 1
bus: 'pci': add driver ce4100_spi
bus: 'pci': add driver ce4100_spi
initcall ce4100_spi_driver_init+0x0/0x16 returned 0 after 6071 usecs
initcall ce4100_spi_driver_init+0x0/0x16 returned 0 after 6071 usecs
calling  net_olddevs_init+0x0/0x72 @ 1
calling  net_olddevs_init+0x0/0x72 @ 1
initcall net_olddevs_init+0x0/0x72 returned 0 after 5 usecs
initcall net_olddevs_init+0x0/0x72 returned 0 after 5 usecs
calling  fixed_mdio_bus_init+0x0/0x10c @ 1
calling  fixed_mdio_bus_init+0x0/0x10c @ 1
Registering platform device 'Fixed MDIO bus.0'. Parent at platform
Registering platform device 'Fixed MDIO bus.0'. Parent at platform
device: 'Fixed MDIO bus.0': device_add
device: 'Fixed MDIO bus.0': device_add
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
async_waiting @ 6
async_waiting @ 6
async_continuing @ 6 after 2 usec
async_continuing @ 6 after 2 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
device: 'target0:0:0': device_add
device: 'target0:0:0': device_add
bus: 'scsi': add device target0:0:0
bus: 'scsi': add device target0:0:0
PM: Adding info for scsi:target0:0:0
PM: Adding info for scsi:target0:0:0
device: '0:0:0:0': device_add
device: '0:0:0:0': device_add
bus: 'scsi': add device 0:0:0:0
bus: 'scsi': add device 0:0:0:0
PM: Adding info for scsi:0:0:0:0
PM: Adding info for scsi:0:0:0:0
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
device: '0:0:0:0': device_add
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
driver: '0:0:0:0': driver_bound: bound to device 'sd'
driver: '0:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
device: '0:0:0:0': device_add
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
device: '0:0:0:0': device_add
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
initcall 1_async_port_probe+0x0/0x60 returned 0 after 195627 usecs
initcall 1_async_port_probe+0x0/0x60 returned 0 after 195627 usecs
calling  3_sd_probe_async+0x0/0x1a0 @ 6
calling  3_sd_probe_async+0x0/0x1a0 @ 6
async_continuing @ 37 after 195504 usec
async_continuing @ 37 after 195504 usec
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device: '8:0': device_add
device: '8:0': device_add
PM: Adding info for No Bus:8:0
PM: Adding info for No Bus:8:0
device: 'sda': device_add
device: 'sda': device_add
PM: Adding info for No Bus:sda
PM: Adding info for No Bus:sda
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
device: 'sda1': device_add
device: 'sda1': device_add
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda1
device: 'sda2': device_add
device: 'sda2': device_add
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda2
device: 'sda3': device_add
device: 'sda3': device_add
PM: Adding info for No Bus:sda3
PM: Adding info for No Bus:sda3
device: 'sda5': device_add
device: 'sda5': device_add
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:sda5
device: 'sda6': device_add
device: 'sda6': device_add
PM: Adding info for No Bus:sda6
PM: Adding info for No Bus:sda6
device: 'sda7': device_add
device: 'sda7': device_add
PM: Adding info for No Bus:sda7
PM: Adding info for No Bus:sda7
device: 'sda8': device_add
device: 'sda8': device_add
PM: Adding info for No Bus:sda8
PM: Adding info for No Bus:sda8
device: 'sda9': device_add
device: 'sda9': device_add
PM: Adding info for No Bus:sda9
PM: Adding info for No Bus:sda9
device: 'sda10': device_add
device: 'sda10': device_add
PM: Adding info for No Bus:sda10
PM: Adding info for No Bus:sda10
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
initcall 3_sd_probe_async+0x0/0x1a0 returned 0 after 99069 usecs
initcall 3_sd_probe_async+0x0/0x1a0 returned 0 after 99069 usecs
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2.01: configured for UDMA/33
ata2.01: configured for UDMA/33
async_waiting @ 37
async_waiting @ 37
async_continuing @ 37 after 2 usec
async_continuing @ 37 after 2 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
device: 'target1:0:1': device_add
device: 'target1:0:1': device_add
bus: 'scsi': add device target1:0:1
bus: 'scsi': add device target1:0:1
PM: Adding info for scsi:target1:0:1
PM: Adding info for scsi:target1:0:1
device: '1:0:1:0': device_add
device: '1:0:1:0': device_add
bus: 'scsi': add device 1:0:1:0
bus: 'scsi': add device 1:0:1:0
PM: Adding info for scsi:1:0:1:0
PM: Adding info for scsi:1:0:1:0
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
sd: probe of 1:0:1:0 rejects match -19
sd: probe of 1:0:1:0 rejects match -19
device: '1:0:1:0': device_add
device: '1:0:1:0': device_add
PM: Adding info for No Bus:1:0:1:0
PM: Adding info for No Bus:1:0:1:0
device: '1:0:1:0': device_add
device: '1:0:1:0': device_add
PM: Adding info for No Bus:1:0:1:0
PM: Adding info for No Bus:1:0:1:0
initcall 2_async_port_probe+0x0/0x60 returned 0 after 373837 usecs
initcall 2_async_port_probe+0x0/0x60 returned 0 after 373837 usecs
bus: 'platform': add device Fixed MDIO bus.0
bus: 'platform': add device Fixed MDIO bus.0
PM: Adding info for platform:Fixed MDIO bus.0
PM: Adding info for platform:Fixed MDIO bus.0
device: 'fixed-0': device_add
device: 'fixed-0': device_add
PM: Adding info for No Bus:fixed-0
PM: Adding info for No Bus:fixed-0
libphy: Fixed MDIO Bus: probed
libphy: Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0x10c returned 0 after 582217 usecs
initcall fixed_mdio_bus_init+0x0/0x10c returned 0 after 582217 usecs
calling  vortex_init+0x0/0x9f @ 1
calling  vortex_init+0x0/0x9f @ 1
bus: 'pci': add driver 3c59x
bus: 'pci': add driver 3c59x
initcall vortex_init+0x0/0x9f returned 0 after 5211 usecs
initcall vortex_init+0x0/0x9f returned 0 after 5211 usecs
calling  tg3_init+0x0/0x16 @ 1
calling  tg3_init+0x0/0x16 @ 1
bus: 'pci': add driver tg3
bus: 'pci': add driver tg3
initcall tg3_init+0x0/0x16 returned 0 after 4927 usecs
initcall tg3_init+0x0/0x16 returned 0 after 4927 usecs
calling  e100_init_module+0x0/0x5a @ 1
calling  e100_init_module+0x0/0x5a @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100: Copyright(c) 1999-2006 Intel Corporation
bus: 'pci': add driver e100
bus: 'pci': add driver e100
initcall e100_init_module+0x0/0x5a returned 0 after 22570 usecs
initcall e100_init_module+0x0/0x5a returned 0 after 22570 usecs
calling  e1000_init_module+0x0/0x39 @ 1
calling  e1000_init_module+0x0/0x39 @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
bus: 'pci': add driver e1000e
bus: 'pci': add driver e1000e
initcall e1000_init_module+0x0/0x39 returned 0 after 23276 usecs
initcall e1000_init_module+0x0/0x39 returned 0 after 23276 usecs
calling  skge_init_module+0x0/0x63 @ 1
calling  skge_init_module+0x0/0x63 @ 1
bus: 'pci': add driver skge
bus: 'pci': add driver skge
initcall skge_init_module+0x0/0x63 returned 0 after 5135 usecs
initcall skge_init_module+0x0/0x63 returned 0 after 5135 usecs
calling  init_nic+0x0/0x16 @ 1
calling  init_nic+0x0/0x16 @ 1
bus: 'pci': add driver forcedeth
bus: 'pci': add driver forcedeth
bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
IOAPIC[0]: Set routing entry (2-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:3)
IOAPIC[0]: Set routing entry (2-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:3)
forcedeth 0000:00:0a.0: setting latency timer to 64
forcedeth 0000:00:0a.0: setting latency timer to 64
device: 'eth0': device_add
device: 'eth0': device_add
PM: Adding info for No Bus:eth0
PM: Adding info for No Bus:eth0
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
initcall init_nic+0x0/0x16 returned 0 after 656351 usecs
initcall init_nic+0x0/0x16 returned 0 after 656351 usecs
calling  ehci_hcd_init+0x0/0xf5 @ 1
calling  ehci_hcd_init+0x0/0xf5 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
bus: 'pci': add driver ehci_hcd
bus: 'pci': add driver ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
ehci_hcd 0000:00:02.1: enabling bus mastering
ehci_hcd 0000:00:02.1: enabling bus mastering
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(): returned f62c8040
cma: dma_alloc_from_contiguous(): returned f62c8040
ehci_hcd 0000:00:02.1: park 0
ehci_hcd 0000:00:02.1: park 0
ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
ehci_hcd 0000:00:02.1: supports USB remote wakeup
ehci_hcd 0000:00:02.1: supports USB remote wakeup
ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.6.0-rc5-01600-g1501693-dirty ehci_hcd
usb usb1: Manufacturer: Linux 3.6.0-rc5-01600-g1501693-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: SerialNumber: 0000:00:02.1
device: 'usb1': device_add
device: 'usb1': device_add
bus: 'usb': add device usb1
bus: 'usb': add device usb1
PM: Adding info for usb:usb1
PM: Adding info for usb:usb1
bus: 'usb': driver_probe_device: matched device usb1 with driver usb
bus: 'usb': driver_probe_device: matched device usb1 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb1
bus: 'usb': really_probe: probing driver usb with device usb1
usb usb1: usb_probe_device
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb usb1: adding 1-0:1.0 (config #1, interface 0)
device: '1-0:1.0': device_add
device: '1-0:1.0': device_add
bus: 'usb': add device 1-0:1.0
bus: 'usb': add device 1-0:1.0
PM: Adding info for usb:1-0:1.0
PM: Adding info for usb:1-0:1.0
bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
hub 1-0:1.0: 10 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: trying to enable port power on non-switchable hub
driver: '1-0:1.0': driver_bound: bound to device 'hub'
driver: '1-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
device: 'ep_81': device_add
device: 'ep_81': device_add
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_81
driver: 'usb1': driver_bound: bound to device 'usb'
driver: 'usb1': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb1 to driver usb
bus: 'usb': really_probe: bound device usb1 to driver usb
device: 'ep_00': device_add
device: 'ep_00': device_add
PM: Adding info for No Bus:ep_00
PM: Adding info for No Bus:ep_00
driver: '0000:00:02.1': driver_bound: bound to device 'ehci_hcd'
driver: '0000:00:02.1': driver_bound: bound to device 'ehci_hcd'
bus: 'pci': really_probe: bound device 0000:00:02.1 to driver ehci_hcd
bus: 'pci': really_probe: bound device 0000:00:02.1 to driver ehci_hcd
initcall ehci_hcd_init+0x0/0xf5 returned 0 after 558571 usecs
initcall ehci_hcd_init+0x0/0xf5 returned 0 after 558571 usecs
calling  ohci_hcd_mod_init+0x0/0xe1 @ 1
calling  ohci_hcd_mod_init+0x0/0xe1 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
ohci_hcd: block sizes: ed 64 td 64
bus: 'platform': add driver ohci-platform
bus: 'platform': add driver ohci-platform
bus: 'pci': add driver ohci_hcd
bus: 'pci': add driver ohci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
ohci_hcd 0000:00:02.0: enabling bus mastering
ohci_hcd 0000:00:02.0: enabling bus mastering
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
cma: dma_alloc_from_contiguous(cma f59376c0, count 1, align 0)
hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
cma: dma_alloc_from_contiguous(): returned f62c8060
cma: dma_alloc_from_contiguous(): returned f62c8060
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: supports USB remote wakeup
ohci_hcd 0000:00:02.0: supports USB remote wakeup
ohci_hcd 0000:00:02.0: irq 23, io mem 0xda002000
ohci_hcd 0000:00:02.0: irq 23, io mem 0xda002000
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers, rh state running
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers, rh state running
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0040
ohci_hcd 0000:00:02.0: hcca frame #0040
ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 3.6.0-rc5-01600-g1501693-dirty ohci_hcd
usb usb2: Manufacturer: Linux 3.6.0-rc5-01600-g1501693-dirty ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: SerialNumber: 0000:00:02.0
device: 'usb2': device_add
device: 'usb2': device_add
bus: 'usb': add device usb2
bus: 'usb': add device usb2
PM: Adding info for usb:usb2
PM: Adding info for usb:usb2
bus: 'usb': driver_probe_device: matched device usb2 with driver usb
bus: 'usb': driver_probe_device: matched device usb2 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb2
bus: 'usb': really_probe: probing driver usb with device usb2
usb usb2: usb_probe_device
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb usb2: adding 2-0:1.0 (config #1, interface 0)
device: '2-0:1.0': device_add
device: '2-0:1.0': device_add
bus: 'usb': add device 2-0:1.0
bus: 'usb': add device 2-0:1.0
PM: Adding info for usb:2-0:1.0
PM: Adding info for usb:2-0:1.0
bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
hub 2-0:1.0: 10 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: trying to enable port power on non-switchable hub
driver: '2-0:1.0': driver_bound: bound to device 'hub'
driver: '2-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
device: 'ep_81': device_add
device: 'ep_81': device_add
PM: Adding info for No Bus:ep_81
PM: Adding info for No Bus:ep_81
driver: 'usb2': driver_bound: bound to device 'usb'
driver: 'usb2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb2 to driver usb
bus: 'usb': really_probe: bound device usb2 to driver usb
device: 'ep_00': device_add
device: 'ep_00': device_add
PM: Adding info for No Bus:ep_00
PM: Adding info for No Bus:ep_00
ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
driver: '0000:00:02.0': driver_bound: bound to device 'ohci_hcd'
driver: '0000:00:02.0': driver_bound: bound to device 'ohci_hcd'
bus: 'pci': really_probe: bound device 0000:00:02.0 to driver ohci_hcd
bus: 'pci': really_probe: bound device 0000:00:02.0 to driver ohci_hcd
initcall ohci_hcd_mod_init+0x0/0xe1 returned 0 after 732315 usecs
initcall ohci_hcd_mod_init+0x0/0xe1 returned 0 after 732315 usecs
calling  uhci_hcd_init+0x0/0x100 @ 1
calling  uhci_hcd_init+0x0/0x100 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd: USB Universal Host Controller Interface driver
bus: 'pci': add driver uhci_hcd
bus: 'pci': add driver uhci_hcd
initcall uhci_hcd_init+0x0/0x100 returned 0 after 16053 usecs
initcall uhci_hcd_init+0x0/0x100 returned 0 after 16053 usecs
calling  i8042_init+0x0/0x3bc @ 1
calling  i8042_init+0x0/0x3bc @ 1
bus: 'pnp': add driver i8042 kbd
bus: 'pnp': add driver i8042 kbd
bus: 'pnp': driver_probe_device: matched device 00:0b with driver i8042 kbd
bus: 'pnp': driver_probe_device: matched device 00:0b with driver i8042 kbd
bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0b
bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0b
driver: '00:0b': driver_bound: bound to device 'i8042 kbd'
driver: '00:0b': driver_bound: bound to device 'i8042 kbd'
bus: 'pnp': really_probe: bound device 00:0b to driver i8042 kbd
bus: 'pnp': really_probe: bound device 00:0b to driver i8042 kbd
bus: 'pnp': add driver i8042 aux
bus: 'pnp': add driver i8042 aux
bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 aux
bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 aux
bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0a
bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0a
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
driver: '00:0a': driver_bound: bound to device 'i8042 aux'
driver: '00:0a': driver_bound: bound to device 'i8042 aux'
bus: 'pnp': really_probe: bound device 00:0a to driver i8042 aux
bus: 'pnp': really_probe: bound device 00:0a to driver i8042 aux
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Registering platform device 'i8042'. Parent at platform
Registering platform device 'i8042'. Parent at platform
device: 'i8042': device_add
device: 'i8042': device_add
bus: 'platform': add device i8042
bus: 'platform': add device i8042
PM: Adding info for platform:i8042
PM: Adding info for platform:i8042
bus: 'platform': add driver i8042
bus: 'platform': add driver i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 AUX port at 0x60,0x64 irq 12
device: 'serio0': device_add
device: 'serio0': device_add
driver: 'i8042': driver_bound: bound to device 'i8042'
driver: 'i8042': driver_bound: bound to device 'i8042'
bus: 'serio': add device serio0
bus: 'serio': add device serio0
PM: Adding info for serio:serio0
PM: Adding info for serio:serio0
bus: 'platform': really_probe: bound device i8042 to driver i8042
bus: 'platform': really_probe: bound device i8042 to driver i8042
device: 'serio1': device_add
device: 'serio1': device_add
bus: 'serio': add device serio1
bus: 'serio': add device serio1
initcall i8042_init+0x0/0x3bc returned 0 after 247503 usecs
initcall i8042_init+0x0/0x3bc returned 0 after 247503 usecs
calling  mousedev_init+0x0/0x52 @ 1
calling  mousedev_init+0x0/0x52 @ 1
PM: Adding info for serio:serio1
PM: Adding info for serio:serio1
device: 'mice': device_add
device: 'mice': device_add
PM: Adding info for No Bus:mice
PM: Adding info for No Bus:mice
mousedev: PS/2 mouse device common for all mice
mousedev: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x52 returned 0 after 24545 usecs
initcall mousedev_init+0x0/0x52 returned 0 after 24545 usecs
calling  atkbd_init+0x0/0x20 @ 1
calling  atkbd_init+0x0/0x20 @ 1
bus: 'serio': add driver atkbd
bus: 'serio': add driver atkbd
initcall atkbd_init+0x0/0x20 returned 0 after 5563 usecs
initcall atkbd_init+0x0/0x20 returned 0 after 5563 usecs
calling  intel_scu_ipc_init+0x0/0x2c @ 1
calling  intel_scu_ipc_init+0x0/0x2c @ 1
initcall intel_scu_ipc_init+0x0/0x2c returned -19 after 1 usecs
initcall intel_scu_ipc_init+0x0/0x2c returned -19 after 1 usecs
calling  sock_diag_init+0x0/0xf @ 1
calling  sock_diag_init+0x0/0xf @ 1
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
initcall sock_diag_init+0x0/0xf returned 0 after 105 usecs
initcall sock_diag_init+0x0/0xf returned 0 after 105 usecs
calling  flow_cache_init_global+0x0/0x16d @ 1
calling  flow_cache_init_global+0x0/0x16d @ 1
initcall flow_cache_init_global+0x0/0x16d returned 0 after 772 usecs
initcall flow_cache_init_global+0x0/0x16d returned 0 after 772 usecs
calling  blackhole_module_init+0x0/0xf @ 1
calling  blackhole_module_init+0x0/0xf @ 1
initcall blackhole_module_init+0x0/0xf returned 0 after 2 usecs
initcall blackhole_module_init+0x0/0xf returned 0 after 2 usecs
calling  sysctl_ipv4_init+0x0/0x7a @ 1
calling  sysctl_ipv4_init+0x0/0x7a @ 1
initcall sysctl_ipv4_init+0x0/0x7a returned 0 after 71 usecs
initcall sysctl_ipv4_init+0x0/0x7a returned 0 after 71 usecs
calling  init_syncookies+0x0/0x16 @ 1
calling  init_syncookies+0x0/0x16 @ 1
initcall init_syncookies+0x0/0x16 returned 0 after 31 usecs
initcall init_syncookies+0x0/0x16 returned 0 after 31 usecs
calling  ipv4_netfilter_init+0x0/0x10 @ 1
calling  ipv4_netfilter_init+0x0/0x10 @ 1
initcall ipv4_netfilter_init+0x0/0x10 returned 0 after 36 usecs
initcall ipv4_netfilter_init+0x0/0x10 returned 0 after 36 usecs
calling  cubictcp_register+0x0/0x83 @ 1
calling  cubictcp_register+0x0/0x83 @ 1
TCP: cubic registered
TCP: cubic registered
initcall cubictcp_register+0x0/0x83 returned 0 after 4 usecs
initcall cubictcp_register+0x0/0x83 returned 0 after 4 usecs
calling  packet_init+0x0/0x39 @ 1
calling  packet_init+0x0/0x39 @ 1
NET: Registered protocol family 17
NET: Registered protocol family 17
initcall packet_init+0x0/0x39 returned 0 after 43 usecs
initcall packet_init+0x0/0x39 returned 0 after 43 usecs
calling  mcheck_init_device+0x0/0x102 @ 1
calling  mcheck_init_device+0x0/0x102 @ 1
bus: 'machinecheck': registered
bus: 'machinecheck': registered
device: 'machinecheck': device_add
device: 'machinecheck': device_add
PM: Adding info for No Bus:machinecheck
PM: Adding info for No Bus:machinecheck
device: 'machinecheck0': device_add
device: 'machinecheck0': device_add
bus: 'machinecheck': add device machinecheck0
bus: 'machinecheck': add device machinecheck0
PM: Adding info for machinecheck:machinecheck0
PM: Adding info for machinecheck:machinecheck0
device: 'machinecheck1': device_add
device: 'machinecheck1': device_add
bus: 'machinecheck': add device machinecheck1
bus: 'machinecheck': add device machinecheck1
PM: Adding info for machinecheck:machinecheck1
PM: Adding info for machinecheck:machinecheck1
device: 'mcelog': device_add
device: 'mcelog': device_add
PM: Adding info for No Bus:mcelog
PM: Adding info for No Bus:mcelog
initcall mcheck_init_device+0x0/0x102 returned 0 after 1479 usecs
initcall mcheck_init_device+0x0/0x102 returned 0 after 1479 usecs
calling  rio_init_mports+0x0/0x4e @ 1
calling  rio_init_mports+0x0/0x4e @ 1
initcall rio_init_mports+0x0/0x4e returned 0 after 25 usecs
initcall rio_init_mports+0x0/0x4e returned 0 after 25 usecs
calling  mcheck_debugfs_init+0x0/0x3e @ 1
calling  mcheck_debugfs_init+0x0/0x3e @ 1
initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 54 usecs
initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 54 usecs
calling  severities_debugfs_init+0x0/0x40 @ 1
calling  severities_debugfs_init+0x0/0x40 @ 1
initcall severities_debugfs_init+0x0/0x40 returned 0 after 21 usecs
initcall severities_debugfs_init+0x0/0x40 returned 0 after 21 usecs
calling  hpet_insert_resource+0x0/0x21 @ 1
calling  hpet_insert_resource+0x0/0x21 @ 1
initcall hpet_insert_resource+0x0/0x21 returned 1 after 2 usecs
initcall hpet_insert_resource+0x0/0x21 returned 1 after 2 usecs
initcall hpet_insert_resource+0x0/0x21 returned with error code 1 
initcall hpet_insert_resource+0x0/0x21 returned with error code 1 
calling  update_mp_table+0x0/0x3f5 @ 1
calling  update_mp_table+0x0/0x3f5 @ 1
initcall update_mp_table+0x0/0x3f5 returned 0 after 2 usecs
initcall update_mp_table+0x0/0x3f5 returned 0 after 2 usecs
calling  lapic_insert_resource+0x0/0x34 @ 1
calling  lapic_insert_resource+0x0/0x34 @ 1
initcall lapic_insert_resource+0x0/0x34 returned 0 after 4 usecs
initcall lapic_insert_resource+0x0/0x34 returned 0 after 4 usecs
calling  io_apic_bug_finalize+0x0/0x1a @ 1
calling  io_apic_bug_finalize+0x0/0x1a @ 1
initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 2 usecs
initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 2 usecs
calling  print_ICs+0x0/0x4bb @ 1
calling  print_ICs+0x0/0x4bb @ 1

printing PIC contents

printing PIC contents
... PIC  IMR: ffff
... PIC  IMR: ffff
... PIC  IRR: 0839
... PIC  IRR: 0839
... PIC  ISR: 0000
... PIC  ISR: 0000
... PIC ELCR: 0828
... PIC ELCR: 0828
printing local APIC contents on CPU#0/0:
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC SPIV: 000001ff
... APIC ISR field:
... APIC ISR field:
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

... APIC TMR field:
... APIC TMR field:
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

... APIC IRR field:
... APIC IRR field:
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000

... APIC ESR: 00000000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR: 000008fd
... APIC ICR2: 02000000
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTT: 000200ef
... APIC LVTPC: 00000400
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c454
... APIC TMICT: 0000c454
... APIC TMCCT: 00000455
... APIC TMCCT: 00000455
... APIC TDCR: 00000003
... APIC TDCR: 00000003


number of MP IRQ sources: 16.
number of MP IRQ sources: 16.
bus: 'serio': really_probe: probing driver atkbd with device serio0
bus: 'serio': really_probe: probing driver atkbd with device serio0
number of IO-APIC #2 registers: 24.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
testing the IO APIC.......................
device: 'input0': device_add
device: 'input0': device_add
PM: Adding info for No Bus:input0
PM: Adding info for No Bus:input0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
driver: 'serio0': driver_bound: bound to device 'atkbd'
driver: 'serio0': driver_bound: bound to device 'atkbd'
bus: 'serio': really_probe: bound device serio0 to driver atkbd
bus: 'serio': really_probe: bound device serio0 to driver atkbd
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
bus: 'serio': really_probe: probing driver atkbd with device serio1
atkbd: probe of serio1 rejects match -19
atkbd: probe of serio1 rejects match -19
IO APIC #2......
IO APIC #2......
.... register #00: 00000000
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : Delivery Type: 0
.......    : LTS          : 0
.......    : LTS          : 0
.... register #01: 00170011
.... register #01: 00170011
.......     : max redirection entries: 17
.......     : max redirection entries: 17
.......     : PRQ implemented: 0
.......     : PRQ implemented: 0
.......     : IO APIC version: 11
.......     : IO APIC version: 11
.... register #02: 00000000
.... register #02: 00000000
.......     : arbitration: 00
.......     : arbitration: 00
.... IRQ redirection table:
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 03   00 03  0    0    0   0   0    1    1    30
0    0    0   0   0    1    1    30
 01 03   01 03  0    0    0   0   0    1    1    31
0    0    0   0   0    1    1    31
 02 03   02 03  1    0    0   0   0    0    0    41
1    0    0   0   0    0    0    41
 03 03   03 03  1    0    0   0   0    1    1    33
1    0    0   0   0    1    1    33
 04 03   04 03  1    0    0   0   0    1    1    34
1    0    0   0   0    1    1    34
 05 03   05 03  1    0    0   0   0    1    1    35
1    0    0   0   0    1    1    35
 06 03   06 03  1    0    0   0   0    1    1    36
1    0    0   0   0    1    1    36
 07 03   07 03  1    0    0   0   0    1    1    37
1    0    0   0   0    1    1    37
 08 03   08 03  1    0    0   0   0    1    1    38
1    0    0   0   0    1    1    38
 09 03   09 03  0    1    0   0   0    1    1    39
0    1    0   0   0    1    1    39
 0a 03   0a 03  1    0    0   0   0    1    1    3A
1    0    0   0   0    1    1    3A
 0b 03   0b 03  1    0    0   0   0    1    1    3B
1    0    0   0   0    1    1    3B
 0c 03   0c 03  0    0    0   0   0    1    1    3C
0    0    0   0   0    1    1    3C
 0d 03   0d 03  1    0    0   0   0    1    1    3D
1    0    0   0   0    1    1    3D
 0e 03   0e 03  0    0    0   0   0    1    1    3E
0    0    0   0   0    1    1    3E
 0f 03   0f 03  0    0    0   0   0    1    1    3F
0    0    0   0   0    1    1    3F
 10 00   10 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
 11 00   11 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
 12 00   12 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
 13 00   13 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
 14 00   14 00  1    0    0   0   0    0    0    00
1    0    0   0   0    0    0    00
 15 03   15 03  1    1    0   1   0    1    1    71
1    1    0   1   0    1    1    71
 16 03   16 03  0    1    0   1   0    1    1    61
0    1    0   1   0    1    1    61
 17 03   17 03  0    1    0   1   0    1    1    51
0    1    0   1   0    1    1    51
IRQ to pin mappings:
IRQ to pin mappings:
IRQ0 IRQ0 -> 0:0-> 0:0

IRQ1 IRQ1 -> 0:1-> 0:1

IRQ3 IRQ3 -> 0:3-> 0:3

IRQ4 IRQ4 -> 0:4-> 0:4

IRQ5 IRQ5 -> 0:5-> 0:5

IRQ6 IRQ6 -> 0:6-> 0:6

IRQ7 IRQ7 -> 0:7-> 0:7

IRQ8 IRQ8 -> 0:8-> 0:8

IRQ9 IRQ9 -> 0:9-> 0:9

IRQ10 IRQ10 -> 0:10-> 0:10

IRQ11 IRQ11 -> 0:11-> 0:11

IRQ12 IRQ12 -> 0:12-> 0:12

IRQ13 IRQ13 -> 0:13-> 0:13

IRQ14 IRQ14 -> 0:14-> 0:14

IRQ15 IRQ15 -> 0:15-> 0:15

IRQ21 IRQ21 -> 0:21-> 0:21

IRQ22 IRQ22 -> 0:22-> 0:22

IRQ23 IRQ23 -> 0:23-> 0:23

.................................... done.
.................................... done.
initcall print_ICs+0x0/0x4bb returned 0 after 966610 usecs
initcall print_ICs+0x0/0x4bb returned 0 after 966610 usecs
calling  print_ipi_mode+0x0/0x2e @ 1
calling  print_ipi_mode+0x0/0x2e @ 1
Using IPI No-Shortcut mode
Using IPI No-Shortcut mode
initcall print_ipi_mode+0x0/0x2e returned 0 after 4757 usecs
initcall print_ipi_mode+0x0/0x2e returned 0 after 4757 usecs
calling  check_early_ioremap_leak+0x0/0x54 @ 1
calling  check_early_ioremap_leak+0x0/0x54 @ 1
initcall check_early_ioremap_leak+0x0/0x54 returned 0 after 1 usecs
initcall check_early_ioremap_leak+0x0/0x54 returned 0 after 1 usecs
calling  pat_memtype_list_init+0x0/0x3a @ 1
calling  pat_memtype_list_init+0x0/0x3a @ 1
initcall pat_memtype_list_init+0x0/0x3a returned 0 after 25 usecs
initcall pat_memtype_list_init+0x0/0x3a returned 0 after 25 usecs
calling  create_tlb_flushall_shift+0x0/0x2e @ 1
calling  create_tlb_flushall_shift+0x0/0x2e @ 1
initcall create_tlb_flushall_shift+0x0/0x2e returned 0 after 44 usecs
initcall create_tlb_flushall_shift+0x0/0x2e returned 0 after 44 usecs
calling  pb_keys_init+0x0/0xb0 @ 1
calling  pb_keys_init+0x0/0xb0 @ 1
initcall pb_keys_init+0x0/0xb0 returned 0 after 2 usecs
initcall pb_keys_init+0x0/0xb0 returned 0 after 2 usecs
calling  init_oops_id+0x0/0x40 @ 1
calling  init_oops_id+0x0/0x40 @ 1
initcall init_oops_id+0x0/0x40 returned 0 after 6 usecs
initcall init_oops_id+0x0/0x40 returned 0 after 6 usecs
calling  printk_late_init+0x0/0x56 @ 1
calling  printk_late_init+0x0/0x56 @ 1
initcall printk_late_init+0x0/0x56 returned 0 after 3 usecs
initcall printk_late_init+0x0/0x56 returned 0 after 3 usecs
calling  sched_init_debug+0x0/0x2a @ 1
calling  sched_init_debug+0x0/0x2a @ 1
initcall sched_init_debug+0x0/0x2a returned 0 after 32 usecs
initcall sched_init_debug+0x0/0x2a returned 0 after 32 usecs
calling  pm_qos_power_init+0x0/0x5b @ 1
calling  pm_qos_power_init+0x0/0x5b @ 1
device: 'cpu_dma_latency': device_add
device: 'cpu_dma_latency': device_add
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:cpu_dma_latency
device: 'network_latency': device_add
device: 'network_latency': device_add
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_latency
device: 'network_throughput': device_add
device: 'network_throughput': device_add
PM: Adding info for No Bus:network_throughput
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0x5b returned 0 after 43683 usecs
initcall pm_qos_power_init+0x0/0x5b returned 0 after 43683 usecs
calling  pm_debugfs_init+0x0/0x2a @ 1
calling  pm_debugfs_init+0x0/0x2a @ 1
initcall pm_debugfs_init+0x0/0x2a returned 0 after 25 usecs
initcall pm_debugfs_init+0x0/0x2a returned 0 after 25 usecs
calling  software_resume+0x0/0x340 @ 1
calling  software_resume+0x0/0x340 @ 1
PM: Hibernation image not present or could not be loaded.
PM: Hibernation image not present or could not be loaded.
initcall software_resume+0x0/0x340 returned -2 after 10004 usecs
initcall software_resume+0x0/0x340 returned -2 after 10004 usecs
initcall software_resume+0x0/0x340 returned with error code -2 
initcall software_resume+0x0/0x340 returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x90 @ 1
calling  debugfs_kprobe_init+0x0/0x90 @ 1
initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 70 usecs
initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 70 usecs
calling  max_swapfiles_check+0x0/0x7 @ 1
calling  max_swapfiles_check+0x0/0x7 @ 1
initcall max_swapfiles_check+0x0/0x7 returned 0 after 1 usecs
initcall max_swapfiles_check+0x0/0x7 returned 0 after 1 usecs
calling  set_recommended_min_free_kbytes+0x0/0x90 @ 1
calling  set_recommended_min_free_kbytes+0x0/0x90 @ 1
initcall set_recommended_min_free_kbytes+0x0/0x90 returned 0 after 88 usecs
initcall set_recommended_min_free_kbytes+0x0/0x90 returned 0 after 88 usecs
calling  init_encrypted+0x0/0xfa @ 1
calling  init_encrypted+0x0/0xfa @ 1
Key type encrypted registered
Key type encrypted registered
initcall init_encrypted+0x0/0xfa returned 0 after 8157 usecs
initcall init_encrypted+0x0/0xfa returned 0 after 8157 usecs
calling  init_evm+0x0/0x26 @ 1
calling  init_evm+0x0/0x26 @ 1
initcall init_evm+0x0/0x26 returned 0 after 59 usecs
initcall init_evm+0x0/0x26 returned 0 after 59 usecs
calling  random32_reseed+0x0/0x83 @ 1
calling  random32_reseed+0x0/0x83 @ 1
initcall random32_reseed+0x0/0x83 returned 0 after 16 usecs
initcall random32_reseed+0x0/0x83 returned 0 after 16 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 17 usecs
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 17 usecs
calling  pci_sysfs_init+0x0/0x44 @ 1
calling  pci_sysfs_init+0x0/0x44 @ 1
initcall pci_sysfs_init+0x0/0x44 returned 0 after 2548 usecs
initcall pci_sysfs_init+0x0/0x44 returned 0 after 2548 usecs
calling  regulator_init_complete+0x0/0x13a @ 1
calling  regulator_init_complete+0x0/0x13a @ 1
initcall regulator_init_complete+0x0/0x13a returned 0 after 5 usecs
initcall regulator_init_complete+0x0/0x13a returned 0 after 5 usecs
calling  random_int_secret_init+0x0/0x16 @ 1
calling  random_int_secret_init+0x0/0x16 @ 1
initcall random_int_secret_init+0x0/0x16 returned 0 after 16 usecs
initcall random_int_secret_init+0x0/0x16 returned 0 after 16 usecs
calling  deferred_probe_initcall+0x0/0x70 @ 1
calling  deferred_probe_initcall+0x0/0x70 @ 1
initcall deferred_probe_initcall+0x0/0x70 returned 0 after 134 usecs
initcall deferred_probe_initcall+0x0/0x70 returned 0 after 134 usecs
calling  late_resume_init+0x0/0x190 @ 1
calling  late_resume_init+0x0/0x190 @ 1
  Magic number: 8:580:562
  Magic number: 8:580:562
tty ptya8: hash matches
tty ptya8: hash matches
initcall late_resume_init+0x0/0x190 returned 0 after 9007 usecs
initcall late_resume_init+0x0/0x190 returned 0 after 9007 usecs
calling  hd_init+0x0/0x2d2 @ 1
calling  hd_init+0x0/0x2d2 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x2d2 returned -1 after 12819 usecs
initcall hd_init+0x0/0x2d2 returned -1 after 12819 usecs
initcall hd_init+0x0/0x2d2 returned with error code -1 
initcall hd_init+0x0/0x2d2 returned with error code -1 
calling  init_netconsole+0x0/0x18f @ 1
calling  init_netconsole+0x0/0x18f @ 1
console [netcon0] enabled
console [netcon0] enabled
netconsole: network logging started
netconsole: network logging started
initcall init_netconsole+0x0/0x18f returned 0 after 10866 usecs
initcall init_netconsole+0x0/0x18f returned 0 after 10866 usecs
calling  memmap_init+0x0/0x29 @ 1
calling  memmap_init+0x0/0x29 @ 1
initcall memmap_init+0x0/0x29 returned 0 after 362 usecs
initcall memmap_init+0x0/0x29 returned 0 after 362 usecs
calling  devfreq_start_polling+0x0/0xc0 @ 1
calling  devfreq_start_polling+0x0/0xc0 @ 1
initcall devfreq_start_polling+0x0/0xc0 returned 0 after 224 usecs
initcall devfreq_start_polling+0x0/0xc0 returned 0 after 224 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 3 usecs
initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 3 usecs
calling  net_secret_init+0x0/0x16 @ 1
calling  net_secret_init+0x0/0x16 @ 1
initcall net_secret_init+0x0/0x16 returned 0 after 16 usecs
initcall net_secret_init+0x0/0x16 returned 0 after 16 usecs
calling  tcp_congestion_default+0x0/0xf @ 1
calling  tcp_congestion_default+0x0/0xf @ 1
initcall tcp_congestion_default+0x0/0xf returned 0 after 3 usecs
initcall tcp_congestion_default+0x0/0xf returned 0 after 3 usecs
calling  tcp_fastopen_init+0x0/0x7 @ 1
calling  tcp_fastopen_init+0x0/0x7 @ 1
initcall tcp_fastopen_init+0x0/0x7 returned 0 after 1 usecs
initcall tcp_fastopen_init+0x0/0x7 returned 0 after 1 usecs
calling  debug_hotplug_cpu+0x0/0x10 @ 1
calling  debug_hotplug_cpu+0x0/0x10 @ 1
CPA self-test:
CPA self-test:
 4k 3070 large 219 gb 0 x 3289[c0000000-f77fd000] miss 0
 4k 3070 large 219 gb 0 x 3289[c0000000-f77fd000] miss 0
 4k 186366 large 40 gb 0 x 186406[c0000000-f77fd000] miss 0
 4k 186366 large 40 gb 0 x 186406[c0000000-f77fd000] miss 0
 4k 186366 large 40 gb 0 x 186406[c0000000-f77fd000] miss 0
 4k 186366 large 40 gb 0 x 186406[c0000000-f77fd000] miss 0
ok.
ok.
INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (16249 ticks this GP) idle=c37/140000000000001/0 
	0: (16249 ticks this GP) idle=c37/140000000000001/0 
		 (t=16250 jiffies)
 (t=16250 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 00003f7a 00003f7a 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (65002 ticks this GP) idle=c37/140000000000001/0 
	0: (65002 ticks this GP) idle=c37/140000000000001/0 
		 (t=65003 jiffies)
 (t=65003 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0000fdeb 0000fdeb 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (113755 ticks this GP) idle=c37/140000000000001/0 
	0: (113755 ticks this GP) idle=c37/140000000000001/0 
		 (t=113756 jiffies)
 (t=113756 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0001bc5c 0001bc5c 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (162508 ticks this GP) idle=c37/140000000000001/0 
	0: (162508 ticks this GP) idle=c37/140000000000001/0 
		 (t=162509 jiffies)
 (t=162509 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 00027acd 00027acd 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (211261 ticks this GP) idle=c37/140000000000001/0 
	0: (211261 ticks this GP) idle=c37/140000000000001/0 
		 (t=211262 jiffies)
 (t=211262 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0003393e 0003393e 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050327>] ? lock_hrtimer_base.isra.27+0x17/0x50
 [<c1050327>] ? lock_hrtimer_base.isra.27+0x17/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000202 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000202 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (260014 ticks this GP) idle=c37/140000000000001/0 
	0: (260014 ticks this GP) idle=c37/140000000000001/0 
		 (t=260015 jiffies)
 (t=260015 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0003f7af 0003f7af 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (308767 ticks this GP) idle=c37/140000000000001/0 
	0: (308767 ticks this GP) idle=c37/140000000000001/0 
		 (t=308768 jiffies)
 (t=308768 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0004b620 0004b620 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c105033f>] ? lock_hrtimer_base.isra.27+0x2f/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (357520 ticks this GP) idle=c37/140000000000001/0 
	0: (357520 ticks this GP) idle=c37/140000000000001/0 
		 (t=357521 jiffies)
 (t=357521 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 00057491 00057491 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050327>] ? lock_hrtimer_base.isra.27+0x17/0x50
 [<c1050327>] ? lock_hrtimer_base.isra.27+0x17/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (406273 ticks this GP) idle=c37/140000000000001/0 
	0: (406273 ticks this GP) idle=c37/140000000000001/0 
		 (t=406274 jiffies)
 (t=406274 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 00063302 00063302 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050325>] ? lock_hrtimer_base.isra.27+0x15/0x50
 [<c1050325>] ? lock_hrtimer_base.isra.27+0x15/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000202 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000202 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (455026 ticks this GP) idle=c37/140000000000001/0 
	0: (455026 ticks this GP) idle=c37/140000000000001/0 
		 (t=455027 jiffies)
 (t=455027 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0006f173 0006f173 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050323>] ? lock_hrtimer_base.isra.27+0x13/0x50
 [<c1050323>] ? lock_hrtimer_base.isra.27+0x13/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15

NMI backtrace for cpu 1
NMI backtrace for cpu 1
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP: 0060:[<c10088e1>] EFLAGS: 00000206 CPU: 1
EIP is at default_idle+0x21/0x40
EIP is at default_idle+0x21/0x40
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
EAX: f59191e0 EBX: c15f048c ECX: 00000000 EDX: 00000007
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
ESI: 00000000 EDI: 00000000 EBP: f5921f84 ESP: f5921f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Process swapper/1 (pid: 0, ti=f5920000 task=f59191e0 task.ti=f5920000)
Stack:
Stack:
 f5921f90 f5921f90 c10091e0 c10091e0 01020800 01020800 f5921fb4 f5921fb4 c140dd93 c140dd93 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000d8 000000d8 00000000 00000000 00000000 00000000

Call Trace:
Call Trace:
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c10091e0>] cpu_idle+0x50/0x80
 [<c140dd93>] start_secondary+0x233/0x235
 [<c140dd93>] start_secondary+0x233/0x235
Code:Code: 08 08 74 74 f7 f7 5d 5d c3 c3 90 90 8d 8d 74 74 26 26 00 00 55 55 89 89 e0 e0 89 89 e5 e5 25 25 00 00 e0 e0 ff ff ff ff 83 83 60 60 0c 0c fb fb 0f 0f ae ae f0 f0 89 89 f6 f6 8b 8b 40 40 08 08 a8 a8 08 08 75 75 09 09 e8 e8 11 11 86 86 07 07 00 00 fb fb f4 f4 <eb> <eb> 0d 0d e8 e8 08 08 86 86 07 07 00 00 fb fb 8d 8d b4 b4 26 26 00 00 00 00 00 00 00 00 89 89 e0 e0 25 25 00 00 e0 e0 ff ff

INFO: rcu_sched self-detected stall on CPUINFO: rcu_sched self-detected stall on CPU

	0: (503779 ticks this GP) idle=c37/140000000000001/0 
	0: (503779 ticks this GP) idle=c37/140000000000001/0 
		 (t=503780 jiffies)
 (t=503780 jiffies)
sending NMI to all CPUs:
sending NMI to all CPUs:
NMI backtrace for cpu 0
NMI backtrace for cpu 0
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
Pid: 9, comm: watchdog/0 Not tainted 3.6.0-rc5-01600-g1501693-dirty #196867 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP: 0060:[<c101fbad>] EFLAGS: 00000086 CPU: 0
EIP is at default_send_IPI_all+0x7d/0x80
EIP is at default_send_IPI_all+0x7d/0x80
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
EAX: 00000046 EBX: 00002710 ECX: 00000000 EDX: f591eb40
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
ESI: c15bf1e0 EDI: c15bf1e0 EBP: f5917e28 ESP: f5917e24
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
CR0: 8005003b CR2: 00000000 CR3: 0165d000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
DR6: ffff0ff0 DR7: 00000400
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Process watchdog/0 (pid: 9, ti=f5916000 task=f591eb40 task.ti=f5916000)
Stack:
Stack:
 c15bf1e0 c15bf1e0 f5917e38 f5917e38 c101fd0f c101fd0f c151443e c151443e f77d92e0 f77d92e0 f5917e6c f5917e6c c109ed12 c109ed12 c152164b c152164b

 0007afe4 0007afe4 00000046 00000046 f5917e54 f5917e54 c107f4db c107f4db f5917e64 f5917e64 fffffed4 fffffed4 00000000 00000000 f591eb40 f591eb40

 00000000 00000000 00000000 00000000 f5917e80 f5917e80 c103b6e6 c103b6e6 f77d8780 f77d8780 f77d8780 f77d8780 f5917f14 f5917f14 f5917e88 f5917e88

Call Trace:
Call Trace:
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c101fd0f>] arch_trigger_all_cpu_backtrace+0x3f/0x80
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c109ed12>] rcu_check_callbacks+0x162/0x530
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c107f4db>] ? trace_hardirqs_off+0xb/0x10
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c103b6e6>] update_process_times+0x36/0x70
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d8ba>] tick_periodic+0x6a/0x80
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c107d949>] tick_handle_periodic+0x19/0x70
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c101e9d3>] smp_apic_timer_interrupt+0x73/0x90
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c11b9890>] ? trace_hardirqs_off_thunk+0xc/0x1c
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c141a9bf>] apic_timer_interrupt+0x2f/0x34
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c1050341>] ? lock_hrtimer_base.isra.27+0x31/0x50
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c10503cc>] hrtimer_try_to_cancel+0x1c/0x90
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c105044f>] hrtimer_cancel+0xf/0x30
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1096d80>] watchdog_disable+0x40/0x80
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c1054382>] smpboot_thread_fn+0xc2/0x1a0
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c104c12f>] ? __kthread_parkme+0x4f/0x60
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c10542c0>] ? lg_global_lock+0xb0/0xb0
 [<c104c6ca>] kthread+0x8a/0x90
 [<c104c6ca>] kthread+0x8a/0x90
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410404>] ? slab_cpuup_callback+0x28/0xbe
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c1410000>] ? cpu_stop_cpu_callback+0x148/0x15a
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c104c640>] ? flush_kthread_worker+0x80/0x80
 [<c142087a>] kernel_thread_helper+0x6/0xd
 [<c142087a>] kernel_thread_helper+0x6/0xd
Code:Code: 00 00 b3 b3 ff ff ff ff 8b 8b 89 89 00 00 b3 b3 ff ff ff ff 80 80 e5 e5 10 10 75 75 e7 e7 89 89 f2 f2 81 81 ca ca 00 00 04 04 08 08 00 00 83 83 f8 f8 02 02 74 74 0a 0a 89 89 f2 f2 81 81 ca ca 00 00 00 00 08 08 00 00 09 09 c2 c2 89 89 d0 d0 89 89 03 03 5b 5b <5e> <5e> 5d 5d c3 c3 8b 8b 15 15 60 60 85 85 5b 5b c1 c1 55 55 89 89 e5 e5 53 53 8b 8b 5a 5a 24 24 8d 8d 76 76 00 00 8b 8b 15 15



--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc5 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
CONFIG_BROKEN_BOOT_DISALLOWED=y
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=m
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_INTEL_MID=y
CONFIG_X86_MDFLD=y
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=m
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=m
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
# CONFIG_BRIDGE_EBT_T_NAT is not set
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=m
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=m
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
CONFIG_BRIDGE_EBT_DNAT=m
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=m
CONFIG_NFC_NCI=m
# CONFIG_NFC_HCI is not set
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_PN544_NFC is not set
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_WILINK=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
# CONFIG_CONNECTOR is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
CONFIG_PCH_PHUB=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_AIC7XXX=y
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=m
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=m
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARASAN_CF=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=m
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=m
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
CONFIG_VETH=m
# CONFIG_VIRTIO_NET is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=m
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
# CONFIG_CHELSIO_T1_1G is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
CONFIG_IXGB=m
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
CONFIG_IP1000=m
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=m
CONFIG_KS8851=m
CONFIG_KS8851_MLL=m
CONFIG_KSZ884X_PCI=m
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_8139TOO=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=m
# CONFIG_NET_VENDOR_SILAN is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=m
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=m
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=m
# CONFIG_WIZNET_W5300 is not set
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_MICREL_KS8995MA=m
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_WLAN=y
CONFIG_LIBERTAS_THINFIRM=m
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=m
# CONFIG_ATH9K_PCI is not set
CONFIG_ATH9K_AHB=y
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=m
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=m
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
# CONFIG_IWLEGACY_DEBUGFS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
# CONFIG_RTL8192CU is not set
CONFIG_RTLWIFI=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
CONFIG_WL12XX=m
# CONFIG_WL18XX is not set
CONFIG_WLCORE=m
CONFIG_WLCORE_SPI=m
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=m
# CONFIG_WANXL is not set
CONFIG_PC300TOO=m
# CONFIG_FARSYNC is not set
CONFIG_DSCC4=m
# CONFIG_DSCC4_PCISYNC is not set
CONFIG_DSCC4_PCI_RST=y
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
# CONFIG_CYCLOMX_X25 is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
# CONFIG_VMXNET3 is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=m
CONFIG_KEYBOARD_TWL4030=m
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=m
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_INTEL_MID is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=m
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=m
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=m
CONFIG_INPUT_TWL4030_VIBRA=m
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
# CONFIG_NOZOMI is not set
CONFIG_ISI=m
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX3107=m
CONFIG_SERIAL_MRST_MAX3110=m
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_PCH_UART=m
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
# CONFIG_SPI_DW_MID_DMA is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_MSIC=y
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
CONFIG_BATTERY_INTEL_MID=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_TWL4030=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_AVS=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
CONFIG_UCB1400_CORE=m
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=m
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_PALMAS=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_ARIZONA=m
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPS11=m
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65090=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS65912=m
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m

#
# Media drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=m

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_TIMBERDALE is not set
CONFIG_SOC_CAMERA=m
# CONFIG_SOC_CAMERA_IMX074 is not set
# CONFIG_SOC_CAMERA_MT9M001 is not set
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
CONFIG_RADIO_SHARK2=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
# CONFIG_USB_KEENE is not set
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=m

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=m
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_AAT2870=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_RTCTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_SB_COMMON=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=m
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=m
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=m
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=m
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
CONFIG_SND_SIS7019=m
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=m
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=m
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=m
# CONFIG_SND_MFLD_MACHINE is not set
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_88PM860X=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADAU1373=m
CONFIG_SND_SOC_ADAV80X=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4641=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_ALC5632=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS42L52=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_JZ4740_CODEC=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DA732X=m
CONFIG_SND_SOC_DFBMCS320=m
CONFIG_SND_SOC_ISABELLE=m
CONFIG_SND_SOC_LM49453=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX98095=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_RT5631=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SN95031=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_STA32X=m
CONFIG_SND_SOC_STA529=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TLV320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_TWL6040=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WL1273=m
CONFIG_SND_SOC_WM1250_EV1=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM2200=m
CONFIG_SND_SOC_WM5100=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8782=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8983=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM8996=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9768=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_MC13783=m
CONFIG_SND_SOC_ML26124=m
CONFIG_SND_SOC_TPA6130A2=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=m
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=m
# CONFIG_SOUND_PSS is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=m
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=m
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TWL6030_USB=m
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM3556=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=m
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO=m
# CONFIG_VFIO_PCI is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=m
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_HP_ACCEL=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=m
# CONFIG_GPIO_INTEL_PMIC is not set
# CONFIG_INTEL_MID_POWER_BUTTON is not set
# CONFIG_INTEL_MFLD_THERMAL is not set
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_SAMPLES=y
CONFIG_SAMPLE_KOBJECT=m
# CONFIG_SAMPLE_KPROBES is not set
CONFIG_SAMPLE_HW_BREAKPOINT=m
# CONFIG_SAMPLE_KFIFO is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_INTEL_MID is not set
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
CONFIG_SECURITY_TOMOYO_POLICY_LOADER="/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER="/sbin/init"
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_DEFAULT_SECURITY_TOMOYO=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="tomoyo"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--fUYQa+Pmc3FrFX/N--
