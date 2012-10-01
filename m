Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2JAMyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:54:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58945 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2JAMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:53:59 -0400
Date: Mon, 1 Oct 2012 08:54:18 -0400
From: Matt Porter <mporter@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        omar.luna@linaro.org
Subject: Re: [PATCH v2 0/7] uio_pruss cleanup and platform support
Message-ID: <20121001125418.GK5641@beef>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
 <alpine.DEB.2.00.1209291830270.20956@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209291830270.20956@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 06:34:54PM +0000, Paul Walmsley wrote:
> 
> cc Omar
> 
> Hi Matt
> 
> On Fri, 28 Sep 2012, Matt Porter wrote:
> 
> > The AM33xx support requires some help in hwmod due to the following
> > comment in arch/arm/mach-omap2/omap_hwmod.c:
> > 	/*
> > 	 * If an IP block contains HW reset lines and any of them are
> > 	 * asserted, we let integration code associated with that
> > 	 * block handle the enable.  We've received very little
> > 	 * information on what those driver authors need, and until
> > 	 * detailed information is provided and the driver code is
> > 	 * posted to the public lists, this is probably the best we
> > 	 * can do.
> > 	 */
> > 
> > The approach to deal with the hardware reset (for at least the pruss
> > hwmod) was to add a generic omap property to properly define this
> > hardware. The implementation simply deasserts any rst lines that
> > are called out in the property when the omap_device is
> > instantiated. This is not the ideal implementation as the sequence is
> > a bit wrong for pruss since the busy check during the hard reset
> > will fail, even though it fails in a benign manner. Ideally, we would
> > want the implementation to observe the ti,deassert-hard-reset property
> > and use that in omap_hwmod.c:_enable() *after* the module is unidled
> > and the clocks active. However, this is actually functional for purposes
> > of getting the uio_pruss driver up and running.
> 
> Could you please sync with Omar on the hard reset handling?  He posted 
> some patches that change the hard reset code.  Perhaps you can align on an 
> approach with him?

Ok, yes, I looked over his series now and it goes some way to solving
the problem on PRUSS. My only concern is that the approach of loading up
function pointers in pdata for the assert/deassert calls gets a bit ugly on a
DT-only platform like AM33xx. I'll work with Omar on that.
 
> A few general comments: if some new per-IP block flag is needed to control 
> this, the best place for it right now would be the hwmod data in 
> arch/arm/mach-omap2/omap_hwmod_*_data.c, rather than DT.  At some point 
> soon, the hard reset handling will be split between a PRM driver and some 
> hwmod bus driver, and it seems best to deal with the DT binding question 
> at that time.  That way we don't wind up with a legacy binding that has to 
> be supported over the long term.

Ok, make sense.

Thanks,
Matt
