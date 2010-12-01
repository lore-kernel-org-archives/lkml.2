Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0LALZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:25:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52292 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311Ab0LALZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:25:18 -0500
Date: Wed, 1 Dec 2010 11:25:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yong Shen <yong.shen@linaro.org>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] make mc13783 regulator code generic
Message-ID: <20101201112515.GC24176@rakim.wolfsonmicro.main>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
X-Cookie: << WAIT >>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 03:15:55PM +0800, Yong Shen wrote:

>  move some common functions and micros of mc13783 regulaor driver to
> a seperate file, which makes it possible for mc13892 to share code.

You've done way more than this in the patch - you've also renamed a lot
of things and done other restructurings.  I'd suggest splitting out the
big mechanical changes for easier review.  For example, a patch moving
code from one place to another, another patch renaming things and so on.

> +config REGULATOR_MC13XXX_CORE
> +	tristate "Support regulators on Freescale MC13xxx PMIC"
> +

This doesn't need to be user visible - the user only cares about the
individual regulator drivers.

>  	/* Power Gate enable value is 0 */
> -	if (id == MC13783_REGU_PWGT1SPI ||
> -	    id == MC13783_REGU_PWGT2SPI)
> +	if (id == MC13783_REG_PWGT1SPI ||
> +	    id == MC13783_REG_PWGT2SPI)
>  		en_val = 0;

I can't tell what the actual change is here?

> +int mc13xxx_sw_regulator(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}
> +

Eh?

> +MODULE_ALIAS("platform:mc13xxx-regulator-core");

Is there really going to be a platform device for this?

> +++ b/include/linux/regulator/mc13xxx.h

Pretty much everything in this file is internal to the driver and
shouldn't be in include/linux.
