Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab2C3K0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:26:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58270 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab2C3K0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:26:11 -0400
Date: Fri, 30 Mar 2012 11:25:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120330102554.GA22981@n2100.arm.linux.org.uk>
References: <1331211513.4657.67.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081412550.29847@axis700.grange> <1331284918.4657.69.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange> <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com> <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:09:55PM +0100, Guennadi Liakhovetski wrote:
> 3. the wrapper, proposed by Russell, now calls dmaengine_slave_config(), 
> which fails, because that's a wrong channel (hope I get this right this 
> time - configuration has nothing to do with selection:-))

I keep saying this.  Slave configuration has nothing to do with
channel selection.  All it does is tell the DMA engine about the
essential details about the peripheral it's being asked to transfer
data with.

If a DMA engine itself doesn't support the peripheral, then none of
the channels on that DMA engine would support it - eg, if the peripheral
had a byte sized register but your DMA engine only supported word size,
that would be a valid reason to have slave_config() fail.

However, if that's the case why would you have wired the peripheral up
to such a DMA engine?  And that's the hint here: you can't use any
peripheral with any DMA engine - there has to be physical handshaking
signals connecting the two together.  And that's what actually controls
which DMA engines and DMA channels are suitable.

Not what the physical address or width or burst size required by the
peripheral.  It's all to do with physical electrical signal routing.

The sooner you get this silly idea that dmaengine_slave_config() should
somehow be involved with DMA channel selection the better it will be
for everyone.
