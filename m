Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271Ab2K3VK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:10:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55788 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab2K3VKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:10:24 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <alpine.SOC.1.00.1211302247340.10301@math.ut.ee>
References: <alpine.SOC.1.00.1211122120150.3649@math.ut.ee>
	<alpine.SOC.1.00.1211302247340.10301@math.ut.ee>
Date: Fri, 30 Nov 2012 22:10:22 +0100
Message-ID: <CAKMK7uFv+7JdgkwH7LZpHWiNnkr-dy=bKron8aRZHsCK1nHhJw@mail.gmail.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:1009 ironlake_crtc_disable+0xaf/0x8e0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Meelis Roos <mroos@ut.ee>
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 9:49 PM, Meelis Roos <mroos@ut.ee> wrote:
>> I tried 3.7-rc5 on an ironlale PC and got the warning in subject. The
>> computer last ran 3.6.0 without any warnings. Second reboot showed the
>> same warning plus a couple of EDID warnings (also below).
>
> Still there with 3.7.0-rc7-00113-gcc19528 and 100% reproducible:

Hm, can you please boot with drm.debug=0xe added to your kernel
cmdline and the attach the complete dmesg?
-Daniel

>
> [    0.646574] WARNING: at drivers/gpu/drm/i915/intel_display.c:1009 ironlake_crtc_disable+0xaf/0x8e0()
> [    0.646575] Hardware name: HP Compaq 8100 Elite SFF PC
> [    0.646575] pipe_off wait timed out
> [    0.646576] Modules linked in:
> [    0.646578] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc7-00113-gcc19528 #75
> [    0.646578] Call Trace:
> [    0.646583]  [<ffffffff81036899>] ? warn_slowpath_common+0x79/0xc0
> [    0.646584]  [<ffffffff81036995>] ? warn_slowpath_fmt+0x45/0x50
> [    0.646585]  [<ffffffff812b5ceb>] ? intel_wait_for_pipe_off+0x5b/0x170
> [    0.646586]  [<ffffffff812b669f>] ? ironlake_crtc_disable+0xaf/0x8e0
> [    0.646588]  [<ffffffff812c5ac9>] ? intel_dp_mode_fixup+0x249/0x270
> [    0.646590]  [<ffffffff812bd4c6>] ? intel_set_mode+0x306/0x920
> [    0.646592]  [<ffffffff812be1d1>] ? intel_crtc_set_config+0x6f1/0x950
> [    0.646595]  [<ffffffff8127545f>] ? drm_fb_helper_set_par+0x6f/0xe0
> [    0.646598]  [<ffffffff8120c7bf>] ? fbcon_init+0x55f/0x5f0
> [    0.646600]  [<ffffffff8125af8c>] ? visual_init+0xac/0x110
> [    0.646601]  [<ffffffff8125c7ec>] ? bind_con_driver+0x16c/0x340
> [    0.646602]  [<ffffffff8125ca20>] ? take_over_console+0x60/0x70
> [    0.646604]  [<ffffffff8120ab6b>] ? fbcon_takeover+0x5b/0xc0
> [    0.646607]  [<ffffffff81059375>] ? notifier_call_chain+0x45/0x60
> [    0.646608]  [<ffffffff81059555>] ? __blocking_notifier_call_chain+0x55/0x80
> [    0.646609]  [<ffffffff8120415f>] ? register_framebuffer+0x1af/0x2e0
> [    0.646611]  [<ffffffff812756c4>] ? drm_fb_helper_single_fb_probe+0x1f4/0x320
> [    0.646612]  [<ffffffff81275999>] ? drm_fb_helper_initial_config+0x1a9/0x220
> [    0.646615]  [<ffffffff810dd13d>] ? __kmalloc+0xed/0x130
> [    0.646618]  [<ffffffff812d6ead>] ? intel_fbdev_init+0x7d/0xb0
> [    0.646619]  [<ffffffff81298e55>] ? i915_driver_load+0xd95/0xf00
> [    0.646622]  [<ffffffff81283fa5>] ? drm_get_pci_dev+0x185/0x2c0
> [    0.646624]  [<ffffffff811f3d41>] ? pci_device_probe+0xd1/0x170
> [    0.646625]  [<ffffffff812e9ed8>] ? driver_probe_device+0x68/0x220
> [    0.646626]  [<ffffffff812ea123>] ? __driver_attach+0x93/0xa0
> [    0.646627]  [<ffffffff812ea090>] ? driver_probe_device+0x220/0x220
> [    0.646629]  [<ffffffff812e836d>] ? bus_for_each_dev+0x4d/0x80
> [    0.646630]  [<ffffffff812e9648>] ? bus_add_driver+0x178/0x260
> [    0.646631]  [<ffffffff812ea724>] ? driver_register+0x84/0x180
> [    0.646634]  [<ffffffff8188c7c4>] ? drm_core_init+0x12f/0x12f
> [    0.646636]  [<ffffffff810002e2>] ? do_one_initcall+0x122/0x170
> [    0.646638]  [<ffffffff8142c6bc>] ? kernel_init+0x11c/0x2a0
> [    0.646641]  [<ffffffff8186c54a>] ? do_early_param+0x83/0x83
> [    0.646643]  [<ffffffff8105e761>] ? schedule_tail+0x21/0xb0
> [    0.646644]  [<ffffffff8142c5a0>] ? rest_init+0x70/0x70
> [    0.646645]  [<ffffffff814455ac>] ? ret_from_fork+0x7c/0xb0
> [    0.646646]  [<ffffffff8142c5a0>] ? rest_init+0x70/0x70
> [    0.646650] ---[ end trace ed6fe7a7042b42d8 ]---
> [    0.702400] [drm:intel_disable_transcoder] *ERROR* failed to disable transcoder 0
>
>
>
> --
> Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
