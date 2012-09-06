Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2IFMvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:51:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47388 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab2IFMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:47 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC v2] memory-hotplug: remove MIGRATE_ISOLATE from free_area->free_list
In-Reply-To: <5048657A.7060004@cn.fujitsu.com>
Organization: http://mina86.com/
References: <1346900018-14759-1-git-send-email-minchan@kernel.org> <50485B7B.3030201@cn.fujitsu.com> <20120906081818.GC16231@bbox> <5048657A.7060004@cn.fujitsu.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 06 Sep 2012 14:51:39 +0200
Message-ID: <xa1tpq5z9uw4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06 2012, Lai Jiangshan wrote:
> +found:
> +	next_pfn =3D page_to_pfn(page);
> +	list_for_each_entry_from(page, &isolated_pages, lru) {
> +		if (page_to_pfn(page) !=3D next_pfn)
> +			return false;
> +		pfn =3D page_to_pfn(page);

+		pfn =3D page_to_pfn(page);
+		if (pfn !=3D next_pfn)
+			return false;

> +		next_pfn =3D pfn + (1UL << page_order(page));
> +		if (next_pfn >=3D end_pfn)
> +			return true;
>  	}

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

iQIcBAEBAgAGBQJQSJxbAAoJECBgQBJQdR/00ygP/RHyhsLlUo9J3kmSwe3GC/Yl
kxh0/b+BGnl5QZMU0FXYDJd9bw18zlM95SkXBGb9rqanr+/aqVrH5bU0Dkt6Yk4S
LmA6Rb8dk0VXGHsesQW3kIKJq1AB4yMUML6618pLYgnPRF4k0D+FmhjdITHfLJoN
husP95zV8xtLtnUXTx3SkcZ5Ae5dA92d6bXOmul6/gA6qB/JZ2xShD474UO0+Dbs
RF2NEYGzMuxEKEMKd4+UTLhgVwkDeTYUEQOyXl3DYvJyJjOACBZ6I4ZwK2xDwK8+
mkS/Y50wxmkS0HwiCdoNcP4Rwpdixy6Mqjj9GBwXZAdMwFZE/hhtvekwquE9UByv
mNz0bfXDVH6kUtzpDfY61cOM+ANEeaoKhnu/ap9g9DR2qAeAmLQgv3YwgaOXwoxT
lnqSMPJVXqpfMFa16VszvS6z501hpW/up+AW6CBRO51cIcYPw13BJ4LF+uDKkttJ
1g4e6NfQ4+LZrNOtNRMUB4AQs8GVli0zSntPAdAyiYanf9ZjdEImq8PTnrKapBAL
RIr1AiX+uJHBSh3yEBs+YAzokwOkWkHKBAQt5PGs1XyWD/IWm3UO9TqquVIxnrMx
f20N6mauE5NERt6dXg8PSoOAol8RBJD0b6jB1iAtoJbXzpwSQF1A+8h+O+xqWK97
JWVHFdiFcojygJw7rzzc
=D1YQ
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
