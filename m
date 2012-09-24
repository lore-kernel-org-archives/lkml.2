Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2IXMln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:41:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64142 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2IXMlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:41:42 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, linux@horizon.com,
        vda.linux@googlemail.com
Cc: hughd@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
In-Reply-To: <20120924121614.5422.qmail@science.horizon.com>
Organization: Google Inc
References: <20120924121614.5422.qmail@science.horizon.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 24 Sep 2012 14:41:32 +0200
Message-ID: <xa1tfw67d24j.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 24 2012, George Spelvin wrote:
>> You are using a 64-bit multiply in a path that is designed for 32-bit
>> processors, which makes me feel that it will be slower.
>
> Slower than the divide it's replacing?

OK, granted, it might be faster after all. ;)  Still, I'd love to see
some benchmark.

> The following 32-bit processors have 32x32->64-bit multiply:
>
> x86
> ARM (as of ARMv4 =3D ARM7TDMI, the lowest version in common use)
> SPARCv7, SPARCv8

Didn't some SPARCs have 32x32->32 multiply?  I remember reading some
rant from a GMP developer about how SPARC is broken that way.

> MIPS32
> MC68020
> PA-RISC 1.1 (XMPYU)
> avr32
> PowerPC (MULHWU)
> VAX (EMUL)

> I could do some Kconfig hacking and make the code path
> architecture-dependent.  Do you think it's worth it?

Definitely not.

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

iQIcBAEBAgAGBQJQYFT8AAoJECBgQBJQdR/0tqkP/15WtAbkpAHJBBAeY9M3z18I
DJ3vJy6fh4kdK7X22xHnbKxfAENd4U8yaKAUghAwrppmMHYOS5V0249moAu1J8Lx
3x+ar7u3Anv+C8U5fd6jtPIBPNBLa2zcYXwDGNCFozecGmrNuv4iJnWAfcIjKMNt
Gey9b+RpUmmjpzdYHifbWL+2HDZEcRYiYb2VRenRkcN5IfX90G6LixY+ZeriGboX
HW4cpYEksKHCS1E9d3FUUVCn2YEY7ZixnThuHktZD0eeotrWz9q1Vt2B4Bv9XGvP
VNP62YRy1G3W+CFUuNmCEZ260zv+d0l218oRoAFcuxtfyIfZUwdkcrvUYCfPFPMP
gVfertBV4Yim/679XmWFpWC4rfYELNZUWNBFvF5QFjI3mD2zuV/rZEmw6QRI2m1i
CjKdBFRDu3L9pMTS3jnLkVVREOTA2TO35FNb85SSwzvxL1M4d6xJt5JewANZ4Zb6
Q0C4Qh7G3rNkTFM3Ub6x6dlRQVCdYRhATbdWpUPIiP+4uslkUifqAcESDtyfPijU
Jdh9SrY2c9Am4Q3P4TErqqXskXIvp8E0agniSWzwbm61oASIIGyygWHsCdW8gt/0
umgEEpkdWXTSk8ysEY6s0qBRfbpTkblYn7KQOxtyrh3/ZVsOqwICGt3sFBGd2Zer
WaAgEZBUedbg/A8YYYQw
=ZuWm
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
