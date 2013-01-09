Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3AILqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:46:11 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2124 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab3AILqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:46:07 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <50ED5874.5010209@broadcom.com>
Date: Wed, 9 Jan 2013 12:45:56 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ben Skeggs" <bskeggs@redhat.com>
Subject: 3.8-rc2: lockdep warning in nouveau driver
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7CF388CC39W25038919-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this one is already known, but I did not find a post about it. So
here it is.

Regards,
Arend

==========================================================================
[    9.422018] usb 1-1.2: new high-speed USB device number 4 using ehci-pci
[    9.436177] [TTM] Zone  kernel: Available graphics memory: 433698 kiB
[    9.442676] [TTM] Zone highmem: Available graphics memory: 1678052 kiB
[    9.449256] [TTM] Initializing pool allocator
[    9.455462] nouveau  [     DRM] VRAM: 512 MiB
[    9.459851] nouveau  [     DRM] GART: 512 MiB
[    9.464227] nouveau  [     DRM] BIT BIOS found
[    9.468709] nouveau  [     DRM] Bios version 70.18.53.00
[    9.474040] nouveau  [     DRM] TMDS table version 2.0
[    9.479196] nouveau  [     DRM] DCB version 4.0
[    9.483746] nouveau  [     DRM] DCB outp 00: 048003b6 0f200014
[    9.489580] nouveau  [     DRM] DCB outp 01: 02033300 00000000
[    9.495431] nouveau  [     DRM] DCB outp 02: 088223a6 0f220010
[    9.501278] nouveau  [     DRM] DCB outp 03: 08022362 00020010
[    9.507124] nouveau  [     DRM] DCB outp 04: 028113c6 0f220010
[    9.512970] nouveau  [     DRM] DCB outp 05: 02011382 00020010
[    9.518804] nouveau  [     DRM] DCB conn 00: 00002047
[    9.523059] hub 1-1.2:1.0: USB hub found
[    9.523201] hub 1-1.2:1.0: 3 ports detected
[    9.532105] nouveau  [     DRM] DCB conn 01: 00101146
[    9.537360] nouveau  [     DRM] DCB conn 02: 00410246
[    9.542450] nouveau  [     DRM] DCB conn 03: 00000300
[    9.588499]
[    9.589986] =============================================
[    9.595365] [ INFO: possible recursive locking detected ]
[    9.600745] 3.8.0-rc2-wl-testing-lockdep-00002-ga524cf0 #1 Not tainted
[    9.607248] ---------------------------------------------
[    9.612626] modprobe/163 is trying to acquire lock:
[    9.617486]  (&subdev->mutex){+.+.+.}, at: [<f8929c12>]
nv50_fb_vram_new+0x92/0x230 [nouveau]
[    9.626052]
[    9.626052] but task is already holding lock:
[    9.631865]  (&subdev->mutex){+.+.+.}, at: [<f8936505>]
nv50_disp_data_ctor+0x55/0xc0 [nouveau]
[    9.640593]
[    9.640593] other info that might help us debug this:
[    9.647096]  Possible unsafe locking scenario:
[    9.647096]
[    9.652995]        CPU0
[    9.655430]        ----
[    9.657867]   lock(&subdev->mutex);
[    9.661365]   lock(&subdev->mutex);
[    9.664863]
[    9.664863]  *** DEADLOCK ***
[    9.664863]
[    9.670762]  May be due to missing lock nesting notation
[    9.670762]
[    9.677526] 4 locks held by modprobe/163:
[    9.681520]  #0:  (&__lockdep_no_validate__){......}, at:
[<c1364f40>] __driver_attach+0x50/0xa0
[    9.690341]  #1:  (&__lockdep_no_validate__){......}, at:
[<c1364f4c>] __driver_attach+0x5c/0xa0
[    9.699156]  #2:  (drm_global_mutex){+.+.+.}, at: [<f87814b8>]
drm_get_pci_dev+0xa8/0x260 [drm]
[    9.707899]  #3:  (&subdev->mutex){+.+.+.}, at: [<f8936505>]
nv50_disp_data_ctor+0x55/0xc0 [nouveau]
[    9.717075]
[    9.717075] stack backtrace:
[    9.721417] Pid: 163, comm: modprobe Not tainted
3.8.0-rc2-wl-testing-lockdep-00002-ga524cf0 #1
[    9.730085] Call Trace:
[    9.732524]  [<c1096603>] __lock_acquire+0x12f3/0x1780
[    9.737644]  [<c10927a0>] ? noop_count+0x10/0x10
[    9.742246]  [<c1094b0b>] ? check_usage+0x6b/0x410
[    9.747021]  [<c1096f94>] lock_acquire+0x84/0x120
[    9.751721]  [<f8929c12>] ? nv50_fb_vram_new+0x92/0x230 [nouveau]
[    9.757797]  [<c1514264>] mutex_lock_nested+0x64/0x2e0
[    9.762929]  [<f8929c12>] ? nv50_fb_vram_new+0x92/0x230 [nouveau]
[    9.769012]  [<f8929bde>] ? nv50_fb_vram_new+0x5e/0x230 [nouveau]
[    9.775096]  [<f8929c12>] nv50_fb_vram_new+0x92/0x230 [nouveau]
[    9.781008]  [<f892df5e>] nv50_instobj_ctor+0xae/0xf0 [nouveau]
[    9.786918]  [<f8913f3b>] nouveau_object_ctor+0x3b/0xe0 [nouveau]
[    9.793001]  [<f892dcdd>] nv50_instmem_alloc+0x2d/0x40 [nouveau]
[    9.798996]  [<f8912922>] nouveau_gpuobj_create_+0x232/0x2b0 [nouveau]
[    9.805501]  [<c15172b6>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[    9.811574]  [<c1097834>] ? trace_hardirqs_on_caller+0xf4/0x180
[    9.817483]  [<f8911480>] nouveau_engctx_create_+0x220/0x260 [nouveau]
[    9.824002]  [<f893655f>] nv50_disp_data_ctor+0xaf/0xc0 [nouveau]
[    9.830086]  [<f8913f3b>] nouveau_object_ctor+0x3b/0xe0 [nouveau]
[    9.836168]  [<f89147e9>] nouveau_object_new+0xe9/0x220 [nouveau]
[    9.842258]  [<f89a455c>] nv50_display_create+0x18c/0x850 [nouveau]
[    9.848505]  [<c10555fa>] ? __cancel_work_timer+0x5a/0xb0
[    9.853884]  [<c1097834>] ? trace_hardirqs_on_caller+0xf4/0x180
[    9.859783]  [<c105560a>] ? __cancel_work_timer+0x6a/0xb0
[    9.865181]  [<f898d3f5>] nouveau_display_create+0x415/0x6a0 [nouveau]
[    9.871700]  [<f897e16b>] nouveau_drm_load+0x28b/0x5d0 [nouveau]
[    9.877688]  [<c1362bc7>] ? device_register+0x17/0x20
[    9.882727]  [<f8782bfa>] ? drm_sysfs_device_add+0x7a/0xa0 [drm]
[    9.888719]  [<f877f920>] ? drm_get_minor+0x220/0x2b0 [drm]
[    9.894279]  [<f878155b>] drm_get_pci_dev+0x14b/0x260 [drm]
[    9.899833]  [<c12c81c7>] ? __pci_set_master+0x27/0x80
[    9.904969]  [<f897db3e>] nouveau_drm_probe+0x20e/0x250 [nouveau]
[    9.911042]  [<c12cd6b3>] pci_device_probe+0x83/0xc0
[    9.915989]  [<c1364d64>] driver_probe_device+0x64/0x1f0
[    9.921282]  [<c1364f89>] __driver_attach+0x99/0xa0
[    9.926143]  [<c1364ef0>] ? driver_probe_device+0x1f0/0x1f0
[    9.931696]  [<c13635c2>] bus_for_each_dev+0x42/0x70
[    9.936644]  [<c1364931>] driver_attach+0x21/0x30
[    9.941333]  [<c1364ef0>] ? driver_probe_device+0x1f0/0x1f0
[    9.946885]  [<c1364557>] bus_add_driver+0x187/0x280
[    9.951831]  [<c12cc780>] ? pci_dev_put+0x20/0x20
[    9.956518]  [<c12cc780>] ? pci_dev_put+0x20/0x20
[    9.961206]  [<c136541a>] driver_register+0x6a/0x130
[    9.966153]  [<c12b8142>] ? __raw_spin_lock_init+0x32/0x60
[    9.971618]  [<c12cc90a>] __pci_register_driver+0x4a/0x50
[    9.977005]  [<f878176d>] drm_pci_init+0xfd/0x110 [drm]
[    9.982219]  [<f89e0048>] nouveau_drm_init+0x48/0x4a [nouveau]
[    9.988033]  [<c1001144>] do_one_initcall+0x34/0x170
[    9.992980]  [<f89e0000>] ? 0xf89dffff
[    9.996717]  [<c10a2013>] load_module+0x1a73/0x22a0
[   10.001579]  [<c10a28c6>] sys_init_module+0x86/0xa0
[   10.006440]  [<c151ebad>] sysenter_do_call+0x12/0x38
[   10.011744] usb 1-1.4: new high-speed USB device number 5 using ehci-pci
[   10.012623] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.012623] [drm] No driver support for vblank timestamp query.
[   10.012625] nouveau  [     DRM] ACPI backlight interface available,
not registering our own
[   10.208606] usb 2-1.7: new full-speed USB device number 3 using ehci-pci
[   10.233173] nouveau  [     DRM] 3 available performance level(s)
[   10.239278] nouveau  [     DRM] 0: core 135MHz shader 270MHz memory
135MHz voltage 850mV
[   10.247417] nouveau  [     DRM] 1: core 405MHz shader 810MHz memory
405MHz voltage 850mV
[   10.255553] nouveau  [     DRM] 3: core 606MHz shader 1468MHz memory
790MHz voltage 1000mV
[   10.263865] nouveau  [     DRM] c: core 405MHz shader 810MHz memory
405MHz voltage 1000mV
[   10.314402] nouveau  [     DRM] MM: using COPY for buffer copies
[   10.380308] usb 2-1.8: new full-speed USB device number 4 using ehci-pci
[   10.503748] usb 2-1.8: config 0 descriptor??
[   10.568285] nouveau  [     DRM] allocated 1920x1080 fb: 0x70000, bo
f717be00
[   10.575405] fbcon: nouveaufb (fb0) is primary device
[   10.837296] Console: switching to colour frame buffer device 180x56
[   10.844686] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[   10.851053] nouveau 0000:01:00.0: registered panic notifier
[   10.856646] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0
on minor 0
Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... done.

