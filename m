Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2DEGGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:06:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:24856 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2DEGGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:06:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127325771"
Subject: Re: [dmaengine] Cyclic DMA regression.
From: Vinod Koul <vinod.koul@linux.intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <CACKLOr2-=BF4AV=ZDizj9D37OL-d9D06p6R+dp9cJ_vDbBwqBw@mail.gmail.com>
References: <CACKLOr2-=BF4AV=ZDizj9D37OL-d9D06p6R+dp9cJ_vDbBwqBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Apr 2012 11:38:03 +0530
Message-ID: <1333606083.31825.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 12:17 +0200, javier Martin wrote:
> The following BUG has been found trying an 'aplay' with a
> Visstrim_SM10 board in linux-3.4-rc1:
> 
> aplay /usr/share/sounds/linphone/hello16000.wav
> Playing WAVE '/usr/share/sounds/linphone/hello16000.wav' : Signed 16
> bit Little Endian, Rate 16000 Hz, Mono
> ------------[ cut here ]------------
> kernel BUG at drivers/dma/dmaengine.h:53!
> Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0    Not tainted  (3.4.0-rc1 #18)
> PC is at imxdma_tasklet+0x118/0x140
> LR is at imxdma_tasklet+0x38/0x140
> pc : [<c022af9c>]    lr : [<c022aebc>]    psr: 60000013
> sp : c049fed8  ip : c31974a4  fp : c04d85a0
> r10: c04d85b8  r9 : 00000102  r8 : 00000001
> r7 : c3018000  r6 : c30181ac  r5 : c3018160  r4 : c3343f60
> r3 : 00000000  r2 : 00000000  r1 : 0000001d  r0 : c31974b8
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 0005317f  Table: a3330000  DAC: 00000017
> Process swapper (pid: 0, stack limit = 0xc049e270)
> Stack: (0xc049fed8 to 0xc04a0000)
> fec0:                                                       00000000 c04ab758
> fee0: 00000000 00000018 00000001 c0028a14 c049e000 00000006 c049e000 c0028fdc
> ff00: c04afeb8 00000000 0000000a 00000000 41069264 c049e000 c04c3c10 00000000
> ff20: c049ff94 c04d3940 41069264 c04a6000 00000000 c0029330 00000021 c0015520
> ff40: c049ff60 0000ffff c04d3c48 c00086f0 c0015738 60000013 ffffffff c0362200
> ff60: 00000000 0005317f 0005217f 60000013 c049e000 c04d39c8 c04a8de0 00000001
> ff80: c04d3940 41069264 c04a6000 00000000 600000d3 c049ffa8 c001572c c0015738
> ffa0: 60000013 ffffffff c049e000 c0015cdc c04a6390 00000000 c0498684 c047f824
> ffc0: 00000000 00000000 c047f360 00000000 00000000 c0498684 00000000 00053175
> ffe0: c04a601c c0498680 c04a8dd4 a0004000 a04973e8 a0008040 00000000 00000000
> [<c022af9c>] (imxdma_tasklet+0x118/0x140) from [<c0028a14>]
> (tasklet_action+0x70/0xd8)
> [<c0028a14>] (tasklet_action+0x70/0xd8) from [<c0028fdc>]
> (__do_softirq+0xf0/0x240)
> [<c0028fdc>] (__do_softirq+0xf0/0x240) from [<c0029330>] (irq_exit+0x88/0x9c)
> [<c0029330>] (irq_exit+0x88/0x9c) from [<c0015520>] (handle_IRQ+0x34/0x84)
> [<c0015520>] (handle_IRQ+0x34/0x84) from [<c00086f0>]
> (avic_handle_irq+0x30/0x50)
> [<c00086f0>] (avic_handle_irq+0x30/0x50) from [<c0362200>] (__irq_svc+0x40/0x6c)
> Exception stack(0xc049ff60 to 0xc049ffa8)
> ff60: 00000000 0005317f 0005217f 60000013 c049e000 c04d39c8 c04a8de0 00000001
> ff80: c04d3940 41069264 c04a6000 00000000 600000d3 c049ffa8 c001572c c0015738
> ffa0: 60000013 ffffffff
> [<c0362200>] (__irq_svc+0x40/0x6c) from [<c0015738>] (default_idle+0x38/0x40)
> [<c0015738>] (default_idle+0x38/0x40) from [<c0015cdc>] (cpu_idle+0x9c/0xc4)
> [<c0015cdc>] (cpu_idle+0x9c/0xc4) from [<c047f824>] (start_kernel+0x230/0x2a4)
> Code: e3a03000 e595404c e5c530c0 eaffffd7 (e7f001f2)
> ---[ end trace 5b6e58d2f7425625 ]---
> 
> The issue is that all DMA cyclic users call "dmaengine_submit" just
> once [1], so only one descriptor is used and this descriptor is just
> looped  until "dmaengine_terminateall" is called.
> It seems this BUG affects every use of a DMA cyclic transfer in the kernel.
> 
> The implication of this is that the cookie of this descriptor is
> always 0 when "dma_cookie_complete" is called.
> 
> I've temporally solved the problem in my local tree with this (dirty) patch:
> ---
> diff --git a/drivers/dma/dmaengine.h b/drivers/dma/dmaengine.h
> index 17f983a..266e8ff 100644
> --- a/drivers/dma/dmaengine.h
> +++ b/drivers/dma/dmaengine.h
> @@ -52,7 +52,7 @@ static inline void dma_cookie_complete(struct
> dma_async_tx_descriptor *tx)
>  {
>         BUG_ON(tx->cookie < DMA_MIN_COOKIE);
>         tx->chan->completed_cookie = tx->cookie;
> -       tx->cookie = 0;
> +//     tx->cookie = 0;
>  }
> 
>  /**
> ---
> 
> But I guess we need something cleaner here.
this is not right fix. The problem is that we shouldn't mark the cyclic
descriptor as complete. So for all drivers using cyclic API they should
do something like this. Can you test if this fixes your issue.
-----------------
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index a45b5d2..0c7362a 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -571,11 +571,14 @@ static void imxdma_tasklet(unsigned long data)
        if (desc->desc.callback)
                desc->desc.callback(desc->desc.callback_param);
 
-       dma_cookie_complete(&desc->desc);
-
-       /* If we are dealing with a cyclic descriptor keep it on ld_active */
+       /* If we are dealing with a cyclic descriptor keep it on ld_active
+        * and don't mark the descriptor as complete.
+        * Only in non-cyclic cases it would be marked as complete
+        */
        if (imxdma_chan_is_doing_cyclic(imxdmac))
                goto out;
+       else
+               dma_cookie_complete(&desc->desc);
 
        /* Free 2D slot if it was an interleaved transfer */
        if (imxdmac->enabled_2d) {


-- 
~Vinod

