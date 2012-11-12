Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2KLQwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:52:23 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57009 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2KLQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:52:20 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        SeongHwan Yoon <sunghwan.yun@samsung.com>
Subject: Re: [PATCH] mm: use migrate_prep() instead of migrate_prep_local()
In-Reply-To: <1352708989-25359-1-git-send-email-m.szyprowski@samsung.com>
Organization: http://mina86.com/
References: <1352708989-25359-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 12 Nov 2012 17:52:11 +0100
Message-ID: <xa1t625azrus.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12 2012, Marek Szyprowski wrote:
> __alloc_contig_migrate_range() should use all possible ways to get all the
> pages migrated from the given memory range, so pruning per-cpu lru lists
> for all CPUs is required, regadless the cost of such operation. Otherwise
> some pages which got stuck at per-cpu lru list might get missed by
> migration procedure causing the contiguous allocation to fail.
>
> Reported-by: SeongHwan Yoon <sunghwan.yun@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1bfe2b0..fcb9719 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5677,7 +5677,7 @@ static int __alloc_contig_migrate_range(struct comp=
act_control *cc,
>  	unsigned int tries =3D 0;
>  	int ret =3D 0;
>=20=20
> -	migrate_prep_local();
> +	migrate_prep();
>=20=20
>  	while (pfn < end || !list_empty(&cc->migratepages)) {
>  		if (fatal_signal_pending(current)) {

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

iQIcBAEBAgAGBQJQoSk7AAoJECBgQBJQdR/09NcP/15Ve5P9jOlCH3LpZZkRAjRD
e24MCnmkrj/SGaped1F2rW3nZr/Qb2lZtKHwYXcrU+qj2O3Ndj/Iz80eW4ywVnVi
QOqzDKwfBi0lapCtZjyCsiyrmsR/eKJ8aH1wNtQzMBUEqkqHKniBXyeJ5+ARlVFV
WHKljHOPAlH8XIOdggumWAEKWuJGnJg9uRIRrAWSB0dWsjLCTLOypB83QeqRzC2g
ACSuVnSk1fHmeaM7moFCahw5+nTta5HC99FAboSRLTVO3cfaew+Wxqzsy6Ld32ob
zzrvMTB/yV92v9FztgG6qpyEIfIxtcnx93AyrFEs2xcKIpL2lf/rzmBBQmB2rMX9
2b2oJWqRyqZ2I4iOfxfvG+xcXmRCry7mN4j/6cdDV8/KR/NXFkm8kC4PgjGguqs7
wRXKeSGLjssOkU1Zo4Yvx2RW/TY4txav6Jl3nWRvmwhY47z9YkZrm8K4J+yvC71h
n1+u2TIT2dpkJSCInNICICwTsid4b8WgnKZK47rgNtPK1reUJlkVJSjizhRwOs/o
feLi+xYOzNLQ794MT+EgmykUMVSZoPzZ5gBQn8/YIz8ByQPUbkX0NjM0fq2ab+rM
PuEilIxWoyQonKhSx5Dh7gK7Kd/duv9+pkZ2KUsr69SXTL3qrABbImYUPSez9hxw
firzZ5iyjnv6zdXHEMLS
=s8Xa
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
