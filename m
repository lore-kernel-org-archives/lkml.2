Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2GBI3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:29:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15236 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GBI3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:29:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 02 Jul 2012 01:29:44 -0700
Message-ID: <4FF15B16.9020903@nvidia.com>
Date: Mon, 2 Jul 2012 13:55:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>,
        Stephen Warren <swarren@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com> <1340969673-7776-2-git-send-email-ldewangan@nvidia.com> <4FEDDF89.1050907@wwwdotorg.org> <4FEF166D.2010705@nvidia.com>
In-Reply-To: <4FEF166D.2010705@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2012 08:38 PM, Laxman Dewangan wrote:
> On Friday 29 June 2012 10:32 PM, Stephen Warren wrote:
>> On 06/29/2012 05:34 AM, Laxman Dewangan wrote:
>>> Use the dmaengine based Tegra APB DMA driver for
>>> data transfer between SPI fifo and memory in
>>> place of legacy Tegra APB DMA.
>>>
>>> Because generic soc-dmaengine-pcm uses the DMAs API
>>> based on dmaengine, using the exported APIs provided
>>> by this generic driver.
>>>
>>> The new driver is selected if legacy driver is not
>>> selected and new dma driver is enabled through config
>>> file.
>> This works just fine with the existing non-dmaengine DMA driver enabled.
>>
>> However, I can't get it to work with dmaengine:
>>
>>> # aplay ~/abba-dq-48000-stereo.wav
>>> [  151.613476] tegra20-i2s tegra20-i2s.0: dmaengine pcm open failed with err -6
>>> [  151.620557] tegra20-i2s tegra20-i2s.0: can't open platform tegra20-i2s.0: -6
>>> aplay: main:654: audio open error: No such device or address
> With the error, it seems that dmachannel is not getting allocated.
>
>> I do have the following in my local tree:
>> 68a67b8 ARM: tegra: add device tree AUXDATA for APBDMA
>> 0db7a96 ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"
>>
> Some dma changes which I sent and already on linux-next are also require
> with the above change.
> Alsong with that I have local change like to rename the dma driver to
> compatible with dts files (remove -new from driver).
>
> I think I should send that patches so that you can test it by:
> - Taking already applied dma driver change in linux-next.
> - Apply my new patches which I am going to send.
>
> And do local change in the tegra_defconfig to disable SYSTEM_DMA and
> enable dmaengine based dma driver.
>
>
The new dma patches are:

  dma: tegra: fix residual calculation for cyclic case
  dma: tegra: rename driver and compatible to match with dts

You require dma changes which is already in linux-next:

  dma: tegra: set DMA_CYCLIC capability
  dma: tegra: do not set transfer desc flag to DMA_CTRL_ACK in cyclic mode
  dma: tegra: add clk_prepare/clk_unprepare
  dma: tegra: use sg_dma_address() for getting dma buffer address
  dma: tegra: add dmaengine based dma driver



