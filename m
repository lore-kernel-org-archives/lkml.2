Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2JQRqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:46:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33833 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2JQRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 17 Oct 2012 13:46:09 -0400
X-Google-Sender-Auth: SG_uQSjC_o_t5S2ce64EWBDJkgI
Message-ID: <CAOvdn6WBj_-=3Z=ZrD670Zup4H=pvjXknvHGgjs55k3LWJyDxQ@mail.gmail.com>
Subject: Re: [RFC] ACPI S3 and Xen (suprisingly small\!).
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 9:49 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
[...]

> The end result is this is a nice set of patches where there is only
> _one_ change in the x86 code (and it is just more of dealing with
> error case) - and the rest are all done in Xen side.

I'm sorry to report that this series doesn't seem to work in my setup
against xen-unstable.

To verify that it was, in fact this patch series, and not another Xen
regression - I swapped out the kernel with this patch series, with an
identical one, replacing only this series with your acpi-s3.v9 branch
- and everything worked fine.

serial capture from bad run pasted below.



(XEN) Xen version 4.3-unstable (bguthro@) (gcc (Ubuntu/Linaro
4.6.3-1ubuntu5) 4.6.3) Wed Oct 17 08:53:46 EDT 2012
(XEN) Latest ChangeSet: unavailable
(XEN) Bootloader: GRUB 1.99-21ubuntu3+orc1
(XEN) Command line: com1=115200,8n1,pci console=com1
dom0_mem=auto:620M^30M cpufreq=xen cpuidle e820-verbose=1
dom0_vcpus_pin
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: V2; EDID transfer time: 1 seconds
(XEN) Disc information:
(XEN)  Found 1 MBR signatures
(XEN)  Found 1 EDD information structures
(XEN) Initial Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009ac00 (usable)
(XEN)  000000000009ac00 - 00000000000a0000 (reserved)
(XEN)  00000000000e0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 0000000020000000 (usable)
(XEN)  0000000020000000 - 0000000020200000 (reserved)
(XEN)  0000000020200000 - 0000000040004000 (usable)
(XEN)  0000000040004000 - 0000000040005000 (reserved)
(XEN)  0000000040005000 - 00000000a8584000 (usable)
(XEN)  00000000a8584000 - 00000000a85c7000 (reserved)
(XEN)  00000000a85c7000 - 00000000aa58a000 (usable)
(XEN)  00000000aa58a000 - 00000000aad6a000 (reserved)
(XEN)  00000000aad6a000 - 00000000aafea000 (ACPI NVS)
(XEN)  00000000aafea000 - 00000000aafff000 (ACPI data)
(XEN)  00000000aafff000 - 00000000ab000000 (usable)
(XEN)  0000000100000000 - 000000014e600000 (usable)
(XEN)  00000000ab000000 - 00000000afa00000 (reserved)
(XEN)  00000000f8000000 - 00000000fc000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec01000 (reserved)
(XEN)  00000000fed10000 - 00000000fed14000 (reserved)
(XEN)  00000000fed18000 - 00000000fed1a000 (reserved)
(XEN)  00000000fed1c000 - 00000000fed20000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000ff900000 - 00000000ffc00000 (reserved)
(XEN)  00000000ffd00000 - 0000000100000000 (reserved)
(XEN) Checking MTRR ranges...
(XEN)  MTRR cap: d0a type: c00
(XEN)  MTRR[0]: base 6 mask f80000800
(XEN)  MTRR[1]: base 80000006 mask fe0000800
(XEN)  MTRR[2]: base a0000006 mask ff8000800
(XEN)  MTRR[3]: base a8000006 mask ffe000800
(XEN)  MTRR[4]: base aa000006 mask fff000800
(XEN)  MTRR[5]: base 100000006 mask fc0000800
(XEN)  MTRR[6]: base 140000006 mask ff0000800
(XEN)  MTRR[7]: base 14f000000 mask fff000800
(XEN)  MTRR[8]: base 14e800000 mask fff800800
(XEN)  MTRR[9]: base 14e600000 mask fffe00800
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009ac00 (usable)
(XEN)  000000000009ac00 - 00000000000a0000 (reserved)
(XEN)  00000000000e0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 0000000020000000 (usable)
(XEN)  0000000020000000 - 0000000020200000 (reserved)
(XEN)  0000000020200000 - 0000000040004000 (usable)
(XEN)  0000000040004000 - 0000000040005000 (reserved)
(XEN)  0000000040005000 - 00000000a8584000 (usable)
(XEN)  00000000a8584000 - 00000000a85c7000 (reserved)
(XEN)  00000000a85c7000 - 00000000aa58a000 (usable)
(XEN)  00000000aa58a000 - 00000000aad6a000 (reserved)
(XEN)  00000000aad6a000 - 00000000aafea000 (ACPI NVS)
(XEN)  00000000aafea000 - 00000000aafff000 (ACPI data)
(XEN)  00000000aafff000 - 00000000ab000000 (usable)
(XEN)  00000000ab000000 - 00000000afa00000 (reserved)
(XEN)  00000000f8000000 - 00000000fc000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec01000 (reserved)
(XEN)  00000000fed10000 - 00000000fed14000 (reserved)
(XEN)  00000000fed18000 - 00000000fed1a000 (reserved)
(XEN)  00000000fed1c000 - 00000000fed20000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000ff900000 - 00000000ffc00000 (reserved)
(XEN)  00000000ffd00000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 000000014e600000 (usable)
(XEN) ACPI: RSDP 000F0410, 0024 (r2  INTEL)
(XEN) ACPI: XSDT AAFFDE18, 0074 (r1  INTEL  IVB-CPT  6222004 MSFT    10013)
(XEN) ACPI: FACP AAFE3D98, 00F4 (r4  INTEL  IVB-CPT  6222004 MSFT    10013)
(XEN) ACPI: DSDT AAFBC018, 1082F (r2  INTEL  IVB-CPT        0 INTL 20110623)
(XEN) ACPI: FACS AAFE9E40, 0040
(XEN) ACPI: APIC AAFFCF18, 00CC (r2  INTEL  IVB-CPT  6222004 MSFT    10013)
(XEN) ACPI: HPET AAFE8F18, 0038 (r1 A M I   PCHHPET  6222004 AMI.        3)
(XEN) ACPI: SSDT AAFE5018, 10A8 (r1 TrmRef PtidDevc     1000 INTL 20110623)
(XEN) ACPI: SSDT AAFE4A18, 0461 (r1    AMI PerfTune     1000 INTL 20110623)
(XEN) ACPI: MCFG AAFE8E98, 003C (r1 INTEL  SNDYBRDG  6222004 MSFT       97)
(XEN) ACPI: SSDT AAFD1818, 079A (r1  PmRef  Cpu0Ist     3000 INTL 20110623)
(XEN) ACPI: SSDT AAFD0018, 0A92 (r1  PmRef    CpuPm     3000 INTL 20110623)
(XEN) ACPI: DMAR AAFE4F18, 00B8 (r1 INTEL      SNB         1 INTL        1)
(XEN) ACPI: FPDT AAFF4018, 0064 (r1  INTEL  IVB-CPT    10000 INTL 20111107)
(XEN) System RAM: 3976MB (4072324kB)
(XEN) No NUMA configuration found
(XEN) Faking a node at 0000000000000000-000000014e600000
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000fcaa0
(XEN) DMI 2.6 present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x408
(XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[404,0], pm1x_evt[400,0]
(XEN) ACPI: 32/64X FACS address mismatch in FADT -
aafe9e40/0000000000000000, using 32
(XEN) ACPI:                  wakeup_vec[aafe9e4c], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
(XEN) Processor #0 7:10 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 7:10 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
(XEN) Processor #4 7:10 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
(XEN) Processor #6 7:10 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
(XEN) ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) ACPI: IRQ9 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x8086a701 base: 0xfed00000
(XEN) Table is not found!
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) SMP: Allowing 16 CPUs (12 hotplug CPUs)
(XEN) IRQ limits: 24 GSI, 760 MSI/MSI-X
(XEN) Switched to APIC driver x2apic_cluster.
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2195.065 MHz processor.
(XEN) Initing memory sharing.
(XEN) mce_intel.c:721: MCA Capability: BCAST 1 SER 0 CMCI 1 firstbank
0 extended MCE MSR 0
(XEN) Intel machine check reporting enabled
(XEN) PCI: MCFG configuration 0: base f8000000 segment 0000 buses 00 - 3f
(XEN) PCI: MCFG area at f8000000 reserved in E820
(XEN) PCI: Using MCFG for segment 0000 bus 00-3f
(XEN) Intel VT-d supported page sizes: 4kB.
(XEN) Intel VT-d supported page sizes: 4kB.
(XEN) Intel VT-d Snoop Control not enabled.
(XEN) Intel VT-d Dom0 DMA Passthrough not enabled.
(XEN) Intel VT-d Queued Invalidation enabled.
(XEN) Intel VT-d Interrupt Remapping enabled.
(XEN) Intel VT-d Shared EPT tables not enabled.
(XEN) I/O virtualisation enabled
(XEN)  - Dom0 mode: Relaxed
(XEN) Enabled directed EOI with ioapic_ack_old on!
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using old ACK method
(XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
(XEN) TSC deadline timer enabled
(XEN) Platform timer is 14.318MHz HPET
(XEN) Allocated console ring of 32 KiB.
(XEN) mwait-idle: MWAIT substates: 0x1120
(XEN) mwait-idle: v0.4 model 0x3a
(XEN) mwait-idle: lapic_timer_reliable_states 0xffffffff
(XEN) VMX: Supported advanced features:
(XEN)  - APIC MMIO access virtualisation
(XEN)  - APIC TPR shadow
(XEN)  - Extended Page Tables (EPT)
(XEN)  - Virtual-Processor Identifiers (VPID)
(XEN)  - Virtual NMI
(XEN)  - MSR direct-access bitmap
(XEN)  - Unrestricted Guest
(XEN) HVM: ASIDs enabled.
(XEN) HVM: VMX enabled
(XEN) HVM: Hardware Assisted Paging (HAP) detected
(XEN) HVM: HAP page sizes: 4kB, 2MB
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) Brought up 4 CPUs
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) ACPI sleep modes: S3
(XEN) mcheck_poll: Machine check polling timer started.
(XEN) *** LOADING DOMAIN 0 ***
(XEN) elf_parse_binary: phdr: paddr=0x1000000 memsz=0x8a2000
(XEN) elf_parse_binary: phdr: paddr=0x1a00000 memsz=0xb30f0
(XEN) elf_parse_binary: phdr: paddr=0x1ab4000 memsz=0x14600
(XEN) elf_parse_binary: phdr: paddr=0x1ac9000 memsz=0x62b000
(XEN) elf_parse_binary: memory: 0x1000000 -> 0x20f4000
(XEN) elf_xen_parse_note: GUEST_OS = "linux"
(XEN) elf_xen_parse_note: GUEST_VERSION = "2.6"
(XEN) elf_xen_parse_note: XEN_VERSION = "xen-3.0"
(XEN) elf_xen_parse_note: VIRT_BASE = 0xffffffff80000000
(XEN) elf_xen_parse_note: ENTRY = 0xffffffff81ac9210
(XEN) elf_xen_parse_note: HYPERCALL_PAGE = 0xffffffff81001000
(XEN) elf_xen_parse_note: FEATURES = "!writable_page_tables|pae_pgdir_above_4gb"
(XEN) elf_xen_parse_note: PAE_MODE = "yes"
(XEN) elf_xen_parse_note: LOADER = "generic"
(XEN) elf_xen_parse_note: unknown xen elf note (0xd)
(XEN) elf_xen_parse_note: SUSPEND_CANCEL = 0x1
(XEN) elf_xen_parse_note: HV_START_LOW = 0xffff800000000000
(XEN) elf_xen_parse_note: PADDR_OFFSET = 0x0
(XEN) elf_xen_addr_calc_check: addresses:
(XEN)     virt_base        = 0xffffffff80000000
(XEN)     elf_paddr_offset = 0x0
(XEN)     virt_offset      = 0xffffffff80000000
(XEN)     virt_kstart      = 0xffffffff81000000
(XEN)     virt_kend        = 0xffffffff820f4000
(XEN)     virt_entry       = 0xffffffff81ac9210
(XEN)     p2m_base         = 0xffffffffffffffff
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x20f4000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000140000000->0000000144000000 (161339 pages
to be allocated)
(XEN)  Init. ramdisk: 000000014bd49000->000000014e5ffc00
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff820f4000
(XEN)  Init. ramdisk: ffffffff820f4000->ffffffff849aac00
(XEN)  Phys-Mach map: ffffffff849ab000->ffffffff84b1a790
(XEN)  Start info:    ffffffff84b1b000->ffffffff84b1b4b4
(XEN)  Page tables:   ffffffff84b1c000->ffffffff84b45000
(XEN)  Boot stack:    ffffffff84b45000->ffffffff84b46000
(XEN)  TOTAL:         ffffffff80000000->ffffffff84c00000
(XEN)  ENTRY ADDRESS: ffffffff81ac9210
(XEN) Dom0 has maximum 4 VCPUs
(XEN) elf_load_binary: phdr 0 at 0xffffffff81000000 -> 0xffffffff818a2000
(XEN) elf_load_binary: phdr 1 at 0xffffffff81a00000 -> 0xffffffff81ab30f0
(XEN) elf_load_binary: phdr 2 at 0xffffffff81ab4000 -> 0xffffffff81ac8600
(XEN) elf_load_binary: phdr 3 at 0xffffffff81ac9000 -> 0xffffffff81b9a000
(XEN) Scrubbing Free RAM: ................................done.
(XEN) Initial low memory virq threshold set at 0x4000 pages.
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch
input to Xen)
(XEN) Freed 268kB init memory.
mapping kernel into physical memory
about to get started...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-orc (bguthro@bguthro-desktop) (gcc
version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #7 SMP Wed Oct 17
13:02:38 EDT 2012
[    0.000000] Command line:
root=/dev/mapper/NxVG--eb56f027--0aeb--4e9a--9233--678d57b9dc9e-NxDisk6
ro xencons=tty console=hvc0
[    0.000000] Freeing 9a-100 pfn range: 102 pages freed
[    0.000000] Freeing 20000-20200 pfn range: 512 pages freed
[    0.000000] Released 614 pages of unused memory
[    0.000000] Set 351519 page(s) to 1-1 mapping
[    0.000000] Populating 2def2-2e158 pfn range: 614 pages added
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x0000000000099fff] usable
[    0.000000] Xen: [mem 0x000000000009ac00-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] Xen: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] Xen: [mem 0x0000000020200000-0x000000002e157fff] usable
[    0.000000] Xen: [mem 0x000000002e158000-0x0000000040003fff] unusable
[    0.000000] Xen: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] Xen: [mem 0x0000000040005000-0x00000000a8583fff] unusable
[    0.000000] Xen: [mem 0x00000000a8584000-0x00000000a85c6fff] reserved
[    0.000000] Xen: [mem 0x00000000a85c7000-0x00000000aa589fff] unusable
[    0.000000] Xen: [mem 0x00000000aa58a000-0x00000000aad69fff] reserved
[    0.000000] Xen: [mem 0x00000000aad6a000-0x00000000aafe9fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000aafea000-0x00000000aaffefff] ACPI data
[    0.000000] Xen: [mem 0x00000000aafff000-0x00000000aaffffff] unusable
[    0.000000] Xen: [mem 0x00000000ab000000-0x00000000af9fffff] reserved
[    0.000000] Xen: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] Xen: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] Xen: [mem 0x00000000ff900000-0x00000000ffbfffff] reserved
[    0.000000] Xen: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000014e5fffff] unusable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x2e158 max_arch_pfn = 0x400000000
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] init_memory_mapping: [mem 0x00000000-0x2e157fff]
[    0.000000] RAMDISK: [mem 0x020f4000-0x049aafff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000aaffde18 00074 (v01  INTEL  IVB-CPT
06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000aafe3d98 000F4 (v04  INTEL  IVB-CPT
06222004 MSFT 00010013)
[    0.000000] ACPI: DSDT 00000000aafbc018 1082F (v02  INTEL  IVB-CPT
00000000 INTL 20110623)
[    0.000000] ACPI: FACS 00000000aafe9e40 00040
[    0.000000] ACPI: APIC 00000000aaffcf18 000CC (v02  INTEL  IVB-CPT
06222004 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000aafe8f18 00038 (v01 A M I   PCHHPET
06222004 AMI. 00000003)
[    0.000000] ACPI: SSDT 00000000aafe5018 010A8 (v01 TrmRef PtidDevc
00001000 INTL 20110623)
[    0.000000] ACPI: SSDT 00000000aafe4a18 00461 (v01    AMI PerfTune
00001000 INTL 20110623)
[    0.000000] ACPI: MCFG 00000000aafe8e98 0003C (v01 INTEL  SNDYBRDG
06222004 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000aafd1818 0079A (v01  PmRef  Cpu0Ist
00003000 INTL 20110623)
[    0.000000] ACPI: SSDT 00000000aafd0018 00A92 (v01  PmRef    CpuPm
00003000 INTL 20110623)
[    0.000000] ACPI: XMAR 00000000aafe4f18 000B8 (v01 INTEL      SNB
00000001 INTL 00000001)
[    0.000000] ACPI: FPDT 00000000aaff4018 00064 (v01  INTEL  IVB-CPT
00010000 INTL 20111107)
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x2e157fff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 12 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] e820: [mem 0xafa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.3-unstable (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64
nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88002da00000 s83456
r8192 d23040 u131072
[    1.854461] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 185174
[    1.854464] Kernel command line:
root=/dev/mapper/NxVG--eb56f027--0aeb--4e9a--9233--678d57b9dc9e-NxDisk6
ro xencons=tty console=hvc0
[    1.854903] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    1.854969] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.855248] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    1.855369] __ex_table already sorted, skipping sort
[    1.884622] software IO TLB [mem 0x28c00000-0x2cbfffff] (64MB)
mapped at [ffff880028c00000-ffff88002cbfffff]
[    1.886801] Memory: 612908k/755040k available (5817k kernel code,
2520k absent, 139612k reserved, 5136k data, 896k init)
[    1.886877] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    1.886905] Hierarchical RCU implementation.
[    1.886906] 	RCU dyntick-idle grace-period acceleration is enabled.
[    1.886907] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    1.886916] NR_IRQS:4352 nr_irqs:712 16
[    1.886989] xen: sci override: global_irq=9 trigger=0 polarity=0
[    1.887024] xen: acpi sci 9
[    1.888406] Console: colour VGA+ 80x25
[    1.888704] console [hvc0] enabled
[    1.888728] installing Xen timer for CPU 0
[    1.888755] tsc: Detected 2195.064 MHz processor
[    1.888761] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4390.12 BogoMIPS (lpj=21950640)
[    1.888768] pid_max: default: 32768 minimum: 301
[    1.888860] Mount-cache hash table entries: 256
[    1.889088] Initializing cgroup subsys cpuacct
[    1.889093] Initializing cgroup subsys devices
[    1.889096] Initializing cgroup subsys freezer
[    1.889100] Initializing cgroup subsys net_cls
[    1.889168] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    1.889168] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    1.889177] CPU: Physical Processor ID: 0
[    1.889179] CPU: Processor Core ID: 0
[    1.889591] mce: CPU supports 2 MCE banks
(XEN) traps.c:2485:d0 Domain attempted WRMSR 000000000000082f from
0x00000000000000f2 to 0x00000000000000f9.
[    1.889624] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    1.889624] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    1.889624] tlb_flushall_shift: 1
[    1.889739] Freeing SMP alternatives: 20k freed
[    1.891834] ACPI: Core revision 20120913
[    1.908378] ftrace: allocating 21833 entries in 86 pages
[    1.919224] cpu 0 spinlock event irq 41
[    1.919242] Performance Events: unsupported p6 CPU model 58 no PMU
driver, software events only.
[    1.920070] installing Xen timer for CPU 1
[    1.920082] cpu 1 spinlock event irq 48
(XEN) traps.c:2485:d0 Domain attempted WRMSR 000000000000082f from
0x00000000000000f2 to 0x00000000000000f9.
[    1.920805] installing Xen timer for CPU 2
[    1.920815] cpu 2 spinlock event irq 55
(XEN) traps.c:2485:d0 Domain attempted WRMSR 000000000000082f from
0x00000000000000f2 to 0x00000000000000f9.
[    1.921556] installing Xen timer for CPU 3
[    1.921566] cpu 3 spinlock event irq 62
(XEN) traps.c:2485:d0 Domain attempted WRMSR 000000000000082f from
0x00000000000000f2 to 0x00000000000000f9.
[    1.922256] Brought up 4 CPUs
[    1.922685] devtmpfs: initialized
[    1.922949] PM: Registering ACPI NVS region [mem
0xaad6a000-0xaafe9fff] (2621440 bytes)
[    1.923631] Grant tables using version 2 layout.
[    1.923646] Grant table initialized
[    1.923694] regulator-dummy: no parameters
[    1.923742] RTC time: 17:32:37, date: 10/17/12
[    1.923777] NET: Registered protocol family 16
[    1.924024] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    1.924030] ACPI: bus type pci registered
[    1.924147] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    1.924153] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    1.937145] PCI: Using configuration type 1 for base access
[    1.937864] bio: create slab <bio-0> at 0
[    1.937979] ACPI: Added _OSI(Module Device)
[    1.937983] ACPI: Added _OSI(Processor Device)
[    1.937986] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.937990] ACPI: Added _OSI(Processor Aggregator Device)
[    1.943414] ACPI: Executed 1 blocks of module-level executable AML code
[    1.961910] ACPI: SSDT 00000000aaccd018 00A4F (v01  PmRef  Cpu0Cst
00003001 INTL 20110623)
[    1.962563] ACPI: Dynamic OEM Table Load:
[    1.962568] ACPI: SSDT           (null) 00A4F (v01  PmRef  Cpu0Cst
00003001 INTL 20110623)
[    2.001604] ACPI: SSDT 00000000aaccea98 00303 (v01  PmRef    ApIst
00003000 INTL 20110623)
[    2.002283] ACPI: Dynamic OEM Table Load:
[    2.002287] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
00003000 INTL 20110623)
[    2.041649] ACPI: SSDT 00000000aacccd98 00119 (v01  PmRef    ApCst
00003000 INTL 20110623)
[    2.042297] ACPI: Dynamic OEM Table Load:
[    2.042302] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
00003000 INTL 20110623)
[    2.082598] ACPI: Interpreter enabled
[    2.082605] ACPI: (supports S0 S1 S3 S4 S5)
[    2.082631] ACPI: Using IOAPIC for interrupt routing
[    2.088693] ACPI: Power Resource [FN00] (off)
[    2.088768] ACPI: Power Resource [FN01] (off)
[    2.088848] ACPI: Power Resource [FN02] (off)
[    2.088921] ACPI: Power Resource [FN03] (off)
[    2.088992] ACPI: Power Resource [FN04] (off)
[    2.089894] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    2.089901] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    2.090503] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    2.091264] PCI host bridge to bus 0000:00
[    2.091269] pci_bus 0000:00: root bus resource [bus 00-3e]
[    2.091273] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.091277] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.091281] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.091285] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    2.091289] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    2.091293] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    2.091297] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    2.091301] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    2.091305] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    2.091309] pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfeafffff]
[    2.095857] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.096587] pci 0000:00:1c.6: PCI bridge to [bus 02]
[    2.097102] pci 0000:00:1c.7: PCI bridge to [bus 03-04]
[    2.097749] pci 0000:03:00.0: PCI bridge to [bus 04]
[    2.098158] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    2.098677]  pci0000:00: ACPI _OSC support notification failed,
disabling PCIe ASPM
[    2.098682]  pci0000:00: Unable to request _OSC control (_OSC
support mask: 0x08)
(XEN) PCI add device 0000:00:00.0
(XEN) PCI add device 0000:00:02.0
(XEN) PCI add device 0000:00:14.0
(XEN) PCI add device 0000:00:16.0
(XEN) PCI add device 0000:00:16.3
(XEN) PCI add device 0000:00:19.0
(XEN) PCI add device 0000:00:1a.0
(XEN) PCI add device 0000:00:1b.0
(XEN) PCI add device 0000:00:1c.0
(XEN) PCI add device 0000:00:1c.6
(XEN) PCI add device 0000:00:1c.7
(XEN) PCI add device 0000:00:1d.0
(XEN) PCI add device 0000:00:1e.0
(XEN) PCI add device 0000:00:1f.0
(XEN) PCI add device 0000:00:1f.2
(XEN) PCI add device 0000:00:1f.3
(XEN) PCI add device 0000:02:00.0
(XEN) PCI add device 0000:03:00.0
(XEN) PCI add device 0000:04:00.0
(XEN) PCI add device 0000:05:01.0
[    2.104211] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.104279] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    2.104348] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    2.104414] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.104480] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    2.104544] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    2.104612] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    2.104676] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.104716] xen/balloon: Initialising balloon driver.
[    2.104855] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.104869] vgaarb: loaded
[    2.104871] vgaarb: bridge control possible 0000:00:02.0
[    2.104950] SCSI subsystem initialized
[    2.104954] ACPI: bus type scsi registered
[    2.105131] ACPI: bus type usb registered
[    2.105151] usbcore: registered new interface driver usbfs
[    2.105162] usbcore: registered new interface driver hub
[    2.105304] usbcore: registered new device driver usb
[    2.105513] wmi: Mapper loaded
[    2.105519] PCI: Using ACPI for IRQ routing
[    2.111086] Switching to clocksource xen
[    2.116428] pnp: PnP ACPI init
[    2.116439] ACPI: bus type pnp registered
[    2.117207] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.117212] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.117216] system 00:05: [io  0xffff] has been reserved
[    2.117219] system 00:05: [io  0xffff] has been reserved
[    2.117223] system 00:05: [io  0x0400-0x0453] has been reserved
[    2.117227] system 00:05: [io  0x0458-0x047f] has been reserved
[    2.117231] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.117235] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.117330] system 00:07: [io  0x0454-0x0457] has been reserved
[    2.117721] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.117726] system 00:08: [mem 0xfed10000-0xfed17fff] could not be reserved
[    2.117730] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.117735] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.117739] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.117743] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.117748] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.117753] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.117757] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    2.117762] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    2.117766] system[    3.281195] usb 3-3: new low-speed USB device
number 2 using xhci_hcd
[    3.282603] bio: create slab <bio-1> at 1
[    3.304654] usb 3-3: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    3.311353] usbcore: registered new interface driver usbhid
[    3.311360] usbhid: USB HID core driver
[    3.421244] usb 3-4: new low-speed USB device number 3 using xhci_hcd
Begin: Running /scripts/local-premount ... [    3.448335] usb 3-4: ep
0x81 - rounding interval to 128 microframes, ep desc says 192
microframes
done.
[    3.523331] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: (null)
Begin: Running /scripts/local-bottom ... done.
done.
Begin: Running /scripts/init-bottom ... udevd[290]:
inotify_add_watch(6, /dev/dm-6, 10) failed: Invalid argument

done.
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7

NxTop Engine (99.99.pre-121017-1309-bguthro) poison-ivy hvc0

poison-ivy login: root (automatic login)
Last login: Wed Oct 17 17:27:26 UTC 2012 from
bguthro-desktop.oldroadcomputing.net on pts/8
Welcome to NxTop Engine (GNU/Linux 3.7.0-orc x86_64)

root@poison-ivy:~#
root@poison-ivy:~#
root@poison-ivy:~# [   13.645342] irq 22: nobody cared (try booting
with the "irqpoll" option)
[   13.645442] handlers:
[   13.645446] [<ffffffff81394fe0>] serial8250_interrupt
[   13.645449] Disabling IRQ #22

root@poison-ivy:~#
root@poison-ivy:~#
root@poison-ivy:~# [   26.153266] irq 22: nobody cared (try booting
with the "irqpoll" option)
[   26.153341] handlers:
[   26.153345] [<ffffffff81394fe0>] serial8250_interrupt
[   26.153349] Disabling IRQ #22
(XEN) Preparing system for ACPI S3 state.
(XEN) Disabling non-boot CPUs ...
(XEN) Breaking vcpu affinity for domain 0 vcpu 2
(XEN) Breaking vcpu affinity for domain 0 vcpu 3
(XEN) Entering ACPI S3 state.
(XEN) mce_intel.c:721: MCA Capability: BCAST 1 SER 0 CMCI 1 firstbank
0 extended MCE MSR 0
(XEN) CPU0 CMCI LVT vector (0xf2) already installed
(XEN) Finishing wakeup from ACPI S3 state.
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) Enabling non-boot CPUs  ...
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) microcode: collect_cpu_info : sig=0x306a4, pf=0x2, rev=0x7
(XEN) mm.c:587:d0 Could not get page ref for pfn ffffffffffffffff
(XEN) mm.c:2571:d0 Error while installing new baseptr ffffffffffffffff
(XEN) mm.c:2265:d0 Bad type (saw 4400000000000001 != exp
7000000000000000) for mfn 13db97 (pfn 26eb2)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13db97 (pfn 26eb2) from L1 entry
800000013db97063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 3400000000000002 != exp
7000000000000000) for mfn 13edc4 (pfn 28085)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13edc4 (pfn 28085) from L1 entry
800000013edc4063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 2400000000000001 != exp
7000000000000000) for mfn 13e625 (pfn 27c24)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13e625 (pfn 27c24) from L1 entry
800000013e625063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 13e886 (pfn 27dc3)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13e886 (pfn 27dc3) from L1 entry
800000013e886063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 13ebfa (pfn 27e4f)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13ebfa (pfn 27e4f) from L1 entry
800000013ebfa063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 14d52f (pfn 38da)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14d52f (pfn 38da) from L1 entry
800000014d52f063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 3400000000000002 != exp
7000000000000000) for mfn 13e5a1 (pfn 278a8)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13e5a1 (pfn 278a8) from L1 entry
800000013e5a1063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 2400000000000001 != exp
7000000000000000) for mfn 14dba6 (pfn 3f51)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14dba6 (pfn 3f51) from L1 entry
800000014dba6063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 13da86 (pfn 26fc3)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13da86 (pfn 26fc3) from L1 entry
800000013da86063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 14d50a (pfn 38b5)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14d50a (pfn 38b5) from L1 entry
800000014d50a063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 14d0a7 (pfn 3452)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14d0a7 (pfn 3452) from L1 entry
800000014d0a7063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 14d6e7 (pfn 3a92)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14d6e7 (pfn 3a92) from L1 entry
800000014d6e7063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 3400000000000002 != exp
7000000000000000) for mfn 14dafd (pfn 3ea8)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14dafd (pfn 3ea8) from L1 entry
800000014dafd063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 2400000000000001 != exp
7000000000000000) for mfn 13d598 (pfn 268b1)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13d598 (pfn 268b1) from L1 entry
800000013d598063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 1400000000000001 != exp
7000000000000000) for mfn 13daa1 (pfn 26fa8)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 13daa1 (pfn 26fa8) from L1 entry
800000013daa1063 for l1e_owner=0, pg_owner=0
(XEN) mm.c:2265:d0 Bad type (saw 4400000000000001 != exp
7000000000000000) for mfn 14d0d5 (pfn 3480)
(XEN) mm.c:812:d0 Could not get page type PGT_writable_page
(XEN) mm.c:864:d0 Error getting mfn 14d0d5 (pfn 3480) from L1 entry
800000014d0d5063 for l1e_owner=0, pg_owner=0
