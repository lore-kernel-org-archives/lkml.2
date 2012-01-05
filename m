Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2AEVpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:45:34 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab2AEVpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:45:33 -0500
Message-ID: <4F0619F9.8010505@nod.at>
Date: Thu, 05 Jan 2012 22:45:29 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] init: Warn on non-existent rdinit
References: <1325789819-30502-1-git-send-email-richard@nod.at> <m14nw9c1me.fsf@fess.ebiederm.org>
In-Reply-To: <m14nw9c1me.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig45DC6B97144E2ED0B8D06CF6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig45DC6B97144E2ED0B8D06CF6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 05.01.2012 21:53, schrieb Eric W. Biederman:
> Richard Weinberger <richard@nod.at> writes:
>=20
>> Such a warning would have saved me some time...
>> Hopefully this printk() saves someone else's time. :-)
>=20
> The warning is wrong if you are not using an initramfs or an initial
> ramdisk.

Gnah, you're so right.
I did not test it without a ramdisk.

> I expect what you want is something like:
>=20
> diff --git a/init/main.c b/init/main.c
> index 217ed23..8d53d28 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -830,10 +830,11 @@ static int __init kernel_init(void * unused)
>          * the work
>          */
> =20
> -       if (!ramdisk_execute_command)
> +       if (!ramdisk_execute_command &&
> +           (sys_access((const char __user *)"/init", 0) =3D=3D 0))
>                 ramdisk_execute_command =3D "/init";
> =20
> -       if (sys_access((const char __user *) ramdisk_execute_command, 0=
) !=3D 0) {
> +       if (!ramdisk_execute_command) {
>                 ramdisk_execute_command =3D NULL;
>                 prepare_namespace();
>         }

Why ramdisk_execute_command =3D NULL; in the !ramdisk_execute_command cas=
e?

>=20
> That way we don't clear ramdisk_execute_command if it was set and
> we complain if we attempt exec the ramdisk_execute_command.

If "/init" does not exist we still don't get a warning.

Thanks,
//richard



--------------enig45DC6B97144E2ED0B8D06CF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPBhn5AAoJEN9758yqZn9e+sgIAMg9UlnDSKMK/4lWNE+nG49x
ISW9MbA6bReIOpAYB3dvDVhXVC/dy9Uw6x+qtbNmTDqjehbOCk1WzZGrM4PrnVcB
O17nOnO/aNZz5wRW1ciuoN7Vd8rD/LINj9Nufv/T0QgikJFeSiqiGCzHqJfrs1Bj
/dVhv0Hlt7A2dWMz5Rz7xAxhUVIe1J82/DhCEXfaWjjZy6UBAvIhtQDCRWwXomv0
k5Vi/aBM2CdBhA//4yBD5q+yB1OvYYO+L6Dp72bIXHXyjPB0zXKS8TudSA7gs/8X
czu3mXfUvc/e7VG8rbEl3Pfp1vsspF9qWjRUlzAoMx6qjyGMZp/76p164g8hZ0M=
=eQhw
-----END PGP SIGNATURE-----

--------------enig45DC6B97144E2ED0B8D06CF6--
