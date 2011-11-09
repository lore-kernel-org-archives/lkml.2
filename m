Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1KITMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:12:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KITMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:12:03 -0500
Date: Wed, 9 Nov 2011 19:11:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'Ryan Mallon'" <rmallon@gmail.com>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111109191136.GP12913@n2100.arm.linux.org.uk>
References: <cover.1320753142.git.n.voss@weinmann.de> <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de> <4EB9B24A.5040809@gmail.com> <EF2E73589CA71846A15D0B2CDF79505D087B3C9440@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B3C9440@wm021.weinmann.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 05:01:07PM +0100, Voss, Nikolaus wrote:
> Hi Ryan,
> > 
> > > +	dev->irq = irq->start;
> > > +	platform_set_drvdata(pdev, dev);
> > > +
> > > +	dev->clk = clk_get(&pdev->dev, "twi_clk");
> > 
> > 
> > This didn't get answered. Can't you just do:
> > 
> > 	dev->clk = clk_get(&pdev->dev, NULL);
> > 
> > and clkdev should figure out the correct clock based on the device pointer?
> 
> No, this doesn't work on at91 since the clocks have no dev_id property
> but only con_id. I cannot see a reason for this, but that's the way it's
> done. Multiple hardware interfaces are handled via a lookup table.

If you can, you could move over to doing this via the standard method
and start switching some of this stuff over to using dev_id.

We'll then have another platform starting to use this stuff correctly.
