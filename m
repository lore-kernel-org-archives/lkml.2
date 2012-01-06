Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2AFGtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:49:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59657 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab2AFGtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:49:40 -0500
Date: Thu, 5 Jan 2012 22:49:30 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        kyungmin.park@samsung.com, cbou@mail.ru, kwangwoo.lee@gmail.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, patches@linaro.org
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
Message-ID: <20120106064929.GB3496@opensource.wolfsonmicro.com>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
 <4F05F509.6020405@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F05F509.6020405@metafoo.de>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:07:53PM +0100, Lars-Peter Clausen wrote:

> > +- lcd,pwrctrl-min-uV: If a regulator controls the Vcc voltage of the lcd panel,
> > +  this property specifies the minimum voltage the regulator should supply.
> > +  The value of this property should in in micro-volts.
> > +- lcd,pwrctrl-max-uV: If a regulator controls the Vcc voltage of the lcd panel,
> > +  this property specifies the maximum voltage the regulator should limit to
> > +  on the Vcc line. The value of this property should in in micro-volts.

> The min and max voltage should rather be specified through the regulator
> constraints.

In principle it should be specified in both places to account for shared
supplies though for all practical purposes for an LCD panel I can't see
multiple users sharing the same regulator and varying the voltage at
runtime.

> > +	if (lcd_enable) {
> > +		if ((pd->min_uV || pd->max_uV) &&
> > +			regulator_set_voltage(lp->regulator,
> > +						pd->min_uV, pd->max_uV))
> > +				dev_info(lp->dev,
> > +					"regulator voltage set failed\n");
> > +		if (regulator_enable(lp->regulator))
> > +			dev_info(lp->dev, "failed to enable regulator\n");
> > +	} else {
> > +		regulator_disable(lp->regulator);
> > +	}

> I think you have to make sure that the regulator enable and disable calls are
> balanced.

Yes.

> > +#ifdef CONFIG_OF

> I think you can remove all the CONFIG_OF ifdefs, the of API should stub itself out.

It's reasonably idiomatic to do this if the parsing code is in a
separate function.
