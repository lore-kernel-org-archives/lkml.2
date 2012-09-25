Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2IYTeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:34:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53273 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2IYTeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:34:02 -0400
Date: Tue, 25 Sep 2012 12:33:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/workqueue.c:1034 __queue_work+0x23d/0x2d7()
Message-ID: <20120925193357.GI16296@google.com>
References: <20120925192847.GF10125@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925192847.GF10125@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 25, 2012 at 09:28:47PM +0200, Borislav Petkov wrote:
> FYI: just hit this below on plain -rc7. Only once so far...
> 
> [ 5294.811825] ------------[ cut here ]------------
> [ 5294.816682] WARNING: at kernel/workqueue.c:1034 __queue_work+0x23d/0x2d7()
> [ 5294.823816] Hardware name: Dinar
> [ 5294.827165] Modules linked in: ohci_hcd radeon kvm_amd ttm drm_kms_helper kvm hwmon backlight cfbcopyarea e1000e cfbimgblt ehci_hcd amd64_edac_mod cfbfillrect edac_core microcode
> [ 5294.844005] Pid: 5076, comm: test Not tainted 3.6.0-rc7 #2
> [ 5294.849689] Call Trace:
> [ 5294.852232]  <IRQ>  [<ffffffff810330cd>] warn_slowpath_common+0x85/0x9d
> [ 5294.859145]  [<ffffffff810330ff>] warn_slowpath_null+0x1a/0x1c
> [ 5294.865206]  [<ffffffff8104c962>] __queue_work+0x23d/0x2d7
> [ 5294.877240]  [<ffffffff8104cab2>] delayed_work_timer_fn+0x2a/0x2e
> [ 5294.883573]  [<ffffffff81040d96>] run_timer_softirq+0x264/0x381
> [ 5294.908176]  [<ffffffff8103a4fc>] __do_softirq+0xdc/0x1de
> [ 5294.913786]  [<ffffffff81496a9c>] call_softirq+0x1c/0x30
> [ 5294.919304]  [<ffffffff81003253>] do_softirq+0x3d/0x86
> [ 5294.924646]  [<ffffffff8103a7e4>] irq_exit+0x53/0xb2
> [ 5294.929806]  [<ffffffff814970bf>] smp_apic_timer_interrupt+0x8b/0x99
> [ 5294.936408]  [<ffffffff8149631c>] apic_timer_interrupt+0x6c/0x80
> [ 5294.942640]  <EOI>  [<ffffffff8148ef06>] ? retint_swapgs+0xe/0x13
> [ 5294.949000] ---[ end trace eaf0764fd1698db2 ]---

That's __queue_work() seeing a delayed work item which either hasn't
been initialized properly or got corrupted somehow.  Can you please
stick printk("XXX offending function = %pf\n", work->func); right
below the WARN_ON() and try to reproduce the problem?

Thanks.

-- 
tejun
