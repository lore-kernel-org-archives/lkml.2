Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482Ab2EXWVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:21:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965386Ab2EXWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:21:06 -0400
Date: Thu, 24 May 2012 23:21:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: philippe.retornaz@epfl.ch
Cc: Fabio Estevam <festevam@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        marc@cpdesign.com.au, Shawn Guo <shawn.guo@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524222102.GP5361@opensource.wolfsonmicro.com>
References: <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
 <201205242338.41420.marc@cpdesign.com.au>
 <5844466.kI7qR0Os9A@laptop>
 <20120524163604.GM5361@opensource.wolfsonmicro.com>
 <20120524164101.GW3710@pengutronix.de>
 <CAOMZO5CZbQ9cjh+5Lj8R5hbYhizP891D01LuqbaRq8WTQs8zkQ@mail.gmail.com>
 <20120524180320.GO5361@opensource.wolfsonmicro.com>
 <20120524214229.1038515zms1khf6t@webmail.epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524214229.1038515zms1khf6t@webmail.epfl.ch>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:42:29PM +0200, philippe.retornaz@epfl.ch wrote:

> Sadly, after looking at the imx31 datasheet it seems it's a hardware
> limitation. We could maybe workaround it by using DMA to access the
> CSPI but even with dma, this would need a single transfer in order
> to keep the CS signal asserted.

Oh dear, though the DMA approach sounds like it might be doable...

> Thus, we need to workaround this in the regmap-spi or mc13783-spi driver.
> Either we find a way to have regmap-spi to use 32bits transfert or
> we implement a custom bus inside mc13783-spi.

Like I said in my previous message the ideal thing would be that the SPI
driver would handle this, that'll ensure that the fix gets propagated to
the maximum possible set of users and is nicer from an abstraction point
of view.

A regmap internal workaround can possibly use Stephen Warren's stuff for
allowing buses to specify endianness stuff that was posted earlier today
though there's a few more tricks needed since this combines reads and
writes.  We may also need to extend the SPI bus to make the capabilities
of the controller discoverable, right now I'm not sure that regmap can
discover when it could activate any more complex stuff.  If we can make
it cheap enough to decide it'd probably be a small performance win even
where the controllers don't have issues.
