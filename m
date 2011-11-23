Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1KWVv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:51:27 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:59563 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1KWVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:51:26 -0500
Date: Thu, 24 Nov 2011 00:51:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Abbott <abbotti@mev.co.uk>, Xi Wang <xi.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111123215111.GD3258@mwanda>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
 <20111123061355.GA3295@mwanda>
 <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
 <20111123145020.GA3258@mwanda>
 <4ECD1A01.3060503@mev.co.uk>
 <4ECD6873.7080106@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <4ECD6873.7080106@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ECD6ACB.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2011 at 10:41:07PM +0100, Lars-Peter Clausen wrote:
> >     if (insnlist.n_insns <=3D ULONG_MAX / sizeof(struct comedi_insn))
> >         insns =3D
> >             kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns,
> >                 GFP_KERNEL);
> >     if (!insns)
> >         ...
> >=20
> > (note that insns is initialized to NULL).
> >=20
>=20
> Just use kcalloc, it will do the right thing for you.
>=20

I think the reason why I didn't do that in my original patch is that
kcalloc() has a memset(..., 0, ...) in it so it's a slow down.  But
this isn't performance critical code so that would work.

regards,
dan carpenter

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzWrOAAoJEOnZkXI/YHqRCa8QAJHIpc/rZ/TNyksvYiqM1i/9
GXp8lh4vJtEb5ZsbONF6N3oPallqKLDP962KiQWJujH0oUU07sHNJ0AnaktpEu0q
Bpu3OjmQQtRZDzT/7n/J4rQjMaOb9+REf37HEyNE66HQ5HUB7kUVKcLQsEKG93F4
gbt58XFYJL+Ub9oV/Q7dDhvCGG3T0Y3kE+1QcsIfmNHw6cqXXEwrcx5naDs8ylhP
WYMxuNk3qQQsv1nPhQ2yrFrERKlaAxfxR+JHUP1pJvY5D/F1FKDRBfSifDlWVhgA
sdp5X9KIi49o0H3lJus+wu3WMgNXz1nghopIXo6eaRNgChy8Z3T5fh8pgQm+EG6B
+Khr8W5wjY7yM4KG7U6EZwy8YeHGLAmw6P3gCZQej5ONTPSzN3QGLenBpkMAYSmo
oG3mhD8vaX0LT8xIUv+M04fPR7R8BtO74HNz5VfIrWQFuo8piWhxN0lPUO2xSwwQ
fdSvGOcwWo8WAx0v5Jnj26jMGaiX3/5SL5G1qxB08cSwgZZlBRKYRzTbAYdg1CUQ
mnMck98rWhmZz/HIvAukRkXCbjy3HbMZ8uYA2B6tuY+9XVSg79l5Xgl1anax3uMW
oTccsSWZOQOTcMxQWAi5CeyHEdaFmOrbgtZXSgZ1yX5OOd1oFiJs6qQqLXOY2X9Z
O16Ih+kOu1SoFQykGc3/
=RHzZ
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
