Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2GEJ3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:29:18 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:34644 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab2GEJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <1341480207-5651-1-git-send-email-shubhrajyoti@ti.com>
References: <1341480207-5651-1-git-send-email-shubhrajyoti@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 5 Jul 2012 14:58:20 +0530
Message-ID: <CAMQu2gzJgkGk5VCkUc1o7oxRhzSY1=Qp0HNR5jt0YFKzwsB10w@mail.gmail.com>
Subject: Re: [PATCH RFC] spi: omap2-mcspi: Fix the dma_unmap warning
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 2:53 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The dma_map and dma_unmap should have same parameter
> passed otherwise we get the below warn.
>
> ks8851 spi1.0: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x000000009f22]
>
> [    2.066925] Modules linked in:
> [    2.070312]
> [    2.071929] [<c001c250>] (unwind_backtrace+0x0/0x130) from [<c0043d84>] (warn_slowpath_common+0x4c/0x64)
> [    2.081909] [<c0043d84>] (warn_slowpath_common+0x4c/0x64) from [<c0043e30>] (warn_slowpath_fmt+0x30/0x40)
> [    2.091949] [<c0043e30>] (warn_slowpath_fmt+0x30/0x40) from [<c0293824>] (check_unmap+0x6d0/0x7b0)
> [    2.101348] [<c0293824>] (check_unmap+0x6d0/0x7b0) from [<c02939cc>] (debug_dma_unmap_page+0x64/0x70)
> [    2.111053] [<c02939cc>] (debug_dma_unmap_page+0x64/0x70) from [<c03519a4>] (omap2_mcspi_txrx_dma+0x2d8/0x4fc)
> [    2.121582] [<c03519a4>] (omap2_mcspi_txrx_dma+0x2d8/0x4fc) from [<c03524d8>] (omap2_mcspi_work.clone.4+0xf0/0x290)
> [    2.132537] [<c03524d8>] (omap2_mcspi_work.clone.4+0xf0/0x290) from [<c0352900>] (omap2_mcspi_transfer_one_message+0x288/0x438)
> [    2.144592] [<c0352900>] (omap2_mcspi_transfer_one_message+0x288/0x438) from [<c03503bc>] (spi_pump_messages+0x100/0x160)
> [    2.156127] [<c03503bc>] (spi_pump_messages+0x100/0x160) from [<c006635c>] (kthread_worker_fn+0xac/0x180)
> [    2.166168] [<c006635c>] (kthread_worker_fn+0xac/0x180) from [<c0066578>] (kthread+0x90/0x9c)
> [    2.175140] [<c0066578>] (kthread+0x90/0x9c) from [<c00157fc>] (kernel_thread_exit+0x0/0x8)
> [    2.183898] ---[ end trace d1830ce6e44292f2 ]---
>
> Fix the warn by changing the unmap parameter to the one used while doing
> dma_map.
>
> Reported-by: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
Looks fine to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
