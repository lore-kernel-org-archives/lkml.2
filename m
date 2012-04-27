Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2D0G3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:29:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37406 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2D0G3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:29:06 -0400
Date: Fri, 27 Apr 2012 16:28:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build warning after merge of the akpm tree
Message-Id: <20120427162858.857ce3348830abe5bd0f9bb0@canb.auug.org.au>
In-Reply-To: <20120427062218.GA1899@moon>
References: <20120427154420.1161da65e7bcc2322857e6b2@canb.auug.org.au>
	<20120427062218.GA1899@moon>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_16_28_58_+1000_MfRskS4W+ItUfCnX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_16_28_58_+1000_MfRskS4W+ItUfCnX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cyrill,

On Fri, 27 Apr 2012 10:22:18 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wr=
ote:
>
> On Fri, Apr 27, 2012 at 03:44:20PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the akpm tree, today's linux-next build ()
> > produced this warning:
> >=20
> > kernel/sys.c: In function 'prctl_set_mm':
> > kernel/sys.c:1779:6: warning: 'error' may be used uninitialized in this=
 function [-Wuninitialized]
> >=20
> > And this is not a false positive (I think).
> >=20
> > Introduced by commit 5455a20be1a6 ("c/r: prctl: extend PR_SET_MM to set
> > up more mm_struct entries").
>=20
> Hi Stephen, thanks for report, have no idea how it happened, since
> commit 5455a20be1a6 _has_ error =3D -EINVAL; line.

I blamed the wrong patch :-(

Commit 8f62e9e9ed ("c/r: prctl: simplify PR_SET_MM on mm::code/data
assignment") removes the "error =3D -EINVAL".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Apr_2012_16_28_58_+1000_MfRskS4W+ItUfCnX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmjyqAAoJEECxmPOUX5FE7FoP/iGL8+f4Di0GEIotB8tuLH3Y
4wTM2gELrv7gLpOPKg2ca79sw8Z39jcLreCdFU9Hk9NGUS2dEgEJXF0wHlRoge59
h8wFxjZzGnkjJL0LxSvNhWn2sEUm958sNMtp46yuOmdkAq2E7YwIFANnEHJWSmyS
4WrVhBjwCguHJwADz5ROCd2Ufurm8l3jf+5k2L3M3BerpDxObFiTgOIGpLWL8aQT
eYuHoiQInPiuyk/zVgf/V+nQiQGlfcVHU4FH3/U56ZGiSLvKG+V3p2Kg49W/2oPV
+oEM4KnuMGx+KAguFkHc+Z4YFV05z47Nx+jy27S2+JnrZ+RKnZ7eEfBVEJZrg9ze
JWW3b0Lpb/NzHtYG8+yYgqu6yoEz2oGo+8/8fyBq3PL3WZtfBXTCnvWualA8MZ4S
1hwLU1HDd++j9ZkmTXQxeVnLmc620bMn/sqQdjft8uZUxZdd0c6JeZdoBJRZdA6Z
frzp06x+fyF4L22RqdWBWFxQKvbebmRiDekfylzAY3A4PmD0HZ/B4z3n089ccoqm
ielXxWUQHSxmLPJCFGp1ZOF8y+owxNTcp1QqT8OO8oDB/+EtDUKu1Ea0wI4WoMs3
3t6eTGIm6/4IHn8qK60sIPzpmwUNWKm/hyhgwkgefoMCH90jBjbbDSqYRJfSamKN
AZOWn+YWdY/HyEx0xfTy
=0cJK
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_16_28_58_+1000_MfRskS4W+ItUfCnX--
