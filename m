Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1KUMh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:37:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38339 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1KUMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:37:28 -0500
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 13:37:26 +0100
Message-ID: <CAJJYPdkFpq+VJDyAP6dk3j-6YN+Ttu0ejByzEnr2HvXozYVXSg@mail.gmail.com>
Subject: WARNING: at drivers/gpu/drm/i915/intel_display.c:792
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: intel-gfx@lists.freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

My Xorg server on rawhide machine is giving me sudden X lockups with 3.1 kernel.
There might be couple issue related together as rawhide is now using
some experimental
Xorg server - but the message from kernel is a bit scary - so
reposting to lkml as well.

xorg-x11-server-Xorg-1.11.99.1-6.20111109.fc17.x86_64
git intel driver: 3b9479dc39d32fd97f80c1e5e0fac67d36ee5e40
drm version (a bit older): 8d055890d90c3d92647e3d8b98d32630ef87c2c8
(since current Fedora rawhide intel driver is so much broken it
doesn't even start)

Running desktop with only a plain  twm (no gnome-shell3 -  broken to
unusability as well).

Happened with just some mouse movement.
Might be related to https://bugzilla.redhat.com/show_bug.cgi?id=753703

My HW: Lenovo T61, gma965, 4GB, x86_64

Zdenek

[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[drm] capturing error event; look for more information in
/debug/dri/0/i915_error_state
[drm:init_ring_common] *ERROR* render ring initialization failed ctl
00000000 head 00000000 tail 00000000 start 00000000
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:792
intel_enable_pipe+0x14a/0x150 [i915]()
Hardware name: 6464CTO
PLL state assertion failure (expected on, current off)
Modules linked in: vfat fat isofs i915 drm_kms_helper drm i2c_algo_bit
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables tun bridge
stp llc lockd sunrpc snd_hda_codec_analog cryptomgr aead arc4
crypto_algapi iwl3945 iwl_legacy mac80211 psmouse iTCO_wdt usbhid
serio_raw i2c_i801 hid i2c_core snd_hda_intel snd_hda_codec cfg80211
iTCO_vendor_support e1000e snd_pcm snd_timer thinkpad_acpi snd
snd_page_alloc soundcore wmi nvram binfmt_misc evdev loop virtio_net
kvm_intel kvm uinput dm_mod ipv6 autofs4 pcmcia ehci_hcd uhci_hcd
sdhci_pci sdhci yenta_socket mmc_core usbcore sr_mod cdrom video
backlight
Pid: 24480, comm: kworker/u:0 Not tainted 3.1.0-00008-gba92ff5 #17
Call Trace:
 [<ffffffff8104f69f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104f796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa04d32ba>] intel_enable_pipe+0x14a/0x150 [i915]
 [<ffffffffa04d61f1>] i9xx_crtc_mode_set+0x6f1/0xd70 [i915]
 [<ffffffffa04cc4af>] intel_crtc_mode_set+0x6f/0xa0 [i915]
 [<ffffffffa0424f2c>] drm_crtc_helper_set_mode+0x32c/0x4d0 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa0425143>] drm_helper_resume_force_mode+0x73/0x160 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa049aca6>] i915_reset+0x526/0x12c0 [i915]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa04a0ed8>] i915_error_work_func+0xc8/0x110 [i915]
 [<ffffffff81070b5b>] process_one_work+0x18b/0x6e0
 [<ffffffff81070afa>] ? process_one_work+0x12a/0x6e0
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107148f>] worker_thread+0x15f/0x350
 [<ffffffff81071330>] ? rescuer_thread+0x240/0x240
 [<ffffffff81075e6b>] kthread+0x9b/0xa0
 [<ffffffff814c0534>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103555c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff814b7c7b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff81075dd0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff814c0530>] ? gs_change+0xb/0xb
---[ end trace 63d388f543b49f36 ]---
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:916
assert_pipe+0x75/0x80 [i915]()
Hardware name: 6464CTO
pipe B assertion failure (expected on, current off)
Modules linked in: vfat fat isofs i915 drm_kms_helper drm i2c_algo_bit
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables tun bridge
stp llc lockd sunrpc snd_hda_codec_analog cryptomgr aead arc4
crypto_algapi iwl3945 iwl_legacy mac80211 psmouse iTCO_wdt usbhid
serio_raw i2c_i801 hid i2c_core snd_hda_intel snd_hda_codec cfg80211
iTCO_vendor_support e1000e snd_pcm snd_timer thinkpad_acpi snd
snd_page_alloc soundcore wmi nvram binfmt_misc evdev loop virtio_net
kvm_intel kvm uinput dm_mod ipv6 autofs4 pcmcia ehci_hcd uhci_hcd
sdhci_pci sdhci yenta_socket mmc_core usbcore sr_mod cdrom video
backlight
Pid: 24480, comm: kworker/u:0 Tainted: G        W   3.1.0-00008-gba92ff5 #17
Call Trace:
 [<ffffffff8104f69f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104f796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa04cd315>] assert_pipe+0x75/0x80 [i915]
 [<ffffffffa04d32f6>] intel_enable_plane+0x36/0x90 [i915]
 [<ffffffffa04d622d>] i9xx_crtc_mode_set+0x72d/0xd70 [i915]
 [<ffffffffa04cc4af>] intel_crtc_mode_set+0x6f/0xa0 [i915]
 [<ffffffffa0424f2c>] drm_crtc_helper_set_mode+0x32c/0x4d0 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa0425143>] drm_helper_resume_force_mode+0x73/0x160 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa049aca6>] i915_reset+0x526/0x12c0 [i915]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa04a0ed8>] i915_error_work_func+0xc8/0x110 [i915]
 [<ffffffff81070b5b>] process_one_work+0x18b/0x6e0
 [<ffffffff81070afa>] ? process_one_work+0x12a/0x6e0
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107148f>] worker_thread+0x15f/0x350
 [<ffffffff81071330>] ? rescuer_thread+0x240/0x240
 [<ffffffff81075e6b>] kthread+0x9b/0xa0
 [<ffffffff814c0534>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103555c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff814b7c7b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff81075dd0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff814c0530>] ? gs_change+0xb/0xb
---[ end trace 63d388f543b49f37 ]---
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:792
intel_enable_pipe+0x14a/0x150 [i915]()
Hardware name: 6464CTO
PLL state assertion failure (expected on, current off)
Modules linked in: vfat fat isofs i915 drm_kms_helper drm i2c_algo_bit
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables tun bridge
stp llc lockd sunrpc snd_hda_codec_analog cryptomgr aead arc4
crypto_algapi iwl3945 iwl_legacy mac80211 psmouse iTCO_wdt usbhid
serio_raw i2c_i801 hid i2c_core snd_hda_intel snd_hda_codec cfg80211
iTCO_vendor_support e1000e snd_pcm snd_timer thinkpad_acpi snd
snd_page_alloc soundcore wmi nvram binfmt_misc evdev loop virtio_net
kvm_intel kvm uinput dm_mod ipv6 autofs4 pcmcia ehci_hcd uhci_hcd
sdhci_pci sdhci yenta_socket mmc_core usbcore sr_mod cdrom video
backlight
Pid: 24480, comm: kworker/u:0 Tainted: G        W   3.1.0-00008-gba92ff5 #17
Call Trace:
 [<ffffffff8104f69f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104f796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa04d32ba>] intel_enable_pipe+0x14a/0x150 [i915]
 [<ffffffffa04d69b0>] i9xx_crtc_enable+0x140/0x190 [i915]
 [<ffffffffa04d6a0e>] i9xx_crtc_commit+0xe/0x10 [i915]
 [<ffffffffa0424f99>] drm_crtc_helper_set_mode+0x399/0x4d0 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa0425143>] drm_helper_resume_force_mode+0x73/0x160 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa049aca6>] i915_reset+0x526/0x12c0 [i915]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa04a0ed8>] i915_error_work_func+0xc8/0x110 [i915]
 [<ffffffff81070b5b>] process_one_work+0x18b/0x6e0
 [<ffffffff81070afa>] ? process_one_work+0x12a/0x6e0
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107148f>] worker_thread+0x15f/0x350
 [<ffffffff81071330>] ? rescuer_thread+0x240/0x240
 [<ffffffff81075e6b>] kthread+0x9b/0xa0
 [<ffffffff814c0534>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103555c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff814b7c7b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff81075dd0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff814c0530>] ? gs_change+0xb/0xb
---[ end trace 63d388f543b49f38 ]---
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/intel_display.c:916
assert_pipe+0x75/0x80 [i915]()
Hardware name: 6464CTO
pipe B assertion failure (expected on, current off)
Modules linked in: vfat fat isofs i915 drm_kms_helper drm i2c_algo_bit
ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables tun bridge
stp llc lockd sunrpc snd_hda_codec_analog cryptomgr aead arc4
crypto_algapi iwl3945 iwl_legacy mac80211 psmouse iTCO_wdt usbhid
serio_raw i2c_i801 hid i2c_core snd_hda_intel snd_hda_codec cfg80211
iTCO_vendor_support e1000e snd_pcm snd_timer thinkpad_acpi snd
snd_page_alloc soundcore wmi nvram binfmt_misc evdev loop virtio_net
kvm_intel kvm uinput dm_mod ipv6 autofs4 pcmcia ehci_hcd uhci_hcd
sdhci_pci sdhci yenta_socket mmc_core usbcore sr_mod cdrom video
backlight
Pid: 24480, comm: kworker/u:0 Tainted: G        W   3.1.0-00008-gba92ff5 #17
Call Trace:
 [<ffffffff8104f69f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104f796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa04cd315>] assert_pipe+0x75/0x80 [i915]
 [<ffffffffa04d32f6>] intel_enable_plane+0x36/0x90 [i915]
 [<ffffffffa04d69be>] i9xx_crtc_enable+0x14e/0x190 [i915]
 [<ffffffffa04d6a0e>] i9xx_crtc_commit+0xe/0x10 [i915]
 [<ffffffffa0424f99>] drm_crtc_helper_set_mode+0x399/0x4d0 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa0425143>] drm_helper_resume_force_mode+0x73/0x160 [drm_kms_helper]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa049aca6>] i915_reset+0x526/0x12c0 [i915]
 [<ffffffffa04a0e10>] ? i915_driver_device_is_agp+0x10/0x10 [i915]
 [<ffffffffa04a0ed8>] i915_error_work_func+0xc8/0x110 [i915]
 [<ffffffff81070b5b>] process_one_work+0x18b/0x6e0
 [<ffffffff81070afa>] ? process_one_work+0x12a/0x6e0
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107148f>] worker_thread+0x15f/0x350
 [<ffffffff81071330>] ? rescuer_thread+0x240/0x240
 [<ffffffff81075e6b>] kthread+0x9b/0xa0
 [<ffffffff814c0534>] kernel_thread_helper+0x4/0x10
 [<ffffffff8103555c>] ? finish_task_switch+0x7c/0x120
 [<ffffffff814b7c7b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff814b8221>] ? retint_restore_args+0xe/0xe
 [<ffffffff81075dd0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff814c0530>] ? gs_change+0xb/0xb
---[ end trace 63d388f543b49f39 ]---
[drm:intel_lvds_enable] *ERROR* timed out waiting for panel to power on


corresponding Xorg.0.log report:


[  9839.749] [mi] EQ overflowing.  Additional events will be discarded
until existing events are processed.
[  9839.749]
Backtrace:
[  9839.751] 0: /usr/bin/X (xorg_backtrace+0x26) [0x462ca6]
[  9839.751] 1: /usr/bin/X (mieqEnqueue+0x273) [0x5542e3]
[  9839.751] 2: /usr/bin/X (0x400000+0x47254) [0x447254]
[  9839.751] 3: /usr/lib64/xorg/modules/input/evdev_drv.so
(0x7fae86d98000+0x50d9) [0x7fae86d9d0d9]
[  9839.751] 4: /usr/bin/X (0x400000+0x7e607) [0x47e607]
[  9839.751] 5: /usr/bin/X (0x400000+0xa3caa) [0x4a3caa]
[  9839.751] 6: /lib64/libpthread.so.0 (0x7fae8b56d000+0xf4f0) [0x7fae8b57c4f0]
[  9839.751] 7: /lib64/libc.so.6 (ioctl+0x7) [0x7fae8a336b17]
[  9839.751] 8: /home/kabi/soft/glx-test/lib/libdrm.so.2
(drmIoctl+0x28) [0x7fae88abc668]
[  9839.751] 9: /home/kabi/soft/glx-test/lib/libdrm.so.2
(drmCommandNone+0x16) [0x7fae88abe8d6]
[  9839.751] 10:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x2e410) [0x7fae88820410]
[  9839.751] 11:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x44bde) [0x7fae88836bde]
[  9839.751] 12: /usr/bin/X (BlockHandler+0x4a) [0x437a8a]
[  9839.751] 13: /usr/bin/X (WaitForSomething+0x11d) [0x46016d]
[  9839.751] 14: /usr/bin/X (0x400000+0x33a22) [0x433a22]
[  9839.752] 15: /usr/bin/X (0x400000+0x22f2a) [0x422f2a]
[  9839.752] 16: /lib64/libc.so.6 (__libc_start_main+0xed) [0x7fae8a27069d]
[  9839.752] 17: /usr/bin/X (0x400000+0x2321d) [0x42321d]
[  9839.752] [mi] These backtraces from mieqEnqueue may point to a
culprit higher up the stack.
[  9839.752] [mi] mieq is *NOT* the cause.  It is a victim.
[  9840.036] (EE) intel(0): Detected a hung GPU, disabling acceleration.
[  9840.036] (EE) intel(0): When reporting this, please include
i915_error_state from debugfs and the full dmesg.
[  9840.158] [mi] EQ overflow continuing.  100 events have been dropped.
[  9840.158]
Backtrace:
[  9840.158] 0: /usr/bin/X (xorg_backtrace+0x26) [0x462ca6]
[  9840.158] 1: /usr/bin/X (0x400000+0x47254) [0x447254]
[  9840.158] 2: /usr/lib64/xorg/modules/input/evdev_drv.so
(0x7fae86d98000+0x50d9) [0x7fae86d9d0d9]
[  9840.158] 3: /usr/bin/X (0x400000+0x7e607) [0x47e607]
[  9840.158] 4: /usr/bin/X (0x400000+0xa3caa) [0x4a3caa]
[  9840.158] 5: /lib64/libpthread.so.0 (0x7fae8b56d000+0xf4f0) [0x7fae8b57c4f0]
[  9840.158] 6: /lib64/libc.so.6 (ioctl+0x7) [0x7fae8a336b17]
[  9840.158] 7: /home/kabi/soft/glx-test/lib/libdrm.so.2
(drmIoctl+0x28) [0x7fae88abc668]
[  9840.158] 8:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x2d474) [0x7fae8881f474]
[  9840.158] 9:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x2df8d) [0x7fae8881ff8d]
[  9840.158] 10:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x2e4b6) [0x7fae888204b6]
[  9840.158] 11:
/home/kabi/soft/glx-test/lib/xorg/modules/drivers/intel_drv.so
(0x7fae887f2000+0x44b81) [0x7fae88836b81]
[  9840.159] 12: /usr/bin/X (BlockHandler+0x4a) [0x437a8a]
[  9840.159] 13: /usr/bin/X (WaitForSomething+0x11d) [0x46016d]
[  9840.159] 14: /usr/bin/X (0x400000+0x33a22) [0x433a22]
[  9840.159] 15: /usr/bin/X (0x400000+0x22f2a) [0x422f2a]
[  9840.159] 16: /lib64/libc.so.6 (__libc_start_main+0xed) [0x7fae8a27069d]
[  9840.159] 17: /usr/bin/X (0x400000+0x2321d) [0x42321d]
[  9842.596] [mi] Increasing EQ size to 512 to prevent dropped events.
