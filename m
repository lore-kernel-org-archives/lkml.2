Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1HQOKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:10:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1HQOKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:10:16 -0400
Date: Wed, 17 Aug 2011 10:10:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: backlight duplicate registration
Message-ID: <20110817141010.GA21479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>, Keith Packard <keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has started showing up on my laptop in the last day or two
(probably since aaa6fd2a004147bf32fce05720938236de3361d9)

	Dave

vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x97/0xab()
Hardware name: Adamo 13   
sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit i2c_core video
Pid: 137, comm: modprobe Not tainted 3.1.0-rc2+ #137
Call Trace:
 [<ffffffff8105df5c>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8105e017>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff811a58a8>] sysfs_add_one+0x97/0xab
 [<ffffffff811a5930>] create_dir+0x74/0xad
 [<ffffffff811a5a1a>] sysfs_create_dir+0x90/0xa7
 [<ffffffff8126ff74>] kobject_add_internal+0xcb/0x18c
 [<ffffffff8127036e>] kobject_add+0x91/0xa2
 [<ffffffff8133729f>] device_add+0xd5/0x576
 [<ffffffff813419b9>] ? pm_runtime_init+0x106/0x10a
 [<ffffffff8133775b>] device_register+0x1b/0x1f
 [<ffffffff812b788f>] backlight_device_register+0x10f/0x17f
 [<ffffffffa009af3b>] intel_panel_setup_backlight+0x7d/0xd2 [i915]
 [<ffffffffa00904c5>] intel_modeset_init+0xd62/0xe73 [i915]
 [<ffffffffa006e385>] i915_driver_load+0x8f4/0xdc0 [i915]
 [<ffffffff8133775b>] ? device_register+0x1b/0x1f
 [<ffffffffa0026c4a>] drm_get_pci_dev+0x170/0x26c [drm]
 [<ffffffffa00a4ab7>] i915_pci_probe+0x1b/0x1d [i915]
 [<ffffffff81291bc7>] local_pci_probe+0x44/0x75
 [<ffffffff8129274a>] pci_device_probe+0xcd/0xfc
 [<ffffffff813397aa>] driver_probe_device+0xb5/0x150
 [<ffffffff813398a3>] __driver_attach+0x5e/0x81
 [<ffffffff81339845>] ? driver_probe_device+0x150/0x150
 [<ffffffff813389c2>] bus_for_each_dev+0x59/0x8f
 [<ffffffff8133945b>] driver_attach+0x1e/0x20
 [<ffffffff8133909c>] bus_add_driver+0xb0/0x206
 [<ffffffff81339d4a>] driver_register+0x98/0x105
 [<ffffffff8129301d>] __pci_register_driver+0x66/0xd1
 [<ffffffffa0026dd0>] drm_pci_init+0x8a/0xef [drm]
 [<ffffffffa00d0000>] ? 0xffffffffa00cffff
 [<ffffffff8109c883>] sys_init_module+0x114/0x267
 [<ffffffff814ef542>] system_call_fastpath+0x16/0x1b
---[ end trace a98c7fa70c5006a7 ]---
kobject_add_internal failed for intel_backlight with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 137, comm: modprobe Tainted: G        W   3.1.0-rc2+ #137
Call Trace:
 [<ffffffff81270005>] kobject_add_internal+0x15c/0x18c
 [<ffffffff8127036e>] kobject_add+0x91/0xa2
 [<ffffffff8133729f>] device_add+0xd5/0x576
 [<ffffffff813419b9>] ? pm_runtime_init+0x106/0x10a
 [<ffffffff8133775b>] device_register+0x1b/0x1f
 [<ffffffff812b788f>] backlight_device_register+0x10f/0x17f
 [<ffffffffa009af3b>] intel_panel_setup_backlight+0x7d/0xd2 [i915]
 [<ffffffffa00904c5>] intel_modeset_init+0xd62/0xe73 [i915]
 [<ffffffffa006e385>] i915_driver_load+0x8f4/0xdc0 [i915]
 [<ffffffff8133775b>] ? device_register+0x1b/0x1f
 [<ffffffffa0026c4a>] drm_get_pci_dev+0x170/0x26c [drm]
 [<ffffffffa00a4ab7>] i915_pci_probe+0x1b/0x1d [i915]
 [<ffffffff81291bc7>] local_pci_probe+0x44/0x75
 [<ffffffff8129274a>] pci_device_probe+0xcd/0xfc
 [<ffffffff813397aa>] driver_probe_device+0xb5/0x150
 [<ffffffff813398a3>] __driver_attach+0x5e/0x81
 [<ffffffff81339845>] ? driver_probe_device+0x150/0x150
 [<ffffffff813389c2>] bus_for_each_dev+0x59/0x8f
 [<ffffffff8133945b>] driver_attach+0x1e/0x20
 [<ffffffff8133909c>] bus_add_driver+0xb0/0x206
 [<ffffffff81339d4a>] driver_register+0x98/0x105
 [<ffffffff8129301d>] __pci_register_driver+0x66/0xd1
 [<ffffffffa0026dd0>] drm_pci_init+0x8a/0xef [drm]
 [<ffffffffa00d0000>] ? 0xffffffffa00cffff
 [<ffffffffa00d008b>] i915_init+0x8b/0x8d [i915]
 [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
 [<ffffffffa00d0000>] ? 0xffffffffa00cffff
 [<ffffffff8109c883>] sys_init_module+0x114/0x267
 [<ffffffff814ef542>] system_call_fastpath+0x16/0x1b
[drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: -17

