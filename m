Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2INHGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:06:47 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48250 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569Ab2INHGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:06:45 -0400
Message-ID: <5052D7AB.1090804@ti.com>
Date: Fri, 14 Sep 2012 10:07:23 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Barry Song <baohua.song@csr.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vista Silicon <javier.martin@vista-silicon.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via device_prep_dma_cyclic()
 callback
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>  <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com> <1347593040.1943.24.camel@vkoul-udesk3>
In-Reply-To: <1347593040.1943.24.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 06:24 AM, Vinod Koul wrote:
> On Thu, 2012-09-13 at 16:37 +0300, Peter Ujfalusi wrote:
>> Change the parameter list of device_prep_dma_cyclic() so the DMA drivers
>> can receive the no_wakeup request coming from client drivers.
>> This feature can be used during audio operation to disable all audio
>> related interrupts.
> We already have a flag to indicate this, see 
> * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion  of
> *  this transaction

I have also noticed this flag. It is not really a direct match for our case
since the notion of "completion of this transfer" is not applicable for cyclic
mode, but it is close enough.

> Unfortunately, the addition of cyclic API missed having this flag. So
> right way would be to add flag argument in the API.

I have not looked at the non cyclic APIs, but I think I can modify the
dmaengine_prep_dma_cyclic() to pass the flags instead of the 'bool no_wakeup'.
If the DMA_PREP_INTERRUPT is not set dma drivers can interpret it in a way
that they will disable all interrupts during cyclic mode.
None of the dma drivers in cyclic mode cares about the flags AFAIK or they can
just ignore this parameter for now (as they did with my no_wakeup parameter).
Will resend the series soon with this change.

-- 
Péter
