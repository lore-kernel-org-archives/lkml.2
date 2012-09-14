Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab2INDdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:33:49 -0400
Received: from [205.233.59.134] ([205.233.59.134]:43461 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab2INDdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:33:47 -0400
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to
 dmaengine_prep_dma_cyclic()
From: Vinod Koul <vkoul@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: vinod.koul@intel.com, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, Ricardo Neri <ricardo.neri@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-arm-kernel@lists.infradead.org, Dan Williams <djbw@fb.com>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
In-Reply-To: <20120913153824.GK28448@n2100.arm.linux.org.uk>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
	 <5051FB4D.3000009@metafoo.de>
	 <20120913153824.GK28448@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:57:59 +0530
Message-ID: <1347593279.1943.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 16:38 +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 13, 2012 at 05:27:09PM +0200, Lars-Peter Clausen wrote:
> > Hm... Do you think it would work as well if we implement this by setting the
> > callback for the descriptor to NULL? If the callback is NULL there is
> > nothing to at the end of a transfer/period and the dma engine driver may
> > choose to disable interrupts. This would also benefit non cyclic transfers
> > where the callback is NULL and we do not need add the new parameter to
> > dmaengine_prep_dma_cyclic.
> 
> Actually, there's a way to do that already.  DMA_PREP_INTERRUPT.
> Unfortunately, most DMA engine slave API users don't set it when they
> setup their transfer:
> 
>  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
>  *  this transaction
Looks like I have repeated the correct action!
> 
> if we fixed that, then we could use the lack of it to avoid the interrupt.
> 
> However, cyclic transfers don't have the flags parameter used to pass this
> bit.  Yet another bit of yucky inconsistent design in DMA engine land...
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



