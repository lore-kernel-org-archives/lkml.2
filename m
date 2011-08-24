Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1HXNWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:22:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39583 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1HXNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:22:27 -0400
MIME-Version: 1.0
Date: Wed, 24 Aug 2011 14:22:26 +0100
Message-ID: <CAPM=9tz6r60CvNuoCcg+6tckQAyCZwZjK4K3_ZA9dzkFn-B+Rg@mail.gmail.com>
Subject: oops on rmmod iwlagn on 3.1.0-rc3
From: Dave Airlie <airlied@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running close to latest linus, just rmmod iwlagn.

Dave.

[10878.480981] cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[10878.492479] IP: [<ffffffff812d96bc>] dev_set_drvdata+0x26/0x34
[10878.493988] PGD 21786a067 PUD 0
[10878.495646] Oops: 0002 [#1] SMP
[10878.497272] CPU 0
[10878.497287] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi tun fuse bridge stp llc sunrpc cpufreq_ondemand
acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables arc4 iwlagn(-) mac80211
snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel qcserial
snd_hda_codec usb_wwan uvcvideo usbserial snd_hwdep aes_generic
snd_seq ecb snd_seq_device microcode videodev btusb bluetooth
v4l2_compat_ioctl32 cfg80211 snd_pcm joydev thinkpad_acpi iTCO_wdt
intel_ips i2c_i801 iTCO_vendor_support snd_timer e1000e rfkill snd
snd_page_alloc soundcore kvm_intel kvm ipv6 sdhci_pci sdhci mmc_core
nouveau i915 ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi
video [last unloaded: scsi_wait_scan]
[10878.506228]
[10878.507687] Pid: 12262, comm: rmmod Tainted: G        W
3.1.0-rc3+ #13 LENOVO 2904HHM/2904HHM
[10878.509248] RIP: 0010:[<ffffffff812d96bc>]  [<ffffffff812d96bc>]
dev_set_drvdata+0x26/0x34
[10878.510816] RSP: 0018:ffff8802160b9d78  EFLAGS: 00010202
[10878.512331] RAX: 0000007ff7a141b5 RBX: ffff880200000091 RCX: 000000000000f733
[10878.513877] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880200000091
[10878.515363] RBP: ffff8802160b9d88 R08: 0000000000000002 R09: 0000ffff00066c0a
[10878.516904] R10: 0000ffff00066c0a R11: ffff88022d4c29c0 R12: 0000000000000000
[10878.518411] R13: ffff88022e7b8000 R14: ffffffffa04ce418 R15: 0000000000000008
[10878.519931] FS:  00007fe239e82720(0000) GS:ffff88023bc00000(0000)
knlGS:0000000000000000
[10878.521438] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10878.522995] CR2: 0000007ff7a1423d CR3: 0000000217298000 CR4: 00000000000006f0
[10878.524540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10878.526163] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10878.527726] Process rmmod (pid: 12262, threadinfo ffff8802160b8000,
task ffff88022cc80000)
[10878.529305] Stack:
[10878.530927]  ffff88022d4c29c0 ffffffffa04ce340 ffff8802160b9da8
ffffffffa04b9ce6
[10878.532500]  0000000000000001 ffff88022e7b8090 ffff8802160b9dd8
ffffffff812427e6
[10878.534027]  ffffffff81b3ff20 ffff88022e7b8090 ffffffffa04ce3a0
ffff88022e7b80f0
[10878.535529] Call Trace:
[10878.537025]  [<ffffffffa04b9ce6>] iwl_pci_remove+0x5b/0x68 [iwlagn]
[10878.538532]  [<ffffffff812427e6>] pci_device_remove+0x3d/0x8f
[10878.540205]  [<ffffffff812d978b>] __device_release_driver+0x86/0xcf
[10878.541716]  [<ffffffff812d9e64>] driver_detach+0x82/0xaa
[10878.543238]  [<ffffffff812d9650>] bus_remove_driver+0xb7/0xdb
[10878.544761]  [<ffffffff81170854>] ? release_sysfs_dirent+0x92/0xb0
[10878.546301]  [<ffffffff812da4fc>] driver_unregister+0x6a/0x72
[10878.547809]  [<ffffffff812429b4>] pci_unregister_driver+0x44/0x89
[10878.549332]  [<ffffffffa04acc54>]
iwl_pci_unregister_driver+0x15/0x19 [iwlagn]
[10878.550867]  [<ffffffffa04b9cfc>] iwl_exit+0x9/0x10 [iwlagn]
[10878.552389]  [<ffffffff8107cc44>] sys_delete_module+0x1ba/0x22c
[10878.553919]  [<ffffffff81095700>] ? audit_syscall_entry+0x145/0x171
[10878.555438]  [<ffffffff8145c6c2>] system_call_fastpath+0x16/0x1b
[10878.556959] Code: 00 00 00 5d c3 55 48 89 e5 41 54 53 66 66 66 66
90 48 83 7f 08 00 48 89 fb 49 89 f4 75 09 e8 4e dc ff ff 85 c0 75 0d
48 8b 43 08 <4c> 89 a0 88 00 00 00 31 c0 5b 41 5c 5d c3 55 48 89 e5 53
52 66
[10878.560483] RIP  [<ffffffff812d96bc>] dev_set_drvdata+0x26/0x34
[10878.562200]  RSP <ffff8802160b9d78>
[10878.563920] CR2: 0000007ff7a1423d
[10878.626994] ---[ end trace e82e7c34f2061c1f ]---
