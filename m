Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2APTdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:33:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59132 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630Ab2APTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:33:12 -0500
Date: Mon, 16 Jan 2012 19:33:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org
Subject: Re: [PATCH v2 1/2] backlight: lcd: add driver for raster-type lcd's
 with gpio controlled panel reset
Message-ID: <20120116193309.GG3514@opensource.wolfsonmicro.com>
References: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
 <1326354211-27064-2-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326354211-27064-2-git-send-email-thomas.abraham@linaro.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 01:13:30PM +0530, Thomas Abraham wrote:

> +			/* set regulator voltage if specified */
> +			if (pd->min_uV || pd->max_uV)
> +				if (regulator_set_voltage(lp->regulator,
> +						pd->min_uV, pd->max_uV))
> +					dev_info(lp->dev,
> +						"voltage set failed\n");
> +			if (regulator_enable(lp->regulator))
> +				dev_info(lp->dev, "regulator enable failed\n");

You should really pay more attention to the errors here, especially for
the enable - this function does return an error code so you could
usefully tell the caller about failures.

> +	/*
> +	 * If power to lcd and/or lcd interface is controlled using a regulator,
> +	 * get the handle to the regulator for later use during power switching.
> +	 */
> +	lp->regulator = regulator_get(dev, "vcc-lcd");
> +	if (IS_ERR(lp->regulator))
> +		dev_info(dev, "could not find regulator\n");

It's much better style to assume that there will be a regulator in the
code and let the core worry about stubbing it out.  Given that you don't
offer any support for varying the voltage dynamically I'd suggest just
removing the set_voltage() support for now - if someone adds it they can
always add additional properties and worry about handling that situation
then.
