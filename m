Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1GKAcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 20:32:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:50019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab1GKAcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 20:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,510,1304319600"; 
   d="scan'208";a="24198659"
Subject: Re: i915_gem_inactive_shrink fault
From: Lin Ming <ming.m.lin@intel.com>
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <201107101710.23262.maciej.rutecki@gmail.com>
References: <1309856364.18875.110.camel@minggr.sh.intel.com>
	 <201107101710.23262.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 08:39:22 +0800
Message-ID: <1310344762.18875.194.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 23:10 +0800, Maciej Rutecki wrote:
> On wtorek, 5 lipca 2011 o 10:59:24 Lin Ming wrote:
> > It seems i915 driver loads fail.
> > 
> > mlin@wsm:~$ dmesg |grep -i i915
> > i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > i915 0000:00:02.0: setting latency timer to 64
> > i915 0000:00:02.0: irq 47 for MSI/MSI-X
> > WARNING: at /linux-2.6/drivers/gpu/drm/i915/intel_display.c:826
> > assert_fdi_tx+0xcc/0xd8() [<ffffffff8133d865>]
> > i915_driver_load+0xb12/0x10e9
> >  [<ffffffff816a891a>] i915_pci_probe+0x1b/0x1d
> >  [<ffffffff81d12264>] i915_init+0x8b/0x8d
> > WARNING: at /linux-2.6/drivers/gpu/drm/i915/intel_display.c:826
> > assert_fdi_tx+0xcc/0xd8() [<ffffffff8133d865>]
> > i915_driver_load+0xb12/0x10e9
> >  [<ffffffff816a891a>] i915_pci_probe+0x1b/0x1d
> >  [<ffffffff81d12264>] i915_init+0x8b/0x8d
> > [drm:i915_driver_load] *ERROR* failed to init modeset
> > i915 0000:00:02.0: PCI INT A disabled
> > i915: probe of 0000:00:02.0 failed with error -5
> >  [<ffffffff81355191>] i915_gem_inactive_shrink+0x2b/0x18d
> > 
> > 
> > The fault message as below.
> > See the attachments for full dmesg, kernel config and lspci output.
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> > IP: [<ffffffff816d4422>] mutex_trylock+0x61/0x131
> > PGD 133cd5067 PUD 134301067 PMD 0
> > Oops: 0002 [#1] SMP
> > CPU 3
> > Modules linked in:
> > 
> > Pid: 2322, comm: bash Tainted: G        W   3.0.0-rc6-tip-mlin+ #571 Intel
> 
> Older kernels work fine?

No, 2.6.39 faults also.

Forgot to mention that what I run was
"echo 3 > /proc/sys/vm/drop_caches".

> 
> Regards


