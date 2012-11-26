Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2KZNVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:21:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2KZNVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:21:12 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 26 Nov 2012 14:14:13 +0100
Message-ID: <xa1tk3t8ik0q.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26 2012, Andrzej Pietrasiewicz <andrzej.p@samsung.com> wrote:
> In some parts of the kernel (e.g. planned configfs integration into usb
> gadget) there is a need to programmatically create config groups
> (directories) but it would be preferable to disallow creating them by
> the user. This is more or less what default_groups used to be for.
> But e.g. in the mass storage gadget, after storing the number of
> luns (logical units) into some configfs attribute, the corresponding lun#
> directories should be created, their number is not known up front so
> default_groups are no good for this.
>
> Example:
>
> $ echo 3 > /cfg/..../mass_storage/luns
>
> causes
>
> /cfg/....../mass_storage/lun0
> /cfg/....../mass_storage/lun1
> /cfg/....../mass_storage/lun2
>
> to be created. Yet
>
> $ mkdir /cfg/..../mass_storage/<any name>
>
> should not be allowed.
>
> With create_group exported it is very easily achieved: make_group and mak=
e_item
> are set to NULL in mass_storage's config_group, yet the kernel can
> create_groups at will.

I think the above description should be part of the commit message. :)

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

iQIcBAEBAgAGBQJQs2slAAoJECBgQBJQdR/0IwQP/2QPnKsOBTd3hwbxnTbIoqTn
avxDm2uHOM0fqZ2t49fYVCI1wxv7lhj/1BEuc9KxAYP/OCz8eWsfvNKRydKRf+fQ
Xr0MzlN73iXaeS3dXh/jzErTUae9WHM1xko4A1xV4hAL4sbwb6exPuukW6CgI8zY
AWGsp4jFNE6Bj3XyQHmU70hpEKlzjxEhM5pBbOCKivrTRAQJY1QSwZ7ncFdbrP61
wEMj4Job4Te3mM7UoCn93bVW7J5D4gAyc6iCDyS13t6ldy6ZA1clHhV+lAIz1eaC
ob1cswrypM2lswAmxi4T1QKFJA15DpiLFa+LkexYZauvCh3eWY36aESYGC7f6fge
o7c4M332z8QJfUMcIGe5QWQFc/z8T9Zdq3rP0hDNnohiKnB2W4x3KOppmt/VghDR
qJ6isYK6nyTjwx2tCElXbahRIobI28lFmPQNC5QTR0rKCLWeeOPI3smiI42ue6+k
3H65QtTctlRIwLzEuxF6l5wi7YsLky5ocXLZkklSHNimZ4Qqg8xmSGGu5mtL4EFM
7VPzDHCI8Va6G79W67ae2OlJ+4wQlVjAmbutyrGc2FtlAxhUWLdOJAY3PFgbTecP
w4F7HiiwePcVNmAadp7wKHe6JJse52/tXgyO1AiStzxRIaHSaWQXTgpAz2e5eGOo
+a6f0V3CfvX/vHPSMqnQ
=v6KB
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
