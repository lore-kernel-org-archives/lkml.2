Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0GaXb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 19:31:26 -0400
Received: from vps.mortis.eu ([79.99.135.181]:39689 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0GaXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 19:31:24 -0400
Date: Sun, 1 Aug 2010 01:31:21 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hwmon: f71882fg: Add support for the Fintek F71808E
Message-ID: <20100731233121.GD3711@salidar.me.mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <4BA9CC64.5010807@redhat.com>
 <20100324092357.GE6368@salidar.me.mortis.eu>
 <4BA9EA0C.6070200@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline
In-Reply-To: <4BA9EA0C.6070200@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 11:31:40 +0100, Hans de Goede wrote:
> On 03/24/2010 10:23, Giel van Schijndel wrote:
>> On Wed, Mar 24, 2010 at 09:25:08 +0100, Hans de Goede wrote:
>>> See comments inline.
>>>
>>> On 03/24/2010 12:12 AM, Giel van Schijndel wrote:
>>>> Allow device probing to recognise the Fintek F71808E.
>>>>=20
>>>> Sysfs interface:
>>>>    * Fan/pwm control is the same as for F71889FG
>>>>    * Temperature and voltage sensor handling is largely the same as for
>>>>      the F71889FG
>>>>     - Has one temperature sensor less (doesn't have temp3)
>>>>     - Misses one voltage sensor (doesn't have V6, thus in6_input refer=
s to
>>>>       what in7_input refers for F71889FG)
>>>>=20
>>>> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
>>>> such that it can largely be reused.
>>>>---
>>>>   Documentation/hwmon/f71882fg |    4 ++
>>>>   drivers/hwmon/Kconfig        |    6 ++--
>>>>   drivers/hwmon/f71882fg.c     |   80 ++++++++++++++++++++++++++++++++=
+++++----
>>>>   3 files changed, 79 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>>>> index 25e1cad..b290b87 100644
>>>> --- a/drivers/hwmon/f71882fg.c
>>>> +++ b/drivers/hwmon/f71882fg.c
>>>> @@ -1974,8 +2002,27 @@ static int __devinit f71882fg_probe(struct plat=
form_device *pdev)
>>>> ... snip ...
>>>> +			/* fall through! */
>>>
>>> Ugh, please don't fall through, and then have an if below to only do
>>> some parts of the case falling through. This is quite confusing at
>>> first I thought your code was buggy I had to read it twice to notice
>>> the if. Instead just duplicate the following lines:
>>>> +			err =3D f71882fg_create_sysfs_files(pdev,
>>>> +					fxxxx_temp_attr,
>>>> +					ARRAY_SIZE(fxxxx_temp_attr));
>>> In the f71862fg case, end the f71862fg case with a break and remove
>>> the if test from the f71808fg case.
>>>
>>>>+		case f71808fg:
>>>>+			if (data->type =3D=3D f71808fg) {
>>>>+				err =3D f71882fg_create_sysfs_files(pdev,
>>>>+						f71808_in_attr,
>>>>+						ARRAY_SIZE(f71808_in_attr));
>>>>+				if (err)
>>>>+					goto exit_unregister_sysfs;
>>>>+			}
>>>>+			err =3D f71882fg_create_sysfs_files(pdev,
>>>>+					fxxxx_temp_attr,
>>>>+					ARRAY_SIZE(fxxxx_temp_attr));
>>>> ... snip ...
>>
>> Ack. New and improved patch follows this line.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> hwmon: f71882fg: Add support for the Fintek F71808E
>=20
> This new version looks good to me:
> Acked-by: Hans de Goede <hdegoede@redhat.com>

Thanks.  Anyone else I need to poke in order to set this on track to
mainline?

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxUskkACgkQZBYm/87l50KKYwCeJULNPeFKasoXLwDaeByZbWVt
g6oAoJYS69F3hgklQNyG6U9aXcX1+Ptv
=5rXS
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
