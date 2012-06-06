Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2FFMUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:20:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64945 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FFMUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:20:30 -0400
X-AuditID: cbfee61b-b7f8f6d000005ca4-a7-4fcf4b0c1d98
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: konrad@darnok.org, rjw@sisk.pl
Cc: "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        kyungmin.park@samsung.com, arnd@arndb.de, tony.luck@intel.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>
References: <CAPbh3rtUA0_SBwi4+kXEF1gHh1OWzwEV92m88AwTGaUrScqv_w@mail.gmail.com>
In-reply-to: <CAPbh3rtUA0_SBwi4+kXEF1gHh1OWzwEV92m88AwTGaUrScqv_w@mail.gmail.com>
Subject: RE: Regression introduced by 0a2b9a6ea93650b8a00f9fd5ee8fdd25671e2df6
 ("X86: integrate CMA with DMA-mapping subsystem" Re: Bug in BUG: Bad page
 state in process work_for_cpu pfn:cf800
Date: Wed, 06 Jun 2012 14:19:57 +0200
Organization: SPRC
Message-id: <006601cd43de$b3eee130$1bcca390$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1DPSli4BakwTNZSJSEilsxmDg/ywAoHZtQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAV0e7/P+BjNfyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6My2tnMRWcl6pomreGvYFxp1gXIyeHhICJRNOz/+wQtpjEhXvr
	2boYuTiEBBYxSqy6t5sFwpnFJHFmYTdYFZuAoUTX2y42EFtEQEmi88RKZpAiZoGfjBKdj28y
	gySEBAIkZh6YCFTEwcEpECzx7LAGSI2wwBFGiY6GGSwgNSwCqhJLL+5gBqnhFxCSmDhLASTM
	K+Ai0X3zGxOELSjxY/I9FpASZgEdia+TIkDCzALaEk/eXWAFCUsIqEs8+qsLYooIGElc+20B
	USEicbfhOesERuFZSObMQpgzC8mcWUg6FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	Du1n0jsYVzVYHGIU4GBU4uE9oHDeX4g1say4MvcQowQHs5IIb5wzUIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjhv37Fz/kIC6YklqdmpqQWpRTBZJg5OqQbGNcyhLLyP1sk++2duddiqInxa2pfP
	uX52fBt2i0ecaKuTnbMxpu221d9tP8JkjFKdV5/9Yv7jBXvoRLnrPnNWZvpJXMw1tX4rUNSi
	aLXq9JzIBSlTLn+bt1fS5EXvtEWXP+1szty9zHLz+7Zjkjf7QzOreh8/iy6SiPxaqiJ7wXX+
	+fPbGGMblFiKMxINtZiLihMBRG61kWkCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Tuesday, June 05, 2012 7:04 PM Konrad Rzeszutek Wilk wrote:

> On Sat, Jun 2, 2012 at 7:36 AM, Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:
> > On Thu, May 31, 2012 at 3:19 AM, Marek Szyprowski
> > <m.szyprowski@samsung.com> wrote:
> >> Hi Konrad,
> >>
> >> On Thursday, May 31, 2012 2:45 AM Konrad Rzeszutek Wilk wrote:
> >>
> >>> About two-three days ago I started getting this on one of the AMD
> >>> machines I run nighly bootup test (full bootup log attached):
> >>> [Note: This is baremetal]
> >>>
> >>> ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
> >>> BUG: Bad page state in process work_for_cpu  pfn:cf800
> >>> page:ffffea0002d64000 count:-1 mapcount:0 ing:          (null) index:0x0
> >>> page flags: 0x100000000000000()
> >>> Modules linked in:
> >>> Pid: 1207, comm: work_for_cpu Not tainted 3.4.0upstream-09208-gaf56e0a #1
> >>> Call Trace:
> >>>  [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
> >>>  [<ffffffff811050bd>] bad_page+0xad/0x100
> >>>  [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
> >>>  [<ffffffff812916d8>] ? __const_udelay+0x28/0x30
> >>>  [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
> >>>  [<ffffffff810a2975>] ? dequeue_task_fair+0xa5/0x330
> >>>  [<ffffffff810367e2>] ? __switch_to+0x152/0x440
> >>>  [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
> >>>  [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
> >>>  [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
> >>>  [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
> >>>  [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
> >>>  [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
> >>>  [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
> >>>  [<ffffffff81389213>] ? device_pm_init+0x43/0x80
> >>>  [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
> >>>  [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
> >>>  [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
> >>>  [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
> >>>  [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
> >>>  [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
> >>>  [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
> >>>  [<ffffffff810906e6>] kthread+0x96/0xa0
> >>>  [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
> >>>  [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0x70
> >>>  [<ffffffff815b61e0>] ? gs_change+0x13/0x13
> >>> Disabling lock debugging due to kernel taint
> >>> BUG: Bad page state in process work_for_cpu  pfn:cf801
> >>>
> >>> I haven't actually run a git bisection, but the last git commit
> >>> that does something in the gart code looks to be this one:
> ..snip..
> > Doing a git bisection points it to this one:
> > is the first bad commit
> 
> I pulled todays linus's tree and if I revert the commit the bug disappears.
> This is on an Dell T105 AMD box running native x86_64.
> Any thoughts on what the bug might be?
 
I've read that patch three times line by line and I really have no idea what might cause such 
weird effect. When CMA is disabled this patch should not change anything in the code flow and 
the called functions... I assume that the CMA has not been enabled in your test config?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



