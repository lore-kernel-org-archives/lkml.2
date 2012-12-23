Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2LWABf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 19:01:35 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43346 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2LWABc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 19:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121222203547.GA5319@liondog.tnic>
References: <20121222203547.GA5319@liondog.tnic>
Date: Sat, 22 Dec 2012 19:01:31 -0500
Message-ID: <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 3:35 PM, Borislav Petkov <bp@alien8.de> wrote:
> Hi Alex,
>
> got the sickest bug on 3.8-rc1, see below. The GPU locks up somewhere
> down radeon_fence_wait_seq, judging by the error messages.
>
> And this doesn't happen with 3.7, of course.
>
> Let me know if you need any more info, thanks.

What chip is this?

Alex

>
> [16273.668350] radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
> [16273.668361] radeon 0000:02:00.0: GPU lockup (waiting for 0x000000000000002b last fence id 0x000000000000002a)
> [16273.882550] plugin-containe[11435]: segfault at 7f1f0a66cc08 ip 00007f1f13289bdb sp 00007f1f0a2fe9e0 error 4 in libflashplayer.so[7f1f130c5000+117b000]
> [16274.502807] ------------[ cut here ]------------
> [16274.502845] WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
> [16274.502880] Hardware name:
> [16274.502897] list_del corruption, ffff8802216a3f10->next is LIST_POISON1 (dead000000100100)
> [16274.502939] Modules linked in: nls_iso8859_15 nls_cp437 acpi_cpufreq mperf cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats binfmt_misc dm_crypt dm_mod ipv6 vfat fat fuse kvm_amd kvm radeon drm_kms_helper ttm edac_core microcode cfbfillrect cfbimgblt cfbcopyarea k10temp
> [16274.503141] Pid: 17386, comm: Xorg Not tainted 3.8.0-rc1 #13
> [16274.503172] Call Trace:
> [16274.503190]  [<ffffffff8124bd00>] ? __list_del_entry+0x60/0xd0
> [16274.503224]  [<ffffffff8103b2cf>] warn_slowpath_common+0x7f/0xc0
> [16274.503257]  [<ffffffff8103b3c6>] warn_slowpath_fmt+0x46/0x50
> [16274.503289]  [<ffffffff8124bd03>] __list_del_entry+0x63/0xd0
> [16274.503320]  [<ffffffff8124bd81>] list_del+0x11/0x40
> [16274.503348]  [<ffffffff812fa00e>] drm_mm_remove_node+0x9e/0xd0
> [16274.503383]  [<ffffffff812fa065>] drm_mm_put_block+0x25/0x70
> [16274.503422]  [<ffffffffa003dd71>] ? ttm_bo_man_put_node+0x31/0x60 [ttm]
> [16274.503464]  [<ffffffffa003dd79>] ttm_bo_man_put_node+0x39/0x60 [ttm]
> [16274.503503]  [<ffffffffa0036790>] ttm_bo_cleanup_memtype_use+0x80/0xb0 [ttm]
> [16274.503545]  [<ffffffffa0037a3b>] ttm_bo_release+0x1fb/0x270 [ttm]
> [16274.503585]  [<ffffffffa0037ae1>] ttm_bo_unref+0x31/0x40 [ttm]
> [16274.503656]  [<ffffffffa00a04c7>] radeon_bo_unref+0x47/0x80 [radeon]
> [16274.503707]  [<ffffffffa00b2929>] radeon_gem_object_free+0x39/0x40 [radeon]
> [16274.503748]  [<ffffffff812f0e59>] drm_gem_object_free+0x29/0x30
> [16274.503781]  [<ffffffff812f1248>] drm_gem_object_release_handle+0xb8/0xd0
> [16274.503819]  [<ffffffff8122f97d>] idr_for_each+0xdd/0x180
> [16274.503850]  [<ffffffff812f1190>] ? drm_gem_handle_create+0x100/0x100
> [16274.503887]  [<ffffffff81099e0d>] ? trace_hardirqs_on+0xd/0x10
> [16274.503920]  [<ffffffff812f17c4>] drm_gem_release+0x24/0x40
> [16274.503952]  [<ffffffff812efffa>] drm_release+0x54a/0x5e0
> [16274.503984]  [<ffffffff8106eed2>] ? lg_local_unlock+0x42/0x70
> [16274.504016]  [<ffffffff8113afe2>] __fput+0xb2/0x240
> [16274.504044]  [<ffffffff8113b22e>] ____fput+0xe/0x10
> [16274.504073]  [<ffffffff81061765>] task_work_run+0xb5/0xd0
> [16274.504105]  [<ffffffff8104144a>] do_exit+0x23a/0xac0
> [16274.504135]  [<ffffffff81041e8c>] do_group_exit+0x4c/0xc0
> [16274.504167]  [<ffffffff8105453d>] get_signal_to_deliver+0x22d/0x960
> [16274.504202]  [<ffffffff81001a9f>] do_signal+0x3f/0x5a0
> [16274.504233]  [<ffffffff8123a36e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [16274.504269]  [<ffffffff8100205d>] do_notify_resume+0x5d/0x90
> [16274.504300]  [<ffffffff8123a36e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [16274.504337]  [<ffffffff8151d6c8>] int_signal+0x12/0x17
> [16274.504366] ---[ end trace 4aad5b52e5533e3e ]---
>
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
