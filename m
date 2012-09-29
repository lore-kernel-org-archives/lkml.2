Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2I2Se4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 14:34:56 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:51769 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab2I2Sez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:55 -0400
Date: Sat, 29 Sep 2012 18:34:54 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Matt Porter <mporter@ti.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
Message-ID: <alpine.DEB.2.00.1209291830270.20956@utopia.booyaka.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cc Omar

Hi Matt

On Fri, 28 Sep 2012, Matt Porter wrote:

> The AM33xx support requires some help in hwmod due to the following
> comment in arch/arm/mach-omap2/omap_hwmod.c:
> 	/*
> 	 * If an IP block contains HW reset lines and any of them are
> 	 * asserted, we let integration code associated with that
> 	 * block handle the enable.  We've received very little
> 	 * information on what those driver authors need, and until
> 	 * detailed information is provided and the driver code is
> 	 * posted to the public lists, this is probably the best we
> 	 * can do.
> 	 */
> 
> The approach to deal with the hardware reset (for at least the pruss
> hwmod) was to add a generic omap property to properly define this
> hardware. The implementation simply deasserts any rst lines that
> are called out in the property when the omap_device is
> instantiated. This is not the ideal implementation as the sequence is
> a bit wrong for pruss since the busy check during the hard reset
> will fail, even though it fails in a benign manner. Ideally, we would
> want the implementation to observe the ti,deassert-hard-reset property
> and use that in omap_hwmod.c:_enable() *after* the module is unidled
> and the clocks active. However, this is actually functional for purposes
> of getting the uio_pruss driver up and running.

Could you please sync with Omar on the hard reset handling?  He posted 
some patches that change the hard reset code.  Perhaps you can align on an 
approach with him?

A few general comments: if some new per-IP block flag is needed to control 
this, the best place for it right now would be the hwmod data in 
arch/arm/mach-omap2/omap_hwmod_*_data.c, rather than DT.  At some point 
soon, the hard reset handling will be split between a PRM driver and some 
hwmod bus driver, and it seems best to deal with the DT binding question 
at that time.  That way we don't wind up with a legacy binding that has to 
be supported over the long term.


- Paul
