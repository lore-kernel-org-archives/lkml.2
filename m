Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3AFQCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:02:05 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:49742 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3AFQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:02:03 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Simon Jeons <simon.jeons@gmail.com>, Liu Hui-R64343 <r64343@freescale.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman\@suse.de" <mgorman@suse.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel\@redhat.com" <riel@redhat.com>,
        "minchan\@kernel.org" <minchan@kernel.org>,
        "kamezawa.hiroyu\@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory return error issue
In-Reply-To: <1357463980.1454.0.camel@kernel.cn.ibm.com>
Organization: http://mina86.com/
References: <1357458273-28558-1-git-send-email-r64343@freescale.com> <20130106075940.GA22985@hacker.(null)> <AD13664F485EE54694E29A7F9D5BE1AF4E5BCD@039-SN2MPN1-021.039d.mgd.msft.net> <20130106084610.GA26483@hacker.(null)> <AD13664F485EE54694E29A7F9D5BE1AF4E5E1F@039-SN2MPN1-021.039d.mgd.msft.net> <1357463980.1454.0.camel@kernel.cn.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Sun, 06 Jan 2013 17:01:48 +0100
Message-ID: <xa1t1udyjo5v.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 06 2013, Simon Jeons wrote:
>> >write(1, "1\n", 2)                      =3D 3

>> Here it tells it.=20=20

> On Sun, 2013-01-06 at 08:48 +0000, Liu Hui-R64343 wrote:
> Why this value trouble you?

Because write() is supposed to return the number of bytes successfully
written.

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

iQIcBAEBAgAGBQJQ6Z/sAAoJECBgQBJQdR/0vc8P/A/mtUEbevpmgRTO9TXUtgXG
CA+MzCT7txiqZbm0pqtx/zE0WmrqPCVWD37kKaGhrXMTh4qsIrgjxyyxR2tDgk37
HnRN3lhZHlKtBOuym2PEd7aTJF8mQv686lK/L5mqU6AFGzSaUlCdyYq3Z3c59nfS
Y3KE7e6FmglTIwtc1/a/VNoOSLMUOxR9rt3FJqy9JMk98gHRH+bgdwCdOdbPKogV
fGfW7LmRtGMo3YzDgAj0DoXlCwYZJ4rBttshF9dVuTcmOSxVZsxgb96joEiecvb6
4nq+SNInik928TPZTUm6LmPJBmUabLT3fBPwKh3WsaZ95V/x48qLWHERXZSgux1k
tPQFXT1HQIX4hK3Vfzp4WCHfD6g6SVG6EmxLp5N8dWomxFrZSp6Fg+mvry968xzL
cyFm5GYFFxEINlKDZfEl06IjbM4uHgcXTzxwddZSfHr4yokMIhtmKmmlRUuNF426
YJ67nZX23829DXzlH4EhH2qhhISGjjiU2JkQ9Z9ABSo9ptm4hTBbg+0sxNbdCPSv
qjSTz+2xvZuGp+FJ5+n2dLw+rq1hRB8F/GPIjJxdz7gjROAWgFWade3hhnmBtGTL
w6Jctfpomg/vRmjBkXXcbepv5DXAPNrhGYFZVyixvKSpiEcEDpW5zVTMi499whAu
JUtPihQw+2UG/iR52s5t
=CGlX
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
