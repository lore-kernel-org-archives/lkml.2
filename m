Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2LKMbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:31:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab2LKMby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:31:54 -0500
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3437 i915_gem_object_pin+0x151/0x1a0()
Date: Tue, 11 Dec 2012 13:31:36 +0100
Message-ID: <87vcc8vkgn.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

looks like we still have some oops in i915. i915 maintainers do you have
any ideas what's going on? I will try to trigger that oops later today
and provide more information.

[10733.442608] WARNING: at drivers/gpu/drm/i915/i915_gem.c:3437 i915_gem_object_pin+0x151/0x1a0()
[10733.442612] Hardware name: 4243BQ9
[10733.442615] Modules linked in: kvm_intel kvm
[10733.442632] Pid: 1361, comm: X Not tainted 3.7.0 #19
[10733.442635] Call Trace:
[10733.442650]  [<ffffffff81095efa>] warn_slowpath_common+0x7a/0xb0
[10733.442659]  [<ffffffff81095f45>] warn_slowpath_null+0x15/0x20
[10733.442669]  [<ffffffff814dc041>] i915_gem_object_pin+0x151/0x1a0
[10733.442679]  [<ffffffff814dc0ea>] i915_gem_object_pin_to_display_plane+0x5a/0x90
[10733.442689]  [<ffffffff814d80f5>] ? i915_mutex_lock_interruptible+0x35/0xc0
[10733.442700]  [<ffffffff814ec6b0>] intel_pin_and_fence_fb_obj+0x50/0x130
[10733.442709]  [<ffffffff814ec9de>] intel_gen6_queue_flip+0x3e/0x160
[10733.442719]  [<ffffffff814f01f2>] intel_crtc_page_flip+0x1d2/0x370
[10733.442728]  [<ffffffff814bd633>] drm_mode_page_flip_ioctl+0x273/0x300
[10733.442738]  [<ffffffff814aba20>] drm_ioctl+0x2d0/0x520
[10733.442746]  [<ffffffff814bd3c0>] ? drm_mode_gamma_get_ioctl+0x120/0x120
[10733.442757]  [<ffffffff818d172f>] ? _raw_spin_unlock_irqrestore+0x5f/0x70
[10733.442768]  [<ffffffff810a4321>] ? del_timer+0x61/0x90
[10733.442779]  [<ffffffff8111fc34>] ? rcu_cleanup_after_idle+0x24/0x40
[10733.442829]  [<ffffffff811205b6>] ? rcu_prepare_for_idle+0x1b6/0x300
[10733.442838]  [<ffffffff81121d89>] ? rcu_user_exit+0x69/0xc0
[10733.442847]  [<ffffffff8119eafa>] do_vfs_ioctl+0x8a/0x2f0
[10733.442859]  [<ffffffff810ebfbd>] ? trace_hardirqs_on+0xd/0x10
[10733.442866]  [<ffffffff8119edf1>] sys_ioctl+0x91/0xa0
[10733.442876]  [<ffffffff818d8d18>] tracesys+0xe1/0xe6

-- 
Nikola
