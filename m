Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2F1ODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:03:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10312 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2F1ODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:03:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 28 Jun 2012 07:03:33 -0700
Message-ID: <4FEC6399.5050505@nvidia.com>
Date: Thu, 28 Jun 2012 19:30:57 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>	<4FEC3B70.5030902@metafoo.de>	<s5hobo3zl79.wl%tiwai@suse.de>	<20120628121816.GB21029@sirena.org.uk>	<4FEC4E62.3020101@metafoo.de>	<20120628122830.GJ28922@opensource.wolfsonmicro.com>	<4FEC4FA9.20004@nvidia.com>	<s5hlij7zja0.wl%tiwai@suse.de>	<4FEC5642.9080908@nvidia.com>	<s5hk3yrzhte.wl%tiwai@suse.de>	<4FEC5DC7.5060600@nvidia.com> <s5hd34jzgs0.wl%tiwai@suse.de>
In-Reply-To: <s5hd34jzgs0.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 07:21 PM, Takashi Iwai wrote:
> At Thu, 28 Jun 2012 19:06:07 +0530,
> Laxman Dewangan wrote:
>
>>>> Then how about this?
>>>> create new file and header for snd-pcm-writecombine-buffer.c/.h and put
>>>> this in sound/core.
>>>> Select this file compilation through config SND_PCM_WRITECOMBINE_BUFFER
>>>> which will be select this config through sound/soc/xxx/Kconfig if they
>>>> want to use.
>>>> This will provide three apis: new, free and mmap.
>>> Way too much hustles than necessary...
>> Ooh no. :-(  I had taken the idea from snd_dmaengine_pcm driver.
>> Bit I like to hear simple way which solves the purpose.
> As Lars suggested, a simple ifdef should suffice for now.
> With the upcoming generic dma_mmap_writecombine() stuff, it'd be even
> simpler in future.
>
> But, still we need to be careful about this.  As mentioned, there is
> no flag to know the possibility of writecombine mmap beforehand.
> It'd be nice if we have either a compile-time or a run-time flag /
> function to check that.  Then the driver can also expose the mmap
> capability to user-space depending on the flag.

Yaah, this seems really simple. Thanks for suggestion.
If I understand it fully, the new apis will be declare in sound/pcm.h, 
implement it in pcm_native.c and use the config variable
CONFIG_SND_PCM_WRITECOMBINE_BUFFER for ifdef.

This will be selected in required sound/soc driver so they can use it 
like powerpc (for fsl) and ARM arch based soc.

