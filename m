Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2IFM46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:56:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34135 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2IFM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:56:55 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC v2] memory-hotplug: remove MIGRATE_ISOLATE from free_area->free_list
In-Reply-To: <50486658.5000305@cn.fujitsu.com>
Organization: http://mina86.com/
References: <1346900018-14759-1-git-send-email-minchan@kernel.org> <50485B7B.3030201@cn.fujitsu.com> <20120906081818.GC16231@bbox> <50486658.5000305@cn.fujitsu.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 06 Sep 2012 14:56:45 +0200
Message-ID: <xa1tmx139unm.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>> +		pfn =3D page_to_pfn(page);
>> +		if (pfn >=3D end_pfn)
>> +			return false;
>> +		if (pfn >=3D start_pfn)
>> +			goto found;

On Thu, Sep 06 2012, Lai Jiangshan wrote:
> this test is wrong.
>
> use this:
>
> if ((pfn <=3D start_pfn) && (start_pfn < pfn + (1UL << page_order(page))))
> 	goto found;
>
> if (pfn > start_pfn)
> 	return false;

	if (pfn > start_pfn)
		return false;
	if (pfn + (1UL << page_order(page)) > start_pfn)
		goto found;

>> +	}
>> +	return false;
>> +
>> +	list_for_each_entry_continue(page, &isolated_pages, lru) {
>> +		if (page_to_pfn(page) !=3D next_pfn)
>> +			return false;

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

iQIcBAEBAgAGBQJQSJ2NAAoJECBgQBJQdR/0+1QQAIR5P9SLVdGeUtCVULOZJe5e
DSIL9hJ9CG5AQoANFaLvoe+EF1jiKsk8AyXnmOSX4yNi4M5cFVfc3Zr6i6t4cpLE
wbUxVjIFsZ41thzgFCwJrxK9daLAMs5Mxk8NnjJZLBzrLfbQTwzQgyeJhdufRnC4
+JPTeEmrtR621U/v1fyiBS3BFI+FhnChaApwytBdmgQFylVz2OFLCvYxVgr2RS+V
JCT0olf/EMo5GZasGzjAvCM2FLtV6r64lpTV2KtjLVX4NILtcpOYjd9rzqMabbR5
LLzG15eHVjBf28yONUJQNHjpUX1hYYkonyqdYVVSX3KFlSb+1mCyXD+n5U8hmk0S
oil8igzQQvX/JtuMl7RMgh92Up0GtbflcxU6tGU+WVqLMSvCP1pcdIWUr4GRf0dN
PgB8ZbZlYzZo6tPnFTr1ioFDl7vJ+LQXHGyzdQ7tTUg/xKCwDPddjWev1AfYNmma
zBgbgkjyMaJhX7TAEwE+MimADcHFEJntOmnwab1KOE81sX678B0v1zVQAkYP/+bf
1Gfcw3iRGXhJiZChILJRhSjM7MuJ6rfJs9SqxJ+hNXcwxfyHIN7iT7WxD+yMlvNY
PKA2enUkLVe83CMYcaisIUA/O5VAaP00jJv2W/RKGVMt3O3lVZ1XSrmW+Ljaxnb2
rn7FVmVzQTk26k7Sg/U0
=+qAP
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
