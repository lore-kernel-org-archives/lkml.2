Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab1LEXFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:05:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab1LEXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:05:36 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Date: Tue, 06 Dec 2011 00:05:30 +0100
Message-ID: <2013134.msetbOSBe8@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1666613.yWuPDPh5gQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1666613.yWuPDPh5gQ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 06 December 2011 00:35:41 Felipe Contreras wrote:
> From: Aliaksei Katovich <aliaksei.katovich@nokia.com>
>=20
> Hi,
>=20
> The Nokia N900 has a bunch of stuff regarding the battery: bq27x00 to=
 find
> out the status, and isp1704 to detect what kind of charger is connect=
ed to
> the USB port. However, that doesn't charge the battery.
>=20
> That's the job of bq24150. Up until now, this has been done by the cl=
osed
> and proprietary BME application from user-space, which sends i2c comm=
ands
> directly.
>=20
> Several people have tried to decipher what it's actually doing, and t=
here
> are some simple user-space scripts that manage to achieve charging:
>=20
>   http://enivax.net/jk/n900/charge21.sh.txt
>=20
> Aliaksei Katovich already sent a patch series, but they seem to be do=
ing
> something completely different (wrong?).
>=20
> This simple driver does the work for me. It's doing basically the sam=
e as
> the user-space scripts, but a bit more aligned to the spec sheet[1], =
and a
> bit more understadable. It's a proof of concept, as it doesn't really=

> change the voltage or amperage depending on the type of charger as it=

> should, but it at least it achieves charging.
>=20
> I have never writen a driver, so don't hold on the comments :)
>=20
> Some inspiration from the code of Aliaksei Katovich.
>=20
> Cheers.
>=20
> [1] http://www.ti.com/lit/ds/symlink/bq24150.pdf
>=20

Hello,

I started writing other implementaion of bq2415x charger driver, which =
should=20
support also setting usb host mode. Code is still unfinished, but now i=
s=20
devided into 2 parts: one power_supply driver and one driver which cove=
r all=20
bq registers. See:

http://atrey.karlin.mff.cuni.cz/~pali/bq2415x/

Felipe Contreras, I think that my implementation is better - it will ex=
port=20
all bq registers (which is needed for hostmode boost) and will also reg=
ister=20
regulator interface.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1666613.yWuPDPh5gQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7dTjoACgkQi/DJPQPkQ1IqzACeOsGU9FpL0vFhrULNa6GQHSYD
BucAnjp1DhC40w27+u7JCqb00cDmzVWj
=lIXg
-----END PGP SIGNATURE-----

--nextPart1666613.yWuPDPh5gQ--

