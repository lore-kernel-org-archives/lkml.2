Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2LUMqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:46:40 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44162 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LUMqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:46:31 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: compare MIGRATE_ISOLATE selectively
In-Reply-To: <20121221010902.GD2686@blaptop>
Organization: http://mina86.com/
References: <1355981152-2505-1-git-send-email-minchan@kernel.org> <xa1tfw30hgfb.fsf@mina86.com> <20121221010902.GD2686@blaptop>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 21 Dec 2012 13:46:23 +0100
Message-ID: <xa1tr4mjpo80.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Thu, Dec 20, 2012 at 04:49:44PM +0100, Michal Nazarewicz wrote:
>> Perhaps =E2=80=9Cis_migrate_isolate=E2=80=9D to match already existing =
=E2=80=9Cis_migrate_cma=E2=80=9D?

On Fri, Dec 21 2012, Minchan Kim wrote:
> Good poking. In fact, while I made this patch, I was very tempted by rena=
ming
> is_migrate_cma to cma_pageblock.
>
>         is_migrate_cma(mt)
>
> I don't know who start to use "mt" instead of "migratetype" but anyway, i=
t's
> not a good idea.
>
>         is_migrate_cma(migratetype)
>
> It's very clear for me because migratetype is per pageblock, we can know =
the
> function works per pageblock unit.
>
>> Especially as the =E2=80=9Cmt_isolated_pageblock=E2=80=9D sound confusin=
g to me, it
>> implies that it works on pageblocks which it does not.
>
> -ENOPARSE.
>
> migratetype works on pageblock.

migratetype is a number, which can be assigned to a pageblock.  In some
transitional cases, the migratetype associated with a page can differ
from the migratetype associated with the pageblock the page is in.  As
such, I think it's confusing to add =E2=80=9Cpageblock=E2=80=9D to the name=
 of the
function which does not read migratetype from pageblock but rather
operates on the number it is provided.

> I admit mt is really dirty but I used page_alloc.c already has lots of
> mt, SIGH.

I don't really have an issue with =E2=80=9Cmt=E2=80=9D myself, especially s=
ince the few
times =E2=80=9Cmt=E2=80=9D is used in page_alloc.c it is a local variable w=
hich I don't
think needs a long descriptive name since context is all there.

> How about this?
>
> 1. Let's change all "mt" with "migratetype" again.
> 2. use is_migrate_isolate and is_migrate_cma for "migratetype".
> 3. use is_migrate_isolate_page instead of page_isolated_pageblock for
>    "page".

Like I've said.  Personally I don't really think 1 is needed, but 2 and
3 look good to me.

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

iQIcBAEBAgAGBQJQ1FofAAoJECBgQBJQdR/0jiIP/jrryaTKAjAoBj4jyX7qtFXi
utw9C5umaqLKIQOmErQSAwHdIbyrwnqPnITXKvOjV2oLUTScJ4idlbVWvxogvCub
BSlVyw3/IARt14F2NEN8PkTib4EJNAOHPDIirVn/UId10Dy4u4iPKE4KXkNqtAEE
juM+s8GMt4gFsZ25b3QbvBFlsn4PNKap629KLZ1J3yvdq+Gp1ldWJKnZyKHtsIsy
UkzurFKX+qJYK8dUoDaFnkgcMInaZFhf7GRe9L6FIdRcUECBoDdzX6cnCJnn+ru8
XBBczIv0N/WXhw4NA7uTX+Jn8dSY0LDjYiKoDjdaDgG4SFtS5FspexCMCH2uVnIl
bEOqj+9K9tiCgfvcc4d0xV7IFFvu+6UnDuA9/ktKhX+zSGcjOwJAT5v/b2scuR5d
PalqlvS8PTVByjhjm1g33e4EMyBu6wBe3QrGav0/8qcWkEuf73lWtOF4Rok9yy/s
+/SvO4FljTKRpqNu2eJMHh6Qhw3YQDAI4lnvCgAohwPadUxrA8T36gbseEXdzv1Z
NQP/ipgNkEM0MrZAMtIpqq5jczeJTClzY1XoE4d3+iOwmbRoEpVeqbMRj5rixkIA
BgA384AjldkI+Esbsn+G6IXhu9XSM7SPfFBssPXYPa2GsHOBQ1V0zBWJ2+lrvRoI
1SMUcvpOSsuttlRbrjlA
=h6PU
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
