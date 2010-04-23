Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0DWQDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:03:13 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:56641 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757890Ab0DWQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:03:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oCguQnHaLXeSQiuikSXSe+2ES1WWvmzqyzU6z6uEikCPVZlRlIkX0FsloiYb2D24P381KR8Bv8WXsHbGPWT3NcgUS45DL6XuL/ms6mAhsaP4rx8s02rLuQX2aZrXznWO;
Date: Fri, 23 Apr 2010 09:03:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, eric@anholt.net
Subject: Re: i915_do_wait_request BUG: unable to handle kernel NULL pointer
  dereference at (null)
Message-ID: <20100423090306.3025c0b7@virtuousgeek.org>
In-Reply-To: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com>
References: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 12:24:25 +0200
Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> Hi
> 
> Just tried to boot current vanilla upstream kernel - and got pretty ugly  oops.
> Here is serial console catch after X-startup:
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa035de81>] i915_do_wait_request+0x101/0x4f0 [i915]
> PGD 139649067 PUD 133b5a067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/virtual/backlight/acpi_video0/actual_brightness
> CPU 0
> Modules linked in: xt_tcpudp bridge stp llc autofs4 sunrpc ipv6
> ipt_REJECT xt_physdev xt_state ]
> 
> Pid: 2725, comm: X Not tainted 2.6.34-rc5-00131-g4424503 #63 6464CTO/6464CTO
> RIP: 0010:[<ffffffffa035de81>] [<ffffffffa035de81>]
> i915_do_wait_request+0x101/0x4f0 [i915]
> RSP: 0018:ffff880139923a88 EFLAGS: 00010246
> RAX: ffffffffa0383e5e RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88013965a000
> RBP: ffff880139923af8 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88013965a000
> R13: 0000000000000002 R14: ffff8801364b4000 R15: 0000000000071184
> FS: 00007f76aac81840(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000133bdd000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process X (pid: 2725, threadinfo ffff880139922000, task ffff88013991c640)
> Stack:
> ffff8801364b5218 ffff880132482250 ffff880139923ab8 ffff880135292540
> <0> 0000000000000002 ffff88013965a000 0000000000071188 0000000000071184
> <0> ffff880139923af8 ffff880135292540 ffff880135292780 ffff88013965a000
> Call Trace:
> [<ffffffffa035fb7f>] i915_gem_object_set_to_display_plane+0xbf/0x130 [i915]
> [<ffffffffa036ef28>] intel_pipe_set_base+0x118/0x4b0 [i915]
> [<ffffffffa034a69c>] drm_crtc_helper_set_config+0x75c/0x8f0 [drm_kms_helper]
> [<ffffffffa0327e1f>] drm_mode_setcrtc+0x2af/0x3b0 [drm]
> [<ffffffffa03199ca>] drm_ioctl+0x33a/0x4a0 [drm]
> [<ffffffffa0327b70>] ? drm_mode_setcrtc+0x0/0x3b0 [drm]
> [<ffffffff8113d05d>] vfs_ioctl+0x3d/0xf0
> [<ffffffff8113d624>] do_vfs_ioctl+0x84/0x5b0
> [<ffffffff8112e255>] ? fget_light+0x75/0x290
> [<ffffffff8100310c>] ? sysret_check+0x27/0x62
> [<ffffffff8113dbd1>] sys_ioctl+0x81/0xa0
> [<ffffffff810030db>] system_call_fastpath+0x16/0x1b
> Code: 86 fb ff ff 89 d8 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75
> f0 4c 8b 7d f8 c9 c3 66 0f
> RIP [<ffffffffa035de81>] i915_do_wait_request+0x101/0x4f0 [i915]
> RSP <ffff880139923a88>
> CR2: 0000000000000000
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa035cb27>] i915_get_gem_seqno+0x37/0x40 [i915]
> 
> 
> 
> Looks like problematic commit is e552eb7038a36d9b18860f525aa02875e313fe16
> Which changes i915_get_gem_seqno()   to access (dev_priv->seqno_page)[0]
> 
> 
> 	if (IS_I965G(dev))
> 		return ((volatile u32 *)(dev_priv->seqno_page))[0];
> 00000000000013e8 <i915_do_wait_request+0xf8> mov    0x88(%r14),%rcx
> 	BUG_ON(seqno == 0);
> 
> 	if (atomic_read(&dev_priv->mm.wedged))
> 		return -EIO;

Arg, when I changed over to the HAS_PIPE_CONTROL macro I didn't update
the get_seqno function appropriately.  Patch on its way.

-- 
Jesse Barnes, Intel Open Source Technology Center
