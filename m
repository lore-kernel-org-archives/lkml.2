Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2HPNSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:18:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47206 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2HPNRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:49 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 2/2] cma: support MIGRATE_DISCARD
In-Reply-To: <20120815232023.GA15225@bbox>
Organization: http://mina86.com/
References: <1344934627-8473-1-git-send-email-minchan@kernel.org> <1344934627-8473-3-git-send-email-minchan@kernel.org> <xa1t7gt1pnck.fsf@mina86.com> <20120815232023.GA15225@bbox>
User-Agent: Notmuch/0.13.2+121~gb26df7c (http://notmuchmail.org) Emacs/24.1.50.2 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 16 Aug 2012 15:17:40 +0200
Message-ID: <xa1twr0znfgr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Tue, Aug 14, 2012 at 04:19:55PM +0200, Michal Nazarewicz wrote:
>> Since CMA is the only user of MIGRATE_DISCARD it may be worth it to
>> guard it inside an #ifdef, eg:

Minchan Kim <minchan@kernel.org> writes:
> In summary, I want to open it for potential usecases in future if anyone
> doesn't oppose strongly.

Fair enough.

>>>  	if (!trylock_page(page)) {
>>> -		if (!force || mode =3D=3D MIGRATE_ASYNC)
>>> +		if (!force || mode & MIGRATE_ASYNC)

> It's not wrong technically but for readability, NP.

Yep, that was my point, thanks. :)

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

iQIcBAEBAgAGBQJQLPL0AAoJECBgQBJQdR/0GeEP/iRcc7bd6j8GvshNvmU8amgt
Hh0+A/Gb6jygt0ieRQDZcb/qC/ODYLuHQ4NMmns1mXbpswItIvmgBg1pQoblzZo0
3UOsST2EzJm5UtFaLzw4vqoXtUwvI5pQUx+qRtS3ROvZqQeCreRn5au2hWPMhTlY
0bAgFED9KX1rihMp+gn8ega96Lon/0Sdnc+yfQgMFfRl9kXGRauVUrnREO2nMj9o
kg8NM/syC/I/t3D7sL8ifq5mbe2bIOZMCV0o0vbMrpEs1bQaIsOsD5F8+4XG98kH
6vy5oAwqRNnFWjcR5QdG5dp+gcr/OArewDsRX5I49iIB8IuhkJvnfWQtbVVZy98B
ozNdmI5PANN6Kzs7mm0prtHsoiNvY/ODf3UatAK/w5ru+UJW7+SnC0e2pYmjlGhR
Qsrhio5x5geFjSV6iszA54rl313D9mzVSmNONgtKDj06ATAwRpMRErlh6huK32Zu
G5XVIoIXaljlPpOBtT59sEUpmt0FXiX5dCmInIPJkZdXuf4vnibyQlgO126zzoMU
/c7Bjw7RwGgAK3euKJVd69Ro/GS1PIzmfF+Q9+Dk3B/ZyTCEkLeNWxfSf912si4o
BOK4KrM5kjn7gZLYPWxBJ38sU43Oonix6gsaXG8GGCFRhtxQSjayszyH5lDdWl7f
YhSR0kdZ7FICbt9E2kuI
=mflS
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
