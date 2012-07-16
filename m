Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2GPRlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:41:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab2GPRlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:41:03 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <js1304@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 3/3] mm: fix return value in __alloc_contig_migrate_range()
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<1342455272-32703-3-git-send-email-js1304@gmail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: AC1F 5F5C D418 88F8 CC84  5858 2060 4012 5075 1FF4
X-PGP: 50751FF4
Date: Mon, 16 Jul 2012 19:40:56 +0200
In-Reply-To: <1342455272-32703-3-git-send-email-js1304@gmail.com> (Joonsoo
	Kim's message of "Tue, 17 Jul 2012 01:14:32 +0900")
Message-ID: <871ukbr4d3.fsf@erwin.mina86.com>
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

> migrate_pages() would return positive value in some failure case,
> so 'ret > 0 ? 0 : ret' may be wrong.
> This fix it and remove one dead statement.
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>

Have you actually encountered this problem?  If migrate_pages() fails
with a positive value, the code that you are removing kicks in and
=2DEBUSY is assigned to ret (now that I look at it, I think that in the
current code the "return ret > 0 ? 0 : ret;" statement could be reduced
to "return ret;").  Your code seems to be cleaner, but the commit
message does not look accurate to me.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4403009..02d4519 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5673,7 +5673,6 @@ static int __alloc_contig_migrate_range(unsigned lo=
ng start, unsigned long end)
>  			}
>  			tries =3D 0;
>  		} else if (++tries =3D=3D 5) {
> -			ret =3D ret < 0 ? ret : -EBUSY;
>  			break;
>  		}
>=20=20
> @@ -5683,7 +5682,7 @@ static int __alloc_contig_migrate_range(unsigned lo=
ng start, unsigned long end)
>  	}
>=20=20
>  	putback_lru_pages(&cc.migratepages);
> -	return ret > 0 ? 0 : ret;
> +	return ret <=3D 0 ? ret : -EBUSY;
>  }
>=20=20
>  /*

=2D-=20
Best regards,                                          _     _
 .o. | Liege of Serenly Enlightened Majesty of       o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
 ooo +-<mina86-mina86.com>-<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQBFIpAAoJECBgQBJQdR/0Gn4P/0pr6sIB9P2fneQiC+7zj495
09WOd/w9J0HPOg9wAjtXD6+NEDGUq6GywUUXWddB1g6yBbJsvHl+CL4tFkgoCO3Y
p/hwVAh/ouQA+Yhnqnv7E8UnAWgRjQlEB02p3DbNPwJ1kqtz/OhMDm0jNKOSL6rj
TkSYPDtgHABo5UXPrC2LRl5JDfM3Xwnavfxs6c8Ze0hgddsJ/tr2NHRgELy4mS6X
9gj4e7W65L8KBPj2kACI54dm2vbKBZXbqKeJn0rfUCUHDvt7tWDrtXb58uvsNQTS
whfp+TO5ysmk/zf4ENlokijQFs24rvTVk22vV4Joyu2NaelhGvsZ8GOjURyaDp0R
hmBepZDFrGWe5nTu1e3iHIBpyd3CPQ+a2gIxUOZqBEX49+/6qs6WRgOYBeuLIJGB
vveb+Tf52ph7Lx+EPuNHBSnY7dd5Ux+n64znL6wHK4Y8Qf2QMovhZcsq4ERY2xy7
3/KKiXCsKYKihrjIRtcKbYUS33NoGWLCu1+76+kD9zoYFpCHJyT9YmoSwwGAYHx1
A4BSKLiOYVASQWU+nuCunlDJDvzA+J4lsPO7mLXbqT8aeGkZpWmTdXWI+8jCJYDu
Q6mKpzk5uf4mAdAtCd066j9rCYDSKHGYpaAtRlDwF/BxbiPu5r2uy2kUafqWgZDS
xpyxqIZhkty7uZr2ZLxW
=gy2Q
-----END PGP SIGNATURE-----
--=-=-=--
