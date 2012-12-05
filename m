Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2LEQl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:41:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2LEQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:41:55 -0500
Date: Wed, 5 Dec 2012 17:41:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram
 chips
Message-ID: <20121205164153.GA5011@pengutronix.de>
References: <201212041758.38600.poeschel@lemonage.de>
 <20121204183238.GA15067@pengutronix.de>
 <201212051043.07460.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <201212051043.07460.poeschel@lemonage.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 05, 2012 at 10:43:07AM +0100, Lars Poeschel wrote:
> I see there where to much "no"s to get anything in, but thank you for
> your comments and explanations.

Not necessarily, just not in this form :)

>=20
> > > I wanted to use a fm24c04 i2c fram chip with linux. I grepped the sou=
rce
> > > and found nothing. I later found that my chip can be handled by at24
> > > eeprom driver. It creates a sysfs file called eeprom to read from and
> > > write to the chip. Userspace has no chance to distinguish if it is
> > > writing an eeprom or a fram chip.
> >=20
> > Why should it?
>=20
> Because writes are much faster and it doesn't have to take care on erase
> cycles. It could use other write strategies on such devices and update
> informations that have to survive power downs more often.

I agree. I think that a seperate attribute named e.g. 'page_size' would
be more helpful than renaming the binary file to fram?

> > The method of accessing EEPROMs is used by way more chips than FRAMs.
> > So, I'd prefer to have the text updated more generic like "EEPROMs and
> > similar devices like RAMs, ROMs, etc...". Describing setting .flags in
> > Kconfig is overkill.
>=20
> A patch updating Kconfig is below.

Looks good from a glimpse, will apply it later.

> No one knows all chips out there.
> For the fm24c04 I use page_size !=3D chip_size. It does not buffer but it=
 has=20
> two pages, 256 bytes each.

Yup, it uses two I2C adresses...

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC/eVEACgkQD27XaX1/VRtFGACeMTUgM/IelOSf6mgZnFu9xAii
UaMAoMCK7HaKqB5m+DaETquLdYLUPz+p
=DnTJ
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
