Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2INHO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:14:28 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36229 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071Ab2INHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:14:26 -0400
Message-ID: <5052D979.3030901@ti.com>
Date: Fri, 14 Sep 2012 10:15:05 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com> <5051FB4D.3000009@metafoo.de> <20120913153824.GK28448@n2100.arm.linux.org.uk>
In-Reply-To: <20120913153824.GK28448@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 06:38 PM, Russell King - ARM Linux wrote:
> On Thu, Sep 13, 2012 at 05:27:09PM +0200, Lars-Peter Clausen wrote:
>> Hm... Do you think it would work as well if we implement this by setting the
>> callback for the descriptor to NULL? If the callback is NULL there is
>> nothing to at the end of a transfer/period and the dma engine driver may
>> choose to disable interrupts. This would also benefit non cyclic transfers
>> where the callback is NULL and we do not need add the new parameter to
>> dmaengine_prep_dma_cyclic.
> 
> Actually, there's a way to do that already.  DMA_PREP_INTERRUPT.
> Unfortunately, most DMA engine slave API users don't set it when they
> setup their transfer:
> 
>  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
>  *  this transaction

As I mentioned already to Vinod: the description of this flag is close enough
for our needs (other than the notion of 'this transaction' is not really
correct for cyclic mode).
I will resend the series to add the flags as new parameter instead of the
no_wakeup.

> 
> if we fixed that, then we could use the lack of it to avoid the interrupt.
> 
> However, cyclic transfers don't have the flags parameter used to pass this
> bit.  Yet another bit of yucky inconsistent design in DMA engine land...
> 


-- 
Péter
