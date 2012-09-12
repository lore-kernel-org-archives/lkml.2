Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2ILKey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:34:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44300 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2ILKev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:34:51 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] memory-hotplug: don't replace lowmem pages with highmem
In-Reply-To: <1347414231-31451-2-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1347414231-31451-1-git-send-email-minchan@kernel.org> <1347414231-31451-2-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 12 Sep 2012 12:34:41 +0200
Message-ID: <xa1tk3vzh6m6.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12 2012, Minchan Kim wrote:
> [1] reporeted that lowmem pages could be replaced by
> highmem pages during migration of CMA and fixed.
>
> Quote from [1]'s description
> "
>     The filesystem layer expects pages in the block device's mapping to n=
ot
>     be in highmem (the mapping's gfp mask is set in bdget()), but CMA can
>     currently replace lowmem pages with highmem pages, leading to crashes=
 in
>     filesystem code such as the one below:
>
>       Unable to handle kernel NULL pointer dereference at virtual address=
 00000400
>       pgd =3D c0c98000
>       [00000400] *pgd=3D00c91831, *pte=3D00000000, *ppte=3D00000000
>       Internal error: Oops: 817 [#1] PREEMPT SMP ARM
>       CPU: 0    Not tainted  (3.5.0-rc5+ #80)
>       PC is at __memzero+0x24/0x80
>       ...
>       Process fsstress (pid: 323, stack limit =3D 0xc0cbc2f0)
>       Backtrace:
>       [<c010e3f0>] (ext4_getblk+0x0/0x180) from [<c010e58c>] (ext4_bread+=
0x1c/0x98)
>       [<c010e570>] (ext4_bread+0x0/0x98) from [<c0117944>] (ext4_mkdir+0x=
160/0x3bc)
>        r4:c15337f0
>       [<c01177e4>] (ext4_mkdir+0x0/0x3bc) from [<c00c29e0>] (vfs_mkdir+0x=
8c/0x98)
>       [<c00c2954>] (vfs_mkdir+0x0/0x98) from [<c00c2a60>] (sys_mkdirat+0x=
74/0xac)
>        r6:00000000 r5:c152eb40 r4:000001ff r3:c14b43f0
>       [<c00c29ec>] (sys_mkdirat+0x0/0xac) from [<c00c2ab8>] (sys_mkdir+0x=
20/0x24)
>        r6:beccdcf0 r5:00074000 r4:beccdbbc
>       [<c00c2a98>] (sys_mkdir+0x0/0x24) from [<c000e3c0>] (ret_fast_sysca=
ll+0x0/0x30)
> "
>
> Memory-hotplug has same problem with CMA so [1]'s fix could be applied
> with memory-hotplug, too.
>
> Fix it by reusing.
>
> [1] 6a6dccba2, mm: cma: don't replace lowmem pages with highmem
>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Looks legit:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

I also like how both of the patches cumulatively have negative delta. :]

> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

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

iQIcBAEBAgAGBQJQUGVBAAoJECBgQBJQdR/0uysP+wUFnJi/YidjhWYibmgSVs2L
fwd6FDd/gIyZFise15T+q4a0bEthtCMGCDOeMJEKU6cEbeHFKFNCXUUjLuJom8kj
iarPCPvAhZvD+Zj31A/XPu/6OkdfkAJoK3qcjeHQrLvG+U9bCUPBCXG/Dn0HRrso
PL5cIUSoitCJpHLEnF2s3TKheUj4uOjSTXKN1KUsd1qLKzm6zXZrxjI7TkD/Kmjz
ttqjYjgDqdSsSto2MoBzbTyY41NOGegNtIJpK7VSbvxUn/3OZIOkuPCMY93oiNXG
YNsmQW4IrA36Kxbub9bt4GJYwxgwLp8gomQj8r+bRx4NLJOJHS1IFkSDAthjgbJH
lu7qZLSIBT4ToW7uC77x+lt6//DZUdW3mGaKFeVKlP4f6INqWzIZMgKHK9roEn4d
2qqB+PocaOwie+jpvCnilFjmIhgEOyYBrC+aBpmezoeT5eXQU2CCNG2jDnnJzT7d
YCefC4uT3iKnjgoVl323+paPkSD7ZSJHRM0/KJUFsQyGfbAgJSaqFQrdPIkfDP1u
l7QuqvCUFhHMJu9A0OrlYgLCfvZzNJ2oOpI16WinBy8lyZYjHOUF34jaXRvoLFgp
pokO0mHyLGB8J6invXOfvoa7zOzh1IB1OGXBZyxaYrKMNoEgEJ95x50KS3zCVvVH
A9CbI7SWWFz3Og35jt9x
=Ai6o
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
