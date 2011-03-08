Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1CHLwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:52:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60227 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754274Ab1CHLwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:52:24 -0500
Date: Tue, 8 Mar 2011 11:52:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052
 chips
Message-ID: <20110308115222.GB20944@opensource.wolfsonmicro.com>
References: <1299577241-31328-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299577241-31328-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:40:41AM +0100, Linus Walleij wrote:

> +config TPS6105X
> +	tristate "TPS61050/61052 Boost Converters"
> +	depends on I2C && EXPERIMENTAL

Why EXPERIMENTAL?

> +	select REGULATOR
> +	select REGULATOR_FIXED_VOLTAGE

> +	default y if MACH_U8500

Not sure I'm enthusiastic about that - it's sensible for the machine to
want that but I can see this getting out of hand if you've got a lot of
machines doing that.  Perhaps have the machine select the regulator for
builds with REGULATOR enabled?

> +	/* Put the chip in SHUTDOWN mode */
> +	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
> +		TPS6105X_REG0_MODE_MASK,
> +		TPS6105X_REG0_MODE_SHUTDOWN << TPS6105X_REG0_MODE_SHIFT);
> +	if (ret)
> +		return ret;

I'm not sure this is what we want.  If the device is driving the
backlight it'll result in the backlight flashing off during boot which
doesn't seem desirable.  The standard thing is just to inherit the
hardware state.
