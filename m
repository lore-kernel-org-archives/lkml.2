Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2K0QX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:23:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54044 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2K0QXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:23:24 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <50B4E364.8030704@linutronix.de>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 27 Nov 2012 17:23:14 +0100
Message-ID: <xa1tip8ruia5.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27 2012, Sebastian Andrzej Siewior wrote:
> I don't want to push python on anyone but the removal magic is simply
> straight forward: unlink the disk ports, rmdir luns, tpgt,=E2=80=A6

How should a generic tool know what kind of actions are needed for given
function to be removed?  If you ask me, there should be a way to unbind
gadget and unload all modules without any specific knowledge of the
functions.  If there is no such mechanism, then it's a bad user
interface.

> I understand the need for things that pop later like interfaceXX but
> couldn't the user manually create them if he needs them?

I think the question is of information flow direction.  If user gives
some information to the kernel, she should be the one creating any
necessary directories.  But if the information comes from kernel to the
user, the kernel should create the structure.

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

iQIcBAEBAgAGBQJQtOjzAAoJECBgQBJQdR/0X7MP/2QOORpTXyGVqEnbuI7QUxWF
9AvHeLeF54QPGshe8gqBW4erZBK5qMgMoOqqR9tApoPQSbddykMDhMfu/ELCY0mx
itfzZRWH+CHBoOySmZeMI3hjL3aHteqw4VaICU8BrjZPX5PPJ15Y7exaGNFodqSH
bJbvr5m9yXjsW2M2sof48bpOARD1y5ZELIIdMwyGn0YqL088FHiiZ99Yk1gKdaWI
it9+hLPYfb1GZGNi+xNn1kmWb5rvsMx2Bww5TsqC2C0ARbdzupZViHfgtMLUSWvw
vO1lcVpOkiQUuAOZ1eTbGkXXNaJVSOiTny8VL68O4ZlAelrBYolYoBUDlU4iVq+B
zlHAepf070TFVkyYkr+K9yTRYYLkNifPfymhcrACN1aB6reiUVViCzTodl8olpJj
e1WTLOEzo7Z5XhxN+HRTyvW4PuyMqtjbaMim6h2z3xCiwBj77ECdZgn2ZbCa/3k9
6RRWWo/C9oR9A95pXQmwoj/3mEVGn1pk3wZ+NlHXJT9rZ7mZDXr7R6aSxjj/iUdO
+gqLRqlyWyHeVo6hlTdR/bq+XQHT2g4rWK1DNXl4yap/mB9y/P9+mbqS4VgdlFYK
L/ti6C7LDL7+VfVVkv/4qkAduzX8FHr7JpCbk5L/f43Rt5zyf43Ju4PsfqLscuVv
D7p6KthT/Awan39pE7cJ
=TCNI
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
