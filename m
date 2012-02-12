Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2BLLiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 06:38:01 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:58985 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2BLLh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 06:37:56 -0500
Date: Sun, 12 Feb 2012 12:37:43 +0100
From: Tomas Janousek <tomi@nomi.cz>
To: Szymon Janc <szymon@janc.net.pl>
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth:
 Increase HCI reset timeout ...)
Message-ID: <20120212113743.GA14271@notes.lisk.in>
References: <20111118184017.GA5052@nomi.cz>
 <201112232143.20937.szymon@janc.net.pl>
 <20111223204849.GA23712@nomi.cz>
 <201112282021.04658.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201112282021.04658.szymon@janc.net.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On Wed, Dec 28, 2011 at 08:21:04PM +0100, Szymon Janc wrote:
> We need to figure out why command complete event to reset command is not 
> received and we get timeout for your bt chip.
> 
> So first please provide kernel debug logs and hcidump while resuming (with 
> timeout set to 10s). Also for kernel logs please make sure you have kernel 
> prints timestamps enabled.
> 
> hcidump -t
> 
> kernel:
> echo "module bluetooth +pf" >/sys/kernel/debug/dynamic_debug/control
> echo "module btusb +pf" >/sys/kernel/debug/dynamic_debug/control

I'm attaching dmesg and hcidump output.

I'm sorry for the delay, I did not have a kernel with dynamic_debug enabled
and I didn't have time to reboot and lose my open terminals. Now I updated to
today's kernel snapshot and enabled debugging, so as long as I don't have to
reboot, I should be able to react quickly. :-)

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg


[    0.410162] pnp 00:05: [io  0x0061]
[    0.410206] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.410216] pnp 00:06: [io  0x00f0]
[    0.410225] pnp 00:06: [irq 13]
[    0.410270] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.410281] pnp 00:07: [io  0x0070-0x0071]
[    0.410287] pnp 00:07: [irq 8]
[    0.410330] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.410341] pnp 00:08: [io  0x0060]
[    0.410342] pnp 00:08: [io  0x0064]
[    0.410348] pnp 00:08: [irq 1]
[    0.410393] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.410408] pnp 00:09: [irq 12]
[    0.410455] pnp 00:09: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.410507] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.410555] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.411121] pnp: PnP ACPI: found 11 devices
[    0.411178] ACPI: ACPI bus type pnp unregistered
[    0.418388] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
[    0.418467] PCI: max bus depth: 1 pci_try_num: 2
[    0.418520] pci 0000:01:00.0: BAR 6: assigned [mem 0xf1000000-0xf107ffff pref]
[    0.418594] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.418653] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.418715] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf10fffff]
[    0.418779] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.418855] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.418930] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.418995] pci 0000:00:1c.1:   bridge window [mem 0xf3800000-0xf38fffff]
[    0.419066] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.419127] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.419192] pci 0000:00:1c.3:   bridge window [mem 0xf3000000-0xf37fffff]
[    0.419257] pci 0000:00:1c.3:   bridge window [mem 0xf1800000-0xf1ffffff 64bit pref]
[    0.419338] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.419399] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.419464] pci 0000:00:1c.4:   bridge window [mem 0xf2800000-0xf2ffffff]
[    0.419530] pci 0000:00:1c.4:   bridge window [mem 0xf2000000-0xf27fffff 64bit pref]
[    0.419651] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.419653] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.419655] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.419656] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfebfffff]
[    0.419658] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.419659] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.419661] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf10fffff]
[    0.419662] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.419664] pci_bus 0000:03: resource 1 [mem 0xf3800000-0xf38fffff]
[    0.419666] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.419667] pci_bus 0000:05: resource 1 [mem 0xf3000000-0xf37fffff]
[    0.419669] pci_bus 0000:05: resource 2 [mem 0xf1800000-0xf1ffffff 64bit pref]
[    0.419671] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.419672] pci_bus 0000:0d: resource 1 [mem 0xf2800000-0xf2ffffff]
[    0.419674] pci_bus 0000:0d: resource 2 [mem 0xf2000000-0xf27fffff 64bit pref]
[    0.419696] NET: Registered protocol family 2
[    0.419794] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.420980] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.421618] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.421802] TCP: Hash tables configured (established 262144 bind 65536)
[    0.421863] TCP reno registered
[    0.421920] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.422001] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.422134] NET: Registered protocol family 1
[    0.422203] pci 0000:00:02.0: Boot video device
[    0.422370] PCI: CLS 64 bytes, default 64
[    0.422405] DMAR: No ATSR found
[    0.422484] IOMMU 0 0xfed90000: using Queued invalidation
[    0.422543] IOMMU 1 0xfed91000: using Queued invalidation
[    0.422603] IOMMU: Setting RMRR:
[    0.422668] IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbf9fffff]
[    0.423119] IOMMU: Setting identity map for device 0000:00:1d.0 [0xba8d5000 - 0xba8ebfff]
[    0.423212] IOMMU: Setting identity map for device 0000:00:1a.0 [0xba8d5000 - 0xba8ebfff]
[    0.423296] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.423362] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.423753] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.425742] audit: initializing netlink socket (disabled)
[    0.425808] type=2000 audit(1329047760.269:1): initialized
[    0.450590] msgmni has been set to 15837
[    0.450844] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.450919] io scheduler noop registered
[    0.450975] io scheduler deadline registered
[    0.451110] io scheduler cfq registered (default)
[    0.451262] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    0.451742] intel_idle: MWAIT substates: 0x21120
[    0.451744] intel_idle: v0.4 model 0x2A
[    0.451745] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.451814] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.452120] ACPI: Lid Switch [LID]
[    0.452228] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.452305] ACPI: Sleep Button [SLPB]
[    0.452420] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.452495] ACPI: Power Button [PWRF]
[    0.456362] thermal LNXTHERM:00: registered as thermal_zone0
[    0.456422] ACPI: Thermal Zone [THM0] (55 C)
[    0.456571] GHES: HEST is not enabled!
[    0.457605] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.458140] Linux agpgart interface v0.103
[    0.458728] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.458893] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.459997] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.460191] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.460329] [drm] Initialized drm 1.1.0 20060810
[    0.460418] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.460481] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.460546] i915 0000:00:02.0: setting latency timer to 64
[    0.511243] mtrr: no more MTRRs available
[    0.511301] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.511861] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    0.511868] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.511930] [drm] Driver supports precise vblank timestamp query.
[    0.512162] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    0.512238] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    0.512316] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    0.980414] fbcon: inteldrmfb (fb0) is primary device
[    1.384240] Console: switching to colour frame buffer device 200x56
[    1.387200] fb0: inteldrmfb frame buffer device
[    1.387201] drm: registered panic notifier
[    1.406824] acpi device:01: registered as cooling_device4
[    1.407043] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.407084] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.409714] acpi device:0b: registered as cooling_device5
[    1.409921] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/LNXVIDEO:01/input/input4
[    1.409964] ACPI: Video Device [VID1] (multi-head: yes  rom: yes  post: no)
[    1.410029] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.411478] brd: module loaded
[    1.411497] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.411582] osst :I: Tape driver with OnStream support version 0.99.4
[    1.411583] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.411809] SCSI Media Changer driver v0.25 
[    1.411894] ahci 0000:00:1f.2: version 3.0
[    1.411946] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.411973] ahci: SSS flag set, parallel bus scan disabled
[    1.424540] Refined TSC clocksource calibration: 2491.906 MHz.
[    1.424568] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1f impl SATA mode
[    1.424576] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.424586] ahci 0000:00:1f.2: setting latency timer to 64
[    1.424718] Switching to clocksource tsc
[    1.451735] scsi0 : ahci
[    1.451827] scsi1 : ahci
[    1.451905] scsi2 : ahci
[    1.451983] scsi3 : ahci
[    1.452061] scsi4 : ahci
[    1.452139] scsi5 : ahci
[    1.452945] ata1: SATA max UDMA/133 abar m2048@0xf3928000 port 0xf3928100 irq 44
[    1.454064] ata2: SATA max UDMA/133 abar m2048@0xf3928000 port 0xf3928180 irq 44
[    1.455171] ata3: SATA max UDMA/133 abar m2048@0xf3928000 port 0xf3928200 irq 44
[    1.456267] ata4: SATA max UDMA/133 abar m2048@0xf3928000 port 0xf3928280 irq 44
[    1.457344] ata5: SATA max UDMA/133 abar m2048@0xf3928000 port 0xf3928300 irq 44
[    1.458418] ata6: DUMMY
[    1.459666] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.464076] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.465164] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.466312] mousedev: PS/2 mouse device common for all mice
[    1.467444] rtc_cmos 00:07: RTC can wake from S4
[    1.468602] rtc (null): alarm rollover: day
[    1.468636] rtc_cmos: dev (254:0)
[    1.468642] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.469755] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.470939] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.472061] EDAC MC: Ver: 2.1.0
[    1.473404] cpuidle: using governor ladder
[    1.474558] cpuidle: using governor menu
[    1.475684] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.475712] zram: num_devices not specified. Using default: 1
[    1.475714] zram: Creating 1 devices ...
[    1.476120] TCP bic registered
[    1.476467] NET: Registered protocol family 10
[    1.477023] Mobile IPv6
[    1.477024] IPv6 over IPv4 tunneling driver
[    1.477576] NET: Registered protocol family 17
[    1.477579] lib80211: common routines for IEEE802.11 drivers
[    1.477581] lib80211_crypt: registered algorithm 'NULL'
[    1.477583] Registering the dns_resolver key type
[    1.477771] registered taskstats version 1
[    1.490674] rtc_cmos 00:07: setting system clock to 2012-02-12 11:56:01 UTC (1329047761)
[    1.780479] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.782776] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.782786] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.783937] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.820754] ata1.00: ATA-8: ST9500420AS, 0003LVM1, max UDMA/100
[    1.821865] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.825142] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.825153] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.826276] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.829083] ata1.00: configured for UDMA/100
[    1.830354] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0003 PQ: 0 ANSI: 5
[    1.831743] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.831924] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.833920] sd 0:0:0:0: [sda] Write Protect is off
[    1.834980] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.834991] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.891340]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 >
[    1.893330] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.149637] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.153199] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.153465] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.153476] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.156180] ata2.00: ATAPI: HL-DT-STDVDRAM GT33N, LT20, max UDMA/66
[    2.160148] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.160414] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.160424] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.163156] ata2.00: configured for UDMA/66
[    2.166206] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT33N     LT20 PQ: 0 ANSI: 5
[    2.170473] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.171702] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.173107] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.173284] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.492196] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.493982] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.493986] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.495194] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.496725] ata3.00: ATA-7: INTEL SSDMAEMC080G2, 2CV102M3, max UDMA/133
[    2.497951] ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.499699] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.499715] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.500920] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.502451] ata3.00: configured for UDMA/133
[    2.503831] scsi 2:0:0:0: Direct-Access     ATA      INTEL SSDMAEMC08 2CV1 PQ: 0 ANSI: 5
[    2.505533] sd 2:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.505619] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.508004] sd 2:0:0:0: [sdb] Write Protect is off
[    2.509208] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.509220] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.511169]  sdb: sdb1 sdb2 sdb3
[    2.512792] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.824773] ata4: SATA link down (SStatus 0 SControl 300)
[    3.144047] ata5: SATA link down (SStatus 0 SControl 300)
[    3.145767] EXT3-fs (sdb2): error: couldn't mount because of unsupported optional features (240)
[    3.174358] EXT2-fs (sdb2): error: couldn't mount because of unsupported optional features (240)
[    3.201349] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    3.202596] VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
[    3.204525] Freeing unused kernel memory: 504k freed
[    3.205819] Write protecting the kernel read-only data: 10240k
[    3.210379] Freeing unused kernel memory: 1288k freed
[    3.216322] Freeing unused kernel memory: 1852k freed
[    3.803658] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.808308] Non-volatile memory driver v1.3
[    3.809973] ACPI: AC Adapter [AC] (on-line)
[    3.828255] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    3.830851] ACPI: Battery Slot [BAT0] (battery present)
[    3.834996] wmi: Mapper loaded
[    3.844203] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[    3.874272] sdhci: Secure Digital Host Controller Interface driver
[    3.876559] sdhci: Copyright(c) Pierre Ossman
[    3.884891] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 5)
[    3.887329] Registered led device: mmc0::
[    3.888414] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    3.900077] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    3.902732] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.905662] e1000e 0000:00:19.0: setting latency timer to 64
[    3.905804] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    3.929878] cfg80211: Calling CRDA to update world regulatory domain
[    3.968569] usbcore: registered new interface driver usbfs
[    3.971111] usbcore: registered new interface driver hub
[    3.973484] usbcore: registered new device driver usb
[    3.988193] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.093551] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:cc:63:7c:f4
[    4.095452] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.097430] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    4.099462] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.101613] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.104198] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.104204] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    4.106663] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.109098] ehci_hcd 0000:00:1a.0: debug port 2
[    4.111783] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.114084] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.115284] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    4.116251] thinkpad_acpi: ThinkPad BIOS 83ET67WW (1.37 ), EC unknown
[    4.117139] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf392a000
[    4.120551] thinkpad_acpi: Lenovo ThinkPad T420, model 4178A3G
[    4.125083] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.125951] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.126161] thinkpad_acpi: radio switch found; radios are enabled
[    4.131389] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.133407] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.135343] usb usb1: Product: EHCI Host Controller
[    4.137199] usb usb1: Manufacturer: Linux 3.3.0-rc3-lis64+ ehci_hcd
[    4.139081] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    4.139957] Registered led device: tpacpi::thinklight
[    4.140000] Registered led device: tpacpi::power
[    4.140015] Registered led device: tpacpi::standby
[    4.140033] Registered led device: tpacpi::thinkvantage
[    4.140044] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    4.140200] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.142097] nvidia: module license 'NVIDIA' taints kernel.
[    4.142099] Disabling lock debugging due to kernel taint
[    4.148325] usb usb1: SerialNumber: 0000:00:1a.0
[    4.150186] hub 1-0:1.0: USB hub found
[    4.153037] hub 1-0:1.0: 3 ports detected
[    4.154780] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.156370] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.157934] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.157939] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    4.159409] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.160971] ehci_hcd 0000:00:1d.0: debug port 2
[    4.163066] nvidia 0000:01:00.0: power state changed by ACPI to D0
[    4.164608] nvidia 0000:01:00.0: power state changed by ACPI to D0
[    4.166018] nvidia 0000:01:00.0: enabling device (0000 -> 0003)
[    4.166371] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    4.167137] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf3929000
[    4.168708] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[    4.170066] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    4.170358] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  290.10  Wed Nov 16 17:39:29 PST 2011
[    4.174953] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.176264] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.177574] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.178834] usb usb2: Product: EHCI Host Controller
[    4.180191] usb usb2: Manufacturer: Linux 3.3.0-rc3-lis64+ ehci_hcd
[    4.181336] usb usb2: SerialNumber: 0000:00:1d.0
[    4.182569] hub 2-0:1.0: USB hub found
[    4.183999] hub 2-0:1.0: 3 ports detected
[    4.194191] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.218086] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[    4.219591] Copyright(c) 2003-2011 Intel Corporation
[    4.221230] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    4.222744] iwlwifi 0000:03:00.0: pci_resource_base = ffffc90004084000
[    4.223959] iwlwifi 0000:03:00.0: HW Revision ID = 0x34
[    4.225466] iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
[    4.225624] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    4.227027] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    4.228470] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    4.229915] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[    4.231313] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    4.232693] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    4.233939] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    4.245981] iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[    4.247464] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[    4.247923] hda_codec: CX20590: BIOS auto-probing.
[    4.250379] iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    4.251915] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.253990] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    4.296243] iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.3 build 42301
[    4.297845] Registered led device: phy0-led
[    4.304544] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.335046] udevd[885]: renamed network interface wlan0 to wlan1
[    4.460993] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    4.584414] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.585747] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.587184] hub 1-1:1.0: USB hub found
[    4.588654] hub 1-1:1.0: 6 ports detected
[    4.697116] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    4.730808] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000
[    4.731968] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    4.783725] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
[    4.820594] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    4.821775] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.823106] hub 2-1:1.0: USB hub found
[    4.824324] hub 2-1:1.0: 8 ports detected
[    4.893658] usb 1-1.4: new full-speed USB device number 3 using ehci_hcd
[    4.981708] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[    4.982867] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.984005] usb 1-1.4: Product: Broadcom Bluetooth Device
[    4.985124] usb 1-1.4: Manufacturer: Broadcom Corp
[    4.986240] usb 1-1.4: SerialNumber: CCAF78EC8B4F
[    5.035073] Bluetooth: Core ver 2.16
[    5.036193] NET: Registered protocol family 31
[    5.037305] Bluetooth: HCI device and connection manager initialized
[    5.038388] Bluetooth: HCI socket layer initialized
[    5.039455] Bluetooth: L2CAP socket layer initialized
[    5.040610] Bluetooth: SCO socket layer initialized
[    5.045288] usbcore: registered new interface driver btusb
[    5.053097] usb 1-1.6: new high-speed USB device number 4 using ehci_hcd
[    5.143392] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b221
[    5.144868] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.144872] usb 1-1.6: Product: Integrated Camera
[    5.144874] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    5.186116] Linux video capture interface: v2.00
[    5.189174] EXT4-fs (sdb2): re-mounted. Opts: (null)
[    5.209801] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b221)
[    5.211730] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
[    5.211779] usbcore: registered new interface driver uvcvideo
[    5.211781] USB Video Class driver (1.1.1)
[    5.224713] EXT4-fs (sdb2): re-mounted. Opts: errors=remount-ro,discard
[    5.304817] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.344586] Netfilter messages via NETLINK v0.30.
[    5.349249] ctnetlink v0.93: registering with nfnetlink.
[    5.366248] Bluetooth: RFCOMM TTY layer initialized
[    5.367124] Bluetooth: RFCOMM socket layer initialized
[    5.367968] Bluetooth: RFCOMM ver 1.11
[    5.397518] fuse init (API version 7.18)
[    5.404400] tun: Universal TUN/TAP device driver, 1.6
[    5.405297] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.410329] bbswitch: Found integrated VGA device 0000:00:02.0: \_SB_.PCI0.VID_
[    5.411535] bbswitch: Found discrete VGA device 0000:01:00.0: \_SB_.PCI0.PEG_.VID_
[    5.414033] bbswitch: detected an Optimus _DSM function
[    5.415211] bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is on
[    6.913854] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: errors=remount-ro,discard
[    6.930620] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    7.700961] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.834834] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.585087] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    8.586094] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    8.875564] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    8.878506] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    9.004689] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[    9.512876] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[    9.650957] type=1400 audit(1329044169.688:2): apparmor="STATUS" operation="profile_load" name="/sbin/klogd" pid=2980 comm="apparmor_parser"
[    9.660489] type=1400 audit(1329044169.698:3): apparmor="STATUS" operation="profile_load" name="/sbin/syslog-ng" pid=2981 comm="apparmor_parser"
[    9.664209] type=1400 audit(1329044169.701:4): apparmor="STATUS" operation="profile_load" name="/bin/ping" pid=2977 comm="apparmor_parser"
[    9.670781] type=1400 audit(1329044169.708:5): apparmor="STATUS" operation="profile_load" name="/sbin/syslogd" pid=2982 comm="apparmor_parser"
[    9.674194] type=1400 audit(1329044169.711:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/deliver" pid=2984 comm="apparmor_parser"
[    9.678693] type=1400 audit(1329044169.714:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/dovecot-auth" pid=2985 comm="apparmor_parser"
[    9.682702] type=1400 audit(1329044169.721:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/imap" pid=2986 comm="apparmor_parser"
[    9.686630] type=1400 audit(1329044169.724:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/imap-login" pid=2987 comm="apparmor_parser"
[    9.690319] type=1400 audit(1329044169.728:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/managesieve-login" pid=2988 comm="apparmor_parser"
[    9.694297] type=1400 audit(1329044169.731:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/pop3" pid=2989 comm="apparmor_parser"
[   10.960408] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.220782] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input10
[   12.262047] wlan1: authenticate with 00:15:f2:6a:e1:83 (try 1)
[   12.263882] wlan1: authenticated
[   12.264233] wlan1: associate with 00:15:f2:6a:e1:83 (try 1)
[   12.266882] wlan1: RX AssocResp from 00:15:f2:6a:e1:83 (capab=0x411 status=0 aid=2)
[   12.266885] wlan1: associated
[   12.266887] wlan1: moving STA 00:15:f2:6a:e1:83 to state 1
[   12.266888] wlan1: moving STA 00:15:f2:6a:e1:83 to state 2
[   12.266889] wlan1: moving STA 00:15:f2:6a:e1:83 to state 3
[   12.273085] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   13.401315] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   13.453952] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   13.454632] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.517115] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[   14.255213] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.255217] Bluetooth: BNEP filters: protocol multicast
[   14.263837] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   14.275405] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   14.275472] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   14.275478] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   14.275490] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   15.081342] Ebtables v2.0 registered
[   20.557818] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[   39.532696] bbswitch: disabling discrete graphics
[   39.535802] bbswitch: Result of Optimus _DSM call: 11000059
[   39.548048] pci_raw_set_power_state: 75 callbacks suppressed
[   39.548060] pci 0000:01:00.0: Refused to change power state, currently in D0
[   39.550215] thinkpad_acpi: EC reports that Thermal Table has changed
[   39.658718] pci 0000:01:00.0: power state changed by ACPI to D3
[  111.052848] thinkpad_acpi: EC reports that Thermal Table has changed
[  111.053049] nvidia 0000:01:00.0: power state changed by ACPI to D0
[  111.053066] nvidia 0000:01:00.0: power state changed by ACPI to D0
[  111.053078] nvidia 0000:01:00.0: enabling device (0000 -> 0003)
[  111.053108] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=none,decodes=none:owns=none
[  111.053425] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  290.10  Wed Nov 16 17:39:29 PST 2011
[  135.452821] nvidia 0000:01:00.0: power state changed by ACPI to D0
[  135.452826] nvidia 0000:01:00.0: power state changed by ACPI to D0
[  135.452839] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=none,decodes=none:owns=none
[  135.452932] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  290.10  Wed Nov 16 17:39:29 PST 2011
[  148.561696] bbswitch: disabling discrete graphics
[  148.563934] bbswitch: Result of Optimus _DSM call: 11000059
[  148.577310] pci 0000:01:00.0: Refused to change power state, currently in D0
[  148.579547] thinkpad_acpi: EC reports that Thermal Table has changed
[  148.687931] pci 0000:01:00.0: power state changed by ACPI to D3
[  179.707245] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
[  179.707255] thinkpad_acpi: unhandled HKEY event 0x6040
[  179.707261] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
[  321.282097] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  321.295308] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  321.295441] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  321.295452] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  321.295476] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  321.438672] usb 1-1.4: USB disconnect, device number 3
[  335.765839] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 1189.342652] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
[ 1189.342663] thinkpad_acpi: unhandled HKEY event 0x6040
[ 1189.342668] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
[ 1920.283222] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1920.296382] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1920.296516] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1920.296527] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1920.296551] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1920.506264] usb 1-1.4: new full-speed USB device number 5 using ehci_hcd
[ 1920.598006] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[ 1920.598016] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1920.598022] usb 1-1.4: Product: Broadcom Bluetooth Device
[ 1920.598027] usb 1-1.4: Manufacturer: Broadcom Corp
[ 1920.598031] usb 1-1.4: SerialNumber: CCAF78EC8B4F
[ 1927.167449] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 1927.646045] wlan1: deauthenticating from 00:15:f2:6a:e1:83 by local choice (reason=3)
[ 1927.693132] wlan1: moving STA 00:15:f2:6a:e1:83 to state 2
[ 1927.696374] wlan1: moving STA 00:15:f2:6a:e1:83 to state 1
[ 1927.699586] wlan1: moving STA 00:15:f2:6a:e1:83 to state 0
[ 1927.719719] cfg80211: Calling CRDA to update world regulatory domain
[ 1928.110984] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 1928.114155] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 1928.245673] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1928.743449] PM: Syncing filesystems ... done.
[ 1928.768066] bbswitch: enabling discrete graphics
[ 1929.013628] pci 0000:01:00.0: power state changed by ACPI to D0
[ 1929.013667] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1929.013804] pci 0000:01:00.0: power state changed by ACPI to D0
[ 1929.013964] pci 0000:01:00.0: power state changed by ACPI to D0
[ 1929.014043] pci 0000:01:00.0: power state changed by ACPI to D0
[ 1929.014130] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1929.026774] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1929.053474] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[ 1929.329723] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1929.342563] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1929.342781] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1929.342866] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1929.342964] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1929.343071] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1929.355870] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1929.356097] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1929.356182] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1929.356280] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1929.537762] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1929.537992] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1929.538006] sd 2:0:0:0: [sdb] Stopping disk
[ 1929.778275] rtc0: suspend, ctrl 02
[ 1929.791653] i915 0000:00:02.0: power state changed by ACPI to D3
[ 1929.990440] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1932.349365] sd 0:0:0:0: [sda] Stopping disk
[ 1932.738231] PM: suspend of devices complete after 3389.375 msecs
[ 1932.751735] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[ 1932.764797] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[ 1932.765008] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[ 1932.778101] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 1932.778307] PM: late suspend of devices complete after 40.075 msecs
[ 1932.779039] ACPI: Preparing to enter system sleep state S3
[ 1932.834584] thinkpad_acpi: fan watchdog: enabling fan
[ 1932.944502] PM: Saving platform NVS memory
[ 1932.954752] Disabling non-boot CPUs ...
[ 1933.057438] CPU 1 is now offline
[ 1933.160491] CPU 2 is now offline
[ 1933.161981] Broke affinity for irq 23
[ 1933.263601] CPU 3 is now offline
[ 1933.264300] Extended CMOS year: 2000
[ 1933.265398] ACPI: Low-level resume complete
[ 1933.265513] PM: Restoring platform NVS memory
[ 1933.266433] Extended CMOS year: 2000
[ 1933.266487] Enabling non-boot CPUs ...
[ 1933.266566] Booting Node 0 Processor 1 APIC 0x1
[ 1933.266588] smpboot cpu 1: start_ip = 98000
[ 1933.277709] Disabled fast string operations
[ 1933.277732] Calibrating delay loop (skipped) already calibrated this CPU
[ 1933.348972] CPU1 is up
[ 1933.350370] Booting Node 0 Processor 2 APIC 0x2
[ 1933.350433] smpboot cpu 2: start_ip = 98000
[ 1933.361855] Disabled fast string operations
[ 1933.361875] Calibrating delay loop (skipped) already calibrated this CPU
[ 1933.442067] CPU2 is up
[ 1933.442558] Booting Node 0 Processor 3 APIC 0x3
[ 1933.445094] smpboot cpu 3: start_ip = 98000
[ 1933.459081] Disabled fast string operations
[ 1933.459100] Calibrating delay loop (skipped) already calibrated this CPU
[ 1933.532149] CPU3 is up
[ 1933.543572] ACPI: Waking up from system sleep state S3
[ 1933.831658] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[ 1933.834296] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1933.836934] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1933.840108] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[ 1933.842631] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1933.845212] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1933.847128] PM: early resume of devices complete after 15.948 msecs
[ 1933.848210] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1933.848217] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1933.852572] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1933.855340] ahci 0000:00:1f.2: setting latency timer to 64
[ 1933.855493] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[ 1933.855510] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 1933.855560] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1933.855608] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1933.855625] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1933.855633] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1933.855692] i915 0000:00:02.0: power state changed by ACPI to D0
[ 1933.855696] i915 0000:00:02.0: power state changed by ACPI to D0
[ 1933.855699] i915 0000:00:02.0: setting latency timer to 64
[ 1933.869928] rtc0: resume, ctrl 02
[ 1934.094153] usb 1-1.4: reset full-speed USB device number 5 using ehci_hcd
[ 1934.182456] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[ 1934.184760] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[ 1934.196929] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1934.201374] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[ 1934.203673] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1934.204842] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[ 1934.205778] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1934.206973] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1934.207909] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1934.208842] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1934.210170] ata5: SATA link down (SStatus 0 SControl 300)
[ 1934.211409] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1934.212413] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1934.213399] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1934.214931] ata3.00: configured for UDMA/133
[ 1934.215951] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[ 1934.217007] ata4: SATA link down (SStatus 0 SControl 300)
[ 1934.218052] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[ 1934.219048] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1934.221508] ata2.00: configured for UDMA/66
[ 1934.226955] sd 2:0:0:0: [sdb] Starting disk
[ 1934.247014] usb 1-1.6: reset high-speed USB device number 4 using ehci_hcd
[ 1936.192450] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1936.421917] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1936.424970] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1936.428043] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1936.434991] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1936.438015] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1936.441049] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1936.445801] ata1.00: configured for UDMA/100
[ 1936.462004] sd 0:0:0:0: [sda] Starting disk
[ 1936.462866] Extended CMOS year: 2000
[ 1936.494858] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 1936.498072] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 1944.164810] PM: resume of devices complete after 10340.134 msecs
[ 1944.169055] Restarting tasks ... done.
[ 1944.180785] video LNXVIDEO:00: Restoring backlight state
[ 1944.187002] video LNXVIDEO:01: Restoring backlight state
[ 1944.195519] bbswitch: disabling discrete graphics
[ 1944.197927] bbswitch: Result of Optimus _DSM call: 11000059
[ 1944.211937] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1944.324749] pci 0000:01:00.0: power state changed by ACPI to D3
[ 1948.201824] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[ 1950.310387] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 1972.181432] wlan1: authenticate with 00:15:f2:6a:e1:83 (try 1)
[ 1972.184245] wlan1: authenticated
[ 1972.184561] wlan1: associate with 00:15:f2:6a:e1:83 (try 1)
[ 1972.187313] wlan1: RX AssocResp from 00:15:f2:6a:e1:83 (capab=0x411 status=0 aid=2)
[ 1972.187324] wlan1: associated
[ 1972.187335] wlan1: moving STA 00:15:f2:6a:e1:83 to state 1
[ 1972.187342] wlan1: moving STA 00:15:f2:6a:e1:83 to state 2
[ 1972.187349] wlan1: moving STA 00:15:f2:6a:e1:83 to state 3
[ 1972.191640] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[ 2052.767137] hci_sock_create: sock ffff88020419f700
[ 2052.767162] hci_sock_bind: sock ffff88020419f700 sk ffff88022eb46400
[ 2052.767169] hci_dev_get: 0
[ 2052.767178] hci_sock_create: sock ffff88020419fc00
[ 2052.767192] hci_sock_ioctl: cmd 800448d3 arg ff9e8e88
[ 2052.767198] hci_dev_get: 0
[ 2052.767208] hci_sock_release: sock ffff88020419fc00 sk ffff88022eb43400
[ 2052.767224] hci_sock_ioctl: cmd 400448dc arg 0
[ 2052.767232] hci_sock_release: sock ffff88020419f700 sk ffff88022eb46400
[ 2052.767242] hci_sock_create: sock ffff88020419f700
[ 2052.767253] hci_sock_setsockopt: sk ffff88022eb46400, opt 1
[ 2052.767258] hci_sock_setsockopt: sk ffff88022eb46400, opt 3
[ 2052.767264] hci_sock_setsockopt: sk ffff88022eb46400, opt 2
[ 2052.767271] hci_sock_bind: sock ffff88020419f700 sk ffff88022eb46400
[ 2052.767275] hci_dev_get: 0
[ 2060.775615] hci_sock_release: sock ffff88020419f700 sk ffff88022eb46400
[ 2064.687621] hci_sock_create: sock ffff8801e2314a00
[ 2064.687646] hci_sock_bind: sock ffff8801e2314a00 sk ffff8802126a0400
[ 2064.687653] hci_dev_get: 0
[ 2064.687662] hci_sock_create: sock ffff8801e2317200
[ 2064.687676] hci_sock_ioctl: cmd 800448d3 arg ffe0ffc8
[ 2064.687681] hci_dev_get: 0
[ 2064.687693] hci_sock_release: sock ffff8801e2317200 sk ffff8802126a7c00
[ 2064.687708] hci_sock_ioctl: cmd 400448dc arg 0
[ 2064.687716] hci_sock_release: sock ffff8801e2314a00 sk ffff8802126a0400
[ 2064.687726] hci_sock_create: sock ffff8801e2314a00
[ 2064.687737] hci_sock_setsockopt: sk ffff8802126a0400, opt 1
[ 2064.687743] hci_sock_setsockopt: sk ffff8802126a0400, opt 3
[ 2064.687748] hci_sock_setsockopt: sk ffff8802126a0400, opt 2
[ 2064.687755] hci_sock_bind: sock ffff8801e2314a00 sk ffff8802126a0400
[ 2064.687760] hci_dev_get: 0
[ 2082.122820] wlan1: deauthenticating from 00:15:f2:6a:e1:83 by local choice (reason=3)
[ 2082.180778] wlan1: moving STA 00:15:f2:6a:e1:83 to state 2
[ 2082.183646] wlan1: moving STA 00:15:f2:6a:e1:83 to state 1
[ 2082.186472] wlan1: moving STA 00:15:f2:6a:e1:83 to state 0
[ 2082.220672] cfg80211: Calling CRDA to update world regulatory domain
[ 2082.471453] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 2082.472588] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 2082.598214] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 2083.155959] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2083.158709] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2083.161540] bt_sock_poll: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2083.161545] bt_sock_poll: sock ffff8801e2315400, sk ffff880212423400
[ 2083.161549] bt_sock_poll: sock ffff8801e2316800, sk ffff8802315f6000
[ 2083.161554] bt_sock_poll: sock ffff8801e2317980, sk ffff8802126a6400
[ 2083.161559] bt_sock_poll: sock ffff8801e2316f80, sk ffff8802126a4800
[ 2083.161563] bt_sock_poll: sock ffff8801e2315680, sk ffff8802126a1400
[ 2083.161567] bt_sock_poll: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2083.161572] bt_sock_poll: sock ffff8801e2314000, sk ffff8802126a1000
[ 2083.161624] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2083.161632] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2083.161639] bt_sock_poll: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2083.161645] bt_sock_poll: sock ffff8801e2315400, sk ffff880212423400
[ 2083.161651] bt_sock_poll: sock ffff8801e2316800, sk ffff8802315f6000
[ 2083.161657] bt_sock_poll: sock ffff8801e2317980, sk ffff8802126a6400
[ 2083.161665] bt_sock_poll: sock ffff8801e2316f80, sk ffff8802126a4800
[ 2083.161671] bt_sock_poll: sock ffff8801e2315680, sk ffff8802126a1400
[ 2083.161677] bt_sock_poll: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2083.161683] bt_sock_poll: sock ffff8801e2314000, sk ffff8802126a1000
[ 2083.208514] hpet1: lost 1 rtc interrupts
[ 2083.239292] PM: Syncing filesystems ... done.
[ 2083.263599] bbswitch: enabling discrete graphics
[ 2083.510302] pci 0000:01:00.0: power state changed by ACPI to D0
[ 2083.513328] pci 0000:01:00.0: power state changed by ACPI to D0
[ 2083.516571] thinkpad_acpi: EC reports that Thermal Table has changed
[ 2083.516955] pci 0000:01:00.0: power state changed by ACPI to D0
[ 2083.516972] pci 0000:01:00.0: power state changed by ACPI to D0
[ 2083.516993] Freezing user space processes ... 
[ 2083.517169] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2083.517182] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2083.517191] bt_sock_poll: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2083.517197] bt_sock_poll: sock ffff8801e2315400, sk ffff880212423400
[ 2083.517203] bt_sock_poll: sock ffff8801e2316800, sk ffff8802315f6000
[ 2083.517210] bt_sock_poll: sock ffff8801e2317980, sk ffff8802126a6400
[ 2083.517216] bt_sock_poll: sock ffff8801e2316f80, sk ffff8802126a4800
[ 2083.517223] bt_sock_poll: sock ffff8801e2315680, sk ffff8802126a1400
[ 2083.517229] bt_sock_poll: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2083.517236] bt_sock_poll: sock ffff8801e2314000, sk ffff8802126a1000
[ 2083.557716] hpet1: lost 2 rtc interrupts
[ 2083.570144] (elapsed 0.05 seconds) done.
[ 2083.572876] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 2083.596876] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 2083.879901] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2083.892508] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2083.895399] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2083.898168] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2083.900836] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 2083.903498] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2083.919169] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2083.921889] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2083.924449] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2083.926946] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[ 2084.042803] btusb_resume: intf ffff880212424800
[ 2084.045285] btusb_resume: intf ffff880212427400
[ 2084.047729] btusb_submit_intr_urb: hci0
[ 2084.050245] btusb_submit_bulk_urb: hci0
[ 2084.052773] btusb_submit_bulk_urb: hci0
[ 2084.055120] btusb_suspend: intf ffff880212427400
[ 2084.057469] btusb_intr_complete: hci0 urb ffff8802129819c0 status -2 count 0
[ 2084.059889] btusb_bulk_complete: hci0 urb ffff880212981b40 status -2 count 0
[ 2084.062387] btusb_bulk_complete: hci0 urb ffff880212981480 status -2 count 0
[ 2084.064704] btusb_suspend: intf ffff880212424800
[ 2084.103643] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 2084.103712] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2084.108311] sd 2:0:0:0: [sdb] Stopping disk
[ 2084.341292] rtc0: suspend, ctrl 02
[ 2084.361188] i915 0000:00:02.0: power state changed by ACPI to D3
[ 2084.556608] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 2086.013269] thinkpad_acpi: fan watchdog: enabling fan
[ 2086.927828] sd 0:0:0:0: [sda] Stopping disk
[ 2087.329704] PM: suspend of devices complete after 3409.524 msecs
[ 2087.343186] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[ 2087.356251] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[ 2087.358790] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[ 2087.372865] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 2087.375083] PM: late suspend of devices complete after 43.448 msecs
[ 2087.377805] ACPI: Preparing to enter system sleep state S3
[ 2087.529197] PM: Saving platform NVS memory
[ 2087.542316] Disabling non-boot CPUs ...
[ 2087.546529] CPU 1 is now offline
[ 2087.549917] CPU 2 is now offline
[ 2087.655342] CPU 3 is now offline
[ 2087.657935] Extended CMOS year: 2000
[ 2087.660918] ACPI: Low-level resume complete
[ 2087.663680] PM: Restoring platform NVS memory
[ 2087.667285] Extended CMOS year: 2000
[ 2087.668215] Enabling non-boot CPUs ...
[ 2087.669157] Booting Node 0 Processor 1 APIC 0x1
[ 2087.670055] smpboot cpu 1: start_ip = 98000
[ 2087.682055] Disabled fast string operations
[ 2087.682075] Calibrating delay loop (skipped) already calibrated this CPU
[ 2087.753524] CPU1 is up
[ 2087.803269] Booting Node 0 Processor 2 APIC 0x2
[ 2087.819816] smpboot cpu 2: start_ip = 98000
[ 2087.847278] Disabled fast string operations
[ 2087.847297] Calibrating delay loop (skipped) already calibrated this CPU
[ 2087.923017] CPU2 is up
[ 2087.974127] Booting Node 0 Processor 3 APIC 0x3
[ 2087.976517] smpboot cpu 3: start_ip = 98000
[ 2087.990244] Disabled fast string operations
[ 2087.990262] Calibrating delay loop (skipped) already calibrated this CPU
[ 2088.062709] CPU3 is up
[ 2088.100618] ACPI: Waking up from system sleep state S3
[ 2088.385599] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[ 2088.388187] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2088.390806] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2088.394090] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[ 2088.396697] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2088.399320] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2088.402913] PM: early resume of devices complete after 17.817 msecs
[ 2088.404111] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2088.404117] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 2088.404126] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2088.404204] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[ 2088.404282] ahci 0000:00:1f.2: setting latency timer to 64
[ 2088.404443] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 2088.404844] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2088.404853] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[ 2088.408182] i915 0000:00:02.0: power state changed by ACPI to D0
[ 2088.408187] i915 0000:00:02.0: power state changed by ACPI to D0
[ 2088.408189] i915 0000:00:02.0: setting latency timer to 64
[ 2088.417034] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2088.419269] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 2088.433670] rtc0: resume, ctrl 02
[ 2088.657847] usb 1-1.6: reset high-speed USB device number 4 using ehci_hcd
[ 2088.727412] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2088.730774] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 2088.732539] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 2088.734281] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2088.736673] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 2088.738412] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 2088.740135] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2088.741900] ata5: SATA link down (SStatus 0 SControl 300)
[ 2088.743111] ata3.00: configured for UDMA/133
[ 2088.750625] ata4: SATA link down (SStatus 0 SControl 300)
[ 2088.757407] sd 2:0:0:0: [sdb] Starting disk
[ 2088.813845] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2088.819945] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[ 2088.823312] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[ 2088.826247] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2088.829439] usb 1-1.4: reset full-speed USB device number 5 using ehci_hcd
[ 2088.835864] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[ 2088.839442] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[ 2088.842407] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2088.847004] ata2.00: configured for UDMA/66
[ 2088.916253] btusb 1-1.4:1.0: no reset_resume for driver btusb?
[ 2088.919261] btusb 1-1.4:1.1: no reset_resume for driver btusb?
[ 2088.922244] btusb_disconnect: intf ffff880212424800
[ 2088.925234] hci_unregister_dev: ffff88022e9f4000 name hci0 bus 1
[ 2088.928188] hci_dev_do_close: hci0 ffff88022e9f4000
[ 2088.931149] hci_req_cancel: hci0 err 0x13
[ 2088.934092] inquiry_cache_flush: cache ffff88022e9f4628
[ 2088.937018] hci_conn_hash_flush: hdev hci0
[ 2088.939930] hci_sock_dev_event: hdev hci0 event 4
[ 2088.942846] hci_send_to_sock: hdev           (null) len 8
[ 2088.945789] btusb_flush: hci0
[ 2088.948681] __hci_request: hci0 start
[ 2088.951547] hci_reset_req: hci0 0
[ 2088.954385] hci_send_cmd: hci0 opcode 0xc03 plen 0
[ 2088.957218] hci_send_cmd: skb len 3
[ 2088.960090] hci_cmd_work: hci0 cmd 1
[ 2088.962922] hci_send_frame: hci0 type 1 len 3
[ 2088.965767] hci_send_to_sock: hdev ffff88022e9f4000 len 3
[ 2088.968605] btusb_send_frame: hci0
[ 2090.283131] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2090.500143] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 2090.503082] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 2090.505984] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2090.513146] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 2090.516041] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 2090.518913] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 2090.523448] ata1.00: configured for UDMA/100
[ 2090.539203] sd 0:0:0:0: [sda] Starting disk
[ 2090.540176] Extended CMOS year: 2000
[ 2090.576415] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 2090.579504] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 2098.932516] __hci_request: hci0 end: err -110
[ 2098.935374] btusb_close: hci0
[ 2098.938235] hci_send_to_sock: hdev           (null) len 10
[ 2098.941064] hci_send_to_sock: hdev           (null) len 6
[ 2098.943848] hci_sock_dev_event: hdev hci0 event 2
[ 2098.946598] hci_send_to_sock: hdev           (null) len 8
[ 2098.949451] hci_del_sysfs: ffff88022e9f4000 name hci0 bus 1
[ 2098.952352] hci_adv_entries_clear: hci0 adv cache cleared
[ 2098.955118] btusb_disconnect: intf ffff880212427400
[ 2098.957888] btusb_destruct: hci0
[ 2098.960754] PM: resume of devices complete after 10586.131 msecs
[ 2098.963577] btusb_probe: intf ffff880212424800 id ffffffffa00dd680
[ 2098.966342] hci_register_dev: ffff880231744000 name  bus 1 owner ffffffffa00ddf20
[ 2098.969309] hci_add_sysfs: ffff880231744000 name hci0 bus 1
[ 2098.972294] hci_sock_dev_event: hdev hci0 event 1
[ 2098.973301] hci_send_to_sock: hdev           (null) len 8
[ 2098.974223] hci_rfkill_set_block: ffff880231744000 name hci0 blocked 0
[ 2098.975153] hci_power_on: hci0
[ 2098.976084] hci_dev_get: 0
[ 2098.976713] Restarting tasks ... 
[ 2098.976840] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.976843] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.976846] bt_sock_poll: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2098.976848] bt_sock_poll: sock ffff8801e2315400, sk ffff880212423400
[ 2098.976849] bt_sock_poll: sock ffff8801e2316800, sk ffff8802315f6000
[ 2098.976851] bt_sock_poll: sock ffff8801e2317980, sk ffff8802126a6400
[ 2098.976853] bt_sock_poll: sock ffff8801e2316f80, sk ffff8802126a4800
[ 2098.976855] bt_sock_poll: sock ffff8801e2315680, sk ffff8802126a1400
[ 2098.976856] bt_sock_poll: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2098.976858] bt_sock_poll: sock ffff8801e2314000, sk ffff8802126a1000
[ 2098.976872] hci_sock_recvmsg: sock ffff88023287ea80, sk ffff880233ffcc00
[ 2098.976994] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.976997] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.976999] bt_sock_poll: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2098.977000] bt_sock_poll: sock ffff8801e2315400, sk ffff880212423400
[ 2098.977002] bt_sock_poll: sock ffff8801e2316800, sk ffff8802315f6000
[ 2098.977004] bt_sock_poll: sock ffff8801e2317980, sk ffff8802126a6400
[ 2098.977006] bt_sock_poll: sock ffff8801e2316f80, sk ffff8802126a4800
[ 2098.977008] bt_sock_poll: sock ffff8801e2315680, sk ffff8802126a1400
[ 2098.977009] bt_sock_poll: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2098.977011] bt_sock_poll: sock ffff8801e2314000, sk ffff8802126a1000
[ 2098.977017] hci_sock_recvmsg: sock ffff88023287ea80, sk ffff880233ffcc00
[ 2098.977036] hci_sock_release: sock ffff880233b5c780 sk ffff880233d4a000
[ 2098.977076] hci_sock_create: sock ffff880227ad5180
[ 2098.977083] hci_sock_ioctl: cmd 800448d2 arg f8538d20
[ 2098.977086] hci_sock_release: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2098.977174] bt_accept_dequeue: parent ffff8802126a1000
[ 2098.977184] l2cap_sock_release: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2098.977186] l2cap_sock_shutdown: sock ffff8801e2317c00, sk ffff8802126a2c00
[ 2098.977189] l2cap_chan_close: chan ffff8802126a5800 state 4 socket ffff8801e2317c00
[ 2098.977191] l2cap_chan_cleanup_listen: parent ffff8802126a2c00
[ 2098.977192] bt_accept_dequeue: parent ffff8802126a2c00
[ 2098.977194] l2cap_state_change: ffff8802126a5800 BT_LISTEN -> BT_CLOSED
[ 2098.977197] l2cap_sock_kill: sk ffff8802126a2c00 state 9
[ 2098.977199] l2cap_sock_destruct: sk ffff8802126a2c00
[ 2098.977203] l2cap_sock_release: sock ffff8801e2315680, sk ffff8802126a1400
[ 2098.977205] l2cap_sock_shutdown: sock ffff8801e2315680, sk ffff8802126a1400
[ 2098.977207] l2cap_chan_close: chan ffff8802126a6000 state 4 socket ffff8801e2315680
[ 2098.977209] l2cap_chan_cleanup_listen: parent ffff8802126a1400
[ 2098.977210] bt_accept_dequeue: parent ffff8802126a1400
[ 2098.977212] l2cap_state_change: ffff8802126a6000 BT_LISTEN -> BT_CLOSED
[ 2098.977214] l2cap_sock_kill: sk ffff8802126a1400 state 9
[ 2098.977215] l2cap_sock_destruct: sk ffff8802126a1400
[ 2098.977224] bt_accept_dequeue: parent ffff8802126a6400
[ 2098.977230] bt_accept_dequeue: parent ffff8802126a4800
[ 2098.977234] l2cap_sock_release: sock ffff8801e2316800, sk ffff8802315f6000
[ 2098.977236] l2cap_sock_shutdown: sock ffff8801e2316800, sk ffff8802315f6000
[ 2098.977238] l2cap_chan_close: chan ffff8802315f2800 state 4 socket ffff8801e2316800
[ 2098.977240] l2cap_chan_cleanup_listen: parent ffff8802315f6000
[ 2098.977241] bt_accept_dequeue: parent ffff8802315f6000
[ 2098.977243] l2cap_state_change: ffff8802315f2800 BT_LISTEN -> BT_CLOSED
[ 2098.977244] l2cap_sock_kill: sk ffff8802315f6000 state 9
[ 2098.977246] l2cap_sock_destruct: sk ffff8802315f6000
[ 2098.977249] l2cap_sock_release: sock ffff8801e2315400, sk ffff880212423400
[ 2098.977251] l2cap_sock_shutdown: sock ffff8801e2315400, sk ffff880212423400
[ 2098.977253] l2cap_chan_close: chan ffff8802315f0000 state 4 socket ffff8801e2315400
[ 2098.977255] l2cap_chan_cleanup_listen: parent ffff880212423400
[ 2098.977257] bt_accept_dequeue: parent ffff880212423400
[ 2098.977258] l2cap_state_change: ffff8802315f0000 BT_LISTEN -> BT_CLOSED
[ 2098.977260] l2cap_sock_kill: sk ffff880212423400 state 9
[ 2098.977262] l2cap_sock_destruct: sk ffff880212423400
[ 2098.977270] l2cap_sock_release: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2098.977272] l2cap_sock_shutdown: sock ffff8801e2315b80, sk ffff880233ffc400
[ 2098.977274] l2cap_chan_close: chan ffff880233ffe000 state 4 socket ffff8801e2315b80
[ 2098.977276] l2cap_chan_cleanup_listen: parent ffff880233ffc400
[ 2098.977277] bt_accept_dequeue: parent ffff880233ffc400
[ 2098.977279] l2cap_state_change: ffff880233ffe000 BT_LISTEN -> BT_CLOSED
[ 2098.977281] l2cap_sock_kill: sk ffff880233ffc400 state 9
[ 2098.977282] l2cap_sock_destruct: sk ffff880233ffc400
[ 2098.977304] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.977306] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.977311] hci_sock_recvmsg: sock ffff88023287ea80, sk ffff880233ffcc00
[ 2098.977346] hci_sock_create: sock ffff880227ad5180
[ 2098.977350] hci_sock_bind: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2098.977352] hci_dev_get: 0
[ 2098.977363] hci_sock_setsockopt: sk ffff880234a5ac00, opt 2
[ 2098.977474] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.977476] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.977528] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.977530] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.982384] hci_sock_release: sock ffff8801e2314a00 sk ffff8802126a0400
[ 2098.983479] hci_sock_ioctl: cmd 400448e2 arg ff9cfda8
[ 2098.983482] hci_dev_get: 0
[ 2098.983484] hci_sock_ioctl: cmd 400448c9 arg 0
[ 2098.983486] hci_dev_get: 0
[ 2098.983488] hci_dev_open: hci0 ffff880231744000
[ 2098.983490] btusb_open: hci0
[ 2098.983493] btusb_submit_intr_urb: hci0
[ 2098.983539] btusb_submit_bulk_urb: hci0
[ 2098.983542] btusb_submit_bulk_urb: hci0
[ 2098.983547] __hci_request: hci0 start
[ 2098.983549] hci_init_req: hci0 0
[ 2098.983551] hci_send_cmd: hci0 opcode 0xc03 plen 0
[ 2098.983554] hci_send_cmd: skb len 3
[ 2098.983558] hci_send_cmd: hci0 opcode 0x1003 plen 0
[ 2098.983560] hci_send_cmd: skb len 3
[ 2098.983561] hci_send_cmd: hci0 opcode 0x1001 plen 0
[ 2098.983563] hci_send_cmd: skb len 3
[ 2098.983564] hci_send_cmd: hci0 opcode 0x1005 plen 0
[ 2098.983566] hci_send_cmd: skb len 3
[ 2098.983567] hci_send_cmd: hci0 opcode 0x1009 plen 0
[ 2098.983569] hci_send_cmd: skb len 3
[ 2098.983571] hci_send_cmd: hci0 opcode 0xc23 plen 0
[ 2098.983572] hci_send_cmd: skb len 3
[ 2098.983574] hci_send_cmd: hci0 opcode 0xc14 plen 0
[ 2098.983575] hci_send_cmd: skb len 3
[ 2098.983577] hci_send_cmd: hci0 opcode 0xc25 plen 0
[ 2098.983578] hci_send_cmd: skb len 3
[ 2098.983580] hci_send_cmd: hci0 opcode 0xc05 plen 1
[ 2098.983581] hci_send_cmd: skb len 4
[ 2098.983583] hci_send_cmd: hci0 opcode 0xc16 plen 2
[ 2098.983584] hci_send_cmd: skb len 5
[ 2098.983586] hci_send_cmd: hci0 opcode 0xc12 plen 7
[ 2098.983588] hci_send_cmd: skb len 10
[ 2098.983788] hci_cmd_work: hci0 cmd 1
[ 2098.983790] hci_send_frame: hci0 type 1 len 3
[ 2098.983792] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.983794] btusb_send_frame: hci0
[ 2098.983961] btusb_tx_complete: hci0 urb ffff880230e70000 status 0 count 3
[ 2098.987082] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2098.987096] hci_rx_work: hci0
[ 2098.987099] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2098.987105] hci_rx_work: hci0 Event packet
[ 2098.987108] hci_cc_reset: hci0 status 0x0
[ 2098.987110] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.987112] hci_req_complete: hci0 command 0x0c03 result 0x00
[ 2098.987113] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.987117] hci_cmd_work: hci0 cmd 1
[ 2098.987119] hci_send_frame: hci0 type 1 len 3
[ 2098.987121] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.987122] btusb_send_frame: hci0
[ 2098.987126] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.987131] hci_sock_create: sock ffff8801e688f480
[ 2098.987137] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.987139] hci_dev_get: 0
[ 2098.987142] hci_sock_release: sock ffff8801e688f480 sk ffff880234a5b000
[ 2098.987151] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.987153] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.987320] btusb_tx_complete: hci0 urb ffff88022aba4900 status 0 count 3
[ 2098.988073] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 14
[ 2098.988087] hci_rx_work: hci0
[ 2098.988089] hci_send_to_sock: hdev ffff880231744000 len 14
[ 2098.988094] hci_rx_work: hci0 Event packet
[ 2098.988096] hci_cc_read_local_features: hci0 status 0x0
[ 2098.988099] hci_cc_read_local_features: hci0 features 0xffff8ffe9bff7987
[ 2098.988103] hci_cmd_work: hci0 cmd 1
[ 2098.988106] hci_send_frame: hci0 type 1 len 3
[ 2098.988108] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.988109] btusb_send_frame: hci0
[ 2098.988118] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.988121] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.988128] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.988132] hci_sock_create: sock ffff8801e688f480
[ 2098.988137] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.988138] hci_dev_get: 0
[ 2098.988141] hci_sock_release: sock ffff8801e688f480 sk ffff880234a5b000
[ 2098.988148] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.988150] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.988197] btusb_tx_complete: hci0 urb ffff880233eeb3c0 status 0 count 3
[ 2098.989074] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 14
[ 2098.989198] hci_rx_work: hci0
[ 2098.989201] hci_send_to_sock: hdev ffff880231744000 len 14
[ 2098.989206] hci_rx_work: hci0 Event packet
[ 2098.989208] hci_cc_read_local_version: hci0 status 0x0
[ 2098.989210] hci_cc_read_local_version: hci0 manufacturer 15 hci ver 5:748
[ 2098.989212] hci_send_cmd: hci0 opcode 0xc01 plen 8
[ 2098.989214] hci_send_cmd: skb len 11
[ 2098.989217] hci_send_cmd: hci0 opcode 0x1002 plen 0
[ 2098.989218] hci_send_cmd: skb len 3
[ 2098.989220] hci_send_cmd: hci0 opcode 0xc56 plen 1
[ 2098.989221] hci_send_cmd: skb len 4
[ 2098.989223] hci_send_cmd: hci0 opcode 0xc45 plen 1
[ 2098.989225] hci_send_cmd: skb len 4
[ 2098.989226] hci_send_cmd: hci0 opcode 0xc58 plen 0
[ 2098.989228] hci_send_cmd: skb len 3
[ 2098.989229] hci_send_cmd: hci0 opcode 0x1004 plen 1
[ 2098.989231] hci_send_cmd: skb len 4
[ 2098.989234] hci_cmd_work: hci0 cmd 1
[ 2098.989236] hci_send_frame: hci0 type 1 len 3
[ 2098.989238] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.989239] btusb_send_frame: hci0
[ 2098.989267] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.989269] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.989280] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.989285] hci_sock_create: sock ffff8801e688f480
[ 2098.989289] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.989291] hci_dev_get: 0
[ 2098.989294] hci_sock_release: sock ffff8801e688f480 sk ffff880234a5b000
[ 2098.989302] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.989304] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.989444] btusb_tx_complete: hci0 urb ffff88022edc6000 status 0 count 3
[ 2098.990068] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 13
[ 2098.990087] hci_rx_work: hci0
[ 2098.990090] hci_send_to_sock: hdev ffff880231744000 len 13
[ 2098.990096] hci_rx_work: hci0 Event packet
[ 2098.990098] hci_cc_read_buffer_size: hci0 status 0x0
[ 2098.990101] hci_cc_read_buffer_size: hci0 acl mtu 1021:8 sco mtu 64:1
[ 2098.990105] hci_cmd_work: hci0 cmd 1
[ 2098.990108] hci_send_frame: hci0 type 1 len 3
[ 2098.990110] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.990112] btusb_send_frame: hci0
[ 2098.990121] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.990124] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.990134] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.990139] hci_sock_create: sock ffff880203537c00
[ 2098.990144] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.990146] hci_dev_get: 0
[ 2098.990148] hci_sock_release: sock ffff880203537c00 sk ffff88022aa66000
[ 2098.990157] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.990159] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.990315] btusb_tx_complete: hci0 urb ffff88022aba4840 status 0 count 3
[ 2098.991064] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 12
[ 2098.991072] hci_rx_work: hci0
[ 2098.991075] hci_send_to_sock: hdev ffff880231744000 len 12
[ 2098.991079] hci_rx_work: hci0 Event packet
[ 2098.991081] hci_cc_read_bd_addr: hci0 status 0x0
[ 2098.991083] hci_req_complete: hci0 command 0x1009 result 0x00
[ 2098.991088] hci_cmd_work: hci0 cmd 1
[ 2098.991090] hci_send_frame: hci0 type 1 len 3
[ 2098.991092] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.991093] btusb_send_frame: hci0
[ 2098.991102] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.991104] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.991113] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.991118] hci_sock_create: sock ffff880203537c00
[ 2098.991123] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.991125] hci_dev_get: 0
[ 2098.991127] hci_sock_release: sock ffff880203537c00 sk ffff88022aa66000
[ 2098.991136] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.991138] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.991187] btusb_tx_complete: hci0 urb ffff88022aba4d80 status 0 count 3
[ 2098.992064] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 9
[ 2098.992072] hci_rx_work: hci0
[ 2098.992075] hci_send_to_sock: hdev ffff880231744000 len 9
[ 2098.992079] hci_rx_work: hci0 Event packet
[ 2098.992081] hci_cc_read_class_of_dev: hci0 status 0x0
[ 2098.992083] hci_cc_read_class_of_dev: hci0 class 0x000000
[ 2098.992087] hci_cmd_work: hci0 cmd 1
[ 2098.992090] hci_send_frame: hci0 type 1 len 3
[ 2098.992091] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2098.992093] btusb_send_frame: hci0
[ 2098.992101] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.992103] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.992110] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2098.992114] hci_sock_create: sock ffff880203537c00
[ 2098.992119] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2098.992120] hci_dev_get: 0
[ 2098.992123] hci_sock_release: sock ffff880203537c00 sk ffff88022aa66000
[ 2098.992130] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2098.992132] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2098.992182] btusb_tx_complete: hci0 urb ffff88022aba4c00 status 0 count 3
[ 2098.992356] done.
[ 2098.992361] video LNXVIDEO:00: Restoring backlight state
[ 2098.994063] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2098.994123] video LNXVIDEO:01: Restoring backlight state
[ 2098.995052] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2098.996069] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2098.997052] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2098.998047] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2098.999047] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.000057] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.001017] bbswitch: disabling discrete graphics
[ 2099.001078] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.002041] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.002173] bbswitch: Result of Optimus _DSM call: 11000059
[ 2099.003037] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.004034] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.005036] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.006041] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.007040] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.008032] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.009034] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 14
[ 2099.009049] hci_rx_work: hci0
[ 2099.009052] hci_send_to_sock: hdev ffff880231744000 len 254
[ 2099.009060] hci_rx_work: hci0 Event packet
[ 2099.009062] hci_cc_read_local_name: hci0 status 0x0
[ 2099.009064] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.009067] hci_cmd_work: hci0 cmd 1
[ 2099.009069] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.009070] hci_send_frame: hci0 type 1 len 3
[ 2099.009072] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.009073] btusb_send_frame: hci0
[ 2099.009082] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.009087] hci_sock_create: sock ffff880203536300
[ 2099.009093] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.009094] hci_dev_get: 0
[ 2099.009098] hci_sock_release: sock ffff880203536300 sk ffff880233ffb400
[ 2099.009108] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.009110] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.009271] btusb_tx_complete: hci0 urb ffff8802316c4f00 status 0 count 3
[ 2099.010032] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 8
[ 2099.010099] hci_rx_work: hci0
[ 2099.010101] hci_send_to_sock: hdev ffff880231744000 len 8
[ 2099.010107] hci_rx_work: hci0 Event packet
[ 2099.010109] hci_cc_read_voice_setting: hci0 status 0x0
[ 2099.010111] hci_cc_read_voice_setting: hci0 voice setting 0x0060
[ 2099.010114] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.010116] btusb_notify: hci0 evt 3
[ 2099.010118] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.010124] hci_cmd_work: hci0 cmd 1
[ 2099.010126] hci_send_frame: hci0 type 1 len 4
[ 2099.010128] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.010129] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.010131] btusb_send_frame: hci0
[ 2099.010135] hci_sock_create: sock ffff880203536a80
[ 2099.010140] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.010141] hci_dev_get: 0
[ 2099.010144] hci_sock_release: sock ffff880203536a80 sk ffff880233ffb400
[ 2099.010152] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.010154] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.010269] btusb_tx_complete: hci0 urb ffff88022f286e40 status 0 count 4
[ 2099.011021] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.011072] hci_rx_work: hci0
[ 2099.011074] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.011080] hci_rx_work: hci0 Event packet
[ 2099.011083] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.011089] hci_cc_set_event_flt: hci0 status 0x0
[ 2099.011093] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.011095] hci_req_complete: hci0 command 0x0c05 result 0x00
[ 2099.011101] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.011105] hci_cmd_work: hci0 cmd 1
[ 2099.011108] hci_sock_create: sock ffff880203535680
[ 2099.011111] hci_send_frame: hci0 type 1 len 5
[ 2099.011113] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.011116] hci_send_to_sock: hdev ffff880231744000 len 5
[ 2099.011122] hci_dev_get: 0
[ 2099.011123] btusb_send_frame: hci0
[ 2099.011124] hci_sock_release: sock ffff880203535680 sk ffff880233ffb400
[ 2099.011131] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.011134] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.011277] btusb_tx_complete: hci0 urb ffff88022f286e40 status 0 count 5
[ 2099.013029] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.013124] hci_rx_work: hci0
[ 2099.013126] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.013131] hci_rx_work: hci0 Event packet
[ 2099.013134] hci_cc_write_ca_timeout: hci0 status 0x0
[ 2099.013136] hci_req_complete: hci0 command 0x0c16 result 0x00
[ 2099.013139] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.013141] hci_cmd_work: hci0 cmd 1
[ 2099.013143] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.013147] hci_send_frame: hci0 type 1 len 10
[ 2099.013149] hci_send_to_sock: hdev ffff880231744000 len 10
[ 2099.013154] btusb_send_frame: hci0
[ 2099.013157] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.013162] hci_sock_create: sock ffff880203536a80
[ 2099.013167] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.013169] hci_dev_get: 0
[ 2099.013172] hci_sock_release: sock ffff880203536a80 sk ffff880233ffc400
[ 2099.013181] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.013183] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.013265] btusb_tx_complete: hci0 urb ffff88022f286e40 status 0 count 10
[ 2099.014014] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 8
[ 2099.014209] hci_rx_work: hci0
[ 2099.014211] hci_send_to_sock: hdev ffff880231744000 len 8
[ 2099.014218] hci_rx_work: hci0 Event packet
[ 2099.014220] hci_cc_delete_stored_link_key: hci0 status 0x0
[ 2099.014224] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.014227] hci_req_complete: hci0 command 0x0c12 result 0x00
[ 2099.014229] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.014232] hci_cmd_work: hci0 cmd 1
[ 2099.014234] hci_send_frame: hci0 type 1 len 11
[ 2099.014236] hci_send_to_sock: hdev ffff880231744000 len 11
[ 2099.014238] btusb_send_frame: hci0
[ 2099.014239] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.014244] hci_sock_create: sock ffff880203536a80
[ 2099.014249] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.014251] hci_dev_get: 0
[ 2099.014254] hci_sock_release: sock ffff880203536a80 sk ffff880233ffc400
[ 2099.014262] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.014264] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.014388] btusb_tx_complete: hci0 urb ffff88022f286900 status 0 count 11
[ 2099.016014] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.016075] hci_rx_work: hci0
[ 2099.016077] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.016085] hci_rx_work: hci0 Event packet
[ 2099.016088] hci_cc_set_event_mask: hci0 status 0x0
[ 2099.016090] hci_req_complete: hci0 command 0x0c01 result 0x00
[ 2099.016097] hci_cmd_work: hci0 cmd 1
[ 2099.016100] hci_send_frame: hci0 type 1 len 3
[ 2099.016102] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.016104] btusb_send_frame: hci0
[ 2099.016112] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.016115] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.016144] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.016154] hci_sock_create: sock ffff88020419f980
[ 2099.016165] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.016166] hci_dev_get: 0
[ 2099.016174] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.016193] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.016198] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.016254] btusb_tx_complete: hci0 urb ffff88022f286900 status 0 count 3
[ 2099.018016] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.019010] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.019998] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.020993] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.021991] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.022045] hci_rx_work: hci0
[ 2099.022047] hci_send_to_sock: hdev ffff880231744000 len 70
[ 2099.022052] hci_rx_work: hci0 Event packet
[ 2099.022055] hci_cc_read_local_commands: hci0 status 0x0
[ 2099.022057] hci_send_cmd: hci0 opcode 0x80f plen 2
[ 2099.022059] hci_send_cmd: skb len 5
[ 2099.022067] hci_req_complete: hci0 command 0x1002 result 0x00
[ 2099.022069] hci_cmd_work: hci0 cmd 1
[ 2099.022072] hci_send_frame: hci0 type 1 len 4
[ 2099.022073] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.022075] btusb_send_frame: hci0
[ 2099.022093] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.022096] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.022109] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.022116] hci_sock_create: sock ffff88020419f980
[ 2099.022121] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.022122] hci_dev_get: 0
[ 2099.022125] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.022133] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.022135] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.022244] btusb_tx_complete: hci0 urb ffff88023506c240 status 0 count 4
[ 2099.022990] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.023041] hci_rx_work: hci0
[ 2099.023043] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.023046] hci_rx_work: hci0 Event packet
[ 2099.023048] hci_cc_write_ssp_mode: hci0 status 0x0
[ 2099.023050] hci_sent_cmd_data: hci0 opcode 0xc56
[ 2099.023053] hci_cmd_work: hci0 cmd 1
[ 2099.023056] hci_send_frame: hci0 type 1 len 4
[ 2099.023057] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.023059] btusb_send_frame: hci0
[ 2099.023070] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.023072] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.023079] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.023083] hci_sock_create: sock ffff88020419f980
[ 2099.023086] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.023088] hci_dev_get: 0
[ 2099.023090] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.023097] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.023101] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.023103] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.023238] btusb_tx_complete: hci0 urb ffff88023506c240 status 0 count 4
[ 2099.023992] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.024041] hci_rx_work: hci0
[ 2099.024042] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.024045] hci_rx_work: hci0 Event packet
[ 2099.024048] hci_cc_write_inquiry_mode: hci0 status 0x0
[ 2099.024050] hci_req_complete: hci0 command 0x0c45 result 0x00
[ 2099.024055] hci_cmd_work: hci0 cmd 1
[ 2099.024057] hci_send_frame: hci0 type 1 len 3
[ 2099.024059] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.024060] btusb_send_frame: hci0
[ 2099.024066] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.024068] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.024075] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.024082] hci_sock_create: sock ffff88020419f980
[ 2099.024086] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.024087] hci_dev_get: 0
[ 2099.024089] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.024095] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.024097] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.024236] btusb_tx_complete: hci0 urb ffff88023506c240 status 0 count 3
[ 2099.024984] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 7
[ 2099.025033] hci_rx_work: hci0
[ 2099.025035] hci_send_to_sock: hdev ffff880231744000 len 7
[ 2099.025042] hci_rx_work: hci0 Event packet
[ 2099.025044] hci_cc_read_inq_rsp_tx_power: hci0 status 0x0
[ 2099.025045] hci_req_complete: hci0 command 0x0c58 result 0x00
[ 2099.025048] hci_cmd_work: hci0 cmd 1
[ 2099.025051] hci_send_frame: hci0 type 1 len 4
[ 2099.025052] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.025054] btusb_send_frame: hci0
[ 2099.025060] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.025065] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.025072] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.025076] hci_sock_create: sock ffff88020419f980
[ 2099.025079] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.025081] hci_dev_get: 0
[ 2099.025083] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.025088] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.025093] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.025238] btusb_tx_complete: hci0 urb ffff88023506c240 status 0 count 4
[ 2099.025983] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.026033] hci_rx_work: hci0
[ 2099.026035] hci_send_to_sock: hdev ffff880231744000 len 16
[ 2099.026038] hci_rx_work: hci0 Event packet
[ 2099.026043] hci_cc_read_local_ext_features: hci0 status 0x0
[ 2099.026045] hci_req_complete: hci0 command 0x1004 result 0x00
[ 2099.026049] hci_cmd_work: hci0 cmd 1
[ 2099.026051] hci_send_frame: hci0 type 1 len 5
[ 2099.026052] hci_send_to_sock: hdev ffff880231744000 len 5
[ 2099.026054] btusb_send_frame: hci0
[ 2099.026063] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.026065] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.026073] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.026079] hci_sock_create: sock ffff88020419f980
[ 2099.026084] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.026085] hci_dev_get: 0
[ 2099.026088] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.026093] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.026096] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.026231] btusb_tx_complete: hci0 urb ffff88023506c240 status 0 count 5
[ 2099.026981] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 0
[ 2099.028976] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.029026] hci_rx_work: hci0
[ 2099.029028] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.029031] hci_rx_work: hci0 Event packet
[ 2099.029033] hci_cc_write_def_link_policy: hci0 status 0x0
[ 2099.029035] hci_sent_cmd_data: hci0 opcode 0x80f
[ 2099.029041] hci_req_complete: hci0 command 0x080f result 0x00
[ 2099.029054] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.029062] __hci_request: hci0 end: err 0
[ 2099.029065] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.029071] hci_sock_dev_event: hdev hci0 event 3
[ 2099.029073] hci_send_to_sock: hdev           (null) len 8
[ 2099.029084] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.029092] hci_sock_create: sock ffff88020419f980
[ 2099.029100] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.029103] hci_dev_get: 0
[ 2099.029109] hci_sock_release: sock ffff88020419f980 sk ffff880233d4c400
[ 2099.029122] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.029126] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.032077] hci_sock_recvmsg: sock ffff88023287ea80, sk ffff880233ffcc00
[ 2099.479171] hci_dev_open: hci0 ffff880231744000
[ 2099.480610] hci_sock_create: sock ffff88020419f980
[ 2099.481678] hci_sock_ioctl: cmd 800448d3 arg ff9cfdf8
[ 2099.483258] hci_dev_get: 0
[ 2099.483263] hci_sock_release: sock ffff88020419f980 sk ffff880233d4cc00
[ 2099.483269] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.483276] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.483279] hci_cmd_work: hci0 cmd 1
[ 2099.483282] hci_send_frame: hci0 type 1 len 5
[ 2099.483284] hci_send_to_sock: hdev ffff880231744000 len 5
[ 2099.483286] btusb_send_frame: hci0
[ 2099.483297] hci_cmd_work: hci0 cmd 0
[ 2099.483320] l2cap_sock_create: sock ffff88020419f980
[ 2099.483323] l2cap_chan_create: sk ffff880233d4cc00 chan ffff880233d4d800
[ 2099.483325] l2cap_sock_init: sk ffff880233d4cc00
[ 2099.483328] l2cap_sock_bind: sk ffff880233d4cc00
[ 2099.483332] l2cap_sock_getsockopt: sk ffff880233d4cc00
[ 2099.483333] l2cap_sock_getsockopt_old: sk ffff880233d4cc00
[ 2099.483335] l2cap_sock_setsockopt: sk ffff880233d4cc00
[ 2099.483337] l2cap_sock_setsockopt_old: sk ffff880233d4cc00
[ 2099.483338] l2cap_sock_setsockopt: sk ffff880233d4cc00
[ 2099.483343] l2cap_sock_setsockopt: sk ffff880233d4cc00
[ 2099.483345] l2cap_sock_listen: sk ffff880233d4cc00 backlog 5
[ 2099.483379] l2cap_sock_create: sock ffff88023286fc00
[ 2099.483381] l2cap_chan_create: sk ffff880233d49800 chan ffff880233d4ac00
[ 2099.483382] l2cap_sock_init: sk ffff880233d49800
[ 2099.483385] l2cap_sock_bind: sk ffff880233d49800
[ 2099.483386] l2cap_sock_setsockopt: sk ffff880233d49800
[ 2099.483389] l2cap_sock_listen: sk ffff880233d49800 backlog 5
[ 2099.483391] l2cap_sock_create: sock ffff88023286d900
[ 2099.483393] l2cap_chan_create: sk ffff880233d4f400 chan ffff880233d4a000
[ 2099.483394] l2cap_sock_init: sk ffff880233d4f400
[ 2099.483397] l2cap_sock_bind: sk ffff880233d4f400
[ 2099.483398] l2cap_sock_setsockopt: sk ffff880233d4f400
[ 2099.483400] l2cap_sock_setsockopt: sk ffff880233d4f400
[ 2099.483401] l2cap_sock_listen: sk ffff880233d4f400 backlog 5
[ 2099.483441] btusb_tx_complete: hci0 urb ffff88022eb8b780 status 0 count 5
[ 2099.483542] thinkpad_acpi: EC reports that Thermal Table has changed
[ 2099.484967] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.485020] hci_rx_work: hci0
[ 2099.485022] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.485024] hci_rx_work: hci0 Event packet
[ 2099.485027] hci_cmd_complete_evt: hci0 opcode 0xc18
[ 2099.485031] hci_cmd_work: hci0 cmd 1
[ 2099.485032] hci_send_frame: hci0 type 1 len 10
[ 2099.485033] hci_send_to_sock: hdev ffff880231744000 len 10
[ 2099.485034] btusb_send_frame: hci0
[ 2099.485213] btusb_tx_complete: hci0 urb ffff8802125fe540 status 0 count 10
[ 2099.485963] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 10
[ 2099.486016] hci_rx_work: hci0
[ 2099.486017] hci_send_to_sock: hdev ffff880231744000 len 10
[ 2099.486019] hci_rx_work: hci0 Event packet
[ 2099.486021] hci_cmd_complete_evt: hci0 opcode 0xc0d
[ 2099.585501] l2cap_sock_create: sock ffff880203537c00
[ 2099.586500] l2cap_chan_create: sk ffff880230442c00 chan ffff880230441800
[ 2099.586502] l2cap_sock_init: sk ffff880230442c00
[ 2099.586507] l2cap_sock_bind: sk ffff880230442c00
[ 2099.586510] l2cap_sock_getsockopt: sk ffff880230442c00
[ 2099.586512] l2cap_sock_getsockopt_old: sk ffff880230442c00
[ 2099.586521] l2cap_sock_setsockopt: sk ffff880230442c00
[ 2099.586523] l2cap_sock_setsockopt_old: sk ffff880230442c00
[ 2099.586525] l2cap_sock_setsockopt: sk ffff880230442c00
[ 2099.586530] l2cap_sock_setsockopt: sk ffff880230442c00
[ 2099.586532] l2cap_sock_listen: sk ffff880230442c00 backlog 5
[ 2099.586604] l2cap_sock_create: sock ffff880203535680
[ 2099.586607] l2cap_chan_create: sk ffff880230440800 chan ffff88022ed5c800
[ 2099.586609] l2cap_sock_init: sk ffff880230440800
[ 2099.586612] l2cap_sock_bind: sk ffff880230440800
[ 2099.586614] l2cap_sock_getsockopt: sk ffff880230440800
[ 2099.586615] l2cap_sock_getsockopt_old: sk ffff880230440800
[ 2099.586617] l2cap_sock_setsockopt: sk ffff880230440800
[ 2099.586619] l2cap_sock_setsockopt_old: sk ffff880230440800
[ 2099.586621] l2cap_sock_setsockopt: sk ffff880230440800
[ 2099.586625] l2cap_sock_setsockopt: sk ffff880230440800
[ 2099.586627] l2cap_sock_listen: sk ffff880230440800 backlog 5
[ 2099.587068] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.587236] hci_sock_ioctl: cmd 400448e7 arg ff9cfce6
[ 2099.588154] hci_cmd_work: hci0 cmd 1
[ 2099.588158] hci_send_frame: hci0 type 1 len 251
[ 2099.588162] hci_send_to_sock: hdev ffff880231744000 len 251
[ 2099.588164] btusb_send_frame: hci0
[ 2099.588968] btusb_tx_complete: hci0 urb ffff8802129d5e40 status 0 count 251
[ 2099.590704] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.590724] hci_rx_work: hci0
[ 2099.590731] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.590741] hci_rx_work: hci0 Event packet
[ 2099.590749] hci_cc_write_local_name: hci0 status 0x0
[ 2099.590756] hci_sent_cmd_data: hci0 opcode 0xc13
[ 2099.641848] pci 0000:01:00.0: power state changed by ACPI to D3
[ 2099.681832] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.682730] hci_sock_ioctl: cmd 800448d7 arg 0
[ 2099.682813] hci_cmd_work: hci0 cmd 1
[ 2099.682817] hci_send_frame: hci0 type 1 len 11
[ 2099.682820] hci_send_to_sock: hdev ffff880231744000 len 11
[ 2099.682822] btusb_send_frame: hci0
[ 2099.683009] btusb_tx_complete: hci0 urb ffff8802125fe240 status 0 count 11
[ 2099.684504] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.684544] hci_rx_work: hci0
[ 2099.684551] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.684561] hci_rx_work: hci0 Event packet
[ 2099.684569] hci_cc_set_event_mask: hci0 status 0x0
[ 2099.684578] hci_req_complete: hci0 command 0x0c01 result 0x00
[ 2099.697960] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.698886] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.698889] hci_cmd_work: hci0 cmd 1
[ 2099.698893] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.698896] hci_send_frame: hci0 type 1 len 4
[ 2099.698897] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.698900] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.698902] btusb_send_frame: hci0
[ 2099.698913] hci_cmd_work: hci0 cmd 0
[ 2099.698937] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.699008] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.707111] btusb_tx_complete: hci0 urb ffff880230e039c0 status 0 count 4
[ 2099.707118] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.710231] hci_cmd_work: hci0 cmd 0
[ 2099.710237] hci_rx_work: hci0
[ 2099.710241] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.710256] hci_rx_work: hci0 Event packet
[ 2099.710271] hci_cc_write_ssp_mode: hci0 status 0x0
[ 2099.710275] hci_sent_cmd_data: hci0 opcode 0xc56
[ 2099.710284] hci_cmd_work: hci0 cmd 1
[ 2099.710290] hci_send_frame: hci0 type 1 len 4
[ 2099.710295] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.710299] btusb_send_frame: hci0
[ 2099.713412] btusb_tx_complete: hci0 urb ffff880233eb7c00 status 0 count 4
[ 2099.713419] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.713465] hci_rx_work: hci0
[ 2099.713472] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.713479] hci_rx_work: hci0 Event packet
[ 2099.713485] hci_cc_write_inquiry_mode: hci0 status 0x0
[ 2099.713490] hci_req_complete: hci0 command 0x0c45 result 0x00
[ 2099.713510] hci_cmd_work: hci0 cmd 1
[ 2099.713515] hci_send_frame: hci0 type 1 len 3
[ 2099.713520] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.713525] btusb_send_frame: hci0
[ 2099.735280] btusb_tx_complete: hci0 urb ffff88022ebed780 status 0 count 3
[ 2099.735285] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 7
[ 2099.735294] hci_rx_work: hci0
[ 2099.735297] hci_send_to_sock: hdev ffff880231744000 len 7
[ 2099.735301] hci_rx_work: hci0 Event packet
[ 2099.735304] hci_cc_read_inq_rsp_tx_power: hci0 status 0x0
[ 2099.735306] hci_req_complete: hci0 command 0x0c58 result 0x00
[ 2099.735311] hci_cmd_work: hci0 cmd 1
[ 2099.735314] hci_send_frame: hci0 type 1 len 5
[ 2099.735316] hci_send_to_sock: hdev ffff880231744000 len 5
[ 2099.735319] btusb_send_frame: hci0
[ 2099.768971] btusb_tx_complete: hci0 urb ffff88022eb5f240 status 0 count 5
[ 2099.768981] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.768995] hci_rx_work: hci0
[ 2099.769000] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.769007] hci_rx_work: hci0 Event packet
[ 2099.769012] hci_cc_write_def_link_policy: hci0 status 0x0
[ 2099.769055] hci_sent_cmd_data: hci0 opcode 0x80f
[ 2099.769059] hci_req_complete: hci0 command 0x080f result 0x00
[ 2099.769068] hci_cmd_work: hci0 cmd 1
[ 2099.769073] hci_send_frame: hci0 type 1 len 251
[ 2099.769076] hci_send_to_sock: hdev ffff880231744000 len 251
[ 2099.769081] btusb_send_frame: hci0
[ 2099.788378] btusb_tx_complete: hci0 urb ffff880233eb7f00 status 0 count 251
[ 2099.788384] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.788559] hci_rx_work: hci0
[ 2099.788562] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.788566] hci_rx_work: hci0 Event packet
[ 2099.788568] hci_cc_write_local_name: hci0 status 0x0
[ 2099.788573] hci_sent_cmd_data: hci0 opcode 0xc13
[ 2099.788578] hci_cmd_work: hci0 cmd 1
[ 2099.788581] hci_send_frame: hci0 type 1 len 6
[ 2099.788583] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.788585] btusb_send_frame: hci0
[ 2099.790587] btusb_tx_complete: hci0 urb ffff880233eb7000 status 0 count 6
[ 2099.790592] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.790598] hci_rx_work: hci0
[ 2099.790599] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.790642] hci_rx_work: hci0 Event packet
[ 2099.790644] hci_cc_write_class_of_dev: hci0 status 0x0
[ 2099.790646] hci_sent_cmd_data: hci0 opcode 0xc24
[ 2099.821173] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.821614] hci_cmd_work: hci0 cmd 1
[ 2099.821618] hci_send_frame: hci0 type 1 len 4
[ 2099.821621] hci_send_to_sock: hdev ffff880231744000 len 4
[ 2099.821625] btusb_send_frame: hci0
[ 2099.821798] btusb_tx_complete: hci0 urb ffff880233eb7000 status 0 count 4
[ 2099.822910] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.822916] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.822920] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.822922] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.822925] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.822928] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.822930] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.822937] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.822939] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.822941] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.822950] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.822957] hci_sock_create: sock ffff880208ab5680
[ 2099.822962] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.822965] hci_dev_get: 0
[ 2099.822968] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa66000
[ 2099.822975] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.822978] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.822980] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.822982] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.822984] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.822985] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.822987] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.822989] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.822991] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.822992] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.822998] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.823001] hci_sock_create: sock ffff880208ab5680
[ 2099.823004] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.823005] hci_dev_get: 0
[ 2099.823007] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa66000
[ 2099.823013] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.823015] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.823017] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.823019] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.823021] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.823023] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.823025] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.823027] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.823028] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.823030] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.823036] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.823039] hci_sock_create: sock ffff880208ab5680
[ 2099.823042] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.823044] hci_dev_get: 0
[ 2099.823046] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa66000
[ 2099.823051] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.823059] hci_cmd_work: hci0 cmd 0
[ 2099.823064] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.823067] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.823069] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.823072] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.823074] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.823076] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.823079] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.823081] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.823082] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.823085] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.823090] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.823095] hci_sock_create: sock ffff880208ab5680
[ 2099.823098] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.823101] hci_dev_get: 0
[ 2099.823103] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa66000
[ 2099.823109] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.823111] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.823114] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.823116] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.823119] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.823121] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.823123] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.823125] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.823127] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.823143] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.823148] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.823152] hci_sock_create: sock ffff880208ab5680
[ 2099.823155] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.823157] hci_dev_get: 0
[ 2099.823159] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa66000
[ 2099.823171] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.823230] hci_rx_work: hci0
[ 2099.823232] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.823239] hci_rx_work: hci0 Event packet
[ 2099.823242] hci_cc_write_scan_enable: hci0 status 0x0
[ 2099.823244] hci_sent_cmd_data: hci0 opcode 0xc1a
[ 2099.823247] hci_send_to_sock: hdev           (null) len 10
[ 2099.823249] hci_req_complete: hci0 command 0x0c1a result 0x00
[ 2099.823253] hci_cmd_work: hci0 cmd 1
[ 2099.823256] hci_send_frame: hci0 type 1 len 3
[ 2099.823258] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.823260] btusb_send_frame: hci0
[ 2099.823417] btusb_tx_complete: hci0 urb ffff88023140e840 status 0 count 3
[ 2099.824838] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.824849] hci_cmd_work: hci0 cmd 0
[ 2099.824861] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.824865] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.824870] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.824872] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.824875] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.824878] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.824880] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.824883] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.824886] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.824931] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.824939] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.824944] hci_sock_create: sock ffff880208ab6a80
[ 2099.824950] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.824952] hci_dev_get: 0
[ 2099.824977] hci_sock_release: sock ffff880208ab6a80 sk ffff88022aa65400
[ 2099.824985] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.824988] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.824990] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.824992] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.824995] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.824997] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.824999] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825001] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825003] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825006] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825011] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.825014] hci_sock_create: sock ffff880208ab6a80
[ 2099.825032] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.825033] hci_dev_get: 0
[ 2099.825035] hci_sock_release: sock ffff880208ab6a80 sk ffff88022aa65400
[ 2099.825039] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.825041] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.825043] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.825044] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.825045] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.825047] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.825048] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825050] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825051] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825052] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825056] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.825079] hci_sock_create: sock ffff880208ab6a80
[ 2099.825083] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.825085] hci_dev_get: 0
[ 2099.825087] hci_sock_release: sock ffff880208ab6a80 sk ffff88022aa65400
[ 2099.825095] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.825097] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.825100] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.825101] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.825103] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.825104] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.825105] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825107] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825108] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825110] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825128] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.825130] hci_sock_create: sock ffff880208ab6a80
[ 2099.825133] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.825134] hci_dev_get: 0
[ 2099.825135] hci_sock_release: sock ffff880208ab6a80 sk ffff88022aa65400
[ 2099.825138] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.825143] hci_cmd_work: hci0 cmd 0
[ 2099.825145] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.825147] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.825149] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.825151] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.825152] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.825154] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.825187] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.825241] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825243] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825246] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825249] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825256] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.825259] hci_sock_create: sock ffff880208ab6a80
[ 2099.825264] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.825266] hci_dev_get: 0
[ 2099.825268] hci_sock_release: sock ffff880208ab6a80 sk ffff88022aa64400
[ 2099.825441] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.825445] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.825448] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.825450] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.825454] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.825457] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.825459] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825461] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825464] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825466] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825473] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.825477] hci_sock_create: sock ffff880233b5e080
[ 2099.825482] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.825484] hci_dev_get: 0
[ 2099.825487] hci_sock_release: sock ffff880233b5e080 sk ffff88022f375c00
[ 2099.825492] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.825500] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.825503] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.825506] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.825509] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.825512] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.825514] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.825517] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.825519] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.825521] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.825523] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.825612] hci_cmd_work: hci0 cmd 0
[ 2099.826164] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.827161] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.828159] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.829169] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.830179] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.831151] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.832146] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.833143] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.834144] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.835138] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.836136] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.837135] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.838133] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.839129] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.840128] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 14
[ 2099.840179] hci_rx_work: hci0
[ 2099.840182] hci_send_to_sock: hdev ffff880231744000 len 254
[ 2099.840187] hci_rx_work: hci0 Event packet
[ 2099.840190] hci_cc_read_local_name: hci0 status 0x0
[ 2099.840196] hci_cmd_work: hci0 cmd 1
[ 2099.840198] hci_send_frame: hci0 type 1 len 3
[ 2099.840201] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.840204] btusb_send_frame: hci0
[ 2099.840214] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.840218] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.840221] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.840223] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.840225] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.840229] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.840231] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.840233] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.840235] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.840236] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.840247] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.840253] hci_sock_create: sock ffff880208ab5680
[ 2099.840258] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.840259] hci_dev_get: 0
[ 2099.840262] hci_sock_release: sock ffff880208ab5680 sk ffff88022aa65400
[ 2099.840271] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.840273] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.840275] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.840276] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.840278] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.840279] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.840281] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.840282] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.840283] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.840285] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.840377] btusb_tx_complete: hci0 urb ffff88023140ec00 status 0 count 3
[ 2099.841125] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 7
[ 2099.841173] hci_rx_work: hci0
[ 2099.841174] hci_send_to_sock: hdev ffff880231744000 len 7
[ 2099.841176] hci_rx_work: hci0 Event packet
[ 2099.841179] hci_cc_read_ssp_mode: hci0 status 0x0
[ 2099.841180] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.841182] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.841189] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.841190] hci_cmd_work: hci0 cmd 1
[ 2099.841192] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.841194] hci_send_frame: hci0 type 1 len 3
[ 2099.841196] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.841197] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.841199] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.841201] btusb_send_frame: hci0
[ 2099.841202] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.841205] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.841207] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.841208] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.841214] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.841217] hci_sock_create: sock ffff880233b5e080
[ 2099.841219] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.841221] hci_dev_get: 0
[ 2099.841223] hci_sock_release: sock ffff880233b5e080 sk ffff88022f374800
[ 2099.841230] hci_sock_sendmsg: sock ffff880227ad5180 sk ffff880234a5ac00
[ 2099.841235] hci_cmd_work: hci0 cmd 0
[ 2099.841237] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.841239] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.841241] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.841243] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.841244] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.841246] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.841247] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.841253] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.841254] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.841255] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.841374] btusb_tx_complete: hci0 urb ffff88023140ec00 status 0 count 3
[ 2099.843120] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.844122] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.845117] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.846114] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.847120] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.848114] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.849111] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.850118] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.851107] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.852104] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.853101] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.854103] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.855097] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.856094] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.857095] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 16
[ 2099.858091] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 14
[ 2099.858104] hci_rx_work: hci0
[ 2099.858112] hci_send_to_sock: hdev ffff880231744000 len 254
[ 2099.858123] hci_rx_work: hci0 Event packet
[ 2099.858130] hci_cc_read_local_name: hci0 status 0x0
[ 2099.858135] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.858142] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.858148] hci_cmd_work: hci0 cmd 1
[ 2099.858151] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.858156] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.858162] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.858166] hci_send_frame: hci0 type 1 len 3
[ 2099.858171] hci_send_to_sock: hdev ffff880231744000 len 3
[ 2099.858177] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.858181] btusb_send_frame: hci0
[ 2099.858185] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.858192] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.858206] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.858209] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.858229] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.858236] hci_sock_create: sock ffff880208a56580
[ 2099.858243] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.858245] hci_dev_get: 0
[ 2099.858249] hci_sock_release: sock ffff880208a56580 sk ffff88022aa18800
[ 2099.858264] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.858267] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.858270] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.858273] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.858276] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.858280] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.858283] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.858287] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.858290] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.858298] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.858348] btusb_tx_complete: hci0 urb ffff88023152f240 status 0 count 3
[ 2099.859093] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 7
[ 2099.859107] hci_rx_work: hci0
[ 2099.859112] hci_send_to_sock: hdev ffff880231744000 len 7
[ 2099.859120] hci_rx_work: hci0 Event packet
[ 2099.859126] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.859130] hci_cmd_complete_evt: hci0 opcode 0xc19
[ 2099.859136] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.859140] hci_cmd_work: hci0 cmd 1
[ 2099.859146] hci_send_frame: hci0 type 1 len 244
[ 2099.859150] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.859155] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.859160] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.859164] hci_send_to_sock: hdev ffff880231744000 len 244
[ 2099.859169] btusb_send_frame: hci0
[ 2099.859173] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.859178] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.859183] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.859189] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.859195] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.859227] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.859231] hci_sock_create: sock ffff880208a56580
[ 2099.859239] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.859242] hci_dev_get: 0
[ 2099.859245] hci_sock_release: sock ffff880208a56580 sk ffff88022aa18800
[ 2099.859338] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.859341] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.859344] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.859347] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.859350] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.859353] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.859355] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.859358] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.859361] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.859363] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.859958] btusb_tx_complete: hci0 urb ffff88023152f300 status 0 count 244
[ 2099.861081] btusb_intr_complete: hci0 urb ffff88022f912f00 status 0 count 6
[ 2099.861087] hci_rx_work: hci0
[ 2099.861090] hci_send_to_sock: hdev ffff880231744000 len 6
[ 2099.861094] hci_rx_work: hci0 Event packet
[ 2099.861096] hci_cmd_complete_evt: hci0 opcode 0xc52
[ 2099.861100] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.861103] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.861105] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.861107] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.861109] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.861111] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.861113] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.861115] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.861117] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.861119] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2099.861125] hci_sock_recvmsg: sock ffff880227ad5180, sk ffff880234a5ac00
[ 2099.861129] hci_sock_create: sock ffff8801e688cc80
[ 2099.861134] hci_sock_ioctl: cmd 800448d3 arg ff9d01d4
[ 2099.861136] hci_dev_get: 0
[ 2099.861138] hci_sock_release: sock ffff8801e688cc80 sk ffff880233fef400
[ 2099.861145] bt_sock_poll: sock ffff88023287de00, sk ffff880233ff8400
[ 2099.861148] bt_sock_poll: sock ffff88023287e800, sk ffff880233ffe400
[ 2099.861150] bt_sock_poll: sock ffff88020419f980, sk ffff880233d4cc00
[ 2099.861153] bt_sock_poll: sock ffff88023286fc00, sk ffff880233d49800
[ 2099.861158] bt_sock_poll: sock ffff88023286d900, sk ffff880233d4f400
[ 2099.861161] bt_sock_poll: sock ffff880203535900, sk ffff880230441c00
[ 2099.861165] bt_sock_poll: sock ffff880203536300, sk ffff880230446800
[ 2099.861167] bt_sock_poll: sock ffff880203537c00, sk ffff880230442c00
[ 2099.861170] bt_sock_poll: sock ffff880203535680, sk ffff880230440800
[ 2099.861172] bt_sock_poll: sock ffff880203536a80, sk ffff88022ed5fc00
[ 2101.854382] btusb_suspend: intf ffff880212427400
[ 2101.854430] btusb_intr_complete: hci0 urb ffff88022f912f00 status -2 count 0
[ 2101.854610] btusb_bulk_complete: hci0 urb ffff880230e706c0 status -2 count 0
[ 2101.854865] btusb_bulk_complete: hci0 urb ffff88022f912480 status -2 count 0
[ 2101.854941] btusb_suspend: intf ffff880212424800
[ 2103.725847] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[ 2105.896500] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=hcidump

HCI sniffer - Bluetooth packet analyzer ver 2.1
device: hci0 snap_len: 1028 filter: 0xffffffff
device: disconnected

--W/nzBZO5zC0uMSeA--
