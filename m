Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2GGCIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 22:08:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:39746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2GGCIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 22:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174368084"
Date: Sat, 7 Jul 2012 10:08:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault on ttm_init()
Message-ID: <20120707020847.GA28771@localhost>
References: <20120706144622.GA13387@localhost>
 <20120706144846.GA13505@localhost>
 <CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
 <CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 06:09:20PM +0100, Dave Airlie wrote:
> On Fri, Jul 6, 2012 at 5:49 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Fri, Jul 6, 2012 at 3:48 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> ... The missed kconfig.
> >>
> >> On Fri, Jul 06, 2012 at 10:46:22PM +0800, Fengguang Wu wrote:
> >>> Hi Thomas,
> >
> > Wierd, I'm sorta tempted to just depend drm on CONFIG_PROC_FS, but it
> > looks like the error path is failing to dtrt.
> 
> I've attached a patch that should fix it, let me know if it works.

It does not work.. The dmesg (attached) remains the same.

> though since the drm fails on proc not being there I wonder should we
> just enforce proc being there if you pick drm.

Yeah, enabling PROC_FS does fix the error :)

Thanks,
Fengguang

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: 8bit

[    0.000000] Linux version 3.5.0-rc2-00059-gc5fb75a-dirty (wfg@wfg-t420) (gcc version 4.7.0 (Debian 4.7.0-10) ) #3 PREEMPT Sat Jul 7 09:42:37 CST 2012
[    0.000000] Command line: console=ttyS0,115200 console=tty nokeymap root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffd000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820: last_pfn = 0x1fffd max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffcfff]
[    0.000000] RAMDISK: [mem 0x1e8d6000-0x1ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd9a0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffd7b0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001fffd910 0009E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001fffd830 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001fffd7f0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1a2cc81, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffcfff]
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a2cc00
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128902
[    0.000000] Kernel command line: 
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 469120k/524276k available (5504k kernel code, 452k absent, 54704k reserved, 7636k data, 820k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] Detected 2491.906 MHz processor.
[    0.008000] Calibrating delay loop (skipped) preset value.. 4983.81 BogoMIPS (lpj=9967624)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008000] TOMOYO Linux initialized
[    0.008000] AppArmor: AppArmor disabled by boot time parameter
[    0.008000] Mount-cache hash table entries: 256
[    0.008121] mce: CPU supports 10 MCE banks
[    0.008594] CPU: Intel Common KVM processor stepping 01
[    0.011164] ACPI: Core revision 20120320
[    0.028980] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.031882] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.033075] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036002] EVM: security.capability
[    0.036002] dummy: 
[    0.036002] NET: Registered protocol family 16
[    0.036002] ACPI: bus type pci registered
[    0.036002] PCI: Using configuration type 1 for base access
[    0.046380] ACPI: Added _OSI(Module Device)
[    0.046798] ACPI: Added _OSI(Processor Device)
[    0.047216] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.047659] ACPI: Added _OSI(Processor Aggregator Device)
[    0.084396] ACPI: Interpreter enabled
[    0.084839] ACPI: (supports S0 S5)
[    0.085173] ACPI: Using IOAPIC for interrupt routing
[    0.124277] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.125253] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.126153] PCI host bridge to bus 0000:00
[    0.126546] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.127130] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.147702]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.227671] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.228662] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.229886] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.231048] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.232461] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.233915] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.234731] vgaarb: loaded
[    0.234990] vgaarb: bridge control possible 0000:00:02.0
[    0.235664] tps65010: version 2 May 2005
[    0.268087] tps65010: no chip?
[    0.269007] ACPI: bus type usb registered
[    0.269618] usbcore: registered new interface driver usbfs
[    0.270323] usbcore: registered new interface driver hub
[    0.271132] usbcore: registered new device driver usb
[    0.272205] wmi: Mapper loaded
[    5.272606] PCI: Using ACPI for IRQ routing
[    5.276588] NET: Registered protocol family 23
[    5.277208] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    5.280524] Switching to clocksource kvm-clock
[    5.281687] pnp: PnP ACPI init
[    5.282158] ACPI: bus type pnp registered
[    5.290192] pnp: PnP ACPI: found 8 devices
[    5.290705] ACPI: ACPI bus type pnp unregistered
[    5.297426] NET: Registered protocol family 1
[    5.298371] Unpacking initramfs...
[    6.162689] Freeing initrd memory: 23656k freed
[    6.169819] Machine check injector initialized
[    6.170763] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    6.171754] cryptomgr_test (13) used greatest stack depth: 6472 bytes left
[    6.172977] cryptomgr_probe (20) used greatest stack depth: 5864 bytes left
[    6.173755] cryptomgr_test (19) used greatest stack depth: 5416 bytes left
[    6.174731] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    6.176702] Initializing RT-Tester: OK
[    6.177084] audit: initializing netlink socket (disabled)
[    6.177692] type=2000 audit(1341625390.172:1): initialized
[    6.186590] jffs2: version 2.2. © 2001-2006 Red Hat, Inc.
[    6.188190] ramoops: platform device not found, using module parameters
[    6.188936] ramoops: The memory size and the record size must be non-zero
[    6.189640] ramoops: probe of ramoops failed with error -22
[    6.190271] msgmni has been set to 962
[    6.193797] cryptomgr_test (58) used greatest stack depth: 5256 bytes left
[    6.194849] alg: No test for stdrng (krng)
[    6.201273] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.201886] NET: Registered protocol family 38
[    6.202465] xz_dec_test: module loaded
[    6.202822] xz_dec_test: Create a device node with 'mknod xz_dec_test c 251 0' and write .xz files to it.
[    6.203994] i2c-core: driver [adp8860_bl] using legacy suspend method
[    6.204642] i2c-core: driver [adp8860_bl] using legacy resume method
[    6.205533] no IO addresses supplied
[    6.206045] hgafb: HGA card not detected.
[    6.206432] hgafb: probe of hgafb.0 failed with error -22
[    6.207084] usbcore: registered new interface driver smscufx
[    6.208124] uvesafb: failed to execute /sbin/v86d
[    6.208599] uvesafb: make sure that the v86d helper is installed and executable
[    6.209282] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    6.209948] uvesafb: vbe_init() failed with -22
[    6.210381] uvesafb: probe of uvesafb.0 failed with error -22
[    6.211412] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.212144] ACPI: Power Button [PWRF]
[    6.219819] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.220356] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.242003] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.243533] MOXA Intellio family driver version 6.0k
[    6.254360] MOXA Smartio/Industio family driver version 2.0.5
[    6.254972] RocketPort device driver module, version 2.09, 12-June-2003
[    6.255609] No rocketport ports found; unloading driver
[    6.256138] SyncLink serial driver $Revision: 4.38 $
[    6.266632] SyncLink serial driver $Revision: 4.38 $, tty major#249
[    6.267335] Non-volatile memory driver v1.3
[    6.267764] ppdev: user-space parallel port driver
[    6.268250] smapi::smapi_init, ERROR invalid usSmapiID
[    6.268730] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    6.269606] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    6.270293] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.270990] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    6.271588] general protection fault: 0000 [#1] PREEMPT 
[    6.272084] CPU 0 
[    6.272220] Pid: 1, comm: swapper Not tainted 3.5.0-rc2-00059-gc5fb75a-dirty #3 Bochs Bochs
[    6.272220] RIP: 0010:[<ffffffff8105d247>]  [<ffffffff8105d247>] __lock_acquire.isra.19+0x64/0x7c9
[    6.272220] RSP: 0018:ffff88000010fd10  EFLAGS: 00010097
[    6.272220] RAX: 0000000000000000 RBX: ffff880000110000 RCX: 0000000000000000
[    6.272220] RDX: 0000000000000000 RSI: 0000000000000000 RDI: a56b6b6b6b6b6e73
[    6.272220] RBP: ffff88000010fd80 R08: 0000000000000000 R09: 0000000000000000
[    6.272220] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000246
[    6.272220] R13: 0000000000000000 R14: 0000000000000000 R15: a56b6b6b6b6b6e73
[    6.272220] FS:  0000000000000000(0000) GS:ffffffff81a24000(0000) knlGS:0000000000000000
[    6.272220] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.272220] CR2: 00000000ffffffff CR3: 0000000001a12000 CR4: 00000000000006f0
[    6.272220] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.272220] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.272220] Process swapper (pid: 1, threadinfo ffff88000010e000, task ffff880000110000)
[    6.272220] Stack:
[    6.272220]  0000000000000000 0000000000000046 ffff88000010fd50 0000000081c3cad0
[    6.272220]  0000000000000000 ffffffff8105c0f5 ffff88000010fd90 0000000000000000
[    6.272220]  ffff88000010fde0 ffff880000110000 0000000000000246 ffff8800001deab8
[    6.272220] Call Trace:
[    6.272220]  [<ffffffff8105c0f5>] ? mutex_remove_waiter+0x6a/0x7e
[    6.272220]  [<ffffffff8105dd60>] lock_acquire+0x5b/0x78
[    6.272220]  [<ffffffff8135079e>] ? get_device_parent+0x98/0x1b0
[    6.272220]  [<ffffffff8155b67a>] _raw_spin_lock+0x3c/0x6f
[    6.272220]  [<ffffffff8135079e>] ? get_device_parent+0x98/0x1b0
[    6.272220]  [<ffffffff8135079e>] get_device_parent+0x98/0x1b0
[    6.272220]  [<ffffffff81350e32>] device_add+0xf4/0x589
[    6.272220]  [<ffffffff81cfb37b>] ? drm_core_init+0xca/0xca
[    6.272220]  [<ffffffff81358a3d>] ? pm_runtime_init+0xfa/0xfe
[    6.272220]  [<ffffffff81cfb37b>] ? drm_core_init+0xca/0xca
[    6.272220]  [<ffffffff813512dd>] device_register+0x16/0x1a
[    6.272220]  [<ffffffff812226b6>] drm_class_device_register+0x24/0x2e
[    6.272220]  [<ffffffff81cfb3b2>] ttm_init+0x37/0x62
[    6.272220]  [<ffffffff81cd7bca>] do_one_initcall+0x78/0x131
[    6.272220]  [<ffffffff81cd7d77>] kernel_init+0xf4/0x178
[    6.272220]  [<ffffffff81cd745d>] ? loglevel+0x31/0x31
[    6.272220]  [<ffffffff8155d9d4>] kernel_thread_helper+0x4/0x10
[    6.272220]  [<ffffffff81cd7c83>] ? do_one_initcall+0x131/0x131
[    6.272220]  [<ffffffff8155d9d0>] ? gs_change+0x13/0x13
[    6.272220] Code: 49 89 ff 41 89 f5 0f 85 fe 06 00 00 9c 58 66 66 90 66 90 f6 c4 02 0f 84 ee 06 00 00 e8 af f2 0d 00 31 c0 e9 59 07 00 00 44 89 e8 <4d> 8b 64 c7 08 4d 85 e4 0f 85 04 03 00 00 83 3d f4 fe 17 01 00 
[    6.272220] RIP  [<ffffffff8105d247>] __lock_acquire.isra.19+0x64/0x7c9
[    6.272220]  RSP <ffff88000010fd10>
[    6.272220] ---[ end trace 2baa1561a7471508 ]---
[    6.272220] note: swapper[1] exited with preempt_count 1
[    6.298124] swapper (1) used greatest stack depth: 3784 bytes left
[    6.298693] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    6.298693] 

--x+6KMIRAuhnl3hBn--
