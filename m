Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2IMPjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:39:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2IMPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:39:40 -0400
Date: Thu, 13 Sep 2012 16:38:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to
	dmaengine_prep_dma_cyclic()
Message-ID: <20120913153824.GK28448@n2100.arm.linux.org.uk>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com> <5051FB4D.3000009@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051FB4D.3000009@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:27:09PM +0200, Lars-Peter Clausen wrote:
> Hm... Do you think it would work as well if we implement this by setting the
> callback for the descriptor to NULL? If the callback is NULL there is
> nothing to at the end of a transfer/period and the dma engine driver may
> choose to disable interrupts. This would also benefit non cyclic transfers
> where the callback is NULL and we do not need add the new parameter to
> dmaengine_prep_dma_cyclic.

Actually, there's a way to do that already.  DMA_PREP_INTERRUPT.
Unfortunately, most DMA engine slave API users don't set it when they
setup their transfer:

 * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
 *  this transaction

if we fixed that, then we could use the lack of it to avoid the interrupt.

However, cyclic transfers don't have the flags parameter used to pass this
bit.  Yet another bit of yucky inconsistent design in DMA engine land...
