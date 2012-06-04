Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2FDB1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:27:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab2FDB1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:27:00 -0400
Message-ID: <4FCC0E43.5030608@redhat.com>
Date: Mon, 04 Jun 2012 09:24:19 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.1.14-1.el6_1 Thunderbird/3.1.14
MIME-Version: 1.0
To: keithp@keithp.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: at drivers/gpu/drm/i915/i915_drv.c:440
References: <20120601062125.GA23223@localhost.localdomain> <20120601143233.GC5027@phenom.ffwll.local>
In-Reply-To: <20120601143233.GC5027@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 10:32 PM, Daniel Vetter wrote:

> On Fri, Jun 01, 2012 at 02:21:25PM +0800, Dave Young wrote:
>> Today I got a lot i915 warnings on a thinkpad t400, here is the something copied from syslog:
>> [Known issue?]
> 
> The gpu refuses to clear the write fifo. Which means it pretty much
> disappeared into nirvana. The kernel _should_ detect this condition and
> try to reset the gpu. Furthermore it should dump a useful information into
> i915_error_state in debugfs. Can you please attach that (rebooting
> obviously destroy the contents of that file)?


Sorry, I did not save the debugfs content.

I can not always reproduce this issue,  I will send that to you when I
see the call trace next time.

> 
> Also, your version of your kernel, xf86-video-intel, mesa and libdrm are
> relevant.


kernel: 3.4.0
xf86-video-intel: xorg-x11-drv-intel-2.16.0-1.el6.x86_64
mesa: mesa-dri-drivers-7.11-1.el6.x86_64
libdrm: libdrm-2.4.25-1.el6.x86_64

> 
> Yours, Daniel
>>
>> Jun  1 13:31:13 localhost kernel: [15935.915986] ------------[ cut here ]------------
>> Jun  1 13:31:13 localhost kernel: [15935.916009] WARNING: at drivers/gpu/drm/i915/i915_drv.c:440 __gen6_gt_wait_for_fifo+0x74/0x89()
>> Jun  1 13:31:13 localhost kernel: [15935.916017] Hardware name: 4236NUC
>> Jun  1 13:31:13 localhost kernel: [15935.916022] Modules linked in: fuse rfcomm bnep sunrpc vhost_net macvtap macvlan tun kvm_intel kvm btusb bluetooth uvcvideo videobuf2_core videodev media videobuf2_vmalloc videobuf2_memops pcspkr iwlwifi mac80211 cfg80211 e1000e wmi thinkpad_acpi rfkill firewire_ohci firewire_core crc_itu_t sdhci_pci [last unloaded: scsi_wait_scan]
>> Jun  1 13:31:13 localhost kernel: [15935.916125] Pid: 8026, comm: Xorg Not tainted 3.4.0 #284
>> Jun  1 13:31:13 localhost kernel: [15935.916131] Call Trace:
>> Jun  1 13:31:13 localhost kernel: [15935.916146]  [<ffffffff810333a7>] warn_slowpath_common+0x80/0x98
>> Jun  1 13:31:13 localhost kernel: [15935.916157]  [<ffffffff810333d4>] warn_slowpath_null+0x15/0x17
>> Jun  1 13:31:13 localhost kernel: [15935.916168]  [<ffffffff81358163>] __gen6_gt_wait_for_fifo+0x74/0x89
>> Jun  1 13:31:13 localhost kernel: [15935.916178]  [<ffffffff8135852b>] i915_write32+0x4c/0x70
>> Jun  1 13:31:13 localhost kernel: [15935.916189]  [<ffffffff8138b506>] ? gen6_ring_put_irq+0x31/0x8a
>> Jun  1 13:31:13 localhost kernel: [15935.916199]  [<ffffffff8138b538>] gen6_ring_put_irq+0x63/0x8a
>> Jun  1 13:31:13 localhost kernel: [15935.916209]  [<ffffffff8138b59c>] gen6_render_ring_put_irq+0x13/0x15
>> Jun  1 13:31:13 localhost kernel: [15935.916222]  [<ffffffff81367214>] i915_wait_request+0x2fd/0x3b3
>> Jun  1 13:31:13 localhost kernel: [15935.916235]  [<ffffffff81051c59>] ? wake_up_bit+0x25/0x25
>> Jun  1 13:31:13 localhost kernel: [15935.916248]  [<ffffffff81367368>] ? i915_gem_flush_ring+0x6b/0x139
>> Jun  1 13:31:13 localhost kernel: [15935.916260]  [<ffffffff813672fb>] i915_gem_object_wait_rendering+0x31/0x33
>> Jun  1 13:31:13 localhost kernel: [15935.916271]  [<ffffffff8136c81f>] i915_gem_do_execbuffer.clone.6+0xce7/0x129f
>> Jun  1 13:31:13 localhost kernel: [15935.916284]  [<ffffffff8107ab6b>] ? __lock_acquire+0xe32/0xe41
>> Jun  1 13:31:13 localhost kernel: [15935.916294]  [<ffffffff8107ac1a>] ? lock_release_non_nested+0xa0/0x24f
>> Jun  1 13:31:13 localhost kernel: [15935.916306]  [<ffffffff8136d155>] i915_gem_execbuffer2+0x114/0x183
>> Jun  1 13:31:13 localhost kernel: [15935.916321]  [<ffffffff810e7ec4>] ? might_fault+0x89/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.916334]  [<ffffffff81343623>] drm_ioctl+0x2f1/0x3d3
>> Jun  1 13:31:13 localhost kernel: [15935.916345]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.916355]  [<ffffffff8136d041>] ? i915_gem_execbuffer+0x26a/0x26a
>> Jun  1 13:31:13 localhost kernel: [15935.916366]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.916378]  [<ffffffff8100add4>] ? check_for_xstate+0x2f/0x8a
>> Jun  1 13:31:13 localhost kernel: [15935.916391]  [<ffffffff8111c5cc>] do_vfs_ioctl+0x47d/0x4bc
>> Jun  1 13:31:13 localhost kernel: [15935.916405]  [<ffffffff81044a98>] ? do_sigaltstack+0xaf/0x14e
>> Jun  1 13:31:13 localhost kernel: [15935.916417]  [<ffffffff815e0255>] ? retint_swapgs+0x13/0x1b
>> Jun  1 13:31:13 localhost kernel: [15935.916430]  [<ffffffff8110f313>] ? fget_light+0x3d/0x9c
>> Jun  1 13:31:13 localhost kernel: [15935.916441]  [<ffffffff8111c65c>] sys_ioctl+0x51/0x75
>> Jun  1 13:31:13 localhost kernel: [15935.916452]  [<ffffffff815e677d>] system_call_fastpath+0x1a/0x1f
>> Jun  1 13:31:13 localhost kernel: [15935.916460] ---[ end trace 93dc2a59f9772003 ]---
>> Jun  1 13:31:13 localhost kernel: [15935.921817] ------------[ cut here ]------------
>> Jun  1 13:31:13 localhost kernel: [15935.921829] WARNING: at drivers/gpu/drm/i915/i915_drv.c:440 __gen6_gt_wait_for_fifo+0x74/0x89()
>> Jun  1 13:31:13 localhost kernel: [15935.921836] Hardware name: 4236NUC
>> Jun  1 13:31:13 localhost kernel: [15935.921840] Modules linked in: fuse rfcomm bnep sunrpc vhost_net macvtap macvlan tun kvm_intel kvm btusb bluetooth uvcvideo videobuf2_core videodev media videobuf2_vmalloc videobuf2_memops pcspkr iwlwifi mac80211 cfg80211 e1000e wmi thinkpad_acpi rfkill firewire_ohci firewire_core crc_itu_t sdhci_pci [last unloaded: scsi_wait_scan]
>> Jun  1 13:31:13 localhost kernel: [15935.921931] Pid: 8026, comm: Xorg Tainted: G        W    3.4.0 #284
>> Jun  1 13:31:13 localhost kernel: [15935.921937] Call Trace:
>> Jun  1 13:31:13 localhost kernel: [15935.921947]  [<ffffffff810333a7>] warn_slowpath_common+0x80/0x98
>> Jun  1 13:31:13 localhost kernel: [15935.921956]  [<ffffffff810333d4>] warn_slowpath_null+0x15/0x17
>> Jun  1 13:31:13 localhost kernel: [15935.921966]  [<ffffffff81358163>] __gen6_gt_wait_for_fifo+0x74/0x89
>> Jun  1 13:31:13 localhost kernel: [15935.921975]  [<ffffffff8135852b>] i915_write32+0x4c/0x70
>> Jun  1 13:31:13 localhost kernel: [15935.921984]  [<ffffffff8138b1c3>] ring_write_tail+0x1c/0x1e
>> Jun  1 13:31:13 localhost kernel: [15935.921994]  [<ffffffff8138c446>] intel_ring_advance+0x18/0x1a
>> Jun  1 13:31:13 localhost kernel: [15935.922003]  [<ffffffff8138c5a2>] blt_ring_flush+0x66/0x70
>> Jun  1 13:31:13 localhost kernel: [15935.922015]  [<ffffffff81367368>] i915_gem_flush_ring+0x6b/0x139
>> Jun  1 13:31:13 localhost kernel: [15935.922026]  [<ffffffff8136c716>] i915_gem_do_execbuffer.clone.6+0xbde/0x129f
>> Jun  1 13:31:13 localhost kernel: [15935.922037]  [<ffffffff8107ab6b>] ? __lock_acquire+0xe32/0xe41
>> Jun  1 13:31:13 localhost kernel: [15935.922047]  [<ffffffff8107ac1a>] ? lock_release_non_nested+0xa0/0x24f
>> Jun  1 13:31:13 localhost kernel: [15935.922058]  [<ffffffff8136d155>] i915_gem_execbuffer2+0x114/0x183
>> Jun  1 13:31:13 localhost kernel: [15935.922070]  [<ffffffff810e7ec4>] ? might_fault+0x89/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.922080]  [<ffffffff81343623>] drm_ioctl+0x2f1/0x3d3
>> Jun  1 13:31:13 localhost kernel: [15935.922091]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.922100]  [<ffffffff8136d041>] ? i915_gem_execbuffer+0x26a/0x26a
>> Jun  1 13:31:13 localhost kernel: [15935.922112]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.922121]  [<ffffffff8100add4>] ? check_for_xstate+0x2f/0x8a
>> Jun  1 13:31:13 localhost kernel: [15935.922133]  [<ffffffff8111c5cc>] do_vfs_ioctl+0x47d/0x4bc
>> Jun  1 13:31:13 localhost kernel: [15935.922145]  [<ffffffff81044a98>] ? do_sigaltstack+0xaf/0x14e
>> Jun  1 13:31:13 localhost kernel: [15935.922154]  [<ffffffff815e0255>] ? retint_swapgs+0x13/0x1b
>> Jun  1 13:31:13 localhost kernel: [15935.922165]  [<ffffffff8110f313>] ? fget_light+0x3d/0x9c
>> Jun  1 13:31:13 localhost kernel: [15935.922176]  [<ffffffff8111c65c>] sys_ioctl+0x51/0x75
>> Jun  1 13:31:13 localhost kernel: [15935.922185]  [<ffffffff815e677d>] system_call_fastpath+0x1a/0x1f
>> Jun  1 13:31:13 localhost kernel: [15935.922193] ---[ end trace 93dc2a59f9772004 ]---
>> Jun  1 13:31:13 localhost kernel: [15935.928465] ------------[ cut here ]------------
>> Jun  1 13:31:13 localhost kernel: [15935.928476] WARNING: at drivers/gpu/drm/i915/i915_drv.c:440 __gen6_gt_wait_for_fifo+0x74/0x89()
>> Jun  1 13:31:13 localhost kernel: [15935.928482] Hardware name: 4236NUC
>> Jun  1 13:31:13 localhost kernel: [15935.928486] Modules linked in: fuse rfcomm bnep sunrpc vhost_net macvtap macvlan tun kvm_intel kvm btusb bluetooth uvcvideo videobuf2_core videodev media videobuf2_vmalloc videobuf2_memops pcspkr iwlwifi mac80211 cfg80211 e1000e wmi thinkpad_acpi rfkill firewire_ohci firewire_core crc_itu_t sdhci_pci [last unloaded: scsi_wait_scan]
>> Jun  1 13:31:13 localhost kernel: [15935.928577] Pid: 8026, comm: Xorg Tainted: G        W    3.4.0 #284
>> Jun  1 13:31:13 localhost kernel: [15935.928583] Call Trace:
>> Jun  1 13:31:13 localhost kernel: [15935.928592]  [<ffffffff810333a7>] warn_slowpath_common+0x80/0x98
>> Jun  1 13:31:13 localhost kernel: [15935.928602]  [<ffffffff810333d4>] warn_slowpath_null+0x15/0x17
>> Jun  1 13:31:13 localhost kernel: [15935.928612]  [<ffffffff81358163>] __gen6_gt_wait_for_fifo+0x74/0x89
>> Jun  1 13:31:13 localhost kernel: [15935.928622]  [<ffffffff8135852b>] i915_write32+0x4c/0x70
>> Jun  1 13:31:13 localhost kernel: [15935.928631]  [<ffffffff8138b85a>] ? gen6_ring_get_irq+0x44/0x9a
>> Jun  1 13:31:13 localhost kernel: [15935.928641]  [<ffffffff8138b88f>] gen6_ring_get_irq+0x79/0x9a
>> Jun  1 13:31:13 localhost kernel: [15935.928651]  [<ffffffff8138b8ed>] gen6_render_ring_get_irq+0x13/0x15
>> Jun  1 13:31:13 localhost kernel: [15935.928663]  [<ffffffff813670ac>] i915_wait_request+0x195/0x3b3
>> Jun  1 13:31:13 localhost kernel: [15935.928675]  [<ffffffff81367368>] ? i915_gem_flush_ring+0x6b/0x139
>> Jun  1 13:31:13 localhost kernel: [15935.928688]  [<ffffffff813672fb>] i915_gem_object_wait_rendering+0x31/0x33
>> Jun  1 13:31:13 localhost kernel: [15935.928698]  [<ffffffff8136c81f>] i915_gem_do_execbuffer.clone.6+0xce7/0x129f
>> Jun  1 13:31:13 localhost kernel: [15935.928709]  [<ffffffff8107ab6b>] ? __lock_acquire+0xe32/0xe41
>> Jun  1 13:31:13 localhost kernel: [15935.928719]  [<ffffffff8107ac1a>] ? lock_release_non_nested+0xa0/0x24f
>> Jun  1 13:31:13 localhost kernel: [15935.928731]  [<ffffffff8136d155>] i915_gem_execbuffer2+0x114/0x183
>> Jun  1 13:31:13 localhost kernel: [15935.928742]  [<ffffffff810e7ec4>] ? might_fault+0x89/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.928752]  [<ffffffff81343623>] drm_ioctl+0x2f1/0x3d3
>> Jun  1 13:31:13 localhost kernel: [15935.928764]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.928773]  [<ffffffff8136d041>] ? i915_gem_execbuffer+0x26a/0x26a
>> Jun  1 13:31:13 localhost kernel: [15935.928785]  [<ffffffff810e7e7b>] ? might_fault+0x40/0x90
>> Jun  1 13:31:13 localhost kernel: [15935.928794]  [<ffffffff8100add4>] ? check_for_xstate+0x2f/0x8a
>> Jun  1 13:31:13 localhost kernel: [15935.928806]  [<ffffffff8111c5cc>] do_vfs_ioctl+0x47d/0x4bc
>> Jun  1 13:31:13 localhost kernel: [15935.928818]  [<ffffffff81044a98>] ? do_sigaltstack+0xaf/0x14e
>> Jun  1 13:31:13 localhost kernel: [15935.928828]  [<ffffffff815e0255>] ? retint_swapgs+0x13/0x1b
>> Jun  1 13:31:13 localhost kernel: [15935.928838]  [<ffffffff8110f313>] ? fget_light+0x3d/0x9c
>> Jun  1 13:31:13 localhost kernel: [15935.928850]  [<ffffffff8111c65c>] sys_ioctl+0x51/0x75
>> Jun  1 13:31:13 localhost kernel: [15935.928859]  [<ffffffff815e677d>] system_call_fastpath+0x1a/0x1f
>> Jun  1 13:31:13 localhost kernel: [15935.928866] ---[ end trace 93dc2a59f9772005 ]---
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 



-- 
Thanks
Dave
