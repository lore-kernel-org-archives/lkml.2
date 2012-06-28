Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2F1M0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:26:42 -0400
Received: from smtp-out-130.synserver.de ([212.40.185.130]:1060 "EHLO
	smtp-out-120.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751473Ab2F1M0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:26:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6438
Message-ID: <4FEC4E62.3020101@metafoo.de>
Date: Thu, 28 Jun 2012 14:30:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <4FEC3B70.5030902@metafoo.de> <s5hobo3zl79.wl%tiwai@suse.de> <20120628121816.GB21029@sirena.org.uk>
In-Reply-To: <20120628121816.GB21029@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 02:18 PM, Mark Brown wrote:
> On Thu, Jun 28, 2012 at 02:15:38PM +0200, Takashi Iwai wrote:
>> Lars-Peter Clausen wrote:
> 
>>> to the ALSA core. Now that there is a generic dma_mmap_writecombine it may
>>> make sense to integrate this with snd_pcm_lib_default_mmap.
> 
>> Agreed.
> 
>> Also, it must be portable.  So far, only ARM has
>> dma_mmap_writecombine(), thus the build on other arch would fail as
>> is.
> 
> Oh, dear - this means we don't actually have a generic API at all.  Is
> there any effort being made to make this generally available?

Yes there is, and in fact in next/master there is generic
dma_mmap_writecombine. I'm not quite sure how it behaves on non ARM archs
though. But in theory it should fallback to a normal coherent mapping. Marek
did a lot of work on this, I've put him on Cc.

- Lars
