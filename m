Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab2INJ1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:27:52 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:56996 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759332Ab2INJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:27:48 -0400
Message-ID: <5052F8BC.4020102@ti.com>
Date: Fri, 14 Sep 2012 12:28:28 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>  <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>  <5051FB4D.3000009@metafoo.de> <1347593217.1943.26.camel@vkoul-udesk3>  <5052E72A.8040207@metafoo.de> <1347612630.1943.29.camel@vkoul-udesk3>
In-Reply-To: <1347612630.1943.29.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/14/2012 11:50 AM, Vinod Koul wrote:
>> Well, the idea was that the driver would disable interrupts if there is no
>> callback to call, since there would be nothing to do in the interrupt
>> handler anyway. But I guess the flags approach should work fine as well.
> Yes we _could_ do that, but this relies on dmaengine driver to have this
> implicit understanding. Anyone using dmaengine library in ASoC may or
> may not be aware of this, so i would consider it hackish.
> 
> Using this flag explicitly makes everyone aware what the intended
> behaviour is.

I'm not sure about which flags should ASoC set for the two case we are going
to have. I think it should be something like this:

unsigned long flags = DMA_CTRL_ACK;

if (!substream->runtime->no_period_wakeup)
	flags |= DMA_PREP_INTERRUPT;

I'm not 100% sure of the role of DMA_CTRL_ACK in this case. Or should we only
handle the DMA_PREP_INTERRUPT flag, like this:

unsigned long flags = 0;

if (!substream->runtime->no_period_wakeup)
	flags |= DMA_PREP_INTERRUPT;


What do you think?

-- 
Péter
