Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IXO56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:57:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44389 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab2IXO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:57:55 -0400
From: Michal Nazarewicz <mpn@google.com>
To: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        linux@horizon.com, rabin@rab.in
Cc: hughd@google.com, linux-kernel@vger.kernel.org, vda.linux@googlemail.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
In-Reply-To: <xa1t4nmncw03.fsf@mina86.com>
Organization: Google Inc
References: <20120924143305.30771.qmail@science.horizon.com> <xa1t4nmncw03.fsf@mina86.com>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 24 Sep 2012 16:57:46 +0200
Message-ID: <xa1t1uhrcvth.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 24 2012, Michal Nazarewicz wrote:
> Ah, right.  I also thought about that first but than started worrying
> that it could produce unnecessary zeros if the loop iterates at least
> once and exits with r being zero, but now I see that this cannot happen
> since if the loop condition was true, r >=3D 10000 and it has been divided
> by 10000 in the loop so now it's at least 1.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I of course meant =E2=80=9C10=E2=80=9D and =E2=80=9Cat least 1000=E2=80=9D.

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

iQIcBAEBAgAGBQJQYHTqAAoJECBgQBJQdR/0P1wP/iRnaKniIRjQ9qbGXqY3dZsD
QjzD7w3eNrK/HP/ND2O+FIc4/15vSzTIKT0P6xDBL6YgPP1aGtfs2mBg82UVPTmD
YXGJ35GRGQ+zW/UXkXlVTcPS+ccU/0EdEFBMYjQPPkNSdwySMdEaKZSRp53pBn50
ND6sc0NAQa8CYyLEGjgRXTZ7HPoNmQ66VFVuCi+3tK3aH3+WciXfm9vFycN1bJja
05jlJqjRaS+2DKBAwJxLdRfGQcxU1wEjiYqfvPgFIjjYiZgw+waz+/NkZArMW9+c
P3CHcKIFUcSp65vPCzCLcZ24rZTn9sMFHjoex0yW6BJHx69LHWCesRukHGSvWKi5
2qdzaF+yQ+by2tvQJCInS/7tqhpyjNQpS5y9hWmKpTul7m/mUtmH8XTaPzipnGyJ
3SQfmGlvih5YKSMtp2vqLLdhUj843x/4BwfQSCizIsj0vCzeXgCn8nfLAK0fWbVV
7WVmqphKJJ4eQeoTlGftTbJ7rUa7BdgbkvODfyhtjwXOtOCX5ESZuFwrU+Mhdjyr
SPx7nR0J12PE67DEykJqtyl6xURz2/9TzRUeBYa7HywfZNwUYI96K7zwqiwk2v1F
9x4G4YETJmCCjnG3CsXWVOXc5cK1DfssKyUAoElHEwXjwDzKWrUCW5Ti3kaM9x4g
LolscvTQOlXefsBbrRLx
=DTFV
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
