Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2GPRkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:40:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2GPRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:40:31 -0400
From: Michal Nazarewicz <mina86@tlen.pl>
To: Joonsoo Kim <js1304@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: AC1F 5F5C D418 88F8 CC84  5858 2060 4012 5075 1FF4
X-PGP: 50751FF4
Date: Mon, 16 Jul 2012 19:40:09 +0200
In-Reply-To: <1342455272-32703-1-git-send-email-js1304@gmail.com> (Joonsoo
	Kim's message of "Tue, 17 Jul 2012 01:14:30 +0900")
Message-ID: <874np7r4ee.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Joonsoo Kim <js1304@gmail.com> writes:
> migrate_pages() should return number of pages not migrated or error code.
> When unmap_and_move return -EAGAIN, outer loop is re-execution without
> initialising nr_failed. This makes nr_failed over-counted.
>
> So this patch correct it by initialising nr_failed in outer loop.
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Actually, it makes me wonder if there is any code that uses this
information.  If not, it would be best in my opinion to make it return
zero or negative error code, but that would have to be checked.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index be26d5c..294d52a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -982,6 +982,7 @@ int migrate_pages(struct list_head *from,
>=20=20
>  	for(pass =3D 0; pass < 10 && retry; pass++) {
>  		retry =3D 0;
> +		nr_failed =3D 0;
>=20=20
>  		list_for_each_entry_safe(page, page2, from, lru) {
>  			cond_resched();

=2D-=20
Best regards,                                          _     _
 .o. | Liege of Serenly Enlightened Majesty of       o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
 ooo +-<mina86-mina86.com>-<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQBFH6AAoJECBgQBJQdR/0/SsP+gK/qMIWoDDSiGjtDXaBHGU8
QT3FPyIXFAyHE9VrIAz5lQI9N/Xk5oq52o8Eu3nKpEhbUgLMxN6dFADe4NKzZJ4H
xyPFDWWe+LDGsGzHtxgrp7SL2bnIMnAU5JupD4X1yLSIV1BW0j79zBW16ablD87R
auH0xZ6A6ygVyGNpqNskqzTktphr1Uh53IiIbCtUNyo2SMwSA6nXLe3vsc8bWb00
oOlrUf0OWSrcXsTHTOuWWPfxEaUitr2CXglpfzHmVPG7vVBJTRz0X3RQ+yAEJg4u
re3ZDHlgt42j45MOM0+j23EQxpF0MeZcT/+p9qvu0rnF/GEawGVTT9SjUK/zG09H
bO409BdBBjCxAzl2FX+ykYYShwLbb5G5ieLklodf0ZnvpgWrHeQ1GdtlsipCD9Xm
6elS2ROksY9tnKdXiI0quw6K1Uke8ovT0Ijqrchz5yt7RyA9nMPz/ESbdPJAnt/1
WJm2oFKAh0bvBJg5tA8pRH9O9SuX+wHXwSkg0Ii2xMZxIj1oAKfPiX+MhfQhUoea
wIxHSkLOn0ONiLy1kw7v0iTVXDEpj616niElP3vPe4TIUniIP+vnnr+PC2j3ZhAp
qqO3x0F6Mfho1aWD+NnTkF/5rCSaJCg36psfjSsRXSM5zHgjxpn47WsTrOQYyiS/
NR0hxTDMYVwuf/WNU1/d
=zdx2
-----END PGP SIGNATURE-----
--=-=-=--
