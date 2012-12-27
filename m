Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2L0CGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:06:06 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64653 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2L0CF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:05:59 -0500
From: Michal Nazarewicz <mpn@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cma: use unsigned type for count argument
In-Reply-To: <alpine.DEB.2.00.1212261755450.4150@chino.kir.corp.google.com>
Organization: Google Inc
References: <52fd3c7b677ff01f1cd6d54e38a567b463ec1294.1355938871.git.mina86@mina86.com> <20121220153525.97841100.akpm@linux-foundation.org> <alpine.DEB.2.00.1212201557270.13223@chino.kir.corp.google.com> <xa1tip7u14tq.fsf@mina86.com> <alpine.DEB.2.00.1212261755450.4150@chino.kir.corp.google.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 27 Dec 2012 03:05:49 +0100
Message-ID: <xa1tzk10ntaa.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Sat, 22 Dec 2012, Michal Nazarewicz wrote:
>> So I think just adding the following, should be sufficient to make
>> everyone happy:
>>=20
>> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous=
.c
>> index e34e3e0..e91743b 100644
>> --- a/drivers/base/dma-contiguous.c
>> +++ b/drivers/base/dma-contiguous.c
>> @@ -320,7 +320,7 @@ struct page *dma_alloc_from_contiguous(struct device=
 *dev, unsigned int count,
>>  	pr_debug("%s(cma %p, count %u, align %u)\n", __func__, (void *)cma,
>>  		 count, align);
>>=20=20
>> -	if (!count)
>> +	if (!count || count > INT_MAX)
>>  		return NULL;
>>=20=20
>>  	mask =3D (1 << align) - 1;
>
On Thu, Dec 27 2012, David Rientjes <rientjes@google.com> wrote:
> How is this different than leaving the formal to have a signed type, i.e.=
=20
> drop your patch, and testing for count <=3D 0 instead?

Not much different I guess.  I don't have strong opinions to be honest,
except that I feel unsigned is the proper type to use, on top of which
I think bitmap_set() should use unsigned, so in case anyone ever bothers
to change it, CMA will be ready. :P

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

iQIcBAEBAgAGBQJQ26z9AAoJECBgQBJQdR/0FLsP+wXrMoNqTvrzcm44rlE94pb9
J4dpiQH2rSHTWsR3xfdwmoupgrL2WnLb5PRz6tfvf69bdWRhlkmz5OTR1sld95Mi
pB/bwmhdaSknDx8qufJCoaqTAlMD328RBktU8vvpSxZwQZJbqA2sod2lHT4La+aT
38mGGfIWhOHEKNZlgqm91DLOkwptHn0NPCs4udfEMC3lWiTfpp78KOeFM7OPeb4W
GiiunyocX/Y2oez09X63JvFBVFopx0l3rtKbAKAiKW/QRnfgEsshDg/t4rWKnILY
3l+EZBTBsuYaWSaPcgtWZtu04fkOqVF6Dq8lrqw+HjfIvmh8x9X+M7srIwxhR773
rIENo0XVC6dbov0qvuMd9VlnMhQl1vf9n5UIFGTSnjIpY6rn8puOoXNHCUj8YahN
ZMrQxzK7pdJ+yroW/3iaqDjgOyqdNE9sbJ34dM5bGW64cuTxsr5o8iiPD6Vj1oa1
ShY0Xx8V2+J2LQGRHUGIywXu2E499JbIQv/LLDPKm0SWLdANRrGn6TfcD0644Qp2
PM/2cff5xC7PfOxpLipeagJ/RuZRmxZsGcu2gfgXG4wUZJ2ej43qSBmqQQ1Q5hjv
aXdqvgM5q0cHT/yjO2Oe0IwTjl4V1RTQJgrsGIzak3GnjVZaVYbcGcKmDU/gLVSK
3TRe56LEL6ILhJPJnxh2
=gJWR
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
