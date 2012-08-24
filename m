Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2HXQqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:46:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42062 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2HXQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:46:44 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mm: cma: fix alignment requirements for contiguous regions
In-Reply-To: <1345792810-5152-1-git-send-email-m.szyprowski@samsung.com>
Organization: http://mina86.com/
References: <1345792810-5152-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Notmuch/0.14+2~g416b120 (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 24 Aug 2012 18:46:34 +0200
Message-ID: <xa1ttxvs2q6t.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marek Szyprowski <m.szyprowski@samsung.com> writes:
> Contiguous Memory Allocator requires each of its regions to be aligned
> in such a way that it is possible to change migration type for all
> pageblocks holding it and then isolate page of largest possible order from
> the buddy allocator (which is MAX_ORDER-1). This patch relaxes alignment
> requirements by one order, because MAX_ORDER alignment is not really
> needed.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/base/dma-contiguous.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 78efb03..34d94c7 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -250,7 +250,7 @@ int __init dma_declare_contiguous(struct device *dev,=
 unsigned long size,
>  		return -EINVAL;
>=20=20
>  	/* Sanitise input arguments */
> -	alignment =3D PAGE_SIZE << max(MAX_ORDER, pageblock_order);
> +	alignment =3D PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
>  	base =3D ALIGN(base, alignment);
>  	size =3D ALIGN(size, alignment);
>  	limit &=3D ~(alignment - 1);


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
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQN6/qAAoJECBgQBJQdR/0cdIP/iefsLh1o+XolmGZH2R67hAE
Ktci7O0fFlwg0D6fgE2D/tmsLbYZFuSLGWbjWvb0I4tKMuleDSryH3P1AYN8uD3K
NYhwGHeyvwCNtn0QQ3bHL17ScanefZBmBOxnIi6wDWlvS54CFQJFCqSbSGYGoUq/
5mJpxnTlT/+3g0WB/SEMN9L1VPe51aGnvTK8scX4KP263yAQa9CTKgaOuMW/jAPy
wELs+3YyR/zRdKNr8Ay+E5YhpXAoIHbm2RucQpLZTFmC05bCxBO6LmkDx7EYnf1g
GHwt0Jp9OtrK/eTOgszu2bJ4S+ruieQKhN6pjPxnwAfc5r3AxN8qA6YfiiKV/9zs
Tb12vbBhCRtsGjEFZcTL9d2LFX64jy7rqPEERM1s0A/7Q3+o18z4/GyFv4dODsoy
4omv1cqKTsz7odieVATVf5hksIdmdH97KT2KXdpP7u2J0DjQgf/xyPg1SKCIO8B1
eChM6rgk0b+KPABXWv6yz+0iYXwbEhTidmThvODRY/q8npXFSTIRKkxQzVRVN6oe
BB5505gRj5hXa/6JVaw+TZeiJn4wO/ymdAgTYvcvd9/fh2I9tfn4+yuk2G+hm7KH
sOFlS+Mq2Nxf9TALSeXQemgnm0BF8nQjEQN2dbttansvtz7PRNUApEVqbOCOh7Kv
KZ30NJoHGHGAdbMQTw+p
=BLh2
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
