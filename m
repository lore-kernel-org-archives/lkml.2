Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2JWRSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:18:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757239Ab2JWRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:18:40 -0400
Date: Tue, 23 Oct 2012 18:18:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ciminaghi@gnudd.com
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/mfd/sta2x11-mfd: add regmap support
Message-ID: <20121023171837.GE4477@opensource.wolfsonmicro.com>
References: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com>
 <1350917441-4478-3-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cXxibKNEnJOqEg4"
Content-Disposition: inline
In-Reply-To: <1350917441-4478-3-git-send-email-ciminaghi@gnudd.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7cXxibKNEnJOqEg4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 04:50:33PM +0200, ciminaghi@gnudd.com wrote:

> +static bool sta2x11_sctl_writeable_reg(struct device *dev, unsigned int reg)
> +{
> +	return !__reg_within_range(reg, SCTL_SCPCIECSBRST, SCTL_SCRSTSTA);
> +}

This and most of your other readable/writable things look like a
framework feature waiting to be written - something data driven which
takes a table of register ranges and goes and does the
__reg_within_range() check on them.  Seems like it'd be really useful
for devices like this.

> +static bool sta2x11_apb_soc_regs_writeable_reg(struct device *dev,
> +					       unsigned int reg)
> +{
> +	if (!sta2x11_apb_soc_regs_readable_reg(dev, reg))
> +		return false;
> +	return (!__reg_within_range(reg, PCIE_PM_STATUS_0_PORT_0_4,
> +				    PCIE_PM_STATUS_7_0_EP4) &&
> +		reg != PCIE_COMMON_CLOCK_CONFIG_0_4_0 &&
> +		!__reg_within_range(reg, PCIE_SoC_INT_ROUTER_STATUS0_REG,
> +				    PCIE_SoC_INT_ROUTER_STATUS3_REG) &&
> +		reg != SYSTEM_CONFIG_STATUS_REG &&
> +		reg != COMPENSATION_REG1);

For this I'd write a switch statement with the range checks in the
default: case.  Actually you could just use the GCC switch range
feature:

	case PCIE_PM_STATUS_0_PORT_0_4..PCIE_PM_STATUS_7_0_EP4:

Either of these would increase readability.

but generally

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--7cXxibKNEnJOqEg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhtFnAAoJELSic+t+oim9tOkP/i5MFgFmsQkH+eXx7XDUAeZ/
6BGopUv+xfwgVKf2eFwTPMksEp4/F1CEoXjEiLxiZS0GXQin3Y5mFDFThPJcwqZj
9KJfYe7+4ZFVxeoAsN8Sl6qp6lQgbLwnejVdZV5hd+A//rPd3IoYcHUrXYnlrS85
Z/wJCIVsUDc4PsNiu6eK0WiptGLRecFbAX4P9B3zk8IIGwT5oRXFtgKV2UDRBT9e
whY76S4bzqRHx8K7O2rNpwrkgo5zMxHRcs+VtKeW40wByOyQDk8riSD0E2mFjCOD
yEoYbjxFZduzgqwJimDYORDRRHV/i/C9HgKf87gnS0ZDXun0zAF2R5ay5WNRITRb
QRmwjx1ygo3CFnyIQkKZX7uPJmqbb3+LlC9M9C0o+CN/ddkQNbVWwTID9K06n2+O
6DNrWmmqlSBDwHeBwx72YXUzJlfw2awY/erqUP2zoxWAVKVJOwZhBhnkrC5gYcNs
xqhWTjM6VigJwH71AmS4drKg9bAqfpvHzg/v3fG/u8efGT1zoMJegAuoIz/c4X6m
AnSktqfKPHHw1Bp6OsMd4UJVZWWaaD+DNmg4berpusKyBOtV6CpxQpiyc1qtP8bj
0Q8k/SWFWHPM6KYb9Y7a8CzrCTo02y1Jp73I2yPG5CI7qRUsdR1BeYK1xqOaX1Yi
SD8uF6JI0gV44yeiWNwj
=gZcw
-----END PGP SIGNATURE-----

--7cXxibKNEnJOqEg4--
