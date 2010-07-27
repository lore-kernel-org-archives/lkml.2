Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0G0LBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:01:44 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:57123 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756119Ab0G0LBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:01:42 -0400
Message-ID: <4C4EBC8E.40703@ribosome.natur.cuni.cz>
Date: Tue, 27 Jul 2010 13:01:34 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dave Airlie <airlied@linux.ie>
Subject: 2.6.34 and 2.6.35-rc6-git2: kernel crash downstream of generic_file_aio_write
 and i830_swap_bufs
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I have a kernel crash with _intel_ drm driver on Acer LCi291 laptop with builtin Intel 855GM card
when I start /usr/bin/X (it does work when "vesa" instead of "intel" drm driver is called from
xorg.conf, though).

# lspci
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
01:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller (rev 80)
01:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
01:02.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter (rev 04)
01:04.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)
#


With 2.6.34-gentoo-r1 kernel I get:

[ 1440.751283] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 1440.751297] IP: [<efdc70bc>] i830_swap_bufs+0x2a/0x2ab [i830]
[ 1440.751318] *pde = 00000000 
[ 1440.751326] Oops: 0000 [#1] 
[ 1440.751333] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/resource
[ 1440.751342] Modules linked in: i830 snd_intel8x0m snd_intel8x0 snd_ac97_codec ipw2100 libipw irda firewire_ohci i2c_i801 intel_agp firewire_core parport_pc ac97_bus parport rtc_cmos
[ 1440.751379] 
[ 1440.751389] Pid: 6247, comm: X Not tainted 2.6.34-gentoo-r1 #2 855GM      /TravelMate 290           
[ 1440.751400] EIP: 0060:[<efdc70bc>] EFLAGS: 00213246 CPU: 0
[ 1440.751412] EIP is at i830_swap_bufs+0x2a/0x2ab [i830]
[ 1440.751421] EAX: 00000000 EBX: de1120c0 ECX: de1120c0 EDX: de112780
[ 1440.751430] ESI: ed229000 EDI: 00000046 EBP: ed00fe70 ESP: ed00fe34
[ 1440.751439]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1440.751449] Process X (pid: 6247, ti=ed00e000 task=de166dc0 task.ti=ed00e000)
[ 1440.751456] Stack:
[ 1440.751461]  00000001 efdc8e61 efdc8b4c efdc91d2 00000000 ed00ff20 ed00ff18 ed229000
[ 1440.751478] <0> c110c2eb ed00fe70 c110c31e ed00fe8c de1120c0 ed229000 00000046 ed00ff18
[ 1440.751496] <0> c1170ccd bffce0f0 efdc7092 efdc9770 c0086446 ed00fe8c 00000005 bffce0fc
[ 1440.751516] Call Trace:
[ 1440.751534]  [<c110c2eb>] ? might_fault+0x8/0xa
[ 1440.751547]  [<c110c31e>] ? _copy_from_user+0x31/0x115
[ 1440.751563]  [<c1170ccd>] ? drm_ioctl+0x211/0x2a1
[ 1440.751577]  [<efdc7092>] ? i830_swap_bufs+0x0/0x2ab [i830]
[ 1440.751592]  [<c104bc19>] ? generic_file_aio_write+0x87/0x9e
[ 1440.751606]  [<c1068408>] ? do_sync_write+0x89/0xc4
[ 1440.751618]  [<c1170abc>] ? drm_ioctl+0x0/0x2a1
[ 1440.751631]  [<c107149d>] ? vfs_ioctl+0x15/0x49
[ 1440.751642]  [<c10719a4>] ? do_vfs_ioctl+0x42f/0x46d
[ 1440.751655]  [<c10681cf>] ? fsnotify_modify+0x4f/0x5a
[ 1440.751666]  [<c106837f>] ? do_sync_write+0x0/0xc4
[ 1440.751677]  [<c1068bc8>] ? vfs_write+0x98/0xac
[ 1440.751689]  [<c1071a10>] ? sys_ioctl+0x2e/0x48
[ 1440.751701]  [<c1002590>] ? sysenter_do_call+0x12/0x26
[ 1440.751708] Code: c3 55 89 e5 57 56 53 83 ec 20 89 45 e0 89 cb 68 d2 91 dc ef 68 4c 8b dc ef 68 61 8e dc ef 6a 01 e8 98 d0 3a d1 8b 53 40 8b 42 3c <8b> 08 83 c4 10 85 c9 79 05 39 5a 40 74 2d 8b 00 53 ff 72 40 25 
[ 1440.751799] EIP: [<efdc70bc>] i830_swap_bufs+0x2a/0x2ab [i830] SS:ESP 0068:ed00fe34
[ 1440.751816] CR2: 0000000000000000
[ 1440.751824] ---[ end trace dc458c9454c6e7e1 ]---
[ 1440.755289] [drm:drm_release] *ERROR* Device busy: 1


Here is a crash with 2.6.35-rc6-git2 as well:
[cut]
[    5.074544] agpgart-intel 0000:00:00.0: Intel 855GM Chipset
[    5.075090] agpgart-intel 0000:00:00.0: detected 16252K stolen memory
[    5.077817] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xb0000000
[cut]
[   57.952849] BUG: unable to handle kernel NULL pointer dereference at (null)
[   57.952863] IP: [<efae80bc>] i830_swap_bufs+0x2a/0x2ab [i830]
[   57.952885] *pde = 00000000 
[   57.952893] Oops: 0000 [#1] 
[   57.952901] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/resource
[   57.952910] Modules linked in: i830 firewire_ohci snd_intel8x0m ipw2100 snd_intel8x0 irda parport_pc parport intel_agp firewire_core snd_ac97_codec libipw i2c_i801 rtc_cmos ac97_bus
[   57.952948] 
[   57.952959] Pid: 5345, comm: X Not tainted 2.6.35-rc6-git2 #1 855GM      /TravelMate 290           
[   57.952970] EIP: 0060:[<efae80bc>] EFLAGS: 00213246 CPU: 0
[   57.952982] EIP is at i830_swap_bufs+0x2a/0x2ab [i830]
[   57.952991] EAX: 00000000 EBX: ed038a20 ECX: ed038a20 EDX: ed038a80
[   57.953001] ESI: ed24ec00 EDI: 00000046 EBP: ee233e70 ESP: ee233e34
[   57.953010]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   57.953021] Process X (pid: 5345, ti=ee232000 task=ee03dd40 task.ti=ee232000)
[   57.953028] Stack:
[   57.953033]  00000001 efae9e65 efae9b50 efaea1d5 00000000 ee233f20 ee233f18 ed24ec00
[   57.953050] <0> c11106d7 ee233e70 c111070a ee233e8c ed038a20 ed24ec00 00000046 ee233f18
[   57.953068] <0> c11765f5 bfc15960 efae8092 efaea774 c0086446 ee233e8c 00000005 bfc1596c
[   57.953087] Call Trace:
[   57.953104]  [<c11106d7>] ? might_fault+0x8/0xa
[   57.953116]  [<c111070a>] ? _copy_from_user+0x31/0x115
[   57.953131]  [<c11765f5>] ? drm_ioctl+0x211/0x2a1
[   57.953145]  [<efae8092>] ? i830_swap_bufs+0x0/0x2ab [i830]
[   57.953160]  [<c104d7f0>] ? generic_file_aio_write+0x87/0x9e
[   57.953175]  [<c1069e09>] ? do_sync_write+0x89/0xc4
[   57.953187]  [<c11763e4>] ? drm_ioctl+0x0/0x2a1
[   57.953200]  [<c1073241>] ? vfs_ioctl+0x15/0x49
[   57.953212]  [<c1073724>] ? do_vfs_ioctl+0x40b/0x43f
[   57.953225]  [<c1069bd0>] ? fsnotify_modify+0x4f/0x5a
[   57.953237]  [<c1069d80>] ? do_sync_write+0x0/0xc4
[   57.953248]  [<c106a5c9>] ? vfs_write+0x98/0xac
[   57.953260]  [<c1073786>] ? sys_ioctl+0x2e/0x48
[   57.953273]  [<c1002510>] ? sysenter_do_call+0x12/0x26
[   57.953280] Code: c3 55 89 e5 57 56 53 83 ec 20 89 45 e0 89 cb 68 d5 a1 ae ef 68 50 9b ae ef 68 65 9e ae ef 6a 01 e8 c8 19 69 d1 8b 53 40 8b 42 3c <8b> 08 83 c4 10 85 c9 79 05 39 5a 40 74 2d 8b 00 53 ff 72 40 25 
[   57.953370] EIP: [<efae80bc>] i830_swap_bufs+0x2a/0x2ab [i830] SS:ESP 0068:ee233e34
[   57.953387] CR2: 0000000000000000
[   57.953396] ---[ end trace 9e76fe13d3edd6f6 ]---
[   57.957541] [drm:drm_release] *ERROR* Device busy: 1



There is a similar kernel crash at http://forums.gentoo.org/viewtopic-t-832282-start-0.html .


Thanks for clues,
Martin
