Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2EaHUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:20:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54985 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2EaHUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:20:05 -0400
Date: Thu, 31 May 2012 09:19:50 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Bug in BUG: Bad page state in process work_for_cpu  pfn:cf800
In-reply-to: <20120531004446.GA401@localhost.localdomain>
To: "'Konrad Rzeszutek Wilk'" <konrad@darnok.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        kyungmin.park@samsung.com, arnd@arndb.de, tony.luck@intel.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <02bf01cd3efd$c4980ec0$4dc82c40$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0+xpzg3U/XJhlZSxGLJdNt0MaGMgANYx/Q
References: <20120531004446.GA401@localhost.localdomain>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Thursday, May 31, 2012 2:45 AM Konrad Rzeszutek Wilk wrote:

> About two-three days ago I started getting this on one of the AMD
> machines I run nighly bootup test (full bootup log attached):
> [Note: This is baremetal]
> 
> ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
> BUG: Bad page state in process work_for_cpu  pfn:cf800
> page:ffffea0002d64000 count:-1 mapcount:0 ing:          (null) index:0x0
> page flags: 0x100000000000000()
> Modules linked in:
> Pid: 1207, comm: work_for_cpu Not tainted 3.4.0upstream-09208-gaf56e0a #1
> Call Trace:
>  [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
>  [<ffffffff811050bd>] bad_page+0xad/0x100
>  [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
>  [<ffffffff812916d8>] ? __const_udelay+0x28/0x30
>  [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
>  [<ffffffff810a2975>] ? dequeue_task_fair+0xa5/0x330
>  [<ffffffff810367e2>] ? __switch_to+0x152/0x440
>  [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
>  [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
>  [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
>  [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
>  [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
>  [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
>  [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
>  [<ffffffff81389213>] ? device_pm_init+0x43/0x80
>  [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
>  [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
>  [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
>  [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
>  [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
>  [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
>  [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
>  [<ffffffff810906e6>] kthread+0x96/0xa0
>  [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815b61e0>] ? gs_change+0x13/0x13
> Disabling lock debugging due to kernel taint
> BUG: Bad page state in process work_for_cpu  pfn:cf801
> 
> I haven't actually run a git bisection, but the last git commit
> that does something in the gart code looks to be this one:
> 
> commit baa676fcf8d555269bd0a5a2496782beee55824d
> Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Date:   Tue Mar 27 14:28:18 2012 +0200
> 
>     X86 & IA64: adapt for dma_map_ops changes
> 
> hence CC-ing on this e-email.

I hardly see how this commit can cause such issue. It was a pure code refactoring (attributes
parameter has been added to alloc/free functions) without any change in actual code flow. Maybe
something has been changed in core mm code or elsewhere in the driver? 'Bad page state' sounds
rather bad and might be cause by some trashing in completely unrelated code...

> Was wondering if other people had seen something similar to this?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



