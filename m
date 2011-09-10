Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab1IJSsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 14:48:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41211 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933708Ab1IJSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 14:48:14 -0400
Message-ID: <4E6BB0E8.9070005@gmail.com>
Date: Sat, 10 Sep 2011 20:48:08 +0200
From: Anders <aeriksson2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110902 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jarod@wilsonet.com>, Jarod Wilson <jarod@redhat.com>
CC: linux-kernel@vger.kernel.org,
        "lirc-list@lists.sourceforge.net" <lirc-list@lists.sourceforge.net>,
        linux-media@vger.kernel.org
Subject: Re: 3.0.1. imon locking issues?
References: <4E63CB51.7030907@gmail.com> <20110909162245.c1f85760.akpm@linux-foundation.org>
In-Reply-To: <20110909162245.c1f85760.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a new one like this today, attached.

/A

On 09/10/11 01:22, Andrew Morton wrote:
> (cc's added)
> 
> On Sun, 04 Sep 2011 21:02:41 +0200
> Anders <aeriksson2@gmail.com> wrote:
> 
>> Found this oops produced by kdump here. It seems imon related.
>> 
>>
>> ...
>>
>> <4>[  278.893189] Restarting tasks ... done.
>> <6>[  278.994452] usb 5-1: USB disconnect, device number 2
>> <3>[  278.995191] imon:send_packet: error submitting urb(-19)
>> <3>[  279.000016] imon:vfd_write: send packet failed for packet #3
>> <3>[  279.000028] imon:vfd_write: no iMON device present
>> <3>[  279.000032] imon:vfd_write: no iMON device present
>> <3>[  279.000036] imon:vfd_write: no iMON device present
>> <3>[  279.000040] imon:vfd_write: no iMON device present
>> <3>[  279.000044] imon:vfd_write: no iMON device present
>> <3>[  279.000048] imon:vfd_write: no iMON device present
>> <3>[  279.000053] imon:vfd_write: no iMON device present
>> <3>[  279.000057] imon:vfd_write: no iMON device present
>> <3>[  279.000061] imon:vfd_write: no iMON device present
>> <3>[  279.000065] imon:vfd_write: no iMON device present
>> <3>[  279.000069] imon:vfd_write: no iMON device present
>> <3>[  279.000073] imon:vfd_write: no iMON device present
>> <3>[  279.000077] imon:vfd_write: no iMON device present
>> <3>[  279.000081] imon:vfd_write: no iMON device present
>> <3>[  279.000085] imon:vfd_write: no iMON device present
>> <0>[  279.042361] stack segment: 0000 [#1] PREEMPT SMP
>> <4>[  279.042450] CPU 1
>> <4>[  279.042482] Modules linked in: saa7134_alsa tda1004x saa7134_dvb
>> videobuf_dvb dvb_core ir_kbd_i2c tda827x ir_lirc_codec lirc_dev tda8290
>> ir_sony_decoder tuner ir_jvc_decoder snd_hda_codec_realtek
>> ir_rc6_decoder saa7134 videobuf_dma_sg videobuf_core v4l2_common
>> rc_imon_mce imon ir_rc5_decoder ir_nec_decoder rc_core videodev
>> snd_hda_intel parport_pc snd_hda_codec v4l2_compat_ioctl32 parport
>> tveeprom snd_hwdep i2c_piix4 sg pcspkr rtc_cmos atiixp asus_atk0110
>> <4>[  279.043219]
>> <4>[  279.043242] Pid: 1922, comm: LCDd Not tainted 3.0.1-dirty #24
>> System manufacturer System Product Name/M2A-VM HDMI
>> <4>[  279.043318] RIP: 0010:[<ffffffff810231bb>]  [<ffffffff810231bb>]
>> mutex_spin_on_owner+0x3e/0x63
>> <4>[  279.043318] RSP: 0018:ffff88004a1c3e00  EFLAGS: 00010246
>> <4>[  279.043318] RAX: ffff880074118cf0 RBX: ffff8800725d0020 RCX:
>> 0000000000000000
>> <4>[  279.043318] RDX: ffff8800725d0038 RSI: 65766f6d65723d4e RDI:
>> ffff8800725d0020
>> <4>[  279.043318] RBP: 65766f6d65723d4e R08: 0000000000000000 R09:
>> ffff88007308fe40
>> <4>[  279.043318] R10: 0000000000000001 R11: 0000000000000246 R12:
>> 0000000000000000
>> <4>[  279.043318] R13: ffff88004a1c2010 R14: ffff88004a1c2010 R15:
>> 0000000000000001
>> <4>[  279.043318] FS:  00007f9c84ed5700(0000) GS:ffff880077c80000(0000)
>> knlGS:0000000000000000
>> <4>[  279.043318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <4>[  279.043318] CR2: 00007eff71e392a0 CR3: 00000000730f9000 CR4:
>> 00000000000006e0
>> <4>[  279.043318] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> <4>[  279.043318] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> <4>[  279.043318] Process LCDd (pid: 1922, threadinfo ffff88004a1c2000,
>> task ffff880074118cf0)
>> <0>[  279.043318] Stack:
>> <4>[  279.043318]  0000000000000286 ffff8800725d0020 ffff880074118cf0
>> 65766f6d65723d4e
>> <4>[  279.043318]  0000000000000000 ffffffff814c14dc 0000000000000000
>> ffff8800725d0038
>> <4>[  279.043318]  ffffffff81048211 ffff88004a1c3ed8 0000000000000286
>> ffff880074118cf0
>> <0>[  279.043318] Call Trace:
>> <4>[  279.043318]  [<ffffffff814c14dc>] ? __mutex_lock_slowpath+0x57/0x17f
>> <4>[  279.043318]  [<ffffffff81048211>] ? lock_hrtimer_base+0x1b/0x3c
>> <4>[  279.043318]  [<ffffffff810482d1>] ? hrtimer_try_to_cancel+0x63/0x6c
>> <4>[  279.043318]  [<ffffffff814c1404>] ? mutex_lock+0x12/0x22
>> <4>[  279.043318]  [<ffffffff814c1a8a>] ? do_nanosleep+0x77/0xb0
>> <4>[  279.043318]  [<ffffffffa0100805>] ? vfd_write+0x63/0x1bd [imon]
>> <4>[  279.043318]  [<ffffffff8104877d>] ? hrtimer_nanosleep+0x9c/0x108
>> <4>[  279.043318]  [<ffffffff810b22cb>] ? vfs_write+0xad/0x12e
>> <4>[  279.043318]  [<ffffffff810b2402>] ? sys_write+0x45/0x6e
>> <4>[  279.043318]  [<ffffffff814c317b>] ? system_call_fastpath+0x16/0x1b
>> <0>[  279.043318] Code: 00 55 48 89 f5 53 48 89 fb 48 83 ec 08 eb 0e 49
>> 8b 45 00 a8 08 74 04 31 c0 eb 2c f3 90 e8 02 38 05 00 45 31 e4 48 39 6b
>> 18 75 08
>> <83>[  279.043318]  7d 28 00 41 0f 95 c4 e8 60 48 05 00 45 84 e4 75 d2
>> 31 c0 48
>> <1>[  279.043318] RIP  [<ffffffff810231bb>] mutex_spin_on_owner+0x3e/0x63
>> <4>[  279.043318]  RSP <ffff88004a1c3e00>
> 
> Yes, vfd_write() appears to have got all confused and passed a garbage
> pointer into mutex_lock().
> 

I just found another similar one in the vfd path today:
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.0.3-dirty (root@tv) (gcc version 4.4.5
(Gentoo 4.4.5 p1.2, pie-0.4.5) ) #37 SMP PREEMPT Mon Aug 22 08:54:35
CEST 2011
<6>[    0.000000] Command line: root=/dev/sda3 hpet=disable crashkernel=128M
<6>[    0.000000] KERNEL supported cpus:
<6>[    0.000000]   AMD AuthenticAMD
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077ee0000 (usable)
<6>[    0.000000]  BIOS-e820: 0000000077ee0000 - 0000000077ee3000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 0000000077ee3000 - 0000000077ef0000 (ACPI
data)
<6>[    0.000000]  BIOS-e820: 0000000077ef0000 - 0000000077f00000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] DMI 2.4 present.
<7>[    0.000000] DMI: System manufacturer System Product Name/M2A-VM
HDMI, BIOS ASUS M2A-VM HDMI ACPI BIOS Revision 2201 10/22/2008
<7>[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
<7>[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] last_pfn = 0x77ee0 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-C7FFF write-protect
<7>[    0.000000]   C8000-FFFFF uncachable
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
<7>[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
<7>[    0.000000]   2 base 0060000000 mask FFF0000000 write-back
<7>[    0.000000]   3 base 0070000000 mask FFF8000000 write-back
<7>[    0.000000]   4 base 0077F00000 mask FFFFF00000 uncachable
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
<6>[    0.000000] found SMP MP-table at [ffff8800000f6560] f6560
<7>[    0.000000] initial memory mapped : 0 - 20000000
<7>[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000
size 20480
<6>[    0.000000] init_memory_mapping: 0000000000000000-0000000077ee0000
<7>[    0.000000]  0000000000 - 0077e00000 page 2M
<7>[    0.000000]  0077e00000 - 0077ee0000 page 4k
<7>[    0.000000] kernel direct mapping tables up to 77ee0000 @
77edc000-77ee0000
<6>[    0.000000] Reserving 128MB of memory at 768MB for crashkernel
(System RAM: 1918MB)
<4>[    0.000000] ACPI: RSDP 00000000000f8210 00024 (v02 ATI   )
<4>[    0.000000] ACPI: XSDT 0000000077ee3100 00044 (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: FACP 0000000077ee8500 000F4 (v03 ATI    ASUSACPI
42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: DSDT 0000000077ee3280 05210 (v01 ATI    ASUSACPI
00001000 MSFT 03000000)
<4>[    0.000000] ACPI: FACS 0000000077ee0000 00040
<4>[    0.000000] ACPI: SSDT 0000000077ee8740 002CC (v01 PTLTD  POWERNOW
00000001  LTP 00000001)
<4>[    0.000000] ACPI: MCFG 0000000077ee8b00 0003C (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
<4>[    0.000000] ACPI: APIC 0000000077ee8640 00084 (v01 ATI    ASUSACPI
42302E31 AWRD 00000000)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<7>[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD ->
[ffff880075800000-ffff8800773fffff] on node 0
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000010 -> 0x00001000
<4>[    0.000000]   DMA32    0x00001000 -> 0x00100000
<4>[    0.000000]   Normal   empty
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[2] active PFN ranges
<4>[    0.000000]     0: 0x00000010 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x00077ee0
<7>[    0.000000] On node 0 totalpages: 491119
<7>[    0.000000]   DMA zone: 56 pages used for memmap
<7>[    0.000000]   DMA zone: 5 pages reserved
<7>[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 6661 pages used for memmap
<7>[    0.000000]   DMA32 zone: 480475 pages, LIFO batch:31
<6>[    0.000000] Detected use of extended apic ids on hypertransport bus
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x4008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000,
GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000f0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000f0000 -
0000000000100000
<6>[    0.000000] Allocating PCI resources starting at 77f00000 (gap:
77f00000:68100000)
<6>[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4
nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff880077c00000 s68800
r8192 d21312 u524288
<7>[    0.000000] pcpu-alloc: s68800 r8192 d21312 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
 Total pages: 484397
<5>[    0.000000] Kernel command line: root=/dev/sda3 hpet=disable
crashkernel=128M
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
<6>[    0.000000] Inode-cache hash table entries: 131072 (order: 8,
1048576 bytes)
<6>[    0.000000] Checking aperture...
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] Node 0: aperture @ 1262000000 size 32 MB
<6>[    0.000000] Aperture beyond 4GB. Ignoring.
<6>[    0.000000] Memory: 1792880k/1964928k available (4899k kernel
code, 452k absent, 171596k reserved, 2346k data, 464k init)
<6>[    0.000000] Preemptible hierarchical RCU implementation.
<6>[    0.000000]       CONFIG_RCU_FANOUT set to non-default value of 32
<6>[    0.000000] NR_IRQS:384
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] allocated 15728640 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.000000] Detected 2799.820 MHz processor.
<6>[    0.000000] Marking TSC unstable due to TSCs unsynchronized
<6>[    0.002039] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5599.64 BogoMIPS (lpj=2799820)
<6>[    0.002110] pid_max: default: 32768 minimum: 301
<6>[    0.002205] Mount-cache hash table entries: 256
<6>[    0.002393] Initializing cgroup subsys cpuacct
<6>[    0.002435] Initializing cgroup subsys memory
<6>[    0.002481] Initializing cgroup subsys devices
<6>[    0.002516] Initializing cgroup subsys freezer
<6>[    0.002552] Initializing cgroup subsys blkio
<7>[    0.003024] tseg: 0077f00000
<6>[    0.003026] CPU: Physical Processor ID: 0
<6>[    0.003061] CPU: Processor Core ID: 0
<6>[    0.003095] mce: CPU supports 5 MCE banks
<6>[    0.003137] using AMD E400 aware idle routine
<6>[    0.003203] ACPI: Core revision 20110413
<6>[    0.006343] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.016391] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
stepping 03
<6>[    0.016998] Performance Events: AMD PMU driver.
<6>[    0.016998] ... version:                0
<6>[    0.016998] ... bit width:              48
<6>[    0.016998] ... generic registers:      4
<6>[    0.016998] ... value mask:             0000ffffffffffff
<6>[    0.016998] ... max period:             00007fffffffffff
<6>[    0.016998] ... fixed-purpose events:   0
<6>[    0.016998] ... event mask:             000000000000000f
<6>[    0.028011] Booting Node   0, Processors  #1
<7>[    0.028073] smpboot cpu 1: start_ip = 9a000
<6>[    0.099047] Brought up 2 CPUs
<6>[    0.099083] Total of 2 processors activated (11198.43 BogoMIPS).
<6>[    0.099479] PM: Registering ACPI NVS region at 77ee0000 (12288 bytes)
<6>[    0.099479] NET: Registered protocol family 16
<7>[    0.100021] node 0 link 0: io port [c000, ffff]
<6>[    0.100021] TOM: 0000000080000000 aka 2048M
<7>[    0.100045] node 0 link 0: mmio [a0000, bffff]
<7>[    0.100048] node 0 link 0: mmio [f0000000, f7ffffff]
<7>[    0.100050] node 0 link 0: mmio [80000000, dfffffff]
<7>[    0.100053] node 0 link 0: mmio [f0000000, fe02ffff]
<7>[    0.100055] node 0 link 0: mmio [e0000000, e03fffff]
<7>[    0.100057] bus: [00, 03] on node 0 link 0
<7>[    0.100060] bus: 00 index 0 [io  0x0000-0xffff]
<7>[    0.100062] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
<7>[    0.100064] bus: 00 index 2 [mem 0xe0400000-0xfcffffffff]
<7>[    0.100066] bus: 00 index 3 [mem 0x80000000-0xe03fffff]
<6>[    0.100074] ACPI: bus type pci registered
<6>[    0.100118] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    0.100118] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
in E820
<6>[    0.115941] PCI: Using configuration type 1 for base access
<6>[    0.121102] bio: create slab <bio-0> at 0
<7>[    0.122410] ACPI: EC: Look up EC in DSDT
<6>[    0.125737] ACPI: Interpreter enabled
<6>[    0.125775] ACPI: (supports S0 S1 S3 S4 S5)
<6>[    0.125969] ACPI: Using IOAPIC for interrupt routing
<6>[    0.130137] ACPI: No dock devices found.
<6>[    0.130137] HEST: Table not found.
<6>[    0.130154] PCI: Using host bridge windows from ACPI; if
necessary, use "pci=nocrs" and report a bug
<6>[    0.130245] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    0.130313] pci_root PNP0A03:00: host bridge window [io
0x0000-0x0cf7]
<6>[    0.130313] pci_root PNP0A03:00: host bridge window [io
0x0d00-0xffff]
<6>[    0.131014] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff]
<6>[    0.131054] pci_root PNP0A03:00: host bridge window [mem
0x000c0000-0x000dffff]
<6>[    0.131093] pci_root PNP0A03:00: host bridge window [mem
0x80000000-0xfebfffff]
<7>[    0.131141] pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
<7>[    0.131167] pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
<7>[    0.131198] pci 0000:00:07.0: [1002:7917] type 1 class 0x000604
<7>[    0.131218] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
<7>[    0.131222] pci 0000:00:07.0: PME# disabled
<7>[    0.131252] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
<7>[    0.131269] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
<7>[    0.131279] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
<7>[    0.131289] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
<7>[    0.131299] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
<7>[    0.131310] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
<7>[    0.131320] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
<6>[    0.131341] pci 0000:00:12.0: set SATA to AHCI mode
<7>[    0.131403] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
<7>[    0.131417] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
<7>[    0.131483] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
<7>[    0.131497] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
<7>[    0.131563] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
<7>[    0.131577] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
<7>[    0.131642] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
<7>[    0.131656] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
<7>[    0.131721] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
<7>[    0.131735] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
<7>[    0.131806] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
<7>[    0.131826] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
<7>[    0.131898] pci 0000:00:13.5: supports D1 D2
<7>[    0.131900] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
<7>[    0.131904] pci 0000:00:13.5: PME# disabled
<7>[    0.131989] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
<7>[    0.131989] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
<7>[    0.132059] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
<7>[    0.132073] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
<7>[    0.132083] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
<7>[    0.132093] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
<7>[    0.132103] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
<7>[    0.132114] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
<7>[    0.132151] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
<7>[    0.132174] pci 0000:00:14.2: reg 10: [mem 0xfe020000-0xfe023fff
64bit]
<7>[    0.132233] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
<7>[    0.132237] pci 0000:00:14.2: PME# disabled
<7>[    0.132252] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
<7>[    0.132326] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
<7>[    0.132372] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
<7>[    0.132387] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
<7>[    0.132401] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
<7>[    0.132413] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
<7>[    0.132451] pci 0000:01:05.0: [1002:791e] type 0 class 0x000300
<7>[    0.132460] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff
64bit pref]
<7>[    0.132465] pci 0000:01:05.0: reg 18: [mem 0xfdce0000-0xfdceffff
64bit]
<7>[    0.132470] pci 0000:01:05.0: reg 20: [io  0xde00-0xdeff]
<7>[    0.132474] pci 0000:01:05.0: reg 24: [mem 0xfdb00000-0xfdbfffff]
<7>[    0.132484] pci 0000:01:05.0: supports D1 D2
<7>[    0.132494] pci 0000:01:05.2: [1002:7919] type 0 class 0x000403
<7>[    0.132502] pci 0000:01:05.2: reg 10: [mem 0xfdcfc000-0xfdcfffff
64bit]
<6>[    0.132533] pci 0000:00:01.0: PCI bridge to [bus 01-01]
<7>[    0.132569] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
<7>[    0.132572] pci 0000:00:01.0:   bridge window [mem
0xfdb00000-0xfdcfffff]
<7>[    0.132576] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
<7>[    0.132615] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
<7>[    0.132629] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
<7>[    0.132653] pci 0000:02:00.0: reg 18: [mem 0xfdaff000-0xfdafffff
64bit]
<7>[    0.132680] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>[    0.132715] pci 0000:02:00.0: supports D1 D2
<7>[    0.132717] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
<7>[    0.132721] pci 0000:02:00.0: PME# disabled
<6>[    0.132735] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
<6>[    0.132782] pci 0000:00:07.0: PCI bridge to [bus 02-02]
<7>[    0.132818] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
<7>[    0.132821] pci 0000:00:07.0:   bridge window [mem
0xfda00000-0xfdafffff]
<7>[    0.132825] pci 0000:00:07.0:   bridge window [mem
0xfdf00000-0xfdffffff 64bit pref]
<7>[    0.132861] pci 0000:03:06.0: [1131:7133] type 0 class 0x000480
<7>[    0.132883] pci 0000:03:06.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
<7>[    0.132972] pci 0000:03:06.0: supports D1 D2
<7>[    0.132999] pci 0000:03:07.0: [1106:3044] type 0 class 0x000c00
<7>[    0.133022] pci 0000:03:07.0: reg 10: [mem 0xfdefe000-0xfdefe7ff]
<7>[    0.133036] pci 0000:03:07.0: reg 14: [io  0xcf00-0xcf7f]
<7>[    0.133118] pci 0000:03:07.0: supports D2
<7>[    0.133120] pci 0000:03:07.0: PME# supported from D2 D3hot D3cold
<7>[    0.133125] pci 0000:03:07.0: PME# disabled
<6>[    0.133170] pci 0000:00:14.4: PCI bridge to [bus 03-03]
(subtractive decode)
<7>[    0.133208] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
<7>[    0.133213] pci 0000:00:14.4:   bridge window [mem
0xfde00000-0xfdefffff]
<7>[    0.133218] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
<7>[    0.133220] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
<7>[    0.133223] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
<7>[    0.133225] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
<7>[    0.133228] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000dffff] (subtractive decode)
<7>[    0.133230] pci 0000:00:14.4:   bridge window [mem
0x80000000-0xfebfffff] (subtractive decode)
<7>[    0.133241] pci_bus 0000:00: on NUMA node 0
<7>[    0.133244] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[    0.133394] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
<7>[    0.133459] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
<7>[    0.133485] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
<6>[    0.133513]  pci0000:00: Requesting ACPI _OSC control (0x1d)
<6>[    0.133550]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND),
returned control mask: 0x1d
<6>[    0.133589] ACPI _OSC control for PCIe not granted, disabling ASPM
<6>[    0.146241] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.147019] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.147409] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.147796] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.148203] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.148591] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.149005] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
<6>[    0.149332] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
<6>[    0.149711] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.149711] vgaarb: loaded
<6>[    0.149711] vgaarb: bridge control possible 0000:01:05.0
<5>[    0.150049] SCSI subsystem initialized
<7>[    0.150054] libata version 3.00 loaded.
<6>[    0.150054] usbcore: registered new interface driver usbfs
<6>[    0.150054] usbcore: registered new interface driver hub
<6>[    0.150054] usbcore: registered new device driver usb
<6>[    0.150054] Advanced Linux Sound Architecture Driver Version 1.0.24.
<6>[    0.150054] PCI: Using ACPI for IRQ routing
<7>[    0.159907] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.159991] reserve RAM buffer: 000000000009f000 - 000000000009ffff
<7>[    0.159994] reserve RAM buffer: 0000000077ee0000 - 0000000077ffffff
<6>[    0.160048] Bluetooth: Core ver 2.16
<6>[    0.160054] NET: Registered protocol family 31
<6>[    0.160054] Bluetooth: HCI device and connection manager initialized
<6>[    0.160068] Bluetooth: HCI socket layer initialized
<6>[    0.160104] Bluetooth: L2CAP socket layer initialized
<6>[    0.160142] Bluetooth: SCO socket layer initialized
<6>[    0.160142] pnp: PnP ACPI init
<6>[    0.160142] ACPI: bus type pnp registered
<7>[    0.160177] pnp 00:00: [bus 00-ff]
<7>[    0.160180] pnp 00:00: [io  0x0cf8-0x0cff]
<7>[    0.160182] pnp 00:00: [io  0x0000-0x0cf7 window]
<7>[    0.160184] pnp 00:00: [io  0x0d00-0xffff window]
<7>[    0.160186] pnp 00:00: [mem 0x000a0000-0x000bffff window]
<7>[    0.160189] pnp 00:00: [mem 0x000c0000-0x000dffff window]
<7>[    0.160191] pnp 00:00: [mem 0x80000000-0xfebfffff window]
<7>[    0.160246] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
<7>[    0.161003] pnp 00:01: [io  0x4100-0x411f]
<7>[    0.161005] pnp 00:01: [io  0x0228-0x022f]
<7>[    0.161007] pnp 00:01: [io  0x040b]
<7>[    0.161009] pnp 00:01: [io  0x04d6]
<7>[    0.161011] pnp 00:01: [io  0x0c00-0x0c01]
<7>[    0.161013] pnp 00:01: [io  0x0c14]
<7>[    0.161015] pnp 00:01: [io  0x0c50-0x0c52]
<7>[    0.161017] pnp 00:01: [io  0x0c6c-0x0c6d]
<7>[    0.161019] pnp 00:01: [io  0x0c6f]
<7>[    0.161021] pnp 00:01: [io  0x0cd0-0x0cd1]
<7>[    0.161022] pnp 00:01: [io  0x0cd2-0x0cd3]
<7>[    0.161024] pnp 00:01: [io  0x0cd4-0x0cdf]
<7>[    0.161026] pnp 00:01: [io  0x4000-0x40fe]
<7>[    0.161028] pnp 00:01: [io  0x4210-0x4217]
<7>[    0.161030] pnp 00:01: [io  0x0b10-0x0b1f]
<7>[    0.161032] pnp 00:01: [mem 0x00000000-0x00000fff window]
<7>[    0.161035] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
<4>[    0.161067] pnp 00:01: disabling [mem 0x00000000-0x00000fff
window] because it overlaps 0000:02:00.0 BAR 6 [mem
0x00000000-0x0001ffff pref]
<6>[    0.161135] system 00:01: [io  0x4100-0x411f] has been reserved
<6>[    0.161135] system 00:01: [io  0x0228-0x022f] has been reserved
<6>[    0.161135] system 00:01: [io  0x040b] has been reserved
<6>[    0.161135] system 00:01: [io  0x04d6] has been reserved
<6>[    0.161986] system 00:01: [io  0x0c00-0x0c01] has been reserved
<6>[    0.162022] system 00:01: [io  0x0c14] has been reserved
<6>[    0.162058] system 00:01: [io  0x0c50-0x0c52] has been reserved
<6>[    0.162093] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
<6>[    0.162130] system 00:01: [io  0x0c6f] has been reserved
<6>[    0.162165] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
<6>[    0.162201] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
<6>[    0.162237] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
<6>[    0.162274] system 00:01: [io  0x4000-0x40fe] has been reserved
<6>[    0.162311] system 00:01: [io  0x4210-0x4217] has been reserved
<6>[    0.162347] system 00:01: [io  0x0b10-0x0b1f] has been reserved
<6>[    0.162383] system 00:01: [mem 0xfee00400-0xfee00fff window] has
been reserved
<7>[    0.162425] system 00:01: Plug and Play ACPI device, IDs PNP0c02
(active)
<7>[    0.162516] pnp 00:02: [dma 4]
<7>[    0.162518] pnp 00:02: [io  0x0000-0x000f]
<7>[    0.162520] pnp 00:02: [io  0x0080-0x0090]
<7>[    0.162522] pnp 00:02: [io  0x0094-0x009f]
<7>[    0.162524] pnp 00:02: [io  0x00c0-0x00df]
<7>[    0.162550] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
<7>[    0.162550] pnp 00:03: [io  0x0070-0x0073]
<7>[    0.162550] pnp 00:03: [irq 8]
<7>[    0.162550] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.162550] pnp 00:04: [io  0x0061]
<7>[    0.162550] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
<7>[    0.162550] pnp 00:05: [io  0x00f0-0x00ff]
<7>[    0.162550] pnp 00:05: [irq 13]
<7>[    0.162550] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>[    0.162550] pnp 00:06: [io  0x0010-0x001f]
<7>[    0.162550] pnp 00:06: [io  0x0022-0x003f]
<7>[    0.162550] pnp 00:06: [io  0x0044-0x005f]
<7>[    0.162550] pnp 00:06: [io  0x0062-0x0063]
<7>[    0.162550] pnp 00:06: [io  0x0065-0x006f]
<7>[    0.162550] pnp 00:06: [io  0x0074-0x007f]
<7>[    0.162550] pnp 00:06: [io  0x0091-0x0093]
<7>[    0.162550] pnp 00:06: [io  0x00a2-0x00bf]
<7>[    0.162550] pnp 00:06: [io  0x00e0-0x00ef]
<7>[    0.162550] pnp 00:06: [io  0x04d0-0x04d1]
<7>[    0.162550] pnp 00:06: [io  0x0220-0x0225]
<6>[    0.163006] system 00:06: [io  0x04d0-0x04d1] has been reserved
<6>[    0.163043] system 00:06: [io  0x0220-0x0225] has been reserved
<7>[    0.163079] system 00:06: Plug and Play ACPI device, IDs PNP0c02
(active)
<7>[    0.163203] pnp 00:07: [io  0x03f0-0x03f5]
<7>[    0.163205] pnp 00:07: [io  0x03f7]
<7>[    0.163213] pnp 00:07: [irq 6]
<7>[    0.163215] pnp 00:07: [dma 2]
<7>[    0.163259] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
<7>[    0.163259] pnp 00:08: [io  0x03f8-0x03ff]
<7>[    0.163259] pnp 00:08: [irq 4]
<7>[    0.163259] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    0.163259] pnp 00:09: [io  0x0378-0x037f]
<7>[    0.163259] pnp 00:09: [irq 7]
<7>[    0.163300] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
<7>[    0.163300] pnp 00:0a: [mem 0xe0000000-0xefffffff]
<6>[    0.164004] system 00:0a: [mem 0xe0000000-0xefffffff] has been
reserved
<7>[    0.164036] system 00:0a: Plug and Play ACPI device, IDs PNP0c02
(active)
<7>[    0.164159] pnp 00:0b: [mem 0x000cd600-0x000cffff]
<7>[    0.164161] pnp 00:0b: [mem 0x000f0000-0x000f7fff]
<7>[    0.164163] pnp 00:0b: [mem 0x000f8000-0x000fbfff]
<7>[    0.164166] pnp 00:0b: [mem 0x000fc000-0x000fffff]
<7>[    0.164168] pnp 00:0b: [mem 0x77ef0000-0x77feffff]
<7>[    0.164170] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
<7>[    0.164172] pnp 00:0b: [mem 0x77ee0000-0x77efffff]
<7>[    0.164174] pnp 00:0b: [mem 0xffff0000-0xffffffff]
<7>[    0.164176] pnp 00:0b: [mem 0x00000000-0x0009ffff]
<7>[    0.164178] pnp 00:0b: [mem 0x00100000-0x77edffff]
<7>[    0.164180] pnp 00:0b: [mem 0x77ff0000-0x7ffeffff]
<7>[    0.164182] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
<7>[    0.164184] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
<7>[    0.164190] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
<6>[    0.164241] system 00:0b: [mem 0x000cd600-0x000cffff] has been
reserved
<6>[    0.164241] system 00:0b: [mem 0x000f0000-0x000f7fff] could not be
reserved
<6>[    0.164241] system 00:0b: [mem 0x000f8000-0x000fbfff] could not be
reserved
<6>[    0.164241] system 00:0b: [mem 0x000fc000-0x000fffff] could not be
reserved
<6>[    0.164241] system 00:0b: [mem 0x77ef0000-0x77feffff] could not be
reserved
<6>[    0.164241] system 00:0b: [mem 0xfed00000-0xfed000ff] has been
reserved
<6>[    0.164241] system 00:0b: [mem 0x77ee0000-0x77efffff] could not be
reserved
<6>[    0.164255] system 00:0b: [mem 0xffff0000-0xffffffff] has been
reserved
<6>[    0.164292] system 00:0b: [mem 0x00000000-0x0009ffff] could not be
reserved
<6>[    0.164329] system 00:0b: [mem 0x00100000-0x77edffff] could not be
reserved
<6>[    0.164365] system 00:0b: [mem 0x77ff0000-0x7ffeffff] could not be
reserved
<6>[    0.164402] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be
reserved
<6>[    0.164438] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be
reserved
<6>[    0.164476] system 00:0b: [mem 0xfff80000-0xfffeffff] has been
reserved
<7>[    0.164513] system 00:0b: Plug and Play ACPI device, IDs PNP0c01
(active)
<6>[    0.164519] pnp: PnP ACPI: found 12 devices
<6>[    0.164554] ACPI: ACPI bus type pnp unregistered
<6>[    0.172617] Switching to clocksource acpi_pm
<7>[    0.172681] PCI: max bus depth: 1 pci_try_num: 2
<6>[    0.172700] pci 0000:00:01.0: PCI bridge to [bus 01-01]
<6>[    0.172736] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
<6>[    0.172773] pci 0000:00:01.0:   bridge window [mem
0xfdb00000-0xfdcfffff]
<6>[    0.172810] pci 0000:00:01.0:   bridge window [mem
0xf0000000-0xf7ffffff 64bit pref]
<6>[    0.172854] pci 0000:02:00.0: BAR 6: assigned [mem
0xfdf00000-0xfdf1ffff pref]
<6>[    0.172893] pci 0000:00:07.0: PCI bridge to [bus 02-02]
<6>[    0.172929] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
<6>[    0.172965] pci 0000:00:07.0:   bridge window [mem
0xfda00000-0xfdafffff]
<6>[    0.172965] Switched to NOHz mode on CPU #0
<6>[    0.172661] Switched to NOHz mode on CPU #1
<6>[    0.172965] pci 0000:00:07.0:   bridge window [mem
0xfdf00000-0xfdffffff 64bit pref]
<6>[    0.172965] pci 0000:00:14.4: PCI bridge to [bus 03-03]
<6>[    0.172965] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
<6>[    0.172965] pci 0000:00:14.4:   bridge window [mem
0xfde00000-0xfdefffff]
<6>[    0.172965] pci 0000:00:14.4:   bridge window [mem
0xfdd00000-0xfddfffff pref]
<7>[    0.172965] pci 0000:00:07.0: setting latency timer to 64
<7>[    0.172965] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    0.172965] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    0.172965] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.172965] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
<7>[    0.172965] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfebfffff]
<7>[    0.172965] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
<7>[    0.172965] pci_bus 0000:01: resource 1 [mem 0xfdb00000-0xfdcfffff]
<7>[    0.172965] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff
64bit pref]
<7>[    0.172965] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
<7>[    0.172965] pci_bus 0000:02: resource 1 [mem 0xfda00000-0xfdafffff]
<7>[    0.172965] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff
64bit pref]
<7>[    0.172965] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
<7>[    0.172965] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
<7>[    0.172965] pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff
pref]
<7>[    0.172965] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
<7>[    0.172965] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
<7>[    0.172965] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.172965] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
<7>[    0.172965] pci_bus 0000:03: resource 8 [mem 0x80000000-0xfebfffff]
<6>[    0.172965] NET: Registered protocol family 2
<6>[    0.172965] IP route cache hash table entries: 65536 (order: 7,
524288 bytes)
<6>[    0.173310] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
<6>[    0.175118] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes)
<6>[    0.175670] TCP: Hash tables configured (established 262144 bind
65536)
<6>[    0.175708] TCP reno registered
<6>[    0.175744] UDP hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.175797] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.175986] NET: Registered protocol family 1
<6>[    0.176153] RPC: Registered named UNIX socket transport module.
<6>[    0.176199] RPC: Registered udp transport module.
<6>[    0.176234] RPC: Registered tcp transport module.
<6>[    0.176269] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    0.392046] pci 0000:01:05.0: Boot video device
<7>[    0.392058] PCI: CLS 32 bytes, default 64
<6>[    0.393176] audit: initializing netlink socket (disabled)
<5>[    0.393219] type=2000 audit(1315426754.393:1): initialized
<6>[    0.400022] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<6>[    0.400322] msgmni has been set to 3501
<6>[    0.400748] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
<6>[    0.400791] io scheduler noop registered
<6>[    0.400842] io scheduler cfq registered (default)
<7>[    0.400999] pcieport 0000:00:07.0: setting latency timer to 64
<7>[    0.401036] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
<6>[    0.401691] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
<6>[    0.401734] ACPI: Power Button [PWRB]
<6>[    0.401874] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    0.401915] ACPI: Power Button [PWRF]
<6>[    0.402107] ACPI: Fan [FAN] (on)
<7>[    0.402242] ACPI: acpi_idle registered with cpuidle
<4>[    0.403625] ACPI Warning: For \_TZ_.THRM._PSL: Return Package has
no elements (empty) (20110413/nspredef-456)
<3>[    0.403729] ACPI: [Package] has zero elements (ffff88007438bb00)
<4>[    0.403765] ACPI: Invalid passive threshold
<6>[    0.403953] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    0.403990] ACPI: Thermal Zone [THRM] (40 C)
<6>[    0.404103] ERST: Table is not found!
<6>[    0.404222] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    0.424933] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[    0.503807] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[    0.519358] [drm] Initialized drm 1.1.0 20060810
<6>[    0.519448] [drm] radeon defaulting to kernel modesetting.
<6>[    0.519485] [drm] radeon kernel modesetting enabled.
<6>[    0.519581] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
<6>[    0.519822] [drm] initializing kernel modesetting (RS690
0x1002:0x791E 0x1043:0x826D).
<6>[    0.519879] [drm] register mmio base: 0xFDCE0000
<6>[    0.519914] [drm] register mmio size: 65536
<6>[    0.521461] ATOM BIOS: ATI
<6>[    0.521510] radeon 0000:01:05.0: VRAM: 128M 0x0000000078000000 -
0x000000007FFFFFFF (128M used)
<6>[    0.521550] radeon 0000:01:05.0: GTT: 512M 0x0000000080000000 -
0x000000009FFFFFFF
<6>[    0.521590] [drm] Supports vblank timestamp caching Rev 1
(10.10.2010).
<6>[    0.521626] [drm] Driver supports precise vblank timestamp query.
<6>[    0.521686] [drm] radeon: irq initialized.
<6>[    0.522072] [drm] Detected VRAM RAM=128M, BAR=128M
<6>[    0.522112] [drm] RAM width 128bits DDR
<6>[    0.522224] [TTM] Zone  kernel: Available graphics memory: 896440 kiB.
<6>[    0.522265] [TTM] Initializing pool allocator.
<6>[    0.522323] [drm] radeon: 128M of VRAM memory ready
<6>[    0.522357] [drm] radeon: 512M of GTT memory ready.
<6>[    0.522395] [drm] GART: num cpu pages 131072, num gpu pages 131072
<6>[    0.526235] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
<6>[    0.532110] radeon 0000:01:05.0: WB enabled
<6>[    0.532247] [drm] Loading RS690/RS740 Microcode
<6>[    0.532433] [drm] radeon: ring at 0x0000000080001000
<6>[    0.532485] [drm] ring test succeeded in 1 usecs
<6>[    0.532615] [drm] radeon: ib pool ready.
<6>[    0.532660] [drm] ib test succeeded in 0 usecs
<7>[    0.532698] failed to evaluate ATIF got AE_BAD_PARAMETER
<6>[    0.533387] [drm] Radeon Display Connectors
<6>[    0.533422] [drm] Connector 0:
<6>[    0.533455] [drm]   VGA
<6>[    0.533489] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48
0x7e5c 0x7e4c
<6>[    0.533528] [drm]   Encoders:
<6>[    0.533561] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
<6>[    0.533596] [drm] Connector 1:
<6>[    0.533629] [drm]   S-video
<6>[    0.533662] [drm]   Encoders:
<6>[    0.533696] [drm]     TV1: INTERNAL_KLDSCP_DAC1
<6>[    0.533730] [drm] Connector 2:
<6>[    0.533763] [drm]   HDMI-A
<6>[    0.533796] [drm]   HPD2
<6>[    0.533830] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68
0x7e4c 0x7e6c
<6>[    0.533869] [drm]   Encoders:
<6>[    0.533902] [drm]     DFP2: INTERNAL_DDI
<6>[    0.533936] [drm] Connector 3:
<6>[    0.533969] [drm]   DVI-D
<6>[    0.534018] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58
0x7e4c 0x7e5c
<6>[    0.534056] [drm]   Encoders:
<6>[    0.534089] [drm]     DFP3: INTERNAL_LVTM1
<6>[    0.585459] [drm] Radeon display connector VGA-1: Found valid EDID
<6>[    0.686439] [drm] Radeon display connector HDMI-A-1: Found valid EDID
<6>[    0.696062] [drm] Radeon display connector DVI-D-1: No monitor
connected or invalid EDID
<6>[    0.952049] [drm] fb mappable at 0xF0040000
<6>[    0.952115] [drm] vram apper at 0xF0000000
<6>[    0.952149] [drm] size 8294400
<6>[    0.952182] [drm] fb depth is 24
<6>[    0.952216] [drm]    pitch is 7680
<6>[    0.952334] fbcon: radeondrmfb (fb0) is primary device
<6>[    0.999785] Console: switching to colour frame buffer device 240x67
<6>[    1.017853] fb0: radeondrmfb frame buffer device
<6>[    1.017921] drm: registered panic notifier
<6>[    1.017984] [drm] Initialized radeon 2.10.0 20080528 for
0000:01:05.0 on minor 0
<6>[    1.020552] brd: module loaded
<6>[    1.021781] loop: module loaded
<6>[    1.021883] Uniform Multi-Platform E-IDE driver
<6>[    1.022101] ide-gd driver 1.18
<7>[    1.022415] ahci 0000:00:12.0: version 3.0
<6>[    1.022439] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
<4>[    1.022556] ahci 0000:00:12.0: ASUS M2A-VM: enabling 64bit DMA
<6>[    1.022752] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3
Gbps 0xf impl SATA mode
<6>[    1.022872] ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part ccc
<6>[    1.024362] scsi0 : ahci
<6>[    1.024658] scsi1 : ahci
<6>[    1.024872] scsi2 : ahci
<6>[    1.025094] scsi3 : ahci
<6>[    1.025320] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f100 irq 22
<6>[    1.025436] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f180 irq 22
<6>[    1.025544] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f200 irq 22
<6>[    1.025652] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f280 irq 22
<6>[    1.025938] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
<6>[    1.026096] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low)
-> IRQ 19
<7>[    1.026231] r8169 0000:02:00.0: setting latency timer to 64
<7>[    1.026282] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
<6>[    1.026521] r8169 0000:02:00.0: eth0: RTL8168b/8111b at
0xffffc9000000c000, 00:1b:fc:89:fa:a2, XID 18000000 IRQ 41
<6>[    1.026735] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    1.026855] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level,
low) -> IRQ 19
<6>[    1.026976] ehci_hcd 0000:00:13.5: EHCI Host Controller
<6>[    1.027090] ehci_hcd 0000:00:13.5: new USB bus registered,
assigned bus number 1
<6>[    1.027220] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB
freeze workaround
<6>[    1.027344] ehci_hcd 0000:00:13.5: debug port 1
<6>[    1.027443] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
<6>[    1.033023] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
<6>[    1.033298] hub 1-0:1.0: USB hub found
<6>[    1.033357] hub 1-0:1.0: 10 ports detected
<6>[    1.033541] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    1.033649] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<6>[    1.033758] ohci_hcd 0000:00:13.0: OHCI Host Controller
<6>[    1.033836] ohci_hcd 0000:00:13.0: new USB bus registered,
assigned bus number 2
<6>[    1.033977] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
<6>[    1.089194] hub 2-0:1.0: USB hub found
<6>[    1.089253] hub 2-0:1.0: 2 ports detected
<6>[    1.089365] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
<6>[    1.089478] ohci_hcd 0000:00:13.1: OHCI Host Controller
<6>[    1.089562] ohci_hcd 0000:00:13.1: new USB bus registered,
assigned bus number 3
<6>[    1.093329] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
<6>[    1.152189] hub 3-0:1.0: USB hub found
<6>[    1.156013] hub 3-0:1.0: 2 ports detected
<6>[    1.159800] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
<6>[    1.163603] ohci_hcd 0000:00:13.2: OHCI Host Controller
<6>[    1.167438] ohci_hcd 0000:00:13.2: new USB bus registered,
assigned bus number 4
<6>[    1.171288] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
<6>[    1.230201] hub 4-0:1.0: USB hub found
<6>[    1.234086] hub 4-0:1.0: 2 ports detected
<6>[    1.237983] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
<6>[    1.241850] ohci_hcd 0000:00:13.3: OHCI Host Controller
<6>[    1.245639] ohci_hcd 0000:00:13.3: new USB bus registered,
assigned bus number 5
<6>[    1.249558] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
<6>[    1.308193] hub 5-0:1.0: USB hub found
<6>[    1.311919] hub 5-0:1.0: 2 ports detected
<6>[    1.315766] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
<6>[    1.319662] ohci_hcd 0000:00:13.4: OHCI Host Controller
<6>[    1.323553] ohci_hcd 0000:00:13.4: new USB bus registered,
assigned bus number 6
<6>[    1.327490] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
<6>[    1.386184] hub 6-0:1.0: USB hub found
<6>[    1.389979] hub 6-0:1.0: 2 ports detected
<6>[    1.393969] i8042: PNP: No PS/2 controller found. Probing ports
directly.
<6>[    1.398099] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    1.401934] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    1.405894] mousedev: PS/2 mouse device common for all mice
<4>[    1.409893] k8temp 0000:00:18.3: Temperature readouts might be
wrong - check erratum #141
<6>[    1.413775] md: linear personality registered for level -1
<6>[    1.417649] device-mapper: uevent: version 1.0.3
<6>[    1.421562] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02)
initialised: dm-devel@redhat.com
<6>[    1.425396] Bluetooth: Generic Bluetooth USB driver ver 0.6
<6>[    1.429224] usbcore: registered new interface driver btusb
<6>[    1.433070] cpuidle: using governor ladder
<6>[    1.436923] cpuidle: using governor menu
<6>[    1.441268] ALSA device list:
<6>[    1.445075]   No soundcards found.
<6>[    1.448966] TCP cubic registered
<6>[    1.452853] NET: Registered protocol family 17
<6>[    1.456881] Bluetooth: RFCOMM TTY layer initialized
<6>[    1.460820] Bluetooth: RFCOMM socket layer initialized
<6>[    1.464631] Bluetooth: RFCOMM ver 1.11
<6>[    1.468518] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
<6>[    1.472437] Bluetooth: BNEP filters: protocol multicast
<6>[    1.476124] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
<3>[    1.485027] ata2: softreset failed (device not ready)
<4>[    1.488842] ata2: applying SB600 PMP SRST workaround and retrying
<3>[    1.492593] ata4: softreset failed (device not ready)
<4>[    1.496291] ata4: applying SB600 PMP SRST workaround and retrying
<3>[    1.500148] ata3: softreset failed (device not ready)
<4>[    1.510010] ata3: applying SB600 PMP SRST workaround and retrying
<3>[    1.513784] ata1: softreset failed (device not ready)
<4>[    1.517648] ata1: applying SB600 PMP SRST workaround and retrying
<6>[    1.624017] usb 3-2: new full speed USB device number 2 using ohci_hcd
<6>[    1.674031] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[    1.677885] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[    1.681788] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[    1.685616] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[    1.689442] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max
UDMA/100
<6>[    1.693215] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.697865] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.701613] ata4.00: configured for UDMA/100
<6>[    1.705496] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
<6>[    1.709195] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
<6>[    1.712885] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.716776] ata2.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max
UDMA/133
<6>[    1.720601] ata2.00: 2930277168 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
<6>[    1.724423] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.728093] ata3.00: ATA-8: WDC WD3200BEVT-00ZCT0, 11.01A11, max
UDMA/133
<6>[    1.731976] ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
<6>[    1.735853] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.739790] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.743598] ata1.00: configured for UDMA/133
<6>[    1.747455] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.751274] ata2.00: configured for UDMA/133
<6>[    1.755354] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[    1.759108] ata3.00: configured for UDMA/133
<5>[    1.759246] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
HD501LJ  CR10 PQ: 0 ANSI: 5
<5>[    1.766922] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
<5>[    1.767047] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD15EADS-00P 01.0 PQ: 0 ANSI: 5
<5>[    1.767221] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
<5>[    1.767251] sd 1:0:0:0: [sdb] Write Protect is off
<7>[    1.767254] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
<5>[    1.767267] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
<5>[    1.767583] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD3200BEVT-0 11.0 PQ: 0 ANSI: 5
<5>[    1.767749] sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks:
(320 GB/298 GiB)
<5>[    1.767777] sd 2:0:0:0: [sdc] Write Protect is off
<7>[    1.767780] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
<5>[    1.767792] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
<5>[    1.768661] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW
SH-S203P  SB00 PQ: 0 ANSI: 5
<6>[    1.770512]  sdb: sdb1 sdb2 sdb3 sdb4
<4>[    1.810913] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
<5>[    1.810931] sd 0:0:0:0: [sda] Write Protect is off
<7>[    1.810933] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[    1.810946] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
<5>[    1.815307] sd 1:0:0:0: [sdb] Attached SCSI disk
<6>[    1.822781]  sda: sda1 sda2 sda3 sda4
<6>[    1.831597] cdrom: Uniform CD-ROM driver Revision: 3.20
<5>[    1.831804] sd 0:0:0:0: [sda] Attached SCSI disk
<7>[    1.840176] sr 3:0:0:0: Attached scsi CD-ROM sr0
<6>[    1.871946]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
<5>[    1.876888] sd 2:0:0:0: [sdc] Attached SCSI disk
<3>[    1.881462] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
<6>[    1.885769] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core
Processor 5600+ (2 cpu cores) (version 2.20.00)
<6>[    1.890182] powernow-k8: fid 0x14 (2800 MHz), vid 0x8
<6>[    1.894431] powernow-k8: fid 0x12 (2600 MHz), vid 0xa
<6>[    1.898721] powernow-k8: fid 0x10 (2400 MHz), vid 0xc
<6>[    1.903019] powernow-k8: fid 0xe (2200 MHz), vid 0xe
<6>[    1.907321] powernow-k8: fid 0xc (2000 MHz), vid 0x10
<6>[    1.911447] powernow-k8: fid 0xa (1800 MHz), vid 0x10
<6>[    1.915688] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
<6>[    1.920056] md: Skipping autodetection of RAID arrays.
(raid=autodetect will force)
<6>[    1.945378] EXT3-fs (sda3): recovery required on readonly filesystem
<6>[    1.949614] EXT3-fs (sda3): write access will be enabled during
recovery
<6>[    1.957198] EXT3-fs: barriers not enabled
<6>[    1.966025] usb 5-1: new low speed USB device number 2 using ohci_hcd
<6>[    2.053179] kjournald starting.  Commit interval 5 seconds
<6>[    2.053210] EXT3-fs (sda3): recovery complete
<6>[    2.064807] EXT3-fs (sda3): mounted filesystem with writeback data
mode
<6>[    2.069066] VFS: Mounted root (ext3 filesystem) readonly on device
8:3.
<6>[    2.073369] Freeing unused kernel memory: 464k freed
<6>[    5.168857] udev[825]: starting version 164
<6>[    5.401174] atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev
0x00)
<6>[    5.401191] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<6>[    5.401212] atiixp 0000:00:14.1: not 100% native mode: will probe
irqs later
<6>[    5.401219]     ide0: BM-DMA at 0xf900-0xf907
<7>[    5.401225] Probing IDE interface ide0...
<6>[    5.462788] input: PC Speaker as /devices/platform/pcspkr/input/input2
<6>[    5.748071] Linux video capture interface: v2.00
<6>[    5.762101] rtc_cmos 00:03: RTC can wake from S4
<6>[    5.762355] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
<6>[    5.762405] rtc0: alarms up to one month, 242 bytes nvram
<6>[    5.809036] input: iMON Panel, Knob and Mouse(15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/input/input3
<6>[    5.823683] saa7130/34: v4l2 driver version 0.2.16 loaded
<6>[    5.823821] saa7134 0000:03:06.0: PCI INT A -> GSI 21 (level, low)
-> IRQ 21
<6>[    5.823837] saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21,
latency: 64, mmio: 0xfdeff000
<6>[    5.823852] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV
310i [card=101,autodetected]
<6>[    5.823898] saa7133[0]: board init: gpio is 600e000
<6>[    5.830027] imon 5-1:1.0: 0xffdc iMON VFD, MCE IR (id 0x9e)
<6>[    5.849979] IR NEC protocol handler initialized
<6>[    5.860205] Registered IR keymap rc-imon-mce
<6>[    5.860487] input: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0/input4
<6>[    5.860586] rc0: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0
<6>[    5.866848] IR RC5(x) protocol handler initialized
<6>[    5.870206] imon 5-1:1.0: iMON device (15c2:ffdc, intf0) on
usb<5:2> initialized
<6>[    5.870253] usbcore: registered new interface driver imon
<6>[    5.914181] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<6>[    5.914639] piix4_smbus 0000:00:14.0: SMBus Host Controller at
0xb00, revision 0
<6>[    5.915323] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<4>[    5.926216] saa7133[0]: i2c eeprom read error (err=-5)
<6>[    5.934291] IR RC6 protocol handler initialized
<4>[    5.954347] i2c-core: driver [tuner] using legacy suspend method
<4>[    5.954354] i2c-core: driver [tuner] using legacy resume method
<6>[    5.968299] IR JVC protocol handler initialized
<6>[    6.005659] IT8716 SuperIO detected.
<6>[    6.006157] parport_pc 00:09: reported by Plug and Play ACPI
<6>[    6.006200] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
<5>[    6.050488] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[    6.050635] sd 1:0:0:0: Attached scsi generic sg1 type 0
<5>[    6.050779] sd 2:0:0:0: Attached scsi generic sg2 type 0
<5>[    6.050921] sr 3:0:0:0: Attached scsi generic sg3 type 5
<6>[    6.112150] IR Sony protocol handler initialized
<6>[    6.389251] lirc_dev: IR Remote Control driver registered, major 252
<6>[    6.400710] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
<7>[    6.400793] HDA Intel 0000:01:05.2: irq 42 for MSI/MSI-X
<6>[    6.435693] IR LIRC bridge handler initialized
<6>[    6.628022] tuner 5-004b: Tuner -1 found with type(s) Radio TV.
<6>[    6.663021] tda829x 5-004b: setting tuner address to 61
<6>[    6.895237] tda829x 5-004b: ANDERS: setting switch_addr. was 0x00,
new 0x4b
<6>[    6.895241] tda829x 5-004b: ANDERS: new 0x61
<6>[    6.901019] tda829x 5-004b: type set to tda8290+75a
<4>[    9.407011] hda-intel: azx_get_response timeout, switching to
polling mode: last cmd=0x000f0000
<6>[    9.892096] saa7133[0]: registered device video0 [v4l2]
<6>[    9.892138] saa7133[0]: registered device vbi0
<6>[    9.892178] saa7133[0]: registered device radio0
<6>[    9.912735] dvb_init() allocating 1 frontend
<6>[    9.957027] DVB: registering new adapter (saa7133[0])
<4>[    9.957032] DVB: registering adapter 0 frontend 0 (Philips
TDA10046H DVB-T)...
<6>[   10.024021] tda1004x: setting up plls for 48MHz sampling clock
<4>[   10.408016] hda-intel: No response from codec, disabling MSI: last
cmd=0x000f0000
<6>[   10.982019] tda1004x: found firmware revision 0 -- invalid
<6>[   10.982022] tda1004x: trying to boot from eeprom
<4>[   11.409013] hda-intel: Codec #0 probe error; disabling it...
<3>[   13.288018] tda1004x: timeout waiting for DSP ready
<6>[   13.298020] tda1004x: found firmware revision 0 -- invalid
<6>[   13.298022] tda1004x: waiting for firmware upload...
<3>[   13.314867] tda1004x: no firmware upload (timeout or file not found?)
<4>[   13.314870] tda1004x: firmware upload failed
<6>[   13.429029] saa7134 ALSA driver for DMA sound loaded
<6>[   13.429051] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21
registered as card -1
<3>[   13.520012] hda_intel: azx_get_response timeout, switching to
single_cmd mode: last cmd=0x00070503
<3>[   13.521736] hda-codec: No codec parser is available
<6>[   56.338453] EXT3-fs (sda3): using internal journal
<6>[   56.513243] EXT3-fs: barriers not enabled
<6>[   56.515569] kjournald starting.  Commit interval 5 seconds
<6>[   56.515873] EXT3-fs (sda1): using internal journal
<6>[   56.515885] EXT3-fs (sda1): mounted filesystem with writeback data
mode
<6>[   56.537898] EXT3-fs: barriers not enabled
<6>[   56.550701] kjournald starting.  Commit interval 5 seconds
<6>[   56.551055] EXT3-fs (dm-1): using internal journal
<6>[   56.551063] EXT3-fs (dm-1): mounted filesystem with writeback data
mode
<6>[   56.639000] EXT3-fs: barriers not enabled
<6>[   56.647602] kjournald starting.  Commit interval 5 seconds
<6>[   56.647930] EXT3-fs (dm-2): using internal journal
<6>[   56.647939] EXT3-fs (dm-2): mounted filesystem with writeback data
mode
<6>[   56.660780] EXT3-fs: barriers not enabled
<6>[   56.672257] kjournald starting.  Commit interval 5 seconds
<6>[   56.673090] EXT3-fs (dm-3): using internal journal
<6>[   56.673099] EXT3-fs (dm-3): mounted filesystem with writeback data
mode
<6>[   56.745504] EXT4-fs (dm-4): mounted filesystem with ordered data
mode. Opts: (null)
<6>[   56.890513] EXT4-fs (dm-7): mounted filesystem with ordered data
mode. Opts: (null)
<6>[   56.935478] EXT3-fs: barriers not enabled
<6>[   56.946249] kjournald starting.  Commit interval 5 seconds
<6>[   56.946672] EXT3-fs (dm-5): using internal journal
<6>[   56.946682] EXT3-fs (dm-5): mounted filesystem with writeback data
mode
<6>[   57.007990] EXT4-fs (dm-6): mounted filesystem with ordered data
mode. Opts: (null)
<6>[   57.091783] EXT4-fs (dm-0): mounted filesystem without journal.
Opts: (null)
<6>[   59.655869] Adding 10490440k swap on /dev/sda2.  Priority:-1
extents:1 across:10490440k
<6>[   60.209537] r8169 0000:02:00.0: eth0: link down
<6>[   60.209552] r8169 0000:02:00.0: eth0: link down
<6>[   61.813088] r8169 0000:02:00.0: eth0: link up
<6>[ 2936.246110] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2936.248168] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2936.248177] ata1.00: configured for UDMA/133
<6>[ 2936.248185] ata1: EH complete
<6>[ 2936.509843] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2936.513516] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2936.513523] ata2.00: configured for UDMA/133
<6>[ 2936.513530] ata2: EH complete
<6>[ 2938.675874] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2938.676835] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2938.676843] ata3.00: configured for UDMA/133
<6>[ 2938.676855] ata3: EH complete
<6>[ 2938.808226] EXT4-fs (dm-4): re-mounted. Opts: commit=0
<6>[ 2938.815854] EXT4-fs (dm-7): re-mounted. Opts: commit=0
<6>[ 2938.830167] EXT4-fs (dm-6): re-mounted. Opts: commit=0
<6>[ 2938.838099] EXT4-fs (dm-0): re-mounted. Opts: commit=0
<6>[ 2939.420191] PM: Syncing filesystems ... done.
<4>[ 2939.506390] Freezing user space processes ... (elapsed 0.01
seconds) done.
<4>[ 2939.517052] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
<4>[ 2939.528036] Suspending console(s) (use no_console_suspend to debug)
<5>[ 2939.528513] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
<5>[ 2939.528571] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
<5>[ 2939.528621] sd 0:0:0:0: [sda] Synchronizing SCSI cache
<5>[ 2939.528695] sd 1:0:0:0: [sdb] Stopping disk
<5>[ 2939.528700] sd 2:0:0:0: [sdc] Stopping disk
<6>[ 2939.528744] parport_pc 00:09: disabled
<6>[ 2939.528810] serial 00:08: disabled
<6>[ 2939.528836] serial 00:08: wake-up capability disabled by ACPI
<7>[ 2939.528939] ACPI handle has no context!
<6>[ 2939.529387] r8169 0000:02:00.0: eth0: link down
<6>[ 2939.530860] ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
<6>[ 2939.530894] ehci_hcd 0000:00:13.5: PCI INT D disabled
<6>[ 2939.530904] ohci_hcd 0000:00:13.4: PCI INT C disabled
<6>[ 2939.530934] ohci_hcd 0000:00:13.2: PCI INT C disabled
<6>[ 2939.530964] ohci_hcd 0000:00:13.0: PCI INT A disabled
<6>[ 2939.540056] ohci_hcd 0000:00:13.3: PCI INT B disabled
<6>[ 2939.542054] ohci_hcd 0000:00:13.1: PCI INT B disabled
<5>[ 2939.543660] sd 0:0:0:0: [sda] Stopping disk
<6>[ 2939.551605] radeon 0000:01:05.0: PCI INT A disabled
<6>[ 2939.629026] HDA Intel 0000:01:05.2: PCI INT B disabled
<7>[ 2939.629036] ACPI handle has no context!
<6>[ 2939.631090] HDA Intel 0000:00:14.2: PCI INT A disabled
<6>[ 2940.225143] ahci 0000:00:12.0: PCI INT A disabled
<6>[ 2940.225162] PM: suspend of devices complete after 696.841 msecs
<7>[ 2940.225393] r8169 0000:02:00.0: PME# enabled
<6>[ 2940.225401] pcieport 0000:00:07.0: wake-up capability enabled by ACPI
<6>[ 2940.247150] PM: late suspend of devices complete after 21.983 msecs
<6>[ 2940.247333] ACPI: Preparing to enter system sleep state S3
<6>[ 2940.247415] PM: Saving platform NVS memory
<4>[ 2940.247445] Disabling non-boot CPUs ...
<6>[ 2940.248780] CPU 1 is now offline
<6>[ 2940.249144] ACPI: Low-level resume complete
<6>[ 2940.249144] PM: Restoring platform NVS memory
<6>[ 2940.249144] Enabling non-boot CPUs ...
<6>[ 2940.251396] Booting Node 0 Processor 1 APIC 0x1
<7>[ 2940.251398] smpboot cpu 1: start_ip = 9a000
<6>[ 2940.322330] CPU1 is up
<6>[ 2940.322558] ACPI: Waking up from system sleep state S3
<7>[ 2940.322683] pci 0000:00:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x4000)
<7>[ 2940.322708] pcieport 0000:00:07.0: restoring config space at
offset 0x1 (was 0x100007, writing 0x100407)
<7>[ 2940.322742] ahci 0000:00:12.0: restoring config space at offset
0x2 (was 0x1018f00, writing 0x1060100)
<6>[ 2940.322759] ahci 0000:00:12.0: set SATA to AHCI mode
<7>[ 2940.322781] ohci_hcd 0000:00:13.0: restoring config space at
offset 0x1 (was 0x2a00007, writing 0x2a00003)
<7>[ 2940.322808] ohci_hcd 0000:00:13.1: restoring config space at
offset 0x1 (was 0x2a00007, writing 0x2a00003)
<7>[ 2940.322833] ohci_hcd 0000:00:13.2: restoring config space at
offset 0x1 (was 0x2a00007, writing 0x2a00003)
<7>[ 2940.322859] ohci_hcd 0000:00:13.3: restoring config space at
offset 0x1 (was 0x2a00007, writing 0x2a00003)
<7>[ 2940.322884] ohci_hcd 0000:00:13.4: restoring config space at
offset 0x1 (was 0x2a00007, writing 0x2a00003)
<7>[ 2940.322917] ehci_hcd 0000:00:13.5: restoring config space at
offset 0x1 (was 0x2b00000, writing 0x2b00013)
<6>[ 2940.323024] Switched to NOHz mode on CPU #1
<7>[ 2940.323028] HDA Intel 0000:00:14.2: restoring config space at
offset 0x1 (was 0x4100006, writing 0x4100002)
<7>[ 2940.323109] HDA Intel 0000:01:05.2: restoring config space at
offset 0xf (was 0x200, writing 0x20a)
<7>[ 2940.323115] HDA Intel 0000:01:05.2: restoring config space at
offset 0x4 (was 0x4, writing 0xfdcfc004)
<7>[ 2940.323118] HDA Intel 0000:01:05.2: restoring config space at
offset 0x3 (was 0x0, writing 0x4008)
<7>[ 2940.323121] HDA Intel 0000:01:05.2: restoring config space at
offset 0x1 (was 0x100000, writing 0x100002)
<7>[ 2940.323144] r8169 0000:02:00.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
<7>[ 2940.323158] r8169 0000:02:00.0: restoring config space at offset
0x6 (was 0x4, writing 0xfdaff004)
<7>[ 2940.323164] r8169 0000:02:00.0: restoring config space at offset
0x4 (was 0x1, writing 0xee01)
<7>[ 2940.323168] r8169 0000:02:00.0: restoring config space at offset
0x3 (was 0x0, writing 0x8)
<7>[ 2940.323174] r8169 0000:02:00.0: restoring config space at offset
0x1 (was 0x100000, writing 0x100407)
<7>[ 2940.323216] saa7134 0000:03:06.0: restoring config space at offset
0xf (was 0x2054017f, writing 0x205401ff)
<7>[ 2940.323236] saa7134 0000:03:06.0: restoring config space at offset
0x4 (was 0x0, writing 0xfdeff000)
<7>[ 2940.323242] saa7134 0000:03:06.0: restoring config space at offset
0x3 (was 0xff00, writing 0x4000)
<7>[ 2940.323249] saa7134 0000:03:06.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900006)
<7>[ 2940.323270] pci 0000:03:07.0: restoring config space at offset 0xf
(was 0x200001ff, writing 0x2000010b)
<7>[ 2940.323290] pci 0000:03:07.0: restoring config space at offset 0x5
(was 0x1, writing 0xcf01)
<7>[ 2940.323296] pci 0000:03:07.0: restoring config space at offset 0x4
(was 0xfdeff000, writing 0xfdefe000)
<7>[ 2940.323301] pci 0000:03:07.0: restoring config space at offset 0x3
(was 0x4000, writing 0x4008)
<7>[ 2940.323308] pci 0000:03:07.0: restoring config space at offset 0x1
(was 0x2100006, writing 0x2100007)
<6>[ 2940.323452] PM: early resume of devices complete after 0.794 msecs
<6>[ 2940.323569] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
<6>[ 2940.323575] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<6>[ 2940.323600] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
<6>[ 2940.323621] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
<6>[ 2940.323700] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
<6>[ 2940.323716] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
<6>[ 2940.323728] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level,
low) -> IRQ 19
<6>[ 2940.323736] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<6>[ 2940.323747] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
<6>[ 2940.323791] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
<6>[ 2940.323837] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
<6>[ 2940.323841] pcieport 0000:00:07.0: wake-up capability disabled by ACPI
<7>[ 2940.323846] r8169 0000:02:00.0: PME# disabled
<6>[ 2940.323857] saa7133[0]: board init: gpio is 600e000
<5>[ 2940.324072] sd 0:0:0:0: [sda] Starting disk
<5>[ 2940.324120] sd 1:0:0:0: [sdb] Starting disk
<5>[ 2940.324149] sd 2:0:0:0: [sdc] Starting disk
<6>[ 2940.325464] serial 00:08: activated
<6>[ 2940.325754] parport_pc 00:09: activated
<6>[ 2940.329042] r8169 0000:02:00.0: eth0: link down
<6>[ 2940.411029] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
<6>[ 2940.417196] radeon 0000:01:05.0: WB enabled
<6>[ 2940.417227] [drm] radeon: ring at 0x0000000080001000
<6>[ 2940.417245] [drm] ring test succeeded in 1 usecs
<6>[ 2940.417261] [drm] ib test succeeded in 0 usecs
<6>[ 2940.567018] usb 3-2: reset full speed USB device number 2 using
ohci_hcd
<4>[ 2940.719897] btusb 3-2:1.0: no reset_resume for driver btusb?
<4>[ 2940.719900] btusb 3-2:1.1: no reset_resume for driver btusb?
<3>[ 2940.783017] ata4: softreset failed (device not ready)
<4>[ 2940.783020] ata4: applying SB600 PMP SRST workaround and retrying
<6>[ 2940.938026] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[ 2940.942203] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2940.984755] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2940.984757] ata4.00: configured for UDMA/100
<6>[ 2942.065578] r8169 0000:02:00.0: eth0: link up
<3>[ 2943.435018] ata3: softreset failed (device not ready)
<4>[ 2943.435021] ata3: applying SB600 PMP SRST workaround and retrying
<6>[ 2943.590029] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[ 2943.621770] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2943.622724] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2943.622726] ata3.00: configured for UDMA/133
<3>[ 2948.025022] ata1: softreset failed (device not ready)
<4>[ 2948.025025] ata1: applying SB600 PMP SRST workaround and retrying
<6>[ 2948.180036] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[ 2948.182025] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2948.184059] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2948.184061] ata1.00: configured for UDMA/133
<3>[ 2948.892016] ata2: softreset failed (device not ready)
<4>[ 2948.892019] ata2: applying SB600 PMP SRST workaround and retrying
<6>[ 2949.047024] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[ 2950.753040] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2950.756406] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
<6>[ 2950.756408] ata2.00: configured for UDMA/133
<6>[ 2951.751050] PM: resume of devices complete after 11427.518 msecs
<4>[ 2951.751423] Restarting tasks ... done.
<6>[ 2951.816036] usb 5-1: USB disconnect, device number 2
<3>[ 2951.818019] imon:send_packet: error submitting urb(-19)
<3>[ 2951.823024] imon:vfd_write: send packet failed for packet #1
<3>[ 2951.823045] imon:vfd_write: no iMON device present
<3>[ 2951.823049] imon:vfd_write: no iMON device present
<3>[ 2951.823053] imon:vfd_write: no iMON device present
<3>[ 2951.823057] imon:vfd_write: no iMON device present
<3>[ 2951.823061] imon:vfd_write: no iMON device present
<3>[ 2951.823066] imon:vfd_write: no iMON device present
<3>[ 2951.823070] imon:vfd_write: no iMON device present
<3>[ 2951.823074] imon:vfd_write: no iMON device present
<3>[ 2951.823078] imon:vfd_write: no iMON device present
<3>[ 2951.823082] imon:vfd_write: no iMON device present
<3>[ 2951.823086] imon:vfd_write: no iMON device present
<3>[ 2951.823090] imon:vfd_write: no iMON device present
<3>[ 2951.823094] imon:vfd_write: no iMON device present
<3>[ 2951.823099] imon:vfd_write: no iMON device present
<3>[ 2951.823103] imon:vfd_write: no iMON device present
<0>[ 2951.880402] stack segment: 0000 [#1] PREEMPT SMP
<4>[ 2951.880478] CPU 0
<4>[ 2951.880505] Modules linked in: saa7134_alsa tda1004x saa7134_dvb
videobuf_dvb dvb_core ir_kbd_i2c tda827x tda8290 ir_lirc_codec
snd_hda_codec_realtek lirc_dev ir_sony_decoder sg parport_pc
ir_jvc_decoder tuner ir_rc6_decoder snd_hda_intel ir_rc5_decoder
snd_hda_codec ir_nec_decoder parport rc_imon_mce saa7134 imon
videobuf_dma_sg videobuf_core asus_atk0110 rc_core rtc_cmos v4l2_common
videodev v4l2_compat_ioctl32 tveeprom i2c_piix4 pcspkr snd_hwdep atiixp
<4>[ 2951.881010]
<4>[ 2951.881010] Pid: 1926, comm: LCDd Not tainted 3.0.3-dirty #37
System manufacturer System Product Name/M2A-VM HDMI
<4>[ 2951.881010] RIP: 0010:[<ffffffff810231bb>]  [<ffffffff810231bb>]
mutex_spin_on_owner+0x3e/0x63
<4>[ 2951.881010] RSP: 0018:ffff880071ed1e00  EFLAGS: 00010246
<4>[ 2951.881010] RAX: ffff88007418acf0 RBX: ffff8800730f1020 RCX:
0000000000000000
<4>[ 2951.881010] RDX: ffff8800730f1038 RSI: 65766f6d65723d4e RDI:
ffff8800730f1020
<4>[ 2951.881010] RBP: 65766f6d65723d4e R08: 0000000000000000 R09:
ffff8800740a4c80
<4>[ 2951.881010] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
<4>[ 2951.881010] R13: ffff880071ed0010 R14: ffff880071ed0010 R15:
0000000000000001
<4>[ 2951.881010] FS:  00007f09d14a7700(0000) GS:ffff880077c00000(0000)
knlGS:0000000000000000
<4>[ 2951.881010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 2951.881010] CR2: 00007f00e15bd5f8 CR3: 0000000046a8f000 CR4:
00000000000006f0
<4>[ 2951.881010] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<4>[ 2951.881010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[ 2951.881010] Process LCDd (pid: 1926, threadinfo ffff880071ed0000,
task ffff88007418acf0)
<0>[ 2951.881010] Stack:
<4>[ 2951.881010]  0000000000000286 ffff8800730f1020 ffff88007418acf0
65766f6d65723d4e
<4>[ 2951.881010]  0000000000000000 ffffffff814c32ac 00000000730f1020
ffff8800730f1038
<4>[ 2951.881010]  ffffffff81048211 ffff880071ed1ed8 0000000000000286
ffff88007418acf0
<0>[ 2951.881010] Call Trace:
<4>[ 2951.881010]  [<ffffffff814c32ac>] ? __mutex_lock_slowpath+0x57/0x17f
<4>[ 2951.881010]  [<ffffffff81048211>] ? lock_hrtimer_base+0x1b/0x3c
<4>[ 2951.881010]  [<ffffffff810482d1>] ? hrtimer_try_to_cancel+0x63/0x6c
<4>[ 2951.881010]  [<ffffffff814c31d4>] ? mutex_lock+0x12/0x22
<4>[ 2951.881010]  [<ffffffff814c385a>] ? do_nanosleep+0x77/0xb0
<4>[ 2951.881010]  [<ffffffffa0063805>] ? vfd_write+0x63/0x1bd [imon]
<4>[ 2951.881010]  [<ffffffff8104877d>] ? hrtimer_nanosleep+0x9c/0x108
<4>[ 2951.881010]  [<ffffffff810b2393>] ? vfs_write+0xad/0x12e
<4>[ 2951.881010]  [<ffffffff810b24ca>] ? sys_write+0x45/0x6e
<4>[ 2951.881010]  [<ffffffff814c4f3b>] ? system_call_fastpath+0x16/0x1b
<0>[ 2951.881010] Code: 00 55 48 89 f5 53 48 89 fb 48 83 ec 08 eb 0e 49
8b 45 00 a8 08 74 04 31 c0 eb 2c f3 90 e8 ca 38 05 00 45 31 e4 48 39 6b
18 75 08
<83>[ 2951.881010]  7d 28 00 41 0f 95 c4 e8 28 49 05 00 45 84 e4 75 d2
31 c0 48
<1>[ 2951.881010] RIP  [<ffffffff810231bb>] mutex_spin_on_owner+0x3e/0x63
<4>[ 2951.881010]  RSP <ffff880071ed1e00>

