Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1AWEx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 23:53:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1AWEx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 23:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :user-agent;
        b=ocn4tBGNeLHcGwzdrn3nzB/+Q+UJYi8+BOuVaPvPnjhu9yPqX6qvNYfrYFGAveRBT3
         a+8zDTC3j9iLt58Smy7ndkM8uoC44tkoG8PWADIxcEFpvZ3FrT1Z/IZJiwlV9HuwiusA
         bejCBgYViQTAkXelala2YSWZHaceFxjS3/tvQ=
Date: Sun, 23 Jan 2011 08:15:39 +0330
From: Ali Gholami Rudi <aliqrudi@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ali Gholami Rudi <aliqrudi@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
Message-ID: <20112301081539@lilem.mirepesht>
In-Reply-To: <20110121045754.GA9897@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <1295033065-13450-2-git-send-email-mjg@redhat.com> <20112101000015@lilem.mirepesht> <20112101004346@lilem.mirepesht> <20110120151349.49cf3ebb.akpm@linux-foundation.org> <20110121004359.GA6422@srcf.ucam.org> <20110120170337.94d83333.akpm@linux-foundation.org>
	<20110121045754.GA9897@srcf.ucam.org>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now I'm getting this in my dmesg (1/5 and 2/5 still applied to -rc1):

	ACPI: thermal control disabled
	Non-volatile memory driver v1.3
	Linux agpgart interface v0.103
	agpgart-intel 0000:00:00.0: Intel 965GME/GLE Chipset
	agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
	agpgart-intel 0000:00:00.0: detected 8192K stolen memory
	agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
	[drm] Initialized drm 1.1.0 20060810
	i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
	i915 0000:00:02.0: setting latency timer to 64
	ioremap error for 0x3f7c5000-0x3f7c8000, requested 0x10, got 0x0
	i915 0000:00:02.0: irq 42 for MSI/MSI-X
	[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
	[drm] Driver supports precise vblank timestamp query.
	ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
	ACPI: Battery Slot [C245] (battery present)
	------------[ cut here ]------------
	WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x6e/0x83()
	Hardware name: Compaq 610
	sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight'
	Modules linked in:
	Pid: 1, comm: swapper Not tainted 2.6.38-rc1+ #47
	Call Trace:
	 [<c1026828>] ? warn_slowpath_common+0x65/0x7a
	 [<c10b9404>] ? sysfs_add_one+0x6e/0x83
	 [<c10268a1>] ? warn_slowpath_fmt+0x26/0x2a
	 [<c10b9404>] ? sysfs_add_one+0x6e/0x83
	 [<c10b9b6d>] ? create_dir+0x56/0x89
	 [<c10b9c1f>] ? sysfs_create_dir+0x7f/0x94
	 [<c1111b14>] ? kobject_add_internal+0xab/0x15a
	 [<c1111c74>] ? kobject_add_varg+0x31/0x3d
	 [<c1111cea>] ? kobject_add+0x43/0x49
	 [<c11c1e14>] ? device_add+0x8f/0x4c0
	 [<c101dd19>] ? complete_all+0x35/0x3f
	 [<c11c7983>] ? device_pm_init+0x26/0x37
	 [<c11c2257>] ? device_register+0x12/0x15
	 [<c11354a1>] ? backlight_device_register+0xe4/0x133
	 [<c11b141a>] ? intel_panel_setup_backlight+0x58/0xa1
	 [<c11a74b1>] ? intel_modeset_init+0xa46/0xbca
	 [<c119297c>] ? i915_driver_load+0xab5/0xc0c
	 [<c1189140>] ? drm_get_pci_dev+0x130/0x20f
	 [<c12e3c47>] ? i915_pci_probe+0xd/0xf
	 [<c1122356>] ? local_pci_probe+0xe/0x10
	 [<c11229a4>] ? pci_device_probe+0x43/0x66
	 [<c11c3b43>] ? driver_probe_device+0x81/0xfd
	 [<c11c3c02>] ? __driver_attach+0x43/0x5f
	 [<c11c3533>] ? bus_for_each_dev+0x3d/0x67
	 [<c11c39fb>] ? driver_attach+0x14/0x16
	 [<c11c3bbf>] ? __driver_attach+0x0/0x5f
	 [<c11c2fc6>] ? bus_add_driver+0x9d/0x1cd
	 [<c11c3e2f>] ? driver_register+0x79/0xe0
	 [<c1122b69>] ? __pci_register_driver+0x38/0x95
	 [<c118924c>] ? drm_pci_init+0x2d/0x85
	 [<c11836b7>] ? drm_init+0x4c/0x4e
	 [<c14df3de>] ? i915_init+0x67/0x69
	 [<c100115e>] ? do_one_initcall+0x71/0x113
	 [<c14df377>] ? i915_init+0x0/0x69
	 [<c14c530a>] ? kernel_init+0x109/0x185
	 [<c14c5201>] ? kernel_init+0x0/0x185
	 [<c1002cb6>] ? kernel_thread_helper+0x6/0x10
	---[ end trace a1a080aaf8d35408 ]---
	kobject_add_internal failed for intel_backlight with -EEXIST, don't try to register things with the same name in the same directory.
	Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc1+ #47
	Call Trace:
	 [<c1111b7a>] ? kobject_add_internal+0x111/0x15a
	 [<c1111b9b>] ? kobject_add_internal+0x132/0x15a
	 [<c1111c74>] ? kobject_add_varg+0x31/0x3d
	 [<c1111cea>] ? kobject_add+0x43/0x49
	 [<c11c1e14>] ? device_add+0x8f/0x4c0
	 [<c101dd19>] ? complete_all+0x35/0x3f
	 [<c11c7983>] ? device_pm_init+0x26/0x37
	 [<c11c2257>] ? device_register+0x12/0x15
	 [<c11354a1>] ? backlight_device_register+0xe4/0x133
	 [<c11b141a>] ? intel_panel_setup_backlight+0x58/0xa1
	 [<c11a74b1>] ? intel_modeset_init+0xa46/0xbca
	 [<c119297c>] ? i915_driver_load+0xab5/0xc0c
	 [<c1189140>] ? drm_get_pci_dev+0x130/0x20f
	 [<c12e3c47>] ? i915_pci_probe+0xd/0xf
	 [<c1122356>] ? local_pci_probe+0xe/0x10
	 [<c11229a4>] ? pci_device_probe+0x43/0x66
	 [<c11c3b43>] ? driver_probe_device+0x81/0xfd
	 [<c11c3c02>] ? __driver_attach+0x43/0x5f
	 [<c11c3533>] ? bus_for_each_dev+0x3d/0x67
	 [<c11c39fb>] ? driver_attach+0x14/0x16
	 [<c11c3bbf>] ? __driver_attach+0x0/0x5f
	 [<c11c2fc6>] ? bus_add_driver+0x9d/0x1cd
	 [<c11c3e2f>] ? driver_register+0x79/0xe0
	 [<c1122b69>] ? __pci_register_driver+0x38/0x95
	 [<c118924c>] ? drm_pci_init+0x2d/0x85
	 [<c11836b7>] ? drm_init+0x4c/0x4e
	 [<c14df3de>] ? i915_init+0x67/0x69
	 [<c100115e>] ? do_one_initcall+0x71/0x113
	 [<c14df377>] ? i915_init+0x0/0x69
	 [<c14c530a>] ? kernel_init+0x109/0x185
	 [<c14c5201>] ? kernel_init+0x0/0x185
	 [<c1002cb6>] ? kernel_thread_helper+0x6/0x10
	[drm:intel_panel_setup_backlight] *ERROR* Failed to register backlight: -17
	vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
	[drm] initialized overlay support
	Console: switching to colour frame buffer device 170x48
	fb0: inteldrmfb frame buffer device
	drm: registered panic notifier
	[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

Thanks,
Ali

