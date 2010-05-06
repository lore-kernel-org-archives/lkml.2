Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0EFGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:41:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0EFGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:41:37 -0400
Date: Thu, 6 May 2010 08:41:35 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] mc13783-regulator: fix vaild voltage range checking
	for mc13783_fixed_regulator_set_voltage
Message-ID: <20100506064135.GM31199@pengutronix.de>
References: <1273114469.24703.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273114469.24703.3.camel@mola>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:41:17 up 10 days, 7 min, 19 users,  load average: 0.35, 0.24,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 10:54:29AM +0800, Axel Lin wrote:
> In the case of "min_uV == max_uV == mc13783_regulators[id].voltages[0]",
> mc13783_fixed_regulator_set_voltage should return 0 instead of -EINVAL.
> 
> This patch also adds a missing ">" character for MODULE_AUTHOR, a
> trivial fix.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/regulator/mc13783-regulator.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c
> b/drivers/regulator/mc13783-regulator.c
> index ad036dd..4597d50 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -440,8 +440,8 @@ static int
> mc13783_fixed_regulator_set_voltage(struct regulator_dev *rdev,
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
>  		__func__, id, min_uV, max_uV);
>  
> -	if (min_uV > mc13783_regulators[id].voltages[0] &&
> -	    max_uV < mc13783_regulators[id].voltages[0])
> +	if (min_uV >= mc13783_regulators[id].voltages[0] &&
> +	    max_uV <= mc13783_regulators[id].voltages[0])
>  		return 0;
>  	else
>  		return -EINVAL;
> @@ -649,6 +649,6 @@ static void __exit mc13783_regulator_exit(void)
>  module_exit(mc13783_regulator_exit);
>  
>  MODULE_LICENSE("GPL v2");
> -MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de");
> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
>  MODULE_DESCRIPTION("Regulator Driver for Freescale MC13783 PMIC");
>  MODULE_ALIAS("platform:mc13783-regulator");
> -- 
> 1.5.4.3
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
