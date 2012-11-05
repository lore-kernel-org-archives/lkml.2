Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab2KEKbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:31:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47160 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab2KEKbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:31:33 -0500
Date: Mon, 5 Nov 2012 11:31:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add TI TPS80031 mfd core driver
Message-ID: <20121105103130.GB1385@opensource.wolfsonmicro.com>
References: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com>
 <1352108658-14289-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1352108658-14289-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 03:14:17PM +0530, Laxman Dewangan wrote:

Looks pretty good, a few smaller issues though.

> +static bool is_volatile_reg_id0(struct device *dev, unsigned int reg)
> +{
> +	return false;
> +}

This is the default for all registers, you should not need to provide
a function like this.

> +	dev_info(&client->dev, "Jtag version 0x%02x and Eprom version 0x%02x\n",
> +					jtag_ver, ep_ver);

EPROM is an acronym.  For TI devices I think normally the ES revision
is referred to as just that, otherwise JTAG is an acronym too.

> +	if (client->irq) {
> +		ret = tps80031_irq_init(tps80031, client->irq, pdata->irq_base);
> +		if (ret) {
> +			dev_err(&client->dev, "IRQ init failed: %d\n", ret);
> +			goto fail_client_reg;
> +		}
> +	}

Since for current kernel versions we're using irqdomains we can set up
all the interrupts without an irq.  It can make life easier to just
always set up the interrupt controller so drivers don't need to worry
about it.

> +	ret = mfd_add_devices(tps80031->dev, -1,
> +			tps80031_cell, ARRAY_SIZE(tps80031_cell),
> +			NULL, tps80031->irq_base,
> +			regmap_irq_get_domain(tps80031->irq_data));

If you're supplying a domain you shouldn't need to provide an irq_base,
the domain fulfuls the same role better.

> +static int __devexit tps80031_remove(struct i2c_client *client)
> +{
> +	struct tps80031 *tps80031 = i2c_get_clientdata(client);
> +	int i;
> +
> +	mfd_remove_devices(tps80031->dev);
> +
> +	if (client->irq)
> +		free_irq(client->irq, tps80031);

regmap_irq_exit()

> +#ifdef CONFIG_PM_SLEEP
> +static int tps80031_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +
> +	if (client->irq)
> +		disable_irq(client->irq);

The interrupt core should take care of this for you if it's important,
and note that people often use things like RTC alarms to wake the
system.

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl5U0AAoJELSic+t+oim9sHQP/jnGOWtYHr7E7+IfkeV2MRAZ
krsKOPWDfAawRbN84tRjzXUNXlVffXmS3pYy48nxTV8PXQZ9p1UOvIRzVNFAwGGf
6B43IaO5GFEo/qng9k/2oQ8Q2864mjVKwdbYhx+7ttdLc5Mv0oLYSn6Nx71t+C0J
NCoObAXyKvpQ3yDevNc8Xms6rc/ZV3S138glTbCR7ixvE1jCaJPuB3xZiPrFyN6/
jeaMo3b/m60nsWBqoMfFnz+vXrF0NUd6WwLbRno8eDoRpzg+aSbgUFX1bF+9GRGQ
ribAiCVkHr39A21c7h8M5UzSbPsC12KoknJQeSMPMObljsnz3z49wesS5yOJZ8YB
MdR3SLwq1TpulFboPYBoG9JTHnAzfQQRS86DkekhVsAjZ9Vgbb/RFbe+MPL8I77R
VCxjGuz+BnXDy1wNzx3sDXcl3viVCWTn3yQHFI6ttrzvika1FYkbGaRNp6c4Zb6b
l5gOB1LUGKoOnNjkGNoj/IqGG08WS6Qq8ux/z6RWNl2fwj1XNXffLHrRsSoE/yje
F64K/lO6CedZfOT6DE9I2K5nzxeE8Z4Z0dU56mJGj+I+ejKXu7gLSe1a8yMZZw2g
zz+XmAR7D9w0X/riq5hv69KIzr7Kpc7n9sdlTTofKq+msv4Y+1FzQcaL1K51bFrs
RpAzsMAE2vxjModgLnrY
=jgt4
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
