Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2K1OY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:24:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38905 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2K1OY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:24:57 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <50B61695.50207@linutronix.de>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com> <50B5C821.4000406@linutronix.de> <xa1ta9u1naik.fsf@mina86.com> <50B61695.50207@linutronix.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 28 Nov 2012 15:24:45 +0100
Message-ID: <xa1t1ufdn6tu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28 2012, Sebastian Andrzej Siewior wrote:
>             <function_name>-<common_name>
> /functions/acm-function/
>
> instead of
>             <common_name>
> /functions/function1/
>                       +name
> with attribute file named "name" which contains the name of the
> function (i.e. acm). My point is to keep "name" in the directory name
> instead having an extra attribute.

Right.  But as I've suggested:

	mkdir functions/<function-name>
	mkdir functions/<function-name>/<common-name>

which IMO is easier to handle in kernel (no parsing) and looks nicer in
user space.

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

iQIcBAEBAgAGBQJQth6tAAoJECBgQBJQdR/0ttMP/1DxhtAbhNX1o3BClVjUpxMO
c6uBnlOXXvL7iqIlDOnSrBJE5UmNGx6Qc/Wed0/SLUVAEk96vaYZ4Fkt2v/m3iA9
uKZx67PWZGqb5G7TOuN5iF/soIiYt6VfjAKlNxL1WQAL9BlyEhTA/z63bIG12wS3
wyG8R6ow4uCUT233hAlEwJpKWpelk501F4ZQc9VAIbrK7rSutGY5vfeRM0ORiQge
Z000D9TRiKQUaYTpqEJ5Ay6IvNFt6BPEyHuF6Xq+c4i+M9tl3fllEZWXV77A6MIB
vmbyIvDlsCgMRxinpVoJChG8DNCPSnI48Q6+YJiiS13XurS8UYQktZM5xqiDNbnj
ANq2pzdLB9RvirDB0CaWFZSQzRKg/MkiV5v8tv3Ddt0AZuFJb9dwr9R9JeuxRzt2
hFCjmaWgMRemoYdPGUPd3JgVkGZebQBQdlOw2y/2elIcA25vZzABST4EOcYrzOfE
IKfOK8FkauWpqys2sEu2zXio0yCZXXwVi1P9iy4JmgN1kZdGuT9WUD5xFFr82zta
YVeMabDJFf+Stw9xnXOOk5F2KIFugSSQtoMYbXEw6OhXDu6jqzXMIsJIeTVlnIhM
tf7dmivAXlRl4tIOslmRnY0AnwFNioko1yFCoXVDioN/oBCpMqIvOaU8xXoP+iI4
mdd7UKa6SCrLKEW/Uos5
=UTab
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
