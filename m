Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2A0TWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:22:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53742 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab2A0TWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:22:50 -0500
Date: Fri, 27 Jan 2012 19:22:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>,
        Sebastian Reichel <sre@debian.org>,
        ???????????? ???????????????? <freemangordon@abv.bg>
Subject: Re: RFC 2: bq2415x_charger driver
Message-ID: <20120127192247.GA19414@opensource.wolfsonmicro.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
 <3531484.T8K8kTguQQ@pali>
 <20120127162455.GA18353@sirena.org.uk>
 <9034282.U2YBGPDczd@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <9034282.U2YBGPDczd@pali>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27, 2012 at 07:33:59PM +0100, Pali Roh=E1r wrote:
> On Friday 27 January 2012 16:24:55 Mark Brown wrote:
> > On Fri, Jan 27, 2012 at 03:40:43AM +0100, Pali Roh?r wrote:

> > > +	struct i2c_client *client =3D to_i2c_client(bq->dev);

> > You could save a bunch of code by moving all this I2C register I/O over
> > to regmap.

> regmap is not available in 2.6.28, so I cannot use it.

You're submitting to mainline here...

In any case, it's trivial to backport - just copy the directory and
header back.

> > > +static int bq2415x_set_weak_battery_voltage(struct bq2415x_device *b=
q,
> > > int mV) +{
> > > +	int val =3D mV/100 + (mV%100 > 0 ? 1 : 0) - 34;

> > This could probably be written more clearly?

> How?

Without the ternery operator and with more spaces, probably.

> > > +		case BQ2415X_MODE_BOOST: /* Boost mode */
> > > +			dev_info(bq->dev, "mode: Boost\n");

> > Is dev_info() really appropriate for this stuff?

> How can driver write info that user (or other driver) changed chip mode?
> This should be reported in dmesg!

Why does the user care?  There's an interface for querying if they want
to know and you can generate power supply events when the mode changes.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIvmBAAoJEBus8iNuMP3d4jAP/RN7biOHnPMz+RgjcPGk/UEK
JWfg3uxllNQTtzh34xVZ4Pk3YckQpGcHxkj5LW1nonQmBgwg9W9bs0MbsNQIsDUK
Phrh4JstaMv78TLgfGAq5Sm76gnViqmFADYzaMjkqr5l1yE9lgUDqGGDNpqsG8BP
3JkOeFy89fYvRjnvC5MkQC5F8HyRAYODO0lLahDwEXzh95haTkZyVrxl3V/eO8t4
IzbOva2axS1BbmYTk4H+WfFFBgIFmujLw/tbDrhIa7sSYF92z7JkGdHvAXdJ3kGG
x+aNpjBtrQ0AUu0D4W9HIQjuYIHmFkXOA+ovPrkTydhQdQaFUbXeRKMi66kHRfcY
d24ETs4YBo/AfAemfKt9rHR7pVWIrnqFN5rBqf4puuddZ0UAvygoSUogceNBEz/H
ZNnkiZo015lll0Wmpxw8iVAWcXMDqjX3JwtvUduHqgmsRSk1T0P+VWFid4Rt+wbB
W8fNuOz3nicJyGhU1QhLDIku3g8QDg2aJTMiYxcCZMS5vP9jlJDLDu2qFr1kCNgj
A4wLLdhBSc2kQRK/gIIyjxMO6A7nPNI708M+BnQsjviu2qGVXcfgrIsJvDN+eBmq
A8kx3LnjTG8gC4xyVcPdsBfau9v0K8diHC4B1OnTspdtYcMlvc17XHHhWckadmFv
Zb0zDs2r+CnOD4laVedw
=zMnV
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
