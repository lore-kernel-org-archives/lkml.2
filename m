Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1EJTzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:55:45 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:58972 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1EJTzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:55:43 -0400
Message-ID: <4DC9983B.4070006@msgid.tls.msk.ru>
Date: Tue, 10 May 2011 23:55:39 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: apparent regression (crash) - 2.6.38.6
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I just tried 2.6.38.6 (which has been released today), and
discovered that it crashes during bootup on my machine.
2.6.38.5 with exactly the same config works.

Unfortunately I don't have time _right now_ to debug the
issue, but will try tomorrow.

For now, here's a part of dmesg with an oops, captured
using netconsole.  If someone have a clue, please speak
up ;)

What I also noticed is that for some reason, udev now loads
option driver (option: v0.7.2:USB Driver for GSM modems),
even if I don't have any modems connected to the system.
This is obviously not related to the issue at hand.

[   92.138523] netconsole: local port 6665
[   92.138560] netconsole: local IP 192.168.88.2
[   92.138589] netconsole: interface 'eth0'
[   92.138617] netconsole: remote port 6556
[   92.138646] netconsole: remote IP 192.168.88.63
[   92.138675] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[   92.155039] console [netcon0] enabled
[   92.155069] netconsole: network logging started
[  105.078254] wmi: Mapper loaded
[  105.143315] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  105.150119] usbcore: registered new interface driver uas
[  105.158893] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  105.170076] Initializing USB Mass Storage driver...
[  105.170305] scsi8 : usb-storage 1-2:1.0
[  105.170582] scsi9 : usb-storage 4-3:1.0
[  105.170821] usbcore: registered new interface driver usb-storage
[  105.170861] USB Mass Storage support registered.
[  105.186798] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  105.186839] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[  105.186900] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  105.186958] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  105.187002] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 6
[  105.200083] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[  105.200137] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[  105.200184] ehci_hcd 0000:00:12.2: debug port 1
[  105.200237] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbbff000
[  105.200326] usb 1-2: USB disconnect, address 2
[  105.210071] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[  105.210140] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[  105.210172] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  105.210207] usb usb6: Product: EHCI Host Controller
[  105.210240] usb usb6: Manufacturer: Linux 2.6.38-amd64 ehci_hcd
[  105.210272] usb usb6: SerialNumber: 0000:00:12.2
[  105.210403] hub 6-0:1.0: USB hub found
[  105.210440] hub 6-0:1.0: 6 ports detected
[  105.210566] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  105.210628] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  105.210666] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
[  105.220066] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[  105.220120] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[  105.220167] ehci_hcd 0000:00:13.2: debug port 1
[  105.220222] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbbfa800
[  105.230899] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[  105.230977] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[  105.231010] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  105.231048] usb usb7: Product: EHCI Host Controller
[  105.231081] usb usb7: Manufacturer: Linux 2.6.38-amd64 ehci_hcd
[  105.231114] usb usb7: SerialNumber: 0000:00:13.2
[  105.231250] hub 7-0:1.0: USB hub found
[  105.231286] hub 7-0:1.0: 6 ports detected
[  105.244597] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[  105.244642] ACPI: Power Button [PWRB]
[  105.244714] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[  105.244760] ACPI: Power Button [PWRF]
[  105.320071] usb 2-2: USB disconnect, address 2
[  105.366984] usbcore: registered new interface driver usbserial
[  105.367036] USB Serial support registered for generic
[  105.372665] ACPI: processor limited to max C-state 1
[  105.376034] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[  105.376078] cdrom: Uniform CD-ROM driver Revision: 3.20
[  105.444430] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [io 0xb00-0xb0f]
[  105.444472] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[  105.460058] usb 2-3: USB disconnect, address 3
[  105.495455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  105.495537] sd 5:0:0:0: Attached scsi generic sg1 type 0
[  105.495593] sr 6:0:1:0: Attached scsi generic sg2 type 5
[  105.579904] Linux agpgart interface v0.103
[  105.640056] usb 4-3: USB disconnect, address 2
[  105.645489] [drm] Initialized drm 1.1.0 20060810
[  105.731682] [drm] radeon kernel modesetting enabled.
[  105.731794] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  105.733378] [drm] initializing kernel modesetting (RS780 0x1002:0x9610).
[  105.733492] [drm] register mmio base: 0xFBDF0000
[  105.733526] [drm] register mmio size: 65536
[  105.734165] ATOM BIOS: B27722
[  105.734222] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000000CFFFFFFF (256M used)
[  105.734256] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[  105.734520] [drm] Detected VRAM RAM=256M, BAR=256M
[  105.734566] [drm] RAM width 32bits DDR
[  105.734686] [TTM] Zone  kernel: Available graphics memory: 2930020 kiB.
[  105.734718] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[  105.734754] [TTM] Initializing pool allocator.
[  105.734804] [drm] radeon: 256M of VRAM memory ready
[  105.734835] [drm] radeon: 512M of GTT memory ready.
[  105.734886] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  105.734918] [drm] Driver supports precise vblank timestamp query.
[  105.734967] [drm] radeon: irq initialized.
[  105.734999] [drm] GART: num cpu pages 131072, num gpu pages 131072
[  105.735777] [drm] Loading RS780 Microcode
[  105.866725] usb 6-2: new high speed USB device using ehci_hcd and address 2
[  105.992326] usb 6-2: New USB device found, idVendor=0951, idProduct=1626
[  105.992368] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  105.992407] usb 6-2: Product: DT HyperX
[  105.992437] usb 6-2: Manufacturer: Kingston
[  105.992470] usb 6-2: SerialNumber: 0018F30C6ACE5B9417100000
[  105.992838] scsi10 : usb-storage 6-2:1.0
[  106.055221] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  106.064475] radeon 0000:01:05.0: WB enabled
[  106.095615] [drm] ring test succeeded in 1 usecs
[  106.095708] [drm] radeon: ib pool ready.
[  106.095790] [drm] ib test succeeded in 0 usecs
[  106.095840] [drm] Enabling audio support
[  106.096353] [drm] Radeon Display Connectors
[  106.096388] [drm] Connector 0:
[  106.096421] [drm]   VGA
[  106.096455] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[  106.096490] [drm]   Encoders:
[  106.096522] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[  106.096555] [drm] Connector 1:
[  106.096588] [drm]   DVI-D
[  106.096620] [drm]   HPD1
[  106.096670] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[  106.096722] [drm]   Encoders:
[  106.096755] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[  106.150426] [drm] radeon: power management initialized
[  106.207924] usb 7-6: new high speed USB device using ehci_hcd and address 2
[  106.228368] [drm] fb mappable at 0xD0141000
[  106.228410] [drm] vram apper at 0xD0000000
[  106.228443] [drm] size 5242880
[  106.228475] [drm] fb depth is 24
[  106.228507] [drm]    pitch is 5120
[  106.228605] fbcon: radeondrmfb (fb0) is primary device
[  106.247711] Console: switching to colour frame buffer device 160x64
[  106.258639] fb0: radeondrmfb frame buffer device
[  106.258706] drm: registered panic notifier
[  106.258767] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0 on minor 0
[  106.258922] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  106.338563] usb 7-6: New USB device found, idVendor=07cc, idProduct=0301
[  106.338664] usb 7-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  106.338763] usb 7-6: Product: Winter Ver1.3
[  106.338822] usb 7-6: Manufacturer:         Ltd
[  106.338884] usb 7-6: SerialNumber: 714161933017
[  106.341226] scsi11 : usb-storage 7-6:1.0
[  106.341462] usbcore: registered new interface driver usbserial_generic
[  106.341549] usbserial: USB Serial Driver core
[  106.404390] USB Serial support registered for GSM modem (1-port)
[  106.404528] usbcore: registered new interface driver option
[  106.404601] option: v0.7.2:USB Driver for GSM modems
[  106.590060] usb 2-2: new low speed USB device using ohci_hcd and address 4
[  106.753797] usb 2-2: New USB device found, idVendor=046d, idProduct=c044
[  106.753898] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  106.753996] usb 2-2: Product: USB-PS/2 Optical Mouse
[  106.754061] usb 2-2: Manufacturer: Logitech
[  106.761932] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-2/2-2:1.0/input/input6
[  106.762170] generic-usb 0003:046D:C044.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.1-2/input0
[  106.994177] scsi 10:0:0:0: Direct-Access     Kingston DT HyperX        HMAP PQ: 0 ANSI: 0 CCS
[  106.994458] sd 10:0:0:0: Attached scsi generic sg3 type 0
[  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
[  106.994840] PGD 19efc9067 PUD 0
[  106.994898] Oops: 0000 [#1] SMP
[  106.994955] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host0/target0:0:0/0:0:0:0/block/sda/removable
[  106.995082] CPU 1
[  106.995110] Modules linked in: option snd_hda_codec_hdmi usb_wwan snd_hda_codec_realtek snd_hda_intel snd_hda_codec fbcon font bitblit softcursor snd_hwdep radeon ttm drm_kms_helper snd_pcm snd_seq drm snd_timer agpgart snd_seq_device sg fb fbdev i2c_algo_bit i2c_piix4 i2c_core snd sr_mod processor usbserial thermal_sys cfbcopyarea cfbimgblt cfbfillrect evdev soundcore cdrom k10temp asus_atk0110 psmouse button snd_page_alloc hwmon ehci_hcd usb_storage shpchp uas pci_hotplug wmi netconsole r8169 mii ext4 mbcache jbd2 crc16 configfs pata_atiixp ohci_hcd ahci libahci libata usbhid hid usbcore nls_base sd_mod scsi_mod crc_t10dif
[  106.996301]
[  106.996325] Pid: 10, comm: ksoftirqd/1 Not tainted 2.6.38-amd64 #2.6.38.6 System manufacturer System Product Name/M3A78-EM
[  106.996493] RIP: 0010:[<ffffffff811bec1b>]  [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
[  106.996665] RSP: 0018:ffff8800cfc43de8  EFLAGS: 00010046
[  106.996740] RAX: 0000000000000000 RBX: ffff88019b8c54d8 RCX: 0000000000000000
[  106.997674] RDX: ffff88019bb1b380 RSI: 0000000000000000 RDI: ffff88019b8c54d8
[  107.003475] RBP: ffff88019b8c5850 R08: ffff88019e6b1810 R09: 0000000000000001
[  107.003475] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  107.003475] R13: ffff88019b8c54d8 R14: ffff88019d63c040 R15: ffff88019e788800
[  107.003475] FS:  0000000000000000(0000) GS:ffff8800cfc40000(0000) knlGS:00000000f7560720
[  107.003475] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  107.003475] CR2: 0000000000000048 CR3: 000000019efe2000 CR4: 00000000000006e0
[  107.003475] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  107.003475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  107.003475] Process ksoftirqd/1 (pid: 10, threadinfo ffff88019fcda000, task ffff88019fc90080)
[  107.003475] Stack:
[  107.003475]  ffff88019b8c54d8 ffffffff811c6527 ffff88019b8c54d8 0000000000000296
[  107.003475]  ffff8800cfc43e58 ffffffff811c675a ffff88019d63c000 ffff88019d63c000
[  107.003475]  ffff8800cfc43e58 ffffffffa000e1db ffff88019ed729c0 ffffffffa002a500
[  107.003475] Call Trace:
[  107.003475]  <IRQ>
[  107.003475]  [<ffffffff811c6527>] ? __blk_run_queue+0x37/0x190
[  107.003475]  [<ffffffff811c675a>] ? blk_run_queue+0x2a/0x50
[  107.003475]  [<ffffffffa000e1db>] ? scsi_run_queue+0xeb/0x370 [scsi_mod]
[  107.003475]  [<ffffffffa000f39b>] ? scsi_next_command+0x3b/0x60 [scsi_mod]
[  107.003475]  [<ffffffffa001013f>] ? scsi_io_completion+0x34f/0x570 [scsi_mod]
[  107.003475]  [<ffffffff811cafc5>] ? blk_done_softirq+0x75/0x90
[  107.003475]  [<ffffffff81052f1d>] ? __do_softirq+0x9d/0x1d0
[  107.003475]  [<ffffffff8100349c>] ? call_softirq+0x1c/0x30
[  107.003475]  <EOI>
[  107.003475]  [<ffffffff81005535>] ? do_softirq+0x65/0xa0
[  107.003475]  [<ffffffff81052b27>] ? run_ksoftirqd+0x87/0x150
[  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
[  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
[  107.003475]  [<ffffffff8106bf06>] ? kthread+0x96/0xa0
[  107.003475]  [<ffffffff810033a4>] ? kernel_thread_helper+0x4/0x10
[  107.003475]  [<ffffffff8106be70>] ? kthread+0x0/0xa0
[  107.003475]  [<ffffffff810033a0>] ? kernel_thread_helper+0x0/0x10
[  107.003475] Code: 48 83 c4 08 c3 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 31 c0 48 3b 3f 48 8b 57 18 74 09 48 83 c4 08 c3 0f 1f 40 00 48 8b 02 <48> 8b 50 48 b8 01 00 00 00 48 85 d2 74 e6 48 83 c4 08 ff e2 90
[  107.003475] RIP  [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
[  107.003475]  RSP <ffff8800cfc43de8>
[  107.003475] CR2: 0000000000000048
[  107.003475] ---[ end trace 9fcac9eeba5b3f54 ]---
[  107.003475] Kernel panic - not syncing: Fatal exception in interrupt
[  107.003475] Pid: 10, comm: ksoftirqd/1 Tainted: G      D     2.6.38-amd64 #2.6.38.6
[  107.003475] Call Trace:
[  107.003475]  <IRQ>  [<ffffffff81340bb9>] ? panic+0x92/0x1a0
[  107.003475]  [<ffffffff8104c482>] ? kmsg_dump+0x42/0x100
[  107.003475]  [<ffffffff81006823>] ? oops_end+0xa3/0xb0
[  107.003475]  [<ffffffff8102c9b3>] ? no_context+0x103/0x270
[  107.003475]  [<ffffffff8102d1b9>] ? do_page_fault+0x289/0x430
[  107.003475]  [<ffffffff81036804>] ? check_preempt_curr+0x74/0x90
[  107.003475]  [<ffffffff81045275>] ? try_to_wake_up+0xc5/0x430
[  107.003475]  [<ffffffff81343f25>] ? page_fault+0x25/0x30
[  107.003475]  [<ffffffff811bec1b>] ? elv_queue_empty+0x1b/0x30
[  107.003475]  [<ffffffff811c6527>] ? __blk_run_queue+0x37/0x190
[  107.003475]  [<ffffffff811c675a>] ? blk_run_queue+0x2a/0x50
[  107.003475]  [<ffffffffa000e1db>] ? scsi_run_queue+0xeb/0x370 [scsi_mod]
[  107.003475]  [<ffffffffa000f39b>] ? scsi_next_command+0x3b/0x60 [scsi_mod]
[  107.003475]  [<ffffffffa001013f>] ? scsi_io_completion+0x34f/0x570 [scsi_mod]
[  107.003475]  [<ffffffff811cafc5>] ? blk_done_softirq+0x75/0x90
[  107.003475]  [<ffffffff81052f1d>] ? __do_softirq+0x9d/0x1d0
[  107.003475]  [<ffffffff8100349c>] ? call_softirq+0x1c/0x30
[  107.003475]  <EOI>  [<ffffffff81005535>] ? do_softirq+0x65/0xa0
[  107.003475]  [<ffffffff81052b27>] ? run_ksoftirqd+0x87/0x150
[  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
[  107.003475]  [<ffffffff81052aa0>] ? run_ksoftirqd+0x0/0x150
[  107.003475]  [<ffffffff8106bf06>] ? kthread+0x96/0xa0
[  107.003475]  [<ffffffff810033a4>] ? kernel_thread_helper+0x4/0x10
[  107.003475]  [<ffffffff8106be70>] ? kthread+0x0/0xa0
[  107.003475]  [<ffffffff810033a0>] ? kernel_thread_helper+0x0/0x10
[  107.003475] panic occurred, switching back to text console
