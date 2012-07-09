Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2GINNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:13:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab2GINNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:13:20 -0400
Date: Mon, 9 Jul 2012 14:13:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: Re: [PATCH V2 5/7] regualtor: s2mps11: Add samsung s2mps11 regulator
 driver
Message-ID: <20120709131318.GE3934@opensource.wolfsonmicro.com>
References: <0ff201cd5c24$c77d2d20$56778760$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <0ff201cd5c24$c77d2d20$56778760$@com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 07, 2012 at 06:42:09PM +0900, Sangbeom Kim wrote:

Looks fairly good overall but a lot of this should be able to be
factored out to use the standard regualtor core support for register
maps now.

> +static const struct sec_voltage_desc buck_voltage_val1 = {
> +	.max = 2000000,
> +	.min =  600000,
> +	.step =   6250,
> +};

These should be using regulator_map_voltage_linear().

> +static int s2mps11_reg_is_enabled(struct regulator_dev *rdev)
> +{

This looks like it should be regulator_is_enabled_regmap() and similarly
for the other enable/disable operations.

> +static int s2mps11_get_voltage_sel(struct regulator_dev *rdev)
> +{

regulator_get_voltage_sel_regmap()

> +static int s2mps11_set_voltage(struct regulator_dev *rdev,
> +				int min_uV, int max_uV, unsigned *selector)

Should be set_voltage_sel(), really set_voltage_sel_regmap()

> +static int s2mps11_set_voltage_time_sel(struct regulator_dev *rdev,
> +					     unsigned int old_sel,
> +					     unsigned int new_sel)

regulator_set_voltage_time().

> +static int s2mps11_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)

regulator_set_voltage_sel_regmap()

> +	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
> +				GFP_KERNEL);
> +	if (!s2mps11)
> +		return -ENOMEM;
> +
> +	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
> +	s2mps11->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!s2mps11->rdev) {
> +		return -ENOMEM;
> +	}

You should register all the regulators unconditionally rather than only
registering the ones in platform data, this allows people to read the
state of the device even if they can't control it.

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+tjmAAoJEBus8iNuMP3dGV0P/RbBRZ4hPjUCtD7DTBapcD7i
S/+Ftcbuq62p+Cwm50eURZnwp+jie4Lk/vbaq30+b3HdSSZvw5R66vnVMyH1nr78
+gG+hSSxwEZF1x/F3s/ZDsdS4Gl8w0j4ZS74ZHNGsYpzy9/FjoSjq1ZUpdd+Wm+L
Bh8jXHFd+iyj02dA9ZpP4lh/fcaOhZhh2yj+QaMqsnikyizajTZ3PNiLfWT0+e+m
Tdr2yz84v1mexkO5W28PqWqINJOTusAMz8AcDuEb+TXOvagzK/FHD7YckfWFh88W
drwlxKNxDoZ0iZN9OPUTKJdArQ9AKKYyAx+Wym1d0dieo5RLuruJ0KAXUheuN0gQ
4hG8AqedN3fFz8ikJcaSMf+iiPhyumaW/USGFTK3cVTK0ETET9Te3tBqxzwsjSRu
US4W9PAx81aoszYdzdBF5+VjONdwmx+bLc7KB+Gt9ty67If4aLLmYppfkPf3iD71
mEs9IsKMOaXOMkWZuQJ2j2eUxrNoeTmDAqbjUK9IJ6Hl3cthRF4XcpS2f5kq9BEV
vBfV9yi3G8cyRBhZ2KPckBGktKHZo2DhjR6NmBC/LENKfzuXdS6nS4i8FNWpcsqf
1MS+cksNR+Juo1Udj4wQvtmE5Q29Jf4qOPqcVexxjySQLrRyr+NK6KOUhRbU7pRE
8J6gk3XUWmtm1cywJP5E
=0lxz
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
