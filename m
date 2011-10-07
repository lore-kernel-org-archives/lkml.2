Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468Ab1JGOlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:41:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:64291 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1JGOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:41:07 -0400
From: Frank Mehnert <frank.mehnert@oracle.com>
Organization: Oracle Corporation
To: Dave Jones <davej@redhat.com>
Subject: Re: RFC: virtualbox tainting.
Date: Fri, 7 Oct 2011 16:40:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.4; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
References: <20111006190526.GA13883@redhat.com>
In-Reply-To: <20111006190526.GA13883@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2300306.AgImnlUFgV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110071640.53827.frank.mehnert@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090205.4E8F0F81.005D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2300306.AgImnlUFgV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dave,

On Thursday 06 October 2011 21:05:27 Dave Jones wrote:
> The number of bug reports we get from people with virtualbox loaded are
> truly astonishing.  It's GPL, but sadly that doesn't mean it's good.
> Nearly all of these bugs look like random corruption. (corrupt linked
> lists, corrupt page tables, and just plain 'weird' crashes).
>=20
> This diff adds tainting to the module loader to treat it as we do with
> stuff from staging/ (crap). With this tainting in place, automatic bug
> filing tools can opt out of automatically filing kernel bugs, and inform
> the user to file bugs somewhere more appropriate.
>=20
> Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> diff --git a/kernel/module.c b/kernel/module.c
> index 04379f92..d26c9a3 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2653,6 +2653,10 @@ static int check_module_license_and_versions(struct
> module *mod) if (strcmp(mod->name, "ndiswrapper") =3D=3D 0)
>  		add_taint(TAINT_PROPRIETARY_MODULE);
>=20
> +	/* vbox is garbage. */
> +	if (strcmp(mod->name, "vboxdrv") =3D=3D 0)
> +		add_taint(TAINT_CRAP);
> +
>  	/* driverloader was caught wrongly pretending to be under GPL */
>  	if (strcmp(mod->name, "driverloader") =3D=3D 0)
>  		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);

I can understand that you would rather ignore bug reports from external
kernel modules. On the other hand I don't like the TAINT_CRAP flag as
you can probably imagine.

Why not just mark external modules like Bastian Blank suggested? I can
assure that we will not try circumvent a TAINT_OOT_MODULE flag.

Please also note that we always have good relations to the open source
community so feel free to point me an archive where all these kernel
panic reports arrive which you've got. We fixed some bugs in our kernel
modules in the past and it is even possible that some of the current
bug reports are from older versions of VirtualBox which might have been
fixed in the meantime.

And of course, helpful and constructive critism is always appreciated.

Thanks,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert
Senior Manager Software Development Desktop Virtualization, VirtualBox
ORACLE Deutschland B.V. & Co. KG | Werkstr. 24 | 71384 Weinstadt, Germany

Hauptverwaltung: Riesstr. 25, D-80992 M=FCnchen
Registergericht: Amtsgericht M=FCnchen, HRA 95603

Komplement=E4rin: ORACLE Deutschland Verwaltung B.V.
Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
Gesch=E4ftsf=FChrer: J=FCrgen Kunz, Marcel van de Molen, Alexander van der =
Ven

--nextPart2300306.AgImnlUFgV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6PD3UACgkQ6z8pigLf3EcdkgCfYzS4hqAuOjaUkUygRwQPD3vI
MFMAni7SvLhik+DXv6saT0EQ8oHgEof5
=+zLg
-----END PGP SIGNATURE-----

--nextPart2300306.AgImnlUFgV--
