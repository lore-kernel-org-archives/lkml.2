Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2F1Mia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:38:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1477 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2F1Mi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:38:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Jun 2012 05:35:19 -0700
Message-ID: <4FEC4FA9.20004@nvidia.com>
Date: Thu, 28 Jun 2012 18:05:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <4FEC3B70.5030902@metafoo.de> <s5hobo3zl79.wl%tiwai@suse.de> <20120628121816.GB21029@sirena.org.uk> <4FEC4E62.3020101@metafoo.de> <20120628122830.GJ28922@opensource.wolfsonmicro.com>
In-Reply-To: <20120628122830.GJ28922@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 05:58 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jun 28, 2012 at 02:30:26PM +0200, Lars-Peter Clausen wrote:
>> On 06/28/2012 02:18 PM, Mark Brown wrote:
>>> Oh, dear - this means we don't actually have a generic API at all.  Is
>>> there any effort being made to make this generally available?
>> Yes there is, and in fact in next/master there is generic
>> dma_mmap_writecombine. I'm not quite sure how it behaves on non ARM archs
>> though. But in theory it should fallback to a normal coherent mapping. Marek
>> did a lot of work on this, I've put him on Cc.

So can we put the function snd_pcm_lib_writecombine_mmap() in the 
pcm_native.c and only export this api for ARM i.e.  under macro  #ifdef 
CONFIG_ARM so that ARM based SOCs like Tegra/epa3xx/mxs/spear can 
directly use that one?
Or, wait for this common API until all ARCH support it?
