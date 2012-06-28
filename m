Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2F1L7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:59:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10658 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2F1L7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:59:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Jun 2012 04:59:33 -0700
Message-ID: <4FEC468A.3080607@nvidia.com>
Date: Thu, 28 Jun 2012 17:26:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <20120628105148.GD28922@opensource.wolfsonmicro.com>
In-Reply-To: <20120628105148.GD28922@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 04:21 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jun 28, 2012 at 12:31:26PM +0530, Laxman Dewangan wrote:
>> The pcm mmap for the substream dma buffer is done using the
>> dma_mmap_writecombine().
>> Some of the chip sound driver like Spear, Tegra, Davinci,
>> ep93xx,snd_imx, snd_mxs, NUC900, OMAP, Samsung are doing this
>> mapping locally.
>> Add api in the snd dmaengine driver so that different client of
>> snd dmaengine can use this rather than implementing locally.
> OK, but I'd expect this to come along with one or more patches
> converting at least some of the users to the new API...

This is effort towards moving the Tegra pcm driver for dmangine based 
dma driver inplace of legacy dma driver for Tegra which have private API.

Currently, following 4 pcm driver can use this API directly keeping that 
they already using the generic snd dmaengine pcm driver.
ep93xx,
spear,
fsl,
mxs.
And Tegra will be next.

Other driver which can use this API are davinci, OMAP, samsung but 
because they are not using the snd_dmaengine_pcm driver's api as of now 
so not be very much useful for them.


Should I send one patch per driver change or squash all 4 file changes 
in one patch? Whatever will be easy or recommended?

