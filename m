Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2JJNNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:13:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37026 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2JJNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:13:30 -0400
MIME-Version: 1.0
From: Marti Raudsepp <marti@juffo.org>
Date: Wed, 10 Oct 2012 16:12:49 +0300
Message-ID: <CABRT9RAs9=hWjaC8rd58HZw1+fMJRSv_0gOp=KVMg6QzKud8DQ@mail.gmail.com>
Subject: Ivy Bridge resume from suspend: PCH PLL state for reg c6014 assertion failure
To: Kernel hackers <linux-kernel@vger.kernel.org>,
        linux-opengl list <linux-opengl@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list!

I got this oops report in 3.6.1 when suspending my machine from suspend:
ACPI: Low-level resume complete
[...]
i915 0000:00:02.0: setting latency timer to 64
[...]
[drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:1076
assert_pch_pll+0x18f/0x1f0 [i915]()
Hardware name: To Be Filled By O.E.M.
PCH PLL state for reg c6014 assertion failure (expected on, current
off), val=04800080
Modules linked in: pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) fuse w83627ehf dm_mod hid_generic usbhid hid
snd_hda_codec_hdmi snd_hda_codec_realtek i915 snd_hda_intel
snd_hda_codec intel_agp intel_gtt i2c_algo_bit snd_hwdep snd_pcm
snd_page_alloc r8169 drm_kms_helper drm snd_timer i2c_i801 e1000e mii
acpi_cpufreq mei snd iTCO_wdt microcode aesni_intel aes_x86_64
aes_generic iTCO_vendor_support mperf ablk_helper ghash_clmulni_intel
soundcore i2c_core lpc_ich cryptd kvm_intel kvm coretemp crc32c_intel
pcspkr processor psmouse serio_raw video evdev button k10temp
hwmon_vid ehci_hcd xhci_hcd usbcore usb_common ext4 crc16 jbd2 sr_mod
mbcache cdrom sd_mod ahci libahci libata scsi_mod
Call Trace:
 [<ffffffff81055c6f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81055d66>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa0328b1f>] assert_pch_pll+0x18f/0x1f0 [i915]
 [<ffffffffa032e702>] ironlake_crtc_disable+0x4f2/0x7a0 [i915]
 [<ffffffffa032ea5e>] ironlake_crtc_prepare+0xe/0x10 [i915]
 [<ffffffffa0212009>] drm_crtc_helper_set_mode+0x2c9/0x500 [drm_kms_helper]
 [<ffffffff81252e4c>] ? idr_pre_get+0x4c/0x90
 [<ffffffffa02122b3>] drm_helper_resume_force_mode+0x73/0x170 [drm_kms_helper]
 [<ffffffffa0306200>] i915_drm_thaw+0xd0/0x150 [i915]
 [<ffffffffa03065ce>] i915_resume+0x4e/0x80 [i915]
 [<ffffffffa0306616>] i915_pm_resume+0x16/0x20 [i915]
 [<ffffffff8127bb43>] pci_pm_resume+0x73/0xd0
 [<ffffffff8127bad0>] ? pci_pm_thaw+0x90/0x90
 [<ffffffff8132e8cb>] dpm_run_callback.isra.4+0x3b/0x70
 [<ffffffff8132f5c8>] device_resume+0xa8/0x160
 [<ffffffff8132f6a1>] async_resume+0x21/0x50
 [<ffffffff810814be>] async_run_entry_fn+0x8e/0x1b0
 [<ffffffff81073609>] process_one_work+0x139/0x500
 [<ffffffff81485e9e>] ? mutex_unlock+0xe/0x10
 [<ffffffff81081430>] ? async_schedule+0x20/0x20
 [<ffffffff81073d9e>] worker_thread+0x15e/0x460
 [<ffffffff81073c40>] ? rescuer_thread+0x230/0x230
 [<ffffffff810796b3>] kthread+0x93/0xa0
 [<ffffffff81490c84>] kernel_thread_helper+0x4/0x10
 [<ffffffff81079620>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81490c80>] ? gs_change+0x13/0x13
---[ end trace 06d9b7162955a86e ]---

Using Arch Linux x86_64 (testing repos enabled), Ivy Bridge i5-3570K
CPU with built-in Intel HD Graphics 4000. Mesa 9.0, X.org 1.13,
xf86-video-intel 2.20.9, libdrm 2.4.39

Using two monitors via DVI and HDMI ports.

The machine resumed successfully despite the warning and there were no
obvious graphics problems.

However, I also had a complete machine hang 5 hours later -- not sure
if the two events are related. This time no oops, no panic. Graphics
was frozen, sound card looping a single buffer over and over. So I
have nothing to report on that front.

Regards,
Marti
