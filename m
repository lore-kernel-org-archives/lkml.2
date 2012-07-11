Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2GKHwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:52:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41143 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2GKHwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:52:40 -0400
Date: Wed, 11 Jul 2012 00:52:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v9] input: keyboard: Add keys driver for the LPC32xx SoC
Message-ID: <20120711075235.GA27353@core.coreip.homeip.net>
References: <1341948910-6530-1-git-send-email-stigge@antcom.de>
 <20120710205507.GA377@core.coreip.homeip.net>
 <4FFD2FF0.8030000@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFD2FF0.8030000@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 09:49:04AM +0200, Roland Stigge wrote:
> On 07/10/2012 10:55 PM, Dmitry Torokhov wrote:
> > Hi Roland,
> > 
> > On Tue, Jul 10, 2012 at 09:35:10PM +0200, Roland Stigge wrote:
> >> This patch adds a driver for the key scan interface of the LPC32xx SoC
> >>
> > 
> > Could of more things that I had in my patch but forgot to specifically
> > call out:
> > 
> >> +
> >> +	/* Configure the key scanner */
> >> +	clk_prepare_enable(kscandat->clk);
> > 
> > This may fail so we should handle errors.
> > 
> >> +	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
> >> +	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
> >> +	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
> >> +	       LPC32XX_KS_FAST_TST(kscandat->kscan_base));
> >> +	writel(kscandat->matrix_sz,
> >> +	       LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
> >> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> >> +	clk_disable_unprepare(kscandat->clk);
> >> +
> >> +	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
> > 
> > ...
> > 
> >> +
> >> +	free_irq(platform_get_irq(pdev, 0), pdev);
> > 
> > You are requesting IRQ with kscandat as an argument but freeing it with
> > 'pdev' which will fail.
> > 
> >> +
> >> +	if (kscandat->input->users) {
> >> +		/* Enable clock and clear IRQ */
> >> +		clk_prepare_enable(kscandat->clk);
> > 
> > Need to handle errors here as well.
> > 
> > Since I am partial to my rearrangement (basically I started preferring
> > err_<action> style of error labels as they more explanatory than out2 or
> > fail3 style of labels), could you try this version of my patch (on top
> > of your v9 one). Third time is a charm maybe? :)
> 
> Yes, works fine!
> 
> Thanks!
> 
> Acked-by: Roland Stigge <stigge@antcom.de>

Excellent, I'll fold it up into your original v9 patch and queue for
3.6.

Thank you for your patience.

-- 
Dmitry
