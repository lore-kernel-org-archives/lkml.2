Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2JRJ3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:29:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64224 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2JRJ3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <507FA595.4020507@freescale.com>
References: <1350538335-29026-1-git-send-email-b32955@freescale.com>
	<1350541111.5263.3.camel@vkoul-udesk3>
	<507FA595.4020507@freescale.com>
Date: Thu, 18 Oct 2012 14:59:10 +0530
Message-ID: <CAJe_ZhfarH-HpJkEOpH=jY1Gc-UPEyuA4bJ4LSQES7Uyea2BQw@mail.gmail.com>
Subject: Re: [PATCH] dma: add new DMA control commands
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, marex@denx.de,
        Huang Shijie <shijie8@gmail.com>, alsa-devel@alsa-project.org,
        shawn.guo@linaro.org, linux@arm.linux.org.uk, tiwai@suse.de,
        artem.bityutskiy@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-mmc@vger.kernel.org, w.sang@pengutronix.de, perex@perex.cz,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, djbw@fb.com, khali@linux-fr.org, cjb@laptop.org,
        dwmw2@infradead.org, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2012 12:15, Huang Shijie <b32955@freescale.com> wrote:
> 于 2012年10月18日 14:18, Vinod Koul 写道:
>
>> Why cant you do start (prepare clock etc) when you submit the descriptor
>> to dmaengine. Can be done in tx_submit callback.
>> Similarly remove the clock when dma transaction gets completed.
>
> I ever thought this method too.
>
> But it will become low efficient in the following case:
>
>   Assuming the gpmi-nand driver has to read out 1024 pages in one _SINGLE_
> read operation.
> The gpmi-nand will submit the descriptor to dmaengine per page. So with your
> method,
> the system will repeat the enable/disable dma clock 1024 time. At every
> enable/disable dma clock,
> the system has to enable the clock chain and it's parents ...
>
> But with this patch, we only need to enable/disable dma clock one time, just
> at we select the nand chip.
>
If the clock is the dmac's property (not channels'), the toggling
seems too aggressive.
You could try using runtime_suspend/resume for clock
disabling/enabling. How about employing autosuspend with a few ms
delay?
