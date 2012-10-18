Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2JRJAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:00:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54616 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2JRJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:00:50 -0400
Date: Thu, 18 Oct 2012 09:52:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Huang Shijie <b32955@freescale.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, djbw@fb.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, cjb@laptop.org,
        dwmw2@infradead.org, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de, shawn.guo@linaro.org, marex@denx.de,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH] dma: add new DMA control commands
Message-ID: <20121018085208.GR21164@n2100.arm.linux.org.uk>
References: <1350538335-29026-1-git-send-email-b32955@freescale.com> <1350541111.5263.3.camel@vkoul-udesk3> <507FA595.4020507@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <507FA595.4020507@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:45:41PM +0800, Huang Shijie wrote:
> 于 2012年10月18日 14:18, Vinod Koul 写道:
>> Why cant you do start (prepare clock etc) when you submit the descriptor
>> to dmaengine. Can be done in tx_submit callback.
>> Similarly remove the clock when dma transaction gets completed.
> I ever thought this method too.
>
> But it will become low efficient in the following case:
>
>   Assuming the gpmi-nand driver has to read out 1024 pages in one  
> _SINGLE_ read operation.
> The gpmi-nand will submit the descriptor to dmaengine per page. So with  
> your method,
> the system will repeat the enable/disable dma clock 1024 time. At every  
> enable/disable dma clock,
> the system has to enable the clock chain and it's parents ...

And what if you stop using clk_prepare_enable(), and prepare the clock
when the channel is requested and only use clk_enable() in the tx_submit
method?
