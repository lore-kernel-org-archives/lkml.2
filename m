Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1LFNfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:35:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab1LFNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:35:04 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Date: Tue, 06 Dec 2011 14:34:59 +0100
Message-ID: <1432607.e4Z4IWXQZY@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <20111206021749.GA7202@earth.universe> <CAMP44s3JF9QM00x=aUq3tHGfeuTRnKMbT2WrMseZXZTJg1qUyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3351962.1uM5gTbhLY"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3351962.1uM5gTbhLY
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

On Tuesday 06 December 2011 04:49:37 you wrote:
> Hi,
>=20
> 2011/12/6 Sebastian Reichel <sre@debian.org>:
> > Good to hear somebody is working on this :) I planned to do this
> > myself, but didn't find any time for it. Here are some comments
> :
> > from me:
> :)
> :
> > [...]
> >=20
> >> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >=20
> > I would expect the driver in drivers/power. But maybe MFD is
> > better, since the chip can also be used to power USB host?

Yes, chip support usb host mode and is working on rx51.

>=20
> Perhaps, at least I haven't tried that.
>=20
> > [...]
> >=20
> >> +#define BQ2415X_VOLTAGE_SCALE 20000
> >=20
> > If I remember correctly (I read the specs some time ago), this can
> > be configured via external resistor. So this is board specific?
>=20
> Not really. There are 6 bits: 640, 320, 160, 80, 40, 20. So values
> from 0 to 1260mV can be represented, at steps of 20mV. A value of 0
> means 3.5V.
>=20
> > [...]
> >=20
> >> +     bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
> >> +     bq2415x_set_voltage(cli, 0, 4200000);
> >> +     bq2415x_set_current_limit(cli, 1800000, 1800000);
> >=20
> > So it always charges with 1.8A? Shouldn't this be dependent on the
> > input source (e.g. 500mA from USB)? Also what's if no charger is
> > connected at all?
>=20
> No. I'm hard-coding those values, but I wrote the functions
> (set_voltate, set_current_limit) so all values are supported.

These hardcoded values should go to board specified section.

>=20
> What is missing is the code to connect this driver to the charger
> detector driver (isp1704), so those values are determined dynamically=
.
>=20
> > Apart from this I think those values should be exposed to sysfs
> > via /sys/class/power_supply.
>=20
> Perhaps. Although I don't see much of the power supply interface that=

> could be useful here, but if so, I guess this should be indeed in
> 'drivers/power'.

Power supply interface has pending patches for chargers. Patches will a=
dd=20
interface for periodic calling functions - which is usefull for watchdo=
g reset=20
and charging (+ errors handling).

>=20
> Cheers.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart3351962.1uM5gTbhLY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7eGgMACgkQi/DJPQPkQ1IIEACgpqrciqiBgqDTLn91eG9mVPxB
nJ0AoIcVaKiYFiVsoJj9PtiqCWH/axZj
=p/RX
-----END PGP SIGNATURE-----

--nextPart3351962.1uM5gTbhLY--

