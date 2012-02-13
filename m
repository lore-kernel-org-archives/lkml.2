Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2BNAMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:12:39 -0500
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:35885
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752962Ab2BNAMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:12:34 -0500
Date: Mon, 13 Feb 2012 23:27:07 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 3.3 v2] I2C: OMAP: fix build breakage when CONFIG_OF is
 not set
Message-ID: <20120213232707.GH2999@freya.fluff.org>
References: <1328699901-19488-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328699901-19488-1-git-send-email-coelho@ti.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 01:18:21PM +0200, Luciano Coelho wrote:
> Since commit 6145197 (i2c: OMAP: Add DT support for i2c controller),
> building i2c_omap.c breaks if CONFIG_OF is not set:
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
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> ---
> v2: changed the commit log to use abbrev sha and include the commit subject
> 
>  drivers/i2c/busses/i2c-omap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index f713eac..fd200eb 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -979,6 +979,8 @@ static const struct of_device_id omap_i2c_of_match[] = {
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, omap_i2c_of_match);
> +#else
> +static const struct of_device_id *omap_i2c_of_match = NULL;
>  #endif

of_match_ptr(_ptr) will go to NULL if CONFIG_OF is not set, use that please.
