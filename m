Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1HWFE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:04:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53884 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HWFEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:04:50 -0400
MIME-Version: 1.0
Date: Tue, 23 Aug 2011 01:04:49 -0400
Message-ID: <CAHFgRy_-=6re9DhGywq4CaQFc8Gv57R1NFa3mUtNbShBA73NtA@mail.gmail.com>
Subject: 3.1.0-rc3 -- WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>, Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
Hardware name: UL50VT
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
Modules linked in:
Pid: 1, comm: swapper Not tainted 3.1.0-rc3 #2
Call Trace:
 [<ffffffff81039084>] warn_slowpath_common+0x7e/0x96
 [<ffffffff81039130>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff81149f45>] sysfs_add_one+0x92/0xa6
 [<ffffffff81149fc8>] create_dir+0x6f/0xa8
 [<ffffffff8114a0a8>] sysfs_create_dir+0x8b/0xa2
 [<ffffffff811f9478>] kobject_add_internal+0xcb/0x18c
 [<ffffffff811f9872>] kobject_add+0x91/0xa2
 [<ffffffff812d5cf4>] device_add+0xc9/0x56b
 [<ffffffff81207524>] ? __raw_spin_lock_init+0x31/0x52
 [<ffffffff812d61ad>] device_register+0x17/0x1c
 [<ffffffff81230934>] backlight_device_register+0x10a/0x17a
 [<ffffffff812c96d8>] intel_panel_setup_backlight+0x78/0xcd
 [<ffffffff812bf062>] intel_modeset_init+0xd5d/0xe5f
 [<ffffffff8129da2c>] i915_driver_load+0x8d8/0xdb0
 [<ffffffff812d61ad>] ? device_register+0x17/0x1c
 [<ffffffff8128ee0a>] drm_get_pci_dev+0x16b/0x267
 [<ffffffff813fbbba>] i915_pci_probe+0x1b/0x1d
 [<ffffffff812169bf>] pci_device_probe+0x57/0x82
 [<ffffffff812d7e16>] ? driver_sysfs_add+0x6b/0x90
 [<ffffffff812d802c>] driver_probe_device+0xa5/0x135
 [<ffffffff812d8115>] __driver_attach+0x59/0x7c
 [<ffffffff812d80bc>] ? driver_probe_device+0x135/0x135
 [<ffffffff812d72bf>] bus_for_each_dev+0x54/0x88
 [<ffffffff812d7d24>] driver_attach+0x19/0x1b
 [<ffffffff812d79a6>] bus_add_driver+0xab/0x201
 [<ffffffff812d8567>] driver_register+0x93/0x100
 [<ffffffff812171ff>] __pci_register_driver+0x61/0xce
 [<ffffffff8128ef86>] drm_pci_init+0x80/0xe5
 [<ffffffff81ad8aeb>] ? drm_core_init+0x128/0x128
 [<ffffffff81ad8b76>] i915_init+0x8b/0x8d
 [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
 [<ffffffff81ab2ba6>] kernel_init+0x9b/0x115
 [<ffffffff814184b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81410c21>] ? retint_restore_args+0xe/0xe
 [<ffffffff81ab2b0b>] ? start_kernel+0x392/0x392
 [<ffffffff814184b0>] ? gs_change+0xb/0xb
---[ end trace 45a7fa691fcd0399 ]---
kobject_add_internal failed for intel_backlight with -EEXIST, don't
try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W   3.1.0-rc3 #2
Call Trace:
 [<ffffffff811f9509>] kobject_add_internal+0x15c/0x18c
 [<ffffffff811f9872>] kobject_add+0x91/0xa2
 [<ffffffff812d5cf4>] device_add+0xc9/0x56b
 [<ffffffff81207524>] ? __raw_spin_lock_init+0x31/0x52
 [<ffffffff812d61ad>] device_register+0x17/0x1c
 [<ffffffff81230934>] backlight_device_register+0x10a/0x17a
 [<ffffffff812c96d8>] intel_panel_setup_backlight+0x78/0xcd
 [<ffffffff812bf062>] intel_modeset_init+0xd5d/0xe5f
 [<ffffffff8129da2c>] i915_driver_load+0x8d8/0xdb0
 [<ffffffff812d61ad>] ? device_register+0x17/0x1c
 [<ffffffff8128ee0a>] drm_get_pci_dev+0x16b/0x267
 [<ffffffff813fbbba>] i915_pci_probe+0x1b/0x1d
 [<ffffffff812169bf>] pci_device_probe+0x57/0x82
 [<ffffffff812d7e16>] ? driver_sysfs_add+0x6b/0x90
 [<ffffffff812d802c>] driver_probe_device+0xa5/0x135
 [<ffffffff812d8115>] __driver_attach+0x59/0x7c
 [<ffffffff812d80bc>] ? driver_probe_device+0x135/0x135
 [<ffffffff812d72bf>] bus_for_each_dev+0x54/0x88
 [<ffffffff812d7d24>] driver_attach+0x19/0x1b
 [<ffffffff812d79a6>] bus_add_driver+0xab/0x201
 [<ffffffff812d8567>] driver_register+0x93/0x100
 [<ffffffff812171ff>] __pci_register_driver+0x61/0xce
 [<ffffffff8128ef86>] drm_pci_init+0x80/0xe5
 [<ffffffff81ad8aeb>] ? drm_core_init+0x128/0x128
 [<ffffffff81ad8b76>] i915_init+0x8b/0x8d
 [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
 [<ffffffff81ab2ba6>] kernel_init+0x9b/0x115
 [<ffffffff814184b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81410c21>] ? retint_restore_args+0xe/0xe
 [<ffffffff81ab2b0b>] ? start_kernel+0x392/0x392
 [<ffffffff814184b0>] ? gs_change+0xb/0xb
[drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: -17
