Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2LTP55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:57:57 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43676 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2LTP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:57:50 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 10:57:49 EST
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] mm: compare MIGRATE_ISOLATE selectively
In-Reply-To: <1355981152-2505-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1355981152-2505-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 20 Dec 2012 16:49:44 +0100
Message-ID: <xa1tfw30hgfb.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20 2012, Minchan Kim wrote:
> diff --git a/include/linux/page-isolation.h b/include/linux/page-isolatio=
n.h
> index a92061e..4ada4ef 100644
> --- a/include/linux/page-isolation.h
> +++ b/include/linux/page-isolation.h
> @@ -1,6 +1,25 @@
>  #ifndef __LINUX_PAGEISOLATION_H
>  #define __LINUX_PAGEISOLATION_H
>=20=20
> +#ifdef CONFIG_MEMORY_ISOLATION
> +static inline bool page_isolated_pageblock(struct page *page)
> +{
> +	return get_pageblock_migratetype(page) =3D=3D MIGRATE_ISOLATE;
> +}
> +static inline bool mt_isolated_pageblock(int migratetype)
> +{
> +	return migratetype =3D=3D MIGRATE_ISOLATE;
> +}

Perhaps =E2=80=9Cis_migrate_isolate=E2=80=9D to match already existing =E2=
=80=9Cis_migrate_cma=E2=80=9D?
Especially as the =E2=80=9Cmt_isolated_pageblock=E2=80=9D sound confusing t=
o me, it
implies that it works on pageblocks which it does not.

> +#else
> +static inline bool page_isolated_pageblock(struct page *page)
> +{
> +	return false;
> +}
> +static inline bool mt_isolated_pageblock(int migratetype)
> +{
> +	return false;
> +}
> +#endif
>=20=20
>  bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
>  			 bool skip_hwpoisoned_pages);
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

iQIcBAEBAgAGBQJQ0zOZAAoJECBgQBJQdR/0JaQP+wUiFmn/WVrdrXO37kDHr1uw
unGc45gwZizHjGZdnTEAGiJVOTyeA1nicUZ8SoMEuv1N/L1iPjqa+diWGlqh7S2+
3NoXVlzitMEqy1aWQEl8NZIQbcAEak29WlpVDQZhC7CyyoY3qC/tn3z9OC63AiuG
lKxRRvMnF0GcIqBSnj4XLOkO+tIviooIiGxdbERstim8okxojQs894NDrQkrKzA7
94thgXChhGEsx3BmRGVbYnoT0Z7Hcz8WAM3Jjv+hxQtNW1x+7oo6G2uWNMnwspfG
L3oajPjVYxrMxg3JtGq//ISF0THg6NMJbnhCZnYZrffFe+r45eELKX+mIulojcNp
yRmZojuobVGmKIulWan+F/LjZaVmMHb8n6TH7Rs5jXx4D7XA58SgC8mLCfZg6wrJ
mjeNZWFgmDuF6M+cDovTW0xdfuCmJajPvSxvXtNNa3KFpFOphMq/6YuVfzaJoqfL
slDkQ47slEtSlbFWuPhXdHbsK9xddScOHL8aAmEe6EyrRW2hdDD1pwVsY/ThDRL3
BzFIuejZmcEe6pYUzmMlJ0uGS0TtmT4vkiDdbUieo+Hp53i8Du0Gy35Dd2bY0GUB
L6o61GLFx3Fge5yq9DSU7MwghJdcmNla//y0y3GmmEz2V6LJdHyDgobt8KMF6+Zf
cn7HO40PeY0lUnRpXALq
=7hVI
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
