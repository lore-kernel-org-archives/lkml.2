Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2BHLBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:01:35 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41267 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580Ab2BHLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:01:33 -0500
Message-ID: <1328698888.20197.50.camel@cumari>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
From: Luciano Coelho <coelho@ti.com>
To: linux-i2c@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, tony@atomide.com,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>
Date: Wed, 08 Feb 2012 13:01:28 +0200
In-Reply-To: <1328698612-18661-1-git-send-email-coelho@ti.com>
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 12:56 +0200, Luciano Coelho wrote: 
> Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
> i2c_omap.c breaks if CONFIG_OF is not set:
> 
> drivers/i2c/busses/i2c-omap.c: In function 'omap_i2c_probe':
> drivers/i2c/busses/i2c-omap.c:1021: error: 'omap_i2c_of_match' undeclared (first use in this function)
> drivers/i2c/busses/i2c-omap.c:1021: error: (Each undeclared identifier is reported only once
> drivers/i2c/busses/i2c-omap.c:1021: error: for each function it appears in.)
> 
> This is because the definition of omap_i2c_of_match is #ifdef'd on
> CONFIG_OF, but the usage of it is not.
> 
> Since the places where omap_ic2_of_match are prepared to get NULL
> pointers if CONFIG_OF is not defined, we can simply define it to NULL.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Forgot to say that I think this should go into 3.3, since it's a build
break.

-- 
Cheers,
Luca.

