Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2IHDMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 23:12:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2IHDMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 23:12:45 -0400
Date: Sat, 8 Sep 2012 04:12:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com, sameo@linux.intel.com
Subject: Re: [PATCHv2 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20120908031237.GA31018@sirena.org.uk>
References: <1346844964-24839-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346844964-24839-1-git-send-email-sourav.poddar@ti.com>
X-Cookie: See store for details.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:06:04PM +0530, Sourav Poddar wrote:

> +static struct regmap_config smsc_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +		.max_register = SMSC_MAX_REGISTER - 1;

That max_register setup looks very odd...

> +		.cache_type = REGCACHE_COMPRESSED,
> +};

Are you sure the compressed type is sensible?  It would normally only
make sense with a large number of closely packed registers but this
device has 8 bit register values.

> +#ifdef CONFIG_OF
> +	of_property_read_u32(node, "clock", &smsc->clk);
> +#endif

> +	ret = regmap_write(smsc->regmap, SMSC_CLK_CTRL, smsc->clk);
> +	if (ret)
> +		goto err;

What happens on non-DT systems?

> +static int smsc_i2c_remove(struct i2c_client *i2c)
> +{
> +	return 0;
> +}

Remove empty functions, though it's rather surprising that there's
nothing at all to do here..  Normally an MFD would at least remove its
children.

