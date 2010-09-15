Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0IOOoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:44:22 -0400
Received: from dx.infernix.net ([109.71.48.48]:54125 "EHLO dx.infernix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab0IOOoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:44:19 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 10:44:18 EDT
Message-ID: <4C90D998.6050103@infernix.net>
Date: Wed, 15 Sep 2010 16:35:04 +0200
From: infernix <infernix@infernix.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core
 i3 laptop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting a kernel panic when I try to load the new Intel IPS 
powersaving code (intel_ips). It happens about 5 seconds after it gets 
loaded.

It occurs on an Acer 1830T which has a Core i3-330UM CPU. It panics when 
using SMP. With maxcpus=1 it does not panic but gives a general 
protection fault. It seems to me that it's trying to disable turbo mode 
which AFAIK does not exist on this cpu.

Here's the interesting bit when loading intel_ips with maxcpus=1:

[   49.646988] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match 
expected value (found 11, expected 18)
[   49.647227] intel ips 0000:00:1f.6: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[   49.647637] intel ips 0000:00:1f.6: failed to get i915 symbols, 
graphics turbo disabled
[   49.647920] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp 
limit 65535
[   54.843465] general protection fault: 0000 [#1] PREEMPT SMP
[   54.843809] last sysfs file: /sys/bus/pci/drivers/intel ips/uevent
[   54.843946] CPU 0
[   54.844020] Modules linked in: intel_ips nfsd exportfs nfs lockd 
fscache auth_rpcgss sunrpc ipv6 fuse loop uvcvideo videodev option arc4 
snd_hda_codec_intelhdmi v4l1_compat v4l2_compat_ioctl32 usb_wwan 
snd_hda_codec_realtek ecb usb_storage snd_hda_intel snd_hda_codec iwlagn 
usbserial snd_hwdep snd_pcm_oss snd_mixer_oss iwlcore mac80211 snd_pcm 
snd_timer cfg80211 ehci_hcd intel_agp psmouse snd processor acer_wmi 
video usbcore rfkill soundcore agpgart i2c_i801 backlight serio_raw 
i2c_core led_class output ac thermal wmi button battery thermal_sys 
evdev snd_page_alloc pcspkr nls_base
[   54.848814]
[   54.848932] Pid: 1185, comm: ips-adjust Not tainted 2.6.36-rc4 #4 
Base Board Product Name/Aspire 1830T
[   54.849124] RIP: 0010:[<ffffffffa00290e9>]  [<ffffffffa00290e9>] 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   54.849389] RSP: 0018:ffff880134525e78  EFLAGS: 00010002
[   54.849521] RAX: 0000000100000009 RBX: ffffffffa00290c0 RCX: 
0000000000000199
[   54.849643] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 
ffff880135d109c0
[   54.849765] RBP: ffff880135d109c0 R08: ffffffff81655120 R09: 
0000000000000000
[   54.849887] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[   54.850008] R13: 0000000080000000 R14: 00000000000000f9 R15: 
00000000000001ac
[   54.850131] FS:  0000000000000000(0000) GS:ffff880001800000(0000) 
knlGS:0000000000000000
[   54.850302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   54.850418] CR2: 0000000001265008 CR3: 0000000136864000 CR4: 
00000000000006f0
[   54.850540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   54.850662] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   54.850783] Process ips-adjust (pid: 1185, threadinfo 
ffff880134524000, task ffff880134de3e90)
[   54.850954] Stack:
[   54.851056]  ffffffff8104538c ffff880135d109c0 ffff880135d10a00 
0000000000000000
[   54.851328] <0> ffffffffa00296ca ffff880134525f00 ffff880135d109c0 
ffffffffa0029410
[   54.851745] <0> ffff880134547c98 ffff880134525f00 ffff880135d109c0 
ffffffffa0029410
[   54.852251] Call Trace:
[   54.852361]  [<ffffffff8104538c>] ? on_each_cpu+0x3c/0x80
[   54.852480]  [<ffffffffa00296ca>] ? ips_adjust+0x2ba/0x3f0 [intel_ips]
[   54.852603]  [<ffffffffa0029410>] ? ips_adjust+0x0/0x3f0 [intel_ips]
[   54.853450]  [<ffffffffa0029410>] ? ips_adjust+0x0/0x3f0 [intel_ips]
[   54.853574]  [<ffffffff8105a846>] ? kthread+0x96/0xa0
[   54.853693]  [<ffffffff81003b94>] ? kernel_thread_helper+0x4/0x10
[   54.853815]  [<ffffffff8105a7b0>] ? kthread+0x0/0xa0
[   54.853931]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10
[   54.854048] Code: 00 00 b9 99 01 00 00 0f 32 48 c1 e2 20 89 c0 48 09 
c2 48 b8 00 00 00 00 01 00 00 00 48 85 c2 75 0c 48 09 d0 48 89 c2 48 c1 
ea 20 <0f> 30 f3 c3 0f 1f 00 0f b7 c6 66 d1 ef 6b c0 64 d1 f8 8d 04 07
[   54.857483] RIP  [<ffffffffa00290e9>] do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   54.857702]  RSP <ffff880134525e78>
[   54.857812] ---[ end trace 4c3f4f3e72ed300e ]---
[   54.857925] note: ips-adjust[1185] exited with preempt_count 1


Please advise on how to debug this issue, I'm happy to test things.

Thanks!



Wall of text with kernel logs and hardware info follows:

SMP Panic dmesg:
[    0.000000]   #50 [00019c0000 - 00019db000]         BOOTMEM
[    0.000000]   #51 [00017a9440 - 00017a9448]         BOOTMEM
[    0.000000]   #52 [00017a9480 - 00017a9488]         BOOTMEM
[    0.000000]   #53 [00017a94c0 - 00017a94e0]         BOOTMEM
[    0.000000]   #54 [00017a9500 - 00017a9540]         BOOTMEM
[    0.000000]   #55 [00017a9540 - 00017a9660]         BOOTMEM
[    0.000000]   #56 [00017a9680 - 00017a96c8]         BOOTMEM
[    0.000000]   #57 [00017a9700 - 00017a9748]         BOOTMEM
[    0.000000]   #58 [00017ab000 - 00017b3000]         BOOTMEM
[    0.000000]   #59 [00019db000 - 0001ddb000]         BOOTMEM
[    0.000000]   #60 [0005800000 - 0005a00000]         BOOTMEM
[    0.000000]   #61 [0005a00000 - 0009a00000]         BOOTMEM
[    0.000000]   #62 [00017b3000 - 00017d3000]         BOOTMEM
[    0.000000]   #63 [0001ddb000 - 0001e1b000]         BOOTMEM
[    0.000000]   #64 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3718004k/5111808k available (3459k kernel code, 
1255568k absent, 138236k reserved, 3037k data, 404k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 1196.964 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 2393.92 BogoMIPS (lpj=4787856)
[    0.000230] pid_max: default: 32768 minimum: 301
[    0.000368] Mount-cache hash table entries: 256
[    0.000622] CPU: Physical Processor ID: 0
[    0.000729] CPU: Processor Core ID: 0
[    0.000839] mce: CPU supports 9 MCE banks
[    0.000958] CPU0: Thermal monitoring enabled (TM1)
[    0.001075] using mwait in idle threads.
[    0.001182] Performance Events: PEBS fmt1+, Westmere events, Intel 
PMU driver.
[    0.001489] ... version:                3
[    0.001596] ... bit width:              48
[    0.001702] ... generic registers:      4
[    0.001808] ... value mask:             0000ffffffffffff
[    0.001921] ... max period:             000000007fffffff
[    0.002031] ... fixed-purpose events:   3
[    0.002138] ... event mask:             000000070000000f
[    0.002347] ACPI: Core revision 20100702
[    0.054448] Setting APIC routing to flat
[    0.054978] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.094755] CPU0: Intel(R) Core(TM) i3 CPU       U 330  @ 1.20GHz 
stepping 05
[    0.207371] NMI watchdog enabled, takes one hw-pmu counter.
[    0.219130] Booting Node   0, Processors  #1
[    0.327174] NMI watchdog enabled, takes one hw-pmu counter.
[    0.335080]  #2
[    0.443152] NMI watchdog enabled, takes one hw-pmu counter.
[    0.451007]  #3
[    0.559078] NMI watchdog enabled, takes one hw-pmu counter.
[    0.562914] Brought up 4 CPUs
[    0.563032] Total of 4 processors activated (9575.79 BogoMIPS).
[    0.564841] devtmpfs: initialized
[    0.567307] NET: Registered protocol family 16
[    0.567509] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.567674] ACPI: bus type pci registered
[    0.567896] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.568069] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.640708] PCI: Using configuration type 1 for base access
[    0.641563] bio: create slab <bio-0> at 0
[    0.651986] ACPI: Executed 1 blocks of module-level executable AML code
[    0.662611] ACPI: BIOS _OSI(Linux) query ignored
[    0.664108] ACPI: SSDT 00000000b3691c18 00264 (v01  PmRef  Cpu0Ist 
00003000 INTL 20051117)
[    0.665588] ACPI: Dynamic OEM Table Load:
[    0.665787] ACPI: SSDT (null) 00264 (v01  PmRef  Cpu0Ist 00003000 
INTL 20051117)
[    0.666691] ACPI: SSDT 00000000b368f018 00891 (v01  PmRef  Cpu0Cst 
00003001 INTL 20051117)
[    0.668149] ACPI: Dynamic OEM Table Load:
[    0.668349] ACPI: SSDT (null) 00891 (v01  PmRef  Cpu0Cst 00003001 
INTL 20051117)
[    0.669364] ACPI: SSDT 00000000b3690a98 00303 (v01  PmRef    ApIst 
00003000 INTL 20051117)
[    0.670938] ACPI: Dynamic OEM Table Load:
[    0.671140] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 
INTL 20051117)
[    0.671693] ACPI: SSDT 00000000b368ed98 00119 (v01  PmRef    ApCst 
00003000 INTL 20051117)
[    0.673239] ACPI: Dynamic OEM Table Load:
[    0.673438] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 
INTL 20051117)
[    0.710332] ACPI: Interpreter enabled
[    0.710441] ACPI: (supports S0 S3 S4 S5)
[    0.710797] ACPI: Using IOAPIC for interrupt routing
[    0.728571] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.729182] ACPI: No dock devices found.
[    0.729290] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.730577] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.732627] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.732746] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.732865] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.733033] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfeafffff]
[    0.741698] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.742849] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.743098] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive 
decode)
[    0.751818] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.752632] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 
14 15)
[    0.753399] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 
14 15) *10
[    0.754254] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.755174] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 
14 15)
[    0.755936] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.756839] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *10
[    0.757691] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.758550] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.759333] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.759512] vgaarb: loaded
[    0.759695] SCSI subsystem initialized
[    0.759883] PCI: Using ACPI for IRQ routing
[    0.760289] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.760823] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.762964] Switching to clocksource tsc
[    0.763121] pnp: PnP ACPI init
[    0.763240] ACPI: bus type pnp registered
[    0.764920] pnp 00:05: disabling [io  0x164e-0x164f] because it 
overlaps 0000:00:1c.1 BAR 7 [io  0x1000-0x1fff]
[    0.766467] pnp: PnP ACPI: found 11 devices
[    0.766577] ACPI: ACPI bus type pnp unregistered
[    0.766698] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.766820] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.766936] system 00:05: [io  0xffff] has been reserved
[    0.767048] system 00:05: [io  0xffff] has been reserved
[    0.767161] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.767275] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.767397] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.767513] system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.767631] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.767749] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.767867] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.767983] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.768099] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.768216] system 00:09: [mem 0xff000000-0xffffffff] could not be 
reserved
[    0.768335] system 00:09: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.768454] system 00:09: [mem 0xd4500000-0xd4500fff] has been reserved
[    0.775197] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.775311] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.775433] pci 0000:00:1c.0:   bridge window [mem 0xd3400000-0xd43fffff]
[    0.775555] pci 0000:00:1c.0:   bridge window [mem 
0xd0400000-0xd13fffff 64bit pref]
[    0.775730] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.775842] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.775963] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd33fffff]
[    0.776086] pci 0000:00:1c.1:   bridge window [mem 
0xd1400000-0xd23fffff 64bit pref]
[    0.776260] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.776371] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.776490] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.776606] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.776745] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.776885] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.777113] NET: Registered protocol family 2
[    0.777310] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.777979] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.779508] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.779934] TCP: Hash tables configured (established 262144 bind 65536)
[    0.780051] TCP reno registered
[    0.780158] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.780297] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.780569] NET: Registered protocol family 1
[    0.810894] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.811013] Placing 64MB software IO TLB between ffff880005a00000 - 
ffff880009a00000
[    0.811177] software IO TLB at phys 0x5a00000 - 0x9a00000
[    0.811336] Simple Boot Flag at 0x44 set to 0x1
[    0.812304] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.814227] VFS: Disk quotas dquot_6.5.2
[    0.814417] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.815075] msgmni has been set to 7261
[    0.815460] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.815627] io scheduler noop registered
[    0.815734] io scheduler deadline registered
[    0.815889] io scheduler cfq registered (default)
[    0.816945] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.817582] SCSI Media Changer driver v0.25
[    0.817751] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.818015] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 
0x1 impl SATA mode
[    0.818185] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo 
pio slum part ems apst
[    0.819221] scsi0 : ahci
[    0.819428] scsi1 : ahci
[    0.819604] scsi2 : ahci
[    0.819780] scsi3 : ahci
[    0.819940] ata1: SATA max UDMA/133 abar m2048@0xd4405000 port 
0xd4405100 irq 40
[    0.820105] ata2: DUMMY
[    0.820206] ata3: DUMMY
[    0.820306] ata4: DUMMY
[    0.820487] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    0.947388] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    0.947521] netconsole: local port 4444
[    0.947629] netconsole: local IP 192.168.0.63
[    0.947737] netconsole: interface 'eth0'
[    0.947843] netconsole: remote port 9353
[    0.947950] netconsole: remote IP 192.168.0.3
[    0.948059] netconsole: remote ethernet address 00:15:17:21:1f:02
[    0.948174] netconsole: device eth0 not up yet, forcing it
[    1.138751] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.140799] ata1.00: ATA-8: WDC WD5000BEVT-00ZAT0, 01.01A01, max UDMA/133
[    1.140931] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 
31/32), AA
[    1.143674] ata1.00: configured for UDMA/133
[    1.158758] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-0 
01.0 PQ: 0 ANSI: 5
[    1.159118] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.159148] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.159241] sd 0:0:0:0: [sda] Write Protect is off
[    1.159283] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.210761]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.211375] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.620229] atl1c 0000:01:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps 
Full Duplex>
[    3.667258] console [netcon0] enabled
[    3.667368] netconsole: network logging started
[    3.667571] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 
0x60,0x64 irq 1,12
[    3.684896] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.685018] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.685227] mice: PS/2 mouse device common for all mice
[    3.685408] rtc_cmos 00:06: RTC can wake from S4
[    3.685579] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.685733] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.686016] cpuidle: using governor ladder
[    3.686371] cpuidle: using governor menu
[    3.686483] No iBFT detected.
[    3.686992] TCP cubic registered
[    3.687103] NET: Registered protocol family 17
[    3.687222] Registering the dns_resolver key type
[    3.688134] rtc_cmos 00:06: setting system clock to 2010-09-15 
16:20:47 UTC (1284567647)
[    3.711655] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    3.720108] EXT3-fs (sda6): error: couldn't mount because of 
unsupported optional features (240)
[    3.824528] EXT4-fs (sda6): mounted filesystem with writeback data 
mode. Opts: data=writeback
[    3.825017] VFS: Mounted root (ext4 filesystem) readonly on device 8:6.
[    3.825207] Freeing unused kernel memory: 404k freed
[    3.825485] Write protecting the kernel read-only data: 6144k
[    3.826188] Freeing unused kernel memory: 620k freed
[    3.826948] Freeing unused kernel memory: 944k freed
[    5.390836] udevd (102): /proc/102/oom_adj is deprecated, please use 
/proc/102/oom_score_adj instead.
[    5.592768] Linux agpgart interface v0.103
[    5.759951] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    5.760175] ACPI: Sleep Button [SLPB]
[    5.760458] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    5.763169] ACPI: Lid Switch [LID0]
[    5.763491] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.763698] ACPI: Power Button [PWRF]
[    5.779601] ACPI: WMI: Skipping duplicate GUID 
05901221-D566-11D1-B2F0-00A0C9062910
[    5.781743] ACPI: WMI: Mapper loaded
[    5.869268] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    5.914409] ACPI: Battery Slot [BAT0] (battery present)
[    5.918966] ACPI: AC Adapter [ADP1] (on-line)
[    6.130829] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) 
-> IRQ 19
[    6.131059] ACPI: resource 0000:00:1f.3 [io  0x3000-0x301f] conflicts 
with ACPI region SMBI [io  0x3000-0x300f window disabled]
[    6.131319] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    6.282321] acer-wmi: Acer Laptop ACPI-WMI Extras
[    6.284600] acer-wmi: Brightness must be controlled by generic video 
driver
[    6.360321] thermal LNXTHERM:01: registered as thermal_zone0
[    6.360478] ACPI: Thermal Zone [TZS0] (48 C)
[    6.367190] thermal LNXTHERM:02: registered as thermal_zone1
[    6.367336] ACPI: Thermal Zone [TZS1] (41 C)
[    6.530591] usbcore: registered new interface driver usbfs
[    6.530794] usbcore: registered new interface driver hub
[    6.531061] usbcore: registered new device driver usb
[    6.535194] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    6.537359] agpgart-intel 0000:00:00.0: detected 131068K stolen 
memory, trimming to 32768K
[    6.559095] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.663354] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    6.663575] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    6.663780] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.663981] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    6.664244] ehci_hcd 0000:00:1a.0: debug port 2
[    6.668341] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd4405c00
[    6.683722] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.683939] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.684077] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.684257] usb usb1: Product: EHCI Host Controller
[    6.684385] usb usb1: Manufacturer: Linux 2.6.36-rc4 ehci_hcd
[    6.684515] usb usb1: SerialNumber: 0000:00:1a.0
[    6.684805] hub 1-0:1.0: USB hub found
[    6.684948] hub 1-0:1.0: 3 ports detected
[    6.685245] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    6.685447] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.685600] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    6.686569] ehci_hcd 0000:00:1d.0: debug port 2
[    6.690641] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd4405800
[    6.703702] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.703908] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.704044] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.704224] usb usb2: Product: EHCI Host Controller
[    6.704350] usb usb2: Manufacturer: Linux 2.6.36-rc4 ehci_hcd
[    6.704481] usb usb2: SerialNumber: 0000:00:1d.0
[    6.704744] hub 2-0:1.0: USB hub found
[    6.704873] hub 2-0:1.0: 3 ports detected
[    6.932586] input: AlpsPS/2 ALPS GlidePoint as 
/devices/platform/i8042/serio1/input/input5
[    6.995532] usb 1-1: new high speed USB device using ehci_hcd and 
address 2
[    7.076671] usbcore: registered new interface driver usbserial
[    7.077166] USB Serial support registered for generic
[    7.128184] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    7.128347] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    7.129014] hub 1-1:1.0: USB hub found
[    7.129416] hub 1-1:1.0: 6 ports detected
[    7.178516] cfg80211: Calling CRDA to update world regulatory domain
[    7.239408] usb 2-1: new high speed USB device using ehci_hcd and 
address 2
[    7.371870] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.372038] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    7.372721] hub 2-1:1.0: USB hub found
[    7.372945] hub 2-1:1.0: 8 ports detected
[    7.435270] Error: Driver 'pcspkr' is already registered, aborting...
[    7.443493] usb 1-1.6: new high speed USB device using ehci_hcd and 
address 3
[    7.510615] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    7.711091] hda_codec: ALC271X: BIOS auto-probing.
[    7.711890] hda_codec: connection list not available for 0x24
[    7.713723] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[    7.799544] usb 1-1.6: New USB device found, idVendor=0bda, 
idProduct=0138
[    7.799713] usb 1-1.6: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    7.799953] usb 1-1.6: Product: USB2.0-CRW
[    7.800084] usb 1-1.6: Manufacturer: Generic
[    7.800217] usb 1-1.6: SerialNumber: 20090516388200000
[    7.816272] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
in-tree:
[    7.816510] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    7.816875] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[    7.817382] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) 
Advanced-N 6200 AGN, REV=0x74
[    7.834965] iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    7.835196] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 
802.11a channels
[    7.866108] Initializing USB Mass Storage driver...
[    7.866446] scsi4 : usb-storage 1-1.6:1.0
[    7.866700] usbcore: registered new interface driver usb-storage
[    7.866834] USB Mass Storage support registered.
[    7.875270] usb 2-1.5: new high speed USB device using ehci_hcd and 
address 3
[    8.001330] usb 2-1.5: New USB device found, idVendor=064e, 
idProduct=a219
[    8.001495] usb 2-1.5: New USB device strings: Mfr=2, Product=1, 
SerialNumber=3
[    8.001755] usb 2-1.5: Product: 1.3M WebCam
[    8.001880] usb 2-1.5: Manufacturer: Suyin
[    8.002003] usb 2-1.5: SerialNumber: HF1315-S32B-OV01-VA-R02.01.05
[    8.006411] usbcore: registered new interface driver usbserial_generic
[    8.006566] usbserial: USB Serial Driver core
[    8.206406] USB Serial support registered for GSM modem (1-port)
[    8.206629] usbcore: registered new interface driver option
[    8.206787] option: v0.7.2:USB Driver for GSM modems
[    8.232517] iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 
build 25532
[    8.316670] Linux video capture interface: v2.00
[    8.391729] uvcvideo: Found UVC 1.00 device 1.3M WebCam (064e:a219)
[    8.401699] input: 1.3M WebCam as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input7
[    8.402055] usbcore: registered new interface driver uvcvideo
[    8.402207] USB Video Class driver (v0.1.0)
[    8.694609] cfg80211: World regulatory domain updated:
[    8.694765]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[    8.695005]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    8.695161]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[    8.695313]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[    8.695471]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    8.695629]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    8.865797] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card 
  1.00 PQ: 0 ANSI: 0 CCS
[    8.867769] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    8.873486] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    9.996466] EXT4-fs (sda6): re-mounted. Opts: (null)
[   10.092805] EXT4-fs (sda6): Ignoring deprecated nobh option
[   10.095448] EXT4-fs (sda6): re-mounted. Opts: 
nobh,data=writeback,errors=remount-ro
[   10.272830] loop: module loaded
[   10.578772] fuse init (API version 7.15)
[   12.154833] NET: Registered protocol family 10
[   12.156215] lo: Disabled Privacy Extensions
[   12.545274] RPC: Registered udp transport module.
[   12.545486] RPC: Registered tcp transport module.
[   12.545737] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.623061] FS-Cache: Loaded
[   12.892162] FS-Cache: Netfs 'nfs' registered for caching
[   13.009734] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   18.008753] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match 
expected value (found 11, expected 18)
[   18.008999] intel ips 0000:00:1f.6: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[   18.009632] intel ips 0000:00:1f.6: failed to get i915 symbols, 
graphics turbo disabled
[   18.010050] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp 
limit 65535
[   23.206133] general protection fault: 0000 [#1] PREEMPT SMP
[   23.206484] last sysfs file: /sys/bus/pci/drivers/intel ips/uevent
[   23.206625] CPU 3
[   23.206704] Modules linked in: intel_ips nfsd exportfs nfs lockd 
fscache auth_rpcgss sunrpc ipv6 fuse loop arc4 uvcvideo ecb videodev 
option usb_wwan v4l1_compat v4l2_compat_ioctl32 usb_storage 
snd_hda_codec_intelhdmi iwlagn snd_hda_codec_realtek iwlcore mac80211 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss cfg80211 
snd_pcm usbserial snd_timer video ehci_hcd intel_agp usbcore psmouse snd 
thermal acer_wmi processor i2c_i801 backlight soundcore nls_base rfkill 
serio_raw pcspkr output snd_page_alloc i2c_core led_class wmi ac evdev 
button battery thermal_sys agpgart
[   23.211688]
[   23.211811] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-rc4 #4 Base 
Board Product Name/Aspire 1830T
[   23.212008] RIP: 0010:[<ffffffffa01720e9>]  [<ffffffffa01720e9>] 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   23.212282] RSP: 0018:ffff8800018c3f80  EFLAGS: 00010002
[   23.212420] RAX: 0000000100000009 RBX: ffff880001892f40 RCX: 
0000000000000199
[   23.212563] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
ffff8801354ad840
[   23.212708] RBP: 0000000000000003 R08: 0000000000000001 R09: 
0000000000000001
[   23.212852] R10: 0000000000000001 R11: 0000000000000001 R12: 
00000000ffffffff
[   23.212996] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000000
[   23.213141] FS:  0000000000000000(0000) GS:ffff8800018c0000(0000) 
knlGS:0000000000000000
[   23.213335] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.213474] CR2: 00007fe9726be00f CR3: 000000000161c000 CR4: 
00000000000006e0
[   23.213618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   23.213762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   23.213907] Process kworker/0:1 (pid: 0, threadinfo ffff880137d7e000, 
task ffff880137c9f770)
[   23.214101] Stack:
[   23.214223]  ffffffff8106ee1c 0000000000000008 ffff880137d7fe40 
0000000000000005
[   23.214575] <0> ffffffff8101d072 ffff880137d7fe40 ffffffff81003913 
ffff880137d7fe40 <EOI>
[   23.215172] <0> 0000000000000000 0000000000000001 00000005ae1d6bfc 
00000000000000c8
[   23.215816] Call Trace:
[   23.216665]  <IRQ>
[   23.216829]  [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.217010]  [<ffffffff8101d072>] ? smp_call_function_interrupt+0x22/0x40
[   23.217140]  [<ffffffff81003913>] ? call_function_interrupt+0x13/0x20
[   23.217263]  <EOI>
[   23.217424]  [<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.217547]  [<ffffffff8120b976>] ? intel_idle+0x86/0xf0
[   23.217671]  [<ffffffff812b6892>] ? cpuidle_idle_call+0x92/0x100
[   23.217795]  [<ffffffff81001907>] ? cpu_idle+0x57/0xc0
[   23.217914] Code: 00 00 b9 99 01 00 00 0f 32 48 c1 e2 20 89 c0 48 09 
c2 48 b8 00 00 00 00 01 00 00 00 48 85 c2 75 0c 48 09 d0 48 89 c2 48 c1 
ea 20 <0f> 30 f3 c3 0f 1f 00 0f b7 c6 66 d1 ef 6b c0 64 d1 f8 8d 04 07
[   23.221510] RIP  [<ffffffffa01720e9>] do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   23.221738]  RSP <ffff8800018c3f80>
[   23.221851] ---[ end trace e34c375ac83f1124 ]---
[   23.221859] general protection fault: 0000 [#2] PREEMPT SMP
[   23.221867] last sysfs file: /sys/bus/pci/drivers/intel ips/uevent
[   23.221870] CPU 0
[   23.221872] Modules linked in: intel_ips nfsd exportfs nfs lockd 
fscache auth_rpcgss sunrpc ipv6 fuse loop arc4 uvcvideo ecb videodev 
option usb_wwan v4l1_compat v4l2_compat_ioctl32 usb_storage 
snd_hda_codec_intelhdmi iwlagn snd_hda_codec_realtek iwlcore mac80211 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss cfg80211 
snd_pcm usbserial snd_timer video ehci_hcd intel_agp usbcore psmouse snd 
thermal acer_wmi processor i2c_i801 backlight soundcore nls_base rfkill 
serio_raw pcspkr output snd_page_alloc i2c_core led_class wmi ac evdev 
button battery thermal_sys agpgart
[   23.221930]
[   23.221935] Pid: 0, comm: swapper Tainted: G      D     2.6.36-rc4 #4 
Base Board Product Name/Aspire 1830T
[   23.221940] RIP: 0010:[<ffffffffa01720e9>]  [<ffffffffa01720e9>] 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   23.221950] RSP: 0018:ffff880001803f80  EFLAGS: 00010002
[   23.221954] RAX: 0000000100000009 RBX: ffff880001892f40 RCX: 
0000000000000199
[   23.221958] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
ffff8801354ad840
[   23.221962] RBP: 0000000000000000 R08: 0000000000000001 R09: 
0000000000000001
[   23.221966] R10: 0000000000000001 R11: 0000000000000001 R12: 
00000000ffffffff
[   23.221970] R13: ffffffffffffffff R14: 0000000000075000 R15: 
fffffffff000bd02
[   23.221975] FS:  0000000000000000(0000) GS:ffff880001800000(0000) 
knlGS:0000000000000000
[   23.221980] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.221984] CR2: 0000000001e9a2a0 CR3: 0000000137eac000 CR4: 
00000000000006f0
[   23.221988] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   23.221993] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   23.221997] Process swapper (pid: 0, threadinfo ffffffff81600000, 
task ffffffff81624020)
[   23.222000] Stack:
[   23.222002]  ffffffff8106ee1c 0000000000000008 ffffffff81601e80 
000000000000bbfd
[   23.222009] <0> ffffffff8101d072 ffffffff81601e80 ffffffff81003913 
ffffffff81601e80 <EOI>
[   23.222018] <0> 0000000000000000 0000000000000001 0000000593a832cd 
00000000000000c8
[   23.222026] Call Trace:
[   23.222028]  <IRQ>
[   23.222037]  [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.222045]  [<ffffffff8101d072>] ? smp_call_function_interrupt+0x22/0x40
[   23.222052]  [<ffffffff81003913>] ? call_function_interrupt+0x13/0x20
[   23.222057]  <EOI>
[   23.222064]  [<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.222069]  [<ffffffff8120b976>] ? intel_idle+0x86/0xf0
[   23.222076]  [<ffffffff812b6892>] ? cpuidle_idle_call+0x92/0x100
[   23.222082]  [<ffffffff81001907>] ? cpu_idle+0x57/0xc0
[   23.222092]  [<ffffffff8166ec04>] ? start_kernel+0x2d3/0x2de
[   23.222099]  [<ffffffff8166e3c4>] ? x86_64_start_kernel+0xe5/0xe9
[   23.222102] Code: 00 00 b9 99 01 00 00 0f 32 48 c1 e2 20 89 c0 48 09 
c2 48 b8 00 00 00 00 01 00 00 00 48 85 c2 75 0c 48 09 d0 48 89 c2 48 c1 
ea 20 <0f> 30 f3 c3 0f 1f 00 0f b7 c6 66 d1 ef 6b c0 64 d1 f8 8d 04 07
[   23.222147] RIP  [<ffffffffa01720e9>] do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   23.222155]  RSP <ffff880001803f80>
[   23.222159] ---[ end trace e34c375ac83f1125 ]---
[   23.222163] general protection fault: 0000 [#3] PREEMPT SMP
[   23.222168] Kernel panic - not syncing: Fatal exception in interrupt
[   23.222170]
[   23.222174] Pid: 0, comm: swapper Tainted: G      D     2.6.36-rc4 #4
[   23.222177] last sysfs file: /sys/bus/pci/drivers/intel ips/uevent
[   23.222180] Call Trace:
[   23.222182] CPU 1  <IRQ>
[   23.222185] Modules linked in: intel_ips [<ffffffff8135b096>] ? 
panic+0x9c/0x1a3
[   23.222193]  nfsd exportfs [<ffffffff8135df2e>] ? 
_raw_spin_trylock+0xe/0x70
[   23.222202]  nfs lockd [<ffffffff8100742f>] ? oops_end+0xdf/0xe0
[   23.222211]  fscache auth_rpcgss [<ffffffff8135e55f>] ? 
general_protection+0x1f/0x30
[   23.222218]  sunrpc ipv6 [<ffffffffa01720e9>] ? 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   23.222226]  fuse loop [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.222235]  arc4 uvcvideo [<ffffffff8101d072>] ? 
smp_call_function_interrupt+0x22/0x40
[   23.222242]  ecb videodev [<ffffffff81003913>] ? 
call_function_interrupt+0x13/0x20
[   23.222250]  option <EOI>  usb_wwan v4l1_compat v4l2_compat_ioctl32 
[<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.222259]  usb_storage snd_hda_codec_intelhdmi [<ffffffff8120b976>] 
? intel_idle+0x86/0xf0
[   23.222266]  iwlagn snd_hda_codec_realtek [<ffffffff812b6892>] ? 
cpuidle_idle_call+0x92/0x100
[   23.222274]  iwlcore mac80211 [<ffffffff81001907>] ? cpu_idle+0x57/0xc0
[   23.222281]  snd_hda_intel snd_hda_codec [<ffffffff8166ec04>] ? 
start_kernel+0x2d3/0x2de
[   23.222288]  snd_hwdep snd_pcm_oss [<ffffffff8166e3c4>] ? 
x86_64_start_kernel+0xe5/0xe9
[   23.222296]  snd_mixer_oss cfg80211 snd_pcm usbserial snd_timer video 
ehci_hcd intel_agp usbcore psmouse snd thermal acer_wmi processor 
i2c_i801 backlight soundcore nls_base rfkill serio_raw pcspkr output 
snd_page_alloc i2c_core led_class wmi ac evdev button battery 
thermal_sys agpgart
[   23.222325]
[   23.222330] Pid: 0, comm: kworker/0:0 Tainted: G      D 
2.6.36-rc4 #4 Base Board Product Name/Aspire 1830T
[   23.222335] RIP: 0010:[<ffffffffa01720e9>]  [<ffffffffa01720e9>] 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   23.222344] RSP: 0018:ffff880001843f80  EFLAGS: 00010002
[   23.222348] RAX: 0000000100000005 RBX: ffff880001892f40 RCX: 
0000000000000199
[   23.222353] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
ffff8801354ad840
[   23.222357] RBP: 0000000000000001 R08: 0000000000000001 R09: 
0000000000000001
[   23.222361] R10: 0000000000000001 R11: 0000000000000001 R12: 
00000000ffffffff
[   23.222365] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000000
[   23.222370] FS:  0000000000000000(0000) GS:ffff880001840000(0000) 
knlGS:0000000000000000
[   23.222374] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.222379] CR2: 0000000001e9c808 CR3: 0000000135c8e000 CR4: 
00000000000006e0
[   23.222383] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   23.222388] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   23.222392] Process kworker/0:0 (pid: 0, threadinfo ffff880137d56000, 
task ffff880137c9be90)
[   23.222396] Stack:
[   23.222398]  ffffffff8106ee1c 0000000000000008 ffff880137d57e40 
000000000000bbd5
[   23.222404] <0> ffffffff8101d072 ffff880137d57e40 ffffffff81003913 
ffff880137d57e40 <EOI>
[   23.222412] <0> 0000000000000000 0000000000000001 00000005a231a9fc 
00000000000000c8
[   23.222420] Call Trace:
[   23.222423]  <IRQ>
[   23.222430]  [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.222437]  [<ffffffff8101d072>] ? smp_call_function_interrupt+0x22/0x40
[   23.222443]  [<ffffffff81003913>] ? call_function_interrupt+0x13/0x20
[   23.222447]  <EOI>
[   23.222453]  [<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.222458]  [<ffffffff8120b976>] ? intel_idle+0x86/0xf0
[   23.222465]  [<ffffffff812b6892>] ? cpuidle_idle_call+0x92/0x100
[   23.222470]  [<ffffffff81001907>] ? cpu_idle+0x57/0xc0
[   23.222474] Code: 00 00 b9 99 01 00 00 0f 32 48 c1 e2 20 89 c0 48 09 
c2 48 b8 00 00 00 00 01 00 00 00 48 85 c2 75 0c 48 09 d0 48 89 c2 48 c1 
ea 20 <0f> 30 f3 c3 0f 1f 00 0f b7 c6 66 d1 ef 6b c0 64 d1 f8 8d 04 07
[   23.222522] RIP  [<ffffffffa01720e9>] do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   23.222530]  RSP <ffff880001843f80>
[   23.222533] ---[ end trace e34c375ac83f1126 ]---
[   23.222537] Kernel panic - not syncing: Fatal exception in interrupt
[   23.222542] Pid: 0, comm: kworker/0:0 Tainted: G      D     2.6.36-rc4 #4
[   23.222546] Call Trace:
[   23.222548]  <IRQ>  [<ffffffff8135b096>] ? panic+0x9c/0x1a3
[   23.222558]  [<ffffffff8135df2e>] ? _raw_spin_trylock+0xe/0x70
[   23.222565]  [<ffffffff8100742f>] ? oops_end+0xdf/0xe0
[   23.222571]  [<ffffffff8135e55f>] ? general_protection+0x1f/0x30
[   23.222579]  [<ffffffffa01720e9>] ? do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   23.222587]  [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.222593]  [<ffffffff8101d072>] ? smp_call_function_interrupt+0x22/0x40
[   23.222599]  [<ffffffff81003913>] ? call_function_interrupt+0x13/0x20
[   23.222603]  <EOI>  [<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.222613]  [<ffffffff8120b976>] ? intel_idle+0x86/0xf0
[   23.222619]  [<ffffffff812b6892>] ? cpuidle_idle_call+0x92/0x100
[   23.222625]  [<ffffffff81001907>] ? cpu_idle+0x57/0xc0
[   23.236887] Kernel panic - not syncing: Fatal exception in interrupt
[   23.237009] Pid: 0, comm: kworker/0:1 Tainted: G      D     2.6.36-rc4 #4
[   23.237130] Call Trace:
[   23.237233]  <IRQ>  [<ffffffff8135b096>] ? panic+0x9c/0x1a3
[   23.237409]  [<ffffffff8135df2e>] ? _raw_spin_trylock+0xe/0x70
[   23.237531]  [<ffffffff8100742f>] ? oops_end+0xdf/0xe0
[   23.237650]  [<ffffffff8135e55f>] ? general_protection+0x1f/0x30
[   23.237773]  [<ffffffffa01720e9>] ? do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   23.238671]  [<ffffffff8106ee1c>] ? 
generic_smp_call_function_interrupt+0x5c/0x110
[   23.238845]  [<ffffffff8101d072>] ? smp_call_function_interrupt+0x22/0x40
[   23.238971]  [<ffffffff81003913>] ? call_function_interrupt+0x13/0x20
[   23.239091]  <EOI>  [<ffffffff8120b996>] ? intel_idle+0xa6/0xf0
[   23.239268]  [<ffffffff8120b976>] ? intel_idle+0x86/0xf0
[   23.239388]  [<ffffffff812b6892>] ? cpuidle_idle_call+0x92/0x100
[   23.239509]  [<ffffffff81001907>] ? cpu_idle+0x57/0xc0



UP non-panic dmesg:

[    0.000000] Linux version 2.6.36-rc4 (root@mobility) (gcc version 
4.4.5 20100824 (prerelease) (Debian 4.4.4-11) ) #4 SMP PREEMPT Wed Sep 
15 14:08:01 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc4 
root=/dev/sda6 ro single rootflags=data=writeback 
netconsole=4444@192.168.0.63/eth0,9353@192.168.0.3/00:15:17:21:1f:02 
maxcpus=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b363f000 (usable)
[    0.000000]  BIOS-e820: 00000000b363f000 - 00000000b36bf000 (reserved)
[    0.000000]  BIOS-e820: 00000000b36bf000 - 00000000b37bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b37bf000 - 00000000b37ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b37ff000 - 00000000b3800000 (usable)
[    0.000000]  BIOS-e820: 00000000b3800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or 
disabled in BIOS!
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] last_pfn = 0xb3800 max_arch_pfn = 0x400000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000b3800000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 00000000b37fe120 00074 (v01 ACRSYS ACRPRDCT 
00000001      01000013)
[    0.000000] ACPI: FACP 00000000b37fc000 000F4 (v04 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: DSDT 00000000b37ea000 0EB16 (v02 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: FACS 00000000b376e000 00040
[    0.000000] ACPI: ASF! 00000000b37fd000 000A5 (v32 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: HPET 00000000b37fb000 00038 (v01 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: APIC 00000000b37fa000 0008C (v02 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: MCFG 00000000b37f9000 0003C (v01 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: SLIC 00000000b37e9000 00176 (v01 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: BOOT 00000000b37e5000 00028 (v01 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: ASPT 00000000b37e2000 00034 (v04 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: WDAT 00000000b37e1000 00224 (v01 ACRSYS ACRPRDCT 
00000001 1025 01000013)
[    0.000000] ACPI: SSDT 00000000b37e0000 009F1 (v01  PmRef    CpuPm 
00003000 INTL 20051117)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000b363f
[    0.000000]     0: 0x000b37ff -> 0x000b3800
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000b363f000 - 
00000000b36bf000
[    0.000000] PM: Registered nosave memory: 00000000b36bf000 - 
00000000b37bf000
[    0.000000] PM: Registered nosave memory: 00000000b37bf000 - 
00000000b37ff000
[    0.000000] PM: Registered nosave memory: 00000000b3800000 - 
00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 
00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 
00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 
00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 
00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 
00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 
00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 
00000000fed1b000
[    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 
00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001800000 s78144 
r8192 d24256 u262144
[    0.000000] pcpu-alloc: s78144 r8192 d24256 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 946588
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc4 
root=/dev/sda6 ro single rootflags=data=writeback 
netconsole=4444@192.168.0.63/eth0,9353@192.168.0.3/00:15:17:21:1f:02 
maxcpus=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (65 early reservations)
[    0.000000]   #1 [0001000000 - 000175f010]   TEXT DATA BSS
[    0.000000]   #2 [000009d000 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0001760000 - 0001760372]             BRK
[    0.000000]   #4 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #5 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #6 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #7 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #8 [0001760380 - 0001761380]         BOOTMEM
[    0.000000]   #9 [0000007000 - 00000072d0]         BOOTMEM
[    0.000000]   #10 [0001f62000 - 0001f63000]         BOOTMEM
[    0.000000]   #11 [0001f63000 - 0001f64000]         BOOTMEM
[    0.000000]   #12 [0002000000 - 0005800000]        MEMMAP 0
[    0.000000]   #13 [0001761380 - 0001779380]         BOOTMEM
[    0.000000]   #14 [0001779380 - 0001791380]         BOOTMEM
[    0.000000]   #15 [0001791380 - 00017a9380]         BOOTMEM
[    0.000000]   #16 [00017aa000 - 00017ab000]         BOOTMEM
[    0.000000]   #17 [000175f040 - 000175f081]         BOOTMEM
[    0.000000]   #18 [000175f0c0 - 000175f103]         BOOTMEM
[    0.000000]   #19 [000175f140 - 000175f568]         BOOTMEM
[    0.000000]   #20 [000175f580 - 000175f5e8]         BOOTMEM
[    0.000000]   #21 [000175f600 - 000175f668]         BOOTMEM
[    0.000000]   #22 [000175f680 - 000175f6e8]         BOOTMEM
[    0.000000]   #23 [000175f700 - 000175f768]         BOOTMEM
[    0.000000]   #24 [000175f780 - 000175f7e8]         BOOTMEM
[    0.000000]   #25 [000175f800 - 000175f868]         BOOTMEM
[    0.000000]   #26 [000175f880 - 000175f8e8]         BOOTMEM
[    0.000000]   #27 [000175f900 - 000175f968]         BOOTMEM
[    0.000000]   #28 [000175f980 - 000175f9e8]         BOOTMEM
[    0.000000]   #29 [000175fa00 - 000175fa68]         BOOTMEM
[    0.000000]   #30 [000175fa80 - 000175fae8]         BOOTMEM
[    0.000000]   #31 [000175fb00 - 000175fb68]         BOOTMEM
[    0.000000]   #32 [000175fb80 - 000175fbe8]         BOOTMEM
[    0.000000]   #33 [000175fc00 - 000175fc68]         BOOTMEM
[    0.000000]   #34 [000175fc80 - 000175fce8]         BOOTMEM
[    0.000000]   #35 [000175fd00 - 000175fd68]         BOOTMEM
[    0.000000]   #36 [000175fd80 - 000175fde8]         BOOTMEM
[    0.000000]   #37 [000175fe00 - 000175fe68]         BOOTMEM
[    0.000000]   #38 [000175fe80 - 000175fea0]         BOOTMEM
[    0.000000]   #39 [000175fec0 - 000175fee0]         BOOTMEM
[    0.000000]   #40 [000175ff00 - 000175ff20]         BOOTMEM
[    0.000000]   #41 [000175ff40 - 000175ffe5]         BOOTMEM
[    0.000000]   #42 [00017a9380 - 00017a9425]         BOOTMEM
[    0.000000]   #43 [0001800000 - 000181b000]         BOOTMEM
[    0.000000]   #44 [0001840000 - 000185b000]         BOOTMEM
[    0.000000]   #45 [0001880000 - 000189b000]         BOOTMEM
[    0.000000]   #46 [00018c0000 - 00018db000]         BOOTMEM
[    0.000000]   #47 [0001900000 - 000191b000]         BOOTMEM
[    0.000000]   #48 [0001940000 - 000195b000]         BOOTMEM
[    0.000000]   #49 [0001980000 - 000199b000]         BOOTMEM
[    0.000000]   #50 [00019c0000 - 00019db000]         BOOTMEM
[    0.000000]   #51 [00017a9440 - 00017a9448]         BOOTMEM
[    0.000000]   #52 [00017a9480 - 00017a9488]         BOOTMEM
[    0.000000]   #53 [00017a94c0 - 00017a94e0]         BOOTMEM
[    0.000000]   #54 [00017a9500 - 00017a9540]         BOOTMEM
[    0.000000]   #55 [00017a9540 - 00017a9660]         BOOTMEM
[    0.000000]   #56 [00017a9680 - 00017a96c8]         BOOTMEM
[    0.000000]   #57 [00017a9700 - 00017a9748]         BOOTMEM
[    0.000000]   #58 [00017ab000 - 00017b3000]         BOOTMEM
[    0.000000]   #59 [00019db000 - 0001ddb000]         BOOTMEM
[    0.000000]   #60 [0005800000 - 0005a00000]         BOOTMEM
[    0.000000]   #61 [0005a00000 - 0009a00000]         BOOTMEM
[    0.000000]   #62 [00017b3000 - 00017d3000]         BOOTMEM
[    0.000000]   #63 [0001ddb000 - 0001e1b000]         BOOTMEM
[    0.000000]   #64 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3718004k/5111808k available (3459k kernel code, 
1255568k absent, 138236k reserved, 3037k data, 404k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 1197.143 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 2394.28 BogoMIPS (lpj=4788572)
[    0.000231] pid_max: default: 32768 minimum: 301
[    0.000369] Mount-cache hash table entries: 256
[    0.000623] CPU: Physical Processor ID: 0
[    0.000730] CPU: Processor Core ID: 0
[    0.000840] mce: CPU supports 9 MCE banks
[    0.000960] CPU0: Thermal monitoring enabled (TM1)
[    0.001079] using mwait in idle threads.
[    0.001185] Performance Events: PEBS fmt1+, Westmere events, Intel 
PMU driver.
[    0.001492] ... version:                3
[    0.001598] ... bit width:              48
[    0.001704] ... generic registers:      4
[    0.001812] ... value mask:             0000ffffffffffff
[    0.001923] ... max period:             000000007fffffff
[    0.002033] ... fixed-purpose events:   3
[    0.002140] ... event mask:             000000070000000f
[    0.002338] SMP alternatives: switching to UP code
[    0.006856] ACPI: Core revision 20100702
[    0.058678] Setting APIC routing to flat
[    0.059208] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.098996] CPU0: Intel(R) Core(TM) i3 CPU       U 330  @ 1.20GHz 
stepping 05
[    0.215361] NMI watchdog enabled, takes one hw-pmu counter.
[    0.219117] Brought up 1 CPUs
[    0.219232] Total of 1 processors activated (2394.28 BogoMIPS).
[    0.219471] devtmpfs: initialized
[    0.221871] NET: Registered protocol family 16
[    0.222073] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.222239] ACPI: bus type pci registered
[    0.222443] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.222616] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.294603] PCI: Using configuration type 1 for base access
[    0.295423] bio: create slab <bio-0> at 0
[    0.304834] ACPI: Executed 1 blocks of module-level executable AML code
[    0.315192] ACPI: BIOS _OSI(Linux) query ignored
[    0.316622] ACPI: SSDT 00000000b3691c18 00264 (v01  PmRef  Cpu0Ist 
00003000 INTL 20051117)
[    0.318046] ACPI: Dynamic OEM Table Load:
[    0.318248] ACPI: SSDT (null) 00264 (v01  PmRef  Cpu0Ist 00003000 
INTL 20051117)
[    0.319154] ACPI: SSDT 00000000b368f018 00891 (v01  PmRef  Cpu0Cst 
00003001 INTL 20051117)
[    0.320498] ACPI: Dynamic OEM Table Load:
[    0.320699] ACPI: SSDT (null) 00891 (v01  PmRef  Cpu0Cst 00003001 
INTL 20051117)
[    0.321700] ACPI: SSDT 00000000b3690a98 00303 (v01  PmRef    ApIst 
00003000 INTL 20051117)
[    0.323200] ACPI: Dynamic OEM Table Load:
[    0.323402] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 
INTL 20051117)
[    0.323947] ACPI: SSDT 00000000b368ed98 00119 (v01  PmRef    ApCst 
00003000 INTL 20051117)
[    0.325388] ACPI: Dynamic OEM Table Load:
[    0.325587] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 
INTL 20051117)
[    0.352446] ACPI: Interpreter enabled
[    0.352555] ACPI: (supports S0 S3 S4 S5)
[    0.352913] ACPI: Using IOAPIC for interrupt routing
[    0.369369] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.369964] ACPI: No dock devices found.
[    0.370074] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.371358] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.373386] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.373505] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.373625] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.373793] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfeafffff]
[    0.382444] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.382979] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.383229] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive 
decode)
[    0.391738] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.392542] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 
14 15)
[    0.393308] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 
14 15) *10
[    0.394161] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.395072] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 
14 15)
[    0.395837] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.396740] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *10
[    0.397596] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.398450] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.399233] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.399412] vgaarb: loaded
[    0.399595] SCSI subsystem initialized
[    0.399775] PCI: Using ACPI for IRQ routing
[    0.400162] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.400696] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.402830] Switching to clocksource tsc
[    0.402978] pnp: PnP ACPI init
[    0.403103] ACPI: bus type pnp registered
[    0.404756] pnp 00:05: disabling [io  0x164e-0x164f] because it 
overlaps 0000:00:1c.1 BAR 7 [io  0x1000-0x1fff]
[    0.406268] pnp: PnP ACPI: found 11 devices
[    0.406377] ACPI: ACPI bus type pnp unregistered
[    0.406497] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.406612] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.406728] system 00:05: [io  0xffff] has been reserved
[    0.406840] system 00:05: [io  0xffff] has been reserved
[    0.406952] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.407074] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.407194] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.407311] system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.407429] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.407547] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.407664] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.407781] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.407898] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.408017] system 00:09: [mem 0xff000000-0xffffffff] could not be 
reserved
[    0.408135] system 00:09: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.408254] system 00:09: [mem 0xd4500000-0xd4500fff] has been reserved
[    0.414957] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.415081] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.415202] pci 0000:00:1c.0:   bridge window [mem 0xd3400000-0xd43fffff]
[    0.415324] pci 0000:00:1c.0:   bridge window [mem 
0xd0400000-0xd13fffff 64bit pref]
[    0.415496] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.415609] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.415730] pci 0000:00:1c.1:   bridge window [mem 0xd2400000-0xd33fffff]
[    0.415851] pci 0000:00:1c.1:   bridge window [mem 
0xd1400000-0xd23fffff 64bit pref]
[    0.416025] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.416136] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.416255] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.416371] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.416512] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.416652] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.416880] NET: Registered protocol family 2
[    0.417076] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.417748] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.419279] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.419698] TCP: Hash tables configured (established 262144 bind 65536)
[    0.419814] TCP reno registered
[    0.419920] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.420059] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.420326] NET: Registered protocol family 1
[    0.451087] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.451206] Placing 64MB software IO TLB between ffff880005a00000 - 
ffff880009a00000
[    0.451372] software IO TLB at phys 0x5a00000 - 0x9a00000
[    0.451527] Simple Boot Flag at 0x44 set to 0x1
[    0.452264] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.454160] VFS: Disk quotas dquot_6.5.2
[    0.454354] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.455002] msgmni has been set to 7261
[    0.455363] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.455530] io scheduler noop registered
[    0.455636] io scheduler deadline registered
[    0.455787] io scheduler cfq registered (default)
[    0.456768] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.457400] SCSI Media Changer driver v0.25
[    0.457570] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.457831] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 
0x1 impl SATA mode
[    0.458000] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo 
pio slum part ems apst
[    0.458298] scsi0 : ahci
[    0.458509] scsi1 : ahci
[    0.458677] scsi2 : ahci
[    0.458843] scsi3 : ahci
[    0.459741] ata1: SATA max UDMA/133 abar m2048@0xd4405000 port 
0xd4405100 irq 40
[    0.459905] ata2: DUMMY
[    0.460007] ata3: DUMMY
[    0.460109] ata4: DUMMY
[    0.460299] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    0.587490] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    0.587623] netconsole: local port 4444
[    0.587730] netconsole: local IP 192.168.0.63
[    0.587837] netconsole: interface 'eth0'
[    0.587943] netconsole: remote port 9353
[    0.588050] netconsole: remote IP 192.168.0.3
[    0.588159] netconsole: remote ethernet address 00:15:17:21:1f:02
[    0.588273] netconsole: device eth0 not up yet, forcing it
[    0.778804] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.817789] ata1.00: ATA-8: WDC WD5000BEVT-00ZAT0, 01.01A01, max UDMA/133
[    0.817921] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 
31/32), AA
[    0.821287] ata1.00: configured for UDMA/133
[    0.834917] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-0 
01.0 PQ: 0 ANSI: 5
[    0.835259] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.835482] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    0.835702] sd 0:0:0:0: [sda] Write Protect is off
[    0.835840] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.877090]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    0.877599] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.454645] atl1c 0000:01:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps 
Full Duplex>
[    3.503465] console [netcon0] enabled
[    3.503576] netconsole: network logging started
[    3.503784] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 
0x60,0x64 irq 1,12
[    3.521302] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.521466] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.521692] mice: PS/2 mouse device common for all mice
[    3.521973] rtc_cmos 00:06: RTC can wake from S4
[    3.522138] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.522292] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.522465] cpuidle: using governor ladder
[    3.522633] cpuidle: using governor menu
[    3.522743] No iBFT detected.
[    3.523243] TCP cubic registered
[    3.523354] NET: Registered protocol family 17
[    3.523487] Registering the dns_resolver key type
[    3.524346] rtc_cmos 00:06: setting system clock to 2010-09-15 
16:21:52 UTC (1284567712)
[    3.545924] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    3.553480] EXT3-fs (sda6): error: couldn't mount because of 
unsupported optional features (240)
[    3.558113] EXT4-fs (sda6): INFO: recovery required on readonly 
filesystem
[    3.558353] EXT4-fs (sda6): write access will be enabled during recovery
[    3.631958] EXT4-fs (sda6): recovery complete
[    3.633507] EXT4-fs (sda6): mounted filesystem with writeback data 
mode. Opts: data=writeback
[    3.633860] VFS: Mounted root (ext4 filesystem) readonly on device 8:6.
[    3.634019] Freeing unused kernel memory: 404k freed
[    3.634250] Write protecting the kernel read-only data: 6144k
[    3.634561] Freeing unused kernel memory: 620k freed
[    3.634946] Freeing unused kernel memory: 944k freed
[    5.202737] udevd (86): /proc/86/oom_adj is deprecated, please use 
/proc/86/oom_score_adj instead.
[    5.535557] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    5.635350] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    5.635623] ACPI: Sleep Button [SLPB]
[    5.635813] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
[    5.642329] ACPI: Lid Switch [LID0]
[    5.642544] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    5.642808] ACPI: Power Button [PWRF]
[    5.667271] ACPI: WMI: Skipping duplicate GUID 
05901221-D566-11D1-B2F0-00A0C9062910
[    5.667963] ACPI: WMI: Mapper loaded
[    5.800249] ACPI: Battery Slot [BAT0] (battery present)
[    5.810015] ACPI: AC Adapter [ADP1] (on-line)
[    5.812450] thermal LNXTHERM:01: registered as thermal_zone0
[    5.812615] ACPI: Thermal Zone [TZS0] (48 C)
[    5.823860] thermal LNXTHERM:02: registered as thermal_zone1
[    5.824016] ACPI: Thermal Zone [TZS1] (41 C)
[    5.874130] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) 
-> IRQ 19
[    5.874332] ACPI: resource 0000:00:1f.3 [io  0x3000-0x301f] conflicts 
with ACPI region SMBI [dma 12288-12303 pref window disabled]
[    5.874544] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    5.905177] Linux agpgart interface v0.103
[    6.144975] usbcore: registered new interface driver usbfs
[    6.145343] usbcore: registered new interface driver hub
[    6.145692] usbcore: registered new device driver usb
[    6.373750] acer-wmi: Acer Laptop ACPI-WMI Extras
[    6.376463] acer-wmi: Brightness must be controlled by generic video 
driver
[    6.643279] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    6.646189] agpgart-intel 0000:00:00.0: detected 131068K stolen 
memory, trimming to 32768K
[    6.662736] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.738481] cfg80211: Calling CRDA to update world regulatory domain
[    6.798434] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    6.798785] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    6.798951] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.799111] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    6.799328] ehci_hcd 0000:00:1a.0: debug port 2
[    6.804748] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd4405c00
[    6.820196] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.820435] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.820571] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.820750] usb usb1: Product: EHCI Host Controller
[    6.821042] usb usb1: Manufacturer: Linux 2.6.36-rc4 ehci_hcd
[    6.821177] usb usb1: SerialNumber: 0000:00:1a.0
[    6.822828] hub 1-0:1.0: USB hub found
[    6.822963] hub 1-0:1.0: 3 ports detected
[    6.823214] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    6.823403] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.823547] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    6.823764] ehci_hcd 0000:00:1d.0: debug port 2
[    6.829128] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xd4405800
[    6.846360] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.846581] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.846722] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.847639] usb usb2: Product: EHCI Host Controller
[    6.847769] usb usb2: Manufacturer: Linux 2.6.36-rc4 ehci_hcd
[    6.847902] usb usb2: SerialNumber: 0000:00:1d.0
[    6.848305] hub 2-0:1.0: USB hub found
[    6.848439] hub 2-0:1.0: 3 ports detected
[    7.007166] input: AlpsPS/2 ALPS GlidePoint as 
/devices/platform/i8042/serio1/input/input5
[    7.132121] usb 1-1: new high speed USB device using ehci_hcd and 
address 2
[    7.264397] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    7.264556] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    7.265127] hub 1-1:1.0: USB hub found
[    7.265392] hub 1-1:1.0: 6 ports detected
[    7.375963] usb 2-1: new high speed USB device using ehci_hcd and 
address 2
[    7.510840] Error: Driver 'pcspkr' is already registered, aborting...
[    7.511016] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.511151] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    7.511539] hub 2-1:1.0: USB hub found
[    7.511885] hub 2-1:1.0: 8 ports detected
[    7.583970] usb 1-1.6: new high speed USB device using ehci_hcd and 
address 3
[    7.698636] usbcore: registered new interface driver usbserial
[    7.698976] USB Serial support registered for generic
[    7.760122] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
in-tree:
[    7.760313] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    7.760537] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[    7.760843] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) 
Advanced-N 6200 AGN, REV=0x74
[    7.777093] iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    7.777256] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 
802.11a channels
[    7.933404] usb 1-1.6: New USB device found, idVendor=0bda, 
idProduct=0138
[    7.933562] usb 1-1.6: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    7.933754] usb 1-1.6: Product: USB2.0-CRW
[    7.933877] usb 1-1.6: Manufacturer: Generic
[    7.934001] usb 1-1.6: SerialNumber: 20090516388200000
[    7.946259] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    8.011873] usb 2-1.5: new high speed USB device using ehci_hcd and 
address 3
[    8.027707] Initializing USB Mass Storage driver...
[    8.027969] scsi4 : usb-storage 1-1.6:1.0
[    8.028259] usbcore: registered new interface driver usb-storage
[    8.028393] USB Mass Storage support registered.
[    8.054134] iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 
build 25532
[    8.116118] hda_codec: ALC271X: BIOS auto-probing.
[    8.116615] hda_codec: connection list not available for 0x24
[    8.117792] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[    8.137790] usb 2-1.5: New USB device found, idVendor=064e, 
idProduct=a219
[    8.137944] usb 2-1.5: New USB device strings: Mfr=2, Product=1, 
SerialNumber=3
[    8.138138] usb 2-1.5: Product: 1.3M WebCam
[    8.138264] usb 2-1.5: Manufacturer: Suyin
[    8.138386] usb 2-1.5: SerialNumber: HF1315-S32B-OV01-VA-R02.01.05
[    8.143702] usbcore: registered new interface driver usbserial_generic
[    8.143841] usbserial: USB Serial Driver core
[    8.297666] USB Serial support registered for GSM modem (1-port)
[    8.298067] usbcore: registered new interface driver option
[    8.298204] option: v0.7.2:USB Driver for GSM modems
[    8.345643] Linux video capture interface: v2.00
[    8.466151] uvcvideo: Found UVC 1.00 device 1.3M WebCam (064e:a219)
[    8.475972] input: 1.3M WebCam as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input7
[    8.476456] usbcore: registered new interface driver uvcvideo
[    8.476588] USB Video Class driver (v0.1.0)
[    8.605175] cfg80211: World regulatory domain updated:
[    8.605317]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[    8.605518]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    8.605656]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[    8.605793]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[    8.605933]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    8.606072]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[    9.033068] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card 
  1.00 PQ: 0 ANSI: 0 CCS
[    9.033917] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    9.040630] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    9.814864] EXT4-fs (sda6): re-mounted. Opts: (null)
[    9.894017] EXT4-fs (sda6): Ignoring deprecated nobh option
[    9.896388] EXT4-fs (sda6): re-mounted. Opts: 
nobh,data=writeback,errors=remount-ro
[   10.026779] loop: module loaded
[   10.285761] fuse init (API version 7.15)
[   11.787848] NET: Registered protocol family 10
[   11.788941] lo: Disabled Privacy Extensions
[   12.212061] RPC: Registered udp transport module.
[   12.212249] RPC: Registered tcp transport module.
[   12.212393] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.289895] FS-Cache: Loaded
[   12.549345] FS-Cache: Netfs 'nfs' registered for caching
[   12.655888] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   49.646988] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match 
expected value (found 11, expected 18)
[   49.647227] intel ips 0000:00:1f.6: PCI INT A -> GSI 21 (level, low) 
-> IRQ 21
[   49.647637] intel ips 0000:00:1f.6: failed to get i915 symbols, 
graphics turbo disabled
[   49.647920] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp 
limit 65535
[   54.843465] general protection fault: 0000 [#1] PREEMPT SMP
[   54.843809] last sysfs file: /sys/bus/pci/drivers/intel ips/uevent
[   54.843946] CPU 0
[   54.844020] Modules linked in: intel_ips nfsd exportfs nfs lockd 
fscache auth_rpcgss sunrpc ipv6 fuse loop uvcvideo videodev option arc4 
snd_hda_codec_intelhdmi v4l1_compat v4l2_compat_ioctl32 usb_wwan 
snd_hda_codec_realtek ecb usb_storage snd_hda_intel snd_hda_codec iwlagn 
usbserial snd_hwdep snd_pcm_oss snd_mixer_oss iwlcore mac80211 snd_pcm 
snd_timer cfg80211 ehci_hcd intel_agp psmouse snd processor acer_wmi 
video usbcore rfkill soundcore agpgart i2c_i801 backlight serio_raw 
i2c_core led_class output ac thermal wmi button battery thermal_sys 
evdev snd_page_alloc pcspkr nls_base
[   54.848814]
[   54.848932] Pid: 1185, comm: ips-adjust Not tainted 2.6.36-rc4 #4 
Base Board Product Name/Aspire 1830T
[   54.849124] RIP: 0010:[<ffffffffa00290e9>]  [<ffffffffa00290e9>] 
do_disable_cpu_turbo+0x29/0x30 [intel_ips]
[   54.849389] RSP: 0018:ffff880134525e78  EFLAGS: 00010002
[   54.849521] RAX: 0000000100000009 RBX: ffffffffa00290c0 RCX: 
0000000000000199
[   54.849643] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 
ffff880135d109c0
[   54.849765] RBP: ffff880135d109c0 R08: ffffffff81655120 R09: 
0000000000000000
[   54.849887] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[   54.850008] R13: 0000000080000000 R14: 00000000000000f9 R15: 
00000000000001ac
[   54.850131] FS:  0000000000000000(0000) GS:ffff880001800000(0000) 
knlGS:0000000000000000
[   54.850302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   54.850418] CR2: 0000000001265008 CR3: 0000000136864000 CR4: 
00000000000006f0
[   54.850540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   54.850662] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   54.850783] Process ips-adjust (pid: 1185, threadinfo 
ffff880134524000, task ffff880134de3e90)
[   54.850954] Stack:
[   54.851056]  ffffffff8104538c ffff880135d109c0 ffff880135d10a00 
0000000000000000
[   54.851328] <0> ffffffffa00296ca ffff880134525f00 ffff880135d109c0 
ffffffffa0029410
[   54.851745] <0> ffff880134547c98 ffff880134525f00 ffff880135d109c0 
ffffffffa0029410
[   54.852251] Call Trace:
[   54.852361]  [<ffffffff8104538c>] ? on_each_cpu+0x3c/0x80
[   54.852480]  [<ffffffffa00296ca>] ? ips_adjust+0x2ba/0x3f0 [intel_ips]
[   54.852603]  [<ffffffffa0029410>] ? ips_adjust+0x0/0x3f0 [intel_ips]
[   54.853450]  [<ffffffffa0029410>] ? ips_adjust+0x0/0x3f0 [intel_ips]
[   54.853574]  [<ffffffff8105a846>] ? kthread+0x96/0xa0
[   54.853693]  [<ffffffff81003b94>] ? kernel_thread_helper+0x4/0x10
[   54.853815]  [<ffffffff8105a7b0>] ? kthread+0x0/0xa0
[   54.853931]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10
[   54.854048] Code: 00 00 b9 99 01 00 00 0f 32 48 c1 e2 20 89 c0 48 09 
c2 48 b8 00 00 00 00 01 00 00 00 48 85 c2 75 0c 48 09 d0 48 89 c2 48 c1 
ea 20 <0f> 30 f3 c3 0f 1f 00 0f b7 c6 66 d1 ef 6b c0 64 d1 f8 8d 04 07
[   54.857483] RIP  [<ffffffffa00290e9>] do_disable_cpu_turbo+0x29/0x30 
[intel_ips]
[   54.857702]  RSP <ffff880134525e78>
[   54.857812] ---[ end trace 4c3f4f3e72ed300e ]---
[   54.857925] note: ips-adjust[1185] exited with preempt_count 1



root@mobility:~# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i3 CPU       U 330  @ 1.20GHz
stepping	: 5
cpu MHz		: 1197.143
cache size	: 3072 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall rdtscp 
lm constant_tsc up arch_perfmon pebs bts rep_good xtopology nonstop_tsc 
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm 
sse4_1 sse4_2 popcnt lahf_lm arat tpr_shadow vnmi flexpriority ept vpid
bogomips	: 2394.28
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:



00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller 
(rev 02)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Core Processor 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 3050 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series 
Chipset HECI Controller (rev 06)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d4406100 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset 
USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d4405c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset 
High Definition Audio (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at d4400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4179
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=02
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI 
Express Root Port 1 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d3400000-d43fffff
	Prefetchable memory behind bridge: 00000000d0400000-00000000d13fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 040e
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI 
Express Root Port 2 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d2400000-d33fffff
	Prefetchable memory behind bridge: 00000000d1400000-00000000d23fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 040e
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset 
USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d4405800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5) 
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Acer Incorporated [ALI] Device 040e

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC 
Interface Controller (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=10 <?>

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 
4 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 40
	Region 0: I/O ports at 3048 [size=8]
	Region 1: I/O ports at 305c [size=4]
	Region 2: I/O ports at 3040 [size=8]
	Region 3: I/O ports at 3058 [size=4]
	Region 4: I/O ports at 3020 [size=32]
	Region 5: Memory at d4405000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4151
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus 
Controller (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 19
	Region 0: Memory at d4406000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 3000 [size=32]

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 
Series Chipset Thermal Subsystem (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at d4404000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Kernel driver in use: intel ips

01:00.0 Ethernet controller: Atheros Communications AR8151 v1.0 Gigabit 
Ethernet (rev c0)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at d3400000 (64-bit, non-prefetchable) [size=256K]
	Region 2: I/O ports at 2000 [size=128]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4159
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
unlimited, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [6c] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [180 v1] Device Serial Number ff-a8-9b-37-00-26-2d-ff
	Kernel driver in use: atl1c

02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200 
(rev 35)
	Subsystem: Intel Corporation Centrino Advanced-N 6200 2x2 AGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at d2400000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4169
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 
unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-27-10-ff-ff-23-16-04
	Kernel driver in use: iwlagn

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath 
Architecture Generic Non-core Registers (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath 
Architecture System Address Decoder (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 
(rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Acer Incorporated [ALI] Device 040e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0


dmidecode:
# dmidecode 2.9
SMBIOS 2.6 present.
51 structures occupying 2237 bytes.
Table at 0x000EA690.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: INSYDE
	Version: V1.11
	Release Date: 06/04/2010
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		Japanese floppy for NEC 9800 1.2 MB is supported (int 13h)
		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		8042 keyboard services are supported (int 9h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 11.240

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Acer
	Product Name: Aspire 1830T
	Version: V1.11
	Serial Number: LXPTS02028021154A92000
	UUID: 10938DC0-6A90-11DF-B43D-EBE2BBF7D956
	Wake-up Type: Power Switch
	SKU Number: Calpella_CRB
	Family: Intel_Mobile

Handle 0x0002, DMI type 2, 16 bytes
Base Board Information
	Manufacturer: Intel Corp.
	Product Name: Base Board Product Name
	Version: Base Board Version
	Serial Number: Base Board Serial Number
	Asset Tag: Base Board Asset Tag
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Base Board Chassis Location
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: Chassis Manufacturer
	Type: Other
	Lock: Not Present
	Version: Chassis Version
	Serial Number: Chassis Serial Number
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 9, 17 bytes
System Slot Information
	Designation: J5C1
	Type: x16 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0005, DMI type 9, 17 bytes
System Slot Information
	Designation: J6C1
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0006, DMI type 9, 17 bytes
System Slot Information
	Designation: J6C2
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0007, DMI type 9, 17 bytes
System Slot Information
	Designation: J6D2
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0008, DMI type 9, 17 bytes
System Slot Information
	Designation: J7C1
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0009, DMI type 9, 17 bytes
System Slot Information
	Designation: J7D2
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x000A, DMI type 9, 17 bytes
System Slot Information
	Designation: J8C2
	Type: x16 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x000B, DMI type 9, 17 bytes
System Slot Information
	Designation: J8C1
	Type: x1 <OUT OF SPEC>
	Current Usage: Available
	Length: Other
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x000C, DMI type 11, 5 bytes
OEM Strings
	String 1: String1 for Original Equipment Manufacturer
	String 2: String2 for Original Equipment Manufacturer
	String 3: String3 for Original Equipment Manufacturer
	String 4: String4 for Original Equipment Manufacturer
	String 5: String5 for Original Equipment Manufacturer

Handle 0x000D, DMI type 12, 5 bytes
System Configuration Options
	Option 1: String1 for Type12 Equipment Manufacturer
	Option 2: String2 for Type12 Equipment Manufacturer
	Option 3: String3 for Type12 Equipment Manufacturer
	Option 4: String4 for Type12 Equipment Manufacturer

Handle 0x000E, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Touch Pad
	Interface: PS/2
	Buttons: 4

Handle 0x000F, DMI type 27, 14 bytes
Cooling Device
	Type: Fan
	Status: OK
	OEM-specific Information: 0x00000000
	Nominal Speed: 2000 rpm

Handle 0x0010, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0011, DMI type 39, 22 bytes
System Power Supply
	Location: OEM_Define0
	Name: OEM_Define1
	Manufacturer: OEM_Define2
	Serial Number: OEM_Define3
	Asset Tag: OEM_Define4
	Model Part Number: OEM_Define5
	Revision: OEM_Define6
	Max Power Capacity: 0.075 W
	Status: Present, OK
	Type: Regulator
	Input Voltage Range Switching: Auto-switch
	Plugged: No
	Hot Replaceable: No
	Cooling Device Handle: 0x000F

Handle 0x0012, DMI type 40, 18 bytes
Unknown Type
	Header and Data:
		28 12 12 00 02 06 04 00 05 01 AA 07 00 00 05 02
		DC 05
	Strings:
		PCIExpressx16
		Compiler Version: VC 9.0

Handle 0x0013, DMI type 41, 11 bytes
Unknown Type
	Header and Data:
		29 0B 13 00 01 85 01 00 00 00 01
	Strings:
		Hanksville Gbe Lan Connection

Handle 0x0014, DMI type 22, 26 bytes
Portable Battery
	Location: Fake
	Manufacturer: -Virtual Battery 0-
	Manufacture Date: 10/12/2007
	Serial Number: Battery 0
	Name: CRB Battery 0
	Chemistry: Lithium Ion
	Design Capacity: Unknown
	Design Voltage: Unknown
	SBDS Version: Not Specified
	Maximum Error: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0015, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 15 00 5A 5A

Handle 0x0016, DMI type 129, 8 bytes
OEM-specific Type
	Header and Data:
		81 08 16 00 01 01 02 01
	Strings:
		Intel_ASF
		Intel_ASF_001

Handle 0x0017, DMI type 130, 20 bytes
OEM-specific Type
	Header and Data:
		82 14 17 00 24 41 4D 54 01 01 01 01 01 A5 1F 02
		00 00 00 00

Handle 0x0018, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: No Error
	Number Of Devices: 2

Handle 0x0019, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0018
	Error Information Handle: 0x001B
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK 0
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Not Specified
	Serial Number: 00000000
	Asset Tag: Unknown
	Part Number: Not Specified

Handle 0x001A, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM0
	Bank Connections: None
	Current Speed: 1 ns
	Type: DIMM
	Installed Size: 2048 MB (Single-bank Connection)
	Enabled Size: 2048 MB (Single-bank Connection)
	Error Status: OK

Handle 0x001B, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x001C, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0019
	Memory Array Mapped Address Handle: 0x0028
	Partition Row Position: Unknown
	Interleave Position: 1
	Interleaved Data Depth: 1

Handle 0x001D, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0018
	Error Information Handle: Not Provided
	Total Width: 8 bits
	Data Width: 8 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK 1
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Not Specified
	Serial Number: 00000000
	Asset Tag: Unknown
	Part Number: Not Specified

Handle 0x001E, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM1
	Bank Connections: None
	Current Speed: 1 ns
	Type: DIMM
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x001F, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0020, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0018
	Error Information Handle: 0x0022
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK 2
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Not Specified
	Serial Number: 8417E75F
	Asset Tag: Unknown
	Part Number: M471B5673EH1-CF8

Handle 0x0021, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM1
	Bank Connections: None
	Current Speed: 1 ns
	Type: DIMM
	Installed Size: 2048 MB (Single-bank Connection)
	Enabled Size: 2048 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0022, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0023, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0020
	Memory Array Mapped Address Handle: 0x0028
	Partition Row Position: Unknown
	Interleave Position: 2
	Interleaved Data Depth: 1

Handle 0x0024, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0018
	Error Information Handle: Not Provided
	Total Width: 8 bits
	Data Width: 8 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK 3
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz (1.2 ns)
	Manufacturer: Not Specified
	Serial Number: 00000000
	Asset Tag: Unknown
	Part Number: Not Specified

Handle 0x0025, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM3
	Bank Connections: None
	Current Speed: 1 ns
	Type: DIMM
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x0026, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0027, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0028, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x0018
	Partition Width: 0

Handle 0x0029, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		Unknown
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 8192 MB
	Maximum Total Memory Size: 16384 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		Other
	Memory Module Voltage: Unknown
	Associated Memory Slots: 2
		0x001A
		0x0021
	Enabled Error Correcting Capabilities:
		None

Handle 0x002A, DMI type 170, 38 bytes
OEM-specific Type
	Header and Data:
		AA 26 2A 00 01 00 08 00 00 00 0C 00 06 00 04 02
		41 08 64 02 08 00 63 02 04 00 83 02 04 00 82 02
		02 00 24 02 08 00

Handle 0x002B, DMI type 171, 24 bytes
OEM-specific Type
	Header and Data:
		AB 18 2B 00 02 69 19 73 10 04 4E 06 19 A2 05 86
		80 56 3B 07 86 80 2C 42

Handle 0x002C, DMI type 172, 6 bytes
OEM-specific Type
	Header and Data:
		AC 06 2C 00 01 00

Handle 0x002D, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: Intel(R) Corporation
	ID: 55 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i3 CPU       U 330  @ 1.20GHz
	Voltage: 0.0 V
	External Clock: 1066 MHz
	Max Speed: 1200 MHz
	Current Speed: 1204 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0031
	L2 Cache Handle: 0x0030
	L3 Cache Handle: 0x002E
	Serial Number: Not Specified
	Asset Tag: FFFF
	Part Number: Not Specified
	Core Count: 2
	Core Enabled: 2
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x002E, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3 Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 3072 KB
	Maximum Size: 3072 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: Other

Handle 0x002F, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0030, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 256 KB
	Maximum Size: 256 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0031, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 4-way Set-associative

Handle 0x0032, DMI type 127, 4 bytes
End Of Table
