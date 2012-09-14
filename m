Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2INKCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:02:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32797 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2INKCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:02:20 -0400
Date: Fri, 14 Sep 2012 11:01:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to
	dmaengine_prep_dma_cyclic()
Message-ID: <20120914100140.GA12445@n2100.arm.linux.org.uk>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com> <5051FB4D.3000009@metafoo.de> <1347593217.1943.26.camel@vkoul-udesk3> <5052E72A.8040207@metafoo.de> <1347612630.1943.29.camel@vkoul-udesk3> <5052F8BC.4020102@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052F8BC.4020102@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:28:28PM +0300, Peter Ujfalusi wrote:
> I'm not sure about which flags should ASoC set for the two case we are going
> to have. I think it should be something like this:
> 
> unsigned long flags = DMA_CTRL_ACK;
> 
> if (!substream->runtime->no_period_wakeup)
> 	flags |= DMA_PREP_INTERRUPT;

That looks about right.  I would encourage DMA_CTRL_ACK to always be set
for slave stuff, because it will (according to my understanding of it)
make the behaviour no different from the async_tx stuff... which is
important when support for that stuff gets added.

We could, of course, set DMA_CTRL_ACK in the slave APIs beneath the
user, but the user has access to tx->flags between the prepare and
submit calls...  And doing it in the submit callback will force DMA
engine drivers to have two separate submission paths (as tx'es can't
be acked at submission time.)
