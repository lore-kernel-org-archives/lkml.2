Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2BQI0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:26:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47148 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2BQI0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:26:15 -0500
Date: Fri, 17 Feb 2012 09:26:09 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: imx/pcm038: Don't specify regulator consumers
 by struct device
Message-ID: <20120217082609.GP3852@pengutronix.de>
References: <1329449029.17110.1.camel@phoenix>
 <1329449121.17110.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329449121.17110.2.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:25:37 up 96 days, 16:12, 14 users,  load average: 0.00, 0.03,
 0.52
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 11:25:21AM +0800, Axel Lin wrote:
> The dev field is remove from struct regulator_consumer_supply since commit
> 737f36 "regulator: Remove support for supplies specified by struct device".
> 
> This fixes below build error:
>   CC      arch/arm/mach-imx/mach-pcm038.o
> arch/arm/mach-imx/mach-pcm038.c:236: error: unknown field 'dev' specified in initializer
> make[1]: *** [arch/arm/mach-imx/mach-pcm038.o] Error 1
> make: *** [arch/arm/mach-imx] Error 2

This is a duplicate of one of Fabios patches, I just sent a pull
request.

Sascha

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next 20120217.
> 
>  arch/arm/mach-imx/mach-pcm038.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
> index 16f126d..bfcc1ea 100644
> --- a/arch/arm/mach-imx/mach-pcm038.c
> +++ b/arch/arm/mach-imx/mach-pcm038.c
> @@ -233,7 +233,6 @@ static struct regulator_init_data sdhc1_data = {
>  
>  static struct regulator_consumer_supply cam_consumers[] = {
>  	{
> -		.dev	= NULL,
>  		.supply	= "imx_cam_vcc",
>  	},
>  };
> -- 
> 1.7.5.4
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
