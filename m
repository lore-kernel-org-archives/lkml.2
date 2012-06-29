Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2F2RCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:02:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51542 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab2F2RCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:02:05 -0400
Message-ID: <4FEDDF89.1050907@wwwdotorg.org>
Date: Fri, 29 Jun 2012 11:02:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: tiwai@suse.de, perex@perex.cz, swarren@nvidia.com,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com> <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:34 AM, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> data transfer between SPI fifo and memory in
> place of legacy Tegra APB DMA.
> 
> Because generic soc-dmaengine-pcm uses the DMAs API
> based on dmaengine, using the exported APIs provided
> by this generic driver.
> 
> The new driver is selected if legacy driver is not
> selected and new dma driver is enabled through config
> file.

This works just fine with the existing non-dmaengine DMA driver enabled.

However, I can't get it to work with dmaengine:

> # aplay ~/abba-dq-48000-stereo.wav
> [  151.613476] tegra20-i2s tegra20-i2s.0: dmaengine pcm open failed with err -6
> [  151.620557] tegra20-i2s tegra20-i2s.0: can't open platform tegra20-i2s.0: -6
> aplay: main:654: audio open error: No such device or address

I do have the following in my local tree:
68a67b8 ARM: tegra: add device tree AUXDATA for APBDMA
0db7a96 ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"

I also fixed the compatible values in drivers/dma/tegra20-apb-dma.c so
the driver would get instantiated, which it does;
/sys/devices/tegra-apbdma/dma has a bunch of dmaengine channels in it.

(Note: This is on Ventana, although I doubt that makes much difference)

Is there something else I need to do to test this?
