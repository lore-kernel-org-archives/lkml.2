Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2KMKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:16:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55067 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2KMKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:16:25 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] mm: cma: WARN if freed memory is still in use
In-Reply-To: <1352789271-18461-1-git-send-email-m.szyprowski@samsung.com>
Organization: http://mina86.com/
References: <xa1t8va6zsad.fsf@mina86.com> <1352789271-18461-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 13 Nov 2012 11:16:15 +0100
Message-ID: <xa1t1ufxx0y8.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13 2012, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Memory returned to free_contig_range() must have no other references. Let
> kernel to complain loudly if page reference count is not equal to 1.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 022e4ed..290c2eb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5888,8 +5888,13 @@ done:
>=20=20
>  void free_contig_range(unsigned long pfn, unsigned nr_pages)
>  {
> -	for (; nr_pages--; ++pfn)
> -		__free_page(pfn_to_page(pfn));
> +	struct page *page =3D pfn_to_page(pfn);
> +	int count =3D 0;
> +	for (; nr_pages--; page++) {
> +		count +=3D page_count(page) !=3D 1;
> +		__free_page(page);
> +	}
> +	WARN(count !=3D 0, "%d pages are still in use!\n", count);
>  }
>  #endif

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQoh3vAAoJECBgQBJQdR/0SG4P/2CxtT06r7NeIycdwd6P2Dm/
038uolt5sSF4hrs1S7z6ydmsjek8Grh5DaTO1uZWWYnRjOdUyUqpTX00Un/btuUW
ET/PcK9IVHpYpliHeykCRzdMoyloISUXWs0Ahk2gz5HO6Gfq/W4FU4C3EWFee2xU
yXkPynaU/PAPvcmBCZmPlH2XzufOhzcj++F9Rve7YBaFaew/LiiZzV60YcxspaNB
S0hP7tYP+rMLayXUdoYcg0abFs9jZpcXVlKtmwtsvFHpYPVeUQknh0BWdLwv6FYG
voDJfNDgQglv/xhZct9TQ9ujmaL9Yeg2Hu+Dz8l3IPI+Mcfyy8wL9cSmpIA4TidT
POg4/wK90YPZGkzYuzBOZCHqKDjnNA1s+Y2ylTjwi8e1FClNNQwB2PYPxJggb3/G
aJWVCEDXmQPMv2xQQOd5kYSb+OC85RZ8rLpSokHRbLbPNuuf7U54zUQoTSY1QCRQ
1gAZPCZASkGW3wFxbqa0ilTvaNMCutVGFRP+cYwEIN/iEPPnNVb46jpk/QDuVtDj
Zq/p3NzJa10r4bb+1qXHBlMgN4JBaTS0r/hGKZj9J71WL/t0Iir/72vepWuol8uW
WqEH5vZokKBGrFQDUhnBqgcfC5icXvyWnqmvGFQ4IN1DJIFmmg8mcmtTeNVPk4J5
HuABAVTXP2aZQASs5e6e
=QYe1
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
