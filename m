Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1CGIyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:54:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1CGIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:54:21 -0500
Date: Mon, 7 Mar 2011 09:53:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110307085358.GM29521@pengutronix.de>
References: <20110304080653.3f2c3f19@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304080653.3f2c3f19@debxo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:51:24 up 18 days, 20:48, 32 users,  load average: 0.22, 0.09,
 0.18
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:06:53AM -0800, Andres Salomon wrote:
> Note that this relies on stuff currently in mfd's next tree, but this
> is also a newer driver.  I'm not sure which tree it should go through,
> as it's a problem that shows up in next.

Please ping me again when the mfd tree is in Linus master. I see no
other chance fixing this on my side other than removing regulator
support for efika completely for now. So I guess you have to live with
the compile breakage for some time.

Sascha

> 
> 
> 
> From: Andres Salomon <dilinger@queued.net>
> 
> MFD changes in c738892f cause the mc13xxx_platform_data struct
> to change.  This changes one more (new) user of it, fixing a build
> error.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/arm/mach-mx5/mx51_efika.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/mx51_efika.c b/arch/arm/mach-mx5/mx51_efika.c
> index 74991c9..6451fb4 100644
> --- a/arch/arm/mach-mx5/mx51_efika.c
> +++ b/arch/arm/mach-mx5/mx51_efika.c
> @@ -572,8 +572,10 @@ static struct mc13xxx_regulator_init_data mx51_efika_regulators[] = {
>  
>  static struct mc13xxx_platform_data mx51_efika_mc13892_data = {
>  	.flags = MC13XXX_USE_RTC | MC13XXX_USE_REGULATOR,
> -	.num_regulators = ARRAY_SIZE(mx51_efika_regulators),
> -	.regulators = mx51_efika_regulators,
> +	.regulators = {
> +		.num_regulators = ARRAY_SIZE(mx51_efika_regulators),
> +		.regulators = mx51_efika_regulators,
> +	},
>  };
>  
>  static struct spi_board_info mx51_efika_spi_board_info[] __initdata = {
> -- 
> 1.7.2.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
