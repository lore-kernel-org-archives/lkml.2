Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2KMLN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:13:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2KMLNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:13:51 -0500
Date: Tue, 13 Nov 2012 12:13:37 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 2/2] i2c: i2c-ocores: Add support for the GRLIB port
 of the controller and custom getreg and setreg functions
Message-ID: <20121113111337.GG23119@pengutronix.de>
References: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
 <1352739591-1317-3-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wj9ZLJVQDRFjGSdK"
Content-Disposition: inline
In-Reply-To: <1352739591-1317-3-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wj9ZLJVQDRFjGSdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 12, 2012 at 05:59:51PM +0100, Andreas Larsson wrote:

> @@ -233,6 +276,7 @@ static int ocores_i2c_of_probe(struct platform_device=
 *pdev,
>  {
>  	struct device_node *np =3D pdev->dev.of_node;
>  	u32 val;
> +	const char *name;
> =20
>  	if (of_property_read_u32(np, "reg-shift", &i2c->reg_shift)) {
>  		/* no 'reg-shift', check for deprecated 'regstep' */
> @@ -257,6 +301,15 @@ static int ocores_i2c_of_probe(struct platform_devic=
e *pdev,
> =20
>  	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
>  				&i2c->reg_io_width);
> +
> +	name =3D of_get_property(pdev->dev.of_node, "name", NULL);
> +	if (name && (!strcmp(name, "GAISLER_I2CMST") ||
> +		     !strcmp(name, "01_028"))) {
> +		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
> +		i2c->setreg =3D oc_setreg_grlib;
> +		i2c->getreg =3D oc_getreg_grlib;
> +	}
> +

I'd think we should handle this via a seperate compatible-entry and
match->data?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wj9ZLJVQDRFjGSdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCiK2EACgkQD27XaX1/VRs2WwCeM2W91JCFQPb8A1GyNWXurial
KckAoJCGapS975/aUPf9wKQHv5a77HTO
=21ra
-----END PGP SIGNATURE-----

--wj9ZLJVQDRFjGSdK--
