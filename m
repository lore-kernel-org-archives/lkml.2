Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1GILxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 07:53:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40078 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1GILxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 07:53:15 -0400
Date: Sat, 9 Jul 2011 13:53:07 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: Add I2C bus support
Message-ID: <20110709115307.GA19804@pengutronix.de>
References: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Sat, Jul 09, 2011 at 01:50:42PM +0900, Mark Brown wrote:

> +#include <linux/regmap.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>

I second Lars-Peter with init.h here (from his first review).

> +static int regmap_i2c_read(struct device *dev,
> +			   const void *reg, size_t reg_size,
> +			   void *val, size_t val_size)
> +{
> +	struct i2c_client *i2c =3D to_i2c_client(dev);
> +	struct i2c_msg xfer[2];
> +	int ret;
> +
> +	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
> +		return -ENOTSUPP;

Even more here. MANGLING is not needed for reading (and it will fail for a
number of i2c-masters).

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4YQSMACgkQD27XaX1/VRt5SACcDfx9sNt2flvFv379hY4cLnfK
2yEAni5Zm/S32UrMjmmaaYdFYfvTQc89
=YAX6
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
