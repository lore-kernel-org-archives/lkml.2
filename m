Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2BHLEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:04:46 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45295 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975Ab2BHLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:04:43 -0500
Message-ID: <1328699077.20197.51.camel@cumari>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
From: Luciano Coelho <coelho@ti.com>
To: balbi@ti.com
Cc: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Date: Wed, 08 Feb 2012 13:04:37 +0200
In-Reply-To: <20120208105957.GB16334@legolas.emea.dhcp.ti.com>
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
	 <20120208105957.GB16334@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 12:59 +0200, Felipe Balbi wrote: 
> On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
> > Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
> 
> we generally like to see the commit subject here too. And adding the
> abbreviated commit instead of the full sha1, wouldn't hurt either ;-)

Ok, different practices. :)

I'll send v2.


> > i2c_omap.c breaks if CONFIG_OF is not set:
> > 
> > drivers/i2c/busses/i2c-omap.c: In function 'omap_i2c_probe':
> > drivers/i2c/busses/i2c-omap.c:1021: error: 'omap_i2c_of_match' undeclared (first use in this function)
> > drivers/i2c/busses/i2c-omap.c:1021: error: (Each undeclared identifier is reported only once
> > drivers/i2c/busses/i2c-omap.c:1021: error: for each function it appears in.)
> > 
> > This is because the definition of omap_i2c_of_match is #ifdef'd on
> > CONFIG_OF, but the usage of it is not.
> > 
> > Since the places where omap_ic2_of_match are prepared to get NULL
> > pointers if CONFIG_OF is not defined, we can simply define it to NULL.
> > 
> > Cc: Benoit Cousson <b-cousson@ti.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> 
> after fixing the commit log, you can add:
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> if you want.

Thanks for your quick review!

-- 
Cheers,
Luca.

