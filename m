Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2KZRyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:54:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50599 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab2KZRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:54:15 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
In-Reply-To: <50B3A1A0.2000607@linutronix.de>
Organization: http://mina86.com/
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <xa1ty5hogv6j.fsf@mina86.com> <50B3A1A0.2000607@linutronix.de>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 26 Nov 2012 18:54:06 +0100
Message-ID: <xa1ttxscgsht.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26 2012, Sebastian Andrzej Siewior wrote:
> Wouldn't say that. It may adds complexity on another level. The target
> subsystem has the same problem with adding luns and there seems nothing
> wrong with having lun3 and 4 and leaving 0 and 1 unsued.

That's not what Wikipedia claims though (from
<http://en.wikipedia.org/wiki/Logical_Unit_Number>):

	LUN 0: There is one LUN which is required to exist in every
	target: zero. The logical unit with LUN zero is special in that
	it must implement a few specific commands, most notably Report
	LUNs, which is how an initiator can find out all the other LUNs
	in the target. But LUN zero need not provide any other services,
	such as a storage volume.

That's why I proposed solution where one needs to have continuous
numbering of LUNs.  I'm not an expert on SCSI though.

> With the tcm gadget I get:
>
> |scsi 0:0:0:2: Direct-Access     LIO-ORG  RAMDISK-MCP      4.0  PQ: 0=20
> ANSI: 5
> |scsi 0:0:0:3: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0=20
> ANSI: 5
>
> You notice :2 and :3 instead :0 and :1. While should be there something
> wrong with this?

It may be that it works on Linux but fails on some other systems (or
even older Linux kernels).  Like I've said, I'm not SCSI expert, so my
knowledge of it is (embarrassingly) minimal.

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

iQIcBAEBAgAGBQJQs6y/AAoJECBgQBJQdR/02jQQAIq+8soXkQJ8Tr6FXrCTQmu/
8VjWhdqN0hfEWrZXejXqeb5aPfVBqYz/u5XSn3fXxYYuiblJW2jn/GkD20fAFRr4
95WVvj/MUr5Bdb6jQSBIQUz1pyB0sGaoeiegR81dlUFFLS3ekn/gsZA4UcbA1Rx4
uAkShfd4q6D2USf//o5MOmz8l7m1zZSd6yYZJTgi3dO3kmGXLysn+YzRmWvUdmgv
lCtjq4PphL31v83hjLgMqSVmpGSM6lTteOeiP6kpJMK5gZFmjcNr/dHdnPrilqsz
Ss+QgcAlbWs73n/2PvEIsy73R+Q4o153mBuYkNtDSaQ91yka3MYDuuJE1GJBDbTR
TRF/jPvuIJ7yln6Dyv8J8beZwHoGpBg4F50yN+dqdxTMRVmZa3O52rt5/0YFDxIB
cOj8SZWqQoVw+ia0nIZ6LxqD9Cnhhy5lb1uq/6MVCjKexIMDV1mXtY/nLtiufJTX
5/Vygifs+c9TJN7dieCRUMrBPNK1QwcvjpVsesvCoZ8Zy27h7LPp1rcKUqwlV22S
wd3u+ZeRegND0Y1jiXI0EmozI+MiIckUJqXJZtA2z4F13lgTkQwt7rOLUyGsCjnk
ubxHASbpw+hdC5VQVL4V+6ND+xKtbm4g9l4iGbfdhpWjJEJOsQqwpWoWiYg8f+wf
kkziMuggASOQVRuLzY6I
=UBCB
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
