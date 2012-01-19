Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2ASTpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:45:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59697 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2ASTpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:45:46 -0500
Date: Thu, 19 Jan 2012 20:45:41 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
Message-ID: <20120119194541.GA32483@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
 <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Sorry, found another thing.

> +	if (chip) {
> +		if (chip->nvram_size)
> +			ds1307->nvram_size =3D chip->nvram_size;
> +		if (chip->nvram_offset)
> +			ds1307->nvram_offset =3D chip->nvram_offset;
> +	}

I moved only the assignments...

> =20
>  	buf =3D ds1307->regs;
>  	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
> @@ -893,11 +907,12 @@ read_rtc:
>  		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
>  	}
> =20
> -	if (chip && chip->nvram56) {
> +	if (chip && chip->nvram_size) {

=2E. to here when I saw...

> +		nvram.size =3D ds1307->nvram_size;

=2E.. that nvram is static and we are changing it. Yeah, it is very unlikel=
y but
if we have two RTC with different nvram sizes, one of them will not work co=
rrectly.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8YcuUACgkQD27XaX1/VRsrYgCfdiXnXx4bbC1apKojb+thZ33R
Z08AniHuFBOZj3+u+DCu7+ofvm0R4pDU
=6BPc
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
