Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2BGKKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:10:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37291 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2BGKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:10:18 -0500
Date: Tue, 7 Feb 2012 11:10:16 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Message-ID: <20120207101016.GB2539@pengutronix.de>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
 <1328102793-4313-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <1328102793-4313-3-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

> +config I2C_CONGATEC_CGEB
> +	tristate "Congatec CGEB I2C driver"
> +	depends on MFD_CONGATEC_CGEB
> +	help
> +	  This driver provides support for the I2C busses accssable via
> +	  the Congatec CGEB interface found on Congatec boards.
> +

Please keep the sorting (eg20t is wrong and will be fixed).

> +		ret =3D cgeb_call(priv->board, &fps, CgebI2CTransfer);
> +		if (ret) {
> +			ret =3D -EREMOTEIO;
> +			goto out;
> +		}

-EREMOTEIO is not present in Documentation/i2c/fault-codes. Please use
one from that file.

> +	ret =3D cgeb_i2c_set_speed(priv, 400000);
> +	if (ret)
> +		/*
> +		 * not a critical error, we can continue with the default speed.
> +		 */
> +		dev_warn(&pdev->dev, "Could not set speed to 400KHz\n");

Is it possible to make this configurable? Not all I2C devices support
400KHz, 100KHz is OK.

> +static struct platform_driver cgeb_i2c_driver =3D {
> +	.probe		=3D cgeb_i2c_probe,
> +	.remove		=3D __exit_p(cgeb_i2c_remove),

__devexit_p()

> +static int __init cgeb_i2c_driver_init(void)
> +{
> +	return platform_driver_register(&cgeb_i2c_driver);
> +}
> +
> +static void __exit cgeb_i2c_driver_exit(void)
> +{
> +	platform_driver_unregister(&cgeb_i2c_driver);
> +}
> +
> +module_init(cgeb_i2c_driver_init);
> +module_exit(cgeb_i2c_driver_exit);

module_platform_driver();

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8w+IgACgkQD27XaX1/VRseFgCfb9GA9+cmUwNKK4A634tNVzAg
+ZoAniKTp9LQ1MorQSaZjR7/t6jzm/L2
=WMNh
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
