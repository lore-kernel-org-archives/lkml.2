Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2CURt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:49:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43278 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2CURt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:49:26 -0400
Date: Wed, 21 Mar 2012 18:49:19 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] Support M95040 SPI EEPROM
Message-ID: <20120321174919.GA22498@pengutronix.de>
References: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
 <20120321173022.GF12101@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20120321173022.GF12101@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2012 at 10:30:22AM -0700, Chris Wright wrote:
> * Ivo Sieben (meltedpianoman@gmail.com) wrote:
> > Updated the generic SPI EEPROM driver AT25 for support of address bit A8
> > in the instruction byte. Certain EEPROMS (like M95040 from ST) have a 5=
12
> > Byte size but use only one address byte (A0 to A7) for addressing. For =
the
> > extra address bit A8 bit 3 of the instruction byte is used. This instru=
ction
> > bit is threated as don't care for other AT25 like chips
>=20
> The AT25 datasheet lists that bit in READ and PROGRAM(write) as don't
> care, and the MV950x0 datasheet says just what you've said above (BTW,
> it's "treated" not "threated").  How confident are you that this logic
> will not cause problems for existing non-MV95040 chips?

I was thinking the same. We should not make this behaviour default, but
optional. My idea would be another flag, i.e. EE_INSTR_BIT3_IS_ADDR. I'd th=
ink
the code could then also easily be written in a way, that it gives 17 and 25
bit addresses for free.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9qFJ8ACgkQD27XaX1/VRtXGwCeOOmQLLjKph+4DMQD2uV/zGzu
zzsAmwbJGgziIXSRBC+j54ygADj1ePet
=mn5A
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
