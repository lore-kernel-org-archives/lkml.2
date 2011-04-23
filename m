Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1DWXYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 19:24:31 -0400
Received: from csamuel.org ([74.50.50.137]:52153 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab1DWXY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 19:24:28 -0400
From: Chris Samuel <chris@csamuel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sun, 24 Apr 2011 09:24:07 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, hpa@zytor.com,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl> <1303566747.12067.10.camel@localhost.localdomain>
In-Reply-To: <1303566747.12067.10.camel@localhost.localdomain>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2988261.xxsF5xI1Fo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104240924.12379.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2988261.xxsF5xI1Fo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Sat, 23 Apr 2011 11:52:27 PM Thomas Meyer wrote:

> Could you try to change the line:
>=20
>         } else if (oreg.ax =3D=3D 15*1024) {
>                 boot_params.alt_mem_k =3D (oreg.dx << 6) + oreg.ax;
>=20
> to
>         } else if (oreg.ax =3D=3D 15*1024) {
>                 boot_params.alt_mem_k =3D (oreg.bx << 6) + oreg.ax;
>=20
> That should fix your misdetection.

Took me a while to spot the D->B change - good catch!

I can confirm the allnoconfig now no longer hangs and proceeds
to panic about not being able to mount the rootfs, which is good.
I'll build a more functional kernel now and check it boots OK.

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2988261.xxsF5xI1Fo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbNfl41yjaOTJg85AQL/KQgAh4bF62OjvPqYlqGXj+ravUymjgpzxuy/
pDrlO0m22Wy8lC/SZMNrcBYkjCHWRGm/cgvk4jK2D3KrxGRwVzOuF9iMvTfm/s1n
JHzoHXhfMU42uyw4gQytPfthEZowRFqpWWwNXJ2SUy3spz7wykxOqnAYmdsKaTbl
tI+i7wsdFt30TDKjiBFMjYTIoeoyYF8KZesJuuc0nvVx9wggVg/ka/i1a7tKb0FJ
CQPJtec5BJiD9OHdqGeucRm/wA8i/CQ88APujwkSrfWlyxcYv3UVkD/scZtwSWtY
R7JcWx6yIgvnDM6ZKZEe9Dv0/zvtP9TZ2d0SsoAkVLcZ3TvdYCeMhA==
=pv1q
-----END PGP SIGNATURE-----

--nextPart2988261.xxsF5xI1Fo--
