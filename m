Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0ILSjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:39:25 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:52694 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0ILSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:39:23 -0400
X-Greylist: delayed 2636 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2010 14:39:22 EDT
Message-ID: <4C8D1406.2030903@uni-koeln.de>
Date: Sun, 12 Sep 2010 19:55:18 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.12) Gecko/20100824 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem: Oops in linux-2.6.34.3 radeon at xserver start
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X-Server fails to start with vanilla kernel linux-2.6.34.3 and newer
versions (tested up to 2.6.35.4). All kernels build starting with
configuration of working linux-2.6.34.2. System is Debian stable/testing
with xorg 7.5.


Xorg.0.log shows

...
(II) Module radeon: vendor="X.Org Foundation"
	compiled for 1.7.7, module version = 6.13.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 6.0
(II) LoadModule: "vesa"
(WW) Warning, couldn't open module vesa
(II) UnloadModule: "vesa"
(EE) Failed to load module "vesa" (module does not exist, 0)
(II) LoadModule: "fbdev"
(WW) Warning, couldn't open module fbdev
(II) UnloadModule: "fbdev"
(EE) Failed to load module "fbdev" (module does not exist, 0)
...



Syslog shows Oops:

...
Sep 12 18:38:39 tulsa kernel: [   21.873996] BUG: unable to handle
kernel NULL pointer dereference at (null)
Sep 12 18:38:39 tulsa kernel: [   21.874000] IP: [<ffffffffa0376a2a>]
r600_ioctl_wait_idle+0x43/0x7d [radeon]
Sep 12 18:38:39 tulsa kernel: [   21.874011] PGD 338dca067 PUD 338db3067
PMD 0
Sep 12 18:38:39 tulsa kernel: [   21.874014] Oops: 0000 [#1] PREEMPT SMP
Sep 12 18:38:39 tulsa kernel: [   21.874016] last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/boot_vga
Sep 12 18:38:39 tulsa kernel: [   21.874018] CPU 1
Sep 12 18:38:39 tulsa kernel: [   21.874019] Modules linked in:
binfmt_misc autofs4 uinput fuse ipv6 sbp2 loop dm_crypt
snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
radeon ttm snd_seq_midi drm_kms_helper snd_rawmidi snd_seq_midi_event
drm i2c_i801 snd_seq snd_timer snd_seq_device snd soundcore agpgart
i2c_algo_bit i2c_core joydev evdev pcspkr snd_page_alloc processor wmi
button psmouse asus_atk0110 ext3 jbd mbcache dm_mod ahci usb_storage sg
hid_microsoft sr_mod cdrom sd_mod crc_t10dif ata_generic usbhid hid
pata_acpi r8169 ata_piix uhci_hcd floppy ohci1394 mii libata ieee1394
scsi_mod thermal ehci_hcd ide_pci_generic ide_core usbcore nls_base
thermal_sys [last unloaded: scsi_wait_scan]
Sep 12 18:38:39 tulsa kernel: [   21.874060]
Sep 12 18:38:39 tulsa kernel: [   21.874062] Pid: 2493, comm: Xorg Not
tainted 2.6.34.3-vanilla #1 P6T/System Product Name
Sep 12 18:38:39 tulsa kernel: [   21.874064] RIP:
0010:[<ffffffffa0376a2a>]  [<ffffffffa0376a2a>]
r600_ioctl_wait_idle+0x43/0x7d [radeon]
Sep 12 18:38:39 tulsa kernel: [   21.874072] RSP: 0018:ffff880338d55d80
 EFLAGS: 00010246
Sep 12 18:38:39 tulsa kernel: [   21.874074] RAX: ffffc90010ac0000 RBX:
ffff88033a6eb380 RCX: 0000000000000000
Sep 12 18:38:39 tulsa kernel: [   21.874076] RDX: 0000000000000000 RSI:
ffff88033df09400 RDI: ffff88033c994000
Sep 12 18:38:39 tulsa kernel: [   21.874078] RBP: ffff88033df09400 R08:
0000000000000000 R09: 00000000c0086464
Sep 12 18:38:39 tulsa kernel: [   21.874079] R10: ffff88033df09400 R11:
0000000000000000 R12: 0000000000000000
Sep 12 18:38:39 tulsa kernel: [   21.874081] R13: 00000000c0086464 R14:
ffffffffa03ac660 R15: ffffffffa035d177
Sep 12 18:38:39 tulsa kernel: [   21.874083] FS:  00007fa15f15b700(0000)
GS:ffff880001640000(0000) knlGS:0000000000000000
Sep 12 18:38:39 tulsa kernel: [   21.874085] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Sep 12 18:38:39 tulsa kernel: [   21.874087] CR2: 0000000000000000 CR3:
0000000338dcb000 CR4: 00000000000006e0
Sep 12 18:38:39 tulsa kernel: [   21.874089] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Sep 12 18:38:39 tulsa kernel: [   21.874090] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Sep 12 18:38:39 tulsa kernel: [   21.874092] Process Xorg (pid: 2493,
threadinfo ffff880338d54000, task ffff88033c2ba480)
Sep 12 18:38:39 tulsa kernel: [   21.874094] Stack:
Sep 12 18:38:39 tulsa kernel: [   21.874095]  ffffffffa035d1cb
ffff88033a6eb200 ffff88033df86000 0000000000000064
Sep 12 18:38:39 tulsa kernel: [   21.874098] <0> ffffffffa02ba3e0
0000000000000064 000000000000e200 ffff880300000001
Sep 12 18:38:39 tulsa kernel: [   21.874101] <0> 00000000000080d0
ffff880338d55dd8 00007fff1f0d8fa0 0000000000000001
Sep 12 18:38:39 tulsa kernel: [   21.874104] Call Trace:
Sep 12 18:38:39 tulsa kernel: [   21.874114]  [<ffffffffa035d1cb>] ?
radeon_gem_wait_idle_ioctl+0x54/0x64 [radeon]
Sep 12 18:38:39 tulsa kernel: [   21.874120]  [<ffffffffa02ba3e0>] ?
drm_ioctl+0x224/0x31f [drm]
Sep 12 18:38:39 tulsa kernel: [   21.874125]  [<ffffffff810b221f>] ?
vma_prio_tree_insert+0x20/0x39
Sep 12 18:38:39 tulsa kernel: [   21.874128]  [<ffffffff812a346b>] ?
_raw_spin_unlock+0x25/0x33
Sep 12 18:38:39 tulsa kernel: [   21.874132]  [<ffffffff810bdfa8>] ?
vma_link+0xc0/0xd0
Sep 12 18:38:39 tulsa kernel: [   21.874135]  [<ffffffff810e0234>] ?
vfs_ioctl+0x23/0x93
Sep 12 18:38:39 tulsa kernel: [   21.874137]  [<ffffffff810e0a82>] ?
do_vfs_ioctl+0x429/0x46d
Sep 12 18:38:39 tulsa kernel: [   21.874140]  [<ffffffff810e0b11>] ?
sys_ioctl+0x4b/0x72
Sep 12 18:38:39 tulsa kernel: [   21.874143]  [<ffffffff81002a82>] ?
system_call_fastpath+0x16/0x1b
Sep 12 18:38:39 tulsa kernel: [   21.874144] Code: 00 34 2f 00 00 48 8b
87 d0 00 00 00 76 0a 31 c9 89 88 34 2f 00 00 eb 13 b9 34 2f 00 00 89 08
31 c0 48 8b 8f d0 00 00 00 89 41 04 <8b> 02 c3 48 81 bf c8 00 00 00 80
54 00 00 48 8b 87 d0 00 00 00
Sep 12 18:38:39 tulsa kernel: [   21.874168] RIP  [<ffffffffa0376a2a>]
r600_ioctl_wait_idle+0x43/0x7d [radeon]
Sep 12 18:38:39 tulsa kernel: [   21.874176]  RSP <ffff880338d55d80>
Sep 12 18:38:39 tulsa kernel: [   21.874177] CR2: 0000000000000000
Sep 12 18:38:39 tulsa kernel: [   21.874179] ---[ end trace
618b25935e95b12c ]---
Sep 12 18:38:39 tulsa kernel: [   21.874420] [drm:drm_release] *ERROR*
Device busy: 1
...


Output of scripts/ver_linux for working kernel:


If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux tulsa 2.6.34.2-vanilla #1 SMP PREEMPT Sun Sep 12 18:11:55 CEST
2010 x86_64 GNU/Linux

Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
reiserfsprogs          3.6.21
PPP                    2.4.5
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               8.5
Modules Loaded         acpi_cpufreq cpufreq_stats cpufreq_conservative
cpufreq_ondemand freq_table cpufreq_powersave cpufreq_userspace battery
sco bridge stp llc bnep rfcomm l2cap crc16 bluetooth binfmt_misc autofs4
uinput fuse ipv6 sbp2 loop dm_crypt snd_hda_codec_atihdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event radeon ttm drm_kms_helper snd_seq snd_timer
snd_seq_device drm snd agpgart i2c_i801 i2c_algo_bit soundcore i2c_core
pcspkr joydev usb_storage snd_page_alloc evdev wmi processor button
psmouse asus_atk0110 ext3 jbd mbcache dm_mod ahci hid_microsoft sg
sr_mod cdrom usbhid hid sd_mod crc_t10dif ata_generic pata_acpi uhci_hcd
ata_piix libata scsi_mod ohci1394 r8169 ieee1394 mii ide_pci_generic
ehci_hcd ide_core usbcore nls_base floppy thermal thermal_sys


Output of lspci:

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
(rev 12)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 1 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 3 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 7 (rev 12)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 12)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 12)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and
RAS Registers (rev 12)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
(rev 12)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio
Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 1
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 4
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface
Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port
SATA IDE Controller #1
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller #2
02:00.0 VGA compatible controller: ATI Technologies Inc RV730XT [Radeon
HD 4670]
02:00.1 Audio device: ATI Technologies Inc RV710/730
04:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series
Firewire Controller
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)


Hardware:
Asus P6T
Intel Core i7
12 GB RAM
HIS HD4670 IceQ Turbo PCIe


Regards
Berthold Cogel
