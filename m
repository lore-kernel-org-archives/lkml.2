Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1KSMi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 07:38:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1KSMi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 07:38:57 -0500
Date: Sat, 19 Nov 2011 14:38:37 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
 <4EC27EED.4030108@metasoft.pl>
 <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
 <4EC374F0.8000400@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC374F0.8000400@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay. I've been busy with other things.

On Wed, Nov 16, 2011 at 09:31:44AM +0100, Rafal Prylowski wrote:
> 
> sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
>  or FUA
> Internal error: Oops - undefined instruction: 0 [#1]
> CPU: 0    Not tainted  (3.2.0-rc1EP-1+ #1008)
> PC is at 0xc184c868
> LR is at ep93xx_dma_tasklet+0xec/0x164
> pc : [<c184c868>]    lr : [<c012b528>]    psr: 00000013
> sp : c02b7e70  ip : ffffffff  fp : c02b7ea4
> r10: 00000100  r9 : 80000013  r8 : c02b7e50
> r7 : c02b7e70  r6 : c02b7ea4  r5 : 000000a4  r4 : c02b7e70
> r3 : c02b751d  r2 : 8ae34598  r1 : c184c6e0  r0 : c02b7ea4
> Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: c000717f  Table: c0004000  DAC: 00000017
> Process swapper (pid: 0, stack limit = 0xc02b6270)
> Stack: (0xc02b7e70 to 0xc02b8000)
> 7e60:                                     c02b7ea4 c02b7e70 c0008b64 c02bd5c4
> 7e80: c02d60e0 00000000 00000000 c02bd44c c02d60e0 00000100 c02b7ec4 c02b7ea8
> 7ea0: c001c49c c012b44c 00000018 00000001 c02d60e0 c02b6000 c02b7f04 c02b7ec8
> 7ec0: c001cbc0 c001c3e4 c02b7eec c02b7ed8 00000006 0000000a c02bf674 c02c458c
> 7ee0: 00000011 00000000 c02b7f7c c0004000 41129200 c02b0c80 c02b7f14 c02b7f08
> 7f00: c001cdd0 c001cb38 c02b7f34 c02b7f18 c000983c c001cd98 c0009a60 60000013
> 7f20: fefb0001 c02b7f7c c02b7f44 c02b7f38 c0008190 c0009810 c02b7f9c c02b7f48
> 7f40: c0008b64 c0008190 c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
> 7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
> 7f80: c0009a54 c0009a60 60000013 ffffffff c02b7fbc c02b7fa0 c000a03c c0009a40
> 7fa0: c02b80b0 c02b19dc c02b19d8 c02baa80 c02b7fcc c02b7fc0 c02384e4 c0009fd4
> 7fc0: c02b7ff4 c02b7fd0 c029d924 c0238494 c029d49c 00000000 00000000 c02b19dc
> 7fe0: c0007175 c02b803c 00000000 c02b7ff8 c000803c c029d700 00000000 00000000
> Backtrace:
> [<c012b43c>] (ep93xx_dma_tasklet+0x0/0x164) from [<c001c49c>] (tasklet_action+0x
> c8/0xdc)
> [<c001c3d4>] (tasklet_action+0x0/0xdc) from [<c001cbc0>] (__do_softirq+0x98/0x15
> 4)
>  r7:c02b6000 r6:c02d60e0 r5:00000001 r4:00000018
> [<c001cb28>] (__do_softirq+0x0/0x154) from [<c001cdd0>] (irq_exit+0x48/0x50)
> [<c001cd88>] (irq_exit+0x0/0x50) from [<c000983c>] (handle_IRQ+0x3c/0x8c)
> [<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
>  r7:c02b7f7c r6:fefb0001 r5:60000013 r4:c0009a60
> [<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
> Exception stack(0xc02b7f48 to 0xc02b7f90)
> 7f40:                   c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
> 7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
> 7f80: c0009a54 c0009a60 60000013 ffffffff
> [<c0009a30>] (default_idle+0x0/0x34) from [<c000a03c>] (cpu_idle+0x78/0xb0)
> [<c0009fc4>] (cpu_idle+0x0/0xb0) from [<c02384e4>] (rest_init+0x60/0x78)
>  r7:c02baa80 r6:c02b19d8 r5:c02b19dc r4:c02b80b0
> [<c0238484>] (rest_init+0x0/0x78) from [<c029d924>] (start_kernel+0x234/0x278)
> [<c029d6f0>] (start_kernel+0x0/0x278) from [<c000803c>] (0xc000803c)
>  r5:c02b803c r4:c0007175
> Code: 42555300 54535953 643d4d45 65766972 (53007372)
> ---[ end trace a494979f60859f42 ]---

It looks like following scenario happened:

	1. DMA interrupt is asserted

	2. Interrupt is handled by ep93xx_dma_interrupt()

	3. It schedules the ep93xx_dma_tasklet() but for some reason the
	   tasklet is not immediately run when the interrupt handler returns.

	4. Your driver calls dma_terminate_all() making the active list empty
	   and disabling the channel & interrupt.

	5. ep93xx_dma_tasklet() is run and since the list is empty, it gets
	   pointer to some garbage which then OOPses as it tries to execute
	   ->complete() which points to memory containing:

	Code: 42555300 54535953 643d4d45 65766972 (53007372)

	translated to ascii:

	\0SUBSYSTEM=drivers\0S

	probably the memory was re-used by some uevent.

I wasn't able to reproduce this but can you try if following patch helps? I'm
not sure if it is correct but at least we get more information about the
problem.

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 6181811..5b717da 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -1106,6 +1106,7 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
 	spin_lock_irqsave(&edmac->lock, flags);
 	/* First we disable and flush the DMA channel */
 	edmac->edma->hw_shutdown(edmac);
+	tasklet_kill(&edmac->tasklet);
 	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
 	list_splice_init(&edmac->active, &list);
 	list_splice_init(&edmac->queue, &list);
