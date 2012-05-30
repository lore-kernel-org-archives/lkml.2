Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2E3Vbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2E3Vbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:31:34 -0400
Date: Wed, 30 May 2012 17:31:28 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Lots of i915/drm spew on 3.4
Message-ID: <20120530213128.GA10407@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this hardware:

00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)

I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)

[    8.046291] udevadm used greatest stack depth: 4952 bytes left
[    8.153209] [drm] Initialized drm 1.1.0 20060810
[    8.491107] i915 0000:00:02.0: setting latency timer to 64
[    8.495118] console_init used greatest stack depth: 4784 bytes left
[    8.751664] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.751756] [drm] Driver supports precise vblank timestamp query.
[    8.754836] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.992409] ------------[ cut here ]------------
[    8.992519] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    8.992634] Hardware name:         
[    8.992702] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    8.992877] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    8.992989] Pid: 126, comm: udevd Not tainted 3.4.0+ #3
[    8.993711] Call Trace:
[    8.993790]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    8.993872]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    8.993971]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    8.994113]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    8.994270]  [<ffffffffa00a8f34>] intel_sdvo_create_enhance_property+0xde4/0xe20 [i915]
[    8.994404]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    8.994524]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    8.994643]  [<ffffffffa00aa78d>] intel_sdvo_init+0x4fd/0x7c0 [i915]
[    8.994759]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    8.994868]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    8.994965]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    8.995105]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    8.995189]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    8.995302]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    8.995385]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    8.995464]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    8.995547]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    8.995628]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    8.995708]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    8.995788]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    8.995867]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    8.995945]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    8.996068]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    8.996151]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    8.996230]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    8.996309]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    8.996388]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    8.996468]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    8.996561]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    8.996642]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    8.996751]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    8.996833]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    8.996915]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    8.996996]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    8.997119]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    8.997208]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    8.997284] ---[ end trace 533bf7565e4f928e ]---
[    9.002178] ------------[ cut here ]------------
[    9.002272] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    9.002385] Hardware name:         
[    9.002453] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    9.002626] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    9.002738] Pid: 126, comm: udevd Tainted: G        W    3.4.0+ #3
[    9.002811] Call Trace:
[    9.002885]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    9.002965]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    9.003105]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    9.003205]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    9.003358]  [<ffffffffa00a834e>] intel_sdvo_create_enhance_property+0x1fe/0xe20 [i915]
[    9.003491]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    9.003611]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    9.003729]  [<ffffffffa00aa78d>] intel_sdvo_init+0x4fd/0x7c0 [i915]
[    9.003845]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    9.003953]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    9.004094]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    9.004194]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    9.004275]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    9.004388]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    9.004469]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    9.004549]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    9.004630]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    9.004711]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    9.004790]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    9.004870]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    9.004949]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.005068]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    9.005148]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    9.005227]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.005307]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    9.005387]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.005465]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    9.005545]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.005638]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    9.005719]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.005828]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    9.005908]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    9.005990]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    9.006115]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    9.006199]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    9.006286]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    9.006363] ---[ end trace 533bf7565e4f928f ]---
[    9.163969] ------------[ cut here ]------------
[    9.164116] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    9.164233] Hardware name:         
[    9.164300] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    9.164476] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    9.164588] Pid: 126, comm: udevd Tainted: G        W    3.4.0+ #3
[    9.164662] Call Trace:
[    9.164738]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    9.164820]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    9.164917]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    9.165016]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    9.165213]  [<ffffffffa00a8f34>] intel_sdvo_create_enhance_property+0xde4/0xe20 [i915]
[    9.165349]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    9.165469]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    9.165587]  [<ffffffffa00aa7a4>] intel_sdvo_init+0x514/0x7c0 [i915]
[    9.165703]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    9.165812]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    9.165909]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    9.166006]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    9.166133]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    9.166249]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    9.166331]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    9.166411]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    9.166494]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    9.166574]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    9.166654]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    9.166734]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    9.166814]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.166891]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    9.166969]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    9.167090]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.167170]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    9.167250]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.167329]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    9.167409]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.167502]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    9.167583]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.167691]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    9.167773]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    9.167854]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    9.167936]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    9.168062]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    9.168152]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    9.168229] ---[ end trace 533bf7565e4f9290 ]---
[    9.173120] ------------[ cut here ]------------
[    9.173215] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    9.173328] Hardware name:         
[    9.173396] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    9.173570] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    9.173681] Pid: 126, comm: udevd Tainted: G        W    3.4.0+ #3
[    9.173755] Call Trace:
[    9.173828]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    9.173909]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    9.174006]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    9.174152]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    9.174305]  [<ffffffffa00a834e>] intel_sdvo_create_enhance_property+0x1fe/0xe20 [i915]
[    9.174438]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    9.174558]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    9.174677]  [<ffffffffa00aa7a4>] intel_sdvo_init+0x514/0x7c0 [i915]
[    9.174793]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    9.174902]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    9.174998]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    9.175137]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    9.175219]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    9.175332]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    9.175414]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    9.175494]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    9.175575]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    9.175655]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    9.175735]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    9.175815]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    9.175894]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.175972]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    9.176095]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    9.176178]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.176257]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    9.176336]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.176414]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    9.177143]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.177238]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    9.177319]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.177427]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    9.177508]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    9.177590]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    9.177670]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    9.177750]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    9.177837]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    9.177913] ---[ end trace 533bf7565e4f9291 ]---
[    9.335587] ------------[ cut here ]------------
[    9.335694] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    9.335808] Hardware name:         
[    9.335876] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    9.336096] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    9.336210] Pid: 126, comm: udevd Tainted: G        W    3.4.0+ #3
[    9.336284] Call Trace:
[    9.336361]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    9.336442]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    9.336540]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    9.336639]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    9.336794]  [<ffffffffa00a8f34>] intel_sdvo_create_enhance_property+0xde4/0xe20 [i915]
[    9.336927]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    9.337092]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    9.337212]  [<ffffffffa00aa7bb>] intel_sdvo_init+0x52b/0x7c0 [i915]
[    9.337328]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    9.337437]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    9.337534]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    9.337630]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    9.337713]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    9.337825]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    9.337907]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    9.337987]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    9.338115]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    9.338199]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    9.338278]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    9.338359]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    9.338438]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.338516]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    9.338594]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    9.338673]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.338752]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    9.338832]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.338910]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    9.338991]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.339125]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    9.339207]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.339316]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    9.339397]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    9.339479]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    9.339560]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    9.339641]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    9.339728]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    9.339805] ---[ end trace 533bf7565e4f9292 ]---
[    9.344699] ------------[ cut here ]------------
[    9.344794] WARNING: at drivers/gpu/drm/drm_crtc.c:2886 drm_object_attach_property+0x4d/0x50 [drm]()
[    9.344907] Hardware name:         
[    9.344974] Failed to attach object property (type: 0xc0c0c0c0). Please increase DRM_OBJECT_MAX_PROPERTY by 1 for each time you see this message on the same object type.
[    9.345189] Modules linked in: i915(+) video i2c_algo_bit drm_kms_helper drm i2c_core
[    9.345302] Pid: 126, comm: udevd Tainted: G        W    3.4.0+ #3
[    9.345375] Call Trace:
[    9.345449]  [<ffffffff8106084f>] warn_slowpath_common+0x7f/0xc0
[    9.345529]  [<ffffffff81060946>] warn_slowpath_fmt+0x46/0x50
[    9.345626]  [<ffffffffa00221dd>] drm_object_attach_property+0x4d/0x50 [drm]
[    9.345725]  [<ffffffffa00221f5>] drm_connector_attach_property+0x15/0x20 [drm]
[    9.345877]  [<ffffffffa00a834e>] intel_sdvo_create_enhance_property+0x1fe/0xe20 [i915]
[    9.346010]  [<ffffffffa002329a>] ? drm_property_add_enum+0xca/0x140 [drm]
[    9.346175]  [<ffffffffa00a9e96>] intel_sdvo_tv_init+0x1b6/0x1e0 [i915]
[    9.346295]  [<ffffffffa00aa7bb>] intel_sdvo_init+0x52b/0x7c0 [i915]
[    9.346411]  [<ffffffffa009d9fb>] intel_modeset_init+0xdcb/0xea0 [i915]
[    9.346519]  [<ffffffffa007528e>] i915_driver_load+0xa2e/0xb50 [i915]
[    9.346616]  [<ffffffffa001c111>] ? drm_get_minor+0x261/0x300 [drm]
[    9.346713]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    9.346794]  [<ffffffff810cdfad>] ? trace_hardirqs_on+0xd/0x10
[    9.346907]  [<ffffffffa00bede2>] i915_pci_probe+0x16/0x20 [i915]
[    9.346988]  [<ffffffff8135288c>] local_pci_probe+0x5c/0xd0
[    9.347109]  [<ffffffff81352a11>] pci_device_probe+0x111/0x120
[    9.347192]  [<ffffffff8141a582>] driver_probe_device+0x92/0x390
[    9.347273]  [<ffffffff8141a92b>] __driver_attach+0xab/0xb0
[    9.347353]  [<ffffffff8141a880>] ? driver_probe_device+0x390/0x390
[    9.347432]  [<ffffffff81418515>] bus_for_each_dev+0x55/0x90
[    9.347511]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.347588]  [<ffffffff81419e0e>] driver_attach+0x1e/0x20
[    9.347666]  [<ffffffff81419b18>] bus_add_driver+0x1b8/0x2b0
[    9.347745]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.347824]  [<ffffffff8141b027>] driver_register+0x77/0x150
[    9.347904]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.347982]  [<ffffffff8135160f>] __pci_register_driver+0x6f/0xf0
[    9.348106]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.348202]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[    9.348284]  [<ffffffffa00f2000>] ? 0xffffffffa00f1fff
[    9.348392]  [<ffffffffa00f208b>] i915_init+0x8b/0x8d [i915]
[    9.348473]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[    9.348555]  [<ffffffff810dbb26>] sys_init_module+0x1116/0x2210
[    9.348635]  [<ffffffff81345380>] ? ddebug_proc_open+0xd0/0xd0
[    9.348716]  [<ffffffff810c84cf>] ? lock_release_holdtime.part.26+0xf/0x180
[    9.348802]  [<ffffffff8169c729>] system_call_fastpath+0x16/0x1b
[    9.348879] ---[ end trace 533bf7565e4f9293 ]---
[    9.399547] [drm] initialized overlay support
[    9.760818] fbcon: inteldrmfb (fb0) is primary device
[    9.834778] Console: switching to colour frame buffer device 160x64
[    9.851059] fb0: inteldrmfb frame buffer device
[    9.851158] drm: registered panic notifier
[    9.851398] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

