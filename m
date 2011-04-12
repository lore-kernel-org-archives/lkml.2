Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1DLRyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:54:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56668 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1DLRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=g+GVsiRRZmtPte64SJNhUme4+JwCgEtQVS6Zab6uP0FpVvJ5nRMKgPLjIEy3r5vTIY
         LBiCiTRp7P0hxlbwVk+sYSVESEcEJJioiIQOuFsc2D8dTD+Mc3lBeOo9IWkWqFsuPYAl
         uytpxjFyyr5TsudYJdPJJKh+r1zYmlo4kA3HU=
MIME-Version: 1.0
Date: Tue, 12 Apr 2011 12:54:06 -0500
Message-ID: <BANLkTikTVuV9eH4GiLDs0DewGJXo_3daeg@mail.gmail.com>
Subject: oops in radeon_ddc_get_modes on first boot of rc3
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI - Radeon Oops occurred on my first boot of the 2.6.39-rc3 kernel
(the system booted fine with 2.6.38-rcs) a few minutes ago.  x also
would not start.  On the next reboot I did not get the oops.

[   23.831830] BUG: unable to handle kernel NULL pointer dereference
at 000000000000008e
[   23.831867] IP: [<ffffffffa0158ff6>]
drm_mode_connector_update_edid_property+0x76/0x1c0 [drm]
[   23.831918] PGD 156de7067 PUD 156de6067 PMD 0
[   23.831949] Oops: 0000 [#1] SMP
[   23.831972] last sysfs file:
/sys/devices/virtual/wmi/98479A64-33F5-4E33-A707-8E251EBBC3A1/uevent
[   23.832005] CPU 0
[   23.832016] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event radeon(+) fbcon
tileblit font bitblit snd_seq softcursor joydev snd_timer i915 iwlagn
ttm mac80211 snd_seq_device pcmcia drm_kms_helper snd lp drm uvcvideo
cfg80211 sdhci_pci soundcore psmouse serio_raw parport videodev
v4l2_compat_ioctl32 intel_agp snd_page_alloc yenta_socket tpm_tis tpm
sdhci tpm_bios intel_gtt video ahci libahci e1000e [last unloaded:
kvm]
[   23.832494]
[   23.832505] Pid: 473, comm: modprobe Not tainted 2.6.39-rc3-custom+
#122 LENOVO 4061BL2/4061BL2
[   23.832550] RIP: 0010:[<ffffffffa0158ff6>]  [<ffffffffa0158ff6>]
drm_mode_connector_update_edid_property+0x76/0x1c0 [drm]
[   23.832600] RSP: 0018:ffff880156a49978  EFLAGS: 00010202
[   23.832623] RAX: 0000000000000010 RBX: ffff880156ac2000 RCX: 0000000000000000
[   23.832650] RDX: 0000000000000000 RSI: 0000000000000010 RDI: ffff880156ac2000
[   23.832677] RBP: ffff880156a499b8 R08: 0000000000000100 R09: 0000000000000001
[   23.832704] R10: 0000000000000632 R11: 0000000000000000 R12: 0000000000000000
[   23.832730] R13: 0000000000000010 R14: ffff880156a5c000 R15: ffff880156a5c000
[   23.832758] FS:  00007f223b7ec700(0000) GS:ffff88015bc00000(0000)
knlGS:0000000000000000
[   23.832792] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.832814] CR2: 000000000000008e CR3: 00000001577c9000 CR4: 00000000000406f0
[   23.832841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.832867] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.832895] Process modprobe (pid: 473, threadinfo
ffff880156a48000, task ffff8801574f4410)
[   23.832925] Stack:
[   23.832936]  ffff880157aa8000 0000000000000000 ffffffffa044bb00
ffff880156ac2000
[   23.832979]  ffff880157aa8000 0000000000000000 ffffffffa044bb00
ffff880156a5c000
[   23.833022]  ffff880156a499d8 ffffffffa03b47f7 ffff880156ac2000
ffff880156ac2000
[   23.833065] Call Trace:
[   23.833103]  [<ffffffffa03b47f7>] +0x57/0x120 [radeon]
[   23.833147]  [<ffffffffa03addda>] radeon_lvds_get_modes+0x2a/0x280 [radeon]
[   23.833178]  [<ffffffffa0202bbc>]
drm_helper_probe_single_connector_modes+0xdc/0x380 [drm_kms_helper]
[   23.833215]  [<ffffffff812d34f2>] ? fb_get_options+0x22/0x110
[   23.833240]  [<ffffffffa020159b>]
drm_fb_helper_initial_config+0x2ab/0x780 [drm_kms_helper]
[   23.833274]  [<ffffffff81135874>] ? __kmalloc+0x134/0x1d0
[   23.833297]  [<ffffffffa0200639>] ? drm_fb_helper_init+0x119/0x210
[drm_kms_helper]
[   23.833327]  [<ffffffff81135654>] ? kmem_cache_alloc_trace+0xc4/0x110
[   23.833368]  [<ffffffffa03bb677>] radeon_fbdev_init+0xb7/0x100 [radeon]
[   23.833410]  [<ffffffffa03b5198>] radeon_modeset_init+0x558/0x910 [radeon]
[   23.833456]  [<ffffffffa042125a>] ? radeon_acpi_init+0x8a/0xc0 [radeon]
[   23.833496]  [<ffffffffa038df38>] radeon_driver_load_kms+0xf8/0x170 [radeon]
[   23.833532]  [<ffffffffa0151610>] drm_get_pci_dev+0x190/0x2b0 [drm]
[   23.833558]  [<ffffffff81135654>] ? kmem_cache_alloc_trace+0xc4/0x110
[   23.833598]  [<ffffffffa0421362>] radeon_pci_probe+0xb4/0x30e [radeon]
[   23.833628]  [<ffffffff812bad5f>] local_pci_probe+0x5f/0xd0
[   23.833652]  [<ffffffff812bbf08>] pci_device_probe+0x88/0xb0
[   23.833679]  [<ffffffff81360aca>] ? driver_sysfs_add+0x7a/0xb0
[   23.833705]  [<ffffffff81360c26>] driver_probe_device+0x96/0x1c0
[   23.833732]  [<ffffffff81360deb>] __driver_attach+0x9b/0xa0
[   23.833755]  [<ffffffff81360d50>] ? driver_probe_device+0x1c0/0x1c0
[   23.833780]  [<ffffffff81360048>] bus_for_each_dev+0x68/0x90
[   23.833805]  [<ffffffff81360a4e>] driver_attach+0x1e/0x20
[   23.833827]  [<ffffffff8136032d>] bus_add_driver+0xcd/0x270
[   23.833851]  [<ffffffff81361480>] driver_register+0x80/0x150
[   23.833878]  [<ffffffff812bc196>] __pci_register_driver+0x56/0xd0
[   23.833903]  [<ffffffff81569725>] ? printk+0x41/0x44
[   23.833932]  [<ffffffffa015184a>] drm_pci_init+0x11a/0x130 [drm]
[   23.833960]  [<ffffffffa01a4000>] ? 0xffffffffa01a3fff
[   23.833995]  [<ffffffffa01a40e7>] radeon_init+0xe7/0xe9 [radeon]
[   23.834024]  [<ffffffff81002043>] do_one_initcall+0x43/0x190
[   23.834051]  [<ffffffff81098e7b>] sys_init_module+0xbb/0x200
[   23.835843]  [<ffffffff81574542>] system_call_fastpath+0x16/0x1b
[   23.837627] Code: 89 e7 48 89 42 08 48 89 10 48 b8 00 01 10 00 00
00 ad de 49 89 44 24 08 4d 89 7c 24 10 e8 13 d3 fd e0 4d 85 ed 0f 84
f2 00 00 00
[   23.837826]  0f b6 4d 7e 4c 8b 3b be d0 80 00 00 83 c1 01 c1 e1 07 48 63
[   23.840004] RIP  [<ffffffffa0158ff6>]
drm_mode_connector_update_edid_property+0x76/0x1c0 [drm]
[   23.840004]  RSP <ffff880156a49978>
[   23.840004] CR2: 000000000000008e
[   23.847502] ---[ end trace 34ab89fdff52c124 ]---

-- 
Thanks,

Steve
