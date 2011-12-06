Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1LFHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:25:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38432 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab1LFHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:25:56 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Date: Tue, 06 Dec 2011 08:25:49 +0100
Message-ID: <8650361.EbH1hYJT76@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <CAMP44s1TrRkcy-xS+fXMyv0FAL1TnsPnnTa=gHSd2=P=iFkSUg@mail.gmail.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <2013134.msetbOSBe8@pali-elitebook> <CAMP44s1TrRkcy-xS+fXMyv0FAL1TnsPnnTa=gHSd2=P=iFkSUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3511979.lS3orMS1Wy"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3511979.lS3orMS1Wy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

On Tuesday 06 December 2011 02:12:47 you wrote:
> Hi,
>=20
> On Tue, Dec 6, 2011 at 1:05 AM, Pali Roh=E1r <pali.rohar@gmail.com> w=
rote:
> > I started writing other implementaion of bq2415x charger driver, wh=
ich
> > should support also setting usb host mode. Code is still unfinished=
,
> > but now is devided into 2 parts: one power_supply driver and one dr=
iver
> > which cover all bq registers. See:
> >=20
> > http://atrey.karlin.mff.cuni.cz/~pali/bq2415x/
> >=20
> > Felipe Contreras, I think that my implementation is better - it wil=
l
> > export all bq registers (which is needed for hostmode boost) and wi=
ll
> > also register regulator interface.
>=20
> I took a look at your driver, and there's definitely good stuff in it=
.
> However, I think there's a lot of unnecessary stuff, like the
> miscdevice stuff (which was frowned upon for bq27x00), and a lot of
> user-space interface. Moreover, it doesn't seem to do anything on its=

> own (it needs interaction from user-space).

Ignore miscdevice, I will remove them from driver. I will add some debu=
gfs=20
interface for getting registers output (needed for debugging)

>=20
> IMO the first step should be to have a minimal driver that just works=
,
> even if it doesn't achieve the absolute best charging performance.
> More features could be added later on.
>=20
> Also, I'm not familiar with the regulator interface, but it seems to
> be meant for real regulators, which have consumers, and based on thos=
e
> consumers's needs the real voltage changes. This battery charger on
> the other hand doesn't have anything like that. There will be no
> consumer, and some stuff like the weak battery voltage is not even
> related to a voltage supply, but rather a threshold that can be
> configured to change some behavior of the charger, but there's no
> point in changing it dynamically (or maybe at all).

If regulator interface is not good, I can change it to some sysfs inter=
face.=20
But bq2415x chip driver is not only rx51 specified, so it should handle=
 all=20
chip capabilities.

>=20
> I guess the important one is the charge voltage, which is linked to a=

> real voltage, but what consumers would it have? I don't think there's=

> any.
>=20
> Finally, I don't think user-space interaction should be needed at all=
.
> The driver should start charging immediately when there power supply
> available, and stop when there isn't any. Maybe at some point a
> user-space interface will be useful later on (I don't see why), but I=

> don't think it should be *necessary*.

Userspace interfaction is needed. We need to tell driver to boost - for=
 usb=20
host mode. But of course, battery charging should be automatic without=20=

userspace interfaction.=20

>=20
> I'm not familiar with any of this stuff, so don't take my opinions to=
o
> seriously :)

Consider my code. We do not need two (or more) implementation of same d=
river=20
in kernel. And also we do not need only rx51 specified code.

I separated bq2415x register access into one module (bq2415x.c - withou=
t any=20
logic, only cover chip options) and real battery charging should be don=
e in=20
power_supply interface (bq2415x_charger.c)

My code has also prepaired boost support - for usb host mode, which mus=
t be=20
done in driver.

If you do not agree with other parts, tell me about it - we can fix it.=


>=20
> Cheers.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart3511979.lS3orMS1Wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7dw30ACgkQi/DJPQPkQ1IIEQCgr1gdnnzbh3LututbIGmx9Rq7
y90An1GHGxjZTWPGVt5BxRNeRqNzJgL3
=pAfh
-----END PGP SIGNATURE-----

--nextPart3511979.lS3orMS1Wy--

