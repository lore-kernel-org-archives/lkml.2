Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2JSLyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:54:03 -0400
Received: from mail.agmk.net ([91.192.224.71]:41459 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2JSLyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:54:00 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com
Subject: [3.6.2] oops @ opteron server: mgag200 Fatal error during GPU init
Date: Fri, 19 Oct 2012 13:53:54 +0200
Message-ID: <1993905.xE9oHSL7vg@localhost>
User-Agent: KMail/4.9.1 (Linux/3.6.2; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on the new opteron server i'm observing an oops during matrox video initialization.
here's the dmesg from pure 3.6.2 kernel:

[   20.598985] [drm] Initialized drm 1.1.0 20060810
[   20.642302] [drm:mga_vram_init] *ERROR* can't reserve VRAM
[   20.642307] mgag200 0000:01:04.0: Fatal error during GPU init: -6
[   20.642319] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   20.664413] IP: [<ffffffffa03c364f>] drm_mode_config_cleanup+0x1f/0x1c0 [drm]
[   20.675905] PGD 40869b067 PUD 4086a4067 PMD 0 
[   20.687362] Oops: 0000 [#1] SMP 
[   20.698748] Modules linked in: igb(+) usb_storage(+) mgag200(+) ttm crc32c_intel ghash_clmulni_intel drm_kms_helper drm aesni_intel usb_libusual dca ablk_helper uas i2c_algo_bit sysimgblt cryptd sysfillrect syscopyarea ptp aes_x86_64 pps_core evdev joydev pcspkr aes_generic hid_generic fam15h_power(+) i2c_piix4(+) atiixp(+) k10temp i2c_core microcode ide_core amd64_edac_mod edac_core hwmon edac_mce_amd processor button uhci_hcd ext3 jbd mbcache raid1 md_mod usbhid hid ohci_hcd ehci_hcd usbcore usb_common uvesafb sd_mod crc_t10dif ahci libahci libata scsi_mod
[   20.750381] CPU 12 
[   20.750478] Pid: 463, comm: udevd Not tainted 3.6.2 #4 Supermicro H8DGU/H8DGU
[   20.776696] RIP: 0010:[<ffffffffa03c364f>]  [<ffffffffa03c364f>] drm_mode_config_cleanup+0x1f/0x1c0 [drm]
[   20.790249] RSP: 0018:ffff8804086a3a88  EFLAGS: 00010296
[   20.803729] RAX: 0000000000000000 RBX: ffff881007f41000 RCX: 0000000000000043
[   20.817409] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff881008d83000
[   20.831003] RBP: ffff8804086a3aa8 R08: 000000000000000a R09: 00000000000003ff
[   20.844580] R10: 0000000000000000 R11: 00000000000003fe R12: ffff881008d83000
[   20.858085] R13: ffff881008d83460 R14: ffff881007f41000 R15: ffff881008d833a0
[   20.871607] FS:  00007fc87267c800(0000) GS:ffff88101ec00000(0000) knlGS:0000000000000000
[   20.885316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.899017] CR2: 0000000000000000 CR3: 000000040869a000 CR4: 00000000000407e0
[   20.912916] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   20.926724] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   20.940450] Process udevd (pid: 463, threadinfo ffff8804086a2000, task ffff88040846ee00)
[   20.942880] Probing IDE interface ide1...
[   20.968028] Stack:
[   20.981616]  ffff881007f41000 ffff881007f41000 ffff881008d83000 ffffffffa029a8e0
[   20.995514]  ffff8804086a3ac8 ffffffffa02942c7 00000000fffffffa ffff881008ddd000
[   21.009470]  ffff8804086a3b58 ffffffffa029462e ffff8804086a3af8 ffffffffa03c11a1
[   21.023443] Call Trace:
[   21.037295]  [<ffffffffa02942c7>] mgag200_driver_unload+0x37/0x70 [mgag200]
[   21.051493]  [<ffffffffa029462e>] mgag200_driver_load+0x32e/0x4b0 [mgag200]
[   21.065600]  [<ffffffffa03c11a1>] ? drm_sysfs_device_add+0x81/0xb0 [drm]
[   21.079699]  [<ffffffffa03bd469>] ? drm_get_minor+0x259/0x2f0 [drm]
[   21.093733]  [<ffffffffa03bfaae>] drm_get_pci_dev+0x17e/0x2c0 [drm]
[   21.107675]  [<ffffffffa0299405>] mga_pci_probe+0xb1/0xb9 [mgag200]
[   21.121582]  [<ffffffff8127f854>] local_pci_probe+0x74/0x100
[   21.135386]  [<ffffffff8127f9f1>] pci_device_probe+0x111/0x120
[   21.149106]  [<ffffffff813319e6>] driver_probe_device+0x76/0x240
[   21.162801]  [<ffffffff81331c4b>] __driver_attach+0x9b/0xa0
[   21.176411]  [<ffffffff81331bb0>] ? driver_probe_device+0x240/0x240
[   21.190062]  [<ffffffff8132fd4d>] bus_for_each_dev+0x4d/0x90
[   21.203724]  [<ffffffff81331509>] driver_attach+0x19/0x20
[   21.217443]  [<ffffffff81331100>] bus_add_driver+0x190/0x260
[   21.231260]  [<ffffffffa02c5000>] ? 0xffffffffa02c4fff
[   21.245155]  [<ffffffffa02c5000>] ? 0xffffffffa02c4fff
[   21.259047]  [<ffffffff813322d2>] driver_register+0x72/0x170
[   21.272998]  [<ffffffffa02c5000>] ? 0xffffffffa02c4fff
[   21.286900]  [<ffffffff8127e6c9>] __pci_register_driver+0x59/0xd0
[   21.300840]  [<ffffffffa02c5000>] ? 0xffffffffa02c4fff
[   21.314682]  [<ffffffffa03bfd0a>] drm_pci_init+0x11a/0x130 [drm]
[   21.328540]  [<ffffffffa02c5000>] ? 0xffffffffa02c4fff
[   21.342301]  [<ffffffffa02c5032>] mgag200_init+0x32/0x1000 [mgag200]
[   21.356065]  [<ffffffff81002122>] do_one_initcall+0x122/0x170
[   21.369741]  [<ffffffff810aa176>] sys_init_module+0xfe6/0x1e50
[   21.383355]  [<ffffffff810a6920>] ? free_notes_attrs+0x60/0x60
[   21.396935]  [<ffffffff814ae579>] system_call_fastpath+0x16/0x1b
[   21.410479] Code: 5d 41 5e 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41 54 49 89 fc 4d 8d ac 24 60 04 00 00 53 48 83 ec 08 48 8b 87 60 04 00 00 <48> 8b 18 48 8d 78 f8 48 83 eb 08 49 39 c5 74 1c 90 48 8b 47 40 
[   21.439403] RIP  [<ffffffffa03c364f>] drm_mode_config_cleanup+0x1f/0x1c0 [drm]
[   21.453651]  RSP <ffff8804086a3a88>
[   21.467829] CR2: 0000000000000000
[   21.481651] ---[ end trace ecb4d159319307e6 ]---


01:04.0 VGA compatible controller: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 (rev 0a) (prog-if 00 [VGA controller])
        Subsystem: Super Micro Computer Inc H8DGU
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at fc000000 (32-bit, prefetchable) [size=16M]
        Memory at fdffc000 (32-bit, non-prefetchable) [size=16K]
        Memory at fe000000 (32-bit, non-prefetchable) [size=8M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [dc] Power Management version 1
        Kernel driver in use: mgag200
        Kernel modules: mgag200

