Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2IRI3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:29:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34845 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2IRI3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:29:22 -0400
Date: Tue, 18 Sep 2012 09:28:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 02/15] dmaengine: omap: Add support for pause/resume
	in cyclic dma mode
Message-ID: <20120918082843.GD12445@n2100.arm.linux.org.uk>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com> <1347624358-25582-3-git-send-email-peter.ujfalusi@ti.com> <1347851637.1943.125.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347851637.1943.125.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 08:43:57AM +0530, Vinod Koul wrote:
> On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> > -       /* FIXME: not supported by platform private API */
> > -       return -EINVAL;
> > +       /* Pause/Resume only allowed with cyclic mode */
> > +       if (!c->cyclic)
> > +               return -EINVAL; 
> This is not a dma restriction right?

This is needed because this is not a real "pause" - it is a stop, which
causes the contents of the DMA engine's FIFOs to be discarded - which
means a subsequent resume will loose data.
