Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2F1Mk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:40:59 -0400
Received: from smtp-out-130.synserver.de ([212.40.185.130]:1033 "EHLO
	smtp-out-120.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752046Ab2F1Mk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:40:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28483
Message-ID: <4FEC51BB.2040504@metafoo.de>
Date: Thu, 28 Jun 2012 14:44:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <20120628105148.GD28922@opensource.wolfsonmicro.com> <4FEC468A.3080607@nvidia.com>
In-Reply-To: <4FEC468A.3080607@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 01:56 PM, Laxman Dewangan wrote:
> On Thursday 28 June 2012 04:21 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Thu, Jun 28, 2012 at 12:31:26PM +0530, Laxman Dewangan wrote:
>>> The pcm mmap for the substream dma buffer is done using the
>>> dma_mmap_writecombine().
>>> Some of the chip sound driver like Spear, Tegra, Davinci,
>>> ep93xx,snd_imx, snd_mxs, NUC900, OMAP, Samsung are doing this
>>> mapping locally.
>>> Add api in the snd dmaengine driver so that different client of
>>> snd dmaengine can use this rather than implementing locally.
>> OK, but I'd expect this to come along with one or more patches
>> converting at least some of the users to the new API...
> 
> This is effort towards moving the Tegra pcm driver for dmangine based dma
> driver inplace of legacy dma driver for Tegra which have private API.
> 
> Currently, following 4 pcm driver can use this API directly keeping that
> they already using the generic snd dmaengine pcm driver.
> ep93xx,
> spear,
> fsl,
> mxs.
> And Tegra will be next.
> 
> Other driver which can use this API are davinci, OMAP, samsung but because
> they are not using the snd_dmaengine_pcm driver's api as of now so not be
> very much useful for them.

Btw. all these drivers basically use the same code for buffer preallocation.
Since how the buffer is mmaped is related to how it is allocated it might be
worth to factor this out at the same time as well.

- Lars
