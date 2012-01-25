Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2AYEwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:52:14 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48621 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2AYEwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:52:12 -0500
Date: Tue, 24 Jan 2012 23:49:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, annie.li@oracle.com,
        xen-devel@lists.xensource.com
Subject: Regressions in v3.3-rc1 introduced by "xen/granttable: Grant tables
 V2 implementation"
Message-ID: <20120125044949.GB29759@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F1F8A79.0074,ss=1,re=1.599,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I try to bootup a PVonHVM guest with Xen 4.1 I get this:

Loading vmlinuz......................................................................
Loading initramf.gz...........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc1 (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Tue Jan 24 23:34:01 EST 2012
[    0.000000] Command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb BOOT_IMAGE=vmlinuz 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 00000000fc000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 4.1.
[    0.000000] Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
[    0.000000] You might have to change the root device
[    0.000000] from /dev/hd[a-d] to /dev/xvd[a-d]
[    0.000000] in your root= kernel command line option
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x40000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fbc70] fbc70
[    0.000000] init_memory_mapping: 0000000000000000-0000000040000000
[    0.000000] RAMDISK: 3c058000 - 3ffdf000
[    0.000000] ACPI: RSDP 00000000000ea020 00024 (v02    Xen)
[    0.000000] ACPI: XSDT 00000000fc012cb0 00034 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: FACP 00000000fc012ad0 000F4 (v04    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: DSDT 00000000fc002c40 0FE05 (v02    Xen      HVM 00000000 INTL 20090123)
[    0.000000] ACPI: FACS 00000000fc002c00 00040
[    0.000000] ACPI: APIC 00000000fc012bd0 000D8 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000040000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000040000000
[    0.000000]   NODE_DATA [000000003c031000 - 000000003c057fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x00040000
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 15 CPUs, 14 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bc000000)
[    0.000000] Booting paravirtualized kernel on Xen HVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:15 nr_cpu_ids:15 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003be00000 s82240 r8192 d24256 u131072
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257929
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: initrd=initramf.gz  console=ttyS0,115200 test=netstatic nofb BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 950340k/1048576k available (6364k kernel code, 456k absent, 97780k reserved, 4742k data, 1180k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=15, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:262400 nr_irqs:1208 16
[    0.000000] Xen HVM callback vector for event delivery is enabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Detected 2294.548 MHz processor.
[    0.004999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4589.09 BogoMIPS (lpj=2294548)
[    0.012002] pid_max: default: 32768 minimum: 301
[    0.016032] Security Framework initialized
[    0.020005] SELinux:  Initializing.
[    0.023127] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.029231] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.035103] Mount-cache hash table entries: 256
[    0.039024] Initializing cgroup subsys cpuacct
[    0.042000] Initializing cgroup subsys freezer
[    0.046075] CPU: Physical Processor ID: 0
[    0.048999] CPU: Processor Core ID: 0
[    0.052012] mce: CPU supports 20 MCE banks
[    0.056219] SMP alternatives: switching to UP code
[    0.072893] ACPI: Core revision 20120111
[    0.089601] ftrace: allocating 22768 entries in 89 pages
[    0.124087] Switched APIC routing to physical flat.
[    0.130228] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.145113] CPU0: Genuine Intel(R) CPU  @ 2.30GHz stepping 02
[    0.149999] installing Xen timer for CPU 0
[    0.153064] cpu 0 spinlock event irq 69
[    0.154041] Performance Events: unsupported p6 CPU model 45 no PMU driver, software events only.
[    0.163051] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.165998] Brought up 1 CPUs
[    0.166990] Total of 1 processors activated (4589.09 BogoMIPS).
[    0.172120] RTC time:  0:47:29, date: 01/25/12
[    0.173037] NET: Registered protocol family 16
[    0.174042] kworker/u:0 used greatest stack depth: 6208 bytes left
[    0.178054] ACPI: bus type pci registered
[    0.181115] PCI: Using configuration type 1 for base access
[    0.182029] kworker/u:0 used greatest stack depth: 5800 bytes left
[    0.184088] kworker/u:0 used greatest stack depth: 5440 bytes left
[    0.217125] bio: create slab <bio-0> at 0
[    0.218102] ACPI: Added _OSI(Module Device)
[    0.219000] ACPI: Added _OSI(Processor Device)
[    0.219995] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.220993] ACPI: Added _OSI(Processor Aggregator Device)
[    0.311044] ACPI: Interpreter enabled
[    0.311975] ACPI: (supports S0 S3 S4 S5)
[    0.316988] ACPI: Using IOAPIC for interrupt routing
[    0.958007] ACPI: No dock devices found.
[    0.958878] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.959994] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.961894] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.962876] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.963876] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.964875] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfbffffff]
[    0.965922] PCI host bridge to bus 0000:00
[    0.966883] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.967888] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.968881] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.969898] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfbffffff]
[    1.029004] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    1.029006] * this clock source is slow. Consider trying other clock sources
[    1.041923] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.084997]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.283755] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 10 11)
[    2.287945] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.292705] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.297697] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 10 11)
[    2.301950] xen/balloon: Initialising balloon driver.
[    2.302743] xen-balloon: Initialising balloon driver.
[    2.303932] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.304682] vgaarb: loaded
[    2.305682] vgaarb: bridge control possible 0000:00:02.0
[    2.306852] usbcore: registered new interface driver usbfs
[    2.307717] usbcore: registered new interface driver hub
[    2.308728] usbcore: registered new device driver usb
[    2.309840] PCI: Using ACPI for IRQ routing
[    2.312834] NetLabel: Initializing
[    2.313681] NetLabel:  domain hash size = 128
[    2.314679] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.315684] NetLabel:  unlabeled traffic allowed by default
[    2.316745] Switching to clocksource xen
[    2.319978] pnp: PnP ACPI init
[    2.322649] ACPI: bus type pnp registered
[    2.326228] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.332319] system 00:02: [io  0x10c0-0x1141] has been reserved
[    2.337367] system 00:02: [io  0xb044-0xb047] has been reserved
[    2.342498] system 00:03: [io  0x08a0-0x08a3] has been reserved
[    2.347545] system 00:03: [io  0x0cc0-0x0ccf] has been reserved
[    2.352426] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    2.412166] pnp: PnP ACPI: found 12 devices
[    2.415797] ACPI: ACPI bus type pnp unregistered
[    2.427298] NET: Registered protocol family 2
[    2.431177] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    2.437405] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    2.443897] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.449439] TCP: Hash tables configured (established 131072 bind 65536)
[    2.455015] TCP reno registered
[    2.457680] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.462645] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.468222] NET: Registered protocol family 1
[    2.471928] RPC: Registered named UNIX socket transport module.
[    2.476877] RPC: Registered udp transport module.
[    2.480808] RPC: Registered tcp transport module.
[    2.484855] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.490188] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.495568] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.500610] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.506628] Trying to unpack rootfs image as initramfs...
[    3.842613] Freeing initrd memory: 65052k freed
[    3.864308] Machine check injector initialized
[    3.868477] microcode: CPU0 sig=0x206d2, pf=0x1, revision=0x8000020c
[    3.873965] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.881877] audit: initializing netlink socket (disabled)
[    3.886453] type=2000 audit(1327452454.332:1): initialized
[    3.905496] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.912120] kworker/u:0 used greatest stack depth: 5432 bytes left
[    3.919718] VFS: Disk quotas dquot_6.5.2
[    3.923970] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.929942] NTFS driver 2.1.30 [Flags: R/W].
[    3.933815] msgmni has been set to 1983
[    3.937652] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.944099] io scheduler noop registered
[    3.947491] io scheduler deadline registered
[    3.951259] io scheduler cfq registered (default)
[    3.955229] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.960075] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xf0000000
[    3.967942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.974452] ACPI: Power Button [PWRF]
[    3.977925] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    3.984154] ACPI: Sleep Button [SLPF]
[    4.044889] Grant tables using version 2 layout.
[    4.048968] Grant table initialized
[    4.071769] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.109127] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.154314] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.161264] Non-volatile memory driver v1.3
[    4.164959] Linux agpgart interface v0.103
[    4.168774] [drm] Initialized drm 1.1.0 20060810
[    4.174181] brd: module loaded
[    4.177727] loop: module loaded
[    4.180388] Fixed MDIO Bus: probed
[    4.183447] tun: Universal TUN/TAP device driver, 1.6
[    4.187680] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.194394] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.200165] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.205720] uhci_hcd: USB Universal Host Controller Interface driver
[    4.211477] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    4.215859] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    4.222178] uhci_hcd 0000:00:01.2: detected 2 ports
[    4.226499] uhci_hcd 0000:00:01.2: irq 23, io base 0x0000c100
[    4.247577] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.253339] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.259578] usb usb1: Product: UHCI Host Controller
[    4.263917] usb usb1: Manufacturer: Linux 3.3.0-rc1 uhci_hcd
[    4.268864] usb usb1: SerialNumber: 0000:00:01.2
[    4.273045] hub 1-0:1.0: USB hub found
[    4.276435] hub 1-0:1.0: 2 ports detected
[    4.280358] usbcore: registered new interface driver usblp
[    4.285415] usbcore: registered new interface driver libusual
[    4.290542] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.300400] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.304522] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.309034] mousedev: PS/2 mouse device common for all mice
[    4.315162] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    4.334548] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.339970] rtc0: alarms up to one day, 114 bytes nvram
[    4.344805] cpuidle: using governor ladder
[    4.348287] cpuidle: using governor menu
[    4.351324] EFI Variables Facility v0.08 2004-May-17
[    4.355823] zram: num_devices not specified. Using default: 1
[    4.360929] zram: Creating 1 devices ...
[    4.364693] Netfilter messages via NETLINK v0.30.
[    4.368703] nf_conntrack version 0.5.0 (7932 buckets, 31728 max)
[    4.373904] ctnetlink v0.93: registering with nfnetlink.
[    4.378783] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.383579] TCP cubic registered
[    4.386448] Initializing XFRM netlink socket
[    4.390313] NET: Registered protocol family 10
[    4.394774] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.399368] IPv6 over IPv4 tunneling driver
[    4.403511] NET: Registered protocol family 17
[    4.407427] Registering the dns_resolver key type
[    4.411637] registered taskstats version 1
[    4.415787] XENBUS: Device with no driver: device/vfb/0
[    4.420213] XENBUS: Device with no driver: device/vbd/5632
[    4.425050] XENBUS: Device with no driver: device/vif/0
[    4.429562] XENBUS: Device with no driver: device/console/0
[    4.434211]   Magic number: 12:80:760
[    4.440340] Freeing unused kernel memory: 1180k freed
[    4.445074] Write protecting the kernel read-only data: 10240k
[    4.455026] Freeing unused kernel memory: 1808k freed
[    4.460463] Freeing unused kernel memory: 156k freed
init started: BusyBox v1.14.3 (2012-01-24 23:36:42 EST)
Mounting directories  [  OK  ]
[    4.542101] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    4.623602] modprobe used greatest stack depth: 5208 bytes left
mount: mount point /sys/kernel/config does not exist
[    4.634172] core_filesystem used greatest stack depth: 5096 bytes left
FATAL: Error inserting xen_fbfront (/lib/modules/3.3.0-rc1/kernel/drivers/video/xen-fbfront.ko): No such device
[    4.653547] Initialising Xen virtual ethernet driver.
[    4.760758] vbd vbd-5632: 19 xenbus_dev_probe on device/vbd/5632
[    4.776182] udevd (1225): /proc/1225/oom_adj is deprecated, please use /proc/1225/oom_score_adj instead.
[    4.817225] SCSI subsystem initialized
[    4.823855] libata version 3.00 loaded.
[    4.828486] ata_piix 0000:00:01.1: version 2.13
[    4.832645] ata_piix 0000:00:01.1: setting latency timer to 64
[    4.843283] scsi0 : ata_piix
[    4.850210] scsi1 : ata_piix
[    4.853778] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc120 irq 14
[    4.859818] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc128 irq 15
[    4.867005] Refined TSC clocksource calibration: 2294.470 MHz.
udevd-work[1242]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory

[    4.941699] ip used greatest stack depth: 3864 bytes left
[    5.026085] ata2.01: NODEV after polling detection
[    5.054647] ata2.00: ATAPI: QEMU DVD-ROM, 0.10.2, max UDMA/100
[    5.061809] ata2.00: configured for MWDMA2
[    5.083664] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.10 PQ: 0 ANSI: 5
[    5.131266] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
[    5.135461] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.140627] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.147041] sr 1:0:0:0: Attached scsi generic sg0 type 5
Waiting for devices [  OK  ]
Waiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  [    5.454600] usb usb1: suspend_rh (auto-stop)
]
Bringing up interface eth0:  [    5.487639] BUG: unable to handle kernel NULL pointer dereference at 0000000000000400
[    5.488057] IP: [<ffffffff81375ae9>] gnttab_end_foreign_access_ref_v2+0x29/0x40
[    5.488057] PGD 32aa3067 PUD 32a87067 PMD 0 
[    5.488057] Oops: 0000 [#1] PREEMPT SMP 
[    5.488057] CPU 0 
[    5.488057] Modules linked in: sg sr_mod cdrom ata_generic ata_piix libata scsi_mod xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd
[    5.488057] 
[    5.488057] Pid: 2307, comm: ip Not tainted 3.3.0-rc1 #1 Xen HVM domU
[    5.488057] RIP: 0010:[<ffffffff81375ae9>]  [<ffffffff81375ae9>] gnttab_end_foreign_access_ref_v2+0x29/0x40
[    5.488057] RSP: 0018:ffff88003be03d38  EFLAGS: 00010206
[    5.488057] RAX: 0000000000000000 RBX: ffff880033210640 RCX: 0000000000000040
[    5.488057] RDX: 0000000000002000 RSI: 0000000000000000 RDI: 0000000000000200
[    5.488057] RBP: ffff88003be03d38 R08: 0000000000000101 R09: 0000000000000000
[    5.488057] R10: dead000000100100 R11: 0000000000000000 R12: ffff88003be03e48
[    5.488057] R13: 0000000000000001 R14: ffff880039461c00 R15: 0000000000000200
[    5.488057] FS:  00007fb1f84ec700(0000) GS:ffff88003be00000(0000) knlGS:0000000000000000
[    5.488057] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.488057] CR2: 0000000000000400 CR3: 0000000032b1f000 CR4: 00000000000006f0
[    5.488057] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.488057] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.488057] Process ip (pid: 2307, threadinfo ffff880032b62000, task ffff88003bafe540)
[    5.488057] Stack:
[    5.488057]  ffff88003be03d48 ffffffff81375b13 ffff88003be03e88 ffffffffa00330c3
[    5.488057]  ffffea0000e51810 ffff88003be03e28 ffff88003be03e08 ffff88003be03de8
[    5.488057]  000000018020001e ffff88003be03dd0 ffff880033211300 ffff880033210658
[    5.488057] Call Trace:
[    5.488057]  <IRQ> 
[    5.488057]  [<ffffffff81375b13>] gnttab_end_foreign_access_ref+0x13/0x20
[    5.488057]  [<ffffffffa00330c3>] xennet_poll+0x2a3/0xe60 [xen_netfront]
[    5.488057]  [<ffffffff81041ebc>] ? xen_clocksource_read+0x4c/0x80
[    5.488057]  [<ffffffff810bd910>] ? sched_clock_cpu+0xc0/0x130
[    5.488057]  [<ffffffff814ddae0>] net_rx_action+0x140/0x350
[    5.488057]  [<ffffffff8108df53>] __do_softirq+0xf3/0x270
[    5.488057]  [<ffffffff81633e9c>] call_softirq+0x1c/0x30
[    5.488057]  <EOI> 
[    5.488057]  [<ffffffff8104d3c5>] do_softirq+0x65/0xa0
[    5.488057]  [<ffffffff8108ec3b>] local_bh_enable_ip+0xab/0xc0
[    5.488057]  [<ffffffff8162b0c3>] _raw_spin_unlock_bh+0x23/0x30
[    5.488057]  [<ffffffffa0032d99>] xennet_open+0x59/0xe0 [xen_netfront]
[    5.488057]  [<ffffffff814d893f>] __dev_open+0xbf/0x110
[    5.488057]  [<ffffffff814d6d01>] __dev_change_flags+0xa1/0x180
[    5.488057]  [<ffffffff814d8838>] dev_change_flags+0x28/0x70
[    5.488057]  [<ffffffff814e85e2>] do_setlink+0x1c2/0x9f0
[    5.488057]  [<ffffffff8162b51a>] ? _raw_spin_unlock+0x1a/0x40
[    5.488057]  [<ffffffff812fd064>] ? nla_parse+0x34/0x110
[    5.488057]  [<ffffffff814ea548>] rtnl_newlink+0x3d8/0x600
[    5.488057]  [<ffffffff81293579>] ? selinux_capable+0x39/0x50
[    5.488057]  [<ffffffff814e8187>] rtnetlink_rcv_msg+0x2b7/0x320
[    5.488057]  [<ffffffff810b68d1>] ? get_parent_ip+0x11/0x50
[    5.488057]  [<ffffffff814e7ed0>] ? rtnetlink_rcv+0x40/0x40
[    5.488057]  [<ffffffff815037c9>] netlink_rcv_skb+0xa9/0xd0
[    5.488057]  [<ffffffff814e7eb5>] rtnetlink_rcv+0x25/0x40
[    5.488057]  [<ffffffff81503499>] netlink_unicast+0x1a9/0x1f0
[    5.488057]  [<ffffffff815040ad>] netlink_sendmsg+0x20d/0x300
[    5.488057]  [<ffffffff814c3518>] sock_sendmsg+0xf8/0x130
[    5.488057]  [<ffffffff8113f26b>] ? filemap_fault+0x8b/0x480
[    5.488057]  [<ffffffff810b68d1>] ? get_parent_ip+0x11/0x50
[    5.488057]  [<ffffffff810b68d1>] ? get_parent_ip+0x11/0x50
[    5.488057]  [<ffffffff8113d86a>] ? unlock_page+0x2a/0x40
[    5.488057]  [<ffffffff81165499>] ? __do_fault+0x419/0x520
[    5.488057]  [<ffffffff814c1ef9>] ? copy_from_user+0x9/0x10
[    5.488057]  [<ffffffff814c23be>] ? move_addr_to_kernel+0x4e/0x90
[    5.488057]  [<ffffffff814d0139>] ? verify_iovec+0x69/0xd0
[    5.488057]  [<ffffffff814c4f7a>] __sys_sendmsg+0x3fa/0x420
[    5.488057]  [<ffffffff81165f98>] ? handle_mm_fault+0x148/0x270
[    5.488057]  [<ffffffff8162ea38>] ? do_page_fault+0x1b8/0x4d0
[    5.488057]  [<ffffffff8116a86c>] ? do_brk+0x26c/0x350
[    5.488057]  [<ffffffff814c51a9>] sys_sendmsg+0x49/0x90
[    5.488057]  [<ffffffff816329e9>] system_call_fastpath+0x16/0x1b
[    5.488057] Code: 00 00 55 48 89 e5 66 66 66 66 90 48 8b 05 58 40 a1 00 89 ff 48 89 fa 48 c1 e2 04 66 c7 04 02 00 00 0f ae f0 48 8b 05 4f 40 a1 00 <0f> b7 14 78 31 c0 83 e2 18 75 02 b0 01 c9 c3 0f 1f 84 00 00 00 
[    5.488057] RIP  [<ffffffff81375ae9>] gnttab_end_foreign_access_ref_v2+0x29/0x40
[    5.488057]  RSP <ffff88003be03d38>
[    5.488057] CR2: 0000000000000400
[    5.870364] ---[ end trace 695676be44834560 ]---
[    5.874131] Kernel panic - not syncing: Fatal exception in interrupt


and with this little patch I can get it to work:

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1cd94da..814a7d0 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -950,6 +950,8 @@ static void gnttab_request_version(void)
 
 	gsv.version = 2;
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
+	if (xen_hvm_domain())
+		rc = -1; /* Just so that we use v1 in HVM. */
 	if (rc == 0) {
 		grant_table_version = 2;
 		gnttab_interface = &gnttab_v2_ops;

Any ideas why granttabl v2 won't work in HVM?
