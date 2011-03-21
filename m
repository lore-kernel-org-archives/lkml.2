Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1CUXy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:54:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:30755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab1CUXyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:54:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,222,1299484800"; 
   d="txt'?scan'208";a="899707492"
Date: Mon, 21 Mar 2011 16:54:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Hot plug issue on 2.6.38
Message-ID: <20110321235403.GA4092@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <20110317215609.GA5917@xanatos>
 <20110321222705.GA4139@xanatos>
 <201103212351.12696.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <201103212351.12696.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 21, 2011 at 11:51:12PM +0100, Rafael J. Wysocki wrote:
> On Monday, March 21, 2011, Sarah Sharp wrote:
> > I compiled 2.6.38 with CONFIG_PCI_MMCONFIG=y, and I'm no longer getting
> > "irq nobody cared" messages.  However, PCI express hot plug seems to
> > just not work for the xHCI PCI device.  Nothing appears in dmesg when I
> > plug in the Express Card, and the device doesn't appear in lspci.
> > However, I can get the card to show up if I run
> > 
> > 	echo 1 > /sys/bus/pci/rescan
> > 
> > PCI hot-remove doesn't seem to work either.  The xHCI driver notices the
> > device got removed when the debugging polling loop runs, but the
> > driver's PCI remove functions are never called.  A rescan of the bus
> > doesn't help, and the device still shows up in lspci (although all the
> > registers are read as 0xffff). dmesg and lspci after the device has been
> > removed is attached.
> > 
> > I've tried turning on all the PCI config options that look relavant; my
> > .config is attached.  I've turned on PCI debug too.  The only thing that
> > looks PCI related that I don't have turned on is ACPI_PCI_SLOT.  Do I
> > need that?
> > 
> > I'm not sure how to debug this hot plug issue further.
> 
> Well, we still don't seem to call the _OSC on this machine.  At least your
> dmesg output doesn't indicate so.
> 
> Do you have the patch from:
> 
> https://patchwork.kernel.org/patch/604371/
> 
> applied?

No, it was just 2.6.38.  When I applied that patch, PCI hot plug worked!
dmesg is attached.  Can the patch get queued for 2.6.38 stable, or is it
just a hack?

Sarah Sharp

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

  0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.036 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.07 BogoMIPS (lpj=7448144)
[    0.004102] pid_max: default: 32768 minimum: 301
[    0.008208] Mount-cache hash table entries: 256
[    0.009491] Initializing cgroup subsys ns
[    0.009541] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009609] Initializing cgroup subsys cpuacct
[    0.009668] Initializing cgroup subsys memory
[    0.009811] Initializing cgroup subsys freezer
[    0.010022] CPU: Physical Processor ID: 0
[    0.010069] CPU: Processor Core ID: 0
[    0.010115] using mwait in idle threads.
[    0.010213] ACPI: Core revision 20110112
[    0.156288] Setting APIC routing to flat
[    0.156806] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.199903] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.204012] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.204012] ... version:                2
[    0.204012] ... bit width:              40
[    0.204012] ... generic registers:      2
[    0.204012] ... value mask:             000000ffffffffff
[    0.204012] ... max period:             000000007fffffff
[    0.204012] ... fixed-purpose events:   3
[    0.204012] ... event mask:             0000000700000003
[    0.212179] NMI watchdog enabled, takes one hw-pmu counter.
[    0.224028] lockdep: fixing up alternatives.
[    0.228104] Booting Node   0, Processors  #1 Ok.
[    0.228186] smpboot cpu 1: start_ip = 99000
[    0.320092] NMI watchdog enabled, takes one hw-pmu counter.
[    0.324028] Brought up 2 CPUs
[    0.324076] Total of 2 processors activated (7447.98 BogoMIPS).
[    0.328718] NET: Registered protocol family 16
[    0.330872] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.330943] ACPI: bus type pci registered
[    0.331649] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.331716] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.360742] PCI: Using configuration type 1 for base access
[    0.374025] bio: create slab <bio-0> at 0
[    0.383080] ACPI: EC: EC description table is found, configuring boot EC
[    0.530474] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.576352] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.579265] ACPI: Dynamic OEM Table Load:
[    0.579378] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.583496] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.588597] ACPI: Dynamic OEM Table Load:
[    0.588711] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.625231] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.629237] ACPI: Dynamic OEM Table Load:
[    0.629350] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.647615] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.650253] ACPI: Dynamic OEM Table Load:
[    0.650365] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.670362] ACPI: Interpreter enabled
[    0.670411] ACPI: (supports S0 S3 S4 S5)
[    0.670968] ACPI: Using IOAPIC for interrupt routing
[    0.745833] ACPI: Power Resource [PUBS] (on)
[    0.804342] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.841180] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.841234] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.848193] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.848870] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.848923] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.848975] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.849039] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.849101] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.849165] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.849275] pci_bus 0000:00: scanning bus
[    0.849315] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.849324] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.849359] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x169
[    0.849374] pci 0000:00:00.0: calling quirk_iommu_rwbf+0x0/0x46
[    0.849376] DMAR: Forcing write-buffer flush capability
[    0.849426] DMAR: Disabling IOMMU for graphics on this chipset
[    0.849477] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.849526] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.849536] pci 0000:00:02.0: calling quirk_mmio_always_on+0x0/0x17
[    0.849551] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.849564] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.849574] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.849593] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x169
[    0.849598] pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.849648] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.849656] pci 0000:00:02.1: calling quirk_mmio_always_on+0x0/0x17
[    0.849670] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.849708] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x169
[    0.849712] pci 0000:00:02.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.849771] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.849782] pci 0000:00:03.0: calling quirk_mmio_always_on+0x0/0x17
[    0.849799] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.849845] pci 0000:00:03.0: calling quirk_resource_alignment+0x0/0x169
[    0.849850] pci 0000:00:03.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.849871] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.849876] pci 0000:00:03.0: PME# disabled
[    0.849918] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.849929] pci 0000:00:03.2: calling quirk_mmio_always_on+0x0/0x17
[    0.849942] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.849953] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.849964] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.849974] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.849985] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.850009] pci 0000:00:03.2: calling quirk_resource_alignment+0x0/0x169
[    0.850013] pci 0000:00:03.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.850075] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.850086] pci 0000:00:03.3: calling quirk_mmio_always_on+0x0/0x17
[    0.850099] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.850110] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.850156] pci 0000:00:03.3: calling quirk_resource_alignment+0x0/0x169
[    0.850160] pci 0000:00:03.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.850278] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.850296] pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x17
[    0.850315] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.850330] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.850345] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.850403] pci 0000:00:19.0: calling quirk_resource_alignment+0x0/0x169
[    0.850407] pci 0000:00:19.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.850446] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.850452] pci 0000:00:19.0: PME# disabled
[    0.850501] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.850512] pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x17
[    0.850579] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.850612] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x169
[    0.850616] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.850680] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.850691] pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x17
[    0.850759] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.850792] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x169
[    0.850796] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.850859] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.850870] pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x17
[    0.850937] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.850970] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x169
[    0.850974] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851053] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.851071] pci 0000:00:1a.7: calling quirk_mmio_always_on+0x0/0x17
[    0.851090] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.851172] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x169
[    0.851176] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851214] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.851222] pci 0000:00:1a.7: PME# disabled
[    0.851278] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.851283] pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x17
[    0.851309] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.851379] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x169
[    0.851383] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851428] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.851434] pci 0000:00:1b.0: PME# disabled
[    0.851483] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.851489] pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x17
[    0.851553] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x169
[    0.851557] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851609] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.851615] pci 0000:00:1c.0: PME# disabled
[    0.851670] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.851676] pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x17
[    0.851740] pci 0000:00:1c.1: calling quirk_resource_alignment+0x0/0x169
[    0.851744] pci 0000:00:1c.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851796] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.851802] pci 0000:00:1c.1: PME# disabled
[    0.851857] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.851862] pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x17
[    0.851927] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x169
[    0.851931] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.851982] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.851989] pci 0000:00:1c.3: PME# disabled
[    0.852190] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.852202] pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x17
[    0.852269] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.852303] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x169
[    0.852307] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.852371] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.852382] pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x17
[    0.852449] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.852482] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x169
[    0.852486] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.852550] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.852561] pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x17
[    0.852629] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.852662] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x169
[    0.852666] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.852745] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.852763] pci 0000:00:1d.7: calling quirk_mmio_always_on+0x0/0x17
[    0.852782] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.852864] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x169
[    0.852868] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.852907] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.852914] pci 0000:00:1d.7: PME# disabled
[    0.852963] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.852974] pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x17
[    0.853026] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x169
[    0.853030] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.853097] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.853110] pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x17
[    0.853229] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x169
[    0.853233] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.853318] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.853339] pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x17
[    0.853358] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.853373] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.853388] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.853403] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.853418] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.853434] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.853455] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x169
[    0.853459] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.853508] pci 0000:00:1f.2: PME# supported from D3hot
[    0.853514] pci 0000:00:1f.2: PME# disabled
[    0.853561] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.853567] pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x17
[    0.853593] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.853633] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.853666] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x169
[    0.853670] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.853690] pci_bus 0000:00: fixups for bus
[    0.853695] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[    0.853784] pci_bus 0000:02: scanning bus
[    0.853789] pci_bus 0000:02: fixups for bus
[    0.853792] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.853847] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.853854] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.853864] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.853867] pci_bus 0000:02: bus scan returning with max=02
[    0.853874] pci 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 0
[    0.853961] pci_bus 0000:03: scanning bus
[    0.854088] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.854115] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.854179] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.854318] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x169
[    0.854323] pci 0000:03:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.854443] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.854472] pci 0000:03:00.0: PME# disabled
[    0.854596] pci_bus 0000:03: fixups for bus
[    0.854599] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.854653] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.854660] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.854671] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.854674] pci_bus 0000:03: bus scan returning with max=03
[    0.854681] pci 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 0
[    0.854767] pci_bus 0000:05: scanning bus
[    0.854771] pci_bus 0000:05: fixups for bus
[    0.854774] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.854827] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.854834] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.854844] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.854847] pci_bus 0000:05: bus scan returning with max=05
[    0.854854] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 0
[    0.854907] pci_bus 0000:0d: scanning bus
[    0.854987] pci_bus 0000:0d: fixups for bus
[    0.854990] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.855046] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.855053] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.855063] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.855075] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.855087] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.855099] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.855111] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.855122] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.855134] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.855137] pci_bus 0000:0d: bus scan returning with max=0d
[    0.855144] pci 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[    0.855155] pci 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 1
[    0.855165] pci 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 1
[    0.855175] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 1
[    0.855183] pci_bus 0000:00: bus scan returning with max=0d
[    0.855186] pci_bus 0000:00: on NUMA node 0
[    0.855209] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.861620] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.863011] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.864472] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.873170]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.885763]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.085459] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.087698] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.089936] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.092297] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.094530] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.096779] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.099016] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.101400] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.102592] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.102834] vgaarb: loaded
[    1.104257] SCSI subsystem initialized
[    1.104335] libata version 3.00 loaded.
[    1.104775] PCI: Using ACPI for IRQ routing
[    1.104775] PCI: pci_cache_line_size set to 64 bytes
[    1.104775] pci 0000:00:02.0: BAR 0: reserving [mem 0xf2000000-0xf23fffff flags 0x140204] (d=0, p=0)
[    1.104775] pci 0000:00:02.0: BAR 2: reserving [mem 0xd0000000-0xdfffffff flags 0x14220c] (d=0, p=0)
[    1.104775] pci 0000:00:02.0: BAR 4: reserving [io  0x1800-0x1807 flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:02.1: BAR 0: reserving [mem 0xf2400000-0xf24fffff flags 0x140204] (d=0, p=0)
[    1.104775] pci 0000:00:03.0: BAR 0: reserving [mem 0xf2826800-0xf282680f flags 0x140204] (d=0, p=0)
[    1.104775] pci 0000:00:03.2: BAR 0: reserving [io  0x1828-0x182f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.2: BAR 1: reserving [io  0x180c-0x180f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.2: BAR 2: reserving [io  0x1820-0x1827 flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.2: BAR 3: reserving [io  0x1808-0x180b flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.2: BAR 4: reserving [io  0x1810-0x181f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.3: BAR 0: reserving [io  0x1830-0x1837 flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:03.3: BAR 1: reserving [mem 0xf2624000-0xf2624fff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:19.0: BAR 0: reserving [mem 0xf2600000-0xf261ffff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:19.0: BAR 1: reserving [mem 0xf2625000-0xf2625fff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:19.0: BAR 2: reserving [io  0x1840-0x185f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1a.0: BAR 4: reserving [io  0x1860-0x187f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1a.1: BAR 4: reserving [io  0x1880-0x189f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1a.2: BAR 4: reserving [io  0x18a0-0x18bf flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1a.7: BAR 0: reserving [mem 0xf2826c00-0xf2826fff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:1b.0: BAR 0: reserving [mem 0xf2620000-0xf2623fff flags 0x140204] (d=0, p=0)
[    1.104775] pci 0000:00:1d.0: BAR 4: reserving [io  0x18c0-0x18df flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1d.1: BAR 4: reserving [io  0x18e0-0x18ff flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1d.2: BAR 4: reserving [io  0x1c00-0x1c1f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1d.7: BAR 0: reserving [mem 0xf2827000-0xf28273ff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 0: reserving [io  0x1c48-0x1c4f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 1: reserving [io  0x183c-0x183f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 2: reserving [io  0x1c40-0x1c47 flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 3: reserving [io  0x1838-0x183b flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 4: reserving [io  0x1c20-0x1c3f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:00:1f.2: BAR 5: reserving [mem 0xf2826000-0xf28267ff flags 0x40200] (d=0, p=0)
[    1.104775] pci 0000:00:1f.3: BAR 0: reserving [mem 0xf2827400-0xf28274ff flags 0x140204] (d=0, p=0)
[    1.104775] pci 0000:00:1f.3: BAR 4: reserving [io  0x1c60-0x1c7f flags 0x40101] (d=0, p=0)
[    1.104775] pci 0000:03:00.0: BAR 0: reserving [mem 0xf2500000-0xf2501fff flags 0x140204] (d=0, p=0)
[    1.104911] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.104923] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.105073] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.105199] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.105305] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.106433] Bluetooth: Core ver 2.16
[    1.106568] NET: Registered protocol family 31
[    1.106617] Bluetooth: HCI device and connection manager initialized
[    1.106682] Bluetooth: HCI socket layer initialized
[    1.106731] Bluetooth: L2CAP socket layer initialized
[    1.108099] Bluetooth: SCO socket layer initialized
[    1.108432] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.116291] Switching to clocksource hpet
[    1.116401] pnp: PnP ACPI init
[    1.116542] ACPI: bus type pnp registered
[    1.119660] Switched to NOHz mode on CPU #0
[    1.119756] Switched to NOHz mode on CPU #1
[    1.150223] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.150234] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.150243] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.150253] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.150262] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.150271] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.150281] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.150291] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.150300] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.150310] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.150319] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.150328] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.150338] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.150347] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.150356] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.150366] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.150375] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.151005] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.151080] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.151153] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.151226] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.151298] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.151370] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.151448] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.151526] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.151604] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.151682] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.151760] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.151838] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.151916] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.151994] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.152089] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.152145] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.152346] pnp 00:01: [bus 00-ff]
[    1.152356] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.152366] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.152375] pnp 00:01: [io  0x0d00-0xffff window]
[    1.152385] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.152395] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.152404] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.152414] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.152423] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.152433] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.152442] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.152452] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.152461] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.152471] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.152480] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.152490] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.152499] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.152509] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.152519] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.152817] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.175068] pnp 00:02: [io  0x0010-0x001f]
[    1.175078] pnp 00:02: [io  0x0090-0x009f]
[    1.175088] pnp 00:02: [io  0x0024-0x0025]
[    1.175099] pnp 00:02: [io  0x0028-0x0029]
[    1.175109] pnp 00:02: [io  0x002c-0x002d]
[    1.175118] pnp 00:02: [io  0x0030-0x0031]
[    1.175127] pnp 00:02: [io  0x0034-0x0035]
[    1.175136] pnp 00:02: [io  0x0038-0x0039]
[    1.175145] pnp 00:02: [io  0x003c-0x003d]
[    1.175154] pnp 00:02: [io  0x00a4-0x00a5]
[    1.175164] pnp 00:02: [io  0x00a8-0x00a9]
[    1.175173] pnp 00:02: [io  0x00ac-0x00ad]
[    1.175182] pnp 00:02: [io  0x00b0-0x00b5]
[    1.175192] pnp 00:02: [io  0x00b8-0x00b9]
[    1.175201] pnp 00:02: [io  0x00bc-0x00bd]
[    1.175210] pnp 00:02: [io  0x0050-0x0053]
[    1.175219] pnp 00:02: [io  0x0072-0x0077]
[    1.175228] pnp 00:02: [io  0x002e-0x002f]
[    1.175238] pnp 00:02: [io  0x1000-0x107f]
[    1.175247] pnp 00:02: [io  0x1180-0x11ff]
[    1.175256] pnp 00:02: [io  0x0800-0x080f]
[    1.175265] pnp 00:02: [io  0x15e0-0x15ef]
[    1.175275] pnp 00:02: [io  0x1600-0x167f]
[    1.175284] pnp 00:02: [io  0x1680-0x169f]
[    1.175293] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.175303] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.175312] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.175321] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.175331] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.175340] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.175991] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.176080] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.176153] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.176227] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.176299] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.176370] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.176442] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.176515] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.176587] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.176660] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.176732] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.176805] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.176860] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.177472] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.177758] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.177891] pnp 00:04: [io  0x0000-0x000f]
[    1.177901] pnp 00:04: [io  0x0080-0x008f]
[    1.177910] pnp 00:04: [io  0x00c0-0x00df]
[    1.177920] pnp 00:04: [dma 4]
[    1.178205] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.178336] pnp 00:05: [io  0x0061]
[    1.178624] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.178754] pnp 00:06: [io  0x00f0]
[    1.178772] pnp 00:06: [irq 13]
[    1.179058] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.179187] pnp 00:07: [io  0x0070-0x0071]
[    1.179202] pnp 00:07: [irq 8]
[    1.179491] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.179621] pnp 00:08: [io  0x0060]
[    1.179631] pnp 00:08: [io  0x0064]
[    1.179646] pnp 00:08: [irq 1]
[    1.179935] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.180089] pnp 00:09: [irq 12]
[    1.180385] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.202274] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.202563] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.206530] pnp: PnP ACPI: found 11 devices
[    1.206580] ACPI: ACPI bus type pnp unregistered
[    1.228903] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    1.228961] pci 0000:00:1c.0: BAR 7: assigned [io  0x4000-0x4fff]
[    1.229021] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.229073] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.229129] pci 0000:00:1c.0:   bridge window [mem disabled]
[    1.229183] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.229241] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.229293] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    1.229350] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.229405] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    1.229463] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.229515] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.229572] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.229627] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.229698] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.229747] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.229803] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.229857] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.229936] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.229993] pci 0000:00:1c.0: setting latency timer to 64
[    1.230014] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.230070] pci 0000:00:1c.1: setting latency timer to 64
[    1.230092] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.230148] pci 0000:00:1c.3: setting latency timer to 64
[    1.230158] pci 0000:00:1e.0: setting latency timer to 64
[    1.230163] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.230166] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.230169] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.230172] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.230175] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.230178] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.230181] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    1.230184] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    1.230187] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.230190] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.230193] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.230196] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.230199] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.230202] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.230205] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.230208] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.230211] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.230214] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.230352] NET: Registered protocol family 2
[    1.230655] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.231803] IPv4 FIB: Using LC-trie version 0.409
[    1.232485] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.234135] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.237496] TCP: Hash tables configured (established 262144 bind 65536)
[    1.237587] TCP reno registered
[    1.237658] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.237952] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.238671] NET: Registered protocol family 1
[    1.238779] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.238786] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.238790] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238794] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb1
[    1.238810] pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.238814] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.238818] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238822] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xb1
[    1.238826] pci 0000:00:02.0: Boot video device
[    1.238841] pci 0000:00:02.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.238845] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.238848] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238852] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xb1
[    1.238866] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.238870] pci 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.238873] pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238877] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xb1
[    1.238891] pci 0000:00:03.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.238895] pci 0000:00:03.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.238899] pci 0000:00:03.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238902] pci 0000:00:03.2: calling pci_fixup_video+0x0/0xb1
[    1.238917] pci 0000:00:03.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.238921] pci 0000:00:03.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.238925] pci 0000:00:03.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238928] pci 0000:00:03.3: calling pci_fixup_video+0x0/0xb1
[    1.238943] pci 0000:00:19.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.238947] pci 0000:00:19.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.238950] pci 0000:00:19.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238954] pci 0000:00:19.0: calling pci_fixup_video+0x0/0xb1
[    1.238968] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.238972] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.238976] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.238985] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.238987] pci 0000:00:1a.0: Performing full reset
[    1.239003] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xb1
[    1.239019] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.239023] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.239026] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239035] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.239037] pci 0000:00:1a.1: Performing full reset
[    1.239052] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xb1
[    1.239067] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.239071] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.239075] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239083] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.239086] pci 0000:00:1a.2: Performing full reset
[    1.239100] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xb1
[    1.239116] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x15e
[    1.239119] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
[    1.239123] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239195] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xb1
[    1.239211] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239215] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239219] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239222] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xb1
[    1.239237] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239241] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239245] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239248] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xb1
[    1.239263] pci 0000:00:1c.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.239267] pci 0000:00:1c.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.239271] pci 0000:00:1c.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239274] pci 0000:00:1c.1: calling pci_fixup_video+0x0/0xb1
[    1.239289] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.239293] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.239296] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239300] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xb1
[    1.239315] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239319] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239322] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239330] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.239333] pci 0000:00:1d.0: Performing full reset
[    1.239348] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xb1
[    1.239364] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.239368] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.239371] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239379] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.239382] pci 0000:00:1d.1: Performing full reset
[    1.239396] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xb1
[    1.239411] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.239415] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.239419] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239427] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.239429] pci 0000:00:1d.2: Performing full reset
[    1.239444] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xb1
[    1.239459] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x15e
[    1.239463] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
[    1.239466] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239519] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xb1
[    1.239534] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239538] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239542] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239545] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xb1
[    1.239561] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239565] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239568] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239572] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xb1
[    1.239587] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.239591] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.239594] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239598] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xb1
[    1.239613] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.239617] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.239620] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239624] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xb1
[    1.239639] pci 0000:03:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.239643] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.239646] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.239650] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xb1
[    1.239664] PCI: CLS 64 bytes, default 64
[    1.240056] Trying to unpack rootfs image as initramfs...
[    2.156571] Freeing initrd memory: 32660k freed
[    2.315041] DMA-API: preallocated 32768 debug entries
[    2.315097] DMA-API: debugging enabled by kernel config
[    2.315155] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.315207] Placing 64MB software IO TLB between ffff8800b96a1000 - ffff8800bd6a1000
[    2.315271] software IO TLB at phys 0xb96a1000 - 0xbd6a1000
[    2.315501] Simple Boot Flag at 0x35 set to 0x1
[    2.317683] audit: initializing netlink socket (disabled)
[    2.317814] type=2000 audit(1300751423.312:1): initialized
[    2.338356] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.363853] fuse init (API version 7.16)
[    2.364785] msgmni has been set to 7696
[    2.366144] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.366215] io scheduler noop registered
[    2.366263] io scheduler deadline registered
[    2.366634] io scheduler cfq registered (default)
[    2.366683] start plist test
[    2.368479] end plist test
[    2.369439] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.369518] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.370294] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.370368] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.371141] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.371215] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    2.372349] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.372407] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.372596] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    2.372650] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.372706] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    2.372894] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    2.372951] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    2.373126] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.373879] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    2.374058] pci_bus 0000:02: dev 00, created physical slot 0
[    2.374181] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    2.374238] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    2.374404] pci_bus 0000:03: dev 00, created physical slot 1
[    2.374528] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    2.374583] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    2.374749] pci_bus 0000:05: dev 00, created physical slot 3
[    2.374872] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    2.374934] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.375750] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.376900] ACPI: AC Adapter [AC] (on-line)
[    2.378436] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.412023] ACPI: Lid Switch [LID]
[    2.412668] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.468021] ACPI: Sleep Button [SLPB]
[    2.468686] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.468761] ACPI: Power Button [PWRF]
[    2.468993] ACPI: acpi_idle registered with cpuidle
[    2.587096] Monitor-Mwait will be used to enter C-1 state
[    2.587175] Monitor-Mwait will be used to enter C-2 state
[    2.587249] Monitor-Mwait will be used to enter C-3 state
[    2.587261] Marking TSC unstable due to TSC halts in idle
[    2.683478] thermal LNXTHERM:00: registered as thermal_zone0
[    2.683530] ACPI: Thermal Zone [THM0] (57 C)
[    2.693144] thermal LNXTHERM:01: registered as thermal_zone1
[    2.693196] ACPI: Thermal Zone [THM1] (60 C)
[    2.693720] Linux agpgart interface v0.103
[    2.707884] brd: module loaded
[    2.714637] loop: module loaded
[    2.716368] ahci 0000:00:1f.2: version 3.0
[    2.716449] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.716768] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.716928] ahci: SSS flag set, parallel bus scan disabled
[    2.717075] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.717205] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.717359] ahci 0000:00:1f.2: setting latency timer to 64
[    2.727471] scsi0 : ahci
[    2.728657] scsi1 : ahci
[    2.729590] scsi2 : ahci
[    2.730620] scsi3 : ahci
[    2.745793] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
[    2.745858] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
[    2.745921] ata3: DUMMY
[    2.745964] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.746030] ata4: DUMMY
[    2.746053] ACPI: Battery Slot [BAT0] (battery present)
[    2.746663] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.746848] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.751408] scsi4 : ata_generic
[    2.752271] scsi5 : ata_generic
[    2.753015] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.753068] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.753354] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    2.753407] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.753535] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.753610] e1000e 0000:00:19.0: setting latency timer to 64
[    2.753882] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    3.064031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.067391] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.067396] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.067461] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.067764] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    3.067817] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.071372] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.071377] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.071442] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.071745] ata1.00: configured for UDMA/133
[    3.072519] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    3.074867] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.075495] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.075571] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.075651] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.075759] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.075861] PPP generic driver version 2.4.2
[    3.076687] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.076781] sd 0:0:0:0: [sda] Write Protect is off
[    3.076832] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.077104] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.080487]  sda: sda1 sda2
[    3.084041] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.087329] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.087817] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.088660] mousedev: PS/2 mouse device common for all mice
[    3.089946] rtc_cmos 00:07: RTC can wake from S4
[    3.095054] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.112636] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.112753] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.112869] Linux video capture interface: v2.00
[    3.113678] device-mapper: uevent: version 1.0.3
[    3.114300] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.114548] device-mapper: multipath: version 1.2.0 loaded
[    3.114613] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.115971] cpuidle: using governor ladder
[    3.117527] cpuidle: using governor menu
[    3.118512] TCP cubic registered
[    3.119739] NET: Registered protocol family 10
[    3.122263] NET: Registered protocol family 17
[    3.122508] Bluetooth: RFCOMM TTY layer initialized
[    3.122579] Bluetooth: RFCOMM socket layer initialized
[    3.122629] Bluetooth: RFCOMM ver 1.11
[    3.122676] Registering the dns_resolver key type
[    3.123498] registered taskstats version 1
[    3.123691] kmemleak: Kernel memory leak detector initialized
[    3.123722] kmemleak: Automatic memory scanning thread started
[    3.126264] rtc_cmos 00:07: setting system clock to 2011-03-21 23:50:25 UTC (1300751425)
[    3.126330] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.126380] EDD information not available.
[    3.392056] ata2: SATA link down (SStatus 0 SControl 300)
[    3.559952] Freeing unused kernel memory: 568k freed
[    3.560244] Write protecting the kernel read-only data: 8192k
[    3.565226] Freeing unused kernel memory: 1264k freed
[    3.565959] Freeing unused kernel memory: 16k freed
[    3.595651] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.613409] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    4.062419] usbcore: registered new interface driver usbfs
[    4.063548] usbcore: registered new interface driver hub
[    4.065566] usbcore: registered new device driver usb
[    4.084335] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.084390] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.084679] uhci_hcd: USB Universal Host Controller Interface driver
[    4.084903] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.084973] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.085032] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.085117] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.085122] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.085255] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.092519] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.092576] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.092579] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.092763] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.093249] usb usb1: default language 0x0409
[    4.093384] usb usb1: udev 1, busnum 1, minor = 0
[    4.093387] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.093439] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.093500] usb usb1: Product: UHCI Host Controller
[    4.093549] usb usb1: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.093598] usb usb1: SerialNumber: 0000:00:1a.0
[    4.094477] usb usb1: usb_probe_device
[    4.094481] usb usb1: configuration #1 chosen from 1 choice
[    4.094595] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.095066] hub 1-0:1.0: usb_probe_interface
[    4.095070] hub 1-0:1.0: usb_probe_interface - got id
[    4.095075] hub 1-0:1.0: USB hub found
[    4.095223] hub 1-0:1.0: 2 ports detected
[    4.095286] hub 1-0:1.0: standalone hub
[    4.095289] hub 1-0:1.0: no power switching (usb 1.0)
[    4.095291] hub 1-0:1.0: individual port over-current protection
[    4.095294] hub 1-0:1.0: power on to power good time: 2ms
[    4.095413] hub 1-0:1.0: local power source is good
[    4.095431] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.096801] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.096884] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.096889] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.096989] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.112283] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.112342] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.112345] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.112495] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.112830] usb usb2: default language 0x0409
[    4.112966] usb usb2: udev 1, busnum 2, minor = 128
[    4.112969] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.113021] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.113082] usb usb2: Product: UHCI Host Controller
[    4.113131] usb usb2: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.113180] usb usb2: SerialNumber: 0000:00:1a.1
[    4.113900] usb usb2: usb_probe_device
[    4.113904] usb usb2: configuration #1 chosen from 1 choice
[    4.113981] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.114398] hub 2-0:1.0: usb_probe_interface
[    4.114402] hub 2-0:1.0: usb_probe_interface - got id
[    4.114406] hub 2-0:1.0: USB hub found
[    4.114555] hub 2-0:1.0: 2 ports detected
[    4.114618] hub 2-0:1.0: standalone hub
[    4.114620] hub 2-0:1.0: no power switching (usb 1.0)
[    4.114623] hub 2-0:1.0: individual port over-current protection
[    4.114626] hub 2-0:1.0: power on to power good time: 2ms
[    4.114720] hub 2-0:1.0: local power source is good
[    4.114737] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.116096] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.116164] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.116237] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.116320] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.116324] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.116425] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.132160] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.132217] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.132221] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.132391] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.132730] usb usb3: default language 0x0409
[    4.132865] usb usb3: udev 1, busnum 3, minor = 256
[    4.132868] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.132920] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.133523] usb usb3: Product: UHCI Host Controller
[    4.133571] usb usb3: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.133621] usb usb3: SerialNumber: 0000:00:1a.2
[    4.134344] usb usb3: usb_probe_device
[    4.134348] usb usb3: configuration #1 chosen from 1 choice
[    4.134426] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.134868] hub 3-0:1.0: usb_probe_interface
[    4.134871] hub 3-0:1.0: usb_probe_interface - got id
[    4.134876] hub 3-0:1.0: USB hub found
[    4.135025] hub 3-0:1.0: 2 ports detected
[    4.135088] hub 3-0:1.0: standalone hub
[    4.135091] hub 3-0:1.0: no power switching (usb 1.0)
[    4.135093] hub 3-0:1.0: individual port over-current protection
[    4.135096] hub 3-0:1.0: power on to power good time: 2ms
[    4.135192] hub 3-0:1.0: local power source is good
[    4.135209] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.136606] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.136676] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.136734] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.136870] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.136875] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.136975] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 4
[    4.148237] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.148244] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.148373] ehci_hcd 0000:00:1a.7: debug port 1
[    4.148425] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.152320] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.152323] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.152457] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.152510] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.156404] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.168075] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.168483] usb usb4: default language 0x0409
[    4.168619] usb usb4: udev 1, busnum 4, minor = 384
[    4.168622] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    4.168674] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.168735] usb usb4: Product: EHCI Host Controller
[    4.168783] usb usb4: Manufacturer: Linux 2.6.38+ ehci_hcd
[    4.168832] usb usb4: SerialNumber: 0000:00:1a.7
[    4.169546] usb usb4: usb_probe_device
[    4.169550] usb usb4: configuration #1 chosen from 1 choice
[    4.169625] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.169992] hub 4-0:1.0: usb_probe_interface
[    4.169995] hub 4-0:1.0: usb_probe_interface - got id
[    4.170000] hub 4-0:1.0: USB hub found
[    4.170139] hub 4-0:1.0: 6 ports detected
[    4.170208] hub 4-0:1.0: standalone hub
[    4.170210] hub 4-0:1.0: no power switching (usb 1.0)
[    4.170213] hub 4-0:1.0: individual port over-current protection
[    4.170215] hub 4-0:1.0: power on to power good time: 20ms
[    4.170297] hub 4-0:1.0: local power source is good
[    4.170312] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.171517] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.171530] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.171542] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.171757] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.171826] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.171898] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.172046] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.172052] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.172149] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    4.188084] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.188090] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.188218] ehci_hcd 0000:00:1d.7: debug port 1
[    4.188270] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.192085] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.192159] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.192162] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.192319] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.192372] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.196261] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.208026] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.208423] usb usb5: default language 0x0409
[    4.208575] usb usb5: udev 1, busnum 5, minor = 512
[    4.208578] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    4.208631] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.208693] usb usb5: Product: EHCI Host Controller
[    4.208749] usb usb5: Manufacturer: Linux 2.6.38+ ehci_hcd
[    4.208799] usb usb5: SerialNumber: 0000:00:1d.7
[    4.209589] usb usb5: usb_probe_device
[    4.209592] usb usb5: configuration #1 chosen from 1 choice
[    4.209667] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.210044] hub 5-0:1.0: usb_probe_interface
[    4.210047] hub 5-0:1.0: usb_probe_interface - got id
[    4.210052] hub 5-0:1.0: USB hub found
[    4.210191] hub 5-0:1.0: 6 ports detected
[    4.210255] hub 5-0:1.0: standalone hub
[    4.210257] hub 5-0:1.0: no power switching (usb 1.0)
[    4.210259] hub 5-0:1.0: individual port over-current protection
[    4.210263] hub 5-0:1.0: power on to power good time: 20ms
[    4.210355] hub 5-0:1.0: local power source is good
[    4.210372] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.211960] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.212523] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.212580] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.212703] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.213708] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.213714] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.213815] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.220165] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.220220] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.220223] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.220397] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.220771] usb usb6: default language 0x0409
[    4.220927] usb usb6: udev 1, busnum 6, minor = 640
[    4.220931] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.220984] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.221046] usb usb6: Product: UHCI Host Controller
[    4.221095] usb usb6: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.221109] Monitor-Mwait will be used to enter C-3 state
[    4.221151] usb usb6: SerialNumber: 0000:00:1d.0
[    4.222317] usb usb6: usb_probe_device
[    4.222321] usb usb6: configuration #1 chosen from 1 choice
[    4.222400] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.222774] hub 6-0:1.0: usb_probe_interface
[    4.222777] hub 6-0:1.0: usb_probe_interface - got id
[    4.222782] hub 6-0:1.0: USB hub found
[    4.222929] hub 6-0:1.0: 2 ports detected
[    4.222993] hub 6-0:1.0: standalone hub
[    4.222995] hub 6-0:1.0: no power switching (usb 1.0)
[    4.222998] hub 6-0:1.0: individual port over-current protection
[    4.223001] hub 6-0:1.0: power on to power good time: 2ms
[    4.223097] hub 6-0:1.0: local power source is good
[    4.223114] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.224415] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.224550] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.224635] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.224640] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.224738] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.232108] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.240169] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.240238] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.240241] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.240416] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.240759] usb usb7: default language 0x0409
[    4.240895] usb usb7: udev 1, busnum 7, minor = 768
[    4.240898] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.240950] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.241011] usb usb7: Product: UHCI Host Controller
[    4.241060] usb usb7: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.241109] usb usb7: SerialNumber: 0000:00:1d.1
[    4.241838] usb usb7: usb_probe_device
[    4.241842] usb usb7: configuration #1 chosen from 1 choice
[    4.241918] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.242280] hub 7-0:1.0: usb_probe_interface
[    4.242283] hub 7-0:1.0: usb_probe_interface - got id
[    4.242287] hub 7-0:1.0: USB hub found
[    4.242434] hub 7-0:1.0: 2 ports detected
[    4.242501] hub 7-0:1.0: standalone hub
[    4.242503] hub 7-0:1.0: no power switching (usb 1.0)
[    4.242505] hub 7-0:1.0: individual port over-current protection
[    4.242508] hub 7-0:1.0: power on to power good time: 2ms
[    4.242590] hub 7-0:1.0: local power source is good
[    4.242605] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.243752] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.243856] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.243935] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.243939] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.244264] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.260117] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.260173] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.260176] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.260238] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.260574] usb usb8: default language 0x0409
[    4.260712] usb usb8: udev 1, busnum 8, minor = 896
[    4.260714] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.260766] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.260827] usb usb8: Product: UHCI Host Controller
[    4.260876] usb usb8: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.260925] usb usb8: SerialNumber: 0000:00:1d.2
[    4.261650] usb usb8: usb_probe_device
[    4.261653] usb usb8: configuration #1 chosen from 1 choice
[    4.261729] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.262088] hub 8-0:1.0: usb_probe_interface
[    4.262091] hub 8-0:1.0: usb_probe_interface - got id
[    4.262095] hub 8-0:1.0: USB hub found
[    4.262240] hub 8-0:1.0: 2 ports detected
[    4.262307] hub 8-0:1.0: standalone hub
[    4.262310] hub 8-0:1.0: no power switching (usb 1.0)
[    4.262312] hub 8-0:1.0: individual port over-current protection
[    4.262314] hub 8-0:1.0: power on to power good time: 2ms
[    4.262395] hub 8-0:1.0: local power source is good
[    4.262410] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.263566] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.268054] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.268066] hub 4-0:1.0: port 1: status 0501 change 0001
[    4.268138] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.268148] hub 4-0:1.0: port 3: status 0501 change 0001
[    4.292163] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.308105] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.308120] hub 5-0:1.0: port 1: status 0501 change 0001
[    4.312112] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.320123] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.340158] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.360181] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.368176] hub 4-0:1.0: state 7 ports 6 chg 000a evt 0000
[    4.368212] hub 4-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.368279] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.424123] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.424251] hub 4-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.480305] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.480310] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.480320] hub 4-0:1.0: port 3 not reset yet, waiting 50ms
[    4.536119] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.536215] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    4.536249] hub 5-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    4.536277] hub 5-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.592288] ehci_hcd 0000:00:1d.7: port 1 full speed --> companion
[    4.592702] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.592714] hub 5-0:1.0: port 1 not reset yet, waiting 50ms
[    4.648121] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.648217] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.648241] uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
[    4.648275] hub 6-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.776115] hub 6-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    4.888123] usb 6-1: new full speed USB device number 2 using uhci_hcd
[    5.020075] usb 6-1: ep0 maxpacket = 8
[    5.040615] usb 6-1: default language 0x0409
[    5.063638] usb 6-1: udev 2, busnum 6, minor = 641
[    5.063641] usb 6-1: New USB device found, idVendor=04b3, idProduct=301a
[    5.063694] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.063746] usb 6-1: Product: USB 1.1 2port downstream low power hub
[    5.063798] usb 6-1: Manufacturer: Lite-On Technology
[    5.064551] usb 6-1: usb_probe_device
[    5.064555] usb 6-1: configuration #1 chosen from 1 choice
[    5.070646] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    5.072770] hub 6-1:1.0: usb_probe_interface
[    5.072774] hub 6-1:1.0: usb_probe_interface - got id
[    5.072779] hub 6-1:1.0: USB hub found
[    5.073624] hub 6-1:1.0: 3 ports detected
[    5.073689] hub 6-1:1.0: compound device; port removable status: FRR
[    5.073692] hub 6-1:1.0: individual port power switching
[    5.073694] hub 6-1:1.0: individual port over-current protection
[    5.073697] hub 6-1:1.0: power on to power good time: 44ms
[    5.074631] hub 6-1:1.0: hub controller current requirement: 100mA
[    5.074634] hub 6-1:1.0: 100mA bus power budget for each child
[    5.075640] hub 6-1:1.0: enabling power on all ports
[    5.079482] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    5.079525] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.079551] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    5.079586] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    5.177647] hub 6-1:1.0: port 1: status 0101 change 0001
[    5.208104] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    5.280104] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    5.320124] usb 1-1: new low speed USB device number 2 using uhci_hcd
[    5.360066] usb usb3: suspend_rh (auto-stop)
[    5.360099] usb usb7: suspend_rh (auto-stop)
[    5.360126] usb usb8: suspend_rh (auto-stop)
[    5.478052] usb 1-1: skipped 1 descriptor after interface
[    5.478064] usb 1-1: skipped 1 descriptor after interface
[    5.483029] usb 1-1: default language 0x0409
[    5.498047] usb 1-1: udev 2, busnum 1, minor = 1
[    5.498051] usb 1-1: New USB device found, idVendor=046d, idProduct=c521
[    5.498104] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.498157] usb 1-1: Product: USB Receiver
[    5.498210] usb 1-1: Manufacturer: Logitech
[    5.498766] usb 1-1: usb_probe_device
[    5.498770] usb 1-1: configuration #1 chosen from 1 choice
[    5.509045] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.509596] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[    5.510702] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.510728] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.510763] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.522593] usbhid 1-1:1.0: usb_probe_interface
[    5.522597] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.539044] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    5.540420] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    5.540533] usbhid 1-1:1.1: usb_probe_interface
[    5.540537] usbhid 1-1:1.1: usb_probe_interface - got id
[    5.570715] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.1/input/input6
[    5.570841] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    5.571382] usbhid 1-1:1.1: looking for a minor, starting at 96
[    5.572394] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    5.572584] usbcore: registered new interface driver usbhid
[    5.572640] usbhid: USB HID core driver
[    5.636094] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.748124] usb 2-1: new full speed USB device number 2 using uhci_hcd
[    5.880061] usb 2-1: ep0 maxpacket = 8
[    5.906696] usb 2-1: default language 0x0409
[    5.915709] usb 2-1: udev 2, busnum 2, minor = 129
[    5.915712] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.915765] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.915818] usb 2-1: Product: Fingerprint Sensor
[    5.916451] usb 2-1: usb_probe_device
[    5.916455] usb 2-1: configuration #1 chosen from 1 choice
[    5.917820] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.919266] hub 6-1:1.0: state 7 ports 3 chg 0002 evt 0000
[    5.920624] hub 6-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    5.997631] usb 6-1.1: new full speed USB device number 3 using uhci_hcd
[    6.092064] usb 6-1.1: ep0 maxpacket = 8
[    6.113637] usb 6-1.1: skipped 1 descriptor after interface
[    6.113649] usb 6-1.1: skipped 1 descriptor after interface
[    6.116614] usb 6-1.1: default language 0x0409
[    6.143627] usb 6-1.1: udev 3, busnum 6, minor = 642
[    6.143630] usb 6-1.1: New USB device found, idVendor=04b3, idProduct=301b
[    6.143689] usb 6-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    6.143750] usb 6-1.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    6.143813] usb 6-1.1: Manufacturer: Lite-On Technology
[    6.144457] usb 6-1.1: usb_probe_device
[    6.144461] usb 6-1.1: configuration #1 chosen from 1 choice
[    6.148646] usb 6-1.1: adding 6-1.1:1.0 (config #1, interface 0)
[    6.150778] usbhid 6-1.1:1.0: usb_probe_interface
[    6.150782] usbhid 6-1.1:1.0: usb_probe_interface - got id
[    6.161058] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.1/6-1.1:1.0/input/input7
[    6.161193] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 17 us
[    6.162253] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-1.1/input0
[    6.162613] usb 6-1.1: adding 6-1.1:1.1 (config #1, interface 1)
[    6.164775] usbhid 6-1.1:1.1: usb_probe_interface
[    6.164779] usbhid 6-1.1:1.1: usb_probe_interface - got id
[    6.168858] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.1/6-1.1:1.1/input/input8
[    6.168988] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 128, phase 0, 14 us
[    6.170043] generic-usb 0003:04B3:301B.0004: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-1.1/input1
[    6.170989] hub 6-1:1.0: 356mA power budget left
[    6.170994] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.171029] hub 6-1:1.0: state 7 ports 3 chg 0000 evt 0002
[    6.808150] hub 3-0:1.0: hub_suspend
[    6.808192] usb usb3: bus auto-suspend
[    6.808195] usb usb3: suspend_rh
[    6.808216] hub 7-0:1.0: hub_suspend
[    6.808222] usb usb7: bus auto-suspend
[    6.808225] usb usb7: suspend_rh
[    6.808245] hub 8-0:1.0: hub_suspend
[    6.808251] usb usb8: bus auto-suspend
[    6.808253] usb usb8: suspend_rh
[    6.808273] hub 4-0:1.0: hub_suspend
[    6.808279] usb usb4: bus auto-suspend
[    6.808282] ehci_hcd 0000:00:1a.7: suspend root hub
[    7.824142] hub 5-0:1.0: hub_suspend
[    7.824150] usb usb5: bus auto-suspend
[    7.824153] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.873597] EXT3-fs: barriers not enabled
[    8.874135] kjournald starting.  Commit interval 5 seconds
[    8.874329] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   14.240546] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   14.270756] EXT3-fs (sda1): using internal journal
[   14.320615] udev[2710]: starting version 163
[   14.745350] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.745727] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.787848] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.796268] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   14.938556] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   14.970999] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 4, 118 us
[   15.356912] sshd (2872): /proc/2872/oom_adj is deprecated, please use /proc/2872/oom_score_adj instead.
[   15.420738] cfg80211: Calling CRDA to update world regulatory domain
[   15.431776] [drm] Initialized drm 1.1.0 20060810
[   15.543143] cfg80211: World regulatory domain updated:
[   15.543147] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.543151] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.543155] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.543159] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.543162] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.543166] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.797806] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.797830] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.797840] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.797846] i915 0000:00:02.0: setting latency timer to 64
[   15.864417] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.868113] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.868117] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.868320] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.868331] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.868409] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.906015] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.906020] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.906063] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.906197] iwlagn 0000:03:00.0: irq 45 for MSI/MSI-X
[   15.920252] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.921081] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.951074] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.977169] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.993097] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   16.027597] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   16.027676] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   16.028384] Registered led device: phy0-led
[   16.104293] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   16.180969] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   16.181075] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   16.181078] [drm] Driver supports precise vblank timestamp query.
[   16.450318] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   17.075111] fb0: inteldrmfb frame buffer device
[   17.075114] drm: registered panic notifier
[   17.226845] acpi device:02: registered as cooling_device2
[   17.233546] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input9
[   17.241034] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   17.247700] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.247845] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   17.247992] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   17.248322] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   17.404842] Console: switching to colour frame buffer device 180x56
[   18.948913] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   18.949489] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.288122] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   29.184086] eth0: no IPv6 routers present
[   96.915675] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[   97.032200] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[   97.032213] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[   97.032255] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[   97.032368] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x169
[   97.032445] pci 0000:05:00.0: PME# supported from D0 D3hot
[   97.032454] pci 0000:05:00.0: PME# disabled
[   97.032548] pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf0001fff 64bit]
[   97.032562] pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf0001fff 64bit] (PCI address [0xf0000000-0xf0001fff])
[   97.032570] pcieport 0000:00:1c.3: PCI bridge to [bus 05-0c]
[   97.032574] pcieport 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[   97.032582] pcieport 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[   97.032588] pcieport 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[   97.032606] pcieport 0000:00:1c.3: setting latency timer to 64
[   97.032702] pci 0000:05:00.0: no hotplug settings from platform
[   97.054251] xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[   97.054263] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   97.054381] xhci_hcd 0000:05:00.0: enabling bus mastering
[   97.054390] xhci_hcd 0000:05:00.0: setting latency timer to 64
[   97.054396] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   97.054460] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
[   97.072205] xhci_hcd 0000:05:00.0: xHCI capability registers at ffffc900044c4000:
[   97.072212] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[   97.072215] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[   97.072218] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[   97.072223] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[   97.072225] xhci_hcd 0000:05:00.0:   Max device slots: 32
[   97.072228] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[   97.072231] xhci_hcd 0000:05:00.0:   Max ports: 4
[   97.072236] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[   97.072238] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[   97.072241] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[   97.072246] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[   97.072248] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[   97.072251] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[   97.072256] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[   97.072259] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[   97.072262] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[   97.072266] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[   97.072269] xhci_hcd 0000:05:00.0: xHCI operational registers at ffffc900044c4020:
[   97.072274] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[   97.072277] xhci_hcd 0000:05:00.0:   HC is being stopped
[   97.072279] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[   97.072282] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[   97.072285] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[   97.072287] xhci_hcd 0000:05:00.0:   HC has finished light reset
[   97.072292] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[   97.072294] xhci_hcd 0000:05:00.0:   Event ring is empty
[   97.072297] xhci_hcd 0000:05:00.0:   No Host System Error
[   97.072299] xhci_hcd 0000:05:00.0:   HC is halted
[   97.072305] xhci_hcd 0000:05:00.0: ffffc900044c4420 port status reg = 0x2a0
[   97.072310] xhci_hcd 0000:05:00.0: ffffc900044c4424 port power reg = 0x0
[   97.072315] xhci_hcd 0000:05:00.0: ffffc900044c4428 port link reg = 0x0
[   97.072320] xhci_hcd 0000:05:00.0: ffffc900044c442c port reserved reg = 0x0
[   97.072326] xhci_hcd 0000:05:00.0: ffffc900044c4430 port status reg = 0x2a0
[   97.072331] xhci_hcd 0000:05:00.0: ffffc900044c4434 port power reg = 0x0
[   97.072336] xhci_hcd 0000:05:00.0: ffffc900044c4438 port link reg = 0x0
[   97.072342] xhci_hcd 0000:05:00.0: ffffc900044c443c port reserved reg = 0x0
[   97.072347] xhci_hcd 0000:05:00.0: ffffc900044c4440 port status reg = 0x2a0
[   97.072352] xhci_hcd 0000:05:00.0: ffffc900044c4444 port power reg = 0x0
[   97.072357] xhci_hcd 0000:05:00.0: ffffc900044c4448 port link reg = 0x0
[   97.072362] xhci_hcd 0000:05:00.0: ffffc900044c444c port reserved reg = 0x0
[   97.072367] xhci_hcd 0000:05:00.0: ffffc900044c4450 port status reg = 0x2a0
[   97.072372] xhci_hcd 0000:05:00.0: ffffc900044c4454 port power reg = 0x0
[   97.072377] xhci_hcd 0000:05:00.0: ffffc900044c4458 port link reg = 0x0
[   97.072382] xhci_hcd 0000:05:00.0: ffffc900044c445c port reserved reg = 0x0
[   97.072385] xhci_hcd 0000:05:00.0: // Halt the HC
[   97.072392] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4020, 32'h0, 4'hf);
[   97.072397] xhci_hcd 0000:05:00.0: Resetting HCD
[   97.072402] xhci_hcd 0000:05:00.0: // Reset the HC
[   97.072407] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4020, 32'h2, 4'hf);
[   97.072453] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[   97.072458] xhci_hcd 0000:05:00.0: Reset complete
[   97.072463] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   97.072465] xhci_hcd 0000:05:00.0: Calling HCD init
[   97.072468] xhci_hcd 0000:05:00.0: xhci_init
[   97.072470] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[   97.072475] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[   97.072478] xhci_hcd 0000:05:00.0: Supported page size of 4K
[   97.072481] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[   97.072486] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[   97.072491] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[   97.072494] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4058, 32'h20, 4'hf);
[   97.072513] xhci_hcd 0000:05:00.0: // Device context base array address = 0x37809000 (DMA), ffff880037809000 (virt)
[   97.072517] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900044c4050, 64'h37809000, 4'hf);
[   97.072577] xhci_hcd 0000:05:00.0: Allocating ring at ffff880131d3a960
[   97.072592] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff880133118dc0
[   97.072624] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780a000 (virtual) 0x3780a000 (DMA)
[   97.072630] xhci_hcd 0000:05:00.0: Linking segment 0x3780a000 to segment 0x3780a000 (DMA)
[   97.072634] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment ffff880133118dc0 (virtual), 0x3780a000 (DMA)
[   97.072637] xhci_hcd 0000:05:00.0: Allocated command ring at ffff880131d3a960
[   97.072640] xhci_hcd 0000:05:00.0: First segment DMA is 0x3780a000
[   97.072646] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[   97.072650] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900044c4038, 64'h3780a001, 4'hf);
[   97.072657] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   97.072660] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   97.072665] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[   97.072668] xhci_hcd 0000:05:00.0: // xHCI capability registers at ffffc900044c4000:
[   97.072673] xhci_hcd 0000:05:00.0: // @ffffc900044c4000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[   97.072676] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[   97.072679] xhci_hcd 0000:05:00.0: // xHCI operational registers at ffffc900044c4020:
[   97.072684] xhci_hcd 0000:05:00.0: // @ffffc900044c4018 = 0x600 RTSOFF
[   97.072687] xhci_hcd 0000:05:00.0: // xHCI runtime registers at ffffc900044c4600:
[   97.072692] xhci_hcd 0000:05:00.0: // @ffffc900044c4014 = 0x800 DBOFF
[   97.072695] xhci_hcd 0000:05:00.0: // Doorbell array at ffffc900044c4800:
[   97.072698] xhci_hcd 0000:05:00.0: xHCI runtime registers at ffffc900044c4600:
[   97.072703] xhci_hcd 0000:05:00.0:   ffffc900044c4600: Microframe index = 0x0
[   97.072719] xhci_hcd 0000:05:00.0: // Allocating event ring
[   97.072732] xhci_hcd 0000:05:00.0: Allocating ring at ffff880131d3a9c0
[   97.072746] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff8801331186c0
[   97.072750] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780a400 (virtual) 0x3780a400 (DMA)
[   97.072754] xhci_hcd 0000:05:00.0: Linking segment 0x3780a400 to segment 0x3780a400 (DMA)
[   97.072758] xhci_hcd 0000:05:00.0: TRB math tests passed.
[   97.072774] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x3780b000
[   97.072778] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88003780b000, dma addr = 0x3780b000
[   97.072784] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[   97.072787] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4628, 32'h1, 4'hf);
[   97.072790] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[   97.072793] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x3780b000
[   97.072800] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900044c4630, 64'h3780b000, 4'hf);
[   97.072807] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[   97.072810] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900044c4638, 64'h3780a400, 4'hf);
[   97.072813] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[   97.072819] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[   97.072842] xhci_hcd 0000:05:00.0: Ext Cap ffffc900044c4510, port offset = 1, count = 2, revision = 0x3
[   97.072850] xhci_hcd 0000:05:00.0: Ext Cap ffffc900044c4520, port offset = 3, count = 2, revision = 0x2
[   97.072853] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[   97.072868] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = ffffc900044c4440
[   97.072871] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = ffffc900044c4450
[   97.072886] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = ffffc900044c4420
[   97.072889] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = ffffc900044c4430
[   97.072892] xhci_hcd 0000:05:00.0: Finished xhci_init
[   97.072894] xhci_hcd 0000:05:00.0: Called HCD init
[   97.072900] xhci_hcd 0000:05:00.0: Got SBRN 48
[   97.072914] xhci_hcd 0000:05:00.0: enabling Mem-Wr-Inval
[   97.072919] xhci_hcd 0000:05:00.0: MWI active
[   97.072922] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[   97.072924] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   97.072974] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
[   97.072976] xhci_hcd 0000:05:00.0: xhci_run
[   97.073160] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[   97.073167] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[   97.073172] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[   97.073727] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[   97.073731] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[   97.073734] xhci_hcd 0000:05:00.0: @3780a000 00000000 00000000 00000000 00000000
[   97.073738] xhci_hcd 0000:05:00.0: @3780a010 00000000 00000000 00000000 00000000
[   97.073741] xhci_hcd 0000:05:00.0: @3780a020 00000000 00000000 00000000 00000000
[   97.073744] xhci_hcd 0000:05:00.0: @3780a030 00000000 00000000 00000000 00000000
[   97.073747] xhci_hcd 0000:05:00.0: @3780a040 00000000 00000000 00000000 00000000
[   97.073750] xhci_hcd 0000:05:00.0: @3780a050 00000000 00000000 00000000 00000000
[   97.073754] xhci_hcd 0000:05:00.0: @3780a060 00000000 00000000 00000000 00000000
[   97.073757] xhci_hcd 0000:05:00.0: @3780a070 00000000 00000000 00000000 00000000
[   97.073760] xhci_hcd 0000:05:00.0: @3780a080 00000000 00000000 00000000 00000000
[   97.073764] xhci_hcd 0000:05:00.0: @3780a090 00000000 00000000 00000000 00000000
[   97.073767] xhci_hcd 0000:05:00.0: @3780a0a0 00000000 00000000 00000000 00000000
[   97.073770] xhci_hcd 0000:05:00.0: @3780a0b0 00000000 00000000 00000000 00000000
[   97.073773] xhci_hcd 0000:05:00.0: @3780a0c0 00000000 00000000 00000000 00000000
[   97.073776] xhci_hcd 0000:05:00.0: @3780a0d0 00000000 00000000 00000000 00000000
[   97.073780] xhci_hcd 0000:05:00.0: @3780a0e0 00000000 00000000 00000000 00000000
[   97.073783] xhci_hcd 0000:05:00.0: @3780a0f0 00000000 00000000 00000000 00000000
[   97.073786] xhci_hcd 0000:05:00.0: @3780a100 00000000 00000000 00000000 00000000
[   97.073789] xhci_hcd 0000:05:00.0: @3780a110 00000000 00000000 00000000 00000000
[   97.073792] xhci_hcd 0000:05:00.0: @3780a120 00000000 00000000 00000000 00000000
[   97.073796] xhci_hcd 0000:05:00.0: @3780a130 00000000 00000000 00000000 00000000
[   97.073799] xhci_hcd 0000:05:00.0: @3780a140 00000000 00000000 00000000 00000000
[   97.073802] xhci_hcd 0000:05:00.0: @3780a150 00000000 00000000 00000000 00000000
[   97.073805] xhci_hcd 0000:05:00.0: @3780a160 00000000 00000000 00000000 00000000
[   97.073808] xhci_hcd 0000:05:00.0: @3780a170 00000000 00000000 00000000 00000000
[   97.073812] xhci_hcd 0000:05:00.0: @3780a180 00000000 00000000 00000000 00000000
[   97.073815] xhci_hcd 0000:05:00.0: @3780a190 00000000 00000000 00000000 00000000
[   97.073818] xhci_hcd 0000:05:00.0: @3780a1a0 00000000 00000000 00000000 00000000
[   97.073821] xhci_hcd 0000:05:00.0: @3780a1b0 00000000 00000000 00000000 00000000
[   97.073825] xhci_hcd 0000:05:00.0: @3780a1c0 00000000 00000000 00000000 00000000
[   97.073828] xhci_hcd 0000:05:00.0: @3780a1d0 00000000 00000000 00000000 00000000
[   97.073831] xhci_hcd 0000:05:00.0: @3780a1e0 00000000 00000000 00000000 00000000
[   97.073834] xhci_hcd 0000:05:00.0: @3780a1f0 00000000 00000000 00000000 00000000
[   97.073837] xhci_hcd 0000:05:00.0: @3780a200 00000000 00000000 00000000 00000000
[   97.073841] xhci_hcd 0000:05:00.0: @3780a210 00000000 00000000 00000000 00000000
[   97.073844] xhci_hcd 0000:05:00.0: @3780a220 00000000 00000000 00000000 00000000
[   97.073847] xhci_hcd 0000:05:00.0: @3780a230 00000000 00000000 00000000 00000000
[   97.073851] xhci_hcd 0000:05:00.0: @3780a240 00000000 00000000 00000000 00000000
[   97.073854] xhci_hcd 0000:05:00.0: @3780a250 00000000 00000000 00000000 00000000
[   97.073857] xhci_hcd 0000:05:00.0: @3780a260 00000000 00000000 00000000 00000000
[   97.073860] xhci_hcd 0000:05:00.0: @3780a270 00000000 00000000 00000000 00000000
[   97.073863] xhci_hcd 0000:05:00.0: @3780a280 00000000 00000000 00000000 00000000
[   97.073867] xhci_hcd 0000:05:00.0: @3780a290 00000000 00000000 00000000 00000000
[   97.073870] xhci_hcd 0000:05:00.0: @3780a2a0 00000000 00000000 00000000 00000000
[   97.073873] xhci_hcd 0000:05:00.0: @3780a2b0 00000000 00000000 00000000 00000000
[   97.073876] xhci_hcd 0000:05:00.0: @3780a2c0 00000000 00000000 00000000 00000000
[   97.073879] xhci_hcd 0000:05:00.0: @3780a2d0 00000000 00000000 00000000 00000000
[   97.073883] xhci_hcd 0000:05:00.0: @3780a2e0 00000000 00000000 00000000 00000000
[   97.073886] xhci_hcd 0000:05:00.0: @3780a2f0 00000000 00000000 00000000 00000000
[   97.073889] xhci_hcd 0000:05:00.0: @3780a300 00000000 00000000 00000000 00000000
[   97.073892] xhci_hcd 0000:05:00.0: @3780a310 00000000 00000000 00000000 00000000
[   97.073895] xhci_hcd 0000:05:00.0: @3780a320 00000000 00000000 00000000 00000000
[   97.073899] xhci_hcd 0000:05:00.0: @3780a330 00000000 00000000 00000000 00000000
[   97.073902] xhci_hcd 0000:05:00.0: @3780a340 00000000 00000000 00000000 00000000
[   97.073905] xhci_hcd 0000:05:00.0: @3780a350 00000000 00000000 00000000 00000000
[   97.073908] xhci_hcd 0000:05:00.0: @3780a360 00000000 00000000 00000000 00000000
[   97.073912] xhci_hcd 0000:05:00.0: @3780a370 00000000 00000000 00000000 00000000
[   97.073915] xhci_hcd 0000:05:00.0: @3780a380 00000000 00000000 00000000 00000000
[   97.073918] xhci_hcd 0000:05:00.0: @3780a390 00000000 00000000 00000000 00000000
[   97.073921] xhci_hcd 0000:05:00.0: @3780a3a0 00000000 00000000 00000000 00000000
[   97.073924] xhci_hcd 0000:05:00.0: @3780a3b0 00000000 00000000 00000000 00000000
[   97.073928] xhci_hcd 0000:05:00.0: @3780a3c0 00000000 00000000 00000000 00000000
[   97.073931] xhci_hcd 0000:05:00.0: @3780a3d0 00000000 00000000 00000000 00000000
[   97.073934] xhci_hcd 0000:05:00.0: @3780a3e0 00000000 00000000 00000000 00000000
[   97.073937] xhci_hcd 0000:05:00.0: @3780a3f0 3780a000 00000000 00000000 00001802
[   97.073940] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   97.073943] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780a000 (virt), 0x3780a000 (dma)
[   97.073946] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   97.073949] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780a000 (virt), 0x3780a000 (dma)
[   97.073952] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   97.073959] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   97.073962] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   97.073965] xhci_hcd 0000:05:00.0: ERST memory map follows:
[   97.073968] xhci_hcd 0000:05:00.0: @3780b000 3780a400 00000000 00000040 00000000
[   97.073971] xhci_hcd 0000:05:00.0: Event ring:
[   97.073974] xhci_hcd 0000:05:00.0: @3780a400 00000000 00000000 00000000 00000000
[   97.073977] xhci_hcd 0000:05:00.0: @3780a410 00000000 00000000 00000000 00000000
[   97.073980] xhci_hcd 0000:05:00.0: @3780a420 00000000 00000000 00000000 00000000
[   97.073983] xhci_hcd 0000:05:00.0: @3780a430 00000000 00000000 00000000 00000000
[   97.073987] xhci_hcd 0000:05:00.0: @3780a440 00000000 00000000 00000000 00000000
[   97.073990] xhci_hcd 0000:05:00.0: @3780a450 00000000 00000000 00000000 00000000
[   97.073993] xhci_hcd 0000:05:00.0: @3780a460 00000000 00000000 00000000 00000000
[   97.073996] xhci_hcd 0000:05:00.0: @3780a470 00000000 00000000 00000000 00000000
[   97.074000] xhci_hcd 0000:05:00.0: @3780a480 00000000 00000000 00000000 00000000
[   97.074003] xhci_hcd 0000:05:00.0: @3780a490 00000000 00000000 00000000 00000000
[   97.074006] xhci_hcd 0000:05:00.0: @3780a4a0 00000000 00000000 00000000 00000000
[   97.074009] xhci_hcd 0000:05:00.0: @3780a4b0 00000000 00000000 00000000 00000000
[   97.074012] xhci_hcd 0000:05:00.0: @3780a4c0 00000000 00000000 00000000 00000000
[   97.074016] xhci_hcd 0000:05:00.0: @3780a4d0 00000000 00000000 00000000 00000000
[   97.074019] xhci_hcd 0000:05:00.0: @3780a4e0 00000000 00000000 00000000 00000000
[   97.074022] xhci_hcd 0000:05:00.0: @3780a4f0 00000000 00000000 00000000 00000000
[   97.074025] xhci_hcd 0000:05:00.0: @3780a500 00000000 00000000 00000000 00000000
[   97.074028] xhci_hcd 0000:05:00.0: @3780a510 00000000 00000000 00000000 00000000
[   97.074032] xhci_hcd 0000:05:00.0: @3780a520 00000000 00000000 00000000 00000000
[   97.074035] xhci_hcd 0000:05:00.0: @3780a530 00000000 00000000 00000000 00000000
[   97.074038] xhci_hcd 0000:05:00.0: @3780a540 00000000 00000000 00000000 00000000
[   97.074041] xhci_hcd 0000:05:00.0: @3780a550 00000000 00000000 00000000 00000000
[   97.074045] xhci_hcd 0000:05:00.0: @3780a560 00000000 00000000 00000000 00000000
[   97.074048] xhci_hcd 0000:05:00.0: @3780a570 00000000 00000000 00000000 00000000
[   97.074051] xhci_hcd 0000:05:00.0: @3780a580 00000000 00000000 00000000 00000000
[   97.074054] xhci_hcd 0000:05:00.0: @3780a590 00000000 00000000 00000000 00000000
[   97.074057] xhci_hcd 0000:05:00.0: @3780a5a0 00000000 00000000 00000000 00000000
[   97.074061] xhci_hcd 0000:05:00.0: @3780a5b0 00000000 00000000 00000000 00000000
[   97.074064] xhci_hcd 0000:05:00.0: @3780a5c0 00000000 00000000 00000000 00000000
[   97.074067] xhci_hcd 0000:05:00.0: @3780a5d0 00000000 00000000 00000000 00000000
[   97.074070] xhci_hcd 0000:05:00.0: @3780a5e0 00000000 00000000 00000000 00000000
[   97.074074] xhci_hcd 0000:05:00.0: @3780a5f0 00000000 00000000 00000000 00000000
[   97.074077] xhci_hcd 0000:05:00.0: @3780a600 00000000 00000000 00000000 00000000
[   97.074080] xhci_hcd 0000:05:00.0: @3780a610 00000000 00000000 00000000 00000000
[   97.074083] xhci_hcd 0000:05:00.0: @3780a620 00000000 00000000 00000000 00000000
[   97.074086] xhci_hcd 0000:05:00.0: @3780a630 00000000 00000000 00000000 00000000
[   97.074090] xhci_hcd 0000:05:00.0: @3780a640 00000000 00000000 00000000 00000000
[   97.074093] xhci_hcd 0000:05:00.0: @3780a650 00000000 00000000 00000000 00000000
[   97.074096] xhci_hcd 0000:05:00.0: @3780a660 00000000 00000000 00000000 00000000
[   97.074099] xhci_hcd 0000:05:00.0: @3780a670 00000000 00000000 00000000 00000000
[   97.074103] xhci_hcd 0000:05:00.0: @3780a680 00000000 00000000 00000000 00000000
[   97.074106] xhci_hcd 0000:05:00.0: @3780a690 00000000 00000000 00000000 00000000
[   97.074109] xhci_hcd 0000:05:00.0: @3780a6a0 00000000 00000000 00000000 00000000
[   97.074112] xhci_hcd 0000:05:00.0: @3780a6b0 00000000 00000000 00000000 00000000
[   97.074115] xhci_hcd 0000:05:00.0: @3780a6c0 00000000 00000000 00000000 00000000
[   97.074119] xhci_hcd 0000:05:00.0: @3780a6d0 00000000 00000000 00000000 00000000
[   97.074122] xhci_hcd 0000:05:00.0: @3780a6e0 00000000 00000000 00000000 00000000
[   97.074125] xhci_hcd 0000:05:00.0: @3780a6f0 00000000 00000000 00000000 00000000
[   97.074128] xhci_hcd 0000:05:00.0: @3780a700 00000000 00000000 00000000 00000000
[   97.074132] xhci_hcd 0000:05:00.0: @3780a710 00000000 00000000 00000000 00000000
[   97.074135] xhci_hcd 0000:05:00.0: @3780a720 00000000 00000000 00000000 00000000
[   97.074138] xhci_hcd 0000:05:00.0: @3780a730 00000000 00000000 00000000 00000000
[   97.074141] xhci_hcd 0000:05:00.0: @3780a740 00000000 00000000 00000000 00000000
[   97.074144] xhci_hcd 0000:05:00.0: @3780a750 00000000 00000000 00000000 00000000
[   97.074148] xhci_hcd 0000:05:00.0: @3780a760 00000000 00000000 00000000 00000000
[   97.074151] xhci_hcd 0000:05:00.0: @3780a770 00000000 00000000 00000000 00000000
[   97.074154] xhci_hcd 0000:05:00.0: @3780a780 00000000 00000000 00000000 00000000
[   97.074157] xhci_hcd 0000:05:00.0: @3780a790 00000000 00000000 00000000 00000000
[   97.074161] xhci_hcd 0000:05:00.0: @3780a7a0 00000000 00000000 00000000 00000000
[   97.074164] xhci_hcd 0000:05:00.0: @3780a7b0 00000000 00000000 00000000 00000000
[   97.074167] xhci_hcd 0000:05:00.0: @3780a7c0 00000000 00000000 00000000 00000000
[   97.074170] xhci_hcd 0000:05:00.0: @3780a7d0 00000000 00000000 00000000 00000000
[   97.074173] xhci_hcd 0000:05:00.0: @3780a7e0 00000000 00000000 00000000 00000000
[   97.074177] xhci_hcd 0000:05:00.0: @3780a7f0 00000000 00000000 00000000 00000000
[   97.074179] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   97.074183] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780a400 (virt), 0x3780a400 (dma)
[   97.074185] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   97.074188] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780a400 (virt), 0x3780a400 (dma)
[   97.074191] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   97.074198] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780a400
[   97.074201] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[   97.074206] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4624, 32'ha0, 4'hf);
[   97.074211] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[   97.074214] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4020, 32'h4, 4'hf);
[   97.074220] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter ffffc900044c4620 by writing 0x2 to irq_pending
[   97.074224] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4620, 32'h2, 4'hf);
[   97.074229] xhci_hcd 0000:05:00.0:   ffffc900044c4620: ir_set[0]
[   97.074232] xhci_hcd 0000:05:00.0:   ffffc900044c4620: ir_set.pending = 0x2
[   97.074237] xhci_hcd 0000:05:00.0:   ffffc900044c4624: ir_set.control = 0xa0
[   97.074242] xhci_hcd 0000:05:00.0:   ffffc900044c4628: ir_set.erst_size = 0x1
[   97.074251] xhci_hcd 0000:05:00.0:   ffffc900044c4630: ir_set.erst_base = @3780b000
[   97.074258] xhci_hcd 0000:05:00.0:   ffffc900044c4638: ir_set.erst_dequeue = @3780a400
[   97.074261] xhci_hcd 0000:05:00.0: Endpoint state = 0x1
[   97.074264] xhci_hcd 0000:05:00.0: Command ring enq = 0x3780a010 (DMA)
[   97.074267] xhci_hcd 0000:05:00.0: Finished xhci_run for USB2 roothub
[   97.074540] usb usb9: default language 0x0409
[   97.074746] usb usb9: udev 1, busnum 9, minor = 1024
[   97.074749] usb usb9: New USB device found, idVendor=1d6b, idProduct=0002
[   97.074753] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   97.074756] usb usb9: Product: xHCI Host Controller
[   97.074758] usb usb9: Manufacturer: Linux 2.6.38+ xhci_hcd
[   97.074761] usb usb9: SerialNumber: 0000:05:00.0
[   97.075914] usb usb9: usb_probe_device
[   97.075919] usb usb9: configuration #1 chosen from 1 choice
[   97.075961] xHCI xhci_add_endpoint called for root hub
[   97.075964] xHCI xhci_check_bandwidth called for root hub
[   97.076072] usb usb9: adding 9-0:1.0 (config #1, interface 0)
[   97.076744] hub 9-0:1.0: usb_probe_interface
[   97.076747] hub 9-0:1.0: usb_probe_interface - got id
[   97.076753] hub 9-0:1.0: USB hub found
[   97.081115] hub 9-0:1.0: 2 ports detected
[   97.081146] hub 9-0:1.0: standalone hub
[   97.081149] hub 9-0:1.0: individual port power switching
[   97.081152] hub 9-0:1.0: individual port over-current protection
[   97.081156] hub 9-0:1.0: Single TT
[   97.081159] hub 9-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   97.081162] hub 9-0:1.0: power on to power good time: 20ms
[   97.081324] hub 9-0:1.0: local power source is good
[   97.081353] hub 9-0:1.0: enabling power on all ports
[   97.081417] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4440, 32'h2a0, 4'hf);
[   97.081423] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   97.081497] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4450, 32'h2a0, 4'hf);
[   97.081503] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   97.083700] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   97.083749] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 10
[   97.096654] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   97.096658] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   97.096663] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[   97.096667] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4020, 32'h5, 4'hf);
[   97.096682] xhci_hcd 0000:05:00.0: // Ding dong!
[   97.096685] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4800, 32'h0, 4'hf);
[   97.096690] xhci_hcd 0000:05:00.0: Finished xhci_run for USB3 roothub
[   97.096755] xhci_hcd 0000:05:00.0: op reg status = 00000008
[   97.096758] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
[   97.096763] xhci_hcd 0000:05:00.0: @3780a400 3780a000 00000000 01003021 0000c001
[   97.096766] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4024, 32'h8, 4'hf);
[   97.096770] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   97.096773] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
[   97.096776] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[   97.096779] xhci_hcd 0000:05:00.0: NEC firmware version 30.21
[   97.096783] xhci_hcd 0000:05:00.0: Command ring deq = 0x3780a010 (DMA)
[   97.096786] xhci_hcd 0000:05:00.0: Event ring deq = 0x3780a410 (DMA)
[   97.096789] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   97.096796] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900044c4638, 64'h3780a418, 4'hf);
[   97.096897] usb usb10: skipped 1 descriptor after endpoint
[   97.096962] usb usb10: default language 0x0409
[   97.097165] usb usb10: udev 1, busnum 10, minor = 1152
[   97.097168] usb usb10: New USB device found, idVendor=1d6b, idProduct=0003
[   97.097171] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   97.097174] usb usb10: Product: xHCI Host Controller
[   97.097177] usb usb10: Manufacturer: Linux 2.6.38+ xhci_hcd
[   97.097179] usb usb10: SerialNumber: 0000:05:00.0
[   97.098273] usb usb10: usb_probe_device
[   97.098277] usb usb10: configuration #1 chosen from 1 choice
[   97.098316] xHCI xhci_add_endpoint called for root hub
[   97.098318] xHCI xhci_check_bandwidth called for root hub
[   97.098389] usb usb10: adding 10-0:1.0 (config #1, interface 0)
[   97.098998] hub 10-0:1.0: usb_probe_interface
[   97.099001] hub 10-0:1.0: usb_probe_interface - got id
[   97.099006] hub 10-0:1.0: USB hub found
[   97.104301] hub 10-0:1.0: 2 ports detected
[   97.104331] hub 10-0:1.0: standalone hub
[   97.104334] hub 10-0:1.0: individual port power switching
[   97.104337] hub 10-0:1.0: individual port over-current protection
[   97.104341] hub 10-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   97.104344] hub 10-0:1.0: power on to power good time: 20ms
[   97.104487] hub 10-0:1.0: local power source is good
[   97.104513] hub 10-0:1.0: enabling power on all ports
[   97.104572] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4420, 32'h2a0, 4'hf);
[   97.104581] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   97.104649] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4430, 32'h2a0, 4'hf);
[   97.104657] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   97.180108] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   97.180114] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   97.180156] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   97.180159] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   97.180199] hub 9-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   97.204059] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   97.204064] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   97.204105] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   97.204108] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   97.204129] hub 10-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   99.810070] hub 9-0:1.0: hub_suspend
[   99.810176] usb usb9: bus auto-suspend
[   99.810179] xhci_hcd 0000:05:00.0: suspend USB 2.0 root hub
[   99.810187] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4450, 32'ha0002a0, 4'hf);
[   99.810194] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4440, 32'ha0002a0, 4'hf);
[   99.810203] hub 10-0:1.0: hub_suspend
[   99.810209] usb usb10: bus auto-suspend
[   99.810212] xhci_hcd 0000:05:00.0: suspend USB 3.0 root hub
[   99.810219] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4430, 32'ha0002a0, 4'hf);
[   99.810227] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900044c4420, 32'ha0002a0, 4'hf);
[  157.152152] xhci_hcd 0000:05:00.0: Poll event ring: 4294931584
[  157.152159] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  157.152165] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  157.152168] xhci_hcd 0000:05:00.0: HC error bitmask = 0x4
[  157.152171] xhci_hcd 0000:05:00.0: Event ring:
[  157.152175] xhci_hcd 0000:05:00.0: @3780a400 3780a000 00000000 01003021 0000c001
[  157.152178] xhci_hcd 0000:05:00.0: @3780a410 00000000 00000000 00000000 00000000
[  157.152181] xhci_hcd 0000:05:00.0: @3780a420 00000000 00000000 00000000 00000000
[  157.152185] xhci_hcd 0000:05:00.0: @3780a430 00000000 00000000 00000000 00000000
[  157.152188] xhci_hcd 0000:05:00.0: @3780a440 00000000 00000000 00000000 00000000
[  157.152191] xhci_hcd 0000:05:00.0: @3780a450 00000000 00000000 00000000 00000000
[  157.152194] xhci_hcd 0000:05:00.0: @3780a460 00000000 00000000 00000000 00000000
[  157.152198] xhci_hcd 0000:05:00.0: @3780a470 00000000 00000000 00000000 00000000
[  157.152201] xhci_hcd 0000:05:00.0: @3780a480 00000000 00000000 00000000 00000000
[  157.152204] xhci_hcd 0000:05:00.0: @3780a490 00000000 00000000 00000000 00000000
[  157.152213] xhci_hcd 0000:05:00.0: @3780a4a0 00000000 00000000 00000000 00000000
[  157.152215] xhci_hcd 0000:05:00.0: @3780a4b0 00000000 00000000 00000000 00000000
[  157.152218] xhci_hcd 0000:05:00.0: @3780a4c0 00000000 00000000 00000000 00000000
[  157.152221] xhci_hcd 0000:05:00.0: @3780a4d0 00000000 00000000 00000000 00000000
[  157.152224] xhci_hcd 0000:05:00.0: @3780a4e0 00000000 00000000 00000000 00000000
[  157.152227] xhci_hcd 0000:05:00.0: @3780a4f0 00000000 00000000 00000000 00000000
[  157.152230] xhci_hcd 0000:05:00.0: @3780a500 00000000 00000000 00000000 00000000
[  157.152232] xhci_hcd 0000:05:00.0: @3780a510 00000000 00000000 00000000 00000000
[  157.152235] xhci_hcd 0000:05:00.0: @3780a520 00000000 00000000 00000000 00000000
[  157.152238] xhci_hcd 0000:05:00.0: @3780a530 00000000 00000000 00000000 00000000
[  157.152241] xhci_hcd 0000:05:00.0: @3780a540 00000000 00000000 00000000 00000000
[  157.152244] xhci_hcd 0000:05:00.0: @3780a550 00000000 00000000 00000000 00000000
[  157.152246] xhci_hcd 0000:05:00.0: @3780a560 00000000 00000000 00000000 00000000
[  157.152249] xhci_hcd 0000:05:00.0: @3780a570 00000000 00000000 00000000 00000000
[  157.152252] xhci_hcd 0000:05:00.0: @3780a580 00000000 00000000 00000000 00000000
[  157.152255] xhci_hcd 0000:05:00.0: @3780a590 00000000 00000000 00000000 00000000
[  157.152258] xhci_hcd 0000:05:00.0: @3780a5a0 00000000 00000000 00000000 00000000
[  157.152260] xhci_hcd 0000:05:00.0: @3780a5b0 00000000 00000000 00000000 00000000
[  157.152263] xhci_hcd 0000:05:00.0: @3780a5c0 00000000 00000000 00000000 00000000
[  157.152266] xhci_hcd 0000:05:00.0: @3780a5d0 00000000 00000000 00000000 00000000
[  157.152269] xhci_hcd 0000:05:00.0: @3780a5e0 00000000 00000000 00000000 00000000
[  157.152272] xhci_hcd 0000:05:00.0: @3780a5f0 00000000 00000000 00000000 00000000
[  157.152275] xhci_hcd 0000:05:00.0: @3780a600 00000000 00000000 00000000 00000000
[  157.152277] xhci_hcd 0000:05:00.0: @3780a610 00000000 00000000 00000000 00000000
[  157.152280] xhci_hcd 0000:05:00.0: @3780a620 00000000 00000000 00000000 00000000
[  157.152283] xhci_hcd 0000:05:00.0: @3780a630 00000000 00000000 00000000 00000000
[  157.152286] xhci_hcd 0000:05:00.0: @3780a640 00000000 00000000 00000000 00000000
[  157.152289] xhci_hcd 0000:05:00.0: @3780a650 00000000 00000000 00000000 00000000
[  157.152292] xhci_hcd 0000:05:00.0: @3780a660 00000000 00000000 00000000 00000000
[  157.152294] xhci_hcd 0000:05:00.0: @3780a670 00000000 00000000 00000000 00000000
[  157.152297] xhci_hcd 0000:05:00.0: @3780a680 00000000 00000000 00000000 00000000
[  157.152300] xhci_hcd 0000:05:00.0: @3780a690 00000000 00000000 00000000 00000000
[  157.152303] xhci_hcd 0000:05:00.0: @3780a6a0 00000000 00000000 00000000 00000000
[  157.152306] xhci_hcd 0000:05:00.0: @3780a6b0 00000000 00000000 00000000 00000000
[  157.152309] xhci_hcd 0000:05:00.0: @3780a6c0 00000000 00000000 00000000 00000000
[  157.152311] xhci_hcd 0000:05:00.0: @3780a6d0 00000000 00000000 00000000 00000000
[  157.152314] xhci_hcd 0000:05:00.0: @3780a6e0 00000000 00000000 00000000 00000000
[  157.152317] xhci_hcd 0000:05:00.0: @3780a6f0 00000000 00000000 00000000 00000000
[  157.152320] xhci_hcd 0000:05:00.0: @3780a700 00000000 00000000 00000000 00000000
[  157.152323] xhci_hcd 0000:05:00.0: @3780a710 00000000 00000000 00000000 00000000
[  157.152326] xhci_hcd 0000:05:00.0: @3780a720 00000000 00000000 00000000 00000000
[  157.152328] xhci_hcd 0000:05:00.0: @3780a730 00000000 00000000 00000000 00000000
[  157.152331] xhci_hcd 0000:05:00.0: @3780a740 00000000 00000000 00000000 00000000
[  157.152334] xhci_hcd 0000:05:00.0: @3780a750 00000000 00000000 00000000 00000000
[  157.152337] xhci_hcd 0000:05:00.0: @3780a760 00000000 00000000 00000000 00000000
[  157.152340] xhci_hcd 0000:05:00.0: @3780a770 00000000 00000000 00000000 00000000
[  157.152342] xhci_hcd 0000:05:00.0: @3780a780 00000000 00000000 00000000 00000000
[  157.152345] xhci_hcd 0000:05:00.0: @3780a790 00000000 00000000 00000000 00000000
[  157.152348] xhci_hcd 0000:05:00.0: @3780a7a0 00000000 00000000 00000000 00000000
[  157.152351] xhci_hcd 0000:05:00.0: @3780a7b0 00000000 00000000 00000000 00000000
[  157.152354] xhci_hcd 0000:05:00.0: @3780a7c0 00000000 00000000 00000000 00000000
[  157.152357] xhci_hcd 0000:05:00.0: @3780a7d0 00000000 00000000 00000000 00000000
[  157.152359] xhci_hcd 0000:05:00.0: @3780a7e0 00000000 00000000 00000000 00000000
[  157.152362] xhci_hcd 0000:05:00.0: @3780a7f0 00000000 00000000 00000000 00000000
[  157.152366] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780a410 (virt), 0x3780a410 (dma)
[  157.152368] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  157.152371] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780a400 (virt), 0x3780a400 (dma)
[  157.152374] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  157.152382] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780a410
[  157.152385] xhci_hcd 0000:05:00.0: Command ring:
[  157.152388] xhci_hcd 0000:05:00.0: @3780a000 00000000 00000000 00000000 0000c401
[  157.152390] xhci_hcd 0000:05:00.0: @3780a010 00000000 00000000 00000000 00000000
[  157.152393] xhci_hcd 0000:05:00.0: @3780a020 00000000 00000000 00000000 00000000
[  157.152396] xhci_hcd 0000:05:00.0: @3780a030 00000000 00000000 00000000 00000000
[  157.152399] xhci_hcd 0000:05:00.0: @3780a040 00000000 00000000 00000000 00000000
[  157.152402] xhci_hcd 0000:05:00.0: @3780a050 00000000 00000000 00000000 00000000
[  157.152405] xhci_hcd 0000:05:00.0: @3780a060 00000000 00000000 00000000 00000000
[  157.152408] xhci_hcd 0000:05:00.0: @3780a070 00000000 00000000 00000000 00000000
[  157.152411] xhci_hcd 0000:05:00.0: @3780a080 00000000 00000000 00000000 00000000
[  157.152413] xhci_hcd 0000:05:00.0: @3780a090 00000000 00000000 00000000 00000000
[  157.152416] xhci_hcd 0000:05:00.0: @3780a0a0 00000000 00000000 00000000 00000000
[  157.152419] xhci_hcd 0000:05:00.0: @3780a0b0 00000000 00000000 00000000 00000000
[  157.152422] xhci_hcd 0000:05:00.0: @3780a0c0 00000000 00000000 00000000 00000000
[  157.152425] xhci_hcd 0000:05:00.0: @3780a0d0 00000000 00000000 00000000 00000000
[  157.152428] xhci_hcd 0000:05:00.0: @3780a0e0 00000000 00000000 00000000 00000000
[  157.152430] xhci_hcd 0000:05:00.0: @3780a0f0 00000000 00000000 00000000 00000000
[  157.152433] xhci_hcd 0000:05:00.0: @3780a100 00000000 00000000 00000000 00000000
[  157.152436] xhci_hcd 0000:05:00.0: @3780a110 00000000 00000000 00000000 00000000
[  157.152439] xhci_hcd 0000:05:00.0: @3780a120 00000000 00000000 00000000 00000000
[  157.152442] xhci_hcd 0000:05:00.0: @3780a130 00000000 00000000 00000000 00000000
[  157.152445] xhci_hcd 0000:05:00.0: @3780a140 00000000 00000000 00000000 00000000
[  157.152448] xhci_hcd 0000:05:00.0: @3780a150 00000000 00000000 00000000 00000000
[  157.152450] xhci_hcd 0000:05:00.0: @3780a160 00000000 00000000 00000000 00000000
[  157.152453] xhci_hcd 0000:05:00.0: @3780a170 00000000 00000000 00000000 00000000
[  157.152456] xhci_hcd 0000:05:00.0: @3780a180 00000000 00000000 00000000 00000000
[  157.152459] xhci_hcd 0000:05:00.0: @3780a190 00000000 00000000 00000000 00000000
[  157.152462] xhci_hcd 0000:05:00.0: @3780a1a0 00000000 00000000 00000000 00000000
[  157.152465] xhci_hcd 0000:05:00.0: @3780a1b0 00000000 00000000 00000000 00000000
[  157.152467] xhci_hcd 0000:05:00.0: @3780a1c0 00000000 00000000 00000000 00000000
[  157.152470] xhci_hcd 0000:05:00.0: @3780a1d0 00000000 00000000 00000000 00000000
[  157.152473] xhci_hcd 0000:05:00.0: @3780a1e0 00000000 00000000 00000000 00000000
[  157.152476] xhci_hcd 0000:05:00.0: @3780a1f0 00000000 00000000 00000000 00000000
[  157.152479] xhci_hcd 0000:05:00.0: @3780a200 00000000 00000000 00000000 00000000
[  157.152482] xhci_hcd 0000:05:00.0: @3780a210 00000000 00000000 00000000 00000000
[  157.152485] xhci_hcd 0000:05:00.0: @3780a220 00000000 00000000 00000000 00000000
[  157.152487] xhci_hcd 0000:05:00.0: @3780a230 00000000 00000000 00000000 00000000
[  157.152490] xhci_hcd 0000:05:00.0: @3780a240 00000000 00000000 00000000 00000000
[  157.152493] xhci_hcd 0000:05:00.0: @3780a250 00000000 00000000 00000000 00000000
[  157.152496] xhci_hcd 0000:05:00.0: @3780a260 00000000 00000000 00000000 00000000
[  157.152499] xhci_hcd 0000:05:00.0: @3780a270 00000000 00000000 00000000 00000000
[  157.152502] xhci_hcd 0000:05:00.0: @3780a280 00000000 00000000 00000000 00000000
[  157.152505] xhci_hcd 0000:05:00.0: @3780a290 00000000 00000000 00000000 00000000
[  157.152507] xhci_hcd 0000:05:00.0: @3780a2a0 00000000 00000000 00000000 00000000
[  157.152510] xhci_hcd 0000:05:00.0: @3780a2b0 00000000 00000000 00000000 00000000
[  157.152513] xhci_hcd 0000:05:00.0: @3780a2c0 00000000 00000000 00000000 00000000
[  157.152516] xhci_hcd 0000:05:00.0: @3780a2d0 00000000 00000000 00000000 00000000
[  157.152519] xhci_hcd 0000:05:00.0: @3780a2e0 00000000 00000000 00000000 00000000
[  157.152522] xhci_hcd 0000:05:00.0: @3780a2f0 00000000 00000000 00000000 00000000
[  157.152525] xhci_hcd 0000:05:00.0: @3780a300 00000000 00000000 00000000 00000000
[  157.152527] xhci_hcd 0000:05:00.0: @3780a310 00000000 00000000 00000000 00000000
[  157.152530] xhci_hcd 0000:05:00.0: @3780a320 00000000 00000000 00000000 00000000
[  157.152533] xhci_hcd 0000:05:00.0: @3780a330 00000000 00000000 00000000 00000000
[  157.152536] xhci_hcd 0000:05:00.0: @3780a340 00000000 00000000 00000000 00000000
[  157.152539] xhci_hcd 0000:05:00.0: @3780a350 00000000 00000000 00000000 00000000
[  157.152542] xhci_hcd 0000:05:00.0: @3780a360 00000000 00000000 00000000 00000000
[  157.152545] xhci_hcd 0000:05:00.0: @3780a370 00000000 00000000 00000000 00000000
[  157.152548] xhci_hcd 0000:05:00.0: @3780a380 00000000 00000000 00000000 00000000
[  157.152551] xhci_hcd 0000:05:00.0: @3780a390 00000000 00000000 00000000 00000000
[  157.152553] xhci_hcd 0000:05:00.0: @3780a3a0 00000000 00000000 00000000 00000000
[  157.152556] xhci_hcd 0000:05:00.0: @3780a3b0 00000000 00000000 00000000 00000000
[  157.152559] xhci_hcd 0000:05:00.0: @3780a3c0 00000000 00000000 00000000 00000000
[  157.152562] xhci_hcd 0000:05:00.0: @3780a3d0 00000000 00000000 00000000 00000000
[  157.152565] xhci_hcd 0000:05:00.0: @3780a3e0 00000000 00000000 00000000 00000000
[  157.152568] xhci_hcd 0000:05:00.0: @3780a3f0 3780a000 00000000 00000000 00001802
[  157.152571] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780a010 (virt), 0x3780a010 (dma)
[  157.152573] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  157.152576] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780a010 (virt), 0x3780a010 (dma)
[  157.152579] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  157.152587] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  157.152589] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000

--OwLcNYc0lM97+oe1--
