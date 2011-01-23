Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab1AWP7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:59:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:41055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1AWP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:59:52 -0500
Message-Id: <0d30dc$kr9795@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,366,1291622400"; 
   d="scan'208";a="699702565"
Date: Sun, 23 Jan 2011 15:59:48 +0000
To: chris2553@googlemail.com
Subject: Re: [PATCH] drm/i915: Handle the no-interrupts case for UMS by polling
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101231128.22951.chris2553@googlemail.com> <1295787965-6849-1-git-send-email-chris@chris-wilson.co.uk> <201101231538.41929.chris2553@googlemail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201101231538.41929.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 15:38:41 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> That's done it. With all three patches applied, X and KDE are starting now. 
> Thanks for your work on this.

That's good to hear!

> A couple of points though.
> 
> 1. The latest patch applied but the following warning was spat out:
> 
> patching file drivers/gpu/drm/i915/i915_irq.c
> Hunk #1 succeeded at 1288 (offset -5 lines).

Minor drift as I now have a number of outstanding patches for 2.6.38.
 
> I guess we may be working with slightly different versions of the source.
> 
> 2. The kernel log now contains the following:
> 
> r8169 0000:02:00.0: eth0: link up
> [drm] Initialized drm 1.1.0 20060810
> irq 16: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc2+ #502
> Call Trace:
>  [<c1070a54>] ? __report_bad_irq.clone.2+0x24/0x90
>  [<c1070c17>] ? note_interrupt+0x157/0x190
>  [<c101b1cd>] ? ack_apic_level+0x5d/0x1e0
>  [<c107175b>] ? handle_fasteoi_irq+0xab/0xd0
>  [<c10716b0>] ? handle_fasteoi_irq+0x0/0xd0
>  <IRQ>  [<c1004ddd>] ? do_IRQ+0x3d/0xc0
>  [<c1037f27>] ? irq_exit+0x57/0x70
>  [<c1019173>] ? smp_apic_timer_interrupt+0x53/0x90
>  [<c1003229>] ? common_interrupt+0x29/0x30
>  [<c119fbe9>] ? acpi_safe_halt+0x19/0x26
>  [<c119fc50>] ? acpi_idle_enter_c1+0x5a/0xa9
>  [<c1244d98>] ? cpuidle_idle_call+0x68/0xf0
>  [<c1001726>] ? cpu_idle+0x46/0x80
> handlers:
> [<c129dd60>] (azx_interrupt+0x0/0x180)
> [<c12210d0>] (usb_hcd_irq+0x0/0x60)
> Disabling IRQ #16
> pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:00:02.0: setting latency timer to 64
> ioremap error for 0xbdce0000-0xbdce3000, requested 0x10, got 0x0
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] No driver support for vblank timestamp query.
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> Is this likely to be related the the irq issues your patch addressed or is it a 
> separate thing that I should report separately?

It's the i915 IRQ alright, but I'm not sure what the cause is. An
unexpected interrupt arrived, although you don't use any paths in the
driver that use interrupts, nor should one be generated when all we are
doing is initialising the device structs. Should just be a minor nuisance
fortunately.

If you can open a bug report to track it and attach
/sys/kernel/debug/dri/0/i915_gem_interrupts maybe we can work out from
the interrupt that arrived, why it was triggered.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
