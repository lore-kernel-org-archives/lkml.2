Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DDHDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:03:50 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41933 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2DDHDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:03:47 -0400
Date: Wed, 4 Apr 2012 10:03:45 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: nouveau regression in 3.4-rc4-144
Message-ID: <alpine.SOC.1.00.1204041000040.26551@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todays 3.4-rc4-144 fails to bring up nouveau on my 6600 (NV43). 
Yesterdays 3.4-rc1-104 worked.

[    0.217652] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.217703] vgaarb: loaded
[    0.217737] vgaarb: bridge control possible 0000:05:00.0
[...]
[    0.301534] PCI-DMA: Disabling AGP.
[    0.301676] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.301714] PCI-DMA: using GART IOMMU.
[    0.301752] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[...]
[    4.126518] wmi: Mapper loaded
[    4.164097] firewire_ohci 0000:01:08.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    4.164914] VGA switcheroo: detected Optimus DSM method \ handle
[    4.165180] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[    4.165645] [drm] nouveau 0000:05:00.0: Detected an NV40 generation card (0x043100a4)
[    4.169130] [drm] nouveau 0000:05:00.0: Checking PRAMIN for VBIOS
[    4.243053] [drm] nouveau 0000:05:00.0: ... BIOS checksum invalid
[    4.243099] [drm] nouveau 0000:05:00.0: Checking PROM for VBIOS
[    4.243177] [drm] nouveau 0000:05:00.0: ... BIOS signature not found
[    4.243222] [drm] nouveau 0000:05:00.0: Checking ACPI for VBIOS
[    4.243266] [drm] nouveau 0000:05:00.0: ... BIOS signature not found
[    4.243310] [drm] nouveau 0000:05:00.0: Checking PCIROM for VBIOS
[    4.247128] [drm] nouveau 0000:05:00.0: ... appears to be valid
[    4.247212] ------------[ cut here ]------------
[    4.247255] kernel BUG at mm/slub.c:3471!
[    4.247297] invalid opcode: 0000 [#1] SMP 
[    4.247384] CPU 0 
[    4.247412] Modules linked in: nouveau(+) video mxm_wmi wmi ohci_hcd(+) firewire_ohci firewire_core powernow_k8 ttm crc_itu_t ehci_hcd(+) amd64_edac_mod(+) psmouse mperf drm_kms_helper edac_mce_amd evdev usbcore pcspkr drm serio_raw edac_core microcode k8temp(+) power_supply usb_common pata_amd(+) i2c_nforce2(+) thermal processor fan button snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore thermal_sys i2c_core forcedeth(+)
[    4.248014] 
[    4.248014] Pid: 299, comm: modprobe Not tainted 3.4.0-rc1-00144-g01627d9 #3 System Manufacter System Product Name/KN9(NF-MCP55 series)
[    4.248014] RIP: 0010:[<ffffffff810a0c27>]  [<ffffffff810a0c27>] kfree+0x22/0x80
[    4.248014] RSP: 0018:ffff880136a69aa8  EFLAGS: 00010246
[    4.248014] RAX: 0004d00000000000 RBX: ffff880135960000 RCX: 0000000000000000
[    4.248014] RDX: 0004d00000000000 RSI: 0000000000135960 RDI: 0000000000000026
[    4.248014] RBP: ffff880136a69b38 R08: 0000000000000000 R09: ffff88013f563800
[    4.248014] R10: 0000000000000000 R11: 000000000000014b R12: ffff880135980000
[    4.248014] R13: ffff880136a69b38 R14: ffff880136a69ac0 R15: ffff880136bfcb80
[    4.248014] FS:  00007f767132b700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[    4.248014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.248014] CR2: 00007fb55803d960 CR3: 0000000139e67000 CR4: 00000000000007f0
[    4.248014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.248014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.248014] Process modprobe (pid: 299, threadinfo ffff880136a68000, task ffff880137cedeb0)
[    4.248014] Stack:
[    4.248014]  ffff880136bfc800 ffffffffa01d0fb8 ffff88013a7802a8 00004e494d415250
[    4.248014]  ffffffffa01d12b7 0000000200000001 000000000000fe00 ffff880135960000
[    4.248014]  000000004d4f5250 ffffffffa01d1143 0000000000000000 000000000000fe00
[    4.248014] Call Trace:
[    4.248014]  [<ffffffffa01d0fb8>] ? bios_shadow+0x1da/0x26a [nouveau]
[    4.248014]  [<ffffffffa01d12b7>] ? bios_shadow_prom+0x174/0x174 [nouveau]
[    4.248014]  [<ffffffffa01d1143>] ? nv_mask+0x57/0x57 [nouveau]
[    4.248014]  [<ffffffffa01d50d6>] ? init_io+0x4d7/0x4d7 [nouveau]
[    4.248014]  [<ffffffffa01d1048>] ? bios_shadow+0x26a/0x26a [nouveau]
[    4.248014]  [<ffffffffa01d8cbc>] ? nouveau_bios_init+0x53/0xc8c [nouveau]
[    4.248014]  [<ffffffffa02167ce>] ? NVReadVgaCrtc+0x45/0x96 [nouveau]
[    4.248014]  [<ffffffffa01cdac1>] ? NVSetOwner+0x57/0x8a [nouveau]
[    4.248014]  [<ffffffffa01c2bb1>] ? nouveau_card_init+0x13e7/0x1aa5 [nouveau]
[    4.248014]  [<ffffffffa01c3991>] ? nouveau_load+0x658/0x69c [nouveau]
[    4.248014]  [<ffffffffa00ee1ad>] ? drm_get_pci_dev+0x14d/0x24f [drm]
[    4.248014]  [<ffffffff81169fab>] ? pci_device_probe+0x6b/0xb7
[    4.248014]  [<ffffffff811d543e>] ? driver_probe_device+0xa8/0x1ad
[    4.248014]  [<ffffffff811d5592>] ? __driver_attach+0x4f/0x6f
[    4.248014]  [<ffffffff811d5543>] ? driver_probe_device+0x1ad/0x1ad
[    4.248014]  [<ffffffff811d3ed0>] ? bus_for_each_dev+0x4a/0x75
[    4.248014]  [<ffffffff811d4c36>] ? bus_add_driver+0xa5/0x1f5
[    4.248014]  [<ffffffff811d599f>] ? driver_register+0x85/0xed
[    4.248014]  [<ffffffff8116a1ab>] ? __pci_register_driver+0x4c/0xad
[    4.248014]  [<ffffffffa0251000>] ? 0xffffffffa0250fff
[    4.248014]  [<ffffffffa0251000>] ? 0xffffffffa0250fff
[    4.248014]  [<ffffffff81000205>] ? do_one_initcall+0x75/0x124
[    4.248014]  [<ffffffffa0251000>] ? 0xffffffffa0250fff
[    4.248014]  [<ffffffff8105d511>] ? sys_init_module+0x151b/0x1757
[    4.248014]  [<ffffffff812d5522>] ? system_call_fastpath+0x16/0x1b
[    4.248014] Code: 00 00 00 00 00 00 00 5b c3 48 83 ff 10 53 48 89 fb 76 74 e8 d3 e3 ff ff 49 89 c1 48 8b 00 a8 80 75 14 49 f7 01 00 c0 00 00 75 02 <0f> 0b 5b 4c 89 cf e9 43 a4 fd ff 4c 8b 54 24 08 49 8b 79 30 48 
[    4.248014] RIP  [<ffffffff810a0c27>] kfree+0x22/0x80
[    4.248014]  RSP <ffff880136a69aa8>
[    4.253364] ---[ end trace 59f4859ed17a8d9d ]---

-- 
Meelis Roos (mroos@linux.ee)
