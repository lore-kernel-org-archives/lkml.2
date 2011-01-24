Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1AXMiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:38:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1AXMiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:38:02 -0500
Message-ID: <4D3D7290.9050203@corscience.de>
Date: Mon, 24 Jan 2011 13:37:36 +0100
From: Bernhard Walle <walle@corscience.de>
Organization: Corscience GmbH & Co. KG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: ben-linux@fluff.org, ddaney@caviumnetworks.com, ralf@linux-mips.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: octeon: Make the timeout 1*HZ instead of 1 jiffy
References: <1295870741-19970-1-git-send-email-walle@corscience.de> <20110124131405.4583a7af@endymion.delvare>
In-Reply-To: <20110124131405.4583a7af@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7878AC828B9D8B302412882"
X-Provags-ID: V02:K0:3snplpTO/PWCQREt4TsTRlslKfPkMXUG+Gxcjimh86r
 YB3PvLKoHRWgpHw+p5p/ceF/TbV1niv345vTHXXJj3i8kXMS3k
 WUbvhKV0rob2yOmQJuzDHvc0nsI75Q37NP81Cjt3FkkgagyBDb
 yWnB9s1anNbYEOt9FX5FxPYpc7lejNf2U5PbRxr3bne/bneTv4
 d8DgnuQdCWX8G3Vy/gpFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7878AC828B9D8B302412882
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Am 24.01.2011 13:14, schrieb Jean Delvare:
>>  	.owner =3D THIS_MODULE,
>>  	.name =3D "OCTEON adapter",
>>  	.algo =3D &octeon_i2c_algo,
>> -	.timeout =3D 2,
>> +	.timeout =3D HZ,
>>  };
>=20
> This is a large timeout value, much larger than any value the
> i2c-octeon driver was using today for any possible value of HZ.
> Wouldn't it make more sense to set it to HZ / 50, which is 2 for HZ =3D=

> 100, leaving the setting unchanged for this common case at least?

To be honest, I had problems with timeout=3D2 that go away with
timeout=3DHZ. But I cannot be sure that this is a problem with my hardwar=
e
that is not present with other devices.

The drivers that use HZ are i2c-mpc.c and i2c-pca-platform.c, but I
don't know the hardware that much so that I really can compare the values=
=2E

So yes, you're right. A patch modifying the timeout value should be an
extra patch, so I will resend the current patch to use HZ/50.


Regards,
Bernhard


--------------enigE7878AC828B9D8B302412882
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNPXKQAAoJEIQVJz6X/I4DuRMP/32PwgTQARVC0kyRxZYGUgw/
V7uut9b//PM01jXleAhfnBNi0fafUDJr0Ez2etcXt/o9o5+hdpvG4OoYSFZNojp+
4KwoZuXcgr+FgOv47cA4pXiRIQZyHXLcCDEfF7S+FYDi2YOmka1jcp5qfsXWnIn5
TkjnGDGW+bgMiNaDrvM+skgwBTPvn5zdsZO7oo37i5xSlaxCmqAm0/PW8XSHIodp
CcWOthQ7vUJH4IKk6BoLvxr5/tK/7DZz9eqQq20Fzl7JTDvFnBWhyn/8ICanQR1o
ET33Hoydiva2HRk2HHrx+9aTphsXrgcgD3CRoNW1ktNwMvFsBB3ZyFJwdGX8Wxlh
K4UUZ1MBYvF4irJqSjY1XbTQJMqx2/7/M/uURsra/Qo6QijIlcXG92ZlOp0sb3gA
9TaUQfsdMpiQT+f+VPVsJApJOKVH6KdCs+x2cr+5yM3EL4DOcMVVjN2b74ihCU36
cmjvU/iEYYsIXaYrNtxY6BYBHOe8PdZF5oazQ4+9Y2ej4HGZoqYayDm92Nu/x6HT
g2d0yliDEZiwg+CitxwYZMPPWJmK6zklfU3E5cnOHvdco81VohMVWRapgqGdEHXk
oxXUb5sEo8AsuetPDSX6dtkIMROYWcB26pR4Dd4LBm2wNfLT4DzVSSRDPgHsXJbP
HhtxwXy43rhAMuYT2M6w
=voPb
-----END PGP SIGNATURE-----

--------------enigE7878AC828B9D8B302412882--
