Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2CZVc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab2CZVc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:32:57 -0400
Date: Mon, 26 Mar 2012 17:32:50 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: michel.daenzer@amd.com, jglisse@redhat.com, airlied@redhat.com
Subject: WARNING: at drivers/gpu/drm/radeon/radeon_object.c:236
Message-ID: <20120326213250.GA16328@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, michel.daenzer@amd.com,
	jglisse@redhat.com, airlied@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing this in Linus' tree as of v3.3-6972-ge22057c

[    5.244938] [drm] Initialized drm 1.1.0 20060810
[    5.317257] console_init used greatest stack depth: 4616 bytes left
[    5.369057] [drm] radeon defaulting to kernel modesetting.
[    5.374833] [drm] radeon kernel modesetting enabled.
[    5.384614] [drm] initializing kernel modesetting (RV380 0x1002:0x5B60 0x1002:0x0302).
[    5.392789] [drm] register mmio base: 0xC8210000
[    5.397689] [drm] register mmio size: 65536
[    5.402820] [drm] Generation 2 PCI interface, using max accessible memory
[    5.409659] radeon 0000:01:00.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
[    5.418416] radeon 0000:01:00.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    5.426322] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.432970] [drm] Driver supports precise vblank timestamp query.
[    5.439350] radeon 0000:01:00.0: irq 45 for MSI/MSI-X
[    5.439501] radeon 0000:01:00.0: radeon: using MSI.
[    5.444802] [drm] radeon: irq initialized.
[    5.450415] [drm] Detected VRAM RAM=128M, BAR=128M
[    5.455304] [drm] RAM width 64bits DDR
[    5.459839] [TTM] Zone  kernel: Available graphics memory: 1531086 kiB
[    5.466424] [TTM] Initializing pool allocator
[    5.470969] [TTM] Initializing DMA pool allocator
[    5.476543] [drm] radeon: 128M of VRAM memory ready
[    5.481475] [drm] radeon: 512M of GTT memory ready.
[    5.486861] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.494094] [drm] radeon: ib pool ready.
[    5.500719] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[    5.507468] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[    5.514678] radeon 0000:01:00.0: WB enabled
[    5.518901] [drm] fence driver on ring 0 use gpu addr 0xa0000000 and cpu addr 0xffff8800b3ab7000
[    5.528486] [drm] Loading R300 Microcode
[    5.549168] [drm] radeon: ring at 0x00000000A0001000
[    5.554264] [drm] ring test succeeded in 0 usecs
[    5.562762] [drm] ib test succeeded in 0 usecs
[    5.573542] [drm] Radeon Display Connectors
[    5.577880] [drm] Connector 0:
[    5.580973] [drm]   VGA
[    5.583475] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    5.589516] [drm]   Encoders:
[    5.592522] [drm]     CRT1: INTERNAL_DAC1
[    5.596581] [drm] Connector 1:
[    5.599678] [drm]   DVI-I
[    5.602337] [drm]   HPD1
[    5.604925] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    5.610963] [drm]   Encoders:
[    5.613983] [drm]     CRT2: INTERNAL_DAC2
[    5.618029] [drm]     DFP1: INTERNAL_TMDS1
[    5.622170] [drm] Connector 2:
[    5.625276] [drm]   S-video
[    5.628111] [drm]   Encoders:
[    5.631117] [drm]     TV1: INTERNAL_DAC2
[    5.716973] [drm] fb mappable at 0xC00C0000
[    5.721195] [drm] vram apper at 0xC0000000
[    5.725343] [drm] size 7057408
[    5.728439] [drm] fb depth is 24
[    5.731703] [drm]    pitch is 6720
[    5.736460] fbcon: radeondrmfb (fb0) is primary device
[    5.744023] ------------[ cut here ]------------
[    5.744054] WARNING: at drivers/gpu/drm/radeon/radeon_object.c:236 radeon_bo_pin_restricted+0x140/0x170 [radeon]()
[    5.744056] Hardware name:         
[    5.744057] Modules linked in: radeon(+) ttm drm_kms_helper drm i2c_algo_bit i2c_core
[    5.744065] Pid: 113, comm: modprobe Not tainted 3.3.0+ #18
[    5.744066] Call Trace:
[    5.744072]  [<ffffffff81047edf>] warn_slowpath_common+0x7f/0xc0
[    5.744075]  [<ffffffff81047f3a>] warn_slowpath_null+0x1a/0x20
[    5.744092]  [<ffffffffa00b89b0>] radeon_bo_pin_restricted+0x140/0x170 [radeon]
[    5.744109]  [<ffffffffa00bb8f9>] radeon_crtc_do_set_base+0xd9/0x530 [radeon]
[    5.744114]  [<ffffffff810b4d1d>] ? trace_hardirqs_on+0xd/0x10
[    5.744131]  [<ffffffffa00bbd8a>] radeon_crtc_set_base+0x1a/0x20 [radeon]
[    5.744147]  [<ffffffffa00bbdb9>] radeon_crtc_mode_set+0x29/0x8f0 [radeon]
[    5.744164]  [<ffffffffa00b182c>] ? radeon_combios_encoder_dpms_scratch_regs+0xac/0xc0 [radeon]
[    5.744181]  [<ffffffffa00bb6d8>] ? radeon_crtc_dpms+0x138/0x1c0 [radeon]
[    5.744186]  [<ffffffffa0069f1e>] drm_crtc_helper_set_mode+0x38e/0x520 [drm_kms_helper]
[    5.744190]  [<ffffffff8118ac9c>] ? deactivate_slab+0x55c/0x600
[    5.744195]  [<ffffffffa006af8f>] drm_crtc_helper_set_config+0x85f/0xb10 [drm_kms_helper]
[    5.744199]  [<ffffffffa0068a97>] drm_fb_helper_set_par+0x77/0xf0 [drm_kms_helper]
[    5.744203]  [<ffffffff81365194>] fbcon_init+0x534/0x5c0
[    5.744207]  [<ffffffff813ca95d>] visual_init+0xfd/0x2b0
[    5.744209]  [<ffffffff813cae38>] bind_con_driver+0x328/0x7d0
[    5.744213]  [<ffffffff812239f6>] ? sysfs_create_file+0x26/0x30
[    5.744216]  [<ffffffff813cbc91>] take_over_console+0x61/0x70
[    5.744218]  [<ffffffff81360d5b>] fbcon_takeover+0x5b/0xb0
[    5.744221]  [<ffffffff81365d25>] fbcon_event_notify+0x655/0x760
[    5.744224]  [<ffffffff8165e067>] notifier_call_chain+0x67/0x160
[    5.744227]  [<ffffffff81078ae2>] __blocking_notifier_call_chain+0x72/0xd0
[    5.744230]  [<ffffffff81078b56>] blocking_notifier_call_chain+0x16/0x20
[    5.744233]  [<ffffffff8135433b>] fb_notifier_call_chain+0x1b/0x20
[    5.744236]  [<ffffffff813559d8>] register_framebuffer+0x1c8/0x300
[    5.744240]  [<ffffffffa0068cc3>] drm_fb_helper_single_fb_probe+0x1b3/0x300 [drm_kms_helper]
[    5.744244]  [<ffffffffa0068fe3>] drm_fb_helper_initial_config+0x1d3/0x250 [drm_kms_helper]
[    5.744247]  [<ffffffff8118c63e>] ? kmem_cache_alloc_trace+0xde/0x2a0
[    5.744250]  [<ffffffffa006929f>] ? drm_fb_helper_single_add_all_connectors+0x4f/0x180 [drm_kms_helper]
[    5.744269]  [<ffffffffa00c9c87>] radeon_fbdev_init+0xc7/0x110 [radeon]
[    5.744287]  [<ffffffffa00c4dff>] radeon_modeset_init+0x31f/0x7d0 [radeon]
[    5.744303]  [<ffffffffa00a25b5>] radeon_driver_load_kms+0x115/0x1a0 [radeon]
[    5.744315]  [<ffffffffa00257c1>] drm_get_pci_dev+0x191/0x2a0 [drm]
[    5.744331]  [<ffffffffa0115652>] ? radeon_pci_probe+0x9a/0xb4 [radeon]
[    5.744347]  [<ffffffffa0115664>] radeon_pci_probe+0xac/0xb4 [radeon]
[    5.744351]  [<ffffffff8133a37c>] local_pci_probe+0x5c/0xd0
[    5.744354]  [<ffffffff8133bc81>] pci_device_probe+0x101/0x120
[    5.744358]  [<ffffffff813eddd8>] driver_probe_device+0x98/0x3a0
[    5.744361]  [<ffffffff813ee18b>] __driver_attach+0xab/0xb0
[    5.744364]  [<ffffffff813ee0e0>] ? driver_probe_device+0x3a0/0x3a0
[    5.744367]  [<ffffffff813ebefe>] bus_for_each_dev+0x5e/0x90
[    5.744370]  [<ffffffff813ed82e>] driver_attach+0x1e/0x20
[    5.744372]  [<ffffffff813ed360>] bus_add_driver+0x1c0/0x2b0
[    5.744375]  [<ffffffff813ee6f6>] driver_register+0x76/0x130
[    5.744379]  [<ffffffff81321c68>] ? __raw_spin_lock_init+0x38/0x70
[    5.744382]  [<ffffffff8133b946>] __pci_register_driver+0x66/0xe0
[    5.744389]  [<ffffffffa00259ea>] drm_pci_init+0x11a/0x130 [drm]
[    5.744391]  [<ffffffffa0163000>] ? 0xffffffffa0162fff
[    5.744394]  [<ffffffffa0163000>] ? 0xffffffffa0162fff
[    5.744406]  [<ffffffffa01630ec>] radeon_init+0xec/0x1000 [radeon]
[    5.744409]  [<ffffffff810001cf>] do_one_initcall+0x3f/0x170
[    5.744413]  [<ffffffff810c3840>] sys_init_module+0xc0/0x230
[    5.744416]  [<ffffffff81662492>] system_call_fastpath+0x16/0x1b
[    5.744418] ---[ end trace 7e4f3033b847a3dd ]---

